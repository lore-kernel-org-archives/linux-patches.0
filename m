Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AC7116EB70;
	Mon,  1 Jul 2024 18:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719859012; cv=none; b=U3l3g2gMpPwfvrPxDCHx+O6sreMHpDFUpv34GEnC0BQoVfZyIDkQUrgWJU8rL273VZfIdMKrkOS+OEMEmv1tPKlqGltTglU1TAWFIOzNaRqipA8fgJRj3CH4Am0xDegkiQqc+2resd9p4xVT/wpYo2OUdTHCMkiJ6+arjYLSXKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719859012; c=relaxed/simple;
	bh=SOK63W0QJpOINkA8Ojxb5qetkpfss2ghHjce0E/Esgo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UylO+4NWFlB2ENK9Dgqk5/sDR/AWUles5Uo5OIisW75tFIZrI8bLraiJc8rjwRGmhzSpR+9uWROyCkTg86ASduqXY2MSirr0L/6sHA6RimXpU5cfiJaFnLZWNbKXs0kKHKTxPHJ4vnUVgU/xNVFuBt6ANDX3C6yAyf6U1r2GZXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jqcRKtVN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jqcRKtVN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CFF0C32781;
	Mon,  1 Jul 2024 18:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719859011;
	bh=SOK63W0QJpOINkA8Ojxb5qetkpfss2ghHjce0E/Esgo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jqcRKtVNeTuF/TEorXQJmXc1UqPpGsiJP9Tv8gOzlvRgsgWu6nnUKCdp4Ph6m5shZ
	 JQb788OKCxsqpmHd70WR7BP1aqgNZCVbKN89yqDOavjzbZvciRk9UrnopcMrb3Vk5d
	 Lc5WZV5kv8TR4LYYAthhik74WmgehCEKe+680plKEd1TzfATWWoAPzha29lefWX2sN
	 zQZsbgMFh6Uua5YGA8Fha5fI/JdWiwdvTFXgeQ196QsgpWE5kgaLyGjtBQHM+YozmO
	 u3mjJYRJiCNVQ3QvkGGFwdIuQOizoVhpXGsshLUXT6MH7BZmYuiiZFiJW6BJT91G1c
	 SqsQpqzxMBsWw==
From: Miguel Ojeda <ojeda@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>,
	Wedson Almeida Filho <wedsonaf@gmail.com>,
	Alex Gaynor <alex.gaynor@gmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Andreas Hindborg <a.hindborg@samsung.com>,
	Alice Ryhl <aliceryhl@google.com>,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH 01/13] rust: macros: indent list item in `paste!`'s docs
Date: Mon,  1 Jul 2024 20:36:11 +0200
Message-ID: <20240701183625.665574-2-ojeda@kernel.org>
In-Reply-To: <20240701183625.665574-1-ojeda@kernel.org>
References: <20240701183625.665574-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A new style lint, `doc_lazy_continuation` [1], has been introduced in the
upcoming Rust 1.80 (currently in beta), which detects missing indentation
in code documentation.

We have one such case:

    error: doc list item missing indentation
    --> rust/macros/lib.rs:315:5
        |
    315 | /// default the span of the `[< >]` group is used.
        |     ^
        |
        = help: if this is supposed to be its own paragraph, add a blank line
        = help: for further information visit https://rust-lang.github.io/rust-clippy/master/index.html#doc_lazy_continuation
        = note: `-D clippy::doc-lazy-continuation` implied by `-D clippy::style`
        = help: to override `-D clippy::style` add `#[allow(clippy::doc_lazy_continuation)]`
    help: indent this line
        |
    315 | ///   default the span of the `[< >]` group is used.
        |     ++

While the rendering of the docs by `rustdoc` is not affected, we apply
this kind of indentation elsewhere since it looks better.

Thus clean it up.

Link: https://rust-lang.github.io/rust-clippy/master/index.html#/doc_lazy_continuation [1]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 rust/macros/lib.rs | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/rust/macros/lib.rs b/rust/macros/lib.rs
index 520eae5fd792..05d976b3c09a 100644
--- a/rust/macros/lib.rs
+++ b/rust/macros/lib.rs
@@ -312,7 +312,7 @@ pub fn pinned_drop(args: TokenStream, input: TokenStream) -> TokenStream {
 ///
 /// Currently supported modifiers are:
 /// * `span`: change the span of concatenated identifier to the span of the specified token. By
-/// default the span of the `[< >]` group is used.
+///   default the span of the `[< >]` group is used.
 /// * `lower`: change the identifier to lower case.
 /// * `upper`: change the identifier to upper case.
 ///
-- 
2.45.2

