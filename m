Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBE9233A713
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302252; cv=none; b=qcdukQtY2H0W4TVQsV416Uame6uQVwy2742o1g+CdMqoxoVsTau9KeiecGpq2qrY6fibMUasq61HnI0PnEWKNifB5XZ2fR03bNedonmEQ15xzj57Abpw21B60fdff+MEUbpGxdIvD7jX41ivNg2bMCkS/Pe6kSpzXrLthd/uQJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302252; c=relaxed/simple;
	bh=713Qkt+6vk3owa1bwIn4H3CN7awOJ3iY1hrIvc1cF8A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YnPpAXKStMfF0WsASmnael5d67YF7VsmEsTEDYGPlyggszmNl0OyVy6NZbxD/c5sbB6p42t1umqWcN19cS35efBnJh34f9rYP+t6DQ3vE5Fu+CsRgWdp7zuQe6SONrOUfMwnPYqSI7fTKKKSgsV7xCBBKznbzmunr58Ut8g9MKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X90a2Z4L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X90a2Z4L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27862C19424;
	Sat, 28 Feb 2026 18:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302252;
	bh=713Qkt+6vk3owa1bwIn4H3CN7awOJ3iY1hrIvc1cF8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X90a2Z4LZjCNbmMUqwd9ve0tYuo0ZmX/6cHRhbvm+h+Tg3dvTlTySY2B5O2+JHU1g
	 cFaPSbFUvs56N9EK34g2PHq5OmRKEnAqP9mWrYd1KQUzPRhRyMfTlIjKyFsWLO9NmY
	 bC2Me15Pr9N8foRuVqitd3xMIqB1N3zDeERu6ZIAoiXraUNBL4EbekqUvF4RdGs88y
	 lHZdEbTiA3+aP81NEVieAH4YKaHWgRbQlNPgwQ4vLgVInjHNech5nGzjlumIONvK9L
	 8g4UDZdHgp05QJu8HIjWSO8eiuLA01VrA3d0gXmKPTx86F0Eo5WdLrNkaD/c4S6OLL
	 KR9+EHWwL+Nbg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Ziyi Guo <n7l8m4@u.northwestern.edu>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 266/283] net: mscc: ocelot: extract ocelot_xmit_timestamp() helper
Date: Sat, 28 Feb 2026 13:06:48 -0500
Message-ID: <20260228180709.1583486-266-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
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
index 21a87a3fc5562..e2b475bf58e6c 100644
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

