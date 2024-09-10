Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 389B7199932;
	Tue, 10 Sep 2024 10:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964285; cv=none; b=d994cFpk14YK08NTbnz0Q2vk/l3Bs6pGBXVM8rDSxA/mLJQQURG3JdaBmj251ZjzYBPD5LwNu71R9L5QjdMoBoSrCkpxQTVT70FHNiP75hq1YYI4b4H4r/IkxYS7fBRPQ5AraUPyZ8XjNbLM/Gs3dQ8ooVNt/+HCT7RpIjYAsaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964285; c=relaxed/simple;
	bh=FnJhkU84Ml1FwcPSGYs1c0S8nfWHSvGApbQhPVG7jG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NMwA873qLIvP4uvpywDaT+Bt0y7z4k5SHW3qfE9dLpVIAwZ/iWQSzbOBIWsCHUS4QF+OCHNvpO1btTe7gvpvxRnIhoWFQpdGUTlLOs8Y7JvXKzcTgYgspMrIS1xOm1DwlrNsW1dJxuK7sDvd/gtCDI0z3v7RulPDFT3wXgGq/Ts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YbpAon57; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YbpAon57"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEE18C4CEC6;
	Tue, 10 Sep 2024 10:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964285;
	bh=FnJhkU84Ml1FwcPSGYs1c0S8nfWHSvGApbQhPVG7jG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YbpAon57dsWKATSuGsNAcaLrPttwcfd5enae9WLC0IDzdPsKSpN5PEHz364VYQ38S
	 29w7w3kqQUAIQDaBy+Wr6tnZ1NJKVnO1PTeTUeDXqgWPOaML4yuHpZcIV4ASYphme3
	 bQdb2f1E/xIaRvkjKJqmnz3+rHjC9pDyUGt/4/7Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guillaume Nault <gnault@redhat.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 131/269] bareudp: Fix device stats updates.
Date: Tue, 10 Sep 2024 11:31:58 +0200
Message-ID: <20240910092612.866218114@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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
index 683203f87ae2..277493e41b07 100644
--- a/drivers/net/bareudp.c
+++ b/drivers/net/bareudp.c
@@ -82,7 +82,7 @@ static int bareudp_udp_encap_recv(struct sock *sk, struct sk_buff *skb)
 
 		if (skb_copy_bits(skb, BAREUDP_BASE_HLEN, &ipversion,
 				  sizeof(ipversion))) {
-			bareudp->dev->stats.rx_dropped++;
+			DEV_STATS_INC(bareudp->dev, rx_dropped);
 			goto drop;
 		}
 		ipversion >>= 4;
@@ -92,7 +92,7 @@ static int bareudp_udp_encap_recv(struct sock *sk, struct sk_buff *skb)
 		} else if (ipversion == 6 && bareudp->multi_proto_mode) {
 			proto = htons(ETH_P_IPV6);
 		} else {
-			bareudp->dev->stats.rx_dropped++;
+			DEV_STATS_INC(bareudp->dev, rx_dropped);
 			goto drop;
 		}
 	} else if (bareudp->ethertype == htons(ETH_P_MPLS_UC)) {
@@ -106,7 +106,7 @@ static int bareudp_udp_encap_recv(struct sock *sk, struct sk_buff *skb)
 				   ipv4_is_multicast(tunnel_hdr->daddr)) {
 				proto = htons(ETH_P_MPLS_MC);
 			} else {
-				bareudp->dev->stats.rx_dropped++;
+				DEV_STATS_INC(bareudp->dev, rx_dropped);
 				goto drop;
 			}
 		} else {
@@ -122,7 +122,7 @@ static int bareudp_udp_encap_recv(struct sock *sk, struct sk_buff *skb)
 				   (addr_type & IPV6_ADDR_MULTICAST)) {
 				proto = htons(ETH_P_MPLS_MC);
 			} else {
-				bareudp->dev->stats.rx_dropped++;
+				DEV_STATS_INC(bareudp->dev, rx_dropped);
 				goto drop;
 			}
 		}
@@ -134,12 +134,12 @@ static int bareudp_udp_encap_recv(struct sock *sk, struct sk_buff *skb)
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
@@ -165,8 +165,8 @@ static int bareudp_udp_encap_recv(struct sock *sk, struct sk_buff *skb)
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
@@ -462,11 +462,11 @@ static netdev_tx_t bareudp_xmit(struct sk_buff *skb, struct net_device *dev)
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



