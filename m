Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D49D125A9;
	Sat, 16 Aug 2025 21:19:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755379149; cv=none; b=ceOh4pqRGsQ1QsA5K2Uo23VYiap3HOB88T7nzjrg4BdZKgHcDi0Brh2DsxPupvvnD0o4mMUX7yZI9opmgEpws70tDHwNmrjehXm1wawV7FLZC2gR7H6t03g5T+MzCZeNYDxE4V2VO66j/Y//6F//dTx7lWf4MkxFRQH8APKZwSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755379149; c=relaxed/simple;
	bh=YCuPdCymP0lupweJG5wenPZ1WcdDzT/yx2dP7aAEox8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gY9OExVw85juLuZXKqSwoakdPF7nH0psfDrYaAjTYyp2uTRS7v5kxUQuahe8c0+EDCDwqBTgP2zobzKzmfLrf9z8B9RwaRaXPt+vJg1WK0ucbQufcvWsQZ9FYTgcJJZz3PkYXFVw+ylxdHpFRYg8GsAkTaUL1+myPP8wfiycB/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pF9kwDEU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pF9kwDEU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30D79C4CEEF;
	Sat, 16 Aug 2025 21:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755379149;
	bh=YCuPdCymP0lupweJG5wenPZ1WcdDzT/yx2dP7aAEox8=;
	h=From:To:Cc:Subject:Date:From;
	b=pF9kwDEUNQ4689iLGJmxG92q3q/YoQ+QM7O1Y9TnL8rLi8HW5iU7WlGnRwC4ASW6C
	 L/dLiQKf5fTFT8WT1ALFJlgqwqCjASq18qSwbpBJJA6Z9VO9uOrPA2AQsPMoGrba8m
	 yE23u8D89rSkiB5/3w7tgVhldBS6JLaxvWSmsiEmzMCp/hhnSQ55Ata0YXVJUL5NzI
	 pW9/k91DDtw3MpQWe8cZjIm3dStKvx+y0Kj+W2qPYskWvaPdjATNEza853WLERN0tB
	 N8iR6KqJMUWo1otSQUwNjm8B5kHY/cg2v0SntGGGrnyG+R4ZqxB90ZaRFtoYwgNx8n
	 hiGWy/m6YExUA==
From: Miguel Ojeda <ojeda@kernel.org>
To: Danilo Krummrich <dakr@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	rust-for-linux@vger.kernel.org,
	Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Trevor Gross <tmgross@umich.edu>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH] rust: alloc: remove `allocator_test`
Date: Sat, 16 Aug 2025 23:19:00 +0200
Message-ID: <20250816211900.2731720-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Given we do not have tests that rely on it anymore, remove
`allocator_test`, which simplifies the complexity of the build.

In particular, it avoids potential issues with `rusttest`, such as the
one fixed at [1], where a public function was added to `Kmalloc` and
used elsewhere, but it was not added to `Cmalloc`; or trivial issues
like a missing import [2] due to not many people testing that target.

The only downside is that we cannot use it in the `macros`' crate
examples anymore, but we did not feel a need for that so far, and anyway
we could support that by running those within the kernel too, which we
may do regardless.

Link: https://lore.kernel.org/rust-for-linux/20250816204215.2719559-1-ojeda@kernel.org/ [1]
Link: https://lore.kernel.org/rust-for-linux/20250816210214.2729269-1-ojeda@kernel.org/ [2]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
This one goes on top of:

    https://lore.kernel.org/rust-for-linux/20250726180750.2735836-1-ojeda@kernel.org/

 rust/kernel/alloc.rs                |   7 --
 rust/kernel/alloc/allocator_test.rs | 113 ----------------------------
 2 files changed, 120 deletions(-)
 delete mode 100644 rust/kernel/alloc/allocator_test.rs

diff --git a/rust/kernel/alloc.rs b/rust/kernel/alloc.rs
index 335ae3271fa8..6a3d45a5eb24 100644
--- a/rust/kernel/alloc.rs
+++ b/rust/kernel/alloc.rs
@@ -2,18 +2,11 @@

 //! Implementation of the kernel's memory allocation infrastructure.

-#[cfg(not(testlib))]
 pub mod allocator;
 pub mod kbox;
 pub mod kvec;
 pub mod layout;

-#[cfg(testlib)]
-pub mod allocator_test;
-
-#[cfg(testlib)]
-pub use self::allocator_test as allocator;
-
 pub use self::kbox::Box;
 pub use self::kbox::KBox;
 pub use self::kbox::KVBox;
