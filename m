Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 050B837BE6F;
	Thu, 20 Aug 2026 17:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247766; cv=none; b=AZ3jGOAF0rErCkcjln2g2bnt5ePWeWqXky+3zTdlfl1rlHrHwUPhJ61wSbW/eWq1OmLodtPAnG56RRXBdOpG7V9z1VcPEDWWvEnaSJWWh/qo2738zDZYNofl2mIwf26eU7Vu/budNS2fGKTkK17EMyWaKIRywI0fiyajoA1ahNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247766; c=relaxed/simple;
	bh=MVCG0IpQRPrqD9LrxStK1UcANZsR8XezDVFMxxqc4VE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RiRzXhBeR+Q1mV0n1W0w9FxCm2RfQUo++Dt3Kv8YPOHJecHxYLubP4tw8Sl/K7n5ikN0aYv2Uvt2bCX2UhTf3/tD4KNZNnlyw7Pjck7VCCG9dhfEVsYQuJf7AAfErNSlvVz0utLWZXlwWxbTV21mS3IUl7RZBDwKXIhl28YSlwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SvL9WDW0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SvL9WDW0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60CA71F000E9;
	Thu, 20 Aug 2026 17:42:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247764;
	bh=3MvMGgP+2BCXvopz8dGorngeKq8l6z59sZcGpytx3po=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SvL9WDW0F1v1wG7zLB0WXH1LFtCXxMEg9x4iDQYRVDLJmUJcbCuFJhLRgy3GlZfuY
	 HLLZLo++z7A2uPaIBp/VODwoMyL0TUDbnMN2fGSdTSItL7xAhqZ5tAqSq9Z/i15BHs
	 Wnz3sHtznMyQnc7Uk/9CrXSwaMYxKJ59tGGyWp8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guillaume Nault <gnault@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 122/166] vxlan: Handle stats using NETDEV_PCPU_STAT_DSTATS.
Date: Thu, 20 Aug 2026 16:56:21 +0200
Message-ID: <20260820145214.834790297@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145211.194104353@linuxfoundation.org>
References: <20260820145211.194104353@linuxfoundation.org>
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

From: Guillaume Nault <gnault@redhat.com>

[ Upstream commit be226352e8dc77d3313c096b2d8e7f69bf6980fc ]

VXLAN uses the TSTATS infrastructure (dev_sw_netstats_*()) for RX and
TX packet counters. It also uses the device core stats
(dev_core_stats_*()) for RX and TX drops.

Let's consolidate that using the DSTATS infrastructure, which can
handle both packet counters and packet drops. Statistics that don't
fit DSTATS are still updated atomically with DEV_STATS_INC().

While there, convert the "len" variable of vxlan_encap_bypass() to
unsigned int, to respect the types of skb->len and
dev_dstats_[rt]x_add().

Signed-off-by: Guillaume Nault <gnault@redhat.com>
Link: https://patch.msgid.link/145558b184b3cda77911ca5682b6eb83c3ffed8e.1733313925.git.gnault@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: b9553558b48d ("vxlan: use pskb_network_may_pull() for transmit path header pulls")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/vxlan/vxlan_core.c |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -1798,13 +1798,13 @@ static int vxlan_rcv(struct sock *sk, st
 
 	if (unlikely(!(vxlan->dev->flags & IFF_UP))) {
 		rcu_read_unlock();
-		dev_core_stats_rx_dropped_inc(vxlan->dev);
+		dev_dstats_rx_dropped(vxlan->dev);
 		vxlan_vnifilter_count(vxlan, vni, vninode,
 				      VXLAN_VNI_STATS_RX_DROPS, 0);
 		goto drop;
 	}
 
-	dev_sw_netstats_rx_add(vxlan->dev, skb->len);
+	dev_dstats_rx_add(vxlan->dev, skb->len);
 	vxlan_vnifilter_count(vxlan, vni, vninode, VXLAN_VNI_STATS_RX, skb->len);
 	gro_cells_receive(&vxlan->gro_cells, skb);
 
