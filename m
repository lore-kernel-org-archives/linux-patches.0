Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFA5728C2BF;
	Thu, 20 Aug 2026 17:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247133; cv=none; b=hYCYQXqEFWegDWl8vt95yNJx0nNjOOzQ+l3kv0Jw8Sli3mDaY47z6y8BQLgL0rMqFTAJrO8zmJodr+sprEl3r7x6z4cF/MR2R3G4SB4Ri0e+DcRQCtX3Ug5+JV5Q2A65rogbp6L2WbfJdrGcBKRthe0ml0119klk9wpydnFVNps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247133; c=relaxed/simple;
	bh=2jqdqhccRC1zf3/0zEDbSEioUITlZOQq+s0SLvnLCp4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pvdESqS9KGjeXsk4B4OI7MCZUV7C3qFNCF3MuHStE91LFVmS3GbA5YziI9xmQTXRvp7kwY39yLuR5mqw43/LWqYECx39A1AZMh97+TgSnN2GkdQdJu08X/74gqYlhfdIWTBxZb+IN5zFY9JXX96jtlXq7uMfQnBpJitrY5NymSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M0/D5B8Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M0/D5B8Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27F161F000E9;
	Thu, 20 Aug 2026 17:32:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247131;
	bh=eVLsL/td6m2q8NHvzIYx32aKuqnA8u3bTCZ36OjUl3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M0/D5B8YO42/Uqw33Iy0ryjQGimiM+sDrqvdBJaD5bo//LpMzefVqJkFkbNBQDPhj
	 j1+HyJRXafUw18BMu5SNp+LN8FQSoOqBqyxDk/hZOxfvjEqd6kefsw4H0FUuHWJYgq
	 Fpk6OxAisTAqedfhT2lq/RZVwZGCXCO+ou6J2eXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guillaume Nault <gnault@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 160/220] vrf: Make pcpu_dstats update functions available to other modules.
Date: Thu, 20 Aug 2026 16:55:50 +0200
Message-ID: <20260820145228.284552548@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
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

From: Guillaume Nault <gnault@redhat.com>

[ Upstream commit 18eabadd73ae60023ab05e376246bd725fb0c113 ]

Currently vrf is the only module that uses NETDEV_PCPU_STAT_DSTATS.
In order to make this kind of statistics available to other modules,
we need to define the update functions in netdevice.h.

Therefore, let's define dev_dstats_*() functions for RX and TX packet
updates (packets, bytes and drops). Use these new functions in vrf.c
instead of vrf_rx_stats() and the other manual counter updates.

While there, update the type of the "len" variables to "unsigned int",
so that there're aligned with both skb->len and the new dstats update
functions.

Signed-off-by: Guillaume Nault <gnault@redhat.com>
Link: https://patch.msgid.link/d7a552ee382c79f4854e7fcc224cf176cd21150d.1733313925.git.gnault@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: b9553558b48d ("vxlan: use pskb_network_may_pull() for transmit path header pulls")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/vrf.c         |   49 +++++++++++++---------------------------------
 include/linux/netdevice.h |   40 +++++++++++++++++++++++++++++++++++++
 2 files changed, 54 insertions(+), 35 deletions(-)

--- a/drivers/net/vrf.c
+++ b/drivers/net/vrf.c
@@ -122,16 +122,6 @@ struct net_vrf {
 	int			ifindex;
 };
 
