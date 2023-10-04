Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6BD619BD6
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:30:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I7lh6YP1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FA74C433C8;
	Wed,  4 Oct 2023 18:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696444244;
	bh=wUOHT/guW01EgaAsasJ3or0110+P0FHcpr4B/6fQ9Ig=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I7lh6YP1V+xDHVXRG0WItX6BwryaZ9Fk2I6rqLEYHQIkye248Ack13Z7ahSE6JMZE
	 oHG2hdGpnqvny39S11hLO1rSJMXJNL0IMbX96qzvBANeQEXlm4qFaJPiEb1u09l/Js
	 SNVfYtN7PSm0F6hO8CuqRsh9X4CIreh+QHG9ik6M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karol Wachowski <karol.wachowski@linux.intel.com>,
	Jeffrey Hugo <quic_jhugo@quicinc.com>,
	Stanislaw Gruszka <stanislaw.gruszka@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 153/321] accel/ivpu: Do not use wait event interruptible
Date: Wed,  4 Oct 2023 19:54:58 +0200
Message-ID: <20231004175236.338416446@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislaw Gruszka <stanislaw.gruszka@linux.intel.com>

[ Upstream commit b0873eead1d1eadf13b5c80ad5d8f88b91e4910a ]

If we receive signal when waiting for IPC message response in
ivpu_ipc_receive() we return error and continue to operate.
Then the driver can send another IPC messages and re-use occupied
slot of the message still processed by the firmware. This can result
in corrupting firmware memory and following FW crash with messages:

[ 3698.569719] intel_vpu 0000:00:0b.0: [drm] ivpu_ipc_send_receive_internal(): IPC receive failed: type 0x1103, ret -512
[ 3698.569747] intel_vpu 0000:00:0b.0: [drm] ivpu_jsm_unregister_db(): Failed to unregister doorbell 3: -512
[ 3698.569756] intel_vpu 0000:00:0b.0: [drm] ivpu_ipc_tx_prepare(): IPC message vpu:0x88980000 not released by firmware
[ 3698.569763] intel_vpu 0000:00:0b.0: [drm] ivpu_ipc_tx_prepare(): JSM message vpu:0x88980040 not released by firmware
[ 3698.570234] intel_vpu 0000:00:0b.0: [drm] ivpu_ipc_send_receive_internal(): IPC receive failed: type 0x110e, ret -512
[ 3698.570318] intel_vpu 0000:00:0b.0: [drm] *ERROR* ivpu_mmu_dump_event(): MMU EVTQ: 0x10 (Translation fault) SSID: 0 SID: 3, e[2] 00000000, e[3] 00000208, in addr: 0x88988000, fetch addr: 0x0

To fix the issue don't use interruptible variant of wait event to
allow firmware to finish IPC processing.

Fixes: 5d7422cfb498 ("accel/ivpu: Add IPC driver and JSM messages")
Reviewed-by: Karol Wachowski <karol.wachowski@linux.intel.com>
Reviewed-by: Jeffrey Hugo <quic_jhugo@quicinc.com>
Signed-off-by: Stanislaw Gruszka <stanislaw.gruszka@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230925121137.872158-2-stanislaw.gruszka@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/ivpu/ivpu_ipc.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/drivers/accel/ivpu/ivpu_ipc.c b/drivers/accel/ivpu/ivpu_ipc.c
index fa0af59e39ab6..295c0d7b50398 100644
--- a/drivers/accel/ivpu/ivpu_ipc.c
+++ b/drivers/accel/ivpu/ivpu_ipc.c
@@ -209,10 +209,10 @@ int ivpu_ipc_receive(struct ivpu_device *vdev, struct ivpu_ipc_consumer *cons,
 	struct ivpu_ipc_rx_msg *rx_msg;
 	int wait_ret, ret = 0;
 
-	wait_ret = wait_event_interruptible_timeout(cons->rx_msg_wq,
-						    (IS_KTHREAD() && kthread_should_stop()) ||
-						    !list_empty(&cons->rx_msg_list),
-						    msecs_to_jiffies(timeout_ms));
+	wait_ret = wait_event_timeout(cons->rx_msg_wq,
+				      (IS_KTHREAD() && kthread_should_stop()) ||
+				      !list_empty(&cons->rx_msg_list),
+				      msecs_to_jiffies(timeout_ms));
 
 	if (IS_KTHREAD() && kthread_should_stop())
 		return -EINTR;
@@ -220,9 +220,6 @@ int ivpu_ipc_receive(struct ivpu_device *vdev, struct ivpu_ipc_consumer *cons,
 	if (wait_ret == 0)
 		return -ETIMEDOUT;
 
-	if (wait_ret < 0)
-		return -ERESTARTSYS;
-
 	spin_lock_irq(&cons->rx_msg_lock);
 	rx_msg = list_first_entry_or_null(&cons->rx_msg_list, struct ivpu_ipc_rx_msg, link);
 	if (!rx_msg) {
-- 
2.40.1



