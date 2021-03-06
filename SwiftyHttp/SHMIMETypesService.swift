import Foundation
#if os(iOS) || os(watchOS) || os(tvOS)
    import MobileCoreServices
#elseif os(OSX)
    import CoreServices
#endif

internal class SHMIMETypesService {
    
    static let shMimeType = SHMIMETypesService()
    
    static func sharedInstance() -> SHMIMETypesService {
        
        return shMimeType
    }
    
    internal func mimeTypeForURL(_ fileURL: URL) -> String {
        
        let pathExtension = fileURL.pathExtension
        return pathExtension == "" ? "application/octet-stream" : mimeTypeForPathExtension(pathExtension)
    }

    fileprivate func mimeTypeForPathExtension(_ pathExtension: String) -> String {
        
        guard
            let id = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension as CFString, nil)?.takeRetainedValue(),
            let contentType = UTTypeCopyPreferredTagWithClass(id, kUTTagClassMIMEType)?.takeRetainedValue()
            else {
                
            return "application/octet-stream"
        }
        
        return contentType as String
    }
}
