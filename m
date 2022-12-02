Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B51454C71
	for <patches@lists.linux.dev>; Fri,  2 Dec 2022 16:15:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A9DFC433D7;
	Fri,  2 Dec 2022 16:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1669997746;
	bh=N9xIU8sHH23NdLn+DWGLMxxQ8DUCPXG+6JF3lVqrUEQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EZbLtNCwmhU8xS2so2fhn2yZrtw7LGAKhWwFwbhyGNuK2aqoZ1goBxC0ZLststZ8g
	 wVOtwdwpFLaoppmzJW+U0VpyNfVLK9K/YuY4qO9pREd6xP8p41yaCE3ntnQ6oVVIyr
	 PK/VXlzRvAnyexkoD1Sf6GZprtRWZgwRs/GaiuNRxyyr8WoI2Wqq226GfazZirKivK
	 t9I0aCysJhq862FL544IS4n4d1CBfhU8LoNzDgPnXObzZC41iIPvUyPuo4Yk15ZhAy
	 YUmloqTzIeoOzFfXyUXScNRRMeSZIe6zKtLd3y+Nj8y4xFsjcblX+u6nrRUWYc5T72
	 Y2gMYyw/K1d3A==
From: ojeda@kernel.org
To: Miguel Ojeda <ojeda@kernel.org>,
	Wedson Almeida Filho <wedsonaf@gmail.com>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>
Cc: rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	=?UTF-8?q?Sergio=20Gonz=C3=A1lez=20Collado?= <sergio.collado@gmail.com>
Subject: [PATCH v2 06/28] rust: macros: add `#[vtable]` proc macro
Date: Fri,  2 Dec 2022 17:14:37 +0100
Message-Id: <20221202161502.385525-7-ojeda@kernel.org>
In-Reply-To: <20221202161502.385525-1-ojeda@kernel.org>
References: <20221202161502.385525-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Gary Guo <gary@garyguo.net>

This procedural macro attribute provides a simple way to declare
a trait with a set of operations that later users can partially
implement, providing compile-time `HAS_*` boolean associated
constants that indicate whether a particular operation was overridden.

This is useful as the Rust counterpart to structs like
`file_operations` where some pointers may be `NULL`, indicating
an operation is not provided.

For instance:

    #[vtable]
    trait Operations {
        fn read(...) -> Result<usize> {
            Err(EINVAL)
        }

        fn write(...) -> Result<usize> {
            Err(EINVAL)
        }
    }

    #[vtable]
    impl Operations for S {
        fn read(...) -> Result<usize> {
            ...
        }
    }

    assert_eq!(<S as Operations>::HAS_READ, true);
    assert_eq!(<S as Operations>::HAS_WRITE, false);

Signed-off-by: Gary Guo <gary@garyguo.net>
Reviewed-by: Sergio González Collado <sergio.collado@gmail.com>
[Reworded, adapted for upstream and applied latest changes]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 rust/kernel/prelude.rs |  2 +-
 rust/macros/lib.rs     | 52 +++++++++++++++++++++++
 rust/macros/vtable.rs  | 95 ++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 148 insertions(+), 1 deletion(-)
 create mode 100644 rust/macros/vtable.rs

diff --git a/rust/kernel/prelude.rs b/rust/kernel/prelude.rs
index 6a1c6b38327f..7c4c35bf3c66 100644
--- a/rust/kernel/prelude.rs
+++ b/rust/kernel/prelude.rs
@@ -15,7 +15,7 @@ pub use core::pin::Pin;
 
 pub use alloc::{boxed::Box, vec::Vec};
 
-pub use macros::module;
+pub use macros::{module, vtable};
 
 pub use super::{pr_alert, pr_crit, pr_debug, pr_emerg, pr_err, pr_info, pr_notice, pr_warn};
 
diff --git a/rust/macros/lib.rs b/rust/macros/lib.rs
index 15555e7ff487..e40caaf0a656 100644
--- a/rust/macros/lib.rs
+++ b/rust/macros/lib.rs
@@ -5,6 +5,7 @@
 mod concat_idents;
 mod helpers;
 mod module;
+mod vtable;
 
 use proc_macro::TokenStream;
 
@@ -72,6 +73,57 @@ pub fn module(ts: TokenStream) -> TokenStream {
     module::module(ts)
 }
 
