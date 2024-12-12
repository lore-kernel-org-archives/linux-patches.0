Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 830E1215782;
	Thu, 12 Dec 2024 17:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024166; cv=none; b=GvxA6u6pE5Ini0ns3w3TzVGsZiJSHeuYnyzi66kg9OR3o2iKr9ZXRSrrCS7HTRSudJf/4dHtQdO9dGgLl8TTxq3AmDmlACJjG9Sk5jMKomx4uLGN9LW2QstnPXsK49++YOTs0K4h7CgRcNFBOn1BB2BKA0FcHwbSNdJsq7v8Evo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024166; c=relaxed/simple;
	bh=V/xfUCsuDBHWoLjskgwzkz4i5NzfiQ71ZuFSLQFcOGM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cq+9Nm927UI2BR27kODXlfJIg6e8ewHh/smUVJumDkofXSuk16o0oBOLcqLeb3yXGGiH5MKDGqQuAZyF5S6syy4W8EXlktJ0bRjGN2w77dUhh+NDoCfn0jRlrE3LUwbSqq9DPGVOayrQsvDoThWYOcFxJK+3CROOrzFqWQmzMoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mUKb+HH1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mUKb+HH1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF582C4CECE;
	Thu, 12 Dec 2024 17:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024166;
	bh=V/xfUCsuDBHWoLjskgwzkz4i5NzfiQ71ZuFSLQFcOGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mUKb+HH1vnro0OC0EgilEVKrmUdM6teTV4VCLlSPCLKSmrvExYPsmKFLUz5xpWz+Y
	 KsSPHP1vsEXn169RIMsgtzhI7sPdu8LRPn4Hy3eNYNBzd7G2nvd7JUSRG+LvKHHgAe
	 pWTuj47S0gm8mFZnLXNEtXRTGtd0e6lkzX8xE0Vs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Deepak Kumar Singh <deesin@codeaurora.org>,
	Arun Kumar Neelakantam <aneela@codeaurora.org>,
	Bjorn Andersson <bjorn.andersson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 207/459] rpmsg: glink: Send READ_NOTIFY command in FIFO full case
Date: Thu, 12 Dec 2024 15:59:05 +0100
Message-ID: <20241212144301.745358764@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arun Kumar Neelakantam <aneela@codeaurora.org>

[ Upstream commit b16a37e1846c9573a847a56fa2f31ba833dae45a ]

The current design sleeps unconditionally in TX FIFO full case and
wakeup only after sleep timer expires which adds random delays in
clients TX path.

Avoid sleep and use READ_NOTIFY command so that writer can be woken up
when remote notifies about read completion by sending IRQ.

Signed-off-by: Deepak Kumar Singh <deesin@codeaurora.org>
Signed-off-by: Arun Kumar Neelakantam <aneela@codeaurora.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/1596086296-28529-7-git-send-email-deesin@codeaurora.org
Stable-dep-of: 06c59d97f63c ("rpmsg: glink: use only lower 16-bits of param2 for CMD_OPEN name length")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rpmsg/qcom_glink_native.c | 36 ++++++++++++++++++++++++++++++-
 1 file changed, 35 insertions(+), 1 deletion(-)

diff --git a/drivers/rpmsg/qcom_glink_native.c b/drivers/rpmsg/qcom_glink_native.c
index a8486264f11f3..8128da8646db1 100644
--- a/drivers/rpmsg/qcom_glink_native.c
+++ b/drivers/rpmsg/qcom_glink_native.c
@@ -92,6 +92,8 @@ struct glink_core_rx_intent {
  * @rcids:	idr of all channels with a known remote channel id
  * @features:	remote features
  * @intentless:	flag to indicate that there is no intent
+ * @tx_avail_notify: Waitqueue for pending tx tasks
+ * @sent_read_notify: flag to check cmd sent or not
  */
 struct qcom_glink {
 	struct device *dev;
@@ -118,6 +120,8 @@ struct qcom_glink {
 	unsigned long features;
 
 	bool intentless;
+	wait_queue_head_t tx_avail_notify;
+	bool sent_read_notify;
 };
 
 enum {
@@ -305,6 +309,20 @@ static void qcom_glink_tx_write(struct qcom_glink *glink,
 	glink->tx_pipe->write(glink->tx_pipe, hdr, hlen, data, dlen);
 }
 
+static void qcom_glink_send_read_notify(struct qcom_glink *glink)
+{
+	struct glink_msg msg;
+
+	msg.cmd = cpu_to_le16(RPM_CMD_READ_NOTIF);
+	msg.param1 = 0;
+	msg.param2 = 0;
+
+	qcom_glink_tx_write(glink, &msg, sizeof(msg), NULL, 0);
+
+	mbox_send_message(glink->mbox_chan, NULL);
+	mbox_client_txdone(glink->mbox_chan, 0);
+}
+
 static int qcom_glink_tx(struct qcom_glink *glink,
 			 const void *hdr, size_t hlen,
 			 const void *data, size_t dlen, bool wait)
@@ -325,12 +343,21 @@ static int qcom_glink_tx(struct qcom_glink *glink,
 			goto out;
 		}
 
+		if (!glink->sent_read_notify) {
+			glink->sent_read_notify = true;
+			qcom_glink_send_read_notify(glink);
+		}
+
 		/* Wait without holding the tx_lock */
 		spin_unlock_irqrestore(&glink->tx_lock, flags);
 
-		usleep_range(10000, 15000);
+		wait_event_timeout(glink->tx_avail_notify,
+				   qcom_glink_tx_avail(glink) >= tlen, 10 * HZ);
 
 		spin_lock_irqsave(&glink->tx_lock, flags);
+
+		if (qcom_glink_tx_avail(glink) >= tlen)
+			glink->sent_read_notify = false;
 	}
 
 	qcom_glink_tx_write(glink, hdr, hlen, data, dlen);
@@ -991,6 +1018,9 @@ static irqreturn_t qcom_glink_native_intr(int irq, void *data)
 	unsigned int cmd;
 	int ret = 0;
 
+	/* To wakeup any blocking writers */
+	wake_up_all(&glink->tx_avail_notify);
+
 	for (;;) {
 		avail = qcom_glink_rx_avail(glink);
 		if (avail < sizeof(msg))
@@ -1530,6 +1560,9 @@ static void qcom_glink_rx_close_ack(struct qcom_glink *glink, unsigned int lcid)
 	struct glink_channel *channel;
 	unsigned long flags;
 
+	/* To wakeup any blocking writers */
+	wake_up_all(&glink->tx_avail_notify);
+
 	spin_lock_irqsave(&glink->idr_lock, flags);
 	channel = idr_find(&glink->lcids, lcid);
 	if (WARN(!channel, "close ack on unknown channel\n")) {
@@ -1691,6 +1724,7 @@ struct qcom_glink *qcom_glink_native_probe(struct device *dev,
 	spin_lock_init(&glink->rx_lock);
 	INIT_LIST_HEAD(&glink->rx_queue);
 	INIT_WORK(&glink->rx_work, qcom_glink_work);
+	init_waitqueue_head(&glink->tx_avail_notify);
 
 	spin_lock_init(&glink->idr_lock);
 	idr_init(&glink->lcids);
-- 
2.43.0



