Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B22D926ED46;
	Sat, 12 Sep 2026 19:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242533; cv=none; b=sBJBfglJ+LZte6ioESVyvWkxCcZoEgyEKH0aW2+VycpusaC/2bMgz5+2lcBXdpMoCfSAFe0HADMQI2WAmdP0sai/8uLRZrkm7l3/BYVKQTKoCG0cXDfhvK5QobtQDP3dQVTwXFCz8wcPBU4io7mAnLosPzfAPtH/wO9wmRmmb8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242533; c=relaxed/simple;
	bh=y32yflCqVmLcGbMEqQ0qvyqrtNZ91j0Paz3Xpy6Sm3M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r2Nl9yMYBUIBq9yfSwmjP8NI2pun5ONBjLVTxPRM39+zulmhEX8949zqPjwoPPUZEYyPjFTU36aM4UX/b7WH6a3RyezIUvOgJ6YLFwwxhxn/7Am9DS0gS1wmniMTzuQ4VAgLV9PoL+zchYynPdAZIld+yVf7iYbMl8D+SR32tzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tjso0GHx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tjso0GHx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17ECC1F000FF;
	Sat, 12 Sep 2026 19:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242532;
	bh=hWErFRl5nf4BfjpUVwSLbrb24pHEUL96HE/d1aOGj0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Tjso0GHxWvwyMO6+l5h1J8SHBZ6IZsALycnzVtCnyuyiDG7PRzbuPbg+6rsGVBysS
	 sJAt8hqHWcfDYEfQVETaeohykD40oqIcXH4LRva9R0YbmqDapLQYKOA2tukWfph4Lv
	 2GSmxwXeaFpuDH4nfJbXCLR7nDFWqshj2YLnm3S0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 438/798] rpmsg: glink: remove duplicate code for rpmsg device remove
Date: Sat, 12 Sep 2026 09:01:06 +0200
Message-ID: <20260912065527.179445570@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 02e0f09e7d787..d9aab8042d9d6 100644
--- a/drivers/rpmsg/qcom_glink_native.c
+++ b/drivers/rpmsg/qcom_glink_native.c
@@ -1240,11 +1240,23 @@ static int qcom_glink_announce_create(struct rpmsg_device *rpdev)
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
@@ -1252,14 +1264,7 @@ static void qcom_glink_destroy_ept(struct rpmsg_endpoint *ept)
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
@@ -1535,7 +1540,6 @@ static int qcom_glink_rx_open(struct qcom_glink *glink, unsigned int rcid,
 
 static void qcom_glink_rx_close(struct qcom_glink *glink, unsigned int rcid)
 {
-	struct rpmsg_channel_info chinfo;
 	struct glink_channel *channel;
 	unsigned long flags;
 
@@ -1548,14 +1552,7 @@ static void qcom_glink_rx_close(struct qcom_glink *glink, unsigned int rcid)
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
 
@@ -1569,7 +1566,6 @@ static void qcom_glink_rx_close(struct qcom_glink *glink, unsigned int rcid)
 
 static void qcom_glink_rx_close_ack(struct qcom_glink *glink, unsigned int lcid)
 {
-	struct rpmsg_channel_info chinfo;
 	struct glink_channel *channel;
 	unsigned long flags;
 
@@ -1588,14 +1584,7 @@ static void qcom_glink_rx_close_ack(struct qcom_glink *glink, unsigned int lcid)
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



