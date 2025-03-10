Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AA2F22D786;
	Mon, 10 Mar 2025 17:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741626622; cv=none; b=T8Y0U1p3pUthG0REJGrRLGXfbZpNa8eqN65z0/V+OA0vXUty3QCY9uYsBrm1amLV7hCxZ8RAyk28puKReNzu/yiLQahQW6+cVeS2wZLDyCOECT0isOYOrxz157YVuzKxNrOeCU/QCMFTchzDkWwRopTRt+wBaZsUFQW8vJQI+gU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741626622; c=relaxed/simple;
	bh=bEjbMgsSUnbyGT/KTp3F8KCecUO8PmjShWGkKROtpbY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oGbU3G8z1+r97GEubQOB2e79TWhcBqkjqj0NYmk7E+R55Zn4dwwdfjwQ76u88LAS6x6LGiWD4+XXzVA9ZTyX8H3nVol9oQIOplTxwtmH0PxRcaVTZ82kmGSOxOJSJDEE0w4moQ7rDpDZaF60C4d3q8RpinLgqI0TDgz9meEUYqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VtZXJjkz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VtZXJjkz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97812C4CEE5;
	Mon, 10 Mar 2025 17:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741626622;
	bh=bEjbMgsSUnbyGT/KTp3F8KCecUO8PmjShWGkKROtpbY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VtZXJjkzjNTcO/OUSWZA4hDrAAqOa6uFzDiYtH9n5ZeRLou+8RfytVPqbNKI5dNaG
	 5mkaRmUPOQWOSjLc9eqpRvIf3AuRFzoDGulbB8fM2uTI2x1Tue8uagS1hqTTHXe5tl
	 uhHDI2Z0m06vUv/3P8RjolJJdpBy7iBDrUN8b48A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Matthew Auld <matthew.auld@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 6.13 055/207] drm/xe: Fix fault mode invalidation with unbind
Date: Mon, 10 Mar 2025 18:04:08 +0100
Message-ID: <20250310170449.958131640@linuxfoundation.org>
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

commit 84211b1c0db6b9dbe0020fa97192fb9661617f24 upstream.

Fix fault mode invalidation racing with unbind leading to the
PTE zapping potentially traversing an invalid page-table tree.
Do this by holding the notifier lock across PTE zapping. This
might transfer any contention waiting on the notifier seqlock
read side to the notifier lock read side, but that shouldn't be
a major problem.

At the same time get rid of the open-coded invalidation in the bind
code by relying on the notifier even when the vma bind is not
yet committed.

Finally let userptr invalidation call a dedicated xe_vm function
performing a full invalidation.

Fixes: e8babb280b5e ("drm/xe: Convert multiple bind ops into single job")
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Matthew Auld <matthew.auld@intel.com>
Cc: <stable@vger.kernel.org> # v6.12+
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250228073058.59510-4-thomas.hellstrom@linux.intel.com
(cherry picked from commit 100a5b8dadfca50d91d9a4c9fc01431b42a25cab)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_pt.c       |   38 ++++-------------
 drivers/gpu/drm/xe/xe_vm.c       |   85 +++++++++++++++++++++++++--------------
 drivers/gpu/drm/xe/xe_vm.h       |    8 +++
 drivers/gpu/drm/xe/xe_vm_types.h |    4 -
 4 files changed, 75 insertions(+), 60 deletions(-)

--- a/drivers/gpu/drm/xe/xe_pt.c
+++ b/drivers/gpu/drm/xe/xe_pt.c
@@ -1233,42 +1233,22 @@ static int vma_check_userptr(struct xe_v
 		return 0;
 
 	uvma = to_userptr_vma(vma);
-	notifier_seq = uvma->userptr.notifier_seq;
+	if (xe_pt_userptr_inject_eagain(uvma))
+		xe_vma_userptr_force_invalidate(uvma);
 
-	if (uvma->userptr.initial_bind && !xe_vm_in_fault_mode(vm))
-		return 0;
+	notifier_seq = uvma->userptr.notifier_seq;
 
 	if (!mmu_interval_read_retry(&uvma->userptr.notifier,
-				     notifier_seq) &&
-	    !xe_pt_userptr_inject_eagain(uvma))
+				     notifier_seq))
 		return 0;
 
