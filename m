Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE69A20DD67;
	Fri,  7 Mar 2025 22:52:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741387956; cv=none; b=Ev63pLSlIShyp/UnBV/Jmr5WM6xcRk1ML1W5vL3Ds8vYZTOHM25+x1pRtO/z0A4tU5Tu19MRXqrWF6mlysVgVTUWU3YTAOX1dCP1s5sIBSRDDCwlXNokb3nVe5kqdwD1SmmB8xXRj+HdccA7uiEOqGzzjNUAIRPwywQgp8bP+c4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741387956; c=relaxed/simple;
	bh=sdjp1uyhOF0jVGvyXjgziv2UFXoFIS/gs2td7u/ciXQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=svRAC730vbLEJNoCmbcv66l3TYUgyWqbLSADqZx3YQ1xbm6OAFsa6Sepye7kHCxATCUmpghfCxUoeterhYfP1RTg6jVW+LHnIexr7v5LRKL9+YG/oiAL60hckciiCwZy2ac7vBzuLwzgGPfWXsJ71fwlNmhdeUkAyeqbTG7bG/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pZXFFnGO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pZXFFnGO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F3EFC4CEE3;
	Fri,  7 Mar 2025 22:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741387955;
	bh=sdjp1uyhOF0jVGvyXjgziv2UFXoFIS/gs2td7u/ciXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pZXFFnGO69Qxhre162AhPx0Q745F7drrLwyETmegSRfNejkpc5Q4lB2MPjUUQJ5eU
	 3NrzhMQ8LFruYKhtrqHeN3mWWzgIcvzRd/7IgK7kSsTmUu3i4BFTOu0x6Ip0Ty1R3L
	 kPdLH2GnjXtXK5Pk1Df8VWOsZWksosY5/crsksRX3/J0z/m59X7/DmdUrwGPmztofs
	 blaSyE+aOsI7MFLS2yBm8m+lGICV73wvrAlbgPBYc2qOnNFGwxCDgtVMnay4k1sqn1
	 TZxTa7vm8x0cyxkOtZ1TXwYzKq0MN5h9+wWe/Or9LFgkdTWWSsOk4Y38Zht6wCwhKn
	 fbyRDC2Gcseeg==
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
Subject: [PATCH 6.12.y 44/60] rust: alloc: implement `Cmalloc` in module allocator_test
Date: Fri,  7 Mar 2025 23:49:51 +0100
Message-ID: <20250307225008.779961-45-ojeda@kernel.org>
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

commit dd09538fb4093176a818fcecd45114430cc5840f upstream.

So far the kernel's `Box` and `Vec` types can't be used by userspace
test cases, since all users of those types (e.g. `CString`) use kernel
allocators for instantiation.

In order to allow userspace test cases to make use of such types as
well, implement the `Cmalloc` allocator within the allocator_test module
and type alias all kernel allocators to `Cmalloc`. The `Cmalloc`
allocator uses libc's `realloc()` function as allocator backend.

Reviewed-by: Benno Lossin <benno.lossin@proton.me>
Reviewed-by: Gary Guo <gary@garyguo.net>
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Link: https://lore.kernel.org/r/20241004154149.93856-26-dakr@kernel.org
[ Removed the temporary `allow(dead_code)` as discussed in the list and
  fixed typo, added backticks. - Miguel ]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 rust/kernel/alloc.rs                |  1 -
 rust/kernel/alloc/allocator_test.rs | 89 ++++++++++++++++++++++++++---
 2 files changed, 81 insertions(+), 9 deletions(-)

diff --git a/rust/kernel/alloc.rs b/rust/kernel/alloc.rs
index 049fca7a514d..c6024afa3739 100644
--- a/rust/kernel/alloc.rs
+++ b/rust/kernel/alloc.rs
@@ -215,7 +215,6 @@ unsafe fn free(ptr: NonNull<u8>, layout: Layout) {
     }
 }
 
