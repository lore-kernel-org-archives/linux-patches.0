Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82D6C4078D3;
	Thu, 17 Sep 2026 18:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789670861; cv=none; b=Brw3vXgrld6Psuxp9yvYKA7HIydRziEjX9BHeGaR/pSGax7AhaRsXyhtxkxuXZ49D46kAvvWjOMvU9eHBdJJlfi1m3QL2AQE6B/tEP5+6F1bt2FR/2PbYEEgptrbbssL4+n6kLS2/l8SlqPNN00NbN/N82P5HN3ZyE+xGyhKfn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789670861; c=relaxed/simple;
	bh=hXjwRLvZbBtuwdu82Wub6RElr+LKuTBNqNbZO2bmI5w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NLWxFgdnpKlnAjU48y3Q/sscZ/jJZKifonSNDw934gnuGpIseT7ZWbKWU+gyMu99RZgH8/yQXs7wxKoznRbZzjIg0OG8e9KCa3ih4yi/QlkNN2xlfgd3b+/8oSFxB6Bd++KTckTSLfV0xAfb6WvOeaGVb4jWIcqLA/1f2gLQd0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bgyP4lPa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bgyP4lPa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A37EB1F00893;
	Thu, 17 Sep 2026 18:47:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789670860;
	bh=D324VN58EZ08JTKH+oireoUux3thw9xIw6sTRZjdn+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bgyP4lPaG3j/tNCmvei7eREN56iWTtdg7/EJA/ibvwY7Wf0pT+ZHZf8I6yHMrD99R
	 TGaULuIjGWSwF/SoBGdWdiOmsTfbK/BTjbTyWiXyLnH/EWqftzC0FLz28+WtGGv8M/
	 z7HwmX3sFWvmSi0lQPH3/vaZUFj+KZn6C/81JQv4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0792/1102] net: stmmac: fix TSO support when some channels have TBS available
Date: Thu, 17 Sep 2026 16:12:15 +0100
Message-ID: <20260917151600.353160972@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

[ Upstream commit e32820264c2949a3e75bc5083e49c885e3bbaf62 ]

According to the STM32MP25xx manual, which is dwmac v5.3, TBS (time
based scheduling) is not permitted for channels which have hardware
TSO enabled. Intel's commit 5e6038b88a57 ("net: stmmac: fix TSO and
TBS feature enabling during driver open") concurs with this, but it
is incomplete.

This commit avoids enabling TSO support on the channels which have
TBS available, which, as far as the hardware is concerned, means we
do not set the TSE bit in the DMA channel's transmit control register.

However, the net device's features apply to all queues(channels), which
means these channels may still be handed TSO skbs to transmit, and the
driver will pass them to stmmac_tso_xmit(). This will generate the
descriptors for TSO, even though the channel has the TSE bit clear.

Fix this by checking whether the queue(channel) has TBS available,
and if it does, fall back to software GSO support.

Fixes: 5e6038b88a57 ("net: stmmac: fix TSO and TBS feature enabling during driver open")
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Link: https://patch.msgid.link/E1w7ptE-0000000Easz-28tv@rmk-PC.armlinux.org.uk
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 5e38d732ec67 ("net: stmmac: fix TX descriptor availability check for TSO traffic")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 32 ++++++++++++++++---
 1 file changed, 28 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 1184a6833d753..548e2be390d23 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -3367,6 +3367,17 @@ static void stmmac_safety_feat_configuration(struct stmmac_priv *priv)
 	}
 }
 
+/* STM32MP25xx (dwmac v5.3) states "Do not enable time-based scheduling for
+ * channels on which the TSO feature is enabled." If we have a skb for a
+ * channel which has TBS enabled, fall back to software GSO.
+ */
+static bool stmmac_tso_channel_permitted(struct stmmac_priv *priv,
+					 unsigned int chan)
+{
+	/* TSO and TBS cannot co-exist */
+	return !(priv->dma_conf.tx_queue[chan].tbs & STMMAC_TBS_AVAIL);
+}
+
 /**
  * stmmac_hw_setup - setup mac in a usable state.
  *  @dev : pointer to the device structure.
@@ -3492,10 +3503,7 @@ static int stmmac_hw_setup(struct net_device *dev, bool ptp_register)
 	/* Enable TSO */
 	if (priv->tso) {
 		for (chan = 0; chan < tx_cnt; chan++) {
-			struct stmmac_tx_queue *tx_q = &priv->dma_conf.tx_queue[chan];
-
-			/* TSO and TBS cannot co-exist */
-			if (tx_q->tbs & STMMAC_TBS_AVAIL)
+			if (!stmmac_tso_channel_permitted(priv, chan))
 				continue;
 
 			stmmac_enable_tso(priv, priv->ioaddr, 1, chan);
@@ -4708,6 +4716,21 @@ static netdev_tx_t stmmac_xmit(struct sk_buff *skb, struct net_device *dev)
 	return NETDEV_TX_OK;
 }
 
+static netdev_features_t stmmac_features_check(struct sk_buff *skb,
+					       struct net_device *dev,
+					       netdev_features_t features)
+{
+	u16 queue;
+
+	if (skb_is_gso(skb)) {
+		queue = skb_get_queue_mapping(skb);
+		if (!stmmac_tso_channel_permitted(netdev_priv(dev), queue))
+			features &= ~NETIF_F_GSO_MASK;
+	}
+
+	return vlan_features_check(skb, features);
+}
+
 static void stmmac_rx_vlan(struct net_device *dev, struct sk_buff *skb)
 {
 	struct vlan_ethhdr *veth = skb_vlan_eth_hdr(skb);
@@ -7086,6 +7109,7 @@ static void stmmac_get_stats64(struct net_device *dev, struct rtnl_link_stats64
 static const struct net_device_ops stmmac_netdev_ops = {
 	.ndo_open = stmmac_open,
 	.ndo_start_xmit = stmmac_xmit,
+	.ndo_features_check = stmmac_features_check,
 	.ndo_stop = stmmac_release,
 	.ndo_change_mtu = stmmac_change_mtu,
 	.ndo_fix_features = stmmac_fix_features,
-- 
2.53.0



