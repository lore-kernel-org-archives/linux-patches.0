Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D7EB18A93F;
	Sat, 12 Sep 2026 14:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223181; cv=none; b=qGUvkpBG8NaCQm2hxqQa/d9O0mutjMxDk6IhqpBOTsdyPXwjLezKHI+bzILoj7Ui4vXit8q26HttJYR5AOi97bh49zQqc4aN1Hv6VKXP0W1t5mtEPWy+LUtlV/FS6ofFtS1AHWs4cz6RYnCpR8jh3Z9vAtRpC7Yb5uqL0n2KoGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223181; c=relaxed/simple;
	bh=j+7/mbfkeuf2Ol3PeLt/JQwFRy6P81FGBGQnrSMVbV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BTbcmyJ3NGvCuP4Y3yOQNp7eqj/PyqjrHdLVTwmv9+gFbMvvJ6m3D1ipVAVqwlip2ylEBh8n3Yi5GJRoozFr6dAWKhEDEb6KbR0AYUQcj2l6jrp9/NWHl3VoUA95+Ban6AIVcXSD5gpW1vyTY2rn0y6pVKBq0RYoUXppBQBcdEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q5MsJeYy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q5MsJeYy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4D591F000FF;
	Sat, 12 Sep 2026 14:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223179;
	bh=KyPbCpuXBLxmpBXHv98/Wuru+9pu93kexesBrzHAYHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q5MsJeYyfHmeQYLWR4H0P/EnXgdnoqQAhPfr7aABvmxqZGVqGvteXI3kasckHyNA0
	 aEWendKhCk8nI9oSPV4WAh0RL2khGktweMct6NLRg+zXz26VbaihgDKkJhman/t+xu
	 D9ib5X5fTxFA9OzTgE4AG1kWcQX2+hf/j71Ok0rQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0738/1424] rpmsg: glink: remove duplicate code for rpmsg device remove
Date: Sat, 12 Sep 2026 08:52:50 +0200
Message-ID: <20260912065623.823794012@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>

[ Upstream commit 112766cdf2e5ea0a0f72b0304d57a6f74c066670 ]

rpmsg device remove code is duplicated in at-least 2-3 places, add a
helper function to remove this duplicated code.

Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250822100043.2604794-3-srinivas.kandagatla@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Stable-dep-of: 5a5a48e788e0 ("rpmsg: glink: fix deadlock in endpoint destroy during driver detach")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rpmsg/qcom_glink_native.c | 43 ++++++++++++-------------------
 1 file changed, 16 insertions(+), 27 deletions(-)

diff --git a/drivers/rpmsg/qcom_glink_native.c b/drivers/rpmsg/qcom_glink_native.c
index f5909e4548934..4c7817a7a9903 100644
--- a/drivers/rpmsg/qcom_glink_native.c
+++ b/drivers/rpmsg/qcom_glink_native.c
@@ -1313,11 +1313,23 @@ static int qcom_glink_announce_create(struct rpmsg_device *rpdev)
 	return 0;
 }
 
+static void qcom_glink_remove_rpmsg_device(struct qcom_glink *glink, struct glink_channel *channel)
+{
+	struct rpmsg_channel_info chinfo;
+
+	if (channel->rpdev) {
+		strscpy_pad(chinfo.name, channel->name, sizeof(chinfo.name));
+		chinfo.src = RPMSG_ADDR_ANY;
+		chinfo.dst = RPMSG_ADDR_ANY;
+		rpmsg_unregister_device(glink->dev, &chinfo);
+	}
+	channel->rpdev = NULL;
+}
+
 static void qcom_glink_destroy_ept(struct rpmsg_endpoint *ept)
 {
 	struct glink_channel *channel = to_glink_channel(ept);
 	struct qcom_glink *glink = channel->glink;
-	struct rpmsg_channel_info chinfo;
 	unsigned long flags;
 
 	spin_lock_irqsave(&channel->recv_lock, flags);
@@ -1325,14 +1337,7 @@ static void qcom_glink_destroy_ept(struct rpmsg_endpoint *ept)
 	spin_unlock_irqrestore(&channel->recv_lock, flags);
 
 	/* Decouple the potential rpdev from the channel */
-	if (channel->rpdev) {
-		strscpy_pad(chinfo.name, channel->name, sizeof(chinfo.name));
-		chinfo.src = RPMSG_ADDR_ANY;
-		chinfo.dst = RPMSG_ADDR_ANY;
-
-		rpmsg_unregister_device(glink->dev, &chinfo);
-	}
-	channel->rpdev = NULL;
+	qcom_glink_remove_rpmsg_device(glink, channel);
 
 	qcom_glink_send_close_req(glink, channel);
 }
@@ -1610,7 +1615,6 @@ static int qcom_glink_rx_open(struct qcom_glink *glink, unsigned int rcid,
 
 static void qcom_glink_rx_close(struct qcom_glink *glink, unsigned int rcid)
 {
-	struct rpmsg_channel_info chinfo;
 	struct glink_channel *channel;
 	unsigned long flags;
 
@@ -1623,14 +1627,7 @@ static void qcom_glink_rx_close(struct qcom_glink *glink, unsigned int rcid)
 	/* cancel pending rx_done work */
 	cancel_work_sync(&channel->intent_work);
 
-	if (channel->rpdev) {
-		strscpy_pad(chinfo.name, channel->name, sizeof(chinfo.name));
-		chinfo.src = RPMSG_ADDR_ANY;
-		chinfo.dst = RPMSG_ADDR_ANY;
-
-		rpmsg_unregister_device(glink->dev, &chinfo);
-	}
-	channel->rpdev = NULL;
+	qcom_glink_remove_rpmsg_device(glink, channel);
 
 	qcom_glink_send_close_ack(glink, channel->rcid);
 
@@ -1644,7 +1641,6 @@ static void qcom_glink_rx_close(struct qcom_glink *glink, unsigned int rcid)
 
 static void qcom_glink_rx_close_ack(struct qcom_glink *glink, unsigned int lcid)
 {
-	struct rpmsg_channel_info chinfo;
 	struct glink_channel *channel;
 	unsigned long flags;
 
@@ -1663,14 +1659,7 @@ static void qcom_glink_rx_close_ack(struct qcom_glink *glink, unsigned int lcid)
 	spin_unlock_irqrestore(&glink->idr_lock, flags);
 
 	/* Decouple the potential rpdev from the channel */
-	if (channel->rpdev) {
-		strscpy(chinfo.name, channel->name, sizeof(chinfo.name));
-		chinfo.src = RPMSG_ADDR_ANY;
-		chinfo.dst = RPMSG_ADDR_ANY;
-
-		rpmsg_unregister_device(glink->dev, &chinfo);
-	}
-	channel->rpdev = NULL;
+	qcom_glink_remove_rpmsg_device(glink, channel);
 
 	kref_put(&channel->refcount, qcom_glink_channel_release);
 }
-- 
2.53.0



