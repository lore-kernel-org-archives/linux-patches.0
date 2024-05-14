Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7230823767;
	Tue, 14 May 2024 10:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715682440; cv=none; b=NB6Kw/hLcdIhvdwxORqRFah9BjRRQGSSy0cO3o9gTQ7yQ+UFyGWiDzIkG31fB0wKAiV1PpEMO6UJGx9qjRv3KJcjwF4V2MFx9bkCYMSH12pbRP9mFBwu2CVEcTS+1BWBLQiyUjexM4e8u47D+buzJL959USvyiQlCmyLutTYawE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715682440; c=relaxed/simple;
	bh=VC5nncADzLiN5KH4ZYVQO34kee1DnKIT0nZicP+oK2I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X5Jy11b22K3v/fO3JgEoofEuRCcMMuqbZzSSIh9s+gnMkdjnhIYIN7n2X2jTeoZJtT4Os3BpNWRrsRLA64IxYyrW+yT8yWcq8l5ectEiQMCA/pi0mKX9iKcNuqyXfcsSJJoBJzY9M2B0fDfUggcdsol0n+T5Gagh7HQlbuPIeuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZhKTm96v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZhKTm96v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3397C2BD10;
	Tue, 14 May 2024 10:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715682440;
	bh=VC5nncADzLiN5KH4ZYVQO34kee1DnKIT0nZicP+oK2I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZhKTm96vlwsogL2M7+895ACeu94sae0cokBVlvRx0CGbgV+cQqKscJo1s8YDaqS3S
	 HtTlhlxIQ0cjRqGv+Py5iMWh/bGfzBe4rklqlXDz5GT7LpsXz+/cVO8ufQkBHovYeI
	 xCgtoecE/uj5Q13242vmy4qICPxP5fLCvvxOzCv4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guillaume Nault <gnault@redhat.com>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 061/336] vxlan: Fix racy device stats updates.
Date: Tue, 14 May 2024 12:14:25 +0200
Message-ID: <20240514101040.910228741@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guillaume Nault <gnault@redhat.com>

[ Upstream commit 6dee402daba4eb8677a9438ebdcd8fe90ddd4326 ]

VXLAN devices update their stats locklessly. Therefore these counters
should either be stored in per-cpu data structures or the updates
should be done using atomic increments.

Since the net_device_core_stats infrastructure is already used in
vxlan_rcv(), use it for the other rx_dropped and tx_dropped counter
updates. Update the other counters atomically using DEV_STATS_INC().

Fixes: d342894c5d2f ("vxlan: virtual extensible lan")
Signed-off-by: Guillaume Nault <gnault@redhat.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vxlan/vxlan_core.c | 28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index 9ec46048d361d..afca4f42c31b4 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -1766,8 +1766,8 @@ static int vxlan_rcv(struct sock *sk, struct sk_buff *skb)
 	skb_reset_network_header(skb);
 
 	if (!vxlan_ecn_decapsulate(vs, oiph, skb)) {
-		++vxlan->dev->stats.rx_frame_errors;
-		++vxlan->dev->stats.rx_errors;
+		DEV_STATS_INC(vxlan->dev, rx_frame_errors);
+		DEV_STATS_INC(vxlan->dev, rx_errors);
 		vxlan_vnifilter_count(vxlan, vni, vninode,
 				      VXLAN_VNI_STATS_RX_ERRORS, 0);
 		goto drop;
@@ -1837,7 +1837,7 @@ static int arp_reduce(struct net_device *dev, struct sk_buff *skb, __be32 vni)
 		goto out;
 
 	if (!pskb_may_pull(skb, arp_hdr_len(dev))) {
-		dev->stats.tx_dropped++;
+		dev_core_stats_tx_dropped_inc(dev);
 		goto out;
 	}
 	parp = arp_hdr(skb);
@@ -1893,7 +1893,7 @@ static int arp_reduce(struct net_device *dev, struct sk_buff *skb, __be32 vni)
 		reply->pkt_type = PACKET_HOST;
 
 		if (netif_rx(reply) == NET_RX_DROP) {
-			dev->stats.rx_dropped++;
+			dev_core_stats_rx_dropped_inc(dev);
 			vxlan_vnifilter_count(vxlan, vni, NULL,
 					      VXLAN_VNI_STATS_RX_DROPS, 0);
 		}
@@ -2052,7 +2052,7 @@ static int neigh_reduce(struct net_device *dev, struct sk_buff *skb, __be32 vni)
 			goto out;
 
 		if (netif_rx(reply) == NET_RX_DROP) {
-			dev->stats.rx_dropped++;
+			dev_core_stats_rx_dropped_inc(dev);
 			vxlan_vnifilter_count(vxlan, vni, NULL,
 					      VXLAN_VNI_STATS_RX_DROPS, 0);
 		}
@@ -2263,7 +2263,7 @@ static void vxlan_encap_bypass(struct sk_buff *skb, struct vxlan_dev *src_vxlan,
 				      len);
 	} else {
 drop:
-		dev->stats.rx_dropped++;
+		dev_core_stats_rx_dropped_inc(dev);
 		vxlan_vnifilter_count(dst_vxlan, vni, NULL,
 				      VXLAN_VNI_STATS_RX_DROPS, 0);
 	}
