Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D50D1875
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:54:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A069AC433EF;
	Wed, 28 Dec 2022 15:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672242884;
	bh=Qs8z/eMb9zZap8vuy7TCJ7fXrIA0nWBv7Nf/yamGJUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LuX/XJfwJipEEy7hsWdda/0mcQ9TsUt+2fTbwSB3xJRl7yDECIYMU+4Cp72uFKqxe
	 3tgpyYqQQK5WRl+ACoLW1TU712Sm5q3FMeM2pHicvVNC4LJsJIL3vCBSUBOuB6ww+f
	 ozF6XmNQcu6roKUfDf3p+4nS7OtG2IT0ncJRVDFQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzkaller@googlegroups.com>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 657/731] ipv6/sit: use DEV_STATS_INC() to avoid data-races
Date: Wed, 28 Dec 2022 15:42:44 +0100
Message-Id: <20221228144315.539101661@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit cb34b7cf17ecf33499c9298943f85af247abc1e9 ]

syzbot/KCSAN reported that multiple cpus are updating dev->stats.tx_error
concurrently.

This is because sit tunnels are NETIF_F_LLTX, meaning their ndo_start_xmit()
is not protected by a spinlock.

While original KCSAN report was about tx path, rx path has the same issue.

Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/sit.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/net/ipv6/sit.c b/net/ipv6/sit.c
index 946871741f12..d4cdc2b1b468 100644
--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -696,7 +696,7 @@ static int ipip6_rcv(struct sk_buff *skb)
 		skb->dev = tunnel->dev;
 
 		if (packet_is_spoofed(skb, iph, tunnel)) {
-			tunnel->dev->stats.rx_errors++;
+			DEV_STATS_INC(tunnel->dev, rx_errors);
 			goto out;
 		}
 
@@ -716,8 +716,8 @@ static int ipip6_rcv(struct sk_buff *skb)
 				net_info_ratelimited("non-ECT from %pI4 with TOS=%#x\n",
 						     &iph->saddr, iph->tos);
 			if (err > 1) {
-				++tunnel->dev->stats.rx_frame_errors;
-				++tunnel->dev->stats.rx_errors;
+				DEV_STATS_INC(tunnel->dev, rx_frame_errors);
+				DEV_STATS_INC(tunnel->dev, rx_errors);
 				goto out;
 			}
 		}
@@ -948,7 +948,7 @@ static netdev_tx_t ipip6_tunnel_xmit(struct sk_buff *skb,
 	if (!rt) {
 		rt = ip_route_output_flow(tunnel->net, &fl4, NULL);
 		if (IS_ERR(rt)) {
-			dev->stats.tx_carrier_errors++;
+			DEV_STATS_INC(dev, tx_carrier_errors);
 			goto tx_error_icmp;
 		}
 		dst_cache_set_ip4(&tunnel->dst_cache, &rt->dst, fl4.saddr);
@@ -956,14 +956,14 @@ static netdev_tx_t ipip6_tunnel_xmit(struct sk_buff *skb,
 
 	if (rt->rt_type != RTN_UNICAST) {
 		ip_rt_put(rt);
-		dev->stats.tx_carrier_errors++;
+		DEV_STATS_INC(dev, tx_carrier_errors);
 		goto tx_error_icmp;
 	}
 	tdev = rt->dst.dev;
 
 	if (tdev == dev) {
 		ip_rt_put(rt);
-		dev->stats.collisions++;
+		DEV_STATS_INC(dev, collisions);
 		goto tx_error;
 	}
 
@@ -976,7 +976,7 @@ static netdev_tx_t ipip6_tunnel_xmit(struct sk_buff *skb,
 		mtu = dst_mtu(&rt->dst) - t_hlen;
 
 		if (mtu < IPV4_MIN_MTU) {
-			dev->stats.collisions++;
+			DEV_STATS_INC(dev, collisions);
 			ip_rt_put(rt);
 			goto tx_error;
 		}
@@ -1015,7 +1015,7 @@ static netdev_tx_t ipip6_tunnel_xmit(struct sk_buff *skb,
 		struct sk_buff *new_skb = skb_realloc_headroom(skb, max_headroom);
 		if (!new_skb) {
 			ip_rt_put(rt);
-			dev->stats.tx_dropped++;
+			DEV_STATS_INC(dev, tx_dropped);
 			kfree_skb(skb);
 			return NETDEV_TX_OK;
 		}
@@ -1045,7 +1045,7 @@ static netdev_tx_t ipip6_tunnel_xmit(struct sk_buff *skb,
 	dst_link_failure(skb);
 tx_error:
 	kfree_skb(skb);
-	dev->stats.tx_errors++;
+	DEV_STATS_INC(dev, tx_errors);
 	return NETDEV_TX_OK;
 }
 
@@ -1064,7 +1064,7 @@ static netdev_tx_t sit_tunnel_xmit__(struct sk_buff *skb,
 	return NETDEV_TX_OK;
 tx_error:
 	kfree_skb(skb);
-	dev->stats.tx_errors++;
+	DEV_STATS_INC(dev, tx_errors);
 	return NETDEV_TX_OK;
 }
 
@@ -1093,7 +1093,7 @@ static netdev_tx_t sit_tunnel_xmit(struct sk_buff *skb,
 	return NETDEV_TX_OK;
 
 tx_err:
-	dev->stats.tx_errors++;
+	DEV_STATS_INC(dev, tx_errors);
 	kfree_skb(skb);
 	return NETDEV_TX_OK;
 
-- 
2.35.1



