import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

class ImageCacheManager {
  Future<String> get _localPath async {
    final Directory directory = await getTemporaryDirectory();
    return directory.path;
  }

  Future<File> _localFile(String filename) async {
    final String path = await _localPath;

    return File(p.join(path, filename));
  }

  Future<Uint8List> getAssetFile(String filePath) async {
    final ByteData bytes = await rootBundle.load(filePath);
    return bytes.buffer.asUint8List();
  }

  String getFilename(String mediaId) {
    return 'thumbs/$mediaId';
  }

  Future<bool> isCached(String mediaId) async {
    final String filename = getFilename(mediaId);
    final File file = await _localFile(filename);
    print('$file');
    return file.existsSync();
  }

  Future<String> saveImage(String mediaId, Uint8List image) async {
    final String filename = getFilename(mediaId);
    final File file = await _localFile(filename);

    if (!file.parent.existsSync()) await file.parent.create(recursive: true);

    await file.writeAsBytes(image);
    return filename;
  }

  Future<Uint8List?> getImage(String mediaId) async {
    final String filename = getFilename(mediaId);
    final File file = await _localFile(filename);

    if (file.existsSync()) return await file.readAsBytes();
  }

  Future<String> getImagePath(String mediaId) async {
    final String filename = getFilename(mediaId);
    final File file = await _localFile(filename);

    return file.path;
  }
}
