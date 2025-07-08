Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52DD02E5B27;
	Tue,  8 Jul 2025 16:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993175; cv=none; b=OzBybn/zMsXBdhYvsksB97FC/QMpP/F7cesbwtZgZNIkqbPY9H03vjzH1WIraw9HAeA+mQXkBWP9mbysfkYh2tR2sQkF+1rE8gW4OCVyixkkVJjTqgs2vJhgxQrpT/dUZ05JojE2ru4LTk+EDNKXcc9U14JZY3k2IOLHqZIrQFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993175; c=relaxed/simple;
	bh=fUn784yUzULkHAaUOp8XpQvrXs76aS1Ap2+j7tJQAso=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GeWVDyg1n9ZyKVHSDNFanYWyC7c1gxBmZBogQvOlP+v6EWAufTwrBUlFq97IicPcyrkNRU6/ZdCt7oJijws5tOT1+LDZwEvu+x3ncVb4fn5Q7HI/zXilEMqYUATdmLmgBq6vvjbW6vRiuP++8YNle4iqiAKZS70RxBlscys16yk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1iKzC9aC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1iKzC9aC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF471C4CEF0;
	Tue,  8 Jul 2025 16:46:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993175;
	bh=fUn784yUzULkHAaUOp8XpQvrXs76aS1Ap2+j7tJQAso=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1iKzC9aCJp2y2SE0ZzjS8OWcWTiW6QNdp8+ZsDLZ4gcbiyg5ACQjAfpaatv23qHOE
	 ABTtemUQ/X0CMafMuBdYtlY4v1nFuznwlVADRuYhcR6k93mlZ7n6SFL+xX87dJS5ru
	 MZLUcXIUSsXxmPHyuELpUzkWuufyp+gIGsGFKFNU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Vinay Belgaumkar <vinay.belgaumkar@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 196/232] drm/xe/bmg: Update Wa_22019338487
Date: Tue,  8 Jul 2025 18:23:12 +0200
Message-ID: <20250708162246.567301737@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
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

From: Vinay Belgaumkar <vinay.belgaumkar@intel.com>

[ Upstream commit 84c0b4a00610afbde650fdb8ad6db0424f7b2cc3 ]

Limit GT max frequency to 2600MHz and wait for frequency to reduce
before proceeding with a transient flush. This is really only needed for
the transient flush: if L2 flush is needed due to 16023588340 then
there's no need to do this additional wait since we are already using
the bigger hammer.

v2: Use generic names, ensure user set max frequency requests wait
for flush to complete (Rodrigo)
v3:
 - User requests wait via wait_var_event_timeout (Lucas)
 - Close races on flush + user requests (Lucas)
 - Fix xe_guc_pc_remove_flush_freq_limit() being called on last gt
   rather than root gt (Lucas)
v4:
 - Only apply the freq reducing part if a TDF is needed: L2 flush trumps
   the need for waiting a lower frequency

Fixes: aaa08078e725 ("drm/xe/bmg: Apply Wa_22019338487")
Reviewed-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Vinay Belgaumkar <vinay.belgaumkar@intel.com>
Link: https://lore.kernel.org/r/20250618-wa-22019338487-v5-4-b888388477f2@intel.com
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
(cherry picked from commit deea6a7d6d803d6bb874a3e6f1b312e560e6c6df)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_device.c       |  55 +++++-----
 drivers/gpu/drm/xe/xe_guc_pc.c       | 144 +++++++++++++++++++++++++++
 drivers/gpu/drm/xe/xe_guc_pc.h       |   2 +
 drivers/gpu/drm/xe/xe_guc_pc_types.h |   2 +
 4 files changed, 179 insertions(+), 24 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_device.c b/drivers/gpu/drm/xe/xe_device.c
index 0c3db53b93d8a..82da51a6616a1 100644
--- a/drivers/gpu/drm/xe/xe_device.c
+++ b/drivers/gpu/drm/xe/xe_device.c
@@ -37,6 +37,7 @@
 #include "xe_gt_printk.h"
 #include "xe_gt_sriov_vf.h"
 #include "xe_guc.h"
