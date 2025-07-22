Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BECA23AB9D;
	Tue, 22 Jul 2025 14:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193018; cv=none; b=uyQD4BVIhwC0htDsWvFaBz+wZOoofpQ5HoqL560lnvaJrABLfku1gjeIw25KD7mjYBfNrNCoYv18TmkKzRJZIRZ1kxiSUlOwBEfrL8Wy91ZhRXBvZUjN6Uk+cWpmvUvoOqzxBPNjjmIjWwhS1Xc8Hv/G4StMNjiXzhrKuNOzdgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193018; c=relaxed/simple;
	bh=1w9MuOiBHIbu1RvMWtY8b0z8bqnPl90fEQu6hwhE9A8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RCNmU+nhe+it9xXwC0rwmgtqgIINls/A9GncoDqVjAm04ikHO2+OwZos9+8akBYt1qCUmzSBuecS6iDy3iY8qq3Xica1sYYEP3U65O/TKUD5UBYm8cf4fjsSKhWjyFWMZAFoFQmzW6/jJVPb/PAdxOQi7UOxKTq+5Tnvg7WnOLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VPtma98G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VPtma98G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85F14C4CEEB;
	Tue, 22 Jul 2025 14:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193017;
	bh=1w9MuOiBHIbu1RvMWtY8b0z8bqnPl90fEQu6hwhE9A8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VPtma98G1Sh93/OvO5lR+Hi5qk12FjADzduo6ch3bA9OHELEJ6xNL6XcP+Oflb5IY
	 VK2riN2BFvU1nnepvcZKBCGo99p/RfaxA+4TUqdy2itKAvfSW/eDP7dh6u8A1C/7fR
	 4pgvkdFq2taBmdgNlbRezeSDuZK7mdSR4dcJN4LA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Wajdeczko <michal.wajdeczko@intel.com>,
	=?UTF-8?q?Piotr=20Pi=C3=B3rkowski?= <piotr.piorkowski@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 125/158] drm/xe/pf: Prepare to stop SR-IOV support prior GT reset
Date: Tue, 22 Jul 2025 15:45:09 +0200
Message-ID: <20250722134345.399908789@linuxfoundation.org>
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

[ Upstream commit 81dccec448d204e448ae83e1fe60e8aaeaadadb8 ]

As part of the resume or GT reset, the PF driver schedules work
which is then used to complete restarting of the SR-IOV support,
including resending to the GuC configurations of provisioned VFs.

However, in case of short delay between those two actions, which
could be seen by triggering a GT reset on the suspened device:

 $ echo 1 > /sys/kernel/debug/dri/0000:00:02.0/gt0/force_reset

this PF worker might be still busy, which lead to errors due to
just stopped or disabled GuC CTB communication:

 [ ] xe 0000:00:02.0: [drm:xe_gt_resume [xe]] GT0: resumed
 [ ] xe 0000:00:02.0: [drm] GT0: trying reset from force_reset_show [xe]
 [ ] xe 0000:00:02.0: [drm] GT0: reset queued
 [ ] xe 0000:00:02.0: [drm] GT0: reset started
 [ ] xe 0000:00:02.0: [drm:guc_ct_change_state [xe]] GT0: GuC CT communication channel stopped
 [ ] xe 0000:00:02.0: [drm:guc_ct_send_recv [xe]] GT0: H2G request 0x5503 canceled!
 [ ] xe 0000:00:02.0: [drm] GT0: PF: Failed to push VF1 12 config KLVs (-ECANCELED)
 [ ] xe 0000:00:02.0: [drm] GT0: PF: Failed to push VF1 configuration (-ECANCELED)
 [ ] xe 0000:00:02.0: [drm:guc_ct_change_state [xe]] GT0: GuC CT communication channel disabled
 [ ] xe 0000:00:02.0: [drm] GT0: PF: Failed to push VF2 12 config KLVs (-ENODEV)
 [ ] xe 0000:00:02.0: [drm] GT0: PF: Failed to push VF2 configuration (-ENODEV)
 [ ] xe 0000:00:02.0: [drm] GT0: PF: Failed to push 2 of 2 VFs configurations
 [ ] xe 0000:00:02.0: [drm:pf_worker_restart_func [xe]] GT0: PF: restart completed

While this VFs reprovisioning will be successful during next spin
of the worker, to avoid those errors, make sure to cancel restart
worker if we are about to trigger next reset.

