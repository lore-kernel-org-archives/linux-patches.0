Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A8BE1AF0BB;
	Tue, 27 May 2025 17:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367055; cv=none; b=ErwR7A9uwq6sMON7rn5kDVysR1uVWvYDjnLCqnZhr2heeeBGwSwcdCXKGjQmD7oTQJeieenGci7PvmUoqlE0hHj+1f7OwcA1Y0CEpFC1lTrNCWDqJRhJwAUx/ytta7AjKV0mC/04UlV+1LhOOG2g3OkvNFePVMPNe/6jnTaM9Oo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367055; c=relaxed/simple;
	bh=KHOQ5n0/Bit4a+oCPeVFm4gpUoKVHiNHhN3XmjZYogM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Dzswye0UzEkFStdF+xg64PCm7UdmEwJK1UJOTFeJFqErfOcsTyFpk4TeDrbHGRXT6P67dtRXmk09pr2PLQY/pAPz5aCXe97/cTXnERa2CjZD+SW6PL3O6jPQm5EvQltx6h20Q90575LtGReya+AqL5gXQlfq58ZYaNoO/V5xMts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Emk1bikP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Emk1bikP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B346C4CEE9;
	Tue, 27 May 2025 17:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367054;
	bh=KHOQ5n0/Bit4a+oCPeVFm4gpUoKVHiNHhN3XmjZYogM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Emk1bikPlJDFUksErOmAqQbgaWEkS2RvtkRFYK6hFmn7RAUxthxdz342NSGallIoK
	 geSLKf4RPUPf5beENt0wHq6bz2eV8PqiJ4bqok/yDJm0cQtUEIGgI/R5TbEi7rQ7ly
	 Th0cJVkcl7+UiJWYZ8EhxCMa+jVcdGBiC7aPkBIQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Brost <matthew.brost@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 264/783] drm/xe: Nuke VMs mapping upon close
Date: Tue, 27 May 2025 18:21:01 +0200
Message-ID: <20250527162523.846371339@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Brost <matthew.brost@intel.com>

[ Upstream commit 074e40d9c2a84939fe28d7121d3469db50f34a3d ]

Clear root PT entry and invalidate entire VM's address space when
closing the VM. Will prevent the GPU from accessing any of the VM's
memory after closing.

v2:
 - s/vma/vm in kernel doc (CI)
 - Don't nuke migration VM as this occur at driver unload (CI)
v3:
 - Rebase and pull into SVM series (Thomas)
 - Wait for pending binds (Thomas)
v5:
 - Remove xe_gt_tlb_invalidation_fence_fini in error case (Matt Auld)
 - Drop local migration bool (Thomas)
v7:
 - Add drm_dev_enter/exit protecting invalidation (CI, Matt Auld)

Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250306012657.3505757-12-matthew.brost@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_gt_tlb_invalidation.c | 22 ++++++++++++++
 drivers/gpu/drm/xe/xe_gt_tlb_invalidation.h |  2 ++
 drivers/gpu/drm/xe/xe_pt.c                  | 14 +++++++++
 drivers/gpu/drm/xe/xe_pt.h                  |  3 ++
 drivers/gpu/drm/xe/xe_vm.c                  | 32 +++++++++++++++++++++
 5 files changed, 73 insertions(+)

diff --git a/drivers/gpu/drm/xe/xe_gt_tlb_invalidation.c b/drivers/gpu/drm/xe/xe_gt_tlb_invalidation.c
index 9405d83d4db2a..084cbdeba8eaa 100644
--- a/drivers/gpu/drm/xe/xe_gt_tlb_invalidation.c
+++ b/drivers/gpu/drm/xe/xe_gt_tlb_invalidation.c
@@ -418,6 +418,28 @@ int xe_gt_tlb_invalidation_range(struct xe_gt *gt,
 	return send_tlb_invalidation(&gt->uc.guc, fence, action, len);
 }
 
