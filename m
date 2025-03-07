Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3C4520D503;
	Fri,  7 Mar 2025 22:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741387905; cv=none; b=D2OAXJ2EtOI7rL40uxL1V+Z839SKUBhf8TkdC8l/jxD/10ta/Tgz9x0XTHm8FrT/Vwx8cd9ng/avmlEKjpdp2n8YCteR/OcAcb4Dqk5qO5uooKNmvxFhORWN1ZhLsHcxPQMetUV0A9xv7BRQe1wJkTizhE01f0GcWV4ZcATFxS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741387905; c=relaxed/simple;
	bh=WBukgr0DSq8br+CEPb9i5jFwFmXFlMexsPASHfdLV3g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WcEjp9nS2ofC9fIX6clgGPtNy2KjzpTzYqDf84CTDGDNM5YAMHcSY8brDTFTN/Me9WiLuc+p2oOj//p7Stg24M24CDKWKhO9fEuzKWjk58PaDUwz+4oo811ZuiXwvMri+I3LHZGt4U3rVI8fnrAtkG+QQaE5Adu8rBzeBXXmNCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Vp4Nvtxp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Vp4Nvtxp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 040F1C4CEE5;
	Fri,  7 Mar 2025 22:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741387904;
	bh=WBukgr0DSq8br+CEPb9i5jFwFmXFlMexsPASHfdLV3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vp4Nvtxpsf9/oYXXg1UfLOUhXnlZaoh3j3duuxnt3Hp+97zoG9aZHu7OJRkXVo31L
	 j34CKQHTxpw5+PelSt2F0SluteGYAUOFpLIEFVzkdTq67539srKWUgI4HF0ZO0y1du
	 eFqZ5ysUxfREp1KnkTkjj+ghOK8TD7Lw3m/M5fpixKwEti6dzqNxpvtFsTcoJz1Ztc
	 b49x9MegZoOn7sy/duoUoAitpjyPQm4mb2jasBFm3gbOEtoZ+qW1L5NHLl6J0X1aS3
	 nG6ep2zvgFhbiTQ1NE6go2kfPLpUsXntGm6jafk5MSz+U+djZxx7tw77y970B/BYtA
	 xnPtYbe/pGtYg==
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
Subject: [PATCH 6.12.y 25/60] rust: alloc: implement `Allocator` for `Kmalloc`
Date: Fri,  7 Mar 2025 23:49:32 +0100
Message-ID: <20250307225008.779961-26-ojeda@kernel.org>
In-Reply-To: <20250307225008.779961-1-ojeda@kernel.org>
References: <20250307225008.779961-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Danilo Krummrich <dakr@kernel.org>

commit a34822d1c4c93085f635b922441a017bd7e959b0 upstream.

Implement `Allocator` for `Kmalloc`, the kernel's default allocator,
typically used for objects smaller than page size.

All memory allocations made with `Kmalloc` end up in `krealloc()`.

It serves as allocator for the subsequently introduced types `KBox` and
`KVec`.

Reviewed-by: Benno Lossin <benno.lossin@proton.me>
Reviewed-by: Gary Guo <gary@garyguo.net>
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Link: https://lore.kernel.org/r/20241004154149.93856-7-dakr@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 rust/kernel/alloc/allocator.rs | 31 ++++++++++++++++++++++++++++---
 1 file changed, 28 insertions(+), 3 deletions(-)

diff --git a/rust/kernel/alloc/allocator.rs b/rust/kernel/alloc/allocator.rs
index 9ed122401e8a..272c581e24a0 100644
--- a/rust/kernel/alloc/allocator.rs
+++ b/rust/kernel/alloc/allocator.rs
@@ -13,10 +13,16 @@
 use core::ptr;
 use core::ptr::NonNull;
 
-use crate::alloc::AllocError;
+use crate::alloc::{AllocError, Allocator};
 use crate::bindings;
 
-struct Kmalloc;
+/// The contiguous kernel allocator.
+///
+/// `Kmalloc` is typically used for physically contiguous allocations up to page size, but also
+/// supports larger allocations up to `bindings::KMALLOC_MAX_SIZE`, which is hardware specific.
+///
+/// For more details see [self].
+pub struct Kmalloc;
 
 /// Returns a proper size to alloc a new object aligned to `new_layout`'s alignment.
 fn aligned_size(new_layout: Layout) -> usize {
@@ -53,8 +59,10 @@ struct ReallocFunc(
     unsafe extern "C" fn(*const core::ffi::c_void, usize, u32) -> *mut core::ffi::c_void,
 );
 
-#[expect(dead_code)]
 impl ReallocFunc {
+    // INVARIANT: `krealloc` satisfies the type invariants.
+    const KREALLOC: Self = Self(bindings::krealloc);
+
     /// # Safety
     ///
     /// This method has the same safety requirements as [`Allocator::realloc`].
@@ -106,6 +114,23 @@ unsafe fn call(
     }
 }
 
+// SAFETY: `realloc` delegates to `ReallocFunc::call`, which guarantees that
+// - memory remains valid until it is explicitly freed,
+// - passing a pointer to a valid memory allocation is OK,
+// - `realloc` satisfies the guarantees, since `ReallocFunc::call` has the same.
+unsafe impl Allocator for Kmalloc {
+    #[inline]
+    unsafe fn realloc(
+        ptr: Option<NonNull<u8>>,
+        layout: Layout,
+        old_layout: Layout,
+        flags: Flags,
+    ) -> Result<NonNull<[u8]>, AllocError> {
+        // SAFETY: `ReallocFunc::call` has the same safety requirements as `Allocator::realloc`.
+        unsafe { ReallocFunc::KREALLOC.call(ptr, layout, old_layout, flags) }
+    }
+}
+
 // SAFETY: TODO.
 unsafe impl GlobalAlloc for Kmalloc {
     unsafe fn alloc(&self, layout: Layout) -> *mut u8 {
-- 
2.48.1

