Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC7CE2EE98B;
	Thu,  3 Jul 2025 14:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554080; cv=none; b=UH81PURLAMsw1BZehldW5vFldNbK0Y8R8nHYS8zOlYQTI/qbU7ONLebhIr3/v3RzbHHHcDUmhVzK/VH4fXln94ZWD5xE16XgwOh2lwqtHZd+FpcG0okAu6Xze5w3N0JV34r+kkserWi+mMz6MwNvxyQJx90h6L8SZ/mWS3zgaUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554080; c=relaxed/simple;
	bh=3paFbRZcqrE21hNzBrxrRuRoyzfLj08gk5fGdjYcLf4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DXFqBTKpdOJa161V7G5c0VTey549X0e2MbOXV/rcl6Obhnc6Z/C3uQSvFW68Jn5C5Pod33wQwmGtuyGpJXiRaGW5W/5FwCNeHUFqYW6y/eVr7M/xWCdvFUEzVtJWKab9iLNQoMF/6sgGjwfMFsaOFonIVSFtZvOKW5iuf8M9QqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WgPpZy7G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WgPpZy7G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A583C4CEE3;
	Thu,  3 Jul 2025 14:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554080;
	bh=3paFbRZcqrE21hNzBrxrRuRoyzfLj08gk5fGdjYcLf4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WgPpZy7GmJbx14AFGnaqF1BHUftW5DJQpW2JWCM13eie71JddG/uw2kITdbJqQexw
	 66R1vksRTnqjbxhEQ9R/zzsuqqiF2Q1cHdHiIafrkKAaidpebLp2YjT+2ESxkGdY/m
	 pJcHIRKqvO7xmI/3Ty4EGdJYI1vaHnuDMM7zrp+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karol Wachowski <karol.wachowski@intel.com>,
	Lizhi Hou <lizhi.hou@amd.com>,
	Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 075/218] accel/ivpu: Trigger device recovery on engine reset/resume failure
Date: Thu,  3 Jul 2025 16:40:23 +0200
Message-ID: <20250703143958.936784549@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
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

From: Karol Wachowski <karol.wachowski@intel.com>

[ Upstream commit a47e36dc5d90dc664cac87304c17d50f1595d634 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/ivpu/ivpu_job.c     | 6 ++++--
 drivers/accel/ivpu/ivpu_jsm_msg.c | 9 +++++++--
 2 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/accel/ivpu/ivpu_job.c b/drivers/accel/ivpu/ivpu_job.c
index e57acae3b42ef..e631098718b15 100644
--- a/drivers/accel/ivpu/ivpu_job.c
+++ b/drivers/accel/ivpu/ivpu_job.c
@@ -849,7 +849,8 @@ void ivpu_context_abort_thread_handler(struct work_struct *work)
 	unsigned long id;
 
 	if (vdev->fw->sched_mode == VPU_SCHEDULING_MODE_HW)
-		ivpu_jsm_reset_engine(vdev, 0);
+		if (ivpu_jsm_reset_engine(vdev, 0))
+			return;
 
 	mutex_lock(&vdev->context_list_lock);
 	xa_for_each(&vdev->context_xa, ctx_id, file_priv) {
@@ -865,7 +866,8 @@ void ivpu_context_abort_thread_handler(struct work_struct *work)
 	if (vdev->fw->sched_mode != VPU_SCHEDULING_MODE_HW)
 		return;
 
-	ivpu_jsm_hws_resume_engine(vdev, 0);
+	if (ivpu_jsm_hws_resume_engine(vdev, 0))
+		return;
 	/*
 	 * In hardware scheduling mode NPU already has stopped processing jobs
 	 * and won't send us any further notifications, thus we have to free job related resources
diff --git a/drivers/accel/ivpu/ivpu_jsm_msg.c b/drivers/accel/ivpu/ivpu_jsm_msg.c
index 21018feb45978..7c08308d5725d 100644
--- a/drivers/accel/ivpu/ivpu_jsm_msg.c
+++ b/drivers/accel/ivpu/ivpu_jsm_msg.c
@@ -7,6 +7,7 @@
 #include "ivpu_hw.h"
 #include "ivpu_ipc.h"
 #include "ivpu_jsm_msg.h"
+#include "ivpu_pm.h"
 #include "vpu_jsm_api.h"
 
 const char *ivpu_jsm_msg_type_to_str(enum vpu_ipc_msg_type type)
@@ -163,8 +164,10 @@ int ivpu_jsm_reset_engine(struct ivpu_device *vdev, u32 engine)
 
 	ret = ivpu_ipc_send_receive(vdev, &req, VPU_JSM_MSG_ENGINE_RESET_DONE, &resp,
 				    VPU_IPC_CHAN_ASYNC_CMD, vdev->timeout.jsm);
-	if (ret)
+	if (ret) {
 		ivpu_err_ratelimited(vdev, "Failed to reset engine %d: %d\n", engine, ret);
+		ivpu_pm_trigger_recovery(vdev, "Engine reset failed");
+	}
 
 	return ret;
 }
@@ -354,8 +357,10 @@ int ivpu_jsm_hws_resume_engine(struct ivpu_device *vdev, u32 engine)
 
 	ret = ivpu_ipc_send_receive(vdev, &req, VPU_JSM_MSG_HWS_RESUME_ENGINE_DONE, &resp,
 				    VPU_IPC_CHAN_ASYNC_CMD, vdev->timeout.jsm);
-	if (ret)
+	if (ret) {
 		ivpu_err_ratelimited(vdev, "Failed to resume engine %d: %d\n", engine, ret);
+		ivpu_pm_trigger_recovery(vdev, "Engine resume failed");
+	}
 
 	return ret;
 }
-- 
2.39.5