+#include "xe_guc_pc.h"
 #include "xe_hw_engine_group.h"
 #include "xe_hwmon.h"
 #include "xe_irq.h"
@@ -871,31 +872,37 @@ void xe_device_td_flush(struct xe_device *xe)
 	if (!IS_DGFX(xe) || GRAPHICS_VER(xe) < 20)
 		return;
 
-	if (XE_WA(xe_root_mmio_gt(xe), 16023588340)) {
+	gt = xe_root_mmio_gt(xe);
+	if (XE_WA(gt, 16023588340)) {
+		/* A transient flush is not sufficient: flush the L2 */
 		xe_device_l2_flush(xe);
-		return;
-	}
-
-	for_each_gt(gt, xe, id) {
-		if (xe_gt_is_media_type(gt))
-			continue;
-
-		if (xe_force_wake_get(gt_to_fw(gt), XE_FW_GT))
-			return;
-
-		xe_mmio_write32(gt, XE2_TDF_CTRL, TRANSIENT_FLUSH_REQUEST);
-		/*
-		 * FIXME: We can likely do better here with our choice of
-		 * timeout. Currently we just assume the worst case, i.e. 150us,
-		 * which is believed to be sufficient to cover the worst case
-		 * scenario on current platforms if all cache entries are
-		 * transient and need to be flushed..
-		 */
-		if (xe_mmio_wait32(gt, XE2_TDF_CTRL, TRANSIENT_FLUSH_REQUEST, 0,
-				   150, NULL, false))
-			xe_gt_err_once(gt, "TD flush timeout\n");
-
-		xe_force_wake_put(gt_to_fw(gt), XE_FW_GT);
+	} else {
+		xe_guc_pc_apply_flush_freq_limit(&gt->uc.guc.pc);
+		
+		/* Execute TDF flush on all graphics GTs */
+		for_each_gt(gt, xe, id) {
+			if (xe_gt_is_media_type(gt))
+				continue;
+
+			if (xe_force_wake_get(gt_to_fw(gt), XE_FW_GT))
+				return;
+
+			xe_mmio_write32(gt, XE2_TDF_CTRL, TRANSIENT_FLUSH_REQUEST);
+			/*
+			 * FIXME: We can likely do better here with our choice of
+			 * timeout. Currently we just assume the worst case, i.e. 150us,
+			 * which is believed to be sufficient to cover the worst case
+			 * scenario on current platforms if all cache entries are
+			 * transient and need to be flushed..
+			 */
+			if (xe_mmio_wait32(gt, XE2_TDF_CTRL, TRANSIENT_FLUSH_REQUEST, 0,
+					   150, NULL, false))
+				xe_gt_err_once(gt, "TD flush timeout\n");
+
+			xe_force_wake_put(gt_to_fw(gt), XE_FW_GT);
+		}
+		
+		xe_guc_pc_remove_flush_freq_limit(&xe_root_mmio_gt(xe)->uc.guc.pc);
 	}
 }
 
diff --git a/drivers/gpu/drm/xe/xe_guc_pc.c b/drivers/gpu/drm/xe/xe_guc_pc.c
index f978da8be35c2..af02803c145bf 100644
--- a/drivers/gpu/drm/xe/xe_guc_pc.c
+++ b/drivers/gpu/drm/xe/xe_guc_pc.c
@@ -6,6 +6,9 @@
 #include "xe_guc_pc.h"
 
 #include <linux/delay.h>
+#include <linux/jiffies.h>
+#include <linux/ktime.h>
+#include <linux/wait_bit.h>
 
 #include <drm/drm_managed.h>
 #include <generated/xe_wa_oob.h>
@@ -47,6 +50,12 @@
 
 #define LNL_MERT_FREQ_CAP	800
 #define BMG_MERT_FREQ_CAP	2133
