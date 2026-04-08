Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15879337B81;
	Wed,  8 Apr 2026 18:56:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674606; cv=none; b=XwFr+6JZ/ugKwKKt6dA3+DEIZt92wMmQYo3JzhWPV/Cp8nsGZ8Y6+MsZ4ZxxsqMotxQxFndH9KEjHkBkOwEir4jV7UxHHFQcKOAtQ6AtWUlkntP19gmBcuF4dZ1kOHrD6KmX8XKgeK4+TFXw89srvUrpzcTag+zc9B2BVqSrFl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674606; c=relaxed/simple;
	bh=p4f0whCxeGdRWVJChINmIOUFMbJRzIdgyTuyZbXH9Qw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pBwhrkNZ01/oATyS1bwTpeMtX9QcIQ+kwP9UEg+ddv5D+HdTx6ESXdlUZPLwtVR92Z6b8PlTK+uZFoSK+4ttp9gUesl1ANTBLUoi6Pj5XyIaRHMY9RvVm/+AurGLFggE3BdOkIZ+bv3Bzq+3sf9vMklg0tLx8SVbUWmP7SMuglU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d7fL+lyq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d7fL+lyq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0522CC19421;
	Wed,  8 Apr 2026 18:56:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674605;
	bh=p4f0whCxeGdRWVJChINmIOUFMbJRzIdgyTuyZbXH9Qw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d7fL+lyqaaVicH48MgXzDkWdXJDg63sme9FcU06lZb/mQTi1RZvhI5old4olZ32t1
	 xKOID1GJLSF4kRVubsx/DBSua4aKVSIJCpkICOSm41i7NI6Gk3OsGvSa184XXPv3m9
	 i/YpyRUmvp1eMvg7MJy1k8A7MlSJqqbPonL4Wgh4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	kernel test robot <lkp@intel.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Gary Guo <gary@garyguo.net>
Subject: [PATCH 6.19 162/311] rust_binder: use AssertSync for BINDER_VM_OPS
Date: Wed,  8 Apr 2026 20:02:42 +0200
Message-ID: <20260408175945.452868275@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alice Ryhl <aliceryhl@google.com>

commit ec327abae5edd1d5b60ea9f920212970133171d2 upstream.

When declaring an immutable global variable in Rust, the compiler checks
that it looks thread safe, because it is generally safe to access said
global variable. When using C bindings types for these globals, we don't
really want this check, because it is conservative and assumes pointers
are not thread safe.

In the case of BINDER_VM_OPS, this is a challenge when combined with the
patch 'userfaultfd: introduce vm_uffd_ops' [1], which introduces a
pointer field to vm_operations_struct. It previously only held function
pointers, which are considered thread safe.

Rust Binder should not be assuming that vm_operations_struct contains no
pointer fields, so to fix this, use AssertSync (which Rust Binder has
already declared for another similar global of type struct
file_operations with the same problem). This ensures that even if
another commit adds a pointer field to vm_operations_struct, this does
not cause problems.

Fixes: 8ef2c15aeae0 ("rust_binder: check ownership before using vma")
Cc: stable <stable@kernel.org>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202603121235.tpnRxFKO-lkp@intel.com/
Link: https://lore.kernel.org/r/20260306171815.3160826-8-rppt@kernel.org [1]
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Gary Guo <gary@garyguo.net>
Link: https://patch.msgid.link/20260314111951.4139029-1-aliceryhl@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/android/binder/page_range.rs       |    8 +++++---
 drivers/android/binder/rust_binder_main.rs |    2 +-
 2 files changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/android/binder/page_range.rs
+++ b/drivers/android/binder/page_range.rs
@@ -13,6 +13,8 @@
 //
 // The shrinker will use trylock methods because it locks them in a different order.
 
+use crate::AssertSync;
+
 use core::{
     marker::PhantomPinned,
     mem::{size_of, size_of_val, MaybeUninit},
@@ -143,14 +145,14 @@ pub(crate) struct ShrinkablePageRange {
 }
 
 // We do not define any ops. For now, used only to check identity of vmas.
-static BINDER_VM_OPS: bindings::vm_operations_struct = pin_init::zeroed();
+static BINDER_VM_OPS: AssertSync<bindings::vm_operations_struct> = AssertSync(pin_init::zeroed());
 
 // To ensure that we do not accidentally install pages into or zap pages from the wrong vma, we
 // check its vm_ops and private data before using it.
 fn check_vma(vma: &virt::VmaRef, owner: *const ShrinkablePageRange) -> Option<&virt::VmaMixedMap> {
     // SAFETY: Just reading the vm_ops pointer of any active vma is safe.
     let vm_ops = unsafe { (*vma.as_ptr()).vm_ops };
-    if !ptr::eq(vm_ops, &BINDER_VM_OPS) {
+    if !ptr::eq(vm_ops, &BINDER_VM_OPS.0) {
         return None;
     }
 
@@ -342,7 +344,7 @@ impl ShrinkablePageRange {
 
         // SAFETY: We own the vma, and we don't use any methods on VmaNew that rely on
         // `vm_ops`.
-        unsafe { (*vma.as_ptr()).vm_ops = &BINDER_VM_OPS };
+        unsafe { (*vma.as_ptr()).vm_ops = &BINDER_VM_OPS.0 };
 
         Ok(num_pages)
     }
--- a/drivers/android/binder/rust_binder_main.rs
+++ b/drivers/android/binder/rust_binder_main.rs
@@ -300,7 +300,7 @@ impl kernel::Module for BinderModule {
 /// Makes the inner type Sync.
 #[repr(transparent)]
 pub struct AssertSync<T>(T);
-// SAFETY: Used only to insert `file_operations` into a global, which is safe.
+// SAFETY: Used only to insert C bindings types into globals, which is safe.
 unsafe impl<T> Sync for AssertSync<T> {}
 
 /// File operations that rust_binderfs.c can use.


