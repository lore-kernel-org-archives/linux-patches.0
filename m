Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 019D9254B12;
	Thu, 17 Apr 2025 18:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744912867; cv=none; b=AcxeIOJmkEweADc8eOUWEnBc/5hpiFkA+q4yHWIHy/NQhMu5xo7DhQwu7whYPAR3LBJX04MvU6cI8qM99zKh6hwRPz76ZndV8djqShAE/VUh4uSWYvQk8qkxWtDCzltt8p6DBd8kVKf2Ow6XZnqHQNBALbNSV/DxJQQKHFwgOVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744912867; c=relaxed/simple;
	bh=ltgkpcauts5XMwMwIRKCcnXPDl0Pmr9X3JuqJ19bmGw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h6ImuLcCyz2NtdDZYj1HYzVyQVcRmsxbpkukwRR4ZVDkEnK3lB5e4WRi7IJrmyUp7ZiQ4C6M7UJTxi+DkxwVZTFzDBMVo/cmCxsrZIuK0b4p00alP5PUfVZ/IdxvqU8pd5H1uEhVgSSsOZ1Yliw83V6ZY0BUiTOY2SS/5mNThkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rDLlcJvW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rDLlcJvW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59058C4CEE4;
	Thu, 17 Apr 2025 18:01:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744912866;
	bh=ltgkpcauts5XMwMwIRKCcnXPDl0Pmr9X3JuqJ19bmGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rDLlcJvWNMgkRFU9bb6IcRTOZcikho4U9rHxf+5I1FdXe1l9VumDitu9G8jKxStOC
	 uhFbvtF+xUtObUT2rcb1P4wO3CvLaAwwOvI9QNC56MrO8FWGmnEhtaU3+ulfszJ6Ug
	 QsVlGfrPegnI1C+VdishsLebq+jFEFN1Qg380MZ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Wajdeczko <michal.wajdeczko@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 150/449] drm/xe/vf: Dont try to trigger a full GT reset if VF
Date: Thu, 17 Apr 2025 19:47:18 +0200
Message-ID: <20250417175124.011744575@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 9f4f27d1ef4a9..8a20e6744836c 100644
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
@@ -676,6 +677,9 @@ static int do_gt_reset(struct xe_gt *gt)
 {
 	int err;
 
+	if (IS_SRIOV_VF(gt_to_xe(gt)))
+		return xe_gt_sriov_vf_reset(gt);
+
 	xe_gsc_wa_14015076503(gt, true);
 
 	xe_mmio_write32(&gt->mmio, GDRST, GRDOM_FULL);
diff --git a/drivers/gpu/drm/xe/xe_gt_sriov_vf.c b/drivers/gpu/drm/xe/xe_gt_sriov_vf.c
index cca5d57328021..9c30cbd9af6e1 100644
--- a/drivers/gpu/drm/xe/xe_gt_sriov_vf.c
+++ b/drivers/gpu/drm/xe/xe_gt_sriov_vf.c
@@ -58,6 +58,22 @@ static int vf_reset_guc_state(struct xe_gt *gt)
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
index 912d208142616..ba6c5d74e326f 100644
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



