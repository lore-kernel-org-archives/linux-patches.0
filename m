Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 592F817C7A3;
	Tue, 10 Sep 2024 10:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725965105; cv=none; b=K5LWpAkhs24MT+lzPeDldwJASm45XK3qHuzZ0qdIT5gO8uFYvHLHhPdqSWBW0q9hyqhB54Qy+htqYaaMxjEBGHSGhmdDhNRmf2lIIwgYM6PflutXnKNWRmzdMWTwBZIrbt4HDp+4nHeK9ztdYQ/aoFeP0GkBxqlG2ypt8O8gOP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725965105; c=relaxed/simple;
	bh=sb7Jmi1G1xnFHDrspcuTtLQ8/l2xlYJbT2AZjCEMimI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t2Iue4L3Du9UwThI+M1oZzE2PtPrIee81w6hMoMvAc81CEkXVF3g8AUhFAm+e3M9BFLwWPz9VLpKBqu+2h1pA75WtgcMNDKDdR+vvw0V83bVQi9F83Gv7PUgPaNIeqCeHfTm5yT6kkJCeKQDzOurwJWCzSqlJ1Mpe0ngaWjdHYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D+m+HReI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D+m+HReI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E5B9C4CEC6;
	Tue, 10 Sep 2024 10:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725965105;
	bh=sb7Jmi1G1xnFHDrspcuTtLQ8/l2xlYJbT2AZjCEMimI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D+m+HReIz9LSRDJ10kkqmxVMiQCCoNF6ZRN8/Vmj/Mkj5uoDbZpjbKTg1ySEfdFTW
	 nPm4pKF4Ufoe86Bv5lefjE+46hlvHMIdO0q9we5kg6tCQAxEWlLbD9dNTsKgMpXGAF
	 P50BTldPknjxWo41SK19wkwocFL9WDhcWHUsgfpE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guillaume Nault <gnault@redhat.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 121/186] bareudp: Fix device stats updates.
Date: Tue, 10 Sep 2024 11:33:36 +0200
Message-ID: <20240910092559.558882637@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092554.645718780@linuxfoundation.org>
References: <20240910092554.645718780@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guillaume Nault <gnault@redhat.com>

[ Upstream commit 4963d2343af81f493519f9c3ea9f2169eaa7353a ]

Bareudp devices update their stats concurrently.
Therefore they need proper atomic increments.

Fixes: 571912c69f0e ("net: UDP tunnel encapsulation module for tunnelling different protocols like MPLS, IP, NSH etc.")
Signed-off-by: Guillaume Nault <gnault@redhat.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/04b7b9d0b480158eb3ab4366ec80aa2ab7e41fcb.1725031794.git.gnault@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bareudp.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/bareudp.c b/drivers/net/bareudp.c
index 53ef48588e59..d9917120b8fa 100644
--- a/drivers/net/bareudp.c
+++ b/drivers/net/bareudp.c
@@ -75,7 +75,7 @@ static int bareudp_udp_encap_recv(struct sock *sk, struct sk_buff *skb)
 
 		if (skb_copy_bits(skb, BAREUDP_BASE_HLEN, &ipversion,
 				  sizeof(ipversion))) {
-			bareudp->dev->stats.rx_dropped++;
+			DEV_STATS_INC(bareudp->dev, rx_dropped);
 			goto drop;
 		}
 		ipversion >>= 4;
@@ -85,7 +85,7 @@ static int bareudp_udp_encap_recv(struct sock *sk, struct sk_buff *skb)
 		} else if (ipversion == 6 && bareudp->multi_proto_mode) {
 			proto = htons(ETH_P_IPV6);
 		} else {
-			bareudp->dev->stats.rx_dropped++;
+			DEV_STATS_INC(bareudp->dev, rx_dropped);
 			goto drop;
 		}
 	} else if (bareudp->ethertype == htons(ETH_P_MPLS_UC)) {
@@ -99,7 +99,7 @@ static int bareudp_udp_encap_recv(struct sock *sk, struct sk_buff *skb)
 				   ipv4_is_multicast(tunnel_hdr->daddr)) {
 				proto = htons(ETH_P_MPLS_MC);
 			} else {
-				bareudp->dev->stats.rx_dropped++;
+				DEV_STATS_INC(bareudp->dev, rx_dropped);
 				goto drop;
 			}
 		} else {
@@ -115,7 +115,7 @@ static int bareudp_udp_encap_recv(struct sock *sk, struct sk_buff *skb)
 				   (addr_type & IPV6_ADDR_MULTICAST)) {
 				proto = htons(ETH_P_MPLS_MC);
 			} else {
-				bareudp->dev->stats.rx_dropped++;
+				DEV_STATS_INC(bareudp->dev, rx_dropped);
 				goto drop;
 			}
 		}
@@ -127,12 +127,12 @@ static int bareudp_udp_encap_recv(struct sock *sk, struct sk_buff *skb)
 				 proto,
 				 !net_eq(bareudp->net,
 				 dev_net(bareudp->dev)))) {
-		bareudp->dev->stats.rx_dropped++;
+		DEV_STATS_INC(bareudp->dev, rx_dropped);
 		goto drop;
 	}
 	tun_dst = udp_tun_rx_dst(skb, family, TUNNEL_KEY, 0, 0);
 	if (!tun_dst) {
-		bareudp->dev->stats.rx_dropped++;
+		DEV_STATS_INC(bareudp->dev, rx_dropped);
 		goto drop;
 	}
 	skb_dst_set(skb, &tun_dst->dst);
@@ -157,8 +157,8 @@ static int bareudp_udp_encap_recv(struct sock *sk, struct sk_buff *skb)
 						     &((struct ipv6hdr *)oiph)->saddr);
 		}
 		if (err > 1) {
-			++bareudp->dev->stats.rx_frame_errors;
-			++bareudp->dev->stats.rx_errors;
+			DEV_STATS_INC(bareudp->dev, rx_frame_errors);
+			DEV_STATS_INC(bareudp->dev, rx_errors);
 			goto drop;
 		}
 	}
@@ -453,11 +453,11 @@ static netdev_tx_t bareudp_xmit(struct sk_buff *skb, struct net_device *dev)
 	dev_kfree_skb(skb);
 
 	if (err == -ELOOP)
-		dev->stats.collisions++;
+		DEV_STATS_INC(dev, collisions);
 	else if (err == -ENETUNREACH)
-		dev->stats.tx_carrier_errors++;
+		DEV_STATS_INC(dev, tx_carrier_errors);
 
-	dev->stats.tx_errors++;
+	DEV_STATS_INC(dev, tx_errors);
 	return NETDEV_TX_OK;
 }
 
-- 
2.43.0



