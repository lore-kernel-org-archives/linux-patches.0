Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EE4F3CF688;
	Wed, 30 Sep 2026 18:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791444; cv=none; b=pS0OcEI1DKufBwB4q7c56XWWkz6KjJg2AtcAXxRqFaFL1zdCRsj1YPCZz5eNdz5O5l+OwjRt8mPmAlTLhcu+ZscfWBO8WzKFsi81BxyNF+eDsTaKU3uGmljm4wCa6l28tUK8rMRf6dTlGN5AoI25TtJ7trYmpKZJgeIuib7AOS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791444; c=relaxed/simple;
	bh=GeZ4wkSb9CVOyjnm+7s9EEjI7YC4yimTIcaNGvi+Olo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NjEBSPY8WuYXAeafFAIsnCM6M/F6Y6tPAk6wxJHsS0tl8RZqHwxUHqo9KNb8Fg63/pq4q1caBtRIvXwf2TiAt/kiEpU+VWOm1w4R7/ZgbO1yiuJoKdimwko/rnlhIQg/rGHoosKcTeOMyPeIifsZI1AEHdIaDRMRxpPZENTIYyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jp1+dplo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jp1+dplo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E9141F000FF;
	Wed, 30 Sep 2026 18:04:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791443;
	bh=Fp6UsOUk14wvCNkPy6RT24a5i0Kp8VqhfIB5gdY12mw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jp1+dploH3N9BtQn/SYbnRD0VxRVXih0v2Q0cYub6ZY/jB9G1y74b/pE9vS3Tro84
	 IR2BGW5mDeFjCTcsjfkrF1rO76O4U4aisf7/tHs2x9LN8bVGGz0rrVckJs1Egaqq+u
	 E4qnhC3T+aJ4sWPsTYhnyrC0dJ8c6hVMXNggAPzY=
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
Subject: [PATCH 5.15 303/752] bonding: use skb_cow_head() in bond_do_alb_xmit() and rlb_arp_xmit()
Date: Wed, 30 Sep 2026 17:22:53 +0200
Message-ID: <20260930152404.847475094@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 4be2afd98ce1d..930313b9d4597 100644
--- a/drivers/net/bonding/bond_alb.c
+++ b/drivers/net/bonding/bond_alb.c
@@ -666,9 +666,15 @@ static struct slave *rlb_arp_xmit(struct sk_buff *skb, struct bonding *bond)
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
@@ -1309,7 +1315,6 @@ static netdev_tx_t bond_do_alb_xmit(struct sk_buff *skb, struct bonding *bond,
 				    struct slave *tx_slave)
 {
 	struct alb_bond_info *bond_info = &(BOND_ALB_INFO(bond));
-	struct ethhdr *eth_data = eth_hdr(skb);
 
 	if (!tx_slave) {
 		/* unbalanced or unassigned, send through primary */
@@ -1320,7 +1325,9 @@ static netdev_tx_t bond_do_alb_xmit(struct sk_buff *skb, struct bonding *bond,
 
 	if (tx_slave && bond_slave_can_tx(tx_slave)) {
 		if (tx_slave != rcu_access_pointer(bond->curr_active_slave)) {
-			ether_addr_copy(eth_data->h_source,
+			if (unlikely(skb_cow_head(skb, 0)))
+				return bond_tx_drop(bond->dev, skb);
+			ether_addr_copy(skb_eth_hdr(skb)->h_source,
 					tx_slave->dev->dev_addr);
 		}
 
@@ -1344,8 +1351,7 @@ struct slave *bond_xmit_tlb_slave_get(struct bonding *bond,
 	struct ethhdr *eth_data;
 	u32 hash_index;
 
-	skb_reset_mac_header(skb);
-	eth_data = eth_hdr(skb);
+	eth_data = skb_eth_hdr(skb);
 
 	/* Do not TX balance any multicast or broadcast */
 	if (!is_multicast_ether_addr(eth_data->h_dest)) {
@@ -1394,8 +1400,7 @@ struct slave *bond_xmit_alb_slave_get(struct bonding *bond,
 	u32 hash_index = 0;
 	int hash_size = 0;
 
-	skb_reset_mac_header(skb);
-	eth_data = eth_hdr(skb);
+	eth_data = skb_eth_hdr(skb);
 
 	switch (ntohs(skb->protocol)) {
 	case ETH_P_IP: {
-- 
2.53.0



