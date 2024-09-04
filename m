Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5041416F826;
	Wed,  4 Sep 2024 20:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725482693; cv=none; b=ViiEMDOaDmLrJ/KM+oKPc9QRIWiymGflP8cyJOXOQ46JW2S8FLxpZ7H53yyjUHqms23V+mgc+Wc1Yjys08BJXlvf5HYu8n0be4dUT+bnSaLriOI64gTYm6+ChmG6OP8Rsk5rzRhkdA8Yr84Pbg3k2sLN6g/GDPEBkhUyJ/wKaQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725482693; c=relaxed/simple;
	bh=BDCJg1BW/c/WNJP3GkIb+wNmN8ALfi+qN1JhvFLZ3EE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QazBtgOR/cLUWqttxkNkt8B36R3os/bRVhI1oDjMN4Oxfht1bsvc732O5JiQrjlitddDiCDYinoEuxM/cEPBuphYSr/jX1SXA1xpcF/YiLxkw6flaQZgujBAMEOg3ZD6ejYOAAtk82IMujEE+RRExxqsCk/IwWkIMnvBmGTbz7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HhkfSfof; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HhkfSfof"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3590C4CEC2;
	Wed,  4 Sep 2024 20:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725482692;
	bh=BDCJg1BW/c/WNJP3GkIb+wNmN8ALfi+qN1JhvFLZ3EE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HhkfSfofGKkQGfCIuBvNAxqs+wXC0cnrvgli+VSLQICP+daaSeemNQvOvAZsuhKYC
	 cGe47SWz3SVGkVVIlUoKHdyHg2ynfsKRXhQCP4ydBdLqgfAnRZNXZlgRhgHjtCILPM
	 4z7vkqbOwIzWVOdSvgKC7SLPuaNH5uUBjeTlMjYL2QquinvEYxtPtlxfDbW5gwRTLS
	 sjysBP1Y8z7Vo6IdIE4BGHBex5aTNB93hKAUL0eUVge50+ZWg5JZH+keGmb8V/RRgL
	 Aw8Fj92o7JM7+4xNLpXz+rMVwCk65AZqWZbd2MGsr8aQWczWgsk8W4YvVGUNMHeihJ
	 zHAPhVwuXlMgQ==
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
Subject: [PATCH 03/19] rust: types: avoid repetition in `{As,From}Bytes` impls
Date: Wed,  4 Sep 2024 22:43:31 +0200
Message-ID: <20240904204347.168520-4-ojeda@kernel.org>
In-Reply-To: <20240904204347.168520-1-ojeda@kernel.org>
References: <20240904204347.168520-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In order to provide `// SAFETY` comments for every `unsafe impl`, we would
need to repeat them, which is not very useful and would be harder to read.

We could perhaps allow the lint (ideally within a small module), but we
can take the chance to avoid the repetition of the `impl`s themselves
too by using a small local macro, like in other places where we have
had to do this sort of thing.

Thus add the straightforward `impl_{from,as}bytes!` macros and use them
to implement `FromBytes`.

This, in turn, will allow us in the next patch to place a `// SAFETY`
comment that defers to the actual invocation of the macro.

Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 rust/kernel/types.rs | 68 +++++++++++++++++++++++---------------------
 1 file changed, 35 insertions(+), 33 deletions(-)

diff --git a/rust/kernel/types.rs b/rust/kernel/types.rs
index 9e7ca066355c..70e173f15d87 100644
--- a/rust/kernel/types.rs
+++ b/rust/kernel/types.rs
@@ -481,21 +481,22 @@ pub enum Either<L, R> {
 /// All bit-patterns must be valid for this type. This type must not have interior mutability.
 pub unsafe trait FromBytes {}
 
-// SAFETY: All bit patterns are acceptable values of the types below.
-unsafe impl FromBytes for u8 {}
-unsafe impl FromBytes for u16 {}
-unsafe impl FromBytes for u32 {}
-unsafe impl FromBytes for u64 {}
-unsafe impl FromBytes for usize {}
-unsafe impl FromBytes for i8 {}
-unsafe impl FromBytes for i16 {}
-unsafe impl FromBytes for i32 {}
-unsafe impl FromBytes for i64 {}
-unsafe impl FromBytes for isize {}
-// SAFETY: If all bit patterns are acceptable for individual values in an array, then all bit
-// patterns are also acceptable for arrays of that type.
-unsafe impl<T: FromBytes> FromBytes for [T] {}
-unsafe impl<T: FromBytes, const N: usize> FromBytes for [T; N] {}
+macro_rules! impl_frombytes {
+    ($($({$($generics:tt)*})? $t:ty, )*) => {
+        $(unsafe impl$($($generics)*)? FromBytes for $t {})*
+    };
+}
+
+impl_frombytes! {
+    // SAFETY: All bit patterns are acceptable values of the types below.
+    u8, u16, u32, u64, usize,
+    i8, i16, i32, i64, isize,
+
+    // SAFETY: If all bit patterns are acceptable for individual values in an array, then all bit
+    // patterns are also acceptable for arrays of that type.
+    {<T: FromBytes>} [T],
+    {<T: FromBytes, const N: usize>} [T; N],
+}
 
 /// Types that can be viewed as an immutable slice of initialized bytes.
 ///
@@ -514,21 +515,22 @@ unsafe impl<T: FromBytes> FromBytes for [T] {}
 /// mutability.
 pub unsafe trait AsBytes {}
 
-// SAFETY: Instances of the following types have no uninitialized portions.
-unsafe impl AsBytes for u8 {}
-unsafe impl AsBytes for u16 {}
-unsafe impl AsBytes for u32 {}
-unsafe impl AsBytes for u64 {}
-unsafe impl AsBytes for usize {}
-unsafe impl AsBytes for i8 {}
-unsafe impl AsBytes for i16 {}
-unsafe impl AsBytes for i32 {}
-unsafe impl AsBytes for i64 {}
-unsafe impl AsBytes for isize {}
-unsafe impl AsBytes for bool {}
-unsafe impl AsBytes for char {}
-unsafe impl AsBytes for str {}
-// SAFETY: If individual values in an array have no uninitialized portions, then the array itself
-// does not have any uninitialized portions either.
-unsafe impl<T: AsBytes> AsBytes for [T] {}
-unsafe impl<T: AsBytes, const N: usize> AsBytes for [T; N] {}
+macro_rules! impl_asbytes {
+    ($($({$($generics:tt)*})? $t:ty, )*) => {
+        $(unsafe impl$($($generics)*)? AsBytes for $t {})*
+    };
+}
+
+impl_asbytes! {
+    // SAFETY: Instances of the following types have no uninitialized portions.
+    u8, u16, u32, u64, usize,
+    i8, i16, i32, i64, isize,
+    bool,
+    char,
+    str,
+
+    // SAFETY: If individual values in an array have no uninitialized portions, then the array
+    // itself does not have any uninitialized portions either.
+    {<T: AsBytes>} [T],
+    {<T: AsBytes, const N: usize>} [T; N],
+}
-- 
2.46.0

