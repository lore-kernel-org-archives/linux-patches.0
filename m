Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214450;
	b=1uWwO9usXEV0hyEaFK/2A9ejp1WSFAufecNqfvnKEIQyW2ruVlTCtAO4QbqUYE+WFLou
	 /yP9erIRjAIxnz/H61muvf+T5cQafyOUq66zwPCKSvwmnfHEWINYKN+KkSK8feRuG2KRD
	 Hmi4jqCeZKj7XbEcbr+Q4UJ/rIF2IWR2QiZR/tIEKbq3H77nbbsy4ce93pAWz6ok/fytm
	 wkc5UyKSb5zlYCQmAdhR5tb730xum1pFbPNx9JIVr1qJTyV7O4Ecb6ZvSN7PoiET1oooT
	 /ZFqBks2DPzLHGnikDmi/33Lt/P7SyOHitlNyrlcpsSipgR/jaxxRWDdX61acZ/lE1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214450;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1ERfc572c/Z4+ti3JlWY5vXexgamX9v9x/s/Iv4cDwY=;
	b=iDzgIPQl+8WnDxrLkBniC1jlDIpfKftq0FzxHkgGmbpv2bqFOH4EF5+EB6Nw88lAMBoK
	 PpwATWxfkUd4PIpYLHi6OLtM1+kRRQLYdIsf8EEUmCMkJIAoCZY1uD/eVfELzLEDsLjrK
	 yPO+Cxhu/lqdDKZw145SMgMGktkzARL8F+IecEbl4UAf2heRf3nGzOnlbm7+RNN4O654j
	 Al1T7m8htXIM8rKnQNkm5W7NAdU5zdrjoOJDtGuFp4vMph13P9w9Q6Cihalb5aLIAfUBb
	 d4dOJv1LiaKM6+9qsUCgMxoiyJ6Av9oXCxZK+1NT62TWHEkAnNyX0NhFchNTfR3okJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N12iW7LO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98B49606BFAD;
	Wed, 28 Oct 2026 19:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N12iW7LO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAB041F01825;
	Wed, 28 Oct 2026 19:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214450;
	bh=1ERfc572c/Z4+ti3JlWY5vXexgamX9v9x/s/Iv4cDwY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N12iW7LOTrLbx5dG/coFTPKnBt61IGVWaJ6Mxva1yXECbbGHCPgYVQgIAIx+lIt9b
	 7KvOmmV0ngYd3Hh8sZ6MYZuu1VHTyBSunN3CR38aRWpkehbDqscetIVI2wY6LqUFq5
	 izmDo0OQht2rTd0bbgWz0jT3YrbSVxGCbA/ExSn4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0864/1887] ipv6: use RCU in ip6_output()
Date: Wed, 28 Oct 2026 17:49:20 +0100
Message-ID: <20261028170519.079511097@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 11709573cc4e48dc34c80fc7ab9ce5b159e29695 ]

Use RCU in ip6_output() in order to use dst_dev_rcu() to prevent
possible UAF.

We can remove rcu_read_lock()/rcu_read_unlock() pairs
from ip6_finish_output2().

Fixes: 4a6ce2b6f2ec ("net: introduce a new function dst_dev_put()")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://patch.msgid.link/20250828195823.3958522-5-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ip6_output.c | 30 ++++++++++++++++--------------
 1 file changed, 16 insertions(+), 14 deletions(-)

diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 7ad60793c853c..3ff6f43bd40ae 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -59,7 +59,7 @@
 static int ip6_finish_output2(struct net *net, struct sock *sk, struct sk_buff *skb)
 {
 	struct dst_entry *dst = skb_dst(skb);
-	struct net_device *dev = dst->dev;
+	struct net_device *dev = dst_dev_rcu(dst);
 	struct inet6_dev *idev = ip6_dst_idev(dst);
 	unsigned int hh_len = LL_RESERVED_SPACE(dev);
 	const struct in6_addr *daddr, *nexthop;
@@ -69,15 +69,12 @@ static int ip6_finish_output2(struct net *net, struct sock *sk, struct sk_buff *
 
 	/* Be paranoid, rather than too clever. */
 	if (unlikely(hh_len > skb_headroom(skb)) && dev->header_ops) {
-		/* Make sure idev stays alive */
-		rcu_read_lock();
+		/* idev stays alive because we hold rcu_read_lock(). */
 		skb = skb_expand_head(skb, hh_len);
 		if (!skb) {
 			IP6_INC_STATS(net, idev, IPSTATS_MIB_OUTDISCARDS);
-			rcu_read_unlock();
 			return -ENOMEM;
 		}
-		rcu_read_unlock();
 	}
 
 	hdr = ipv6_hdr(skb);
@@ -122,7 +119,6 @@ static int ip6_finish_output2(struct net *net, struct sock *sk, struct sk_buff *
 		daddr = &hdr->daddr;
 	}
 
-	rcu_read_lock();
 	nexthop = rt6_nexthop(dst_rt6_info(dst), daddr);
 	neigh = __ipv6_neigh_lookup_noref(dev, nexthop);
 
@@ -130,7 +126,6 @@ static int ip6_finish_output2(struct net *net, struct sock *sk, struct sk_buff *
 		if (unlikely(!neigh))
 			neigh = __neigh_create(&nd_tbl, nexthop, dev, false);
 		if (IS_ERR(neigh)) {
-			rcu_read_unlock();
 			IP6_INC_STATS(net, idev, IPSTATS_MIB_OUTNOROUTES);
 			kfree_skb_reason(skb, SKB_DROP_REASON_NEIGH_CREATEFAIL);
 			return -EINVAL;
@@ -138,7 +133,6 @@ static int ip6_finish_output2(struct net *net, struct sock *sk, struct sk_buff *
 	}
 	sock_confirm_neigh(skb, neigh);
 	ret = neigh_output(neigh, skb, false);
-	rcu_read_unlock();
 	return ret;
 }
 
@@ -224,22 +218,30 @@ static int ip6_finish_output(struct net *net, struct sock *sk, struct sk_buff *s
 
 int ip6_output(struct net *net, struct sock *sk, struct sk_buff *skb)
 {
-	struct net_device *dev = skb_dst(skb)->dev, *indev = skb->dev;
-	struct inet6_dev *idev = ip6_dst_idev(skb_dst(skb));
+	struct dst_entry *dst = skb_dst(skb);
+	struct net_device *dev, *indev = skb->dev;
+	struct inet6_dev *idev;
+	int ret;
 
 	skb->protocol = htons(ETH_P_IPV6);
+	rcu_read_lock();
+	dev = dst_dev_rcu(dst);
+	idev = ip6_dst_idev(dst);
 	skb->dev = dev;
 
 	if (unlikely(!idev || READ_ONCE(idev->cnf.disable_ipv6))) {
 		IP6_INC_STATS(net, idev, IPSTATS_MIB_OUTDISCARDS);
+		rcu_read_unlock();
 		kfree_skb_reason(skb, SKB_DROP_REASON_IPV6DISABLED);
 		return 0;
 	}
 
-	return NF_HOOK_COND(NFPROTO_IPV6, NF_INET_POST_ROUTING,
-			    net, sk, skb, indev, dev,
-			    ip6_finish_output,
-			    !(IP6CB(skb)->flags & IP6SKB_REROUTED));
+	ret = NF_HOOK_COND(NFPROTO_IPV6, NF_INET_POST_ROUTING,
+			   net, sk, skb, indev, dev,
+			   ip6_finish_output,
+			   !(IP6CB(skb)->flags & IP6SKB_REROUTED));
+	rcu_read_unlock();
+	return ret;
 }
 EXPORT_SYMBOL(ip6_output);
 
-- 
2.53.0



