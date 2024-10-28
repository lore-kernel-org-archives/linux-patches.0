Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A84568837;
	Mon, 28 Oct 2024 06:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098072; cv=none; b=XVFHiB5DBpsZLzV3BdwcNueRuPDH73bZVlfbQpLUncZpWvIL66mfEBEA7DIQAkCW9wbPx4Npm2MhoVJBvWXi+jOVXHaUDEwPALlMB9aZ6s7gHJCIORccKOsrF/tS0EkLTToBAj42ZiAWuKofoJbEV58+e7ICKYjrQSzbWUEdg7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098072; c=relaxed/simple;
	bh=7Qe93v79hXWRCuHyAiSlnT4kO9FtzFg3MbmA236Eye4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YGtMU1qhRIiWXVsOowCNacs5TFcZ1KWrz4ojdDPokk/ga9SWsZhYNIbWeSNlm7OVoDZMHJqCbgHplv8GP6bj6yOiDPkryf9wmpFkKGUoEM5+VWZSK56FLuc3iRHb4N8ax7nwuWaRyU+C4T4f+mBqNmdWAtuKEEPDM+u6gy500Sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eLk3K2VH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eLk3K2VH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4589BC4CEC3;
	Mon, 28 Oct 2024 06:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098072;
	bh=7Qe93v79hXWRCuHyAiSlnT4kO9FtzFg3MbmA236Eye4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eLk3K2VHYWKkM1CdlFPCacXYwSSlWXTTJdopcxmSkr/0IhXY3IVeyZctMxFDKKH+7
	 RynHsPOxTDNf3K0rfVEt9xN0fYl8pZ4m+7avKBRjXKRgY84UCb7TDxKFIQr2e6FfEr
	 CrrAh/ydhfU0I6xKd6ROw4Re5c913UD2H0AupvSc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Chen <justin.chen@broadcom.com>,
	Cristian Marussi <cristian.marussi@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 057/261] firmware: arm_scmi: Queue in scmi layer for mailbox implementation
Date: Mon, 28 Oct 2024 07:23:19 +0100
Message-ID: <20241028062313.450279205@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Justin Chen <justin.chen@broadcom.com>

[ Upstream commit da1642bc97c4ef67f347edcd493bd0a52f88777b ]

send_message() does not block in the MBOX implementation. This is
because the mailbox layer has its own queue. However, this confuses
the per xfer timeouts as they all start their timeout ticks in
parallel.

Consider a case where the xfer timeout is 30ms and a SCMI transaction
takes 25ms:

  | 0ms: Message #0 is queued in mailbox layer and sent out, then sits
  |      at scmi_wait_for_message_response() with a timeout of 30ms
  | 1ms: Message #1 is queued in mailbox layer but not sent out yet.
  |      Since send_message() doesn't block, it also sits at
  |      scmi_wait_for_message_response() with a timeout of 30ms
  |  ...
  | 25ms: Message #0 is completed, txdone is called and message #1 is sent
  | 31ms: Message #1 times out since the count started at 1ms. Even though
  |       it has only been inflight for 6ms.

Fixes: 5c8a47a5a91d ("firmware: arm_scmi: Make scmi core independent of the transport type")
Signed-off-by: Justin Chen <justin.chen@broadcom.com>
Message-Id: <20241014160717.1678953-1-justin.chen@broadcom.com>
Reviewed-by: Cristian Marussi <cristian.marussi@arm.com>
Tested-by: Cristian Marussi <cristian.marussi@arm.com>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_scmi/mailbox.c | 32 +++++++++++++++++++----------
 1 file changed, 21 insertions(+), 11 deletions(-)

diff --git a/drivers/firmware/arm_scmi/mailbox.c b/drivers/firmware/arm_scmi/mailbox.c
index 0219a12e3209a..06087cb785f36 100644
--- a/drivers/firmware/arm_scmi/mailbox.c
+++ b/drivers/firmware/arm_scmi/mailbox.c
@@ -24,6 +24,7 @@
  * @chan_platform_receiver: Optional Platform Receiver mailbox unidirectional channel
  * @cinfo: SCMI channel info
  * @shmem: Transmit/Receive shared memory area
+ * @chan_lock: Lock that prevents multiple xfers from being queued
  */
 struct scmi_mailbox {
 	struct mbox_client cl;
@@ -32,6 +33,7 @@ struct scmi_mailbox {
 	struct mbox_chan *chan_platform_receiver;
 	struct scmi_chan_info *cinfo;
 	struct scmi_shared_mem __iomem *shmem;
+	struct mutex chan_lock;
 };
 
 #define client_to_scmi_mailbox(c) container_of(c, struct scmi_mailbox, cl)
@@ -255,6 +257,7 @@ static int mailbox_chan_setup(struct scmi_chan_info *cinfo, struct device *dev,
 
 	cinfo->transport_info = smbox;
 	smbox->cinfo = cinfo;
+	mutex_init(&smbox->chan_lock);
 
 	return 0;
 }
@@ -284,13 +287,23 @@ static int mailbox_send_message(struct scmi_chan_info *cinfo,
 	struct scmi_mailbox *smbox = cinfo->transport_info;
 	int ret;
 
-	ret = mbox_send_message(smbox->chan, xfer);
+	/*
+	 * The mailbox layer has its own queue. However the mailbox queue
+	 * confuses the per message SCMI timeouts since the clock starts when
+	 * the message is submitted into the mailbox queue. So when multiple
+	 * messages are queued up the clock starts on all messages instead of
+	 * only the one inflight.
+	 */
+	mutex_lock(&smbox->chan_lock);
 
-	/* mbox_send_message returns non-negative value on success, so reset */
-	if (ret > 0)
-		ret = 0;
+	ret = mbox_send_message(smbox->chan, xfer);
+	/* mbox_send_message returns non-negative value on success */
+	if (ret < 0) {
+		mutex_unlock(&smbox->chan_lock);
+		return ret;
+	}
 
-	return ret;
+	return 0;
 }
 
 static void mailbox_mark_txdone(struct scmi_chan_info *cinfo, int ret,
@@ -298,13 +311,10 @@ static void mailbox_mark_txdone(struct scmi_chan_info *cinfo, int ret,
 {
 	struct scmi_mailbox *smbox = cinfo->transport_info;
 
-	/*
-	 * NOTE: we might prefer not to need the mailbox ticker to manage the
-	 * transfer queueing since the protocol layer queues things by itself.
-	 * Unfortunately, we have to kick the mailbox framework after we have
-	 * received our message.
-	 */
 	mbox_client_txdone(smbox->chan, ret);
+
+	/* Release channel */
+	mutex_unlock(&smbox->chan_lock);
 }
 
 static void mailbox_fetch_response(struct scmi_chan_info *cinfo,
-- 
2.43.0



