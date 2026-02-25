Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAD5D1E2834;
	Wed, 25 Feb 2026 01:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983537; cv=none; b=sutSQNlJ8jTPYoSiDjhQ7Y2h8fc6BU+Yk3o9NIIYVrd+XtoIv7dH0c5Xh4yKKNsVcl0Nu2wg3vCaJ2CcglrEdRwNWDfq0De1xOA2u2KCwOREwMSgNg3vTwnfG/XASZMWHKeI+6zhCb/dHESARLeqeoWLPf6Mlc00McDavMBH/n4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983537; c=relaxed/simple;
	bh=FA9EUDHbOsV4GYEdGr+me3w08xWnBXoimw9zI8gg6tg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HqxD/0kPNcRIE+QGDWhPbvABUdTSUEpeXO1Z+WmVilPUWhdGGl8ovIJp3kaKpRlhVcjndLDiP2nE3NAUdbQhvs/tmy61/J3Dg8wK2tj6KQjVnsaISnRwH62WPT54dQexNPFUKTw1C3HF3aFOo1MNCF3f4wTqWSzSk4IuYHGFk1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=18aLs/xr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="18aLs/xr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6E58C116D0;
	Wed, 25 Feb 2026 01:38:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983536;
	bh=FA9EUDHbOsV4GYEdGr+me3w08xWnBXoimw9zI8gg6tg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=18aLs/xr/enKk40V8y+jUfYmGeDhh1h7XkCQopkNqN7l6KJr/sYR19CD6kR25vf6M
	 NuN6HlKLdFjapq4HI4kI7yRVx6XUm+oN4JVzwsP90kMtJA2lvtxEY8kXPH3H8j/H70
	 ieVIkkE+SDpHMIEdfSaz1pap7KEDjuQFIQpqq/PQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ziyi Guo <n7l8m4@u.northwestern.edu>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 641/781] net: mscc: ocelot: split xmit into FDMA and register injection paths
Date: Tue, 24 Feb 2026 17:22:30 -0800
Message-ID: <20260225012415.528713207@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ziyi Guo <n7l8m4@u.northwestern.edu>

[ Upstream commit 47f79b20e7fb885aa1623b759a68e8e27401ec4d ]

Split ocelot_port_xmit() into two separate functions:
- ocelot_port_xmit_fdma(): handles the FDMA injection path
- ocelot_port_xmit_inj(): handles the register-based injection path

The top-level ocelot_port_xmit() now dispatches to the appropriate
function based on the ocelot_fdma_enabled static key.

This is a pure refactor with no behavioral change. Separating the two
code paths makes each one simpler and prepares for adding proper locking
to the register injection path without affecting the FDMA path.

Signed-off-by: Ziyi Guo <n7l8m4@u.northwestern.edu>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://patch.msgid.link/20260208225602.1339325-3-n7l8m4@u.northwestern.edu
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 026f6513c588 ("net: mscc: ocelot: add missing lock protection in ocelot_port_xmit_inj()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mscc/ocelot_net.c | 39 ++++++++++++++++++++------
 1 file changed, 30 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index ef4a6c768de9b..a7966c174b2e2 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -571,7 +571,25 @@ static bool ocelot_xmit_timestamp(struct ocelot *ocelot, int port,
 	return true;
 }
 
-static netdev_tx_t ocelot_port_xmit(struct sk_buff *skb, struct net_device *dev)
+static netdev_tx_t ocelot_port_xmit_fdma(struct sk_buff *skb,
+					 struct net_device *dev)
+{
+	struct ocelot_port_private *priv = netdev_priv(dev);
+	struct ocelot_port *ocelot_port = &priv->port;
+	struct ocelot *ocelot = ocelot_port->ocelot;
+	int port = priv->port.index;
+	u32 rew_op = 0;
+
+	if (!ocelot_xmit_timestamp(ocelot, port, skb, &rew_op))
+		return NETDEV_TX_OK;
+
+	ocelot_fdma_inject_frame(ocelot, port, rew_op, skb, dev);
+
+	return NETDEV_TX_OK;
+}
+
+static netdev_tx_t ocelot_port_xmit_inj(struct sk_buff *skb,
+					struct net_device *dev)
 {
 	struct ocelot_port_private *priv = netdev_priv(dev);
 	struct ocelot_port *ocelot_port = &priv->port;
@@ -579,24 +597,27 @@ static netdev_tx_t ocelot_port_xmit(struct sk_buff *skb, struct net_device *dev)
 	int port = priv->port.index;
 	u32 rew_op = 0;
 
-	if (!static_branch_unlikely(&ocelot_fdma_enabled) &&
-	    !ocelot_can_inject(ocelot, 0))
+	if (!ocelot_can_inject(ocelot, 0))
 		return NETDEV_TX_BUSY;
 
 	if (!ocelot_xmit_timestamp(ocelot, port, skb, &rew_op))
 		return NETDEV_TX_OK;
 
-	if (static_branch_unlikely(&ocelot_fdma_enabled)) {
-		ocelot_fdma_inject_frame(ocelot, port, rew_op, skb, dev);
-	} else {
-		ocelot_port_inject_frame(ocelot, port, 0, rew_op, skb);
+	ocelot_port_inject_frame(ocelot, port, 0, rew_op, skb);
 
-		consume_skb(skb);
-	}
+	consume_skb(skb);
 
 	return NETDEV_TX_OK;
 }
 
+static netdev_tx_t ocelot_port_xmit(struct sk_buff *skb, struct net_device *dev)
+{
+	if (static_branch_unlikely(&ocelot_fdma_enabled))
+		return ocelot_port_xmit_fdma(skb, dev);
+
+	return ocelot_port_xmit_inj(skb, dev);
+}
+
 enum ocelot_action_type {
 	OCELOT_MACT_LEARN,
 	OCELOT_MACT_FORGET,
-- 
2.51.0



