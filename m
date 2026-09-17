Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 454074B44CC;
	Thu, 17 Sep 2026 15:38:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659493; cv=none; b=WW/hc3HoSh0w2sun8Bigh8Y2+vjO008oHkaRj7vjyxykbAxTNfv9StItZWtuv/jZ4G3kgvZz5KEGJ/+Qg60RqHFB2dmUx9kDuLrB5ZzyPaAHZ5W7UTrgeJt1r1rVlPnBckGbzteRWU3O0fmzdy7TBrsTWzI3YDxnGPpMFbrNgSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659493; c=relaxed/simple;
	bh=U591tsCwOio8HFGEHszi7g2CVRO0aQwiWSy1aywOK8k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ttl53eIpQLmsCZBH9lXN/f5JeLb3t/hshXtdLq+qYNEvaytphQ52J8+ZH7xVfbDroOKcas2TE0HJ4+Y/CyJLTOCBfiZ1gp4zLtFzu5YmJPlA64osYXZN1G77Bx20IukSV3wc569c90mNX6XhwYQ0duAOqVU9f1mWzmqELQOlmJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MpQSKcul; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MpQSKcul"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBFA41F00898;
	Thu, 17 Sep 2026 15:38:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659487;
	bh=XlJIlo/jlK91tBe2exG2p8Uu73ks/OIwVYpzcFx6lq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MpQSKculSmLF2h3eHmWQTiM2jUTSDprBoWM7ll+bAJEGX4AdiK6ssP7N5ux9blEeQ
	 UU24WiKw6tY5yU8RjYoI9dZrySq5MQkbdfmDLVc+MAv2xg6NYWf0NojaCHq0qVLmvb
	 5u6uXAhTj/OrRNLWuKHeBU0nCaYCDfhBE1VQIJo4=
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
Subject: [PATCH 7.2 273/733] bonding: use skb_cow_head() in bond_do_alb_xmit() and rlb_arp_xmit()
Date: Thu, 17 Sep 2026 16:09:41 +0100
Message-ID: <20260917151358.154389287@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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
index 654f051d00239..43ac8e28e4182 100644
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
@@ -1340,7 +1346,6 @@ static netdev_tx_t bond_do_alb_xmit(struct sk_buff *skb, struct bonding *bond,
 				    struct slave *tx_slave)
 {
 	struct alb_bond_info *bond_info = &(BOND_ALB_INFO(bond));
-	struct ethhdr *eth_data = eth_hdr(skb);
 
 	if (!tx_slave) {
 		/* unbalanced or unassigned, send through primary */
@@ -1351,7 +1356,9 @@ static netdev_tx_t bond_do_alb_xmit(struct sk_buff *skb, struct bonding *bond,
 
 	if (tx_slave && bond_slave_can_tx(tx_slave)) {
 		if (tx_slave != rcu_access_pointer(bond->curr_active_slave)) {
-			ether_addr_copy(eth_data->h_source,
+			if (unlikely(skb_cow_head(skb, 0)))
+				return bond_tx_drop(bond->dev, skb);
+			ether_addr_copy(skb_eth_hdr(skb)->h_source,
 					tx_slave->dev->dev_addr);
 		}
 
@@ -1375,8 +1382,7 @@ struct slave *bond_xmit_tlb_slave_get(struct bonding *bond,
 	struct ethhdr *eth_data;
 	u32 hash_index;
 
-	skb_reset_mac_header(skb);
-	eth_data = eth_hdr(skb);
+	eth_data = skb_eth_hdr(skb);
 
 	/* Do not TX balance any multicast or broadcast */
 	if (!is_multicast_ether_addr(eth_data->h_dest)) {
@@ -1428,8 +1434,7 @@ struct slave *bond_xmit_alb_slave_get(struct bonding *bond,
 	u32 hash_index = 0;
 	int hash_size = 0;
 
-	skb_reset_mac_header(skb);
-	eth_data = eth_hdr(skb);
+	eth_data = skb_eth_hdr(skb);
 
 	switch (ntohs(skb->protocol)) {
 	case ETH_P_IP: {
-- 
2.53.0



