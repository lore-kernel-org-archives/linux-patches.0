Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 655EE41F35E;
	Thu, 30 Jul 2026 15:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423803; cv=none; b=OPj2GqwkyXAOgEtZaMa8g8InQWUyHEzfed0nxTNhKhUVhMNoAvUgxNjfL+1wmN1jOyWBq6QyNbK8FNx8wCpxYA8Ts3jxogix/3TJBn5b8vOi3s9+vTobLpRhlnIXuiKSHktlngeGyiceM0LVe2XgG82KFEnDwm199slYeMAShNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423803; c=relaxed/simple;
	bh=O0D6Xg03qaZbkCgWeLMwSsy9XRPRjLKugnuPBTfQyyY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E9zwJjA667ESOzvl9+si7OBqzRCA2YC7mgiJvcPSxS7YAcGAhx/yXaa+maQXzvdF9ATffAeAmLEEo1rkwUBjBU4Q+c3tLvCxqnfwbtcmKPyjUl8lOGga4wFPfWqKp5IjSjZJPhtLAffLIeqSehvgjX0p5Wnq4AxMUBjozCnbHK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UDZlb7Wh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UDZlb7Wh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68A3A1F000E9;
	Thu, 30 Jul 2026 15:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423801;
	bh=Hes6L3pIS4LGd9t9L1ZSVFmcCduSOaz+O7RgpMQcInQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UDZlb7WhQvOGRcMUmza4XhYu3YKIvjyOXq3CPLCnLcH03FwUS4xpzZJ7JGmsqb4/v
	 UJqGzxp7JQKO7VuOdfU+xA5/sMtGpAwhbXGWy1r2zK5VRhXivvg0YA7XRSi5PbXc7Y
	 zfjqm1SIDG+G+VieNbJDqj7jc/6V0gXB2H9p87+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Wajdeczko <michal.wajdeczko@intel.com>,
	Matthew Auld <matthew.auld@intel.com>,
	=?UTF-8?q?Micha=C5=82=20Winiarski?= <michal.winiarski@intel.com>,
	Satyanarayana K V P <satyanarayana.k.v.p@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 127/675] drm/xe/vf: Fix VF CCS attach/detach race with in-flight BO moves
Date: Thu, 30 Jul 2026 16:07:37 +0200
Message-ID: <20260730141447.844876923@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Brost <matthew.brost@intel.com>

[ Upstream commit 56441f9e08ad68697295b8835266d2bc48ab59b5 ]

xe_bo_move() attaches VF CCS read/write batch buffers (BBs) to a BO
after it transitions NULL/SYSTEM -> TT, and detaches them after it
transitions TT -> SYSTEM. Both operations were done synchronously on
the CPU immediately after building the move's copy/clear fence,
without waiting for that fence to signal. This creates two races with
VF migration:

- Attach happens too late relative to the copy job it is meant to
  protect. If the copy job is submitted before the CCS BBs are
  attached, a VF migration event that pauses execution mid-copy can
  observe partially copied CCS metadata without the attach state
  needed to correctly save/restore it.

- Detach happens too early relative to the copy job that moves data
  out of TT. The CCS BBs are torn down right after the copy fence is
  obtained, while the actual blit may still be in flight. A VF
  migration event that pauses execution mid-copy can then race the
  save/restore path against the still-running blit, and the CCS BBs
  it would need to make sense of the paused state have already been
  removed.

Fix both races:

- Move the attach call to before the copy/clear job is submitted, so
  the CCS BBs are already registered by the time the copy runs. On
  attach failure, unwind and bail out of the move. xe_migrate_ccs_rw_copy()
  now takes the destination resource explicitly, since bo->ttm.resource
  is not updated to the new resource until after the move commits.

- Detach only after explicitly waiting for the copy fence to signal,
  instead of tearing down the CCS BBs immediately after obtaining it.

While here, also fix xe_sriov_vf_ccs_attach_bo() to properly unwind and
propagate errors: the per-context loop previously never broke out on
error, silently discarding earlier failures. Unwind by clearing each
attached context directly via xe_migrate_ccs_rw_copy_clear() instead of
reusing xe_sriov_vf_ccs_detach_bo(), which requires both contexts to be
attached before it will clean up either one.

Fixes: 864690cf4dd6 ("drm/xe/vf: Attach and detach CCS copy commands with BO")
Cc: Michal Wajdeczko <michal.wajdeczko@intel.com>
Cc: Matthew Auld <matthew.auld@intel.com>
Cc: Michał Winiarski <michal.winiarski@intel.com>
Cc: Satyanarayana K V P <satyanarayana.k.v.p@intel.com>
Assisted-by: GitHub_Copilot:claude-sonnet-5
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Acked-by: Satyanarayana K V P <satyanarayana.k.v.p@intel.com>
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
Link: https://patch.msgid.link/20260714062440.3421225-1-matthew.brost@intel.com
(cherry picked from commit d45ad0aa7a1eb5d7288b5ed948b05695611dc39e)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_bo.c           | 34 +++++++++++++++++++---------
 drivers/gpu/drm/xe/xe_migrate.c      |  5 +++-
 drivers/gpu/drm/xe/xe_migrate.h      |  1 +
 drivers/gpu/drm/xe/xe_sriov_vf_ccs.c | 20 ++++++++++++++--
 drivers/gpu/drm/xe/xe_sriov_vf_ccs.h |  3 ++-
 5 files changed, 48 insertions(+), 15 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_bo.c b/drivers/gpu/drm/xe/xe_bo.c
