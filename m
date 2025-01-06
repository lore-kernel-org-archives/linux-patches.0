Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5207E1DE4D2;
	Mon,  6 Jan 2025 16:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736179281; cv=none; b=iMDcAGgdAuQUBTTNnRIQYiFmcRcT6u4kN2vSVweSM4D8J1D7bkzvVl96g8T4LVEFznASzAvEw0p3ww/Jb1o0qVXsNGby1EbPfEPqgbOUbLEzCJ1RFLebe4cGeRHkN5BDNbmGUhk3mm1kv5xC4h0opMHdG9HQXgZ9vnyZ8JrP0MU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736179281; c=relaxed/simple;
	bh=rmSK5h8RZxNwBerc2p5dVpYyAelqxGhhXEZiDkWfOAM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tMIu+Dk2vMflKeXF7CF6ioshChLpgJuVqyytOAewGvxYNh98Jalgdxh9hVhL4UpiRe4fGTRe9gU+JQbeIBFK0EVSkJKQayXDi/3wBi3ax+Ap1ZV8IHL1JLTitLdmRqnhRlmF4kXYam9L+mXZRLmSjlLCkTIGuOTXe5A2zNCRzXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dAIZD5Y2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dAIZD5Y2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A57EC4CED2;
	Mon,  6 Jan 2025 16:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736179281;
	bh=rmSK5h8RZxNwBerc2p5dVpYyAelqxGhhXEZiDkWfOAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dAIZD5Y2VXCkc1b1Ykwbj4mfLPbSAEXDdhNyh3W2FrPcFHOG63ho0lYt9F0cXa3Mc
	 81zLd3wVoDwSHivQQNjHi0jQzwnJ75MvUQrsxtstUNJ/Z1Bnm9HDE5yUSqvSv95o7+
	 EKyNarpVuYbjOVQ6lZ8VWz29CxRWdL0K3kw3luJg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasily Averin <vvs@virtuozzo.com>,
	"David S. Miller" <davem@davemloft.net>,
	Harshvardhan Jha <harshvardhan.j.jha@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 54/93] ipv6: use skb_expand_head in ip6_finish_output2
Date: Mon,  6 Jan 2025 16:17:30 +0100
Message-ID: <20250106151130.743911330@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151128.686130933@linuxfoundation.org>
References: <20250106151128.686130933@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vasily Averin <vvs@virtuozzo.com>

[ Upstream commit e415ed3a4b8b246ee5e9d109ff5153efcf96b9f2 ]

Unlike skb_realloc_headroom, new helper skb_expand_head does not allocate
a new skb if possible.

Additionally this patch replaces commonly used dereferencing with variables.

Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
(cherry picked from commit e415ed3a4b8b246ee5e9d109ff5153efcf96b9f2)
Signed-off-by: Harshvardhan Jha <harshvardhan.j.jha@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ip6_output.c | 51 ++++++++++++++-----------------------------
 1 file changed, 16 insertions(+), 35 deletions(-)

diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index a34a562b0954..906d1be9dee8 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -59,46 +59,29 @@ static int ip6_finish_output2(struct net *net, struct sock *sk, struct sk_buff *
 {
 	struct dst_entry *dst = skb_dst(skb);
 	struct net_device *dev = dst->dev;
+	struct inet6_dev *idev = ip6_dst_idev(dst);
 	unsigned int hh_len = LL_RESERVED_SPACE(dev);
-	int delta = hh_len - skb_headroom(skb);
-	const struct in6_addr *nexthop;
+	const struct in6_addr *daddr, *nexthop;
+	struct ipv6hdr *hdr;
 	struct neighbour *neigh;
 	int ret;
 
 	/* Be paranoid, rather than too clever. */
-	if (unlikely(delta > 0) && dev->header_ops) {
-		/* pskb_expand_head() might crash, if skb is shared */
-		if (skb_shared(skb)) {
-			struct sk_buff *nskb = skb_clone(skb, GFP_ATOMIC);
-
-			if (likely(nskb)) {
-				if (skb->sk)
-					skb_set_owner_w(nskb, skb->sk);
-				consume_skb(skb);
-			} else {
-				kfree_skb(skb);
-			}
-			skb = nskb;
-		}
-		if (skb &&
-		    pskb_expand_head(skb, SKB_DATA_ALIGN(delta), 0, GFP_ATOMIC)) {
-			kfree_skb(skb);
-			skb = NULL;
-		}
+	if (unlikely(hh_len > skb_headroom(skb)) && dev->header_ops) {
+		skb = skb_expand_head(skb, hh_len);
 		if (!skb) {
-			IP6_INC_STATS(net, ip6_dst_idev(dst), IPSTATS_MIB_OUTDISCARDS);
+			IP6_INC_STATS(net, idev, IPSTATS_MIB_OUTDISCARDS);
 			return -ENOMEM;
 		}
 	}
 
-	if (ipv6_addr_is_multicast(&ipv6_hdr(skb)->daddr)) {
-		struct inet6_dev *idev = ip6_dst_idev(skb_dst(skb));
-
+	hdr = ipv6_hdr(skb);
+	daddr = &hdr->daddr;
+	if (ipv6_addr_is_multicast(daddr)) {
 		if (!(dev->flags & IFF_LOOPBACK) && sk_mc_loop(sk) &&
 		    ((mroute6_is_socket(net, skb) &&
 		     !(IP6CB(skb)->flags & IP6SKB_FORWARDED)) ||
-		     ipv6_chk_mcast_addr(dev, &ipv6_hdr(skb)->daddr,
-					 &ipv6_hdr(skb)->saddr))) {
+		     ipv6_chk_mcast_addr(dev, daddr, &hdr->saddr))) {
 			struct sk_buff *newskb = skb_clone(skb, GFP_ATOMIC);
 
 			/* Do not check for IFF_ALLMULTI; multicast routing
@@ -109,7 +92,7 @@ static int ip6_finish_output2(struct net *net, struct sock *sk, struct sk_buff *
 					net, sk, newskb, NULL, newskb->dev,
 					dev_loopback_xmit);
 
-			if (ipv6_hdr(skb)->hop_limit == 0) {
+			if (hdr->hop_limit == 0) {
 				IP6_INC_STATS(net, idev,
 					      IPSTATS_MIB_OUTDISCARDS);
 				kfree_skb(skb);
@@ -118,9 +101,7 @@ static int ip6_finish_output2(struct net *net, struct sock *sk, struct sk_buff *
 		}
 
 		IP6_UPD_PO_STATS(net, idev, IPSTATS_MIB_OUTMCAST, skb->len);
-
-		if (IPV6_ADDR_MC_SCOPE(&ipv6_hdr(skb)->daddr) <=
-		    IPV6_ADDR_SCOPE_NODELOCAL &&
+		if (IPV6_ADDR_MC_SCOPE(daddr) <= IPV6_ADDR_SCOPE_NODELOCAL &&
 		    !(dev->flags & IFF_LOOPBACK)) {
 			kfree_skb(skb);
 			return 0;
@@ -135,10 +116,10 @@ static int ip6_finish_output2(struct net *net, struct sock *sk, struct sk_buff *
 	}
 
 	rcu_read_lock_bh();
-	nexthop = rt6_nexthop((struct rt6_info *)dst, &ipv6_hdr(skb)->daddr);
-	neigh = __ipv6_neigh_lookup_noref(dst->dev, nexthop);
+	nexthop = rt6_nexthop((struct rt6_info *)dst, daddr);
+	neigh = __ipv6_neigh_lookup_noref(dev, nexthop);
 	if (unlikely(!neigh))
-		neigh = __neigh_create(&nd_tbl, nexthop, dst->dev, false);
+		neigh = __neigh_create(&nd_tbl, nexthop, dev, false);
 	if (!IS_ERR(neigh)) {
 		sock_confirm_neigh(skb, neigh);
 		ret = neigh_output(neigh, skb, false);
@@ -147,7 +128,7 @@ static int ip6_finish_output2(struct net *net, struct sock *sk, struct sk_buff *
 	}
 	rcu_read_unlock_bh();
 
-	IP6_INC_STATS(net, ip6_dst_idev(dst), IPSTATS_MIB_OUTNOROUTES);
+	IP6_INC_STATS(net, idev, IPSTATS_MIB_OUTNOROUTES);
 	kfree_skb(skb);
 	return -EINVAL;
 }
-- 
2.39.5



