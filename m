Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B96B2E9ECA;
	Tue, 22 Jul 2025 14:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193013; cv=none; b=mqPkBYfUqDWSLt8CxTV4fUSVEGsyJP9i20Dv2t9KWtkRl2P8inIBoyCaJ20CUAbkJQTN3fSmqjV7ySdkY9Z9g9LOrzCZPnIlcXbM2bGg/xiqUeS8VmoxRhuZNtYlfmTYkY8h9CQ8WQAlKAjyp4d9+JLIbViTI/nBW9V3Z7lQDpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193013; c=relaxed/simple;
	bh=6Cr7NhAZeHoRkRm0L9f2oHerul0luAFkx4Qks6lqjgA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QeQ2WH1y+12aRiODlNNtJCdjYdAWejBrNy+OmKN0TY63GQFQsR6Uqad2itsxj8Fis0wL0Ph+DUVnEpamqBPInhJLtKwgoNseIURJW8SHUYNKHmxNNAFaVVZygJfHRUaOykyo1EAwUzJPfXPckU54MwNCH4HXc6F8cBucnTowbBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2jF9iPAr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2jF9iPAr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BB1AC4CEEB;
	Tue, 22 Jul 2025 14:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193012;
	bh=6Cr7NhAZeHoRkRm0L9f2oHerul0luAFkx4Qks6lqjgA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2jF9iPAr7E2XwVfjmRGe2HV2C2XqHa+/xqAZCp9Z3laHk4eVd3rIbmBth0rPzXDWV
	 3tbhk8CsXUOOelQfZCzUJhtJ8KBqd6PbuRpPEaWrIWdb+5GBjb2AgDChVm/xDzF0e7
	 QaxmU/esPvEAxjQBM37hhIpibT23LkaBSiSvORlU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Wajdeczko <michal.wajdeczko@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	=?UTF-8?q?Micha=C5=82=20Winiarski?= <michal.winiarski@intel.com>,
	Stuart Summers <stuart.summers@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 124/158] drm/xe/pf: Move VFs reprovisioning to worker
Date: Tue, 22 Jul 2025 15:45:08 +0200
Message-ID: <20250722134345.362612294@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134340.596340262@linuxfoundation.org>
References: <20250722134340.596340262@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Wajdeczko <michal.wajdeczko@intel.com>

[ Upstream commit a4d1c5d0b99b75263a5626d2e52d569db3844b33 ]

Since the GuC is reset during GT reset, we need to re-send the
entire SR-IOV provisioning configuration to the GuC. But since
this whole configuration is protected by the PF master mutex and
we can't avoid making allocations under this mutex (like during
LMEM provisioning), we can't do this reprovisioning from gt-reset
path if we want to be reclaim-safe. Move VFs reprovisioning to a
async worker that we will start from the gt-reset path.

Signed-off-by: Michal Wajdeczko <michal.wajdeczko@intel.com>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Michał Winiarski <michal.winiarski@intel.com>
Reviewed-by: Stuart Summers <stuart.summers@intel.com>
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250125215505.720-1-michal.wajdeczko@intel.com
Stable-dep-of: 81dccec448d2 ("drm/xe/pf: Prepare to stop SR-IOV support prior GT reset")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_gt_sriov_pf.c       | 43 +++++++++++++++++++++--
 drivers/gpu/drm/xe/xe_gt_sriov_pf_types.h | 10 ++++++
 2 files changed, 51 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_gt_sriov_pf.c b/drivers/gpu/drm/xe/xe_gt_sriov_pf.c
index 919d960165d51..1c3ba7dcb4ace 100644
--- a/drivers/gpu/drm/xe/xe_gt_sriov_pf.c
+++ b/drivers/gpu/drm/xe/xe_gt_sriov_pf.c
@@ -14,7 +14,11 @@
 #include "xe_gt_sriov_pf_control.h"
 #include "xe_gt_sriov_pf_helpers.h"
 #include "xe_gt_sriov_pf_service.h"
+#include "xe_gt_sriov_printk.h"
 #include "xe_mmio.h"
