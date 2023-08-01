Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0078C1FB4F
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:42:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D662C433CA;
	Tue,  1 Aug 2023 09:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690882974;
	bh=S/6ZsNZtjdVCINLYvi7SsJ0A1N34LCIULAgDFIzfM5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KrapO6BwLRrrdGbzyecFSPJ5fRHkE9s4WQXmLLVTB82MG2Koz786b7wjl+MIibDMH
	 8z5VWCraYd5sBIpzbNwP/WqSYPbTvlxXOFWyCyPsFmwfKk+J/2x9ECtU/gzaZsTQ7B
	 IF/KYk8haqiLiiT2Hp6QjHdqoCOjgUVFo2DHs0ko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Benc <jbenc@redhat.com>,
	Simon Horman <simon.horman@corigine.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 070/239] vxlan: calculate correct header length for GPE
Date: Tue,  1 Aug 2023 11:18:54 +0200
Message-ID: <20230801091928.206778029@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091925.659598007@linuxfoundation.org>
References: <20230801091925.659598007@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jiri Benc <jbenc@redhat.com>

[ Upstream commit 94d166c5318c6edd1e079df8552233443e909c33 ]

VXLAN-GPE does not add an extra inner Ethernet header. Take that into
account when calculating header length.

This causes problems in skb_tunnel_check_pmtu, where incorrect PMTU is
cached.

In the collect_md mode (which is the only mode that VXLAN-GPE
supports), there's no magic auto-setting of the tunnel interface MTU.
It can't be, since the destination and thus the underlying interface
may be different for each packet.

So, the administrator is responsible for setting the correct tunnel
interface MTU. Apparently, the administrators are capable enough to
calculate that the maximum MTU for VXLAN-GPE is (their_lower_MTU - 36).
They set the tunnel interface MTU to 1464. If you run a TCP stream over
such interface, it's then segmented according to the MTU 1464, i.e.
producing 1514 bytes frames. Which is okay, this still fits the lower
MTU.

However, skb_tunnel_check_pmtu (called from vxlan_xmit_one) uses 50 as
the header size and thus incorrectly calculates the frame size to be
1528. This leads to ICMP too big message being generated (locally),
PMTU of 1450 to be cached and the TCP stream to be resegmented.

The fix is to use the correct actual header size, especially for
skb_tunnel_check_pmtu calculation.

Fixes: e1e5314de08ba ("vxlan: implement GPE")
Signed-off-by: Jiri Benc <jbenc@redhat.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c |  2 +-
 drivers/net/vxlan/vxlan_core.c                | 23 ++++++++-----------
 include/net/vxlan.h                           | 13 +++++++----
 3 files changed, 20 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 1726297f2e0df..8eb9839a3ca69 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -8479,7 +8479,7 @@ static void ixgbe_atr(struct ixgbe_ring *ring,
 		struct ixgbe_adapter *adapter = q_vector->adapter;
 
 		if (unlikely(skb_tail_pointer(skb) < hdr.network +
-			     VXLAN_HEADROOM))
+			     vxlan_headroom(0)))
 			return;
 
 		/* verify the port is recognized as VXLAN */
diff --git a/drivers/net/vxlan/vxlan_core.c b/drivers/net/vxlan/vxlan_core.c
index 561fe1b314f5f..fed54702b7e21 100644
--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -2515,7 +2515,7 @@ void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
 		}
 
 		ndst = &rt->dst;
