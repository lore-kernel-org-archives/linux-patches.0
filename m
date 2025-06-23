Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB88E253950;
	Mon, 23 Jun 2025 13:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684935; cv=none; b=NpbWXMr4AXcf5Lqn+EwuYZfKvuYDGo5i2PfYjBuzqRIVtei61dksaxDGHNhyWCeAGEptIlFC1BsROKnzGoeRS1imuZb+6+fjwLXdcPIa7ZQSdMRClHwnNvZ3oOKbn5O6mw2SFEZV58c7H+E7XcklF9QJgI51HweC80UX9P994WU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684935; c=relaxed/simple;
	bh=dAfG191cg9+vj1GlasOaxYMZvKEwjPnsNumUbngBbt4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UdH3OyphHH1ifQ4uL0U7blp+a5/7n+sjlPP3Ha3YALMW3daTTA8ptsBi+wzSIbKHoxPAjKZ4vWxEHZGHRocl7VEQW97aPY+JSaDftl0irBAVQ5FWjMG2MVRBlRr3StkhSnFTMyw1/4NAc9zjcu1+OCB9Hn1y5KgaVkzd7+4UXDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J7Zg0S+M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J7Zg0S+M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F406C4CEEA;
	Mon, 23 Jun 2025 13:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684934;
	bh=dAfG191cg9+vj1GlasOaxYMZvKEwjPnsNumUbngBbt4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J7Zg0S+MNdDPPHyedLf8A0OP+Ll2gJ928eB1lh1G3glpOKI+mfgpRZhofXGBjHnVd
	 1Lxcl7A3deH57DNtITR9oRjPsxxIVUN+BWFy3oBP8mj56B3EGZL/CBxNtaKoClb0Qq
	 sVeqUFzlWUFfPDX9AjY253CotOfx/+oLRkq649yE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karol Wachowski <karol.wachowski@intel.com>,
	Lizhi Hou <lizhi.hou@amd.com>,
	Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Subject: [PATCH 6.15 192/592] accel/ivpu: Trigger device recovery on engine reset/resume failure
Date: Mon, 23 Jun 2025 15:02:30 +0200
Message-ID: <20250623130704.853443840@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karol Wachowski <karol.wachowski@intel.com>

commit a47e36dc5d90dc664cac87304c17d50f1595d634 upstream.

Trigger full device recovery when the driver fails to restore device state
via engine reset and resume operations. This is necessary because, even if
submissions from a faulty context are blocked, the NPU may still process
previously submitted faulty jobs if the engine reset fails to abort them.
Such jobs can continue to generate faults and occupy device resources.
When engine reset is ineffective, the only way to recover is to perform
a full device recovery.

Fixes: dad945c27a42 ("accel/ivpu: Add handling of VPU_JSM_STATUS_MVNCI_CONTEXT_VIOLATION_HW")
Cc: stable@vger.kernel.org # v6.15+
Signed-off-by: Karol Wachowski <karol.wachowski@intel.com>
Reviewed-by: Lizhi Hou <lizhi.hou@amd.com>
Signed-off-by: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Link: https://lore.kernel.org/r/20250528154253.500556-1-jacek.lawrynowicz@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/accel/ivpu/ivpu_job.c     |    6 ++++--
 drivers/accel/ivpu/ivpu_jsm_msg.c |    9 +++++++--
 2 files changed, 11 insertions(+), 4 deletions(-)

--- a/drivers/accel/ivpu/ivpu_job.c
+++ b/drivers/accel/ivpu/ivpu_job.c
@@ -986,7 +986,8 @@ void ivpu_context_abort_work_fn(struct w
 		return;
 
 	if (vdev->fw->sched_mode == VPU_SCHEDULING_MODE_HW)
-		ivpu_jsm_reset_engine(vdev, 0);
+		if (ivpu_jsm_reset_engine(vdev, 0))
+			return;
 
 	mutex_lock(&vdev->context_list_lock);
 	xa_for_each(&vdev->context_xa, ctx_id, file_priv) {
@@ -1009,7 +1010,8 @@ void ivpu_context_abort_work_fn(struct w
 	if (vdev->fw->sched_mode != VPU_SCHEDULING_MODE_HW)
 		goto runtime_put;
 
-	ivpu_jsm_hws_resume_engine(vdev, 0);
+	if (ivpu_jsm_hws_resume_engine(vdev, 0))
+		return;
 	/*
 	 * In hardware scheduling mode NPU already has stopped processing jobs
 	 * and won't send us any further notifications, thus we have to free job related resources
--- a/drivers/accel/ivpu/ivpu_jsm_msg.c
+++ b/drivers/accel/ivpu/ivpu_jsm_msg.c
@@ -7,6 +7,7 @@
 #include "ivpu_hw.h"
 #include "ivpu_ipc.h"
 #include "ivpu_jsm_msg.h"
+#include "ivpu_pm.h"
 #include "vpu_jsm_api.h"
 
 const char *ivpu_jsm_msg_type_to_str(enum vpu_ipc_msg_type type)
@@ -163,8 +164,10 @@ int ivpu_jsm_reset_engine(struct ivpu_de
 
 	ret = ivpu_ipc_send_receive(vdev, &req, VPU_JSM_MSG_ENGINE_RESET_DONE, &resp,
 				    VPU_IPC_CHAN_ASYNC_CMD, vdev->timeout.jsm);
-	if (ret)
+	if (ret) {
 		ivpu_err_ratelimited(vdev, "Failed to reset engine %d: %d\n", engine, ret);
+		ivpu_pm_trigger_recovery(vdev, "Engine reset failed");
+	}
 
 	return ret;
 }
@@ -354,8 +357,10 @@ int ivpu_jsm_hws_resume_engine(struct iv
 
 	ret = ivpu_ipc_send_receive(vdev, &req, VPU_JSM_MSG_HWS_RESUME_ENGINE_DONE, &resp,
 				    VPU_IPC_CHAN_ASYNC_CMD, vdev->timeout.jsm);
-	if (ret)
+	if (ret) {
 		ivpu_err_ratelimited(vdev, "Failed to resume engine %d: %d\n", engine, ret);
+		ivpu_pm_trigger_recovery(vdev, "Engine resume failed");
+	}
 
 	return ret;
 }


