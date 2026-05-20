Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF322343880;
	Wed, 20 May 2026 18:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779301880; cv=none; b=Ow3KS0uXmP7FPBIpOzRiDJSs03mR1VtyNy7ZxGnFGASTpkqNrLxr6RCrZxy6ZahEBl7zMAHD+w3GfXP+5RrEUCNEE9QUvqSNStpBmXi1pgP2IwBBTS4OU5qtHcJpj0QdouYz1hwaZYxkP/KKAIMZ9yajzPNOQ5x4Fr4wuaUF9cA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779301880; c=relaxed/simple;
	bh=XKTws6MsbJQyToNPtl1D64MpJ/iaV3WdCShtHPaoEFg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EeRH0WQ2rn+anDiisvdGodOlmihSIc6lSlAWCJWnO3kmoDKm/EsXY7dQVwrhVrkeL1hh72se5dDc9VAyx/vsAHfFeIp9YgsquyLCPz//457oaRz8M665STtkzQNVtzLAMsVESSOVa+NWtlEFWWVv0MpSy4ZOWMBdTuTd6Kq6CDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b5Redpdu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b5Redpdu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FB4C1F000E9;
	Wed, 20 May 2026 18:31:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779301879;
	bh=Fk+K3+Jbm4yCd1aY/vNv0cf51/dMeg5BzG5MmAwdLn0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b5RedpduNFnbeojlE6cpFITu7343Q5E43h3RkthAIlYkoGSXJTgy1DzQzSrAXRhty
	 OE3P+OknsXYYIqyDUTxV/2OvCs/xX/0aA4qVnf3GwfZQUMq/YSGNMjuH0ybpRNJpwc
	 BVUBcBviAFiFBrStALxx0hfiJSOTfS9vnRTXJzO4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 055/508] net: bcmgenet: Remove custom ndo_poll_controller()
Date: Wed, 20 May 2026 18:17:58 +0200
Message-ID: <20260520162059.792345231@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

From: Florian Fainelli <florian.fainelli@broadcom.com>

[ Upstream commit 19537e125cc7cf2da43a606f5bcebbe0c9aea4cc ]

The driver gained a .ndo_poll_controller() at a time where the TX
cleaning process was always done from NAPI which makes this unnecessary.
See commit ac3d9dd034e5 ("netpoll: make ndo_poll_controller() optional")
for more background.

Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 5393b2b5bee2 ("net: bcmgenet: fix racing timeout handler")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/broadcom/genet/bcmgenet.c    | 20 -------------------
 1 file changed, 20 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index cdbe47c7ba280..6ba26feed4588 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -3255,23 +3255,6 @@ static irqreturn_t bcmgenet_wol_isr(int irq, void *dev_id)
 	return IRQ_HANDLED;
 }
 
-#ifdef CONFIG_NET_POLL_CONTROLLER
-static void bcmgenet_poll_controller(struct net_device *dev)
-{
-	struct bcmgenet_priv *priv = netdev_priv(dev);
-
-	/* Invoke the main RX/TX interrupt handler */
-	disable_irq(priv->irq0);
-	bcmgenet_isr0(priv->irq0, priv);
-	enable_irq(priv->irq0);
-
-	/* And the interrupt handler for RX/TX priority queues */
-	disable_irq(priv->irq1);
-	bcmgenet_isr1(priv->irq1, priv);
-	enable_irq(priv->irq1);
-}
-#endif
-
 static void bcmgenet_umac_reset(struct bcmgenet_priv *priv)
 {
 	u32 reg;
@@ -3741,9 +3724,6 @@ static const struct net_device_ops bcmgenet_netdev_ops = {
 	.ndo_set_mac_address	= bcmgenet_set_mac_addr,
 	.ndo_eth_ioctl		= phy_do_ioctl_running,
 	.ndo_set_features	= bcmgenet_set_features,
-#ifdef CONFIG_NET_POLL_CONTROLLER
-	.ndo_poll_controller	= bcmgenet_poll_controller,
-#endif
 	.ndo_get_stats		= bcmgenet_get_stats,
 	.ndo_change_carrier	= bcmgenet_change_carrier,
 };
-- 
2.53.0



