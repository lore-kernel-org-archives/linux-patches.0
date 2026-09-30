Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1376A4322EC;
	Wed, 30 Sep 2026 19:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795232; cv=none; b=E3O5/6i/B5/NjebflRQldhw7iFUe5kf/zbgChyYnKk4vGgyOSw0b1EYF5HdHYF8vIT+xDgCllbL5pjyDbI5OC4NY8Ay+ZPtKrM4dLpWNMjG/ub3PsmG2YXokba1tn46dDdt8mbWys4qkNPG9F32hncOcoscso1bJCpLBTzrCn2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795232; c=relaxed/simple;
	bh=Q9aIUMAeC+AFgY4ZfhYHcrhnmP95QT4RPBpmvxgmSsw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G8F0ih2i41U0WFJgRvwXv/974NKlUIJ2jq466PzjgIBcHAzAoTZUooWvoUXgadCpVMQbgxV8Juehwr9Arnpc8Tii4nyyn3P/7MLAxgFPh29J9bzHfhp7ewN9qCs+pnuQVcxL9OmV5Tx94Cc9jII8xJtHDA7+vx/U3D3Ms3YFBd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ll/BX+Qi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ll/BX+Qi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7339D1F0089B;
	Wed, 30 Sep 2026 19:07:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795231;
	bh=hYbi4WdUVD3pgzXXgxkBWsCfASCr53GnqDMsgTjiLNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ll/BX+QiZzz79JnXJ+shuZH8OBozGk5EPkRgdIRvjqP1GnuPUncxxqpDYs/uU6qpV
	 EilNrm6kGsid/+r4XLH07U7z0x6aNFzbYPhJc87chTjDVWwDxEmhw5RwB8trWoy98O
	 q/kQZcYhXCrNleyVUSqXsm0VapBzFXXVavKl63Uw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Hangbin Liu <liuhangbin@kylinos.cn>,
	Jay Vosburgh <jv@jvosburgh.net>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0489/1193] bonding: use skb_cow_head() in bond_do_alb_xmit() and rlb_arp_xmit()
Date: Wed, 30 Sep 2026 17:19:33 +0200
Message-ID: <20260930152445.016476177@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 1746ef2e2df2ad71c66eca56364d56bde284523b ]

In bond_do_alb_xmit() and rlb_arp_xmit(), make sure to unclone
skb head via skb_cow_head() before modifying the source MAC address
(Ethernet header and ARP payload) to avoid silent corruption if
the skb is shared or cloned. Avoid caching the header pointers
across skb_cow_head().

In rlb_arp_xmit(), only modify arp->mac_src if it differs from
tx_slave->dev->dev_addr to avoid an unnecessary copy and head
reallocation.

Also, we should not assume mac header is set in output path.

Use skb_eth_hdr() instead of eth_hdr() to fix the issue,
and remove now redundant skb_reset_mac_header() calls.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Hangbin Liu <liuhangbin@kylinos.cn>
Cc: Jay Vosburgh <jv@jvosburgh.net>
Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
Link: https://patch.msgid.link/20260903143940.1180513-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_alb.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/net/bonding/bond_alb.c b/drivers/net/bonding/bond_alb.c
index 5a7148c515c21..87a46276f87aa 100644
--- a/drivers/net/bonding/bond_alb.c
+++ b/drivers/net/bonding/bond_alb.c
@@ -678,9 +678,15 @@ static struct slave *rlb_arp_xmit(struct sk_buff *skb, struct bonding *bond)
 	if (arp->op_code == htons(ARPOP_REPLY)) {
 		/* the arp must be sent on the selected rx channel */
 		tx_slave = rlb_choose_channel(skb, bond, arp);
-		if (tx_slave)
+		if (tx_slave &&
+		    !ether_addr_equal_64bits(arp->mac_src,
+					     tx_slave->dev->dev_addr)) {
+			if (unlikely(skb_cow_head(skb, 0)))
+				return NULL;
+			arp = (struct arp_pkt *)skb_network_header(skb);
 			bond_hw_addr_copy(arp->mac_src, tx_slave->dev->dev_addr,
 					  tx_slave->dev->addr_len);
+		}
 		netdev_dbg(bond->dev, "(slave %s): Server sent ARP Reply packet\n",
 			   tx_slave ? tx_slave->dev->name : "NULL");
 	} else if (arp->op_code == htons(ARPOP_REQUEST)) {
@@ -1341,7 +1347,6 @@ static netdev_tx_t bond_do_alb_xmit(struct sk_buff *skb, struct bonding *bond,
 				    struct slave *tx_slave)
 {
 	struct alb_bond_info *bond_info = &(BOND_ALB_INFO(bond));
-	struct ethhdr *eth_data = eth_hdr(skb);
 
 	if (!tx_slave) {
 		/* unbalanced or unassigned, send through primary */
@@ -1352,7 +1357,9 @@ static netdev_tx_t bond_do_alb_xmit(struct sk_buff *skb, struct bonding *bond,
 
 	if (tx_slave && bond_slave_can_tx(tx_slave)) {
 		if (tx_slave != rcu_access_pointer(bond->curr_active_slave)) {
-			ether_addr_copy(eth_data->h_source,
+			if (unlikely(skb_cow_head(skb, 0)))
+				return bond_tx_drop(bond->dev, skb);
+			ether_addr_copy(skb_eth_hdr(skb)->h_source,
 					tx_slave->dev->dev_addr);
 		}
 
@@ -1376,8 +1383,7 @@ struct slave *bond_xmit_tlb_slave_get(struct bonding *bond,
 	struct ethhdr *eth_data;
 	u32 hash_index;
 
-	skb_reset_mac_header(skb);
-	eth_data = eth_hdr(skb);
+	eth_data = skb_eth_hdr(skb);
 
 	/* Do not TX balance any multicast or broadcast */
 	if (!is_multicast_ether_addr(eth_data->h_dest)) {
@@ -1429,8 +1435,7 @@ struct slave *bond_xmit_alb_slave_get(struct bonding *bond,
 	u32 hash_index = 0;
 	int hash_size = 0;
 
-	skb_reset_mac_header(skb);
-	eth_data = eth_hdr(skb);
+	eth_data = skb_eth_hdr(skb);
 
 	switch (ntohs(skb->protocol)) {
 	case ETH_P_IP: {
-- 
2.53.0



