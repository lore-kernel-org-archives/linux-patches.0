Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDD0519644B;
	Mon, 24 Feb 2025 14:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408358; cv=none; b=LrRmCS+F3R7H2chDYhwqjz0MrxaYtp4aYnv98SY4swc6zlI7TB0Qp3jFDQgAUKX1ZPm0MfL4N1hxNOUrBTjAz7pIUy6eKbBwD9VIVNJwkKGu07TcqH7W57rKoKJyfFQ0yX5ef876WKx4zjeKgTyd+HfA/Rq0inaZzYqc7DMbUWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408358; c=relaxed/simple;
	bh=eLlYbiKelOOjp6q5LdtepfRZ9vCOiFTx2FkVg7t9Tbk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qpLSSD9NPD9pDroUMBVpZWB4nkPXTzhD0tkPJ8mbAtDc70XpcrwKJAiv07Jw/U5Vb+K4iYELbrJySK4k7+FWrxxF0P3VALuGKkQAzYTe8yQcUtPgfAVjnYCPLw8DJnubmaa3s5WWzAfW5b/L58kxLmvX2hn/2f3KO6Yt07FbV3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RgMA9aM8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RgMA9aM8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA839C4CED6;
	Mon, 24 Feb 2025 14:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408358;
	bh=eLlYbiKelOOjp6q5LdtepfRZ9vCOiFTx2FkVg7t9Tbk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RgMA9aM8vu7MecULCTBPGKWO28UC2JGZvo5coBd8Wjf0tXeKZOAtKi8Tdhh69fgCy
	 RJhym8r+6oEcTaVlGJetVp2T6MtZPQWoq1UXryc7UtXQRgdkPnK755VYzsc+n83ZDA
	 BT3BWabPvYU/z83Qt+tOS6uABjBaLr/GewA405AQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomasz Rusinowicz <tomasz.rusinowicz@intel.com>,
	Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 035/154] accel/ivpu: Add FW state dump on TDR
Date: Mon, 24 Feb 2025 15:33:54 +0100
Message-ID: <20250224142608.460306830@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142607.058226288@linuxfoundation.org>
References: <20250224142607.058226288@linuxfoundation.org>
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

From: Tomasz Rusinowicz <tomasz.rusinowicz@intel.com>

[ Upstream commit 5e162f872d7af8f041b143536617ab2563ea7de5 ]

Send JSM state dump message at the beginning of TDR handler. This allows
FW to collect debug info in the FW log before the state of the NPU is
lost allowing to analyze the cause of a TDR.

Wait a predefined timeout (10 ms) so the FW has a chance to write debug
logs. We cannot wait for JSM response at this point because IRQs are
already disabled before TDR handler is invoked.

Signed-off-by: Tomasz Rusinowicz <tomasz.rusinowicz@intel.com>
Reviewed-by: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240930195322.461209-9-jacek.lawrynowicz@linux.intel.com
Signed-off-by: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Stable-dep-of: 41a2d8286c90 ("accel/ivpu: Fix error handling in recovery/reset")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/ivpu/ivpu_drv.h     |  1 +
 drivers/accel/ivpu/ivpu_hw.c      |  3 +++
 drivers/accel/ivpu/ivpu_ipc.c     | 26 ++++++++++++++++++++++++++
 drivers/accel/ivpu/ivpu_ipc.h     |  2 ++
 drivers/accel/ivpu/ivpu_jsm_msg.c |  8 ++++++++
 drivers/accel/ivpu/ivpu_jsm_msg.h |  2 ++
 drivers/accel/ivpu/ivpu_pm.c      |  1 +
 7 files changed, 43 insertions(+)

diff --git a/drivers/accel/ivpu/ivpu_drv.h b/drivers/accel/ivpu/ivpu_drv.h
index 63f13b697eed7..2b30cc2e9272e 100644
--- a/drivers/accel/ivpu/ivpu_drv.h
+++ b/drivers/accel/ivpu/ivpu_drv.h
@@ -152,6 +152,7 @@ struct ivpu_device {
 		int tdr;
 		int autosuspend;
 		int d0i3_entry_msg;
+		int state_dump_msg;
 	} timeout;
 };
 
diff --git a/drivers/accel/ivpu/ivpu_hw.c b/drivers/accel/ivpu/ivpu_hw.c
index e69c0613513f1..08b3cef58fd2d 100644
--- a/drivers/accel/ivpu/ivpu_hw.c
+++ b/drivers/accel/ivpu/ivpu_hw.c
@@ -89,12 +89,14 @@ static void timeouts_init(struct ivpu_device *vdev)
 		vdev->timeout.tdr = 2000000;
 		vdev->timeout.autosuspend = -1;
 		vdev->timeout.d0i3_entry_msg = 500;
+		vdev->timeout.state_dump_msg = 10;
 	} else if (ivpu_is_simics(vdev)) {
 		vdev->timeout.boot = 50;
 		vdev->timeout.jsm = 500;
 		vdev->timeout.tdr = 10000;
 		vdev->timeout.autosuspend = -1;
 		vdev->timeout.d0i3_entry_msg = 100;
+		vdev->timeout.state_dump_msg = 10;
 	} else {
 		vdev->timeout.boot = 1000;
 		vdev->timeout.jsm = 500;
@@ -104,6 +106,7 @@ static void timeouts_init(struct ivpu_device *vdev)
 		else
 			vdev->timeout.autosuspend = 100;
 		vdev->timeout.d0i3_entry_msg = 5;
+		vdev->timeout.state_dump_msg = 10;
 	}
 }
 
