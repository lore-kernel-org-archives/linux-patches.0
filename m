Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE95B1F91E3;
	Mon, 22 Sep 2025 19:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570397; cv=none; b=DEm47fPPgujpDBTFeWZrm5IkJjkvtB0qbhLTTC+mxdGcvgT54ZSefjTALIVo2i42XsXujWw6tfSry68meuUSXe7dgKA8d5TrsufYnQ54WbSJiBf50+LmGAtAc9AvdbSKcjPp2hiZNG7JUaDJz5hMbTXWfxWMwR9Iha32iWlroro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570397; c=relaxed/simple;
	bh=edQxAS7TTxRzspsZI6Hr7X6ND+xH+SahxZpvKy11ZCU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aTo+z79r4ZhZI2zEcQpbTzzocUw60HxcCtiYnSFURBpFXHFo9tbyO7hqxzs5gOwiyPuc2hxiATJkArufdRMebh0OaM4tOJqQILslhVRCmi0qIm5CfFOKwLaA/g38kALU9ao8jqTqDDIH+enHWvfjwlp2kelOUvcEUVy6NF8YXwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PeAV4r1b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PeAV4r1b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00611C4CEF0;
	Mon, 22 Sep 2025 19:46:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758570397;
	bh=edQxAS7TTxRzspsZI6Hr7X6ND+xH+SahxZpvKy11ZCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PeAV4r1bcYWEOP5NtAWvefCYGwjfiRB0OvmkclcHq+bfcTKxw1shNz+RiG7wijaoM
	 hTVCwcHpO+wbS3jYbzrNSyoP8F7gNBOOIYgnaAjuSdwjBtpwKtTDywztgs9QDDiiXi
	 PKhmjEYci87KE0/FJbBz5U5OO7Zvy/4UT15lL1xg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	John Harrison <John.C.Harrison@Intel.com>,
	Vinay Belgaumkar <vinay.belgaumkar@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 125/149] drm/xe/guc: Set RCS/CCS yield policy
Date: Mon, 22 Sep 2025 21:30:25 +0200
Message-ID: <20250922192416.026821013@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192412.885919229@linuxfoundation.org>
References: <20250922192412.885919229@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>

[ Upstream commit 26caeae9fb482ec443753b4e3307e5122b60b850 ]

All recent platforms (including all the ones officially supported by the
Xe driver) do not allow concurrent execution of RCS and CCS workloads
from different address spaces, with the HW blocking the context switch
when it detects such a scenario.
The DUAL_QUEUE flag helps with this, by causing the GuC to not submit a
context it knows will not be able to execute. This, however, causes a new
problem: if RCS and CCS queues have pending workloads from different
address spaces, the GuC needs to choose from which of the 2 queues to
pick the next workload to execute. By default, the GuC prioritizes RCS
submissions over CCS ones, which can lead to CCS workloads being
significantly (or completely) starved of execution time.
The driver can tune this by setting a dedicated scheduling policy KLV;
this KLV allows the driver to specify a quantum (in ms) and a ratio
(percentage value between 0 and 100), and the GuC will prioritize the CCS
for that percentage of each quantum.
Given that we want to guarantee enough RCS throughput to avoid missing
frames, we set the yield policy to 20% of each 80ms interval.

v2: updated quantum and ratio, improved comment, use xe_guc_submit_disable
in gt_sanitize

