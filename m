Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4DCE258CD6;
	Fri,  7 Mar 2025 22:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741387909; cv=none; b=UvmYSH6Res1HOJXVSk8yiOunayW1rjBZjBt/EFbvI37B9f8F/qpSvkTCJkFSTIvP7hBDc9pe/tSB2MwgNL9DWxowApZ+C2/jHHnO3Gz+BoYSh8AyhmTAIsvxlzVv6X9MqAVwOahceXZZfKRZbpvvx3IyB+xG8uwvMO1RKRNTpKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741387909; c=relaxed/simple;
	bh=QQFGSeAZ73dVTmlSggmrZRidVgx4iUgNI8dMdqntHik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G2B+36ZELYNtZwlK/WbNBg451MhK2ZGdnzrYToNEBqXFSknAW+8h7aL8YrBUgCdpc6gmOso+2Wnf2ogl7eylzMkVYbubjRYwAUch8/jLje1RMfl5iQSgo6uT87Mz52IKE4sEHFmmr3pDUtn6t8hS7dyo9ZFC5mEEMSeopTY/OVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a3Y1i65q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a3Y1i65q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D3ADC4CEE5;
	Fri,  7 Mar 2025 22:51:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741387909;
	bh=QQFGSeAZ73dVTmlSggmrZRidVgx4iUgNI8dMdqntHik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a3Y1i65q476W8vVdoDHb3GM2EYON4pyi+LgC4Zu6cFfe8kvs9ycy+w7qVM5Hv81YG
	 eVWQVxeTLtnc1OxMxEnj0vXIFAxHP3UJz8oeaHzgU8QzSI6tE9kF1UQg+1K05qhfnf
	 QoTCCjgvrO7LnkmHqGy9kGo5Dx/Rx+wJ4VL1B/svqvcAX3BSNbAYJbPb92VTuwXVEf
	 2a20l74NbOobIhDCCS4d7elBw6caEUP459nUvNFfXKHrscSiNZhsE32r8mrsVsmfwU
	 v9slfKe9MatSHo/4458lG/UqtqSLIW8bxHjADNFnvILUWUFimrZxFfMXd1wykA0KYG
	 dyB/6u5WBg0Pg==
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
Subject: [PATCH 6.12.y 27/60] rust: alloc: implement `Vmalloc` allocator
Date: Fri,  7 Mar 2025 23:49:34 +0100
Message-ID: <20250307225008.779961-28-ojeda@kernel.org>
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

commit 61c004781d6b928443052e7a6cf84b35d4f61401 upstream.

Implement `Allocator` for `Vmalloc`, the kernel's virtually contiguous
allocator, typically used for larger objects, (much) larger than page
size.

All memory allocations made with `Vmalloc` end up in `vrealloc()`.

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Benno Lossin <benno.lossin@proton.me>
Reviewed-by: Gary Guo <gary@garyguo.net>
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Link: https://lore.kernel.org/r/20241004154149.93856-9-dakr@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 rust/helpers/helpers.c              |  1 +
 rust/helpers/vmalloc.c              |  9 +++++++
 rust/kernel/alloc/allocator.rs      | 37 +++++++++++++++++++++++++++++
 rust/kernel/alloc/allocator_test.rs |  1 +
 4 files changed, 48 insertions(+)
 create mode 100644 rust/helpers/vmalloc.c

diff --git a/rust/helpers/helpers.c b/rust/helpers/helpers.c
index 30f40149f3a9..20a0c69d5cc7 100644
--- a/rust/helpers/helpers.c
+++ b/rust/helpers/helpers.c
@@ -22,5 +22,6 @@
 #include "spinlock.c"
 #include "task.c"
 #include "uaccess.c"
+#include "vmalloc.c"
 #include "wait.c"
 #include "workqueue.c"
