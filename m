Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97329215782;
	Thu, 12 Dec 2024 17:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024169; cv=none; b=N//Oo5jLFB1FvT8fZB3EBezEs0KoaK0Q1XaOWi31EIQTDFbiQJ3zJzhrdBN1lbDkqz81p/NuIb/eEOfgQAAnQ1Ks/Ox/tIM5zz4JDzWB59tQNFWLqFoO90TcjC9+SQsLW/TpEgh7RdJno0FjFHPRALWEOWQ9vN1vZbxHGUkClZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024169; c=relaxed/simple;
	bh=3dDGe5BzMlOsNniZHqGI8hh24UYOzg+IWbf9uxw81Ks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZFDBqRD9mi0OnzfdOnQvomVjDFMmelG0SYB/SvuDacwHkpeu5JvtmEiQnQnTxs0aWP9NtHuDXg1XTYVtMN5YTsCz0ZXeEMdfllBkhpZqvFkw+VxAzMn/igaSszoLWAs1i6PpVZGsTZ8UpkCdPMI/EWcvLLS0BKagvs1si4j0tPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B9QNWZOm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B9QNWZOm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2479C4CECE;
	Thu, 12 Dec 2024 17:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024169;
	bh=3dDGe5BzMlOsNniZHqGI8hh24UYOzg+IWbf9uxw81Ks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B9QNWZOmJyKFw5IBEpP8MLG4uEcBhKf8WA2f55V9mFN9EeZkQyd6vg1+w7uXAZDEN
	 9cjvEg1OI99cAQgTsBzGbliUSiQUmTyGjhKIF7Edry/ax/zKd1wGilaiW/cK9LrwGg
	 X7ZHK7I4/HJ/KB/2PeyhKOvMKTORUdqPTncw8LZk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Andersson <quic_bjorande@quicinc.com>,
	Chris Lew <quic_clew@quicinc.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 208/459] rpmsg: glink: Fix GLINK command prefix
Date: Thu, 12 Dec 2024 15:59:06 +0100
Message-ID: <20241212144301.785830087@linuxfoundation.org>
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

From: Bjorn Andersson <quic_bjorande@quicinc.com>

[ Upstream commit 4e816d0318fdfe8932da80dbf04ba318b13e4b3a ]

The upstream GLINK driver was first introduced to communicate with the
RPM on MSM8996, presumably as an artifact from that era the command
defines was prefixed RPM_CMD, while they actually are GLINK_CMDs.

Let's rename these, to keep things tidy. No functional change.

Signed-off-by: Bjorn Andersson <quic_bjorande@quicinc.com>
Reviewed-by: Chris Lew <quic_clew@quicinc.com>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230214225933.2025595-1-quic_bjorande@quicinc.com
Stable-dep-of: 06c59d97f63c ("rpmsg: glink: use only lower 16-bits of param2 for CMD_OPEN name length")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rpmsg/qcom_glink_native.c | 98 +++++++++++++++----------------
 1 file changed, 49 insertions(+), 49 deletions(-)

