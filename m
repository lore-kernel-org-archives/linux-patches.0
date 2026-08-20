Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E2C8481AAD;
	Thu, 20 Aug 2026 17:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247760; cv=none; b=JPUmV62V0XzAKWVs09qX0zF98DnmX0jlDKrOxaxwg7hArlMrQK0gmLJN4EgncMvpdeGdoebpIlj7C4kIu3Ln20tYTWv+GSFBjCiwF8KiRdNUZgSY6FfzKs9WMMx16d0Uh3aMxdhTJ4uhlSSRzduYUg7DAr9rzrsjM2f526rV00A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247760; c=relaxed/simple;
	bh=kgOv7bC0DfYlSpmpoinfEGyMuyyod6HBQzlhE2Ewy+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MUMtcx4/TzRtCWCqDsJtZQX+7oYptFBUJLVhy2VojeRcxvSV2xVU4riEWf2jqABEju/72Nx781yePBrp7pCHB2N2QRURWq/iN2/EJwDOSziVt/YJZyKy8zbCmvrvdkNJ3/CjJ4HQsYNdSNAJpD9nP7sdAII95wY5JcaTf+2Aodc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bB6NDbjQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bB6NDbjQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B91FF1F000E9;
	Thu, 20 Aug 2026 17:42:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247759;
	bh=agxbS5Q01O6B0mi/rcO0+VAgXSPI5sKmvBcV9x3xRFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bB6NDbjQ8x/GzI08ogvbFkGkZFTMOsSW1TxX66HZ9u5kPaIkwkL85O0oEJRSGt9kt
	 2nHBq7j8wNZX7woW/yxW3m4IiAVK36rgQM7lAIz9MEKLjPnjL4JHR4eqpdYlNqKWkW
	 NNkY+lQviEDA6EeZXj8jSPoND6ygDyebM2nQ5hkM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeremy Kerr <jk@codeconstruct.com.au>,
	Simon Horman <horms@kernel.org>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 120/166] net: core,vrf: Change pcpu_dstat fields to u64_stats_t
Date: Thu, 20 Aug 2026 16:56:19 +0200
Message-ID: <20260820145214.775687460@linuxfoundation.org>
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

From: Jeremy Kerr <jk@codeconstruct.com.au>

[ Upstream commit fa59dc2f6fc616fde3941f62ccd4adcaa21ccd47 ]

The pcpu_sw_netstats and pcpu_lstats structs both contain a set of
u64_stats_t fields for individual stats, but pcpu_dstats uses u64s
instead.

Make this consistent by using u64_stats_t across all stats types.

The per-cpu dstats are only used by the vrf driver at present, so update
that driver as part of this change.

Signed-off-by: Jeremy Kerr <jk@codeconstruct.com.au>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://lore.kernel.org/r/20240607-dstats-v3-1-cc781fe116f7@codeconstruct.com.au
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: b9553558b48d ("vxlan: use pskb_network_may_pull() for transmit path header pulls")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/vrf.c         |   38 ++++++++++++++++++++++----------------
 include/linux/netdevice.h |   12 ++++++------
 2 files changed, 28 insertions(+), 22 deletions(-)

--- a/drivers/net/vrf.c
+++ b/drivers/net/vrf.c
@@ -126,8 +126,8 @@ static void vrf_rx_stats(struct net_devi
 	struct pcpu_dstats *dstats = this_cpu_ptr(dev->dstats);
 
 	u64_stats_update_begin(&dstats->syncp);
-	dstats->rx_packets++;
-	dstats->rx_bytes += len;
+	u64_stats_inc(&dstats->rx_packets);
+	u64_stats_add(&dstats->rx_bytes, len);
 	u64_stats_update_end(&dstats->syncp);
 }
 
@@ -150,11 +150,11 @@ static void vrf_get_stats64(struct net_d
 		dstats = per_cpu_ptr(dev->dstats, i);
 		do {
 			start = u64_stats_fetch_begin(&dstats->syncp);
-			tbytes = dstats->tx_bytes;
-			tpkts = dstats->tx_packets;
-			tdrops = dstats->tx_drops;
-			rbytes = dstats->rx_bytes;
-			rpkts = dstats->rx_packets;
+			tbytes = u64_stats_read(&dstats->tx_bytes);
+			tpkts = u64_stats_read(&dstats->tx_packets);
+			tdrops = u64_stats_read(&dstats->tx_drops);
+			rbytes = u64_stats_read(&dstats->rx_bytes);
+			rpkts = u64_stats_read(&dstats->rx_packets);
 		} while (u64_stats_fetch_retry(&dstats->syncp, start));
 		stats->tx_bytes += tbytes;
 		stats->tx_packets += tpkts;
@@ -408,10 +408,15 @@ static int vrf_local_xmit(struct sk_buff
 
 	skb->protocol = eth_type_trans(skb, dev);
 
-	if (likely(__netif_rx(skb) == NET_RX_SUCCESS))
+	if (likely(__netif_rx(skb) == NET_RX_SUCCESS)) {
 		vrf_rx_stats(dev, len);
-	else
-		this_cpu_inc(dev->dstats->rx_drops);
+	} else {
+		struct pcpu_dstats *dstats = this_cpu_ptr(dev->dstats);
+
+		u64_stats_update_begin(&dstats->syncp);
+		u64_stats_inc(&dstats->rx_drops);
+		u64_stats_update_end(&dstats->syncp);
+	}
 
 	return NETDEV_TX_OK;
 }
@@ -599,19 +604,20 @@ static netdev_tx_t is_ip_tx_frame(struct
 
 static netdev_tx_t vrf_xmit(struct sk_buff *skb, struct net_device *dev)
 {
+	struct pcpu_dstats *dstats = this_cpu_ptr(dev->dstats);
+
 	int len = skb->len;
 	netdev_tx_t ret = is_ip_tx_frame(skb, dev);
 
+	u64_stats_update_begin(&dstats->syncp);
 	if (likely(ret == NET_XMIT_SUCCESS || ret == NET_XMIT_CN)) {
-		struct pcpu_dstats *dstats = this_cpu_ptr(dev->dstats);
 
-		u64_stats_update_begin(&dstats->syncp);
-		dstats->tx_packets++;
-		dstats->tx_bytes += len;
-		u64_stats_update_end(&dstats->syncp);
+		u64_stats_inc(&dstats->tx_packets);
+		u64_stats_add(&dstats->tx_bytes, len);
 	} else {
-		this_cpu_inc(dev->dstats->tx_drops);
+		u64_stats_inc(&dstats->tx_drops);
 	}
+	u64_stats_update_end(&dstats->syncp);
 
 	return ret;
 }
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2748,12 +2748,12 @@ struct pcpu_sw_netstats {
 } __aligned(4 * sizeof(u64));
 
 struct pcpu_dstats {
-	u64			rx_packets;
-	u64			rx_bytes;
-	u64			rx_drops;
-	u64			tx_packets;
-	u64			tx_bytes;
-	u64			tx_drops;
+	u64_stats_t		rx_packets;
+	u64_stats_t		rx_bytes;
+	u64_stats_t		rx_drops;
+	u64_stats_t		tx_packets;
+	u64_stats_t		tx_bytes;
+	u64_stats_t		tx_drops;
 	struct u64_stats_sync	syncp;
 } __aligned(8 * sizeof(u64));
 