Fixes: 411220808cee ("drm/xe/pf: Restart VFs provisioning after GT reset")
Signed-off-by: Michal Wajdeczko <michal.wajdeczko@intel.com>
Reviewed-by: Piotr Piórkowski <piotr.piorkowski@intel.com>
Link: https://lore.kernel.org/r/20250711193316.1920-2-michal.wajdeczko@intel.com
(cherry picked from commit 9f50b729dd61dfb9f4d7c66900d22a7c7353a8c0)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_gt.c          |  3 +++
 drivers/gpu/drm/xe/xe_gt_sriov_pf.c | 19 +++++++++++++++++++
 drivers/gpu/drm/xe/xe_gt_sriov_pf.h |  5 +++++
 3 files changed, 27 insertions(+)

diff --git a/drivers/gpu/drm/xe/xe_gt.c b/drivers/gpu/drm/xe/xe_gt.c
index 231ed53cf907c..30d027e6ec274 100644
--- a/drivers/gpu/drm/xe/xe_gt.c
+++ b/drivers/gpu/drm/xe/xe_gt.c
@@ -773,6 +773,9 @@ static int gt_reset(struct xe_gt *gt)
 		goto err_out;
 	}
 
+	if (IS_SRIOV_PF(gt_to_xe(gt)))
+		xe_gt_sriov_pf_stop_prepare(gt);
+
 	xe_uc_gucrc_disable(&gt->uc);
 	xe_uc_stop_prepare(&gt->uc);
 	xe_gt_pagefault_reset(gt);
diff --git a/drivers/gpu/drm/xe/xe_gt_sriov_pf.c b/drivers/gpu/drm/xe/xe_gt_sriov_pf.c
index 1c3ba7dcb4ace..57e9eddc092e1 100644
--- a/drivers/gpu/drm/xe/xe_gt_sriov_pf.c
+++ b/drivers/gpu/drm/xe/xe_gt_sriov_pf.c
@@ -152,6 +152,25 @@ void xe_gt_sriov_pf_sanitize_hw(struct xe_gt *gt, unsigned int vfid)
 	pf_clear_vf_scratch_regs(gt, vfid);
 }
 
+static void pf_cancel_restart(struct xe_gt *gt)
+{
+	xe_gt_assert(gt, IS_SRIOV_PF(gt_to_xe(gt)));
+
+	if (cancel_work_sync(&gt->sriov.pf.workers.restart))
+		xe_gt_sriov_dbg_verbose(gt, "pending restart canceled!\n");
+}
+
+/**
+ * xe_gt_sriov_pf_stop_prepare() - Prepare to stop SR-IOV support.
+ * @gt: the &xe_gt
+ *
+ * This function can only be called on the PF.
+ */
+void xe_gt_sriov_pf_stop_prepare(struct xe_gt *gt)
+{
+	pf_cancel_restart(gt);
+}
+
 static void pf_restart(struct xe_gt *gt)
 {
 	struct xe_device *xe = gt_to_xe(gt);
diff --git a/drivers/gpu/drm/xe/xe_gt_sriov_pf.h b/drivers/gpu/drm/xe/xe_gt_sriov_pf.h
index 96fab779a906f..165ba31d03913 100644
--- a/drivers/gpu/drm/xe/xe_gt_sriov_pf.h
+++ b/drivers/gpu/drm/xe/xe_gt_sriov_pf.h
@@ -12,6 +12,7 @@ struct xe_gt;
 int xe_gt_sriov_pf_init_early(struct xe_gt *gt);
 void xe_gt_sriov_pf_init_hw(struct xe_gt *gt);
 void xe_gt_sriov_pf_sanitize_hw(struct xe_gt *gt, unsigned int vfid);
+void xe_gt_sriov_pf_stop_prepare(struct xe_gt *gt);
 void xe_gt_sriov_pf_restart(struct xe_gt *gt);
 #else
 static inline int xe_gt_sriov_pf_init_early(struct xe_gt *gt)
@@ -23,6 +24,10 @@ static inline void xe_gt_sriov_pf_init_hw(struct xe_gt *gt)
 {
 }
 
+static inline void xe_gt_sriov_pf_stop_prepare(struct xe_gt *gt)
+{
+}
+
 static inline void xe_gt_sriov_pf_restart(struct xe_gt *gt)
 {
 }
-- 
2.39.5