+#define BMG_MIN_FREQ		1200
+#define BMG_MERT_FLUSH_FREQ_CAP	2600
+
+#define SLPC_RESET_TIMEOUT_MS 5 /* roughly 5ms, but no need for precision */
+#define SLPC_RESET_EXTENDED_TIMEOUT_MS 1000 /* To be used only at pc_start */
+#define SLPC_ACT_FREQ_TIMEOUT_MS 100
 
 /**
  * DOC: GuC Power Conservation (PC)
@@ -133,6 +142,36 @@ static int wait_for_pc_state(struct xe_guc_pc *pc,
 	return -ETIMEDOUT;
 }
 
+static int wait_for_flush_complete(struct xe_guc_pc *pc)
+{
+	const unsigned long timeout = msecs_to_jiffies(30);
+
+	if (!wait_var_event_timeout(&pc->flush_freq_limit,
+				    !atomic_read(&pc->flush_freq_limit),
+				    timeout))
+		return -ETIMEDOUT;
+
+	return 0;
+}
+
+static int wait_for_act_freq_limit(struct xe_guc_pc *pc, u32 freq)
+{
+	int timeout_us = SLPC_ACT_FREQ_TIMEOUT_MS * USEC_PER_MSEC;
+	int slept, wait = 10;
+
+	for (slept = 0; slept < timeout_us;) {
+		if (xe_guc_pc_get_act_freq(pc) <= freq)
+			return 0;
+
+		usleep_range(wait, wait << 1);
+		slept += wait;
+		wait <<= 1;
+		if (slept + wait > timeout_us)
+			wait = timeout_us - slept;
+	}
+
+	return -ETIMEDOUT;
+}
 static int pc_action_reset(struct xe_guc_pc *pc)
 {
 	struct xe_guc_ct *ct = pc_to_ct(pc);
@@ -584,6 +623,11 @@ int xe_guc_pc_set_max_freq(struct xe_guc_pc *pc, u32 freq)
 {
 	int ret;
 
+	if (XE_WA(pc_to_gt(pc), 22019338487)) {
+		if (wait_for_flush_complete(pc) != 0)
+			return -EAGAIN;
+	}
+
 	mutex_lock(&pc->freq_lock);
 	if (!pc->freq_ready) {
 		/* Might be in the middle of a gt reset */
@@ -793,6 +837,106 @@ static int pc_adjust_requested_freq(struct xe_guc_pc *pc)
 	return ret;
 }
 
