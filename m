Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98B182F2D;
	Sat, 16 Nov 2024 18:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731780964; cv=none; b=OzDO9g4ZYw0iNPcHwZIZGna7Tj3eFUT+uIV5JpXvonCwcqPr9+vL77mdqujANvOe7aMFXZSNyzOLFjY5wk2FLnxSIuusaEu1Wt8UvA8DR3mZtQRgPW7OYZzJTm3dOv+eAjU/vFFZVL7YRw1/kwICQkzrEe1tUUAvEQOVzlCspUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731780964; c=relaxed/simple;
	bh=hp00ADXUMPrO5AFnJKlG+wHf5P6FWUNDJvSujqeDGTo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QGdWD9nT3bFnFUYc02qE805jrOj0a8p2jkILI7bQdRPB69gBwYvLoAROuEGWgVtQRkqCp6R7RgdOf87rFSlbSNEaHaaJSsyjWC5NxNwvRl4NoTPbZdobkJweZjLLs/hjBuzkLxZDIK9Xrdr+k23yyCBHkdB+dK5quRhs83UjWO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I/tOe8MG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I/tOe8MG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9354FC4CEC3;
	Sat, 16 Nov 2024 18:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731780964;
	bh=hp00ADXUMPrO5AFnJKlG+wHf5P6FWUNDJvSujqeDGTo=;
	h=From:To:Cc:Subject:Date:From;
	b=I/tOe8MGuPYGJK9WVSxbJ0NHHH1rVfDl4ykAZkmCBsWuH6ScTB46m1uqDvhFeVb59
	 d5AvuiKMQ/N4y4SrneERb1G1XC6N6eIvZYcd7Goi0xr+npsyM8VOdqQnnVxiO2AG34
	 Dpk9mIFR1iMeGvvMZwFRZuIdOIoaonpGggdO7io4m0qArfwDszCeJNhT2e20ghqnhU
	 7wqV+Wv/w8SRoIon0i1h1+aspgi9lgHweQJNKJIV8QBxrWtZ2iwj1UEtnYe5IpKXSH
	 YTop4ej2CFerywuvdmSg4imb7wepINOeF7WMV7SZWrN6uE8Aw9jG3yeZSjEnXrwmp9
	 S1KSv676S6kIQ==
From: Miguel Ojeda <ojeda@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Trevor Gross <tmgross@umich.edu>,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH] rust: allow `clippy::needless_lifetimes`
Date: Sat, 16 Nov 2024 19:15:37 +0100
Message-ID: <20241116181538.369355-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In beta Clippy (i.e. Rust 1.83.0), the `needless_lifetimes` lint has
been extended [1] to suggest eliding `impl` lifetimes, e.g.

    error: the following explicit lifetimes could be elided: 'a
    --> rust/kernel/list.rs:647:6
        |
    647 | impl<'a, T: ?Sized + ListItem<ID>, const ID: u64> FusedIterator for Iter<'a, T, ID> {}
        |      ^^                                                                  ^^
        |
        = help: for further information visit https://rust-lang.github.io/rust-clippy/master/index.html#needless_lifetimes
        = note: `-D clippy::needless-lifetimes` implied by `-D warnings`
        = help: to override `-D warnings` add `#[allow(clippy::needless_lifetimes)]`
    help: elide the lifetimes
        |
    647 - impl<'a, T: ?Sized + ListItem<ID>, const ID: u64> FusedIterator for Iter<'a, T, ID> {}
    647 + impl<T: ?Sized + ListItem<ID>, const ID: u64> FusedIterator for Iter<'_, T, ID> {}

A possibility would have been to clean them -- the RFC patch [2] did
this, while asking if we wanted these cleanups. There is an open issue
[3] in Clippy about being able to differentiate some of the new cases,
e.g. those that do not involve introducing `'_`. Thus it seems others
feel similarly.

Thus, for the time being, we decided to `allow` the lint.

Link: https://github.com/rust-lang/rust-clippy/pull/13286 [1]
Link: https://lore.kernel.org/rust-for-linux/20241012231300.397010-1-ojeda@kernel.org/ [2]
Link: https://github.com/rust-lang/rust-clippy/issues/13514 [3]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Makefile b/Makefile
index a9e723cb0596..00a444603fb1 100644
--- a/Makefile
+++ b/Makefile
@@ -456,6 +456,7 @@ export rust_common_flags := --edition=2021 \
 			    -Wclippy::mut_mut \
 			    -Wclippy::needless_bitwise_bool \
 			    -Wclippy::needless_continue \
+			    -Aclippy::needless_lifetimes \
 			    -Wclippy::no_mangle_with_rust_abi \
 			    -Wclippy::undocumented_unsafe_blocks \
 			    -Wclippy::unnecessary_safety_comment \

base-commit: b2603f8ac8217bc59f5c7f248ac248423b9b99cb
-- 
2.47.0

