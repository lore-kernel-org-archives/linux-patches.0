Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66F58482CB;
	Thu, 30 Nov 2023 16:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aZo0HJF3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7D6EC433C8;
	Thu, 30 Nov 2023 16:25:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701361513;
	bh=dfHvZ0EEXuY5pBzPXbMreVzoqNleoofJ+v2kx7ERsSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aZo0HJF3wKvWSxhqfb4zV+IWXAS+iTzUQCQd6cuAUkLF+67YFyEDiq2K0dFHvy8SK
	 xV1dtHN7IPlMlkJ6eeF5hxT8qkg3rTUuF3b13TJ28OKb05XWg2a5KA3nlhtDVScunB
	 ljIoRVv40YoENGNAFO7OnpRKew2zt1vgBMW8ADQk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>,
	David Ahern <dsahern@kernel.org>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 028/112] net, vrf: Move dstats structure to core
Date: Thu, 30 Nov 2023 16:21:15 +0000
Message-ID: <20231130162141.213554838@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231130162140.298098091@linuxfoundation.org>
References: <20231130162140.298098091@linuxfoundation.org>
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

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit 79e0c5be8c73a674c92bd4ba77b75f4f8c91d32e ]

Just move struct pcpu_dstats out of the vrf into the core, and streamline
the field names slightly, so they better align with the {t,l}stats ones.

No functional change otherwise. A conversion of the u64s to u64_stats_t
could be done at a separate point in future. This move is needed as we are
moving the {t,l,d}stats allocation/freeing to the core.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: David Ahern <dsahern@kernel.org>
Link: https://lore.kernel.org/r/20231114004220.6495-2-daniel@iogearbox.net
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Stable-dep-of: 024ee930cb3c ("bpf: Fix dev's rx stats for bpf_redirect_peer traffic")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/vrf.c         | 24 +++++++-----------------
 include/linux/netdevice.h | 10 ++++++++++
 2 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/net/vrf.c b/drivers/net/vrf.c
index a3408e4e1491b..3654c8b344024 100644
--- a/drivers/net/vrf.c
+++ b/drivers/net/vrf.c
@@ -121,22 +121,12 @@ struct net_vrf {
 	int			ifindex;
 };
 
-struct pcpu_dstats {
-	u64			tx_pkts;
-	u64			tx_bytes;
-	u64			tx_drps;
-	u64			rx_pkts;
-	u64			rx_bytes;
-	u64			rx_drps;
-	struct u64_stats_sync	syncp;
-};
-
 static void vrf_rx_stats(struct net_device *dev, int len)
 {
 	struct pcpu_dstats *dstats = this_cpu_ptr(dev->dstats);
 
 	u64_stats_update_begin(&dstats->syncp);
-	dstats->rx_pkts++;
+	dstats->rx_packets++;
 	dstats->rx_bytes += len;
 	u64_stats_update_end(&dstats->syncp);
 }
@@ -161,10 +151,10 @@ static void vrf_get_stats64(struct net_device *dev,
 		do {
 			start = u64_stats_fetch_begin(&dstats->syncp);
 			tbytes = dstats->tx_bytes;
-			tpkts = dstats->tx_pkts;
-			tdrops = dstats->tx_drps;
+			tpkts = dstats->tx_packets;
+			tdrops = dstats->tx_drops;
 			rbytes = dstats->rx_bytes;
-			rpkts = dstats->rx_pkts;
+			rpkts = dstats->rx_packets;
 		} while (u64_stats_fetch_retry(&dstats->syncp, start));
 		stats->tx_bytes += tbytes;
 		stats->tx_packets += tpkts;
@@ -421,7 +411,7 @@ static int vrf_local_xmit(struct sk_buff *skb, struct net_device *dev,
 	if (likely(__netif_rx(skb) == NET_RX_SUCCESS))
 		vrf_rx_stats(dev, len);
 	else
-		this_cpu_inc(dev->dstats->rx_drps);
+		this_cpu_inc(dev->dstats->rx_drops);
 
 	return NETDEV_TX_OK;
 }
@@ -616,11 +606,11 @@ static netdev_tx_t vrf_xmit(struct sk_buff *skb, struct net_device *dev)
 		struct pcpu_dstats *dstats = this_cpu_ptr(dev->dstats);
 
 		u64_stats_update_begin(&dstats->syncp);
-		dstats->tx_pkts++;
+		dstats->tx_packets++;
 		dstats->tx_bytes += len;
 		u64_stats_update_end(&dstats->syncp);
 	} else {
-		this_cpu_inc(dev->dstats->tx_drps);
+		this_cpu_inc(dev->dstats->tx_drops);
 	}
 
 	return ret;
diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index b646609f09c05..b76dc6fa4e772 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2725,6 +2725,16 @@ struct pcpu_sw_netstats {
 	struct u64_stats_sync   syncp;
 } __aligned(4 * sizeof(u64));
 
+struct pcpu_dstats {
+	u64			rx_packets;
+	u64			rx_bytes;
+	u64			rx_drops;
+	u64			tx_packets;
+	u64			tx_bytes;
+	u64			tx_drops;
+	struct u64_stats_sync	syncp;
+} __aligned(8 * sizeof(u64));
+
 struct pcpu_lstats {
 	u64_stats_t packets;
 	u64_stats_t bytes;
-- 
2.42.0