@@ -1858,7 +1858,7 @@ static int arp_reduce(struct net_device
 		goto out;
 
 	if (!pskb_may_pull(skb, arp_hdr_len(dev))) {
-		dev_core_stats_tx_dropped_inc(dev);
+		dev_dstats_tx_dropped(dev);
 		vxlan_vnifilter_count(vxlan, vni, NULL,
 				      VXLAN_VNI_STATS_TX_DROPS, 0);
 		goto out;
@@ -1916,7 +1916,7 @@ static int arp_reduce(struct net_device
 		reply->pkt_type = PACKET_HOST;
 
 		if (netif_rx(reply) == NET_RX_DROP) {
-			dev_core_stats_rx_dropped_inc(dev);
+			dev_dstats_rx_dropped(dev);
 			vxlan_vnifilter_count(vxlan, vni, NULL,
 					      VXLAN_VNI_STATS_RX_DROPS, 0);
 		}
@@ -2077,7 +2077,7 @@ static int neigh_reduce(struct net_devic
 			goto out;
 
 		if (netif_rx(reply) == NET_RX_DROP) {
-			dev_core_stats_rx_dropped_inc(dev);
+			dev_dstats_rx_dropped(dev);
 			vxlan_vnifilter_count(vxlan, vni, NULL,
 					      VXLAN_VNI_STATS_RX_DROPS, 0);
 		}
@@ -2370,8 +2370,8 @@ static void vxlan_encap_bypass(struct sk
 {
 	union vxlan_addr loopback;
 	union vxlan_addr *remote_ip = &dst_vxlan->default_dst.remote_ip;
+	unsigned int len = skb->len;
 	struct net_device *dev;
-	int len = skb->len;
 
 	skb->pkt_type = PACKET_HOST;
 	skb->encapsulation = 0;
@@ -2398,16 +2398,16 @@ static void vxlan_encap_bypass(struct sk
 	if ((dst_vxlan->cfg.flags & VXLAN_F_LEARN) && snoop)
 		vxlan_snoop(dev, &loopback, eth_hdr(skb)->h_source, 0, vni);
 
-	dev_sw_netstats_tx_add(src_vxlan->dev, 1, len);
+	dev_dstats_tx_add(src_vxlan->dev, len);
 	vxlan_vnifilter_count(src_vxlan, vni, NULL, VXLAN_VNI_STATS_TX, len);
 
 	if (__netif_rx(skb) == NET_RX_SUCCESS) {
-		dev_sw_netstats_rx_add(dst_vxlan->dev, len);
+		dev_dstats_rx_add(dst_vxlan->dev, len);
 		vxlan_vnifilter_count(dst_vxlan, vni, NULL, VXLAN_VNI_STATS_RX,
 				      len);
 	} else {
 drop:
-		dev_core_stats_rx_dropped_inc(dev);
+		dev_dstats_rx_dropped(dev);
 		vxlan_vnifilter_count(dst_vxlan, vni, NULL,
 				      VXLAN_VNI_STATS_RX_DROPS, 0);
 	}
@@ -2700,7 +2700,7 @@ out_unlock:
 	return;
 
 drop:
-	dev_core_stats_tx_dropped_inc(dev);
+	dev_dstats_tx_dropped(dev);
 	vxlan_vnifilter_count(vxlan, vni, NULL, VXLAN_VNI_STATS_TX_DROPS, 0);
 	dev_kfree_skb(skb);
 	return;
@@ -2745,7 +2745,7 @@ static void vxlan_xmit_nh(struct sk_buff
 	return;
 
 drop:
-	dev_core_stats_tx_dropped_inc(dev);
+	dev_dstats_tx_dropped(dev);
 	vxlan_vnifilter_count(netdev_priv(dev), vni, NULL,
 			      VXLAN_VNI_STATS_TX_DROPS, 0);
 	dev_kfree_skb(skb);
@@ -2783,7 +2783,7 @@ static netdev_tx_t vxlan_xmit_nhid(struc
 	return NETDEV_TX_OK;
 
 drop:
-	dev_core_stats_tx_dropped_inc(dev);
+	dev_dstats_tx_dropped(dev);
 	vxlan_vnifilter_count(netdev_priv(dev), vni, NULL,
 			      VXLAN_VNI_STATS_TX_DROPS, 0);
 	dev_kfree_skb(skb);
@@ -2881,7 +2881,7 @@ static netdev_tx_t vxlan_xmit(struct sk_
 			    !is_multicast_ether_addr(eth->h_dest))
 				vxlan_fdb_miss(vxlan, eth->h_dest);
 
-			dev_core_stats_tx_dropped_inc(dev);
+			dev_dstats_tx_dropped(dev);
 			vxlan_vnifilter_count(vxlan, vni, NULL,
 					      VXLAN_VNI_STATS_TX_DROPS, 0);
 			kfree_skb(skb);
@@ -3259,7 +3259,7 @@ static void vxlan_setup(struct net_devic
 	dev->min_mtu = ETH_MIN_MTU;
 	dev->max_mtu = ETH_MAX_MTU;
 
-	dev->pcpu_stat_type = NETDEV_PCPU_STAT_TSTATS;
+	dev->pcpu_stat_type = NETDEV_PCPU_STAT_DSTATS;
 	INIT_LIST_HEAD(&vxlan->next);
 
 	timer_setup(&vxlan->age_timer, vxlan_cleanup, TIMER_DEFERRABLE);