+#include "xe_pm.h"
+
+static void pf_worker_restart_func(struct work_struct *w);
 
 /*
  * VF's metadata is maintained in the flexible array where:
@@ -40,6 +44,11 @@ static int pf_alloc_metadata(struct xe_gt *gt)
 	return 0;
 }
 
+static void pf_init_workers(struct xe_gt *gt)
+{
+	INIT_WORK(&gt->sriov.pf.workers.restart, pf_worker_restart_func);
+}
+
 /**
  * xe_gt_sriov_pf_init_early - Prepare SR-IOV PF data structures on PF.
  * @gt: the &xe_gt to initialize
@@ -64,6 +73,8 @@ int xe_gt_sriov_pf_init_early(struct xe_gt *gt)
 	if (err)
 		return err;
 
+	pf_init_workers(gt);
+
 	return 0;
 }
 
@@ -141,6 +152,35 @@ void xe_gt_sriov_pf_sanitize_hw(struct xe_gt *gt, unsigned int vfid)
 	pf_clear_vf_scratch_regs(gt, vfid);
 }
 
+static void pf_restart(struct xe_gt *gt)
+{
+	struct xe_device *xe = gt_to_xe(gt);
+
+	xe_pm_runtime_get(xe);
+	xe_gt_sriov_pf_config_restart(gt);
+	xe_gt_sriov_pf_control_restart(gt);
+	xe_pm_runtime_put(xe);
+
+	xe_gt_sriov_dbg(gt, "restart completed\n");
+}
+
+static void pf_worker_restart_func(struct work_struct *w)
+{
+	struct xe_gt *gt = container_of(w, typeof(*gt), sriov.pf.workers.restart);
+
+	pf_restart(gt);
+}
+
+static void pf_queue_restart(struct xe_gt *gt)
+{
+	struct xe_device *xe = gt_to_xe(gt);
+
+	xe_gt_assert(gt, IS_SRIOV_PF(xe));
+
+	if (!queue_work(xe->sriov.wq, &gt->sriov.pf.workers.restart))
+		xe_gt_sriov_dbg(gt, "restart already in queue!\n");
+}
+
 /**
  * xe_gt_sriov_pf_restart - Restart SR-IOV support after a GT reset.
  * @gt: the &xe_gt
@@ -149,6 +189,5 @@ void xe_gt_sriov_pf_sanitize_hw(struct xe_gt *gt, unsigned int vfid)
  */
 void xe_gt_sriov_pf_restart(struct xe_gt *gt)
 {
-	xe_gt_sriov_pf_config_restart(gt);
-	xe_gt_sriov_pf_control_restart(gt);
+	pf_queue_restart(gt);
 }
diff --git a/drivers/gpu/drm/xe/xe_gt_sriov_pf_types.h b/drivers/gpu/drm/xe/xe_gt_sriov_pf_types.h
index 28e1b130bf87c..a69d128c4f45a 100644
--- a/drivers/gpu/drm/xe/xe_gt_sriov_pf_types.h
+++ b/drivers/gpu/drm/xe/xe_gt_sriov_pf_types.h
@@ -31,8 +31,17 @@ struct xe_gt_sriov_metadata {
 	struct xe_gt_sriov_pf_service_version version;
 };
 
+/**
+ * struct xe_gt_sriov_pf_workers - GT level workers used by the PF.
+ */
+struct xe_gt_sriov_pf_workers {
+	/** @restart: worker that executes actions post GT reset */
+	struct work_struct restart;
+};
+
 /**
  * struct xe_gt_sriov_pf - GT level PF virtualization data.
+ * @workers: workers data.
  * @service: service data.
  * @control: control data.
  * @policy: policy data.
@@ -40,6 +49,7 @@ struct xe_gt_sriov_metadata {
  * @vfs: metadata for all VFs.
  */
 struct xe_gt_sriov_pf {
+	struct xe_gt_sriov_pf_workers workers;
 	struct xe_gt_sriov_pf_service service;
 	struct xe_gt_sriov_pf_control control;
 	struct xe_gt_sriov_pf_policy policy;
-- 
2.39.5



