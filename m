Received: from mail-0201.mail-europe.com (mail-0201.mail-europe.com [51.77.79.158])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C693ED2
	for <patches@lists.linux.dev>; Mon, 24 Apr 2023 08:12:00 +0000 (UTC)
Date: Mon, 24 Apr 2023 08:11:33 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail; t=1682323903; x=1682583103;
	bh=9tXLJw7aS2XfS2d3gc4JfQ1c+axPiaqoVKfXWCkw42E=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=bf4SNBhMwTguIdAncVzh5qLxV1ZYWi5GolZ7vhl4PHQALjDS4AaYfZPVsJxi3p4Xy
	 J9c0TDW7wOHdvqGNedNTQfjXceAGYPKLW05jU0wRyPNiFDDJW5uDo1eVsOUag1aqkj
	 dzDynwvOS/V1XjvKh9Wvz/1PjZksRH24dtFWDY1KvqhbNtAisuGuzEmhYvZrqCA53v
	 59BuMDz2nIa3f41puY8UTwzFHvaMTBrIHbfP4W6q71ha+k477z6NSu9tcTXK3Uie0C
	 h8JsTD9qERL7wpGzDU7nSSHk8//0sM7gDHTiWgE4CT+VN4lF6+yTEj158C8QFJO6J1
	 fu/YtqWt9PCBw==
To: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho <wedsonaf@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>
From: Benno Lossin <benno.lossin@proton.me>
Cc: rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, patches@lists.linux.dev, Benno Lossin <benno.lossin@proton.me>
Subject: [PATCH 1/4] rust: macros: fix usage of `#[allow]` in `quote!`
Message-ID: <20230424081112.99890-1-benno.lossin@proton.me>
Feedback-ID: 71780778:user:proton
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

When using `quote!` as part of an expression that was not the last one
in a function, the `#[allow(clippy::vec_init_then_push)]` attribute
would be present on an expression, which is not allowed.
This patch refactors that part of the macro to use a statement instead.

Signed-off-by: Benno Lossin <benno.lossin@proton.me>
---
 rust/macros/quote.rs | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/rust/macros/quote.rs b/rust/macros/quote.rs
index c8e08b3c1e4c..dddbb4e6f4cb 100644
--- a/rust/macros/quote.rs
+++ b/rust/macros/quote.rs
@@ -39,12 +39,14 @@ impl ToTokens for TokenStream {
 /// [`quote_spanned!`](https://docs.rs/quote/latest/quote/macro.quote_span=
ned.html) macro from the
 /// `quote` crate but provides only just enough functionality needed by th=
e current `macros` crate.
 macro_rules! quote_spanned {
-    ($span:expr =3D> $($tt:tt)*) =3D> {
-    #[allow(clippy::vec_init_then_push)]
-    {
-        let mut tokens =3D ::std::vec::Vec::new();
-        let span =3D $span;
-        quote_spanned!(@proc tokens span $($tt)*);
+    ($span:expr =3D> $($tt:tt)*) =3D> {{
+        let mut tokens;
+        #[allow(clippy::vec_init_then_push)]
+        {
+            tokens =3D ::std::vec::Vec::new();
+            let span =3D $span;
+            quote_spanned!(@proc tokens span $($tt)*);
+        }
         ::proc_macro::TokenStream::from_iter(tokens)
     }};
     (@proc $v:ident $span:ident) =3D> {};

base-commit: ea76e08f4d901a450619831a255e9e0a4c0ed162
--
2.40.0


