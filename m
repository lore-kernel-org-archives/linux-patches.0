Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 053E32D73B5;
	Thu, 30 Jul 2026 15:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423780; cv=none; b=YefmNlM06+oxnlN0DkWy7JUImbhiTaaGxe8gOHDhNQQRExYeJKObimfWxYKkqdYMmMVu7157wTnszOwodBpZNjY3X8rSR5gGdyf8q+/SlG7iiNvf8oeejrsMh6lEAfDfCvf8eaT8EYWwMhdykzt+W2GI6aH2G0Bio7ifZR7rVxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423780; c=relaxed/simple;
	bh=tSt+6GiUAXjzdZbFJifNYQC/+woM3b3sL8XEqdREtzw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OP2Sy24cecDdwW3NQDGyezFEUmpxGKcn4JxjRrNHc1T3pB4nWxrD1B9PPufX+B3c276lAT1bISo+PZecYmYKhlAOWI8AOiot+i+dpc+DSPbdBLkpR7If7d7GqDWwPRrFm1/lzNVkH40A7v1vZCaiGsXtprQGGfxldWd2zoBtJ18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HL8PfD3c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HL8PfD3c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E6F61F000E9;
	Thu, 30 Jul 2026 15:02:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423778;
	bh=AhbU/099J5p+aQZNFCL+sNqhJCvuo2+SWw2d+NPu8lY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HL8PfD3cF2Ds8F5nduq26KAtGOY2hLl4Nsq7S3L5HhhHgWx8iWXUtvPgbWEvWKGkj
	 UOGomXt8i38R71yfcNqnhVlLN0q+n8eweFS51PCwEA5oPYfBtepSCRnH7lksRXCEpk
	 rAoRrYE4Wos4eH0554mesAKRz7k6JK+yrbh+/j+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Satyanarayana K V P <satyanarayana.k.v.p@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Michal Wajdeczko <michal.wajdeczko@intel.com>,
	Matthew Auld <matthew.auld@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 126/675] drm/xe/vf: Shadow buffer management for CCS read/write operations
Date: Thu, 30 Jul 2026 16:07:36 +0200
Message-ID: <20260730141447.823887870@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Satyanarayana K V P <satyanarayana.k.v.p@intel.com>

[ Upstream commit fa18290bf0723b02bfa8d30d2e14722f0d096c2c ]

CCS copy command consist of 5-dword sequence. If vCPU halts during
save/restore operations while these sequences are being programmed,
incomplete writes can cause page faults during IGPU CCS metadata saving.

Use shadow buffer management to prevent partial write issues during CCS
operations.

Signed-off-by: Satyanarayana K V P <satyanarayana.k.v.p@intel.com>
Suggested-by: Matthew Brost <matthew.brost@intel.com>
Cc: Michal Wajdeczko <michal.wajdeczko@intel.com>
Cc: Matthew Auld <matthew.auld@intel.com>
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Link: https://patch.msgid.link/20251118120745.3460172-3-satyanarayana.k.v.p@intel.com
Stable-dep-of: 56441f9e08ad ("drm/xe/vf: Fix VF CCS attach/detach race with in-flight BO moves")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_migrate.c      | 57 ++++++++++++++++++++++++++--
 drivers/gpu/drm/xe/xe_migrate.h      |  3 ++
 drivers/gpu/drm/xe/xe_sriov_vf_ccs.c | 19 ++++++++--
 drivers/gpu/drm/xe/xe_sriov_vf_ccs.h |  1 +
 4 files changed, 73 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_migrate.c b/drivers/gpu/drm/xe/xe_migrate.c
index b6905f35d6c81f..6a0c088d09fb33 100644
--- a/drivers/gpu/drm/xe/xe_migrate.c
+++ b/drivers/gpu/drm/xe/xe_migrate.c
@@ -33,6 +33,7 @@
 #include "xe_res_cursor.h"
 #include "xe_sa.h"
 #include "xe_sched_job.h"
+#include "xe_sriov_vf_ccs.h"
 #include "xe_sync.h"
 #include "xe_trace_bo.h"
 #include "xe_validation.h"
