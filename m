Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42A5E2F531B;
	Sat, 12 Sep 2026 12:19:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215597; cv=none; b=iit/dw2Nw8BdNUGqXtikPq7GX88QMwD/pzlMKajAv/+Tao3sU/5StQ4SyiPw3fTZUWQXPpdK15Lgc7Fmb2H3HvHuxrMAZfEQsz2i4+MBkKpRFnyg6kC95woNfkt6MOlhRnSXFd/xeAdmqXAwEX/RkxQfuxhZuX4jVx3zqCksOo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215597; c=relaxed/simple;
	bh=YcP5/h3r2oF0sZvoRLXnf99HqDpvYl54a1zI/hhtxPs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fTSKMGAtw55ZI8K7scWWZ/oYhPOtkwVI7JqnT+bUjwfYs7whHAsHzeLhaGPoJ5iumeKrVBduvmSspBvHMSVCBSVSm1zaVvsFTPP9tARpnIyXgBqYqIbXhy3A24kBM/H/mwZ/6vwcsObQxGB3pczvtXaBglf+92FrlLMtdUbi2KI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IHQxVPSc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IHQxVPSc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF01F1F000FF;
	Sat, 12 Sep 2026 12:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215596;
	bh=TiC3sbQ6BwP/1VqFN3SgqC2AJMfmd1KNahv5Irvnsy0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IHQxVPSch9Nx7pNwYOe/l2l6NJtuaswhaJ2XSAxs9p7H9XmPVG5Jv9sTbHf7213U4
	 UoLQqpBKQnHzXTe/VQFHJye74XFSx4nIDj5xiXr/tPi2jmhn989Zq8g4wj6Ffq74cx
	 gB/lqJVXrUGlU96Y/MXVH96XKw0lmFPeF2LAdC7U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0521/1376] rpmsg: glink: remove duplicate code for rpmsg device remove
Date: Sat, 12 Sep 2026 08:49:07 +0200
Message-ID: <20260912065619.148127033@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index c2d39a3bcea7e..9d4fee6409423 100644
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



