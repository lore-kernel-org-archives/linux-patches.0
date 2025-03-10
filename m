Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D02912236FB;
	Mon, 10 Mar 2025 17:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741626627; cv=none; b=r1s05t939Z+4uPjWd/W0LRG5nqSEJ+fFQQyh5w4T+QhU8/QMWeHC8N03Nxo14MCzDJfOwZ/+2haVl+eTGxXzMR9R+dBbHvIu4nshV+WkJeZFmOCD+yUFsa8hbA6F5DEF64gjbjihUXGbEtR8S0TsAh/5Xgv7/afo8SI/jo0y7n0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741626627; c=relaxed/simple;
	bh=ifpBuEyeYwgnyW+FHQtvuq/H4/HbWD0LfJqf34DN4G8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WXgtfdPX64nndySjyWOcSe51EJKB8EQplRR1fchdp96b8FgjsLN7EyiqbY4FklGk4R+HseS68DbvHn89hXr2+CJv9sNzqvfy32wgNyunEv+E/FjD+lai0jhckNA34G4QCN+fUdRGgZhtJ9Q1Bcw/vm29tQbxfoiT4+2u9VPjZXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=axIS5+ln; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="axIS5+ln"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55EDBC4CEE5;
	Mon, 10 Mar 2025 17:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741626627;
	bh=ifpBuEyeYwgnyW+FHQtvuq/H4/HbWD0LfJqf34DN4G8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=axIS5+lndsm21wnpDMfX+rJKbfkAZ4fD7owKv8se54yTVY4ACysIoBdBp42pX+Ntu
	 DbrMMjV237N7rlCJtlkf0W2TAKYUE4Ax47nnNbxq1SlgqN9KxZ8PrZIjFEhicX8hqZ
	 XLRkw8upp3h4WwZQR7o4oVPWcMEUChhGGygIKwFo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oak Zeng <oak.zeng@intel.com>,
	Matthew Auld <matthew.auld@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 6.13 057/207] drm/xe/userptr: Unmap userptrs in the mmu notifier
Date: Mon, 10 Mar 2025 18:04:10 +0100
Message-ID: <20250310170450.039559535@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Hellström <thomas.hellstrom@linux.intel.com>

commit 333b8906336174478efbbfc1e24a89e3397ffe65 upstream.

If userptr pages are freed after a call to the xe mmu notifier,
the device will not be blocked out from theoretically accessing
these pages unless they are also unmapped from the iommu, and
this violates some aspects of the iommu-imposed security.

Ensure that userptrs are unmapped in the mmu notifier to
mitigate this. A naive attempt would try to free the sg table, but
the sg table itself may be accessed by a concurrent bind
operation, so settle for only unmapping.

v3:
- Update lockdep asserts.
- Fix a typo (Matthew Auld)

Fixes: 81e058a3e7fd ("drm/xe: Introduce helper to populate userptr")
Cc: Oak Zeng <oak.zeng@intel.com>
Cc: Matthew Auld <matthew.auld@intel.com>
Cc: <stable@vger.kernel.org> # v6.10+
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
Acked-by: Matthew Brost <matthew.brost@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250304173342.22009-4-thomas.hellstrom@linux.intel.com
(cherry picked from commit ba767b9d01a2c552d76cf6f46b125d50ec4147a6)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_hmm.c      |   51 ++++++++++++++++++++++++++++++++-------
 drivers/gpu/drm/xe/xe_hmm.h      |    2 +
 drivers/gpu/drm/xe/xe_vm.c       |    4 +++
 drivers/gpu/drm/xe/xe_vm_types.h |    4 +++
 4 files changed, 52 insertions(+), 9 deletions(-)

--- a/drivers/gpu/drm/xe/xe_hmm.c
+++ b/drivers/gpu/drm/xe/xe_hmm.c
@@ -150,6 +150,45 @@ static int xe_build_sg(struct xe_device
 			       DMA_ATTR_SKIP_CPU_SYNC | DMA_ATTR_NO_KERNEL_MAPPING);
 }
 
