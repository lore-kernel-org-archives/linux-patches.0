Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 085C219D88D;
	Tue,  9 Jul 2024 16:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720541190; cv=none; b=s8cshr6IhYpM9furjvdBDVwvEZXgGSVjnUJawwgAj0nXVvCv3mE7xPUbEh0aCDY03vRqEtzivHEdQhLp+4XRHOAX47opmWgF2bTQEo6NEMTvn+1qjPTINg506IlNSXxJcxVcEdIJf2gMG2oVgKpXl4RdTq1tK77R8JpsfE4CLog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720541190; c=relaxed/simple;
	bh=9mVsfzjap65UG7inNi/6ALDZA7jm3b4WyDRibLyQG7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NbvBgI6y9zRNUunxRuE36UnhDVBq6VPXDnobT1hMVkfTxEJ//e1/XSeGkld1xi0SShIu9ov8GPkqsnvYyeIxKgR73i3+yj05OOaCj4Olefik3eLOglHH+6W7wak5Ho5xfMIjGiNtjmuOaStjWo2hVVRVsLkqktJHAPJKCvb3kD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YuvNZQUQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YuvNZQUQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57026C3277B;
	Tue,  9 Jul 2024 16:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720541189;
	bh=9mVsfzjap65UG7inNi/6ALDZA7jm3b4WyDRibLyQG7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YuvNZQUQtQlMa5Rb3Bqqto2Q3ViuHBwi/rzZYVVeYlhFqn9t0RXD1QB25yqFYQSl9
	 1fQcO/jkoIepLZ5QnhE7SwKFTXLL9Ln3miLlyQqNOj78G99fT8xvJVEYfFJULJPtfL
	 loQl2tM0LIPPi2lnijHx5SJNNaeSgFInVy0xlygSQjh/cEWP2VQLJUIIIerYs/cMsx
	 Pm7OXIegDwPy04xeZXvD+VaAUNZuz0Z3N2H3dFgjs5uEIcYjCEM0um8L5V8Xd5g05G
	 g0+YIT8wwmp6XYvrIt0cmZ6ofOe+ThpY5MyyklVw1kblq9qCOTOe40yKCwmGs5z0pW
	 MEQLkR8RJTgRQ==
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
	patches@lists.linux.dev,
	Finn Behrens <me@kloenk.dev>
Subject: [PATCH v2 01/13] rust: macros: indent list item in `paste!`'s docs
Date: Tue,  9 Jul 2024 18:05:56 +0200
Message-ID: <20240709160615.998336-2-ojeda@kernel.org>
In-Reply-To: <20240709160615.998336-1-ojeda@kernel.org>
References: <20240709160615.998336-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
Reviewed-by: Björn Roy Baron <bjorn3_gh@protonmail.com>
Reviewed-by: Finn Behrens <me@kloenk.dev>
Tested-by: Benno Lossin <benno.lossin@proton.me>
Tested-by: Andreas Hindborg <a.hindborg@samsung.com>
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 rust/macros/lib.rs | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/rust/macros/lib.rs b/rust/macros/lib.rs
index 6dcc72aff111..159e75292970 100644
--- a/rust/macros/lib.rs
+++ b/rust/macros/lib.rs
@@ -345,7 +345,7 @@ pub fn pinned_drop(args: TokenStream, input: TokenStream) -> TokenStream {
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