-static void vrf_rx_stats(struct net_device *dev, int len)
-{
-	struct pcpu_dstats *dstats = this_cpu_ptr(dev->dstats);
-
-	u64_stats_update_begin(&dstats->syncp);
-	u64_stats_inc(&dstats->rx_packets);
-	u64_stats_add(&dstats->rx_bytes, len);
-	u64_stats_update_end(&dstats->syncp);
-}
-
 static void vrf_tx_error(struct net_device *vrf_dev, struct sk_buff *skb)
 {
 	vrf_dev->stats.tx_errors++;
@@ -367,7 +357,7 @@ static bool qdisc_tx_is_default(const st
 static int vrf_local_xmit(struct sk_buff *skb, struct net_device *dev,
 			  struct dst_entry *dst)
 {
-	int len = skb->len;
+	unsigned int len = skb->len;
 
 	skb_orphan(skb);
 
@@ -380,15 +370,10 @@ static int vrf_local_xmit(struct sk_buff
 
 	skb->protocol = eth_type_trans(skb, dev);
 
-	if (likely(__netif_rx(skb) == NET_RX_SUCCESS)) {
-		vrf_rx_stats(dev, len);
-	} else {
-		struct pcpu_dstats *dstats = this_cpu_ptr(dev->dstats);
-
-		u64_stats_update_begin(&dstats->syncp);
-		u64_stats_inc(&dstats->rx_drops);
-		u64_stats_update_end(&dstats->syncp);
-	}
+	if (likely(__netif_rx(skb) == NET_RX_SUCCESS))
+		dev_dstats_rx_add(dev, len);
+	else
+		dev_dstats_rx_dropped(dev);
 
 	return NETDEV_TX_OK;
 }
@@ -576,20 +561,14 @@ static netdev_tx_t is_ip_tx_frame(struct
 
 static netdev_tx_t vrf_xmit(struct sk_buff *skb, struct net_device *dev)
 {
-	struct pcpu_dstats *dstats = this_cpu_ptr(dev->dstats);
-
-	int len = skb->len;
-	netdev_tx_t ret = is_ip_tx_frame(skb, dev);
-
-	u64_stats_update_begin(&dstats->syncp);
-	if (likely(ret == NET_XMIT_SUCCESS || ret == NET_XMIT_CN)) {
+	unsigned int len = skb->len;
+	netdev_tx_t ret;
 
-		u64_stats_inc(&dstats->tx_packets);
-		u64_stats_add(&dstats->tx_bytes, len);
-	} else {
-		u64_stats_inc(&dstats->tx_drops);
-	}
-	u64_stats_update_end(&dstats->syncp);
+	ret = is_ip_tx_frame(skb, dev);
+	if (likely(ret == NET_XMIT_SUCCESS || ret == NET_XMIT_CN))
+		dev_dstats_tx_add(dev, len);
+	else
+		dev_dstats_tx_dropped(dev);
 
 	return ret;
 }
@@ -1371,7 +1350,7 @@ static struct sk_buff *vrf_ip6_rcv(struc
 	if (!is_ndisc) {
 		struct net_device *orig_dev = skb->dev;
 
-		vrf_rx_stats(vrf_dev, skb->len);
+		dev_dstats_rx_add(vrf_dev, skb->len);
 		skb->dev = vrf_dev;
 		skb->skb_iif = vrf_dev->ifindex;
 
@@ -1427,7 +1406,7 @@ static struct sk_buff *vrf_ip_rcv(struct
 		goto out;
 	}
 
-	vrf_rx_stats(vrf_dev, skb->len);
+	dev_dstats_rx_add(vrf_dev, skb->len);
 
 	if (!list_empty(&vrf_dev->ptype_all)) {
 		int err;
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -2793,6 +2793,46 @@ static inline void dev_lstats_add(struct
 	u64_stats_update_end(&lstats->syncp);
 }
 
+static inline void dev_dstats_rx_add(struct net_device *dev,
+				     unsigned int len)
+{
+	struct pcpu_dstats *dstats = this_cpu_ptr(dev->dstats);
+
+	u64_stats_update_begin(&dstats->syncp);
+	u64_stats_inc(&dstats->rx_packets);
+	u64_stats_add(&dstats->rx_bytes, len);
+	u64_stats_update_end(&dstats->syncp);
+}
+
+static inline void dev_dstats_rx_dropped(struct net_device *dev)
+{
+	struct pcpu_dstats *dstats = this_cpu_ptr(dev->dstats);
+
+	u64_stats_update_begin(&dstats->syncp);
+	u64_stats_inc(&dstats->rx_drops);
+	u64_stats_update_end(&dstats->syncp);
+}
+
+static inline void dev_dstats_tx_add(struct net_device *dev,
+				     unsigned int len)
+{
+	struct pcpu_dstats *dstats = this_cpu_ptr(dev->dstats);
+
+	u64_stats_update_begin(&dstats->syncp);
+	u64_stats_inc(&dstats->tx_packets);
+	u64_stats_add(&dstats->tx_bytes, len);
+	u64_stats_update_end(&dstats->syncp);
+}
+
+static inline void dev_dstats_tx_dropped(struct net_device *dev)
+{
+	struct pcpu_dstats *dstats = this_cpu_ptr(dev->dstats);
+
+	u64_stats_update_begin(&dstats->syncp);
+	u64_stats_inc(&dstats->tx_drops);
+	u64_stats_update_end(&dstats->syncp);
+}
+
 #define __netdev_alloc_pcpu_stats(type, gfp)				\
 ({									\
 	typeof(type) __percpu *pcpu_stats = alloc_percpu_gfp(type, gfp);\