-		err = skb_tunnel_check_pmtu(skb, ndst, VXLAN_HEADROOM,
+		err = skb_tunnel_check_pmtu(skb, ndst, vxlan_headroom(flags & VXLAN_F_GPE),
 					    netif_is_any_bridge_port(dev));
 		if (err < 0) {
 			goto tx_error;
@@ -2576,7 +2576,8 @@ void vxlan_xmit_one(struct sk_buff *skb, struct net_device *dev,
 				goto out_unlock;
 		}
 
-		err = skb_tunnel_check_pmtu(skb, ndst, VXLAN6_HEADROOM,
+		err = skb_tunnel_check_pmtu(skb, ndst,
+					    vxlan_headroom((flags & VXLAN_F_GPE) | VXLAN_F_IPV6),
 					    netif_is_any_bridge_port(dev));
 		if (err < 0) {
 			goto tx_error;
@@ -2988,14 +2989,12 @@ static int vxlan_change_mtu(struct net_device *dev, int new_mtu)
 	struct vxlan_rdst *dst = &vxlan->default_dst;
 	struct net_device *lowerdev = __dev_get_by_index(vxlan->net,
 							 dst->remote_ifindex);
-	bool use_ipv6 = !!(vxlan->cfg.flags & VXLAN_F_IPV6);
 
 	/* This check is different than dev->max_mtu, because it looks at
 	 * the lowerdev->mtu, rather than the static dev->max_mtu
 	 */
 	if (lowerdev) {
-		int max_mtu = lowerdev->mtu -
-			      (use_ipv6 ? VXLAN6_HEADROOM : VXLAN_HEADROOM);
+		int max_mtu = lowerdev->mtu - vxlan_headroom(vxlan->cfg.flags);
 		if (new_mtu > max_mtu)
 			return -EINVAL;
 	}
@@ -3641,11 +3640,11 @@ static void vxlan_config_apply(struct net_device *dev,
 	struct vxlan_dev *vxlan = netdev_priv(dev);
 	struct vxlan_rdst *dst = &vxlan->default_dst;
 	unsigned short needed_headroom = ETH_HLEN;
-	bool use_ipv6 = !!(conf->flags & VXLAN_F_IPV6);
 	int max_mtu = ETH_MAX_MTU;
+	u32 flags = conf->flags;
 
 	if (!changelink) {
-		if (conf->flags & VXLAN_F_GPE)
+		if (flags & VXLAN_F_GPE)
 			vxlan_raw_setup(dev);
 		else
 			vxlan_ether_setup(dev);
@@ -3670,8 +3669,7 @@ static void vxlan_config_apply(struct net_device *dev,
 
 		dev->needed_tailroom = lowerdev->needed_tailroom;
 
-		max_mtu = lowerdev->mtu - (use_ipv6 ? VXLAN6_HEADROOM :
-					   VXLAN_HEADROOM);
+		max_mtu = lowerdev->mtu - vxlan_headroom(flags);
 		if (max_mtu < ETH_MIN_MTU)
 			max_mtu = ETH_MIN_MTU;
 
@@ -3682,10 +3680,9 @@ static void vxlan_config_apply(struct net_device *dev,
 	if (dev->mtu > max_mtu)
 		dev->mtu = max_mtu;
 
-	if (use_ipv6 || conf->flags & VXLAN_F_COLLECT_METADATA)
-		needed_headroom += VXLAN6_HEADROOM;
-	else
-		needed_headroom += VXLAN_HEADROOM;
+	if (flags & VXLAN_F_COLLECT_METADATA)
+		flags |= VXLAN_F_IPV6;
+	needed_headroom += vxlan_headroom(flags);
 	dev->needed_headroom = needed_headroom;
 
 	memcpy(&vxlan->cfg, conf, sizeof(*conf));
diff --git a/include/net/vxlan.h b/include/net/vxlan.h
index 20bd7d893e10a..b57567296bc67 100644
--- a/include/net/vxlan.h
+++ b/include/net/vxlan.h
@@ -384,10 +384,15 @@ static inline netdev_features_t vxlan_features_check(struct sk_buff *skb,
 	return features;
 }
 
-/* IP header + UDP + VXLAN + Ethernet header */
-#define VXLAN_HEADROOM (20 + 8 + 8 + 14)
-/* IPv6 header + UDP + VXLAN + Ethernet header */
-#define VXLAN6_HEADROOM (40 + 8 + 8 + 14)
+static inline int vxlan_headroom(u32 flags)
+{
+	/* VXLAN:     IP4/6 header + UDP + VXLAN + Ethernet header */
+	/* VXLAN-GPE: IP4/6 header + UDP + VXLAN */
+	return (flags & VXLAN_F_IPV6 ? sizeof(struct ipv6hdr) :
+				       sizeof(struct iphdr)) +
+	       sizeof(struct udphdr) + sizeof(struct vxlanhdr) +
+	       (flags & VXLAN_F_GPE ? 0 : ETH_HLEN);
+}
 
 static inline struct vxlanhdr *vxlan_hdr(struct sk_buff *skb)
 {
-- 
2.39.2