+static bool needs_flush_freq_limit(struct xe_guc_pc *pc)
+{
+	struct xe_gt *gt = pc_to_gt(pc);
+
+	return  XE_WA(gt, 22019338487) &&
+		pc->rp0_freq > BMG_MERT_FLUSH_FREQ_CAP;
+}
+
+/**
+ * xe_guc_pc_apply_flush_freq_limit() - Limit max GT freq during L2 flush
+ * @pc: the xe_guc_pc object
+ *
+ * As per the WA, reduce max GT frequency during L2 cache flush
+ */
+void xe_guc_pc_apply_flush_freq_limit(struct xe_guc_pc *pc)
+{
+	struct xe_gt *gt = pc_to_gt(pc);
+	u32 max_freq;
+	int ret;
+
+	if (!needs_flush_freq_limit(pc))
+		return;
+
+	mutex_lock(&pc->freq_lock);
+
+	if (!pc->freq_ready) {
+		mutex_unlock(&pc->freq_lock);
+		return;
+	}
+
+	ret = pc_action_query_task_state(pc);
+	if (ret) {
+		mutex_unlock(&pc->freq_lock);
+		return;
+	}
+
+	max_freq = pc_get_max_freq(pc);
+	if (max_freq > BMG_MERT_FLUSH_FREQ_CAP) {
+		ret = pc_set_max_freq(pc, BMG_MERT_FLUSH_FREQ_CAP);
+		if (ret) {
+			xe_gt_err_once(gt, "Failed to cap max freq on flush to %u, %pe\n",
+				       BMG_MERT_FLUSH_FREQ_CAP, ERR_PTR(ret));
+			mutex_unlock(&pc->freq_lock);
+			return;
+		}
+
+		atomic_set(&pc->flush_freq_limit, 1);
+
+		/*
+		 * If user has previously changed max freq, stash that value to
+		 * restore later, otherwise use the current max. New user
+		 * requests wait on flush.
+		 */
+		if (pc->user_requested_max != 0)
+			pc->stashed_max_freq = pc->user_requested_max;
+		else
+			pc->stashed_max_freq = max_freq;
+	}
+
+	mutex_unlock(&pc->freq_lock);
+
+	/*
+	 * Wait for actual freq to go below the flush cap: even if the previous
+	 * max was below cap, the current one might still be above it
+	 */
+	ret = wait_for_act_freq_limit(pc, BMG_MERT_FLUSH_FREQ_CAP);
+	if (ret)
+		xe_gt_err_once(gt, "Actual freq did not reduce to %u, %pe\n",
+			       BMG_MERT_FLUSH_FREQ_CAP, ERR_PTR(ret));
+}
+
+/**
+ * xe_guc_pc_remove_flush_freq_limit() - Remove max GT freq limit after L2 flush completes.
+ * @pc: the xe_guc_pc object
+ *
+ * Retrieve the previous GT max frequency value.
+ */
+void xe_guc_pc_remove_flush_freq_limit(struct xe_guc_pc *pc)
+{
+	struct xe_gt *gt = pc_to_gt(pc);
+	int ret = 0;
+
+	if (!needs_flush_freq_limit(pc))
+		return;
+
+	if (!atomic_read(&pc->flush_freq_limit))
+		return;
+
+	mutex_lock(&pc->freq_lock);
+
+	ret = pc_set_max_freq(&gt->uc.guc.pc, pc->stashed_max_freq);
+	if (ret)
+		xe_gt_err_once(gt, "Failed to restore max freq %u:%d",
+			       pc->stashed_max_freq, ret);
+
+	atomic_set(&pc->flush_freq_limit, 0);
+	mutex_unlock(&pc->freq_lock);
+	wake_up_var(&pc->flush_freq_limit);
+}
+
 static int pc_set_mert_freq_cap(struct xe_guc_pc *pc)
 {
 	int ret = 0;
diff --git a/drivers/gpu/drm/xe/xe_guc_pc.h b/drivers/gpu/drm/xe/xe_guc_pc.h
index efda432fadfc8..7154b3aab0d84 100644
--- a/drivers/gpu/drm/xe/xe_guc_pc.h
+++ b/drivers/gpu/drm/xe/xe_guc_pc.h
@@ -34,5 +34,7 @@ u64 xe_guc_pc_mc6_residency(struct xe_guc_pc *pc);
 void xe_guc_pc_init_early(struct xe_guc_pc *pc);
 int xe_guc_pc_restore_stashed_freq(struct xe_guc_pc *pc);
 void xe_guc_pc_raise_unslice(struct xe_guc_pc *pc);
+void xe_guc_pc_apply_flush_freq_limit(struct xe_guc_pc *pc);
+void xe_guc_pc_remove_flush_freq_limit(struct xe_guc_pc *pc);
 
 #endif /* _XE_GUC_PC_H_ */
diff --git a/drivers/gpu/drm/xe/xe_guc_pc_types.h b/drivers/gpu/drm/xe/xe_guc_pc_types.h
index 13810be015db5..5b86d91296cb9 100644
--- a/drivers/gpu/drm/xe/xe_guc_pc_types.h
+++ b/drivers/gpu/drm/xe/xe_guc_pc_types.h
@@ -15,6 +15,8 @@
 struct xe_guc_pc {
 	/** @bo: GGTT buffer object that is shared with GuC PC */
 	struct xe_bo *bo;
+	/** @flush_freq_limit: 1 when max freq changes are limited by driver */
+	atomic_t flush_freq_limit;
 	/** @rp0_freq: HW RP0 frequency - The Maximum one */
 	u32 rp0_freq;
 	/** @rpe_freq: HW RPe frequency - The Efficient one */
-- 
2.39.5