index 0dabe85351392e..1d46b61bf1285d 100644
--- a/drivers/gpu/drm/xe/xe_bo.c
+++ b/drivers/gpu/drm/xe/xe_bo.c
@@ -930,6 +930,21 @@ static int xe_bo_move(struct ttm_buffer_object *ttm_bo, bool evict,
 		xe_pm_runtime_get_noresume(xe);
 	}
 
+	/*
+	 * Attach CCS BBs before submitting the copy job below so a VF
+	 * migration racing the copy sees valid, up to date attach state.
+	 */
+	if (IS_VF_CCS_READY(xe) &&
+	    ((move_lacks_source && new_mem->mem_type == XE_PL_TT) ||
+	     (old_mem_type == XE_PL_SYSTEM && new_mem->mem_type == XE_PL_TT)) &&
+	    handle_system_ccs) {
+		ret = xe_sriov_vf_ccs_attach_bo(bo, new_mem);
+		if (ret) {
+			xe_pm_runtime_put(xe);
+			goto out;
+		}
+	}
+
 	if (move_lacks_source) {
 		u32 flags = 0;
 
@@ -967,22 +982,19 @@ static int xe_bo_move(struct ttm_buffer_object *ttm_bo, bool evict,
 		ttm_bo_move_null(ttm_bo, new_mem);
 	}
 
-	dma_fence_put(fence);
-	xe_pm_runtime_put(xe);
-
 	/*
-	 * CCS meta data is migrated from TT -> SMEM. So, let us detach the
-	 * BBs from BO as it is no longer needed.
+	 * Detach must wait for the copy above to complete: a VF migration
+	 * racing an in-flight copy must still see valid CCS BBs, so don't
+	 * tear them down until the copy fence has signaled.
 	 */
 	if (IS_VF_CCS_READY(xe) && old_mem_type == XE_PL_TT &&
-	    new_mem->mem_type == XE_PL_SYSTEM)
+	    new_mem->mem_type == XE_PL_SYSTEM) {
+		dma_fence_wait(fence, false);
 		xe_sriov_vf_ccs_detach_bo(bo);
+	}
 