+static void xe_hmm_userptr_set_mapped(struct xe_userptr_vma *uvma)
+{
+	struct xe_userptr *userptr = &uvma->userptr;
+	struct xe_vm *vm = xe_vma_vm(&uvma->vma);
+
+	lockdep_assert_held_write(&vm->lock);
+	lockdep_assert_held(&vm->userptr.notifier_lock);
+
+	mutex_lock(&userptr->unmap_mutex);
+	xe_assert(vm->xe, !userptr->mapped);
+	userptr->mapped = true;
+	mutex_unlock(&userptr->unmap_mutex);
+}
+
+void xe_hmm_userptr_unmap(struct xe_userptr_vma *uvma)
+{
+	struct xe_userptr *userptr = &uvma->userptr;
+	struct xe_vma *vma = &uvma->vma;
+	bool write = !xe_vma_read_only(vma);
+	struct xe_vm *vm = xe_vma_vm(vma);
+	struct xe_device *xe = vm->xe;
+
+	if (!lockdep_is_held_type(&vm->userptr.notifier_lock, 0) &&
+	    !lockdep_is_held_type(&vm->lock, 0) &&
+	    !(vma->gpuva.flags & XE_VMA_DESTROYED)) {
+		/* Don't unmap in exec critical section. */
+		xe_vm_assert_held(vm);
+		/* Don't unmap while mapping the sg. */
+		lockdep_assert_held(&vm->lock);
+	}
+
+	mutex_lock(&userptr->unmap_mutex);
+	if (userptr->sg && userptr->mapped)
+		dma_unmap_sgtable(xe->drm.dev, userptr->sg,
+				  write ? DMA_BIDIRECTIONAL : DMA_TO_DEVICE, 0);
+	userptr->mapped = false;
+	mutex_unlock(&userptr->unmap_mutex);
+}
+
 /**
  * xe_hmm_userptr_free_sg() - Free the scatter gather table of userptr
  * @uvma: the userptr vma which hold the scatter gather table
@@ -161,16 +200,9 @@ static int xe_build_sg(struct xe_device
 void xe_hmm_userptr_free_sg(struct xe_userptr_vma *uvma)
 {
 	struct xe_userptr *userptr = &uvma->userptr;
-	struct xe_vma *vma = &uvma->vma;
-	bool write = !xe_vma_read_only(vma);
-	struct xe_vm *vm = xe_vma_vm(vma);
-	struct xe_device *xe = vm->xe;
-	struct device *dev = xe->drm.dev;
-
-	xe_assert(xe, userptr->sg);
-	dma_unmap_sgtable(dev, userptr->sg,
-			  write ? DMA_BIDIRECTIONAL : DMA_TO_DEVICE, 0);
 
+	xe_assert(xe_vma_vm(&uvma->vma)->xe, userptr->sg);
+	xe_hmm_userptr_unmap(uvma);
 	sg_free_table(userptr->sg);
 	userptr->sg = NULL;
 }
@@ -297,6 +329,7 @@ int xe_hmm_userptr_populate_range(struct
 
 	xe_mark_range_accessed(&hmm_range, write);
 	userptr->sg = &userptr->sgt;
+	xe_hmm_userptr_set_mapped(uvma);
 	userptr->notifier_seq = hmm_range.notifier_seq;
 	up_read(&vm->userptr.notifier_lock);
 	kvfree(pfns);
--- a/drivers/gpu/drm/xe/xe_hmm.h
+++ b/drivers/gpu/drm/xe/xe_hmm.h
@@ -13,4 +13,6 @@ struct xe_userptr_vma;
 int xe_hmm_userptr_populate_range(struct xe_userptr_vma *uvma, bool is_mm_mmap_locked);
 
 void xe_hmm_userptr_free_sg(struct xe_userptr_vma *uvma);
+
+void xe_hmm_userptr_unmap(struct xe_userptr_vma *uvma);
 #endif
--- a/drivers/gpu/drm/xe/xe_vm.c
+++ b/drivers/gpu/drm/xe/xe_vm.c
@@ -621,6 +621,8 @@ static void __vma_userptr_invalidate(str
 		err = xe_vm_invalidate_vma(vma);
 		XE_WARN_ON(err);
 	}
+
+	xe_hmm_userptr_unmap(uvma);
 }
 
 static bool vma_userptr_invalidate(struct mmu_interval_notifier *mni,
@@ -1039,6 +1041,7 @@ static struct xe_vma *xe_vma_create(stru
 			INIT_LIST_HEAD(&userptr->invalidate_link);
 			INIT_LIST_HEAD(&userptr->repin_link);
 			vma->gpuva.gem.offset = bo_offset_or_userptr;
+			mutex_init(&userptr->unmap_mutex);
 
 			err = mmu_interval_notifier_insert(&userptr->notifier,
 							   current->mm,
@@ -1080,6 +1083,7 @@ static void xe_vma_destroy_late(struct x
 		 * them anymore
 		 */
 		mmu_interval_notifier_remove(&userptr->notifier);
+		mutex_destroy(&userptr->unmap_mutex);
 		xe_vm_put(vm);
 	} else if (xe_vma_is_null(vma)) {
 		xe_vm_put(vm);
--- a/drivers/gpu/drm/xe/xe_vm_types.h
+++ b/drivers/gpu/drm/xe/xe_vm_types.h
@@ -59,12 +59,16 @@ struct xe_userptr {
 	struct sg_table *sg;
 	/** @notifier_seq: notifier sequence number */
 	unsigned long notifier_seq;
+	/** @unmap_mutex: Mutex protecting dma-unmapping */
+	struct mutex unmap_mutex;
 	/**
 	 * @initial_bind: user pointer has been bound at least once.
 	 * write: vm->userptr.notifier_lock in read mode and vm->resv held.
 	 * read: vm->userptr.notifier_lock in write mode or vm->resv held.
 	 */
 	bool initial_bind;
+	/** @mapped: Whether the @sgt sg-table is dma-mapped. Protected by @unmap_mutex. */
+	bool mapped;
 #if IS_ENABLED(CONFIG_DRM_XE_USERPTR_INVAL_INJECT)
 	u32 divisor;
 #endif