-	if (xe_vm_in_fault_mode(vm)) {
+	if (xe_vm_in_fault_mode(vm))
 		return -EAGAIN;
-	} else {
-		spin_lock(&vm->userptr.invalidated_lock);
-		list_move_tail(&uvma->userptr.invalidate_link,
-			       &vm->userptr.invalidated);
-		spin_unlock(&vm->userptr.invalidated_lock);
-
-		if (xe_vm_in_preempt_fence_mode(vm)) {
-			struct dma_resv_iter cursor;
-			struct dma_fence *fence;
-			long err;
-
-			dma_resv_iter_begin(&cursor, xe_vm_resv(vm),
-					    DMA_RESV_USAGE_BOOKKEEP);
-			dma_resv_for_each_fence_unlocked(&cursor, fence)
-				dma_fence_enable_sw_signaling(fence);
-			dma_resv_iter_end(&cursor);
-
-			err = dma_resv_wait_timeout(xe_vm_resv(vm),
-						    DMA_RESV_USAGE_BOOKKEEP,
-						    false, MAX_SCHEDULE_TIMEOUT);
-			XE_WARN_ON(err <= 0);
-		}
-	}
 
+	/*
+	 * Just continue the operation since exec or rebind worker
+	 * will take care of rebinding.
+	 */
 	return 0;
 }
 
--- a/drivers/gpu/drm/xe/xe_vm.c
+++ b/drivers/gpu/drm/xe/xe_vm.c
@@ -580,51 +580,26 @@ out_unlock_outer:
 	trace_xe_vm_rebind_worker_exit(vm);
 }
 
