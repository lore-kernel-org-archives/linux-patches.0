Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08CA8379EF1
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:05:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301932; cv=none; b=DxUKOWDbwnvdQXwe3M972S4UldENux8GxqJhscTClkjM4o5nfp6YTLqtwybLfAZjoDafkrw+Q2L/QXVywVIQ2rzHmdRXsBUXLv1Ko91XHk6qlZ0cNwko5DXdx0w1LDv1lWLD1cDc2FxIIeFRkamPeA3o+H861vhJPyinsH83HAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301932; c=relaxed/simple;
	bh=3fvs9MCE0vliuxMKLSSq5/GrPFam35LFeTzzFVu+hZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q/zU3o+oEO06wn0HiqXGCvqjWCUNOD8dxYj842+CPOz0VadUMGKi+on/8Q0S916CP0+6evk03QA8PP9jOGuy3dxT7mVjFRZYLfJNtPq/rPPULLTqTL5+klv84fmKWpSo69uKm/1ZcvSuR8cZhMygbOiTb1wlE6CE9lszlxX/qZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gR1uhSux; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gR1uhSux"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5617DC19425;
	Sat, 28 Feb 2026 18:05:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301931;
	bh=3fvs9MCE0vliuxMKLSSq5/GrPFam35LFeTzzFVu+hZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gR1uhSuxCuhGcLoYAHlrkxaOwXJVXheamlTORQP1BoSXUpUE23kcn/XaFja1N2m+Y
	 S8RUrymYw/DBXzmsZ7+E7wPN2uD/mQd6F2S/pc6aoLfnlKv83+QP5MvKUe5gaSvgEk
	 vPVTvRPzsW8tqp6TTmQSrxsdmmldYLWg/PdV7jgsBEHcHG18yRcvRTiFgnto1oQMwd
	 Yxno1SA5xNqOa5rk6EFSxT1xT4QkyhTDA43es4MFXutsct6M0KXICG+10mFUjYp/eB
	 jAuyD8YNDIwLHQLmw7dfD28ztHcowYGjoQSxjfKdSe0JIi0fOxjPRg4iZ22doX5KOO
	 haI63oege5SHQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Ziyi Guo <n7l8m4@u.northwestern.edu>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 367/385] net: mscc: ocelot: extract ocelot_xmit_timestamp() helper
Date: Sat, 28 Feb 2026 12:59:49 -0500
Message-ID: <20260228180011.1568201-367-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Ziyi Guo <n7l8m4@u.northwestern.edu>

[ Upstream commit 29372f07f7969a2f0490793226ecf6c8c6bde0fa ]

Extract the PTP timestamp handling logic from ocelot_port_xmit() into a
separate ocelot_xmit_timestamp() helper function. This is a pure
refactor with no behavioral change.

The helper returns false if the skb was consumed (freed) due to a
timestamp request failure, and true if the caller should continue with
frame injection. The rew_op value is returned via pointer.

This prepares for splitting ocelot_port_xmit() into separate FDMA and
register injection paths in a subsequent patch.

Signed-off-by: Ziyi Guo <n7l8m4@u.northwestern.edu>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://patch.msgid.link/20260208225602.1339325-2-n7l8m4@u.northwestern.edu
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 026f6513c588 ("net: mscc: ocelot: add missing lock protection in ocelot_port_xmit_inj()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mscc/ocelot_net.c | 36 ++++++++++++++++----------
 1 file changed, 22 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index 7c9540a717251..5d2d40cb8333d 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -551,33 +551,41 @@ static int ocelot_port_stop(struct net_device *dev)
 	return 0;
 }
 
-static netdev_tx_t ocelot_port_xmit(struct sk_buff *skb, struct net_device *dev)
+static bool ocelot_xmit_timestamp(struct ocelot *ocelot, int port,
+				  struct sk_buff *skb, u32 *rew_op)
 {
-	struct ocelot_port_private *priv = netdev_priv(dev);
-	struct ocelot_port *ocelot_port = &priv->port;
-	struct ocelot *ocelot = ocelot_port->ocelot;
-	int port = priv->port.index;
-	u32 rew_op = 0;
-
-	if (!static_branch_unlikely(&ocelot_fdma_enabled) &&
-	    !ocelot_can_inject(ocelot, 0))
-		return NETDEV_TX_BUSY;
-
-	/* Check if timestamping is needed */
 	if (ocelot->ptp && (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP)) {
 		struct sk_buff *clone = NULL;
 
 		if (ocelot_port_txtstamp_request(ocelot, port, skb, &clone)) {
 			kfree_skb(skb);
-			return NETDEV_TX_OK;
+			return false;
 		}
 
 		if (clone)
 			OCELOT_SKB_CB(skb)->clone = clone;
 
-		rew_op = ocelot_ptp_rew_op(skb);
+		*rew_op = ocelot_ptp_rew_op(skb);
 	}
 
+	return true;
+}
+
+static netdev_tx_t ocelot_port_xmit(struct sk_buff *skb, struct net_device *dev)
+{
+	struct ocelot_port_private *priv = netdev_priv(dev);
+	struct ocelot_port *ocelot_port = &priv->port;
+	struct ocelot *ocelot = ocelot_port->ocelot;
+	int port = priv->port.index;
+	u32 rew_op = 0;
+
+	if (!static_branch_unlikely(&ocelot_fdma_enabled) &&
+	    !ocelot_can_inject(ocelot, 0))
+		return NETDEV_TX_BUSY;
+
+	if (!ocelot_xmit_timestamp(ocelot, port, skb, &rew_op))
+		return NETDEV_TX_OK;
+
 	if (static_branch_unlikely(&ocelot_fdma_enabled)) {
 		ocelot_fdma_inject_frame(ocelot, port, rew_op, skb, dev);
 	} else {
-- 
2.51.0