diff --git a/drivers/rpmsg/qcom_glink_native.c b/drivers/rpmsg/qcom_glink_native.c
index 8128da8646db1..831a5d1cd4806 100644
--- a/drivers/rpmsg/qcom_glink_native.c
+++ b/drivers/rpmsg/qcom_glink_native.c
@@ -191,20 +191,20 @@ struct glink_channel {
 
 static const struct rpmsg_endpoint_ops glink_endpoint_ops;
 
-#define RPM_CMD_VERSION			0
-#define RPM_CMD_VERSION_ACK		1
-#define RPM_CMD_OPEN			2
-#define RPM_CMD_CLOSE			3
-#define RPM_CMD_OPEN_ACK		4
-#define RPM_CMD_INTENT			5
-#define RPM_CMD_RX_DONE			6
-#define RPM_CMD_RX_INTENT_REQ		7
-#define RPM_CMD_RX_INTENT_REQ_ACK	8
-#define RPM_CMD_TX_DATA			9
-#define RPM_CMD_CLOSE_ACK		11
-#define RPM_CMD_TX_DATA_CONT		12
-#define RPM_CMD_READ_NOTIF		13
-#define RPM_CMD_RX_DONE_W_REUSE		14
+#define GLINK_CMD_VERSION		0
+#define GLINK_CMD_VERSION_ACK		1
+#define GLINK_CMD_OPEN			2
+#define GLINK_CMD_CLOSE			3
+#define GLINK_CMD_OPEN_ACK		4
+#define GLINK_CMD_INTENT		5
+#define GLINK_CMD_RX_DONE		6
+#define GLINK_CMD_RX_INTENT_REQ		7
+#define GLINK_CMD_RX_INTENT_REQ_ACK	8
+#define GLINK_CMD_TX_DATA		9
+#define GLINK_CMD_CLOSE_ACK		11
+#define GLINK_CMD_TX_DATA_CONT		12
+#define GLINK_CMD_READ_NOTIF		13
+#define GLINK_CMD_RX_DONE_W_REUSE	14
 
 #define GLINK_FEATURE_INTENTLESS	BIT(1)
 
@@ -313,7 +313,7 @@ static void qcom_glink_send_read_notify(struct qcom_glink *glink)
 {
 	struct glink_msg msg;
 
-	msg.cmd = cpu_to_le16(RPM_CMD_READ_NOTIF);
+	msg.cmd = cpu_to_le16(GLINK_CMD_READ_NOTIF);
 	msg.param1 = 0;
 	msg.param2 = 0;
 
@@ -375,7 +375,7 @@ static int qcom_glink_send_version(struct qcom_glink *glink)
 {
 	struct glink_msg msg;
 
-	msg.cmd = cpu_to_le16(RPM_CMD_VERSION);
+	msg.cmd = cpu_to_le16(GLINK_CMD_VERSION);
 	msg.param1 = cpu_to_le16(GLINK_VERSION_1);
 	msg.param2 = cpu_to_le32(glink->features);
 
@@ -386,7 +386,7 @@ static void qcom_glink_send_version_ack(struct qcom_glink *glink)
 {
 	struct glink_msg msg;
 
-	msg.cmd = cpu_to_le16(RPM_CMD_VERSION_ACK);
+	msg.cmd = cpu_to_le16(GLINK_CMD_VERSION_ACK);
 	msg.param1 = cpu_to_le16(GLINK_VERSION_1);
 	msg.param2 = cpu_to_le32(glink->features);
 
@@ -398,7 +398,7 @@ static void qcom_glink_send_open_ack(struct qcom_glink *glink,
 {
 	struct glink_msg msg;
 
-	msg.cmd = cpu_to_le16(RPM_CMD_OPEN_ACK);
+	msg.cmd = cpu_to_le16(GLINK_CMD_OPEN_ACK);
 	msg.param1 = cpu_to_le16(channel->rcid);
 	msg.param2 = cpu_to_le32(0);
 
@@ -424,11 +424,11 @@ static void qcom_glink_handle_intent_req_ack(struct qcom_glink *glink,
 }
 
 /**
- * qcom_glink_send_open_req() - send a RPM_CMD_OPEN request to the remote
+ * qcom_glink_send_open_req() - send a GLINK_CMD_OPEN request to the remote
  * @glink: Ptr to the glink edge
  * @channel: Ptr to the channel that the open req is sent
  *
- * Allocates a local channel id and sends a RPM_CMD_OPEN message to the remote.
+ * Allocates a local channel id and sends a GLINK_CMD_OPEN message to the remote.
  * Will return with refcount held, regardless of outcome.
  *
  * Returns 0 on success, negative errno otherwise.
@@ -457,7 +457,7 @@ static int qcom_glink_send_open_req(struct qcom_glink *glink,
 
 	channel->lcid = ret;
 
-	req.msg.cmd = cpu_to_le16(RPM_CMD_OPEN);
+	req.msg.cmd = cpu_to_le16(GLINK_CMD_OPEN);
 	req.msg.param1 = cpu_to_le16(channel->lcid);
 	req.msg.param2 = cpu_to_le32(name_len);
 	strcpy(req.name, channel->name);
@@ -482,7 +482,7 @@ static void qcom_glink_send_close_req(struct qcom_glink *glink,
 {
 	struct glink_msg req;
 
-	req.cmd = cpu_to_le16(RPM_CMD_CLOSE);
+	req.cmd = cpu_to_le16(GLINK_CMD_CLOSE);
 	req.param1 = cpu_to_le16(channel->lcid);
 	req.param2 = 0;
 
@@ -494,7 +494,7 @@ static void qcom_glink_send_close_ack(struct qcom_glink *glink,
 {
 	struct glink_msg req;
 
-	req.cmd = cpu_to_le16(RPM_CMD_CLOSE_ACK);
+	req.cmd = cpu_to_le16(GLINK_CMD_CLOSE_ACK);
 	req.param1 = cpu_to_le16(rcid);
 	req.param2 = 0;
 
@@ -525,7 +525,7 @@ static void qcom_glink_rx_done_work(struct work_struct *work)
 		iid = intent->id;
 		reuse = intent->reuse;
 
-		cmd.id = reuse ? RPM_CMD_RX_DONE_W_REUSE : RPM_CMD_RX_DONE;
+		cmd.id = reuse ? GLINK_CMD_RX_DONE_W_REUSE : GLINK_CMD_RX_DONE;
 		cmd.lcid = cid;
 		cmd.liid = iid;
 
@@ -637,7 +637,7 @@ static int qcom_glink_send_intent_req_ack(struct qcom_glink *glink,
 {
 	struct glink_msg msg;
 
-	msg.cmd = cpu_to_le16(RPM_CMD_RX_INTENT_REQ_ACK);
+	msg.cmd = cpu_to_le16(GLINK_CMD_RX_INTENT_REQ_ACK);
 	msg.param1 = cpu_to_le16(channel->lcid);
 	msg.param2 = cpu_to_le32(granted);
 
@@ -668,7 +668,7 @@ static int qcom_glink_advertise_intent(struct qcom_glink *glink,
 	} __packed;
 	struct command cmd;
 
-	cmd.id = cpu_to_le16(RPM_CMD_INTENT);
+	cmd.id = cpu_to_le16(GLINK_CMD_INTENT);
 	cmd.lcid = cpu_to_le16(channel->lcid);
 	cmd.count = cpu_to_le32(1);
 	cmd.size = cpu_to_le32(intent->size);
@@ -1033,42 +1033,42 @@ static irqreturn_t qcom_glink_native_intr(int irq, void *data)
 		param2 = le32_to_cpu(msg.param2);
 
 		switch (cmd) {
-		case RPM_CMD_VERSION:
-		case RPM_CMD_VERSION_ACK:
-		case RPM_CMD_CLOSE:
-		case RPM_CMD_CLOSE_ACK:
-		case RPM_CMD_RX_INTENT_REQ:
+		case GLINK_CMD_VERSION:
+		case GLINK_CMD_VERSION_ACK:
+		case GLINK_CMD_CLOSE:
+		case GLINK_CMD_CLOSE_ACK:
+		case GLINK_CMD_RX_INTENT_REQ:
 			ret = qcom_glink_rx_defer(glink, 0);
 			break;
-		case RPM_CMD_OPEN_ACK:
+		case GLINK_CMD_OPEN_ACK:
 			ret = qcom_glink_rx_open_ack(glink, param1);
 			qcom_glink_rx_advance(glink, ALIGN(sizeof(msg), 8));
 			break;
-		case RPM_CMD_OPEN:
+		case GLINK_CMD_OPEN:
 			ret = qcom_glink_rx_defer(glink, param2);
 			break;
-		case RPM_CMD_TX_DATA:
-		case RPM_CMD_TX_DATA_CONT:
+		case GLINK_CMD_TX_DATA:
+		case GLINK_CMD_TX_DATA_CONT:
 			ret = qcom_glink_rx_data(glink, avail);
 			break;
-		case RPM_CMD_READ_NOTIF:
+		case GLINK_CMD_READ_NOTIF:
 			qcom_glink_rx_advance(glink, ALIGN(sizeof(msg), 8));
 
 			mbox_send_message(glink->mbox_chan, NULL);
 			mbox_client_txdone(glink->mbox_chan, 0);
 			break;
-		case RPM_CMD_INTENT:
+		case GLINK_CMD_INTENT:
 			qcom_glink_handle_intent(glink, param1, param2, avail);
 			break;
-		case RPM_CMD_RX_DONE:
+		case GLINK_CMD_RX_DONE:
 			qcom_glink_handle_rx_done(glink, param1, param2, false);
 			qcom_glink_rx_advance(glink, ALIGN(sizeof(msg), 8));
 			break;
-		case RPM_CMD_RX_DONE_W_REUSE:
+		case GLINK_CMD_RX_DONE_W_REUSE:
 			qcom_glink_handle_rx_done(glink, param1, param2, true);
 			qcom_glink_rx_advance(glink, ALIGN(sizeof(msg), 8));
 			break;
-		case RPM_CMD_RX_INTENT_REQ_ACK:
+		case GLINK_CMD_RX_INTENT_REQ_ACK:
 			qcom_glink_handle_intent_req_ack(glink, param1, param2);
 			qcom_glink_rx_advance(glink, ALIGN(sizeof(msg), 8));
 			break;
@@ -1271,7 +1271,7 @@ static int qcom_glink_request_intent(struct qcom_glink *glink,
 
 	reinit_completion(&channel->intent_req_comp);
 
-	cmd.id = RPM_CMD_RX_INTENT_REQ;
+	cmd.id = GLINK_CMD_RX_INTENT_REQ;
 	cmd.cid = channel->lcid;
 	cmd.size = size;
 
@@ -1345,7 +1345,7 @@ static int __qcom_glink_send(struct glink_channel *channel,
 		chunk_size = SZ_8K;
 		left_size = len - chunk_size;
 	}
-	req.msg.cmd = cpu_to_le16(RPM_CMD_TX_DATA);
+	req.msg.cmd = cpu_to_le16(GLINK_CMD_TX_DATA);
 	req.msg.param1 = cpu_to_le16(channel->lcid);
 	req.msg.param2 = cpu_to_le32(iid);
 	req.chunk_size = cpu_to_le32(chunk_size);
@@ -1366,7 +1366,7 @@ static int __qcom_glink_send(struct glink_channel *channel,
 			chunk_size = SZ_8K;
 		left_size -= chunk_size;
 
-		req.msg.cmd = cpu_to_le16(RPM_CMD_TX_DATA_CONT);
+		req.msg.cmd = cpu_to_le16(GLINK_CMD_TX_DATA_CONT);
 		req.msg.param1 = cpu_to_le16(channel->lcid);
 		req.msg.param2 = cpu_to_le32(iid);
 		req.chunk_size = cpu_to_le32(chunk_size);
@@ -1605,22 +1605,22 @@ static void qcom_glink_work(struct work_struct *work)
 		param2 = le32_to_cpu(msg->param2);
 
 		switch (cmd) {
-		case RPM_CMD_VERSION:
+		case GLINK_CMD_VERSION:
 			qcom_glink_receive_version(glink, param1, param2);
 			break;
-		case RPM_CMD_VERSION_ACK:
+		case GLINK_CMD_VERSION_ACK:
 			qcom_glink_receive_version_ack(glink, param1, param2);
 			break;
-		case RPM_CMD_OPEN:
+		case GLINK_CMD_OPEN:
 			qcom_glink_rx_open(glink, param1, msg->data);
 			break;
-		case RPM_CMD_CLOSE:
+		case GLINK_CMD_CLOSE:
 			qcom_glink_rx_close(glink, param1);
 			break;
-		case RPM_CMD_CLOSE_ACK:
+		case GLINK_CMD_CLOSE_ACK:
 			qcom_glink_rx_close_ack(glink, param1);
 			break;
-		case RPM_CMD_RX_INTENT_REQ:
+		case GLINK_CMD_RX_INTENT_REQ:
 			qcom_glink_handle_intent_req(glink, param1, param2);
 			break;
 		default:
-- 
2.43.0