-static bool vma_userptr_invalidate(struct mmu_interval_notifier *mni,
-				   const struct mmu_notifier_range *range,
-				   unsigned long cur_seq)
+static void __vma_userptr_invalidate(struct xe_vm *vm, struct xe_userptr_vma *uvma)
 {
-	struct xe_userptr *userptr = container_of(mni, typeof(*userptr), notifier);
-	struct xe_userptr_vma *uvma = container_of(userptr, typeof(*uvma), userptr);
+	struct xe_userptr *userptr = &uvma->userptr;
 	struct xe_vma *vma = &uvma->vma;
-	struct xe_vm *vm = xe_vma_vm(vma);
 	struct dma_resv_iter cursor;
 	struct dma_fence *fence;
 	long err;
 
-	xe_assert(vm->xe, xe_vma_is_userptr(vma));
-	trace_xe_vma_userptr_invalidate(vma);
-
-	if (!mmu_notifier_range_blockable(range))
-		return false;
-
-	vm_dbg(&xe_vma_vm(vma)->xe->drm,
-	       "NOTIFIER: addr=0x%016llx, range=0x%016llx",
-		xe_vma_start(vma), xe_vma_size(vma));
-
-	down_write(&vm->userptr.notifier_lock);
-	mmu_interval_set_seq(mni, cur_seq);
-
-	/* No need to stop gpu access if the userptr is not yet bound. */
-	if (!userptr->initial_bind) {
-		up_write(&vm->userptr.notifier_lock);
-		return true;
-	}
-
 	/*
 	 * Tell exec and rebind worker they need to repin and rebind this
 	 * userptr.
 	 */
 	if (!xe_vm_in_fault_mode(vm) &&
-	    !(vma->gpuva.flags & XE_VMA_DESTROYED) && vma->tile_present) {
+	    !(vma->gpuva.flags & XE_VMA_DESTROYED)) {
 		spin_lock(&vm->userptr.invalidated_lock);
 		list_move_tail(&userptr->invalidate_link,
 			       &vm->userptr.invalidated);
 		spin_unlock(&vm->userptr.invalidated_lock);
 	}
 
-	up_write(&vm->userptr.notifier_lock);
-
 	/*
 	 * Preempt fences turn into schedule disables, pipeline these.
 	 * Note that even in fault mode, we need to wait for binds and
@@ -642,11 +617,35 @@ static bool vma_userptr_invalidate(struc
 				    false, MAX_SCHEDULE_TIMEOUT);
 	XE_WARN_ON(err <= 0);
 
-	if (xe_vm_in_fault_mode(vm)) {
+	if (xe_vm_in_fault_mode(vm) && userptr->initial_bind) {
 		err = xe_vm_invalidate_vma(vma);
 		XE_WARN_ON(err);
 	}
+}
+
+static bool vma_userptr_invalidate(struct mmu_interval_notifier *mni,
+				   const struct mmu_notifier_range *range,
+				   unsigned long cur_seq)
+{
+	struct xe_userptr_vma *uvma = container_of(mni, typeof(*uvma), userptr.notifier);
+	struct xe_vma *vma = &uvma->vma;
+	struct xe_vm *vm = xe_vma_vm(vma);
+
+	xe_assert(vm->xe, xe_vma_is_userptr(vma));
+	trace_xe_vma_userptr_invalidate(vma);
 
+	if (!mmu_notifier_range_blockable(range))
+		return false;
+
+	vm_dbg(&xe_vma_vm(vma)->xe->drm,
+	       "NOTIFIER: addr=0x%016llx, range=0x%016llx",
+		xe_vma_start(vma), xe_vma_size(vma));
+
+	down_write(&vm->userptr.notifier_lock);
+	mmu_interval_set_seq(mni, cur_seq);
+
+	__vma_userptr_invalidate(vm, uvma);
+	up_write(&vm->userptr.notifier_lock);
 	trace_xe_vma_userptr_invalidate_complete(vma);
 
 	return true;
@@ -656,6 +655,34 @@ static const struct mmu_interval_notifie
 	.invalidate = vma_userptr_invalidate,
 };
 
+#if IS_ENABLED(CONFIG_DRM_XE_USERPTR_INVAL_INJECT)
+/**
+ * xe_vma_userptr_force_invalidate() - force invalidate a userptr
+ * @uvma: The userptr vma to invalidate
+ *
+ * Perform a forced userptr invalidation for testing purposes.
+ */
+void xe_vma_userptr_force_invalidate(struct xe_userptr_vma *uvma)
+{
+	struct xe_vm *vm = xe_vma_vm(&uvma->vma);
+
+	/* Protect against concurrent userptr pinning */
+	lockdep_assert_held(&vm->lock);
+	/* Protect against concurrent notifiers */
+	lockdep_assert_held(&vm->userptr.notifier_lock);
+	/*
+	 * Protect against concurrent instances of this function and
+	 * the critical exec sections
+	 */
+	xe_vm_assert_held(vm);
+
+	if (!mmu_interval_read_retry(&uvma->userptr.notifier,
+				     uvma->userptr.notifier_seq))
+		uvma->userptr.notifier_seq -= 2;
+	__vma_userptr_invalidate(vm, uvma);
+}
+#endif
+
 int xe_vm_userptr_pin(struct xe_vm *vm)
 {
 	struct xe_userptr_vma *uvma, *next;
--- a/drivers/gpu/drm/xe/xe_vm.h
+++ b/drivers/gpu/drm/xe/xe_vm.h
@@ -280,4 +280,12 @@ struct xe_vm_snapshot *xe_vm_snapshot_ca
 void xe_vm_snapshot_capture_delayed(struct xe_vm_snapshot *snap);
 void xe_vm_snapshot_print(struct xe_vm_snapshot *snap, struct drm_printer *p);
 void xe_vm_snapshot_free(struct xe_vm_snapshot *snap);
+
+#if IS_ENABLED(CONFIG_DRM_XE_USERPTR_INVAL_INJECT)
+void xe_vma_userptr_force_invalidate(struct xe_userptr_vma *uvma);
+#else
+static inline void xe_vma_userptr_force_invalidate(struct xe_userptr_vma *uvma)
+{
+}
+#endif
 #endif
--- a/drivers/gpu/drm/xe/xe_vm_types.h
+++ b/drivers/gpu/drm/xe/xe_vm_types.h
@@ -227,8 +227,8 @@ struct xe_vm {
 		 * up for revalidation. Protected from access with the
 		 * @invalidated_lock. Removing items from the list
 		 * additionally requires @lock in write mode, and adding
-		 * items to the list requires the @userptr.notifer_lock in
-		 * write mode.
+		 * items to the list requires either the @userptr.notifer_lock in
+		 * write mode, OR @lock in write mode.
 		 */
 		struct list_head invalidated;
 	} userptr;