diff --git a/drivers/accel/ivpu/ivpu_ipc.c b/drivers/accel/ivpu/ivpu_ipc.c
index 29b723039a345..13c8a12162e89 100644
--- a/drivers/accel/ivpu/ivpu_ipc.c
+++ b/drivers/accel/ivpu/ivpu_ipc.c
@@ -353,6 +353,32 @@ int ivpu_ipc_send_receive(struct ivpu_device *vdev, struct vpu_jsm_msg *req,
 	return ret;
 }
 
+int ivpu_ipc_send_and_wait(struct ivpu_device *vdev, struct vpu_jsm_msg *req,
+			   u32 channel, unsigned long timeout_ms)
+{
+	struct ivpu_ipc_consumer cons;
+	int ret;
+
+	ret = ivpu_rpm_get(vdev);
+	if (ret < 0)
+		return ret;
+
+	ivpu_ipc_consumer_add(vdev, &cons, channel, NULL);
+
+	ret = ivpu_ipc_send(vdev, &cons, req);
+	if (ret) {
+		ivpu_warn_ratelimited(vdev, "IPC send failed: %d\n", ret);
+		goto consumer_del;
+	}
+
+	msleep(timeout_ms);
+
+consumer_del:
+	ivpu_ipc_consumer_del(vdev, &cons);
+	ivpu_rpm_put(vdev);
+	return ret;
+}
+
 static bool
 ivpu_ipc_match_consumer(struct ivpu_device *vdev, struct ivpu_ipc_consumer *cons,
 			struct ivpu_ipc_hdr *ipc_hdr, struct vpu_jsm_msg *jsm_msg)
diff --git a/drivers/accel/ivpu/ivpu_ipc.h b/drivers/accel/ivpu/ivpu_ipc.h
index fb4de7fb8210e..b4dfb504679ba 100644
--- a/drivers/accel/ivpu/ivpu_ipc.h
+++ b/drivers/accel/ivpu/ivpu_ipc.h
@@ -107,5 +107,7 @@ int ivpu_ipc_send_receive_internal(struct ivpu_device *vdev, struct vpu_jsm_msg
 int ivpu_ipc_send_receive(struct ivpu_device *vdev, struct vpu_jsm_msg *req,
 			  enum vpu_ipc_msg_type expected_resp, struct vpu_jsm_msg *resp,
 			  u32 channel, unsigned long timeout_ms);
+int ivpu_ipc_send_and_wait(struct ivpu_device *vdev, struct vpu_jsm_msg *req,
+			   u32 channel, unsigned long timeout_ms);
 
 #endif /* __IVPU_IPC_H__ */
diff --git a/drivers/accel/ivpu/ivpu_jsm_msg.c b/drivers/accel/ivpu/ivpu_jsm_msg.c
index 88105963c1b28..f7618b605f021 100644
--- a/drivers/accel/ivpu/ivpu_jsm_msg.c
+++ b/drivers/accel/ivpu/ivpu_jsm_msg.c
@@ -555,3 +555,11 @@ int ivpu_jsm_dct_disable(struct ivpu_device *vdev)
 	return ivpu_ipc_send_receive_internal(vdev, &req, VPU_JSM_MSG_DCT_DISABLE_DONE, &resp,
 					      VPU_IPC_CHAN_ASYNC_CMD, vdev->timeout.jsm);
 }
+
+int ivpu_jsm_state_dump(struct ivpu_device *vdev)
+{
+	struct vpu_jsm_msg req = { .type = VPU_JSM_MSG_STATE_DUMP };
+
+	return ivpu_ipc_send_and_wait(vdev, &req, VPU_IPC_CHAN_ASYNC_CMD,
+				      vdev->timeout.state_dump_msg);
+}
diff --git a/drivers/accel/ivpu/ivpu_jsm_msg.h b/drivers/accel/ivpu/ivpu_jsm_msg.h
index e4e42c0ff6e65..9e84d3526a146 100644
--- a/drivers/accel/ivpu/ivpu_jsm_msg.h
+++ b/drivers/accel/ivpu/ivpu_jsm_msg.h
@@ -43,4 +43,6 @@ int ivpu_jsm_metric_streamer_info(struct ivpu_device *vdev, u64 metric_group_mas
 				  u64 buffer_size, u32 *sample_size, u64 *info_size);
 int ivpu_jsm_dct_enable(struct ivpu_device *vdev, u32 active_us, u32 inactive_us);
 int ivpu_jsm_dct_disable(struct ivpu_device *vdev);
+int ivpu_jsm_state_dump(struct ivpu_device *vdev);
+
 #endif
diff --git a/drivers/accel/ivpu/ivpu_pm.c b/drivers/accel/ivpu/ivpu_pm.c
index 0110f5ee7d069..848d7468d48ce 100644
--- a/drivers/accel/ivpu/ivpu_pm.c
+++ b/drivers/accel/ivpu/ivpu_pm.c
@@ -124,6 +124,7 @@ static void ivpu_pm_recovery_work(struct work_struct *work)
 	if (ret)
 		ivpu_err(vdev, "Failed to resume NPU: %d\n", ret);
 
+	ivpu_jsm_state_dump(vdev);
 	ivpu_dev_coredump(vdev);
 
 	atomic_inc(&vdev->pm->reset_counter);
-- 
2.39.5