diff --git a/rust/helpers/vmalloc.c b/rust/helpers/vmalloc.c
new file mode 100644
index 000000000000..80d34501bbc0
--- /dev/null
+++ b/rust/helpers/vmalloc.c
@@ -0,0 +1,9 @@
+// SPDX-License-Identifier: GPL-2.0
+
+#include <linux/vmalloc.h>
+
+void * __must_check __realloc_size(2)
+rust_helper_vrealloc(const void *p, size_t size, gfp_t flags)
+{
+	return vrealloc(p, size, flags);
+}
diff --git a/rust/kernel/alloc/allocator.rs b/rust/kernel/alloc/allocator.rs
index 272c581e24a0..ee4c828cbd58 100644
--- a/rust/kernel/alloc/allocator.rs
+++ b/rust/kernel/alloc/allocator.rs
@@ -15,6 +15,7 @@
 
 use crate::alloc::{AllocError, Allocator};
 use crate::bindings;
+use crate::pr_warn;
 
 /// The contiguous kernel allocator.
 ///
@@ -24,6 +25,15 @@
 /// For more details see [self].
 pub struct Kmalloc;
 
+/// The virtually contiguous kernel allocator.
+///
+/// `Vmalloc` allocates pages from the page level allocator and maps them into the contiguous kernel
+/// virtual space. It is typically used for large allocations. The memory allocated with this
+/// allocator is not physically contiguous.
+///
+/// For more details see [self].
+pub struct Vmalloc;
+
 /// Returns a proper size to alloc a new object aligned to `new_layout`'s alignment.
 fn aligned_size(new_layout: Layout) -> usize {
     // Customized layouts from `Layout::from_size_align()` can have size < align, so pad first.
@@ -63,6 +73,9 @@ impl ReallocFunc {
     // INVARIANT: `krealloc` satisfies the type invariants.
     const KREALLOC: Self = Self(bindings::krealloc);
 
+    // INVARIANT: `vrealloc` satisfies the type invariants.
+    const VREALLOC: Self = Self(bindings::vrealloc);
+
     /// # Safety
     ///
     /// This method has the same safety requirements as [`Allocator::realloc`].
@@ -168,6 +181,30 @@ unsafe fn alloc_zeroed(&self, layout: Layout) -> *mut u8 {
     }
 }
 
+// SAFETY: `realloc` delegates to `ReallocFunc::call`, which guarantees that
+// - memory remains valid until it is explicitly freed,
+// - passing a pointer to a valid memory allocation is OK,
+// - `realloc` satisfies the guarantees, since `ReallocFunc::call` has the same.
+unsafe impl Allocator for Vmalloc {
+    #[inline]
+    unsafe fn realloc(
+        ptr: Option<NonNull<u8>>,
+        layout: Layout,
+        old_layout: Layout,
+        flags: Flags,
+    ) -> Result<NonNull<[u8]>, AllocError> {
+        // TODO: Support alignments larger than PAGE_SIZE.
+        if layout.align() > bindings::PAGE_SIZE {
+            pr_warn!("Vmalloc does not support alignments larger than PAGE_SIZE yet.\n");
+            return Err(AllocError);
+        }
+
+        // SAFETY: If not `None`, `ptr` is guaranteed to point to valid memory, which was previously
+        // allocated with this `Allocator`.
+        unsafe { ReallocFunc::VREALLOC.call(ptr, layout, old_layout, flags) }
+    }
+}
+
 #[global_allocator]
 static ALLOCATOR: Kmalloc = Kmalloc;
 
diff --git a/rust/kernel/alloc/allocator_test.rs b/rust/kernel/alloc/allocator_test.rs
index c5d325506f0c..32a1450c4d39 100644
--- a/rust/kernel/alloc/allocator_test.rs
+++ b/rust/kernel/alloc/allocator_test.rs
@@ -7,6 +7,7 @@
 use core::ptr::NonNull;
 
 pub struct Kmalloc;
+pub type Vmalloc = Kmalloc;
 
 unsafe impl Allocator for Kmalloc {
     unsafe fn realloc(
-- 
2.48.1

