Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53F112566;
	Mon, 13 Oct 2025 00:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760314478; cv=none; b=o+/3xKJgDUPPA/Cy3fHQq7+YXIXbMgPUFpvkYbbf3xeVJqY3t98c47bL5eIok5C2VKK7zaBEGTMwaqHCPspqW/yBtcD8xNGbTRFt5oIxuY66vxJ3YMb2qs1FKJIQf2VUlVzT49dZKKUESyHr7p+Fn0CcatNFBcUGqpRbiY/JHIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760314478; c=relaxed/simple;
	bh=FjAXHZ+MbGBGWo6/zQ47+tjI8pX/9RPwwwUIErKcHq4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=XngjDR2gfYavXBUhrSUmh6UubtXR/be79eWqoWbYpcEEW9hh964iGpSpc74L2YUWfwOsfRQXKeIs3gDBQlueE/4xYhwUhjF/8lQXbjBzchUV245gRpSs6DPlKKYj4zhJ7vgjv2Bf6Pq+1exdwhLFPmZ+vRGG1kAwNS7bRI7QsHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Gl19GJWA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Gl19GJWA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 744DBC4CEE7;
	Mon, 13 Oct 2025 00:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760314477;
	bh=FjAXHZ+MbGBGWo6/zQ47+tjI8pX/9RPwwwUIErKcHq4=;
	h=From:To:Cc:Subject:Date:From;
	b=Gl19GJWAH37jbiTuqrJKKDMfarGJoT7wQcadgU1Ompu3yfwh7Pw9nkgYBVqn4X2AV
	 FMbd7f5LEdtMlkzJycF3xgCqxQO2vZMGdteiiqcfnz49FiQUut9YntJmZVOCLIAWCn
	 +aY8O+Gro4QZsLNAXeu/i1uWZPXTA9tXncJ7iYATA9MQpY2JCS4+Pos558VBfxqU02
	 m+w/KO/NsI6YNSPS6yVRELGQxQfZON7gWiYcVFoe4Efw3kig00HE7ekH9U9/N3bDu6
	 Fcfps1LTTkTpAU5F1P5C2E8Up9ipeGkicWO4Bg4/wlP4cg63snP3292pSGLmdaPz8n
	 IvHa91PV1X8yg==
From: Miguel Ojeda <ojeda@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Burak Emir <bqe@google.com>
Cc: Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	rust-for-linux@vger.kernel.org,
	Yury Norov <yury.norov@gmail.com>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH] rust: bitmap: clean Rust 1.92.0 `unused_unsafe` warning
Date: Mon, 13 Oct 2025 02:14:22 +0200
Message-ID: <20251013001422.1168581-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Starting with Rust 1.92.0 (expected 2025-12-11), Rust allows to safely
take the address of a union field [1][2]:

      CLIPPY L rust/kernel.o
    error: unnecessary `unsafe` block
       --> rust/kernel/bitmap.rs:169:13
        |
    169 |             unsafe { core::ptr::addr_of!(self.repr.bitmap) }
        |             ^^^^^^ unnecessary `unsafe` block
        |
        = note: `-D unused-unsafe` implied by `-D warnings`
        = help: to override `-D warnings` add `#[allow(unused_unsafe)]`

    error: unnecessary `unsafe` block
       --> rust/kernel/bitmap.rs:185:13
        |
    185 |             unsafe { core::ptr::addr_of_mut!(self.repr.bitmap) }
        |             ^^^^^^ unnecessary `unsafe` block

Thus allow both instances to clean the warning in newer compilers.

Link: https://github.com/rust-lang/rust/issues/141264 [1]
Link: https://github.com/rust-lang/rust/pull/141469 [2]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 rust/kernel/bitmap.rs | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/rust/kernel/bitmap.rs b/rust/kernel/bitmap.rs
index f45915694454..711b8368b38f 100644
--- a/rust/kernel/bitmap.rs
+++ b/rust/kernel/bitmap.rs
@@ -166,6 +166,7 @@ impl core::ops::Deref for BitmapVec {
     fn deref(&self) -> &Bitmap {
         let ptr = if self.nbits <= BITS_PER_LONG {
             // SAFETY: Bitmap is represented inline.
+            #[allow(unused_unsafe, reason = "Safe since Rust 1.92.0")]
             unsafe { core::ptr::addr_of!(self.repr.bitmap) }
         } else {
             // SAFETY: Bitmap is represented as array of `unsigned long`.
@@ -182,6 +183,7 @@ impl core::ops::DerefMut for BitmapVec {
     fn deref_mut(&mut self) -> &mut Bitmap {
         let ptr = if self.nbits <= BITS_PER_LONG {
             // SAFETY: Bitmap is represented inline.
+            #[allow(unused_unsafe, reason = "Safe since Rust 1.92.0")]
             unsafe { core::ptr::addr_of_mut!(self.repr.bitmap) }
         } else {
             // SAFETY: Bitmap is represented as array of `unsigned long`.

base-commit: 3a8660878839faadb4f1a6dd72c3179c1df56787
-- 
2.51.0

