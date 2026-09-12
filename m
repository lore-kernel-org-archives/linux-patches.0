Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16FE528030E;
	Sat, 12 Sep 2026 10:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207252; cv=none; b=hJQFHx5QDUJu32Aai1YZCUsh9plkPP4IdOJPee/EQs3fHFvME3M8xoddm+jvoWVnv6/THHJkXZ/dzUJ95uDjL6wKwlJjskc71NKqwTroDq1H600RWHjkn4njyrhVIzXx4feT6E8XcbQIKOt3NihV8Ji/HRiOW2XrBM8hJtFM1ZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207252; c=relaxed/simple;
	bh=X+f+ljRZNmRhx3j2c7pmjuwJpYXQt+QRxKKToGhDtLI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EMakygtPI1x6nQH8jB9E3W6Djvhd+q0JrHft0wsWDznSKlpNGd3Z6WJgAnGQHuoOlcS7NBE0+g4ZtKnIehfRaVNOgX1F59bb3XK9DReTNDK2T8StJVZqDbvNnqP9GBZqyxNI5U2ddGVqdS0ZXeTk8BeLv/Kw+I7awHUpip5ZhoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z0g2LBvE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z0g2LBvE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD88D1F000FF;
	Sat, 12 Sep 2026 10:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207250;
	bh=W2oIN3V3iE57Zqj1L8e5aFtTcp9wfCjvUN2tgHKtfUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z0g2LBvEdj9pYIFHdeJTfnxjLDM9uVi6aSovS//jFODhBxVB2HURHhIuifOKEj7l8
	 B9Pg2dKbAL2pfCDdX3IbV6i9NY6nsGD3sndYf9ZAoDoN5s25N0Dr7OZlt5IH03iU8S
	 jjmRaJDAm5zZ9GI7O0dGfbjAj2gNQOJi2wKf8sJU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0367/1518] rpmsg: glink: remove duplicate code for rpmsg device remove
Date: Sat, 12 Sep 2026 08:42:16 +0200
Message-ID: <20260912065631.774340454@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 833ff9cb8afe6..df9e98d76847b 100644
--- a/drivers/rpmsg/qcom_glink_native.c
+++ b/drivers/rpmsg/qcom_glink_native.c
@@ -1395,11 +1395,23 @@ static int qcom_glink_announce_create(struct rpmsg_device *rpdev)
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
@@ -1407,14 +1419,7 @@ static void qcom_glink_destroy_ept(struct rpmsg_endpoint *ept)
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
@@ -1704,7 +1709,6 @@ static int qcom_glink_rx_open(struct qcom_glink *glink, unsigned int rcid,
 
 static void qcom_glink_rx_close(struct qcom_glink *glink, unsigned int rcid)
 {
-	struct rpmsg_channel_info chinfo;
 	struct glink_channel *channel;
 	unsigned long flags;
 
@@ -1720,14 +1724,7 @@ static void qcom_glink_rx_close(struct qcom_glink *glink, unsigned int rcid)
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
 
 	qcom_glink_send_close_ack(glink, channel);
 
@@ -1741,7 +1738,6 @@ static void qcom_glink_rx_close(struct qcom_glink *glink, unsigned int rcid)
 
 static void qcom_glink_rx_close_ack(struct qcom_glink *glink, unsigned int lcid)
 {
-	struct rpmsg_channel_info chinfo;
 	struct glink_channel *channel;
 	unsigned long flags;
 
@@ -1763,14 +1759,7 @@ static void qcom_glink_rx_close_ack(struct qcom_glink *glink, unsigned int lcid)
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



