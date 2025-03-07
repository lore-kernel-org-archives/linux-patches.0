Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E539118BC36;
	Fri,  7 Mar 2025 22:50:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741387845; cv=none; b=EoFJHN0R6FkEW3sxQPWU5MFRvtW1CH0ByZxiL2Wx62j7iI33xNW59Fuj9GjCjm4KRB31y11omCvGxvIOHAnn2518o01ZF2oJ1N7GiOHCu3HdFR/t0xr7GVKxyw1QBQkOHkvBmfeHXV/F0OBD2YbKUjdVTUql8cy3yGC3pVVf7ZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741387845; c=relaxed/simple;
	bh=kwbXS7Byvtkz5kvFMTdInqMMnvnM4iSy4ht9szfvSOk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JrxL7Zw2vHVHLGwsvYPFn6Ysa6b850u6bkGa/hMe6r50Q/HJHS4ZAIwLkTwKBXEAu++I3ZegiodkllNI7u+164GaOYjcupjHI06PamKaLFfUiLF1+P6eBwsHTtzVCpuQhCovmIBNWEHontJ8ssXfJq99LT+LTKQzP2jKCd+KPoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gNfz3eAy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gNfz3eAy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3673DC4CEE5;
	Fri,  7 Mar 2025 22:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741387844;
	bh=kwbXS7Byvtkz5kvFMTdInqMMnvnM4iSy4ht9szfvSOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gNfz3eAyFWc0RqtxXYjmSsE5XEPgSmqavZbkB2FZQLxe8ja7LDIX7FpDcqf7xGdni
	 ni9LD8nhU5kqZ8+8JFZX6STam2CF33zRahpnD3fyc3Z8ypPDfucCdWh9tPFz1bGR92
	 wVBtQyD3uY1y5nNwBWxdzHPQZp+WKbLXoELYfvjxzgmC0+pwnB36QSGxiQ6xccm3DW
	 zt3ZUvENtEVhjIe2Hmu9FZ3qxBvIPyjaZHPZVX00KdEyYqKeMHeAZqWHh7apvG97W1
	 pl+8KdVkMAknHx6leUGJglSmwOieIkSlSLHmvdzZPhD6JzoMJClWlDlMmJ8eRS07M7
	 V43fpg+3ykcnA==
From: Miguel Ojeda <ojeda@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	stable@vger.kernel.org
Cc: Danilo Krummrich <dakr@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Alyssa Ross <hi@alyssa.is>,
	NoisyCoil <noisycoil@disroot.org>,
	patches@lists.linux.dev,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.12.y 03/60] rust: types: avoid repetition in `{As,From}Bytes` impls
Date: Fri,  7 Mar 2025 23:49:10 +0100
Message-ID: <20250307225008.779961-4-ojeda@kernel.org>
In-Reply-To: <20250307225008.779961-1-ojeda@kernel.org>
References: <20250307225008.779961-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

commit 567cdff53e71de56ae67eaf4309db38778b7bcd3 upstream.

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

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Trevor Gross <tmgross@umich.edu>
Tested-by: Gary Guo <gary@garyguo.net>
Reviewed-by: Gary Guo <gary@garyguo.net>
Link: https://lore.kernel.org/r/20240904204347.168520-4-ojeda@kernel.org
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
2.48.1