Fixes: d9a1ae0d17bd ("drm/xe/guc: Enable WA_DUAL_QUEUE for newer platforms")
Signed-off-by: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: John Harrison <John.C.Harrison@Intel.com>
Cc: Vinay Belgaumkar <vinay.belgaumkar@intel.com>
Reviewed-by: John Harrison <John.C.Harrison@Intel.com>
Tested-by: Vinay Belgaumkar <vinay.belgaumkar@intel.com>
Link: https://lore.kernel.org/r/20250905235632.3333247-2-daniele.ceraolospurio@intel.com
(cherry picked from commit 88434448438e4302e272b2a2b810b42e05ea024b)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
[Rodrigo added #include "xe_guc_submit.h" while backporting]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/abi/guc_actions_abi.h |  1 +
 drivers/gpu/drm/xe/abi/guc_klvs_abi.h    | 25 +++++++++
 drivers/gpu/drm/xe/xe_gt.c               |  3 +-
 drivers/gpu/drm/xe/xe_guc.c              |  6 +--
 drivers/gpu/drm/xe/xe_guc_submit.c       | 66 ++++++++++++++++++++++++
 drivers/gpu/drm/xe/xe_guc_submit.h       |  2 +
 6 files changed, 98 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/xe/abi/guc_actions_abi.h b/drivers/gpu/drm/xe/abi/guc_actions_abi.h
index b55d4cfb483a1..4d9896e14649c 100644
--- a/drivers/gpu/drm/xe/abi/guc_actions_abi.h
+++ b/drivers/gpu/drm/xe/abi/guc_actions_abi.h
@@ -117,6 +117,7 @@ enum xe_guc_action {
 	XE_GUC_ACTION_ENTER_S_STATE = 0x501,
 	XE_GUC_ACTION_EXIT_S_STATE = 0x502,
 	XE_GUC_ACTION_GLOBAL_SCHED_POLICY_CHANGE = 0x506,
+	XE_GUC_ACTION_UPDATE_SCHEDULING_POLICIES_KLV = 0x509,
 	XE_GUC_ACTION_SCHED_CONTEXT = 0x1000,
 	XE_GUC_ACTION_SCHED_CONTEXT_MODE_SET = 0x1001,
 	XE_GUC_ACTION_SCHED_CONTEXT_MODE_DONE = 0x1002,
diff --git a/drivers/gpu/drm/xe/abi/guc_klvs_abi.h b/drivers/gpu/drm/xe/abi/guc_klvs_abi.h
index 5b2502bec2dcc..89034bc97ec5a 100644
--- a/drivers/gpu/drm/xe/abi/guc_klvs_abi.h
+++ b/drivers/gpu/drm/xe/abi/guc_klvs_abi.h
@@ -17,6 +17,7 @@
  *  | 0 | 31:16 | **KEY** - KLV key identifier                                 |
  *  |   |       |   - `GuC Self Config KLVs`_                                  |
  *  |   |       |   - `GuC Opt In Feature KLVs`_                               |
+ *  |   |       |   - `GuC Scheduling Policies KLVs`_                          |
  *  |   |       |   - `GuC VGT Policy KLVs`_                                   |
  *  |   |       |   - `GuC VF Configuration KLVs`_                             |
  *  |   |       |                                                              |
@@ -139,6 +140,30 @@ enum  {
 #define GUC_KLV_OPT_IN_FEATURE_EXT_CAT_ERR_TYPE_KEY 0x4001
 #define GUC_KLV_OPT_IN_FEATURE_EXT_CAT_ERR_TYPE_LEN 0u
 
+/**
+ * DOC: GuC Scheduling Policies KLVs
+ *
+ * `GuC KLV`_ keys available for use with UPDATE_SCHEDULING_POLICIES_KLV.
+ *
+ * _`GUC_KLV_SCHEDULING_POLICIES_RENDER_COMPUTE_YIELD` : 0x1001
+ *      Some platforms do not allow concurrent execution of RCS and CCS
+ *      workloads from different address spaces. By default, the GuC prioritizes
+ *      RCS submissions over CCS ones, which can lead to CCS workloads being
+ *      significantly (or completely) starved of execution time. This KLV allows
+ *      the driver to specify a quantum (in ms) and a ratio (percentage value
+ *      between 0 and 100), and the GuC will prioritize the CCS for that
+ *      percentage of each quantum. For example, specifying 100ms and 30% will
+ *      make the GuC prioritize the CCS for 30ms of every 100ms.
+ *      Note that this does not necessarly mean that RCS and CCS engines will
+ *      only be active for their percentage of the quantum, as the restriction
+ *      only kicks in if both classes are fully busy with non-compatible address
+ *      spaces; i.e., if one engine is idle or running the same address space,
+ *      a pending job on the other engine will still be submitted to the HW no
+ *      matter what the ratio is
+ */
+#define GUC_KLV_SCHEDULING_POLICIES_RENDER_COMPUTE_YIELD_KEY	0x1001
+#define GUC_KLV_SCHEDULING_POLICIES_RENDER_COMPUTE_YIELD_LEN	2u
+
 /**
  * DOC: GuC VGT Policy KLVs
  *
diff --git a/drivers/gpu/drm/xe/xe_gt.c b/drivers/gpu/drm/xe/xe_gt.c
index e3517ce2e18c1..eaf7569a7c1d1 100644
--- a/drivers/gpu/drm/xe/xe_gt.c
+++ b/drivers/gpu/drm/xe/xe_gt.c
@@ -41,6 +41,7 @@
 #include "xe_gt_topology.h"
 #include "xe_guc_exec_queue_types.h"
 #include "xe_guc_pc.h"
+#include "xe_guc_submit.h"
 #include "xe_hw_fence.h"
 #include "xe_hw_engine_class_sysfs.h"
 #include "xe_irq.h"
@@ -97,7 +98,7 @@ void xe_gt_sanitize(struct xe_gt *gt)
 	 * FIXME: if xe_uc_sanitize is called here, on TGL driver will not
 	 * reload
 	 */
-	gt->uc.guc.submission_state.enabled = false;
+	xe_guc_submit_disable(&gt->uc.guc);
 }
 
 static void xe_gt_enable_host_l2_vram(struct xe_gt *gt)
diff --git a/drivers/gpu/drm/xe/xe_guc.c b/drivers/gpu/drm/xe/xe_guc.c
index 2efc0298e1a4c..b9d21fdaad48b 100644
--- a/drivers/gpu/drm/xe/xe_guc.c
+++ b/drivers/gpu/drm/xe/xe_guc.c
@@ -825,9 +825,7 @@ int xe_guc_post_load_init(struct xe_guc *guc)
 			return ret;
 	}
 
-	guc->submission_state.enabled = true;
-
-	return 0;
+	return xe_guc_submit_enable(guc);
 }
 
 int xe_guc_reset(struct xe_guc *guc)