@@ -2295,7 +2295,7 @@ static int encap_bypass_if_local(struct sk_buff *skb, struct net_device *dev,
 					   addr_family, dst_port,
 					   vxlan->cfg.flags);
 		if (!dst_vxlan) {
-			dev->stats.tx_errors++;
+			DEV_STATS_INC(dev, tx_errors);
 			vxlan_vnifilter_count(vxlan, vni, NULL,
 					      VXLAN_VNI_STATS_TX_ERRORS, 0);
 			kfree_skb(skb);
@@ -2559,7 +2559,7 @@ void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
 	return;
 
 drop:
-	dev->stats.tx_dropped++;
+	dev_core_stats_tx_dropped_inc(dev);
 	vxlan_vnifilter_count(vxlan, vni, NULL, VXLAN_VNI_STATS_TX_DROPS, 0);
 	dev_kfree_skb(skb);
 	return;
@@ -2567,11 +2567,11 @@ void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
 tx_error:
 	rcu_read_unlock();
 	if (err == -ELOOP)
-		dev->stats.collisions++;
+		DEV_STATS_INC(dev, collisions);
 	else if (err == -ENETUNREACH)
-		dev->stats.tx_carrier_errors++;
+		DEV_STATS_INC(dev, tx_carrier_errors);
 	dst_release(ndst);
-	dev->stats.tx_errors++;
+	DEV_STATS_INC(dev, tx_errors);
 	vxlan_vnifilter_count(vxlan, vni, NULL, VXLAN_VNI_STATS_TX_ERRORS, 0);
 	kfree_skb(skb);
 }
@@ -2604,7 +2604,7 @@ static void vxlan_xmit_nh(struct sk_buff *skb, struct net_device *dev,
 	return;
 
 drop:
-	dev->stats.tx_dropped++;
+	dev_core_stats_tx_dropped_inc(dev);
 	vxlan_vnifilter_count(netdev_priv(dev), vni, NULL,
 			      VXLAN_VNI_STATS_TX_DROPS, 0);
 	dev_kfree_skb(skb);
@@ -2642,7 +2642,7 @@ static netdev_tx_t vxlan_xmit_nhid(struct sk_buff *skb, struct net_device *dev,
 	return NETDEV_TX_OK;
 
 drop:
-	dev->stats.tx_dropped++;
+	dev_core_stats_tx_dropped_inc(dev);
 	vxlan_vnifilter_count(netdev_priv(dev), vni, NULL,
 			      VXLAN_VNI_STATS_TX_DROPS, 0);
 	dev_kfree_skb(skb);
@@ -2739,7 +2739,7 @@ static netdev_tx_t vxlan_xmit(struct sk_buff *skb, struct net_device *dev)
 			    !is_multicast_ether_addr(eth->h_dest))
 				vxlan_fdb_miss(vxlan, eth->h_dest);
 
-			dev->stats.tx_dropped++;
+			dev_core_stats_tx_dropped_inc(dev);
 			vxlan_vnifilter_count(vxlan, vni, NULL,
 					      VXLAN_VNI_STATS_TX_DROPS, 0);
 			kfree_skb(skb);
-- 
2.43.0



