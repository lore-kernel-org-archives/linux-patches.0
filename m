Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65AE518DB24;
	Mon, 10 Mar 2025 17:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627168; cv=none; b=R+opa5x0Fz+fstjO+Ba4xcaYTEUJXWSs5/ZmXWxS5kMowFvngYCtqU9BqP4F3j2/9rSo9pk1CWAfgquvjsmnBTuxPkqBB52h/HvVagd5cKNez9nOE1z7YA9KVvhTk9xODzmKbnXS+bHnYgPctuskXy9E64thQW/swWarJv6xNww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627168; c=relaxed/simple;
	bh=cyhA+hU10mw2Qidrp3YG2Xu6tp16SO8hRnkoxM2WcJg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EZ829S1qbERwYJJk0bHaVfF5rsssopuhb/GSxMIXYNcaLa6gTP+9MC5csIm2++48fRiN1Rt7ZLBIUY1VVR/7z70eJN4SrXgGcGFPUUCCbt6UOxkIyO/A7Scprvw+6WabjpQhGD6exqJpYeWm3X5dSfBxfK7wLfmAEfn15Jl5d6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oj83Q+Us; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oj83Q+Us"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81392C4CEE5;
	Mon, 10 Mar 2025 17:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627167;
	bh=cyhA+hU10mw2Qidrp3YG2Xu6tp16SO8hRnkoxM2WcJg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oj83Q+UsS6zQcqmp4iXDI7L0StP8nl62HKPpBaM2sFgl/md9EEH2ydPGf7SEsdQ36
	 mDACKpAKKUBmpCh/IyIj6Eys+txrE89FBTsT2gHFDw/GticUy+cjgZPowUJbIyDm2H
	 H4t4sts8ONjmO3KGDesZ7XGWhJ3xK+JYFvG9SMwE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benno Lossin <benno.lossin@proton.me>,
	Gary Guo <gary@garyguo.net>,
	Danilo Krummrich <dakr@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.12 036/269] rust: alloc: implement `Allocator` for `Kmalloc`
Date: Mon, 10 Mar 2025 18:03:09 +0100
Message-ID: <20250310170459.159391152@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/alloc/allocator.rs |   31 ++++++++++++++++++++++++++++---
 1 file changed, 28 insertions(+), 3 deletions(-)

--- a/rust/kernel/alloc/allocator.rs
+++ b/rust/kernel/alloc/allocator.rs
@@ -13,10 +13,16 @@ use core::alloc::{GlobalAlloc, Layout};
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
@@ -106,6 +114,23 @@ impl ReallocFunc {
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