@@ -1022,12 +1023,16 @@ int xe_migrate_ccs_rw_copy(struct xe_tile *tile, struct xe_exec_queue *q,
 	u32 batch_size, batch_size_allocated;
 	struct xe_device *xe = gt_to_xe(gt);
 	struct xe_res_cursor src_it, ccs_it;
+	struct xe_sriov_vf_ccs_ctx *ctx;
+	struct xe_sa_manager *bb_pool;
 	u64 size = xe_bo_size(src_bo);
 	struct xe_bb *bb = NULL;
 	u64 src_L0, src_L0_ofs;
 	u32 src_L0_pt;
 	int err;
 
+	ctx = &xe->sriov.vf.ccs.contexts[read_write];
+
 	xe_res_first_sg(xe_bo_sg(src_bo), 0, size, &src_it);
 
 	xe_res_first_sg(xe_bo_sg(src_bo), xe_bo_ccs_pages_start(src_bo),
@@ -1060,11 +1065,15 @@ int xe_migrate_ccs_rw_copy(struct xe_tile *tile, struct xe_exec_queue *q,
 		size -= src_L0;
 	}
 
+	bb_pool = ctx->mem.ccs_bb_pool;
+	guard(mutex) (xe_sa_bo_swap_guard(bb_pool));
+	xe_sa_bo_swap_shadow(bb_pool);
+
 	bb = xe_bb_ccs_new(gt, batch_size, read_write);
 	if (IS_ERR(bb)) {
 		drm_err(&xe->drm, "BB allocation failed.\n");
 		err = PTR_ERR(bb);
-		goto err_ret;
+		return err;
 	}
 
 	batch_size_allocated = batch_size;
@@ -1113,10 +1122,52 @@ int xe_migrate_ccs_rw_copy(struct xe_tile *tile, struct xe_exec_queue *q,
 	xe_assert(xe, (batch_size_allocated == bb->len));
 	src_bo->bb_ccs[read_write] = bb;
 
+	xe_sriov_vf_ccs_rw_update_bb_addr(ctx);
+	xe_sa_bo_sync_shadow(bb->bo);
 	return 0;
+}
 
-err_ret:
-	return err;
+/**
+ * xe_migrate_ccs_rw_copy_clear() - Clear the CCS read/write batch buffer
+ * content.
+ * @src_bo: The buffer object @src is currently bound to.
+ * @read_write : Creates BB commands for CCS read/write.
+ *
+ * Directly clearing the BB lacks atomicity and can lead to undefined
+ * behavior if the vCPU is halted mid-operation during the clearing
+ * process. To avoid this issue, we use a shadow buffer object approach.
+ *
+ * First swap the SA BO address with the shadow BO, perform the clearing
+ * operation on the BB, update the shadow BO in the ring buffer, then
+ * sync the shadow and the actual buffer to maintain consistency.
+ *
+ * Returns: None.
+ */
+void xe_migrate_ccs_rw_copy_clear(struct xe_bo *src_bo,
+				  enum xe_sriov_vf_ccs_rw_ctxs read_write)
+{
+	struct xe_bb *bb = src_bo->bb_ccs[read_write];
+	struct xe_device *xe = xe_bo_device(src_bo);
+	struct xe_sriov_vf_ccs_ctx *ctx;
+	struct xe_sa_manager *bb_pool;
+	u32 *cs;
+
+	xe_assert(xe, IS_SRIOV_VF(xe));
+
+	ctx = &xe->sriov.vf.ccs.contexts[read_write];
+	bb_pool = ctx->mem.ccs_bb_pool;
+
+	guard(mutex) (xe_sa_bo_swap_guard(bb_pool));
+	xe_sa_bo_swap_shadow(bb_pool);
+
+	cs = xe_sa_bo_cpu_addr(bb->bo);
+	memset(cs, MI_NOOP, bb->len * sizeof(u32));
+	xe_sriov_vf_ccs_rw_update_bb_addr(ctx);
+
+	xe_sa_bo_sync_shadow(bb->bo);
+
+	xe_bb_free(bb, NULL);
+	src_bo->bb_ccs[read_write] = NULL;
 }
 
 /**
diff --git a/drivers/gpu/drm/xe/xe_migrate.h b/drivers/gpu/drm/xe/xe_migrate.h
index bc55f650204b83..438c3bb66d9b24 100644
--- a/drivers/gpu/drm/xe/xe_migrate.h
+++ b/drivers/gpu/drm/xe/xe_migrate.h
@@ -131,6 +131,9 @@ int xe_migrate_ccs_rw_copy(struct xe_tile *tile, struct xe_exec_queue *q,
 			   struct xe_bo *src_bo,
 			   enum xe_sriov_vf_ccs_rw_ctxs read_write);
 
+void xe_migrate_ccs_rw_copy_clear(struct xe_bo *src_bo,
+				  enum xe_sriov_vf_ccs_rw_ctxs read_write);
+
 struct xe_lrc *xe_migrate_lrc(struct xe_migrate *migrate);
 struct xe_exec_queue *xe_migrate_exec_queue(struct xe_migrate *migrate);
 int xe_migrate_access_memory(struct xe_migrate *m, struct xe_bo *bo,
diff --git a/drivers/gpu/drm/xe/xe_sriov_vf_ccs.c b/drivers/gpu/drm/xe/xe_sriov_vf_ccs.c
index 1a7d767632dadf..d62156195f321b 100644
--- a/drivers/gpu/drm/xe/xe_sriov_vf_ccs.c
+++ b/drivers/gpu/drm/xe/xe_sriov_vf_ccs.c
@@ -148,7 +148,8 @@ static int alloc_bb_pool(struct xe_tile *tile, struct xe_sriov_vf_ccs_ctx *ctx)
 	xe_sriov_info(xe, "Allocating %s CCS BB pool size = %lldMB\n",
 		      ctx->ctx_id ? "Restore" : "Save", bb_pool_size / SZ_1M);
 
-	sa_manager = xe_sa_bo_manager_init(tile, bb_pool_size, SZ_16);
+	sa_manager = __xe_sa_bo_manager_init(tile, bb_pool_size, SZ_4K, SZ_16,
+					     XE_SA_BO_MANAGER_FLAG_SHADOW);
 
 	if (IS_ERR(sa_manager)) {
 		xe_sriov_err(xe, "Suballocator init failed with error: %pe\n",
@@ -314,6 +315,18 @@ int xe_sriov_vf_ccs_init(struct xe_device *xe)
 	return err;
 }
 
+#define XE_SRIOV_VF_CCS_RW_BB_ADDR_OFFSET	(2 * sizeof(u32))
+void xe_sriov_vf_ccs_rw_update_bb_addr(struct xe_sriov_vf_ccs_ctx *ctx)
+{
+	u64 addr = xe_sa_manager_gpu_addr(ctx->mem.ccs_bb_pool);
+	struct xe_lrc *lrc = xe_exec_queue_lrc(ctx->mig_q);
+	struct xe_device *xe = gt_to_xe(ctx->mig_q->gt);
+
+	xe_device_wmb(xe);
+	xe_map_wr(xe, &lrc->bo->vmap, XE_SRIOV_VF_CCS_RW_BB_ADDR_OFFSET, u32, addr);
+	xe_device_wmb(xe);
+}
+
 /**
  * xe_sriov_vf_ccs_attach_bo - Insert CCS read write commands in the BO.
  * @bo: the &buffer object to which batch buffer commands will be added.
@@ -374,9 +387,7 @@ int xe_sriov_vf_ccs_detach_bo(struct xe_bo *bo)
 		if (!bb)
 			continue;
 
-		memset(bb->cs, MI_NOOP, bb->len * sizeof(u32));
-		xe_bb_free(bb, NULL);
-		bo->bb_ccs[ctx_id] = NULL;
+		xe_migrate_ccs_rw_copy_clear(bo, ctx_id);
 	}
 	return 0;
 }
diff --git a/drivers/gpu/drm/xe/xe_sriov_vf_ccs.h b/drivers/gpu/drm/xe/xe_sriov_vf_ccs.h
index 0745c0ff022828..a9c6512f87034f 100644
--- a/drivers/gpu/drm/xe/xe_sriov_vf_ccs.h
+++ b/drivers/gpu/drm/xe/xe_sriov_vf_ccs.h
@@ -19,6 +19,7 @@ int xe_sriov_vf_ccs_attach_bo(struct xe_bo *bo);
 int xe_sriov_vf_ccs_detach_bo(struct xe_bo *bo);
 int xe_sriov_vf_ccs_register_context(struct xe_device *xe);
 void xe_sriov_vf_ccs_print(struct xe_device *xe, struct drm_printer *p);
+void xe_sriov_vf_ccs_rw_update_bb_addr(struct xe_sriov_vf_ccs_ctx *ctx);
 
 static inline bool xe_sriov_vf_ccs_ready(struct xe_device *xe)
 {
-- 
2.53.0