diff --git a/rust/kernel/alloc/allocator_test.rs b/rust/kernel/alloc/allocator_test.rs
deleted file mode 100644
index a3074480bd8d..000000000000
--- a/rust/kernel/alloc/allocator_test.rs
+++ /dev/null
@@ -1,113 +0,0 @@
-// SPDX-License-Identifier: GPL-2.0
-
-//! So far the kernel's `Box` and `Vec` types can't be used by userspace test cases, since all users
-//! of those types (e.g. `CString`) use kernel allocators for instantiation.
-//!
-//! In order to allow userspace test cases to make use of such types as well, implement the
-//! `Cmalloc` allocator within the `allocator_test` module and type alias all kernel allocators to
-//! `Cmalloc`. The `Cmalloc` allocator uses libc's `realloc()` function as allocator backend.
-
-#![allow(missing_docs)]
-
-use super::{flags::*, AllocError, Allocator, Flags};
-use core::alloc::Layout;
-use core::cmp;
-use core::ptr;
-use core::ptr::NonNull;
-
-/// The userspace allocator based on libc.
-pub struct Cmalloc;
-
-pub type Kmalloc = Cmalloc;
-pub type Vmalloc = Kmalloc;
-pub type KVmalloc = Kmalloc;
-
-extern "C" {
-    #[link_name = "aligned_alloc"]
-    fn libc_aligned_alloc(align: usize, size: usize) -> *mut crate::ffi::c_void;
-
-    #[link_name = "free"]
-    fn libc_free(ptr: *mut crate::ffi::c_void);
-}
-
-// SAFETY:
-// - memory remains valid until it is explicitly freed,
-// - passing a pointer to a valid memory allocation created by this `Allocator` is always OK,
-// - `realloc` provides the guarantees as provided in the `# Guarantees` section.
-unsafe impl Allocator for Cmalloc {
-    unsafe fn realloc(
-        ptr: Option<NonNull<u8>>,
-        layout: Layout,
-        old_layout: Layout,
-        flags: Flags,
-    ) -> Result<NonNull<[u8]>, AllocError> {
-        let src = match ptr {
-            Some(src) => {
-                if old_layout.size() == 0 {
-                    ptr::null_mut()
-                } else {
-                    src.as_ptr()
-                }
-            }
-            None => ptr::null_mut(),
-        };
-
-        if layout.size() == 0 {
-            // SAFETY: `src` is either NULL or was previously allocated with this `Allocator`
-            unsafe { libc_free(src.cast()) };
-
-            return Ok(NonNull::slice_from_raw_parts(
-                crate::alloc::dangling_from_layout(layout),
-                0,
-            ));
-        }
-
-        // ISO C (ISO/IEC 9899:2011) defines `aligned_alloc`:
-        //
-        // > The value of alignment shall be a valid alignment supported by the implementation
-        // [...].
-        //
-        // As an example of the "supported by the implementation" requirement, POSIX.1-2001 (IEEE
-        // 1003.1-2001) defines `posix_memalign`:
-        //
-        // > The value of alignment shall be a power of two multiple of sizeof (void *).
-        //
-        // and POSIX-based implementations of `aligned_alloc` inherit this requirement. At the time
-        // of writing, this is known to be the case on macOS (but not in glibc).
-        //
-        // Satisfy the stricter requirement to avoid spurious test failures on some platforms.
-        let min_align = core::mem::size_of::<*const crate::ffi::c_void>();
-        let layout = layout.align_to(min_align).map_err(|_| AllocError)?;
-        let layout = layout.pad_to_align();
-
-        // SAFETY: Returns either NULL or a pointer to a memory allocation that satisfies or
-        // exceeds the given size and alignment requirements.
-        let dst = unsafe { libc_aligned_alloc(layout.align(), layout.size()) }.cast::<u8>();
-        let dst = NonNull::new(dst).ok_or(AllocError)?;
-
-        if flags.contains(__GFP_ZERO) {
-            // SAFETY: The preceding calls to `libc_aligned_alloc` and `NonNull::new`
-            // guarantee that `dst` points to memory of at least `layout.size()` bytes.
-            unsafe { dst.as_ptr().write_bytes(0, layout.size()) };
-        }
-
-        if !src.is_null() {
-            // SAFETY:
-            // - `src` has previously been allocated with this `Allocator`; `dst` has just been
-            //   newly allocated, hence the memory regions do not overlap.
-            // - both` src` and `dst` are properly aligned and valid for reads and writes
-            unsafe {
-                ptr::copy_nonoverlapping(
-                    src,
-                    dst.as_ptr(),
-                    cmp::min(layout.size(), old_layout.size()),
-                )
-            };
-        }
-
-        // SAFETY: `src` is either NULL or was previously allocated with this `Allocator`
-        unsafe { libc_free(src.cast()) };
-
-        Ok(NonNull::slice_from_raw_parts(dst, layout.size()))
-    }
-}
--
2.50.1
