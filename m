Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19B71261B9D;
	Tue, 16 Dec 2025 11:18:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765883907; cv=none; b=mR/hSCSmdigm+edgkGFq4rtmhS7ZiGZtAuDe2BmN3fN3LANFcXtGPjVWa8K9Hblily/RF19PMkQ+rJXV+nrLHve1fBPbqhR8xJNbFDWxBgW8NeTswRvIopDm0gqdxVh7vWJkKtDeNFzMQGoP5HGqoAklYGaSXG/wPDD/n0UsCnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765883907; c=relaxed/simple;
	bh=F09vRDA5fZ08MR9kPqbJu99wpwIk4CKl9DZNYELV50k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ntsDMbJXpS3mvTJn/UMLuGWk/5vgBLlEbwPED3048tltKzeG/PRc5a7zueK4ESPNLuQmAI6NiH9F6p9A6B3LbOVkshNJnYD0b/suF07nsPuQd2QHhb/QE0ehR91qOWidZ+YesgVG7wLPCLBn9110Y/RoO79MezbFQ90jVKDDJn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0tI4J9XK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0tI4J9XK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 999D5C4CEF1;
	Tue, 16 Dec 2025 11:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765883907;
	bh=F09vRDA5fZ08MR9kPqbJu99wpwIk4CKl9DZNYELV50k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0tI4J9XKgSF7YaEcJWGnxXM/gNUVSjTHLOAuo8k46pO10M64lqK8OnWua/WQRBuof
	 uwoy6hD/lwKaoR/GOJBIeShtEaC4e0a7DGZU2T/Mf2fi9yVqAri5Q1iKxsvQgLhbxH
	 L3Ah44a09hW/D0k0X30cdHajWVuxmezqtQLBk6Qo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>,
	Andrzej Kacprowski <Andrzej.Kacprowski@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 009/354] accel/ivpu: Prevent runtime suspend during context abort work
Date: Tue, 16 Dec 2025 12:09:36 +0100
Message-ID: <20251216111321.244743368@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrzej Kacprowski <Andrzej.Kacprowski@intel.com>

[ Upstream commit 7806bad76ac397a767f0c369534133c71c73b157 ]

Increment the runtime PM counter when entering
ivpu_context_abort_work_fn() to prevent the device
from suspending while the function is executing.

Reviewed-by: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Signed-off-by: Andrzej Kacprowski <Andrzej.Kacprowski@intel.com>
Signed-off-by: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250204084622.2422544-3-jacek.lawrynowicz@linux.intel.com
Stable-dep-of: 9f6c63285737 ("accel/ivpu: Ensure rpm_runtime_put in case of engine reset/resume fail")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/ivpu/ivpu_job.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/accel/ivpu/ivpu_job.c b/drivers/accel/ivpu/ivpu_job.c
index e631098718b15..a0dca1c253b74 100644
--- a/drivers/accel/ivpu/ivpu_job.c
+++ b/drivers/accel/ivpu/ivpu_job.c
@@ -8,6 +8,7 @@
 #include <linux/bitfield.h>
 #include <linux/highmem.h>
 #include <linux/pci.h>
+#include <linux/pm_runtime.h>
 #include <linux/module.h>
 #include <uapi/drm/ivpu_accel.h>
 
@@ -848,6 +849,9 @@ void ivpu_context_abort_thread_handler(struct work_struct *work)
 	struct ivpu_job *job;
 	unsigned long id;
 
+	if (drm_WARN_ON(&vdev->drm, pm_runtime_get_if_active(vdev->drm.dev) <= 0))
+		return;
+
 	if (vdev->fw->sched_mode == VPU_SCHEDULING_MODE_HW)
 		if (ivpu_jsm_reset_engine(vdev, 0))
 			return;
@@ -864,7 +868,7 @@ void ivpu_context_abort_thread_handler(struct work_struct *work)
 	mutex_unlock(&vdev->context_list_lock);
 
 	if (vdev->fw->sched_mode != VPU_SCHEDULING_MODE_HW)
-		return;
+		goto runtime_put;
 
 	if (ivpu_jsm_hws_resume_engine(vdev, 0))
 		return;
@@ -878,4 +882,8 @@ void ivpu_context_abort_thread_handler(struct work_struct *work)
 		if (job->file_priv->aborted)
 			ivpu_job_signal_and_destroy(vdev, job->job_id, DRM_IVPU_JOB_STATUS_ABORTED);
 	mutex_unlock(&vdev->submitted_jobs_lock);
+
+runtime_put:
+	pm_runtime_mark_last_busy(vdev->drm.dev);
+	pm_runtime_put_autosuspend(vdev->drm.dev);
 }
-- 
2.51.0



