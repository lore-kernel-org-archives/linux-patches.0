Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73E82156678;
	Wed,  4 Sep 2024 20:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725482704; cv=none; b=lEK/mpV8X8Q2pefcxFJtrTcPWTInTRVS0PXYKrHSZ6aStlq2KmaCxSqwC7w65Ej20MY4CIq92sLYmxwLZUQTZ30ugfZlk20dKYCL7XwEQQKaZ22RXnSrM5qrTI0/LgkWPgW+XnTGDrvEIvfu1cWXiFS7ntKrs2eyNCHtfaTff6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725482704; c=relaxed/simple;
	bh=7iy+IlKbPFkwvYJYWxLR5kHiJlYjkMePAs9ibg/0adA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IRKuJZARwT357mPJy06pHnWvfVPLdQ2N70GZ0GeVjGPRz/wYZ41egCwYDG5uoBRDRJfVQzN02EtgMcRip4yz15zL/srcmVhWdYCnMHBTOM47wiCJDHEKNZgUv1aaEOtP6q4I/og3rGfEjUuxuNYDtEVIJQsceeZhfbom5CfdqO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q6jhst+5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q6jhst+5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC381C4CEC2;
	Wed,  4 Sep 2024 20:45:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725482704;
	bh=7iy+IlKbPFkwvYJYWxLR5kHiJlYjkMePAs9ibg/0adA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q6jhst+5qhRA2z0fr6p58F+mLJu+N/S6dPX8FdRzuPUzGjlnt5IqDqLpD15RmRS8S
	 HYBf7RBQ8M0ltDfGpIpjE8rjkX1zTe9XEduSkWkvvzDFEBtD8kFcWlBkzVM1P1Iedq
	 ADoquiN+IncIMWlusxrL96qz7CN/1LYXR5Je/dCb8TdFpIs/2X04ehXfjYFurLOBIx
	 7KhQ98bOJYIRVRCK3uFZHgVCpw3+XEiC3MKLbZQQ40/cdNnJSYfjZ6noW+3g0Rw5HU
	 DEp187Jm+rEGYk1NJ4sWKPRKa2gEFE7KMhZwIsubKD9Y+847xgav6GX8z5OPeho3KG
	 BO596oTTk5luw==
From: Miguel Ojeda <ojeda@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Wedson Almeida Filho <wedsonaf@gmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Andreas Hindborg <a.hindborg@samsung.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Trevor Gross <tmgross@umich.edu>,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH 06/19] rust: enable `clippy::unnecessary_safety_doc` lint
Date: Wed,  4 Sep 2024 22:43:34 +0200
Message-ID: <20240904204347.168520-7-ojeda@kernel.org>
In-Reply-To: <20240904204347.168520-1-ojeda@kernel.org>
References: <20240904204347.168520-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In Rust 1.67.0, Clippy added the `unnecessary_safety_doc` lint [1],
which is similar to `unnecessary_safety_comment`, but for `# Safety`
sections, i.e. safety preconditions in the documentation.

This is something that should not happen with our coding guidelines in
mind. Thus enable the lint to have it machine-checked.

Link: https://rust-lang.github.io/rust-clippy/master/index.html#/unnecessary_safety_doc [1]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Makefile b/Makefile
index 85f37ac9fef8..f903309db91b 100644
--- a/Makefile
+++ b/Makefile
@@ -458,6 +458,7 @@ export rust_common_flags := --edition=2021 \
 			    -Wclippy::no_mangle_with_rust_abi \
 			    -Wclippy::undocumented_unsafe_blocks \
 			    -Wclippy::unnecessary_safety_comment \
+			    -Wclippy::unnecessary_safety_doc \
 			    -Wrustdoc::missing_crate_level_docs
 
 KBUILD_HOSTCFLAGS   := $(KBUILD_USERHOSTCFLAGS) $(HOST_LFS_CFLAGS) \
-- 
2.46.0

