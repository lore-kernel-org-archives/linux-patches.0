Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 058DA433A5;
	Thu, 17 Apr 2025 18:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915537; cv=none; b=Lb6/HGDGW4EPvcr/YuV2nVrO6OQ8+DKB5a7H9SkrKM7OmZ6VLsnyz7sWQS1b07Yf04aygPghXux3EUnWO7q5gn85Kp0ZZ8Xk0ux3BYMEoZB3g9BLl7BVUp1s9wgr5C826VMutoXKV+V5yJQKW4N+9V1BODmwABwIiThyOOIQzWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915537; c=relaxed/simple;
	bh=TC6nVFdAQWxPrvaSFkUCSzJKnugh+4EEOPw6z3yVPWU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KLjH5WSDvLs7naamftaRgA4guDQm9f89ZZpMsUZ76hi/IuX7/ZmnaSONMtHgSHoN3SID7I70zKibcZCOcbElR7prsCL3zMKdkqR31oJJPAGs/qzN3JcV/k/lwKSS0q72FTGDWgDVdMB3DNzRWfYzvjKszZWdnJ7yQ+q7YlPhLnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F+JsX08Y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F+JsX08Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88F45C4CEEA;
	Thu, 17 Apr 2025 18:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915536;
	bh=TC6nVFdAQWxPrvaSFkUCSzJKnugh+4EEOPw6z3yVPWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F+JsX08YsllgyGtZ30FWViWaJ/S0Qn/OM2aQgtGPtDnqMOqJmuZRkPKFhwnJSW4ZK
	 +liupTNWsd46yzi1Ws0M4cTZGp0+7VpsInAtZPa9q4SCMrW8vzHs7y5b/OJNNL028c
	 CpjruyEaM68y3L2s/3wYMsuGyF3e861e47CNQ9Eo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Wajdeczko <michal.wajdeczko@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 128/393] drm/xe/vf: Dont try to trigger a full GT reset if VF
Date: Thu, 17 Apr 2025 19:48:57 +0200
Message-ID: <20250417175112.738901791@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

From: Michal Wajdeczko <michal.wajdeczko@intel.com>

[ Upstream commit 459777724d306315070d24608fcd89aea85516d6 ]

VFs don't have access to the GDRST(0x941c) register that driver
uses to reset a GT. Attempt to trigger a reset using debugfs:

 $ cat /sys/kernel/debug/dri/0000:00:02.1/gt0/force_reset

or due to a hang condition detected by the driver leads to:

 [ ] xe 0000:00:02.1: [drm] GT0: trying reset from force_reset [xe]
 [ ] xe 0000:00:02.1: [drm] GT0: reset queued
 [ ] xe 0000:00:02.1: [drm] GT0: reset started
 [ ] ------------[ cut here ]------------
 [ ] xe 0000:00:02.1: [drm] GT0: VF is trying to write 0x1 to an inaccessible register 0x941c+0x0
 [ ] WARNING: CPU: 3 PID: 3069 at drivers/gpu/drm/xe/xe_gt_sriov_vf.c:996 xe_gt_sriov_vf_write32+0xc6/0x580 [xe]
 [ ] RIP: 0010:xe_gt_sriov_vf_write32+0xc6/0x580 [xe]
 [ ] Call Trace:
 [ ]  <TASK>
 [ ]  ? show_regs+0x6c/0x80
 [ ]  ? __warn+0x93/0x1c0
 [ ]  ? xe_gt_sriov_vf_write32+0xc6/0x580 [xe]
 [ ]  ? report_bug+0x182/0x1b0
 [ ]  ? handle_bug+0x6e/0xb0
 [ ]  ? exc_invalid_op+0x18/0x80
 [ ]  ? asm_exc_invalid_op+0x1b/0x20
 [ ]  ? xe_gt_sriov_vf_write32+0xc6/0x580 [xe]
 [ ]  ? xe_gt_sriov_vf_write32+0xc6/0x580 [xe]
 [ ]  ? xe_gt_tlb_invalidation_reset+0xef/0x110 [xe]
 [ ]  ? __mutex_unlock_slowpath+0x41/0x2e0
 [ ]  xe_mmio_write32+0x64/0x150 [xe]
 [ ]  do_gt_reset+0x2f/0xa0 [xe]
 [ ]  gt_reset_worker+0x14e/0x1e0 [xe]
 [ ]  process_one_work+0x21c/0x740
 [ ]  worker_thread+0x1db/0x3c0

