Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A76E751357E;
	Wed, 30 Sep 2026 16:55:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787302; cv=none; b=OPxoaqmlFhsockw6y5+Tmix6wHe0T92Du80NOlGBg5MolFxo/ABXPruoolIiiSifHq8wVJO5rrdTUAjrzvselnxiVpmffQ8waKf/NriKFnyvTV882ntJx8vfgOePkTeYlR1JEPB5tp0Y3seaYFi0Rt7ILuiXybaXRdgaLHsPkvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787302; c=relaxed/simple;
	bh=eWuXNUX0Ub4gqDNTEwAgbOMswS4iBngAEb/Wom1RIRo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I1/ua1kn3PacsUR/Tg3WmSNt94B5X0KPpRSc/yabDWI4r274nYmd6b8OvLgu6Hs5ZN3VbZPFENWYVrL0SsR0KRsOLx5twSFxEbixdm+J/TjgAxcoov53hwwKX/lTRpGnpJbgm9KqtFMXkftt1+TVes9KEV/B0UHqi0/OAtfktvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oNTQc9jJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oNTQc9jJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E5721F000FF;
	Wed, 30 Sep 2026 16:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787300;
	bh=c7Nfnsdp14lgFmfTjp5/6zobhYIIgW7U1OiDxZdY8J8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oNTQc9jJ0n/eGIaK5X2YcH9U6AkcBVV/JnIWSFoerMnJitsv4xUscyvPZiIZS10FL
	 o+fLRE5rt4tISSuz9XUStjjO8CGxnDerobHx+h5RX0voi5mOSZc0NinTEwJfJpo7EN
	 mW2P7fl6a/z6bI2rtrt1ryTopZC2TyRZvsDOjLSU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 182/457] net: bcmgenet: stop Tx NAPI before disabling the queues
Date: Wed, 30 Sep 2026 17:24:47 +0200
Message-ID: <20260930152349.979181401@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolai Buchwitz <nb@tipi-net.de>

[ Upstream commit 7e87508b5c4d81210d0a736ed01962e52f5c4c56 ]

bcmgenet_netif_stop() and the Wake-on-LAN branch of bcmgenet_suspend()
both disable the Tx queues first and stop Tx NAPI several steps later. A
completion in flight calls netif_tx_wake_queue() in between, and nothing
stops the queue again, so a transmit can reach the rings after they have
been freed.

Close is safe because dev_deactivate_many() stops the qdisc first.
bcmgenet_suspend() does not, so stop Tx NAPI before the queues on both
paths.

KASAN on a Raspberry Pi CM4, driven from an MTU change because suspend
freezes user space before the callback runs:

  BUG: KASAN: use-after-free in bcmgenet_xmit+0x17f8/0x2258
  Write of size 8 at addr ffffff8055844a68 by task ksoftirqd/0/14
   bcmgenet_xmit+0x17f8/0x2258
   dev_hard_start_xmit+0x13c/0x588
   sch_direct_xmit+0x108/0x340
   __dev_queue_xmit+0x1190/0x3848

Fixes: 254f3239dd07 ("net: bcmgenet: revise suspend/resume")
Signed-off-by: Nicolai Buchwitz <nb@tipi-net.de>
Link: https://patch.msgid.link/20260922130639.1660797-1-nb@tipi-net.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index b916080f4ff17..ca62041efecd7 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -3441,6 +3441,8 @@ static void bcmgenet_netif_stop(struct net_device *dev, bool stop_phy)
 {
 	struct bcmgenet_priv *priv = netdev_priv(dev);
 
+	/* Stop completion polling before it can wake a stopped queue */
+	bcmgenet_disable_tx_napi(priv);
 	netif_tx_disable(dev);
 
 	/* Disable MAC receive */
@@ -3455,7 +3457,6 @@ static void bcmgenet_netif_stop(struct net_device *dev, bool stop_phy)
 	/* Disable MAC transmit. TX DMA disabled must be done before this */
 	umac_enable_set(priv, CMD_TX_EN, false);
 
-	bcmgenet_disable_tx_napi(priv);
 	bcmgenet_disable_rx_napi(priv);
 	bcmgenet_intr_disable(priv);
 
@@ -4320,6 +4321,8 @@ static int bcmgenet_suspend(struct device *d)
 	netif_device_detach(dev);
 
 	if (device_may_wakeup(d) && priv->wolopts) {
+		/* Stop completion polling before it can wake a stopped queue */
+		bcmgenet_disable_tx_napi(priv);
 		netif_tx_disable(dev);
 
 		/* Suspend non-wake Rx data flows */
@@ -4348,7 +4351,6 @@ static int bcmgenet_suspend(struct device *d)
 			netdev_warn(priv->dev,
 				    "Timed out while disabling TX DMA\n");
 
-		bcmgenet_disable_tx_napi(priv);
 		bcmgenet_disable_rx_napi(priv);
 		disable_irq(priv->irq1);
 		bcmgenet_tx_reclaim_all(dev);
-- 
2.53.0



