Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 567483EDE55;
	Tue, 12 May 2026 18:05:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609136; cv=none; b=fzdu0gTjSYH67jeCzzkWCDQCK9vyuNNXopL1uwBUezEktzAncbj2G6jVjVHNOHvKbfbnaZUYvyaMkPJXgAyvU81qBxYml9tQNc0PEtpysDgRyNsVKXNtUJaQ6f0tEnepBhgJZCOETgPd1+3xzS/Wbs+ClwNYK2U5qkyr8TysNf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609136; c=relaxed/simple;
	bh=0XAPkYQSYj722Ty3jKtlON2EFJ0TK/1a392RRX/+hM0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C2gMFqt2P+MU04w3yvSH2ctBQtaD8MJ+lHz1tL5PKzupdXiR1TymlG/KMCpxPGZrCqJJ7cOxUIiulwwri65BqWXD16X19dOZzUe9n2LwoWuwFhXfZWD6jly24pNlZC4P9Ajlyy+7Qvoh6MFyR9jLQT2rVhUD3gNJuVG5qwItupk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1zOYrSaM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1zOYrSaM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B66AAC2BCB0;
	Tue, 12 May 2026 18:05:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609136;
	bh=0XAPkYQSYj722Ty3jKtlON2EFJ0TK/1a392RRX/+hM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1zOYrSaMyrIcqi0HphmaZ8ihCF4OI+PuXyAbxFrrC3KeDgf8sjN7F7q6xxklW+zJA
	 lz4EUkocwJ7x+aXoWy95Xr2cYnVKrj5RueYkXTtjRjsbs561sYa0jmJTdE2DT+AL9o
	 Dtu/EftgQViQSXoWUQngxLWPfqbwSk1IEJLrYp0E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>,
	Gary Guo <gary@garyguo.net>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 7.0 080/307] rust: pin-init: internal: move alignment check to `make_field_check`
Date: Tue, 12 May 2026 19:37:55 +0200
Message-ID: <20260512173941.808964663@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gary Guo <gary@garyguo.net>

commit 83ac2870310b694775ab7e8f0244fdd94fc21926 upstream.

Instead of having the reference creation serving dual-purpose as both for
let bindings and alignment check, detangle them so that the alignment check
is done explicitly in `make_field_check`. This is more robust against
refactors that may change the way let bindings are created.

Cc: stable@vger.kernel.org
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Signed-off-by: Gary Guo <gary@garyguo.net>
Link: https://patch.msgid.link/20260427-pin-init-fix-v3-1-496a699674dd@garyguo.net
[ Reworded for typo. - Miguel ]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/pin-init/internal/src/init.rs |   78 +++++++++++++++++--------------------
 1 file changed, 37 insertions(+), 41 deletions(-)

--- a/rust/pin-init/internal/src/init.rs
+++ b/rust/pin-init/internal/src/init.rs
@@ -243,10 +243,6 @@ fn init_fields(
                 });
                 // Again span for better diagnostics
                 let write = quote_spanned!(ident.span()=> ::core::ptr::write);
-                // NOTE: the field accessor ensures that the initialized field is properly aligned.
-                // Unaligned fields will cause the compiler to emit E0793. We do not support
-                // unaligned fields since `Init::__init` requires an aligned pointer; the call to
-                // `ptr::write` below has the same requirement.
                 let accessor = if pinned {
                     let project_ident = format_ident!("__project_{ident}");
                     quote! {
@@ -361,49 +357,49 @@ fn init_fields(
     }
 }
 
-/// Generate the check for ensuring that every field has been initialized.
+/// Generate the check for ensuring that every field has been initialized and aligned.
 fn make_field_check(
     fields: &Punctuated<InitializerField, Token![,]>,
     init_kind: InitKind,
     path: &Path,
 ) -> TokenStream {
-    let field_attrs = fields
+    let field_attrs: Vec<_> = fields
         .iter()
-        .filter_map(|f| f.kind.ident().map(|_| &f.attrs));
-    let field_name = fields.iter().filter_map(|f| f.kind.ident());
-    match init_kind {
-        InitKind::Normal => quote! {
-            // We use unreachable code to ensure that all fields have been mentioned exactly once,
-            // this struct initializer will still be type-checked and complain with a very natural
-            // error message if a field is forgotten/mentioned more than once.
-            #[allow(unreachable_code, clippy::diverging_sub_expression)]
-            // SAFETY: this code is never executed.
-            let _ = || unsafe {
-                ::core::ptr::write(slot, #path {
-                    #(
-                        #(#field_attrs)*
-                        #field_name: ::core::panic!(),
-                    )*
-                })
-            };
-        },
-        InitKind::Zeroing => quote! {
-            // We use unreachable code to ensure that all fields have been mentioned at most once.
-            // Since the user specified `..Zeroable::zeroed()` at the end, all missing fields will
-            // be zeroed. This struct initializer will still be type-checked and complain with a
-            // very natural error message if a field is mentioned more than once, or doesn't exist.
-            #[allow(unreachable_code, clippy::diverging_sub_expression, unused_assignments)]
-            // SAFETY: this code is never executed.
-            let _ = || unsafe {
-                ::core::ptr::write(slot, #path {
-                    #(
-                        #(#field_attrs)*
-                        #field_name: ::core::panic!(),
-                    )*
-                    ..::core::mem::zeroed()
-                })
-            };
-        },
+        .filter_map(|f| f.kind.ident().map(|_| &f.attrs))
+        .collect();
+    let field_name: Vec<_> = fields.iter().filter_map(|f| f.kind.ident()).collect();
+    let zeroing_trailer = match init_kind {
+        InitKind::Normal => None,
+        InitKind::Zeroing => Some(quote! {
+            ..::core::mem::zeroed()
+        }),
+    };
+    quote! {
+        #[allow(unreachable_code, clippy::diverging_sub_expression)]
+        // We use unreachable code to perform field checks. They're still checked by the compiler.
+        // SAFETY: this code is never executed.
+        let _ = || unsafe {
+            // Create references to ensure that the initialized field is properly aligned.
+            // Unaligned fields will cause the compiler to emit E0793. We do not support
+            // unaligned fields since `Init::__init` requires an aligned pointer; the call to
+            // `ptr::write` for value-initialization case has the same requirement.
+            #(
+                #(#field_attrs)*
+                let _ = &(*slot).#field_name;
+            )*
+
+            // If the zeroing trailer is not present, this checks that all fields have been
+            // mentioned exactly once. If the zeroing trailer is present, all missing fields will be
+            // zeroed, so this checks that all fields have been mentioned at most once. The use of
+            // struct initializer will still generate very natural error messages for any misuse.
+            ::core::ptr::write(slot, #path {
+                #(
+                    #(#field_attrs)*
+                    #field_name: ::core::panic!(),
+                )*
+                #zeroing_trailer
+            })
+        };
     }
 }
 