-	if (IS_VF_CCS_READY(xe) &&
-	    ((move_lacks_source && new_mem->mem_type == XE_PL_TT) ||
-	     (old_mem_type == XE_PL_SYSTEM && new_mem->mem_type == XE_PL_TT)) &&
-	    handle_system_ccs)
-		ret = xe_sriov_vf_ccs_attach_bo(bo);
+	dma_fence_put(fence);
+	xe_pm_runtime_put(xe);
 
 out:
 	if ((!ttm_bo->resource || ttm_bo->resource->mem_type == XE_PL_SYSTEM) &&
diff --git a/drivers/gpu/drm/xe/xe_migrate.c b/drivers/gpu/drm/xe/xe_migrate.c
index 6a0c088d09fb33..e0a14360d312e0 100644
--- a/drivers/gpu/drm/xe/xe_migrate.c
+++ b/drivers/gpu/drm/xe/xe_migrate.c
@@ -1001,6 +1001,8 @@ static int emit_flush_invalidate(struct xe_exec_queue *q, u32 *dw, int i,
  * @tile: Tile whose migration context to be used.
  * @q : Execution to be used along with migration context.
  * @src_bo: The buffer object @src is currently bound to.
+ * @new_mem: The (not yet committed) destination resource @src_bo is being
+ *          moved into; src_bo->ttm.resource is still the old resource.
  * @read_write : Creates BB commands for CCS read/write.
  *
  * Creates batch buffer instructions to copy CCS metadata from CCS pool to
@@ -1012,12 +1014,13 @@ static int emit_flush_invalidate(struct xe_exec_queue *q, u32 *dw, int i,
  */
 int xe_migrate_ccs_rw_copy(struct xe_tile *tile, struct xe_exec_queue *q,
 			   struct xe_bo *src_bo,
+			   struct ttm_resource *new_mem,
 			   enum xe_sriov_vf_ccs_rw_ctxs read_write)
 
 {
 	bool src_is_pltt = read_write == XE_SRIOV_VF_CCS_READ_CTX;
 	bool dst_is_pltt = read_write == XE_SRIOV_VF_CCS_WRITE_CTX;
-	struct ttm_resource *src = src_bo->ttm.resource;
+	struct ttm_resource *src = new_mem;
 	struct xe_migrate *m = tile->migrate;
 	struct xe_gt *gt = tile->primary_gt;
 	u32 batch_size, batch_size_allocated;
diff --git a/drivers/gpu/drm/xe/xe_migrate.h b/drivers/gpu/drm/xe/xe_migrate.h
index 438c3bb66d9b24..8bac669685ee92 100644
--- a/drivers/gpu/drm/xe/xe_migrate.h
+++ b/drivers/gpu/drm/xe/xe_migrate.h
@@ -129,6 +129,7 @@ struct dma_fence *xe_migrate_copy(struct xe_migrate *m,
 
 int xe_migrate_ccs_rw_copy(struct xe_tile *tile, struct xe_exec_queue *q,
 			   struct xe_bo *src_bo,
+			   struct ttm_resource *new_mem,
 			   enum xe_sriov_vf_ccs_rw_ctxs read_write);
 
 void xe_migrate_ccs_rw_copy_clear(struct xe_bo *src_bo,
diff --git a/drivers/gpu/drm/xe/xe_sriov_vf_ccs.c b/drivers/gpu/drm/xe/xe_sriov_vf_ccs.c
index d62156195f321b..e03714ef7ae996 100644
--- a/drivers/gpu/drm/xe/xe_sriov_vf_ccs.c
+++ b/drivers/gpu/drm/xe/xe_sriov_vf_ccs.c
@@ -330,6 +330,8 @@ void xe_sriov_vf_ccs_rw_update_bb_addr(struct xe_sriov_vf_ccs_ctx *ctx)
 /**
  * xe_sriov_vf_ccs_attach_bo - Insert CCS read write commands in the BO.
  * @bo: the &buffer object to which batch buffer commands will be added.
+ * @new_mem: the (not yet committed) destination resource @bo is being moved
+ *          into; bo->ttm.resource is still the old resource at this point.
  *
  * This function shall be called only by VF. It inserts the PTEs and copy
  * command instructions in the BO by calling xe_migrate_ccs_rw_copy()
@@ -337,7 +339,7 @@ void xe_sriov_vf_ccs_rw_update_bb_addr(struct xe_sriov_vf_ccs_ctx *ctx)
  *
  * Returns: 0 if successful, negative error code on failure.
  */
-int xe_sriov_vf_ccs_attach_bo(struct xe_bo *bo)
+int xe_sriov_vf_ccs_attach_bo(struct xe_bo *bo, struct ttm_resource *new_mem)
 {
 	struct xe_device *xe = xe_bo_device(bo);
 	enum xe_sriov_vf_ccs_rw_ctxs ctx_id;
@@ -356,7 +358,21 @@ int xe_sriov_vf_ccs_attach_bo(struct xe_bo *bo)
 		xe_assert(xe, !bb);
 
 		ctx = &xe->sriov.vf.ccs.contexts[ctx_id];
-		err = xe_migrate_ccs_rw_copy(tile, ctx->mig_q, bo, ctx_id);
+		err = xe_migrate_ccs_rw_copy(tile, ctx->mig_q, bo, new_mem, ctx_id);
+		if (err)
+			goto err_unwind;
+	}
+	return 0;
+
+err_unwind:
+	/*
+	 * Clean up any contexts already attached. Can't reuse
+	 * xe_sriov_vf_ccs_detach_bo() here as it requires both contexts
+	 * attached before cleaning up either one.
+	 */
+	for_each_ccs_rw_ctx(ctx_id) {
+		if (bo->bb_ccs[ctx_id])
+			xe_migrate_ccs_rw_copy_clear(bo, ctx_id);
 	}
 	return err;
 }
diff --git a/drivers/gpu/drm/xe/xe_sriov_vf_ccs.h b/drivers/gpu/drm/xe/xe_sriov_vf_ccs.h
index a9c6512f87034f..00d2c9dbe00d9a 100644
--- a/drivers/gpu/drm/xe/xe_sriov_vf_ccs.h
+++ b/drivers/gpu/drm/xe/xe_sriov_vf_ccs.h
@@ -11,11 +11,12 @@
 #include "xe_sriov_vf_ccs_types.h"
 
 struct drm_printer;
+struct ttm_resource;
 struct xe_device;
 struct xe_bo;
 
 int xe_sriov_vf_ccs_init(struct xe_device *xe);
-int xe_sriov_vf_ccs_attach_bo(struct xe_bo *bo);
+int xe_sriov_vf_ccs_attach_bo(struct xe_bo *bo, struct ttm_resource *new_mem);
 int xe_sriov_vf_ccs_detach_bo(struct xe_bo *bo);
 int xe_sriov_vf_ccs_register_context(struct xe_device *xe);
 void xe_sriov_vf_ccs_print(struct xe_device *xe, struct drm_printer *p);
-- 
2.53.0



