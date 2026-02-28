Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A21C359A98
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302471; cv=none; b=t1vq1I9V9tiwpyPcVK4YnWZNx3CjCw+x10419Dr7H8RJ8Qm1jTq4N1hBAPQ6o//OfDSH4Z0lQuAfTWS4TyvhFSAWBzcfLOR1UL/XgAqIWONP6IBAKU8N7bdfL6Oy6QKlRyUiHCCLIK7/sdR3425u7wJza24ctq8FLjl9kgDU49U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302471; c=relaxed/simple;
	bh=7N7zgOSNzhEuQ3vUKF4lLQTB7okgm+3KjMcxRb0s680=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cilP2jDAe0D6EgZfPvC20M30U3AsVAih+bux15mUzHu+AbJDbhSDZTeI2/K0+RQsSqRZnTB4MeSQmIhRU1E9Xa+lY322TRO5fwjtTyxs/OxCLTEy0F8AkKO6JIGEHZDsLDpzvgvYHw1lN2hMY6xsQS6hZI/WQT6zEJ14kcvRE2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bztdSApR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bztdSApR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D87D3C116D0;
	Sat, 28 Feb 2026 18:14:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302471;
	bh=7N7zgOSNzhEuQ3vUKF4lLQTB7okgm+3KjMcxRb0s680=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bztdSApRAY6VpVkX8u1GexfA3d0xi5LOvBQGupmTCtWpmfvKIhEBkWvT8SwLI3IzG
	 it48jZ8fcCmLIRGahk+s1BkUkarvnJAfhp4nsTbkbOnJbH+Z1xipyMmFF13u+xFguX
	 ONdJHjTkRgPRVQpmYgHtCI0YPAXrKovFLquTlJwXHOMHz0zBVQCtgm7BcMjJQqHstT
	 L1iajE4FH41La79dEjALkTfSwfODG4jPV79mVMKl+Mr9dfB2EbPzybEvq8mk5zKdbm
	 vyEQvwnz2oXskUjX/5BiN+/e+Qv+eu+gHLfTJd7mTU43sf3a0yJdPxSOUFbiOBB3hd
	 hP3jDPpumabXg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Ziyi Guo <n7l8m4@u.northwestern.edu>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 216/232] net: mscc: ocelot: split xmit into FDMA and register injection paths
Date: Sat, 28 Feb 2026 13:11:09 -0500
Message-ID: <20260228181127.1592657-216-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
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
index 38d0c1af10a96..14de948f72464 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -580,7 +580,25 @@ static bool ocelot_xmit_timestamp(struct ocelot *ocelot, int port,
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
@@ -588,24 +606,27 @@ static netdev_tx_t ocelot_port_xmit(struct sk_buff *skb, struct net_device *dev)
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