+/// Declares or implements a vtable trait.
+///
+/// Linux's use of pure vtables is very close to Rust traits, but they differ
+/// in how unimplemented functions are represented. In Rust, traits can provide
+/// default implementation for all non-required methods (and the default
+/// implementation could just return `Error::EINVAL`); Linux typically use C
+/// `NULL` pointers to represent these functions.
+///
+/// This attribute is intended to close the gap. Traits can be declared and
+/// implemented with the `#[vtable]` attribute, and a `HAS_*` associated constant
+/// will be generated for each method in the trait, indicating if the implementor
+/// has overridden a method.
+///
+/// This attribute is not needed if all methods are required.
+///
+/// # Examples
+///
+/// ```ignore
+/// use kernel::prelude::*;
+///
+/// // Declares a `#[vtable]` trait
+/// #[vtable]
+/// pub trait Operations: Send + Sync + Sized {
+///     fn foo(&self) -> Result<()> {
+///         Err(EINVAL)
+///     }
+///
+///     fn bar(&self) -> Result<()> {
+///         Err(EINVAL)
+///     }
+/// }
+///
+/// struct Foo;
+///
+/// // Implements the `#[vtable]` trait
+/// #[vtable]
+/// impl Operations for Foo {
+///     fn foo(&self) -> Result<()> {
+/// #        Err(EINVAL)
+///         // ...
+///     }
+/// }
+///
+/// assert_eq!(<Foo as Operations>::HAS_FOO, true);
+/// assert_eq!(<Foo as Operations>::HAS_BAR, false);
+/// ```
+#[proc_macro_attribute]
+pub fn vtable(attr: TokenStream, ts: TokenStream) -> TokenStream {
+    vtable::vtable(attr, ts)
+}
+
 /// Concatenate two identifiers.
 ///
 /// This is useful in macros that need to declare or reference items with names
diff --git a/rust/macros/vtable.rs b/rust/macros/vtable.rs
new file mode 100644
index 000000000000..34d5e7fb5768
--- /dev/null
+++ b/rust/macros/vtable.rs
@@ -0,0 +1,95 @@
+// SPDX-License-Identifier: GPL-2.0
+
+use proc_macro::{Delimiter, Group, TokenStream, TokenTree};
+use std::collections::HashSet;
+use std::fmt::Write;
+
+pub(crate) fn vtable(_attr: TokenStream, ts: TokenStream) -> TokenStream {
+    let mut tokens: Vec<_> = ts.into_iter().collect();
+
+    // Scan for the `trait` or `impl` keyword.
+    let is_trait = tokens
+        .iter()
+        .find_map(|token| match token {
+            TokenTree::Ident(ident) => match ident.to_string().as_str() {
+                "trait" => Some(true),
+                "impl" => Some(false),
+                _ => None,
+            },
+            _ => None,
+        })
+        .expect("#[vtable] attribute should only be applied to trait or impl block");
+
+    // Retrieve the main body. The main body should be the last token tree.
+    let body = match tokens.pop() {
+        Some(TokenTree::Group(group)) if group.delimiter() == Delimiter::Brace => group,
+        _ => panic!("cannot locate main body of trait or impl block"),
+    };
+
+    let mut body_it = body.stream().into_iter();
+    let mut functions = Vec::new();
+    let mut consts = HashSet::new();
+    while let Some(token) = body_it.next() {
+        match token {
+            TokenTree::Ident(ident) if ident.to_string() == "fn" => {
+                let fn_name = match body_it.next() {
+                    Some(TokenTree::Ident(ident)) => ident.to_string(),
+                    // Possibly we've encountered a fn pointer type instead.
+                    _ => continue,
+                };
+                functions.push(fn_name);
+            }
+            TokenTree::Ident(ident) if ident.to_string() == "const" => {
+                let const_name = match body_it.next() {
+                    Some(TokenTree::Ident(ident)) => ident.to_string(),
+                    // Possibly we've encountered an inline const block instead.
+                    _ => continue,
+                };
+                consts.insert(const_name);
+            }
+            _ => (),
+        }
+    }
+
+    let mut const_items;
+    if is_trait {
+        const_items = "
+                /// A marker to prevent implementors from forgetting to use [`#[vtable]`](vtable)
+                /// attribute when implementing this trait.
+                const USE_VTABLE_ATTR: ();
+        "
+        .to_owned();
+
+        for f in functions {
+            let gen_const_name = format!("HAS_{}", f.to_uppercase());
+            // Skip if it's declared already -- this allows user override.
+            if consts.contains(&gen_const_name) {
+                continue;
+            }
+            // We don't know on the implementation-site whether a method is required or provided
+            // so we have to generate a const for all methods.
+            write!(
+                const_items,
+                "/// Indicates if the `{f}` method is overridden by the implementor.
+                const {gen_const_name}: bool = false;",
+            )
+            .unwrap();
+        }
+    } else {
+        const_items = "const USE_VTABLE_ATTR: () = ();".to_owned();
+
+        for f in functions {
+            let gen_const_name = format!("HAS_{}", f.to_uppercase());
+            if consts.contains(&gen_const_name) {
+                continue;
+            }
+            write!(const_items, "const {gen_const_name}: bool = true;").unwrap();
+        }
+    }
+
+    let new_body = vec![const_items.parse().unwrap(), body.stream()]
+        .into_iter()
+        .collect();
+    tokens.push(TokenTree::Group(Group::new(Delimiter::Brace, new_body)));
+    tokens.into_iter().collect()
+}
-- 
2.38.1