+/**
+ * xe_gt_tlb_invalidation_vm - Issue a TLB invalidation on this GT for a VM
+ * @gt: graphics tile
+ * @vm: VM to invalidate
+ *
+ * Invalidate entire VM's address space
+ */
+void xe_gt_tlb_invalidation_vm(struct xe_gt *gt, struct xe_vm *vm)
+{
+	struct xe_gt_tlb_invalidation_fence fence;
+	u64 range = 1ull << vm->xe->info.va_bits;
+	int ret;
+
+	xe_gt_tlb_invalidation_fence_init(gt, &fence, true);
+
+	ret = xe_gt_tlb_invalidation_range(gt, &fence, 0, range, vm->usm.asid);
+	if (ret < 0)
+		return;
+
+	xe_gt_tlb_invalidation_fence_wait(&fence);
+}
+
 /**
  * xe_gt_tlb_invalidation_vma - Issue a TLB invalidation on this GT for a VMA
  * @gt: GT structure
diff --git a/drivers/gpu/drm/xe/xe_gt_tlb_invalidation.h b/drivers/gpu/drm/xe/xe_gt_tlb_invalidation.h
index 672acfcdf0d70..abe9b03d543e6 100644
--- a/drivers/gpu/drm/xe/xe_gt_tlb_invalidation.h
+++ b/drivers/gpu/drm/xe/xe_gt_tlb_invalidation.h
@@ -12,6 +12,7 @@
 
 struct xe_gt;
 struct xe_guc;
+struct xe_vm;
 struct xe_vma;
 
 int xe_gt_tlb_invalidation_init_early(struct xe_gt *gt);
@@ -21,6 +22,7 @@ int xe_gt_tlb_invalidation_ggtt(struct xe_gt *gt);
 int xe_gt_tlb_invalidation_vma(struct xe_gt *gt,
 			       struct xe_gt_tlb_invalidation_fence *fence,
 			       struct xe_vma *vma);
+void xe_gt_tlb_invalidation_vm(struct xe_gt *gt, struct xe_vm *vm);
 int xe_gt_tlb_invalidation_range(struct xe_gt *gt,
 				 struct xe_gt_tlb_invalidation_fence *fence,
 				 u64 start, u64 end, u32 asid);
diff --git a/drivers/gpu/drm/xe/xe_pt.c b/drivers/gpu/drm/xe/xe_pt.c
index dc24baa840924..148d90611eebf 100644
--- a/drivers/gpu/drm/xe/xe_pt.c
+++ b/drivers/gpu/drm/xe/xe_pt.c
@@ -218,6 +218,20 @@ void xe_pt_destroy(struct xe_pt *pt, u32 flags, struct llist_head *deferred)
 	xe_pt_free(pt);
 }
 
+/**
+ * xe_pt_clear() - Clear a page-table.
+ * @xe: xe device.
+ * @pt: The page-table.
+ *
+ * Clears page-table by setting to zero.
+ */
+void xe_pt_clear(struct xe_device *xe, struct xe_pt *pt)
+{
+	struct iosys_map *map = &pt->bo->vmap;
+
+	xe_map_memset(xe, map, 0, 0, SZ_4K);
+}
+
 /**
  * DOC: Pagetable building
  *
diff --git a/drivers/gpu/drm/xe/xe_pt.h b/drivers/gpu/drm/xe/xe_pt.h
index 9ab386431cadd..8e43912ae8e94 100644
--- a/drivers/gpu/drm/xe/xe_pt.h
+++ b/drivers/gpu/drm/xe/xe_pt.h
@@ -13,6 +13,7 @@ struct dma_fence;
 struct xe_bo;
 struct xe_device;
 struct xe_exec_queue;
+struct xe_svm_range;
 struct xe_sync_entry;
 struct xe_tile;
 struct xe_vm;
@@ -35,6 +36,8 @@ void xe_pt_populate_empty(struct xe_tile *tile, struct xe_vm *vm,
 
 void xe_pt_destroy(struct xe_pt *pt, u32 flags, struct llist_head *deferred);
 
+void xe_pt_clear(struct xe_device *xe, struct xe_pt *pt);
+
 int xe_pt_update_ops_prepare(struct xe_tile *tile, struct xe_vma_ops *vops);
 struct dma_fence *xe_pt_update_ops_run(struct xe_tile *tile,
 				       struct xe_vma_ops *vops);
diff --git a/drivers/gpu/drm/xe/xe_vm.c b/drivers/gpu/drm/xe/xe_vm.c
index 5956631c0d40a..785b8960050bd 100644
--- a/drivers/gpu/drm/xe/xe_vm.c
+++ b/drivers/gpu/drm/xe/xe_vm.c
@@ -8,6 +8,7 @@
 #include <linux/dma-fence-array.h>
 #include <linux/nospec.h>
 
+#include <drm/drm_drv.h>
 #include <drm/drm_exec.h>
 #include <drm/drm_print.h>
 #include <drm/ttm/ttm_tt.h>
@@ -1582,9 +1583,40 @@ struct xe_vm *xe_vm_create(struct xe_device *xe, u32 flags)
 
 static void xe_vm_close(struct xe_vm *vm)
 {
+	struct xe_device *xe = vm->xe;
+	bool bound;
+	int idx;
+
+	bound = drm_dev_enter(&xe->drm, &idx);
+
 	down_write(&vm->lock);
+
 	vm->size = 0;
+
+	if (!((vm->flags & XE_VM_FLAG_MIGRATION))) {
+		struct xe_tile *tile;
+		struct xe_gt *gt;
+		u8 id;
+
+		/* Wait for pending binds */
+		dma_resv_wait_timeout(xe_vm_resv(vm),
+				      DMA_RESV_USAGE_BOOKKEEP,
+				      false, MAX_SCHEDULE_TIMEOUT);
+
+		if (bound) {
+			for_each_tile(tile, xe, id)
+				if (vm->pt_root[id])
+					xe_pt_clear(xe, vm->pt_root[id]);
+
+			for_each_gt(gt, xe, id)
+				xe_gt_tlb_invalidation_vm(gt, vm);
+		}
+	}
+
 	up_write(&vm->lock);
+
+	if (bound)
+		drm_dev_exit(idx);
 }
 
 void xe_vm_close_and_put(struct xe_vm *vm)
-- 
2.39.5