-#[allow(dead_code)]
 /// Returns a properly aligned dangling pointer from the given `layout`.
 pub(crate) fn dangling_from_layout(layout: Layout) -> NonNull<u8> {
     let ptr = layout.align() as *mut u8;
diff --git a/rust/kernel/alloc/allocator_test.rs b/rust/kernel/alloc/allocator_test.rs
index bd0cbcd93e52..54ca85964d4a 100644
--- a/rust/kernel/alloc/allocator_test.rs
+++ b/rust/kernel/alloc/allocator_test.rs
@@ -1,22 +1,95 @@
 // SPDX-License-Identifier: GPL-2.0
 
+//! So far the kernel's `Box` and `Vec` types can't be used by userspace test cases, since all users
+//! of those types (e.g. `CString`) use kernel allocators for instantiation.
+//!
+//! In order to allow userspace test cases to make use of such types as well, implement the
+//! `Cmalloc` allocator within the allocator_test module and type alias all kernel allocators to
+//! `Cmalloc`. The `Cmalloc` allocator uses libc's `realloc()` function as allocator backend.
+
 #![allow(missing_docs)]
 
-use super::{AllocError, Allocator, Flags};
+use super::{flags::*, AllocError, Allocator, Flags};
 use core::alloc::Layout;
+use core::cmp;
+use core::ptr;
 use core::ptr::NonNull;
 
-pub struct Kmalloc;
+/// The userspace allocator based on libc.
+pub struct Cmalloc;
+
+pub type Kmalloc = Cmalloc;
 pub type Vmalloc = Kmalloc;
 pub type KVmalloc = Kmalloc;
 
-unsafe impl Allocator for Kmalloc {
+extern "C" {
+    #[link_name = "aligned_alloc"]
+    fn libc_aligned_alloc(align: usize, size: usize) -> *mut core::ffi::c_void;
+
+    #[link_name = "free"]
+    fn libc_free(ptr: *mut core::ffi::c_void);
+}
+
+// SAFETY:
+// - memory remains valid until it is explicitly freed,
+// - passing a pointer to a valid memory allocation created by this `Allocator` is always OK,
+// - `realloc` provides the guarantees as provided in the `# Guarantees` section.
+unsafe impl Allocator for Cmalloc {
     unsafe fn realloc(
-        _ptr: Option<NonNull<u8>>,
-        _layout: Layout,
-        _old_layout: Layout,
-        _flags: Flags,
+        ptr: Option<NonNull<u8>>,
+        layout: Layout,
+        old_layout: Layout,
+        flags: Flags,
     ) -> Result<NonNull<[u8]>, AllocError> {
-        panic!();
+        let src = match ptr {
+            Some(src) => {
+                if old_layout.size() == 0 {
+                    ptr::null_mut()
+                } else {
+                    src.as_ptr()
+                }
+            }
+            None => ptr::null_mut(),
+        };
+
+        if layout.size() == 0 {
+            // SAFETY: `src` is either NULL or was previously allocated with this `Allocator`
+            unsafe { libc_free(src.cast()) };
+
+            return Ok(NonNull::slice_from_raw_parts(
+                crate::alloc::dangling_from_layout(layout),
+                0,
+            ));
+        }
+
+        // SAFETY: Returns either NULL or a pointer to a memory allocation that satisfies or
+        // exceeds the given size and alignment requirements.
+        let dst = unsafe { libc_aligned_alloc(layout.align(), layout.size()) } as *mut u8;
+        let dst = NonNull::new(dst).ok_or(AllocError)?;
+
+        if flags.contains(__GFP_ZERO) {
+            // SAFETY: The preceding calls to `libc_aligned_alloc` and `NonNull::new`
+            // guarantee that `dst` points to memory of at least `layout.size()` bytes.
+            unsafe { dst.as_ptr().write_bytes(0, layout.size()) };
+        }
+
+        if !src.is_null() {
+            // SAFETY:
+            // - `src` has previously been allocated with this `Allocator`; `dst` has just been
+            //   newly allocated, hence the memory regions do not overlap.
+            // - both` src` and `dst` are properly aligned and valid for reads and writes
+            unsafe {
+                ptr::copy_nonoverlapping(
+                    src,
+                    dst.as_ptr(),
+                    cmp::min(layout.size(), old_layout.size()),
+                )
+            };
+        }
+
+        // SAFETY: `src` is either NULL or was previously allocated with this `Allocator`
+        unsafe { libc_free(src.cast()) };
+
+        Ok(NonNull::slice_from_raw_parts(dst, layout.size()))
     }
 }
-- 
2.48.1

