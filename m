Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDD3E22D799;
	Mon, 10 Mar 2025 17:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627219; cv=none; b=ekF49CFbiouvtgBPIyLSzx365f+cRUh9dRQ/zKe9Lb7eE/t4IUu2hOr56j6lHXsl+Ey+zeFmh0DiA6CjK+JfmKHSiyzbM9bf8Myb/PjP/dNZPhZmVosHRTNT3lXCUU9ZvF9VRjP2c3f8TwWJsQJXBsUhkxvbiKtSmiwiwo4kFug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627219; c=relaxed/simple;
	bh=Az+FMyBW7t3jKDAdsXA1zkCjUAOaonFd2qyLRo//7Ec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Itu35Bdtdtgoa6M1ukbF5RuT7CBdf/ApV2QideojHuue6Ln876z7rX8kBZ5sxSw55jK7VQhBJu5WRykf9HNniNXZgAO6meqDP4sOOYu0prR7ZC3IGZzxQHlauTDs9ADx2YlOueEvGHkk7erbPFd5RuR4UyJtss1hvfkEf0yWEHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yxk57lcE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yxk57lcE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41EEAC4CEED;
	Mon, 10 Mar 2025 17:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627219;
	bh=Az+FMyBW7t3jKDAdsXA1zkCjUAOaonFd2qyLRo//7Ec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yxk57lcEhhO6J8YuWEE2j+4rS94sdWz66raKjXgnbZ7jVJ0CIcex5+/0dOftXCd4y
	 I8oZE9bFH2wQvZrZRM4mcWGjWRfJDuYtp1VdX7k9rwAVkIdzKnONilEdUKEDGY/a+h
	 qrN+R3nvMqEAG9zAgyzzvU/ZCMrKlIZNiGeumj6Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benno Lossin <benno.lossin@proton.me>,
	Gary Guo <gary@garyguo.net>,
	Danilo Krummrich <dakr@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.12 055/269] rust: alloc: implement `Cmalloc` in module allocator_test
Date: Mon, 10 Mar 2025 18:03:28 +0100
Message-ID: <20250310170459.920061927@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/alloc.rs                |    1 
 rust/kernel/alloc/allocator_test.rs |   89 ++++++++++++++++++++++++++++++++----
 2 files changed, 81 insertions(+), 9 deletions(-)

--- a/rust/kernel/alloc.rs
+++ b/rust/kernel/alloc.rs
@@ -215,7 +215,6 @@ pub unsafe trait Allocator {
     }
 }
 
-#[allow(dead_code)]
 /// Returns a properly aligned dangling pointer from the given `layout`.
 pub(crate) fn dangling_from_layout(layout: Layout) -> NonNull<u8> {
     let ptr = layout.align() as *mut u8;
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


