Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 431591DCB0E;
	Wed, 19 Feb 2025 09:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955833; cv=none; b=FWEkcik7H2VrhSwKwasSec/6p8wxldZ8LP+gi+rWMVxRUQxr4SDrEb9IXLGDv0jrwSsHYngD5TAKyIqCVimFqRp+/tS8NHInGJCb3rNFXYPlhMsd6PI2pTIyObrzU3i6MwLtP2mTkUNcuMJ+wsaex1PitHFdL0lCaVYZBGJuHho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955833; c=relaxed/simple;
	bh=RPvcOedcO8GVpGUpWFf71L6XjuHTNbslGKxhn2aOte4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s3Xx7RfeXxpUjNvvwCv0JgqTCMLEnsAefHISxQxCBtdAWgeYvrJpeGf9XYZCZu74d6npy51SuUFUlu1m3dfebGMSKToAHJcSTedvcFYLBx2gpx4aAKxCg4uOJ1KAZ6hJfEcKkvVyVBZVXO37KTDFz776t5eZW2HCKLCS8QYJJJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S8BjAiMj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S8BjAiMj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6DCAC4CED1;
	Wed, 19 Feb 2025 09:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955833;
	bh=RPvcOedcO8GVpGUpWFf71L6XjuHTNbslGKxhn2aOte4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S8BjAiMjcmQf+59mRTKE0Zasjs+rJaEAvNH+5b3R6YEeMY4RNTywaKkdM3Z461ftT
	 paxM4MgwORvw+GWdgHdaIguGBbTJ7dJa+s0c0Q4z6ksVKh0T3GjFwx05qhu8e9PB+T
	 6jjAV6S8In+J6TDhljyMV01QfAI1qNVyN59xiuKI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	David Ahern <dsahern@kernel.org>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 127/152] ipv6: mcast: extend RCU protection in igmp6_send()
Date: Wed, 19 Feb 2025 09:29:00 +0100
Message-ID: <20250219082555.071453804@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082550.014812078@linuxfoundation.org>
References: <20250219082550.014812078@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 087c1faa594fa07a66933d750c0b2610aa1a2946 ]

igmp6_send() can be called without RTNL or RCU being held.

Extend RCU protection so that we can safely fetch the net pointer
and avoid a potential UAF.

Note that we no longer can use sock_alloc_send_skb() because
ipv6.igmp_sk uses GFP_KERNEL allocations which can sleep.

Instead use alloc_skb() and charge the net->ipv6.igmp_sk
socket under RCU protection.

Fixes: b8ad0cbc58f7 ("[NETNS][IPV6] mcast - handle several network namespace")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Link: https://patch.msgid.link/20250207135841.1948589-9-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/mcast.c | 31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

diff --git a/net/ipv6/mcast.c b/net/ipv6/mcast.c
index 6e2f77a95a657..a502669b2b28a 100644
--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -2121,21 +2121,21 @@ static void mld_send_cr(struct inet6_dev *idev)
 
 static void igmp6_send(struct in6_addr *addr, struct net_device *dev, int type)
 {
-	struct net *net = dev_net(dev);
-	struct sock *sk = net->ipv6.igmp_sk;
+	const struct in6_addr *snd_addr, *saddr;
+	int err, len, payload_len, full_len;
+	struct in6_addr addr_buf;
 	struct inet6_dev *idev;
 	struct sk_buff *skb;
 	struct mld_msg *hdr;
-	const struct in6_addr *snd_addr, *saddr;
-	struct in6_addr addr_buf;
 	int hlen = LL_RESERVED_SPACE(dev);
 	int tlen = dev->needed_tailroom;
-	int err, len, payload_len, full_len;
 	u8 ra[8] = { IPPROTO_ICMPV6, 0,
 		     IPV6_TLV_ROUTERALERT, 2, 0, 0,
 		     IPV6_TLV_PADN, 0 };
-	struct flowi6 fl6;
 	struct dst_entry *dst;
+	struct flowi6 fl6;
+	struct net *net;
+	struct sock *sk;
 
 	if (type == ICMPV6_MGM_REDUCTION)
 		snd_addr = &in6addr_linklocal_allrouters;
@@ -2146,19 +2146,21 @@ static void igmp6_send(struct in6_addr *addr, struct net_device *dev, int type)
 	payload_len = len + sizeof(ra);
 	full_len = sizeof(struct ipv6hdr) + payload_len;
 
-	rcu_read_lock();
-	IP6_INC_STATS(net, __in6_dev_get(dev), IPSTATS_MIB_OUTREQUESTS);
-	rcu_read_unlock();
+	skb = alloc_skb(hlen + tlen + full_len, GFP_KERNEL);
 
-	skb = sock_alloc_send_skb(sk, hlen + tlen + full_len, 1, &err);
+	rcu_read_lock();
 
+	net = dev_net_rcu(dev);
+	idev = __in6_dev_get(dev);
+	IP6_INC_STATS(net, idev, IPSTATS_MIB_OUTREQUESTS);
 	if (!skb) {
-		rcu_read_lock();
-		IP6_INC_STATS(net, __in6_dev_get(dev),
-			      IPSTATS_MIB_OUTDISCARDS);
+		IP6_INC_STATS(net, idev, IPSTATS_MIB_OUTDISCARDS);
 		rcu_read_unlock();
 		return;
 	}
+	sk = net->ipv6.igmp_sk;
+	skb_set_owner_w(skb, sk);
+
 	skb->priority = TC_PRIO_CONTROL;
 	skb_reserve(skb, hlen);
 
@@ -2183,9 +2185,6 @@ static void igmp6_send(struct in6_addr *addr, struct net_device *dev, int type)
 					 IPPROTO_ICMPV6,
 					 csum_partial(hdr, len, 0));
 
-	rcu_read_lock();
-	idev = __in6_dev_get(skb->dev);
-
 	icmpv6_flow_init(sk, &fl6, type,
 			 &ipv6_hdr(skb)->saddr, &ipv6_hdr(skb)->daddr,
 			 skb->dev->ifindex);
-- 
2.39.5



