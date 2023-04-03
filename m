Received: from mail-4322.protonmail.ch (mail-4322.protonmail.ch [185.70.43.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FEF86FD3
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 15:45:14 +0000 (UTC)
Date: Mon, 03 Apr 2023 15:44:52 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1680536706; x=1680795906;
	bh=AMuWjkxzcUWLgTzTEeseuhGO2kwBxdlzp32Z0NPgb3A=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=LCb7eZzAfWAwgvOarVHmTDm5vr5yfQHAUeghhR5KVCaQnur2FFvHwZdWEtBHi50Un
	 dcyrHpibC0rLvx+GsAa5kQZalsG532NaskMn33A9RYyuRPyB5svWKxgzXEf/ZO4VIH
	 z4HMZb6I/P+Y+3jE1ofXaWgp4sYC8wJNI6KLehatHeDG8Ikxl/VE3eTnIQuAau9xpJ
	 STqZN7VkfE/o3fhAkxdS3CW1PgSEZqPeuYrqEvSHxqLF5S1kXaJtXqMgwPDi0lvczv
	 HGjLoDC5nbrA0Y6/mgmvaCubA0CozkW8Nc2Xi1mkvdsNzutswgPg/t0I+rY4W+lsC1
	 AeUg00+RtTyoA==
To: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho <wedsonaf@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, Alice Ryhl <alice@ryhl.io>
From: Benno Lossin <y86-dev@protonmail.com>
Cc: rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, patches@lists.linux.dev, Benno Lossin <y86-dev@protonmail.com>, Andreas Hindborg <a.hindborg@samsung.com>, Alice Ryhl <aliceryhl@google.com>
Subject: [PATCH v5 02/15] rust: macros: add `quote!` macro
Message-ID: <20230403154422.168633-3-y86-dev@protonmail.com>
In-Reply-To: <20230403154422.168633-1-y86-dev@protonmail.com>
References: <20230403154422.168633-1-y86-dev@protonmail.com>
Feedback-ID: 40624463:user:proton
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

From: Gary Guo <gary@garyguo.net>

Add the `quote!` macro for creating `TokenStream`s directly via the
given Rust tokens. It also supports repetitions using iterators.

It will be used by the pin-init API proc-macros to generate code.

Signed-off-by: Gary Guo <gary@garyguo.net>
Signed-off-by: Benno Lossin <y86-dev@protonmail.com>
Reviewed-by: Andreas Hindborg <a.hindborg@samsung.com>
Cc: Alice Ryhl <aliceryhl@google.com>
---
 rust/macros/lib.rs   |   2 +
 rust/macros/quote.rs | 145 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 147 insertions(+)
 create mode 100644 rust/macros/quote.rs

diff --git a/rust/macros/lib.rs b/rust/macros/lib.rs
index c1d385e345b9..82b520f024dd 100644
--- a/rust/macros/lib.rs
+++ b/rust/macros/lib.rs
@@ -2,6 +2,8 @@

 //! Crate for all kernel procedural macros.

+#[macro_use]
+mod quote;
 mod concat_idents;
 mod helpers;
 mod module;
diff --git a/rust/macros/quote.rs b/rust/macros/quote.rs
new file mode 100644
index 000000000000..94a6277182ee
--- /dev/null
+++ b/rust/macros/quote.rs
@@ -0,0 +1,145 @@
+// SPDX-License-Identifier: Apache-2.0 OR MIT
+
+use proc_macro::{TokenStream, TokenTree};
+
+pub(crate) trait ToTokens {
+    fn to_tokens(&self, tokens: &mut TokenStream);
+}
+
+impl<T: ToTokens> ToTokens for Option<T> {
+    fn to_tokens(&self, tokens: &mut TokenStream) {
+        if let Some(v) =3D self {
+            v.to_tokens(tokens);
+        }
+    }
+}
+
+impl ToTokens for proc_macro::Group {
+    fn to_tokens(&self, tokens: &mut TokenStream) {
+        tokens.extend([TokenTree::from(self.clone())]);
+    }
+}
+
+impl ToTokens for TokenTree {
+    fn to_tokens(&self, tokens: &mut TokenStream) {
+        tokens.extend([self.clone()]);
+    }
+}
+
+impl ToTokens for TokenStream {
+    fn to_tokens(&self, tokens: &mut TokenStream) {
+        tokens.extend(self.clone());
+    }
+}
+
+/// Converts tokens into [`proc_macro::TokenStream`] and performs variable=
 interpolations with
+/// the given span.
+///
+/// This is a similar to the
+/// [`quote_spanned!`](https://docs.rs/quote/latest/quote/macro.quote_span=
ned.html) macro from the
+/// `quote` crate but provides only just enough functionality needed by th=
e current `macros` crate.
+#[allow(unused_macros)]
+macro_rules! quote_spanned {
+    ($span:expr =3D> $($tt:tt)*) =3D> {
+    #[allow(clippy::vec_init_then_push)]
+    {
+        let mut tokens =3D ::std::vec::Vec::new();
+        let span =3D $span;
+        quote_spanned!(@proc tokens span $($tt)*);
+        ::proc_macro::TokenStream::from_iter(tokens)
+    }};
+    (@proc $v:ident $span:ident) =3D> {};
+    (@proc $v:ident $span:ident #$id:ident $($tt:tt)*) =3D> {
+        let mut ts =3D ::proc_macro::TokenStream::new();
+        $crate::quote::ToTokens::to_tokens(&$id, &mut ts);
+        $v.extend(ts);
+        quote_spanned!(@proc $v $span $($tt)*);
+    };
+    (@proc $v:ident $span:ident #(#$id:ident)* $($tt:tt)*) =3D> {
+        for token in $id {
+            let mut ts =3D ::proc_macro::TokenStream::new();
+            $crate::quote::ToTokens::to_tokens(&token, &mut ts);
+            $v.extend(ts);
+        }
+        quote_spanned!(@proc $v $span $($tt)*);
+    };
+    (@proc $v:ident $span:ident ( $($inner:tt)* ) $($tt:tt)*) =3D> {
+        let mut tokens =3D ::std::vec::Vec::new();
+        quote_spanned!(@proc tokens $span $($inner)*);
+        $v.push(::proc_macro::TokenTree::Group(::proc_macro::Group::new(
+            ::proc_macro::Delimiter::Parenthesis,
+            ::proc_macro::TokenStream::from_iter(tokens)
+        )));
+        quote_spanned!(@proc $v $span $($tt)*);
+    };
+    (@proc $v:ident $span:ident [ $($inner:tt)* ] $($tt:tt)*) =3D> {
+        let mut tokens =3D ::std::vec::Vec::new();
+        quote_spanned!(@proc tokens $span $($inner)*);
+        $v.push(::proc_macro::TokenTree::Group(::proc_macro::Group::new(
+            ::proc_macro::Delimiter::Bracket,
+            ::proc_macro::TokenStream::from_iter(tokens)
+        )));
+        quote_spanned!(@proc $v $span $($tt)*);
+    };
+    (@proc $v:ident $span:ident { $($inner:tt)* } $($tt:tt)*) =3D> {
+        let mut tokens =3D ::std::vec::Vec::new();
+        quote_spanned!(@proc tokens $span $($inner)*);
+        $v.push(::proc_macro::TokenTree::Group(::proc_macro::Group::new(
+            ::proc_macro::Delimiter::Brace,
+            ::proc_macro::TokenStream::from_iter(tokens)
+        )));
+        quote_spanned!(@proc $v $span $($tt)*);
+    };
+    (@proc $v:ident $span:ident :: $($tt:tt)*) =3D> {
+        $v.push(::proc_macro::TokenTree::Punct(
+                ::proc_macro::Punct::new(':', ::proc_macro::Spacing::Joint=
)
+        ));
+        $v.push(::proc_macro::TokenTree::Punct(
+                ::proc_macro::Punct::new(':', ::proc_macro::Spacing::Alone=
)
+        ));
+        quote_spanned!(@proc $v $span $($tt)*);
+    };
+    (@proc $v:ident $span:ident : $($tt:tt)*) =3D> {
+        $v.push(::proc_macro::TokenTree::Punct(
+                ::proc_macro::Punct::new(':', ::proc_macro::Spacing::Alone=
)
+        ));
+        quote_spanned!(@proc $v $span $($tt)*);
+    };
+    (@proc $v:ident $span:ident , $($tt:tt)*) =3D> {
+        $v.push(::proc_macro::TokenTree::Punct(
+                ::proc_macro::Punct::new(',', ::proc_macro::Spacing::Alone=
)
+        ));
+        quote_spanned!(@proc $v $span $($tt)*);
+    };
+    (@proc $v:ident $span:ident @ $($tt:tt)*) =3D> {
+        $v.push(::proc_macro::TokenTree::Punct(
+                ::proc_macro::Punct::new('@', ::proc_macro::Spacing::Alone=
)
+        ));
+        quote_spanned!(@proc $v $span $($tt)*);
+    };
+    (@proc $v:ident $span:ident ! $($tt:tt)*) =3D> {
+        $v.push(::proc_macro::TokenTree::Punct(
+                ::proc_macro::Punct::new('!', ::proc_macro::Spacing::Alone=
)
+        ));
+        quote_spanned!(@proc $v $span $($tt)*);
+    };
+    (@proc $v:ident $span:ident $id:ident $($tt:tt)*) =3D> {
+        $v.push(::proc_macro::TokenTree::Ident(::proc_macro::Ident::new(st=
ringify!($id), $span)));
+        quote_spanned!(@proc $v $span $($tt)*);
+    };
+}
+
+/// Converts tokens into [`proc_macro::TokenStream`] and performs variable=
 interpolations with
+/// mixed site span ([`Span::mixed_site()`]).
+///
+/// This is a similar to the [`quote!`](https://docs.rs/quote/latest/quote=
/macro.quote.html) macro
+/// from the `quote` crate but provides only just enough functionality nee=
ded by the current
+/// `macros` crate.
+///
+/// [`Span::mixed_site()`]: https://doc.rust-lang.org/proc_macro/struct.Sp=
an.html#method.mixed_site
+#[allow(unused_macros)]
+macro_rules! quote {
+    ($($tt:tt)*) =3D> {
+        quote_spanned!(::proc_macro::Span::mixed_site() =3D> $($tt)*)
+    }
+}
--
2.39.2


