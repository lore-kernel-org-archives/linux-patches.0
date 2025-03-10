Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D10522154C;
	Mon, 10 Mar 2025 17:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627194; cv=none; b=rV4L+/FChGMQtLHE7QFQQs5alaoe4Iw8k4HNwxW90senShIc+2WNTITeudhVgUmm4usHYvruTgOMfl4t4NbT3nqLHetv45Lx+bad9txdz7NeYEobyvU6047VSAay7+briSA5934NSuvnwPOO2BRzvlCUbWf/wu6VFBo06CyJGr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627194; c=relaxed/simple;
	bh=rmi9nFe6qi4klGi3hX6x2j+VmEINUm/exbL1+tixFmE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PcXxWXaRtO43fXyIc/PF/qT5g4xOpmD69/yZ7xpS6/nfASfgmuoqupczvyh6qzznK5hE0sAXruvB2Xx5uvQ9MNaFZUnmgRuGFk9fDpASbrr95Hby70hX05cjPabbZvF3qxZgvgNev0uLVTp0LDRQsMgJjO/sPpXxmcQIaj4fOPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hlur3Xx4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hlur3Xx4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76EC7C4CEE5;
	Mon, 10 Mar 2025 17:19:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627193;
	bh=rmi9nFe6qi4klGi3hX6x2j+VmEINUm/exbL1+tixFmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hlur3Xx4m5w4fuA7nBgekP8E5GXrceCkkvbbSf7OVTE1l+oj0dPZDuweYBsVqj1yo
	 /p99+TA6rpTBDVcUE/SubwvSJRZRMdSjYkPeDBhSJLOyimk5Y7ReyeV+1mkfwrEWiM
	 OYD6qKiHHyjVlGgYgGe6H2dSiQDBI0xn0smZAkEE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>,
	Trevor Gross <tmgross@umich.edu>,
	Gary Guo <gary@garyguo.net>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.12 014/269] rust: types: avoid repetition in `{As,From}Bytes` impls
Date: Mon, 10 Mar 2025 18:02:47 +0100
Message-ID: <20250310170458.274502082@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miguel Ojeda <ojeda@kernel.org>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/types.rs |   68 ++++++++++++++++++++++++++-------------------------
 1 file changed, 35 insertions(+), 33 deletions(-)

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
@@ -514,21 +515,22 @@ unsafe impl<T: FromBytes, const N: usize
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