@@ -1521,7 +1519,7 @@ void xe_guc_sanitize(struct xe_guc *guc)
 {
 	xe_uc_fw_sanitize(&guc->fw);
 	xe_guc_ct_disable(&guc->ct);
-	guc->submission_state.enabled = false;
+	xe_guc_submit_disable(guc);
 }
 
 int xe_guc_reset_prepare(struct xe_guc *guc)
diff --git a/drivers/gpu/drm/xe/xe_guc_submit.c b/drivers/gpu/drm/xe/xe_guc_submit.c
index e670dcb0f0932..18ddbb7b98a15 100644
--- a/drivers/gpu/drm/xe/xe_guc_submit.c
+++ b/drivers/gpu/drm/xe/xe_guc_submit.c
@@ -32,6 +32,7 @@
 #include "xe_guc_ct.h"
 #include "xe_guc_exec_queue_types.h"
 #include "xe_guc_id_mgr.h"
+#include "xe_guc_klv_helpers.h"
 #include "xe_guc_submit_types.h"
 #include "xe_hw_engine.h"
 #include "xe_hw_fence.h"
@@ -316,6 +317,71 @@ int xe_guc_submit_init(struct xe_guc *guc, unsigned int num_ids)
 	return drmm_add_action_or_reset(&xe->drm, guc_submit_fini, guc);
 }
 
+/*
+ * Given that we want to guarantee enough RCS throughput to avoid missing
+ * frames, we set the yield policy to 20% of each 80ms interval.
+ */
+#define RC_YIELD_DURATION	80	/* in ms */
+#define RC_YIELD_RATIO		20	/* in percent */
+static u32 *emit_render_compute_yield_klv(u32 *emit)
+{
+	*emit++ = PREP_GUC_KLV_TAG(SCHEDULING_POLICIES_RENDER_COMPUTE_YIELD);
+	*emit++ = RC_YIELD_DURATION;
+	*emit++ = RC_YIELD_RATIO;
+
+	return emit;
+}
+
+#define SCHEDULING_POLICY_MAX_DWORDS 16
+static int guc_init_global_schedule_policy(struct xe_guc *guc)
+{
+	u32 data[SCHEDULING_POLICY_MAX_DWORDS];
+	u32 *emit = data;
+	u32 count = 0;
+	int ret;
+
+	if (GUC_SUBMIT_VER(guc) < MAKE_GUC_VER(1, 1, 0))
+		return 0;
+
+	*emit++ = XE_GUC_ACTION_UPDATE_SCHEDULING_POLICIES_KLV;
+
+	if (CCS_MASK(guc_to_gt(guc)))
+		emit = emit_render_compute_yield_klv(emit);
+
+	count = emit - data;
+	if (count > 1) {
+		xe_assert(guc_to_xe(guc), count <= SCHEDULING_POLICY_MAX_DWORDS);
+
+		ret = xe_guc_ct_send_block(&guc->ct, data, count);
+		if (ret < 0) {
+			xe_gt_err(guc_to_gt(guc),
+				  "failed to enable GuC sheduling policies: %pe\n",
+				  ERR_PTR(ret));
+			return ret;
+		}
+	}
+
+	return 0;
+}
+
+int xe_guc_submit_enable(struct xe_guc *guc)
+{
+	int ret;
+
+	ret = guc_init_global_schedule_policy(guc);
+	if (ret)
+		return ret;
+
+	guc->submission_state.enabled = true;
+
+	return 0;
+}
+
+void xe_guc_submit_disable(struct xe_guc *guc)
+{
+	guc->submission_state.enabled = false;
+}
+
 static void __release_guc_id(struct xe_guc *guc, struct xe_exec_queue *q, u32 xa_count)
 {
 	int i;
diff --git a/drivers/gpu/drm/xe/xe_guc_submit.h b/drivers/gpu/drm/xe/xe_guc_submit.h
index 9b71a986c6ca6..0d126b807c104 100644
--- a/drivers/gpu/drm/xe/xe_guc_submit.h
+++ b/drivers/gpu/drm/xe/xe_guc_submit.h
@@ -13,6 +13,8 @@ struct xe_exec_queue;
 struct xe_guc;
 
 int xe_guc_submit_init(struct xe_guc *guc, unsigned int num_ids);
+int xe_guc_submit_enable(struct xe_guc *guc);
+void xe_guc_submit_disable(struct xe_guc *guc);
 
 int xe_guc_submit_reset_prepare(struct xe_guc *guc);
 void xe_guc_submit_reset_wait(struct xe_guc *guc);
-- 
2.51.0



