import SwiftUI
import SecretKit

struct SecretDetailView<SecretType: Secret>: View {

    @State var secret: SecretType
    let keyWriter = OpenSSHKeyWriter()

    var body: some View {
        Form {
            Section {
                GroupBox(label: Text("Fingerprint")) {
                    HStack {
                        Text(keyWriter.openSSHFingerprint(secret: secret))
                        Spacer()
                    }
                        .frame(minWidth: 150, maxWidth: .infinity)
                        .padding()
                }.onDrag {
                    return NSItemProvider(item: NSData(data: self.keyWriter.openSSHFingerprint(secret: self.secret).data(using: .utf8)!), typeIdentifier: kUTTypeUTF8PlainText as String)
                }
                Spacer()
                GroupBox(label: Text("Public Key")) {
                    Text(keyWriter.openSSHString(secret: secret))
                        .multilineTextAlignment(.leading)
                        .frame(minWidth: 150, maxWidth: .infinity, minHeight: 150)
                        .padding()
                }
                .onDrag {
                    return NSItemProvider(item: NSData(data: self.keyString.data(using: .utf8)!), typeIdentifier: kUTTypeUTF8PlainText as String)
                }
                .overlay(
                    Button(action: copy) {
                        Text("Copy")
                    }.padding(),
                    alignment: .bottomTrailing)

            }
        }.padding()
            .frame(minHeight: 150, maxHeight: .infinity)

    }

    var keyString: String {
        keyWriter.openSSHString(secret: secret)
    }

    func copy() {
        NSPasteboard.general.declareTypes([.string], owner: nil)
        NSPasteboard.general.setString(keyString, forType: .string)
    }


}