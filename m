Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC8A72550D7;
	Wed, 25 Feb 2026 01:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983535; cv=none; b=lR6KIIHZA8beFHHJEtRrValCW9xGVBDsU5/v2eoH5U0VloyjobqWOGes1sZts9ns7gdrqT/zTUZIQZ84T7j59Yl/tF88leXc23v4/VhosIX0IT+j0Q2Tdnqj9P8gHLlGii+6cvj9zpw48uGhMmPcVzBIwkDm361SAjjbGby9y4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983535; c=relaxed/simple;
	bh=1tgsdUePlenlQmvtLxq7YSmaQphKNcCpAzh/l4l2a5A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c3O7QYFqFF6cU1MKzWTc/rU/6CYRqB6fgzQYkVj98JNOZ8qc9DmCj+ykWUNkfdFlMCXAWZfF043JFrvHr5zYDVgsMewKecaMYYk0sJmzhep76ZC1YCh74Qp7GCHWRINQDOAMp3U2oqYkbaLVtb/pjzNi2gwueHpqsJSMe/AZyBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=opS/bl/v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="opS/bl/v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 868E2C116D0;
	Wed, 25 Feb 2026 01:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983535;
	bh=1tgsdUePlenlQmvtLxq7YSmaQphKNcCpAzh/l4l2a5A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=opS/bl/vrnS7NBhN7mveK4xnukDKXx57djycH9G/Kaz3g9X6UECZU6DuH10CD96/U
	 OhSSIsyDkcBnunLvHVeoFh6o+jz+vfQnC0gg05WYDQ7ZtG22xxi1vd/x2rwDPOXtGc
	 ILfNEVHZGjwAbrm1HcC1CNTS8pkY3rYJTTVT/irM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ziyi Guo <n7l8m4@u.northwestern.edu>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 640/781] net: mscc: ocelot: extract ocelot_xmit_timestamp() helper
Date: Tue, 24 Feb 2026 17:22:29 -0800
Message-ID: <20260225012415.502442950@linuxfoundation.org>
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
index 469784d3a1a67..ef4a6c768de9b 100644
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