Fix that by sending H2G VF_RESET(0x5507) action instead.

Closes: https://gitlab.freedesktop.org/drm/xe/kernel/-/issues/4078
Signed-off-by: Michal Wajdeczko <michal.wajdeczko@intel.com>
Reviewed-by: Lucas De Marchi <lucas.demarchi@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250131182502.852-1-michal.wajdeczko@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_gt.c          |  4 ++++
 drivers/gpu/drm/xe/xe_gt_sriov_vf.c | 16 ++++++++++++++++
 drivers/gpu/drm/xe/xe_gt_sriov_vf.h |  1 +
 3 files changed, 21 insertions(+)

diff --git a/drivers/gpu/drm/xe/xe_gt.c b/drivers/gpu/drm/xe/xe_gt.c
index 98fe8573e054e..17ba15132a984 100644
--- a/drivers/gpu/drm/xe/xe_gt.c
+++ b/drivers/gpu/drm/xe/xe_gt.c
@@ -32,6 +32,7 @@
 #include "xe_gt_pagefault.h"
 #include "xe_gt_printk.h"
 #include "xe_gt_sriov_pf.h"
+#include "xe_gt_sriov_vf.h"
 #include "xe_gt_sysfs.h"
 #include "xe_gt_tlb_invalidation.h"
 #include "xe_gt_topology.h"
@@ -647,6 +648,9 @@ static int do_gt_reset(struct xe_gt *gt)
 {
 	int err;
 
+	if (IS_SRIOV_VF(gt_to_xe(gt)))
+		return xe_gt_sriov_vf_reset(gt);
+
 	xe_gsc_wa_14015076503(gt, true);
 
 	xe_mmio_write32(gt, GDRST, GRDOM_FULL);
diff --git a/drivers/gpu/drm/xe/xe_gt_sriov_vf.c b/drivers/gpu/drm/xe/xe_gt_sriov_vf.c
index 4ebc82e607af6..f982d6f9f218d 100644
--- a/drivers/gpu/drm/xe/xe_gt_sriov_vf.c
+++ b/drivers/gpu/drm/xe/xe_gt_sriov_vf.c
@@ -57,6 +57,22 @@ static int vf_reset_guc_state(struct xe_gt *gt)
 	return err;
 }
 
+/**
+ * xe_gt_sriov_vf_reset - Reset GuC VF internal state.
+ * @gt: the &xe_gt
+ *
+ * It requires functional `GuC MMIO based communication`_.
+ *
+ * Return: 0 on success or a negative error code on failure.
+ */
+int xe_gt_sriov_vf_reset(struct xe_gt *gt)
+{
+	if (!xe_device_uc_enabled(gt_to_xe(gt)))
+		return -ENODEV;
+
+	return vf_reset_guc_state(gt);
+}
+
 static int guc_action_match_version(struct xe_guc *guc,
 				    u32 wanted_branch, u32 wanted_major, u32 wanted_minor,
 				    u32 *branch, u32 *major, u32 *minor, u32 *patch)
diff --git a/drivers/gpu/drm/xe/xe_gt_sriov_vf.h b/drivers/gpu/drm/xe/xe_gt_sriov_vf.h
index e541ce57bec24..576ff5e795a8b 100644
--- a/drivers/gpu/drm/xe/xe_gt_sriov_vf.h
+++ b/drivers/gpu/drm/xe/xe_gt_sriov_vf.h
@@ -12,6 +12,7 @@ struct drm_printer;
 struct xe_gt;
 struct xe_reg;
 
+int xe_gt_sriov_vf_reset(struct xe_gt *gt);
 int xe_gt_sriov_vf_bootstrap(struct xe_gt *gt);
 int xe_gt_sriov_vf_query_config(struct xe_gt *gt);
 int xe_gt_sriov_vf_connect(struct xe_gt *gt);
-- 
2.39.5



