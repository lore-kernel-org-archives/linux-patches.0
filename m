Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F41B115DBAD;
	Mon, 29 Jan 2024 17:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548431; cv=none; b=g5DAdznmrth/gxBMmwy1RbqrGfBbMQi2WSaMHafmL1dpBe/MMDlOiH9p2U1QJInipRNjuTQ65zgWBm4bu92njTMjXvscIk+SCC9OUipRn9V2UPZdJdK2R8x51yH77Xg1/4BUkM+2Rx+BZ7tK8Smh9knsWKDD3U3sA6S1HwrRCoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548431; c=relaxed/simple;
	bh=IKYQ0nUkgwiE+y0mUqyyesMWPGQwq85ALly18YK6QW0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cwUvsXCvCkpbKuiL3KC2qT/HEJC6+8BQRGwk/auM1liB2zvAkiMu0qLB/cidS+4+j8+c6kgGSvTD14av/znO3bcAR1Lzp7JVzwqwP3luDuEpN8O1VgBj00E16BQxclla+E8hAgiwHaabn2bHyf2JkXxzGGqaewiM8oNRoNirZuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mV4E8mO2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mV4E8mO2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBC3CC433C7;
	Mon, 29 Jan 2024 17:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548430;
	bh=IKYQ0nUkgwiE+y0mUqyyesMWPGQwq85ALly18YK6QW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mV4E8mO24BPRUrcFC9C2+6xmOXFp/TgACGfT3W4vSyJCWJ7rS9qg6zSwOt7RcFShe
	 qTvnW0zsKnr/ZEnd1Nw6w+OwB3o+wrDRA2bwG3ZmhMbWOrWuJ9pbAhI5nunisvnuPS
	 JvUtxrT1/uuVTckvdnB9Tf9l1UflD5Eb4/GJAsJ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Tresidder <rtresidd@electromag.com.au>,
	Romain Gantois <romain.gantois@bootlin.com>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 009/331] net: stmmac: Prevent DSA tags from breaking COE
Date: Mon, 29 Jan 2024 09:01:13 -0800
Message-ID: <20240129170015.238137986@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Romain Gantois <romain.gantois@bootlin.com>

[ Upstream commit c2945c435c999c63e47f337bc7c13c98c21d0bcc ]

Some DSA tagging protocols change the EtherType field in the MAC header
e.g.  DSA_TAG_PROTO_(DSA/EDSA/BRCM/MTK/RTL4C_A/SJA1105). On TX these tagged
frames are ignored by the checksum offload engine and IP header checker of
some stmmac cores.

On RX, the stmmac driver wrongly assumes that checksums have been computed
for these tagged packets, and sets CHECKSUM_UNNECESSARY.

Add an additional check in the stmmac TX and RX hotpaths so that COE is
deactivated for packets with ethertypes that will not trigger the COE and
IP header checks.

Fixes: 6b2c6e4a938f ("net: stmmac: propagate feature flags to vlan")
Cc:  <stable@vger.kernel.org>
Reported-by: Richard Tresidder <rtresidd@electromag.com.au>
Link: https://lore.kernel.org/netdev/e5c6c75f-2dfa-4e50-a1fb-6bf4cdb617c2@electromag.com.au/
Reported-by: Romain Gantois <romain.gantois@bootlin.com>
Link: https://lore.kernel.org/netdev/c57283ed-6b9b-b0e6-ee12-5655c1c54495@bootlin.com/
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Romain Gantois <romain.gantois@bootlin.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/stmicro/stmmac/stmmac_main.c | 32 +++++++++++++++++--
 1 file changed, 29 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 59e07efe08c9..684ec7058c82 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -4356,6 +4356,28 @@ static netdev_tx_t stmmac_tso_xmit(struct sk_buff *skb, struct net_device *dev)
 	return NETDEV_TX_OK;
 }
 
+/**
+ * stmmac_has_ip_ethertype() - Check if packet has IP ethertype
+ * @skb: socket buffer to check
+ *
+ * Check if a packet has an ethertype that will trigger the IP header checks
+ * and IP/TCP checksum engine of the stmmac core.
+ *
+ * Return: true if the ethertype can trigger the checksum engine, false
+ * otherwise
+ */
+static bool stmmac_has_ip_ethertype(struct sk_buff *skb)
+{
+	int depth = 0;
+	__be16 proto;
+
+	proto = __vlan_get_protocol(skb, eth_header_parse_protocol(skb),
+				    &depth);
+
+	return (depth <= ETH_HLEN) &&
+		(proto == htons(ETH_P_IP) || proto == htons(ETH_P_IPV6));
+}
+
 /**
  *  stmmac_xmit - Tx entry point of the driver
  *  @skb : the socket buffer
@@ -4420,9 +4442,13 @@ static netdev_tx_t stmmac_xmit(struct sk_buff *skb, struct net_device *dev)
 	/* DWMAC IPs can be synthesized to support tx coe only for a few tx
 	 * queues. In that case, checksum offloading for those queues that don't
 	 * support tx coe needs to fallback to software checksum calculation.
+	 *
+	 * Packets that won't trigger the COE e.g. most DSA-tagged packets will
+	 * also have to be checksummed in software.
 	 */
 	if (csum_insertion &&
-	    priv->plat->tx_queues_cfg[queue].coe_unsupported) {
+	    (priv->plat->tx_queues_cfg[queue].coe_unsupported ||
+	     !stmmac_has_ip_ethertype(skb))) {
 		if (unlikely(skb_checksum_help(skb)))
 			goto dma_map_err;
 		csum_insertion = !csum_insertion;
@@ -4982,7 +5008,7 @@ static void stmmac_dispatch_skb_zc(struct stmmac_priv *priv, u32 queue,
 	stmmac_rx_vlan(priv->dev, skb);
 	skb->protocol = eth_type_trans(skb, priv->dev);
 
-	if (unlikely(!coe))
+	if (unlikely(!coe) || !stmmac_has_ip_ethertype(skb))
 		skb_checksum_none_assert(skb);
 	else
 		skb->ip_summed = CHECKSUM_UNNECESSARY;
@@ -5498,7 +5524,7 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 		stmmac_rx_vlan(priv->dev, skb);
 		skb->protocol = eth_type_trans(skb, priv->dev);
 
-		if (unlikely(!coe))
+		if (unlikely(!coe) || !stmmac_has_ip_ethertype(skb))
 			skb_checksum_none_assert(skb);
 		else
 			skb->ip_summed = CHECKSUM_UNNECESSARY;
-- 
2.43.0



