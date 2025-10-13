Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D6E230B505;
	Mon, 13 Oct 2025 15:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369557; cv=none; b=aO7FNuVoqOPBdsMGrdohst8Bm/eYDiQ8JUISx+6bWrCGGW42GFvT1yDVJhkYKcZo1nohANZ5v/YT72ZdAcZLjg4xH6YYxaaY8zdRgvRi7dNaVZfBrYbonBKcLFcbfKJDsDRjTpHuymA98JUhkcx8Hd70DuO00EFcvmk8QDxN0Lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369557; c=relaxed/simple;
	bh=/l7Fli2oW1wZuYentZU1HRlFULM1utPjkFd/6zZgfjA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OpATth1YiRQVyfm31b1k7prKpVfIfmDssIuCB4ccwXe1jw/qwHxhzdFo3I6PwRT6j4D9nuBcbF1atqbkHfROQRMRX7b50jjQSp9D+vbipYvfVPriULIS1qa8QcECOscusI6+UgNNRNNMBI17KAqdqLQjBjNo2jaILEb1FdROZG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1VsfEbim; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1VsfEbim"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A607C4CEE7;
	Mon, 13 Oct 2025 15:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369557;
	bh=/l7Fli2oW1wZuYentZU1HRlFULM1utPjkFd/6zZgfjA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1VsfEbimVyzwBvsvkgonOMQfif6e8zOtWfTf+swiKnfGAjrBr9RtUad4HgX/hncA6
	 KhskMl7HKH/1sIcB94dXaDt/vJpGjceli+S4OnY+TTbJS7B4tZ9VXW8zIqhJhQJQPT
	 ApktsYju/QCq4qNFNcVKHDuuYc4p7jj4uj8LZiRw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 288/563] ipv6: use RCU in ip6_output()
Date: Mon, 13 Oct 2025 16:42:29 +0200
Message-ID: <20251013144421.702654451@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
 net/ipv6/ip6_output.c | 29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index e234640433d6b..9d64c13bab5ea 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -60,7 +60,7 @@
 static int ip6_finish_output2(struct net *net, struct sock *sk, struct sk_buff *skb)
 {
 	struct dst_entry *dst = skb_dst(skb);
-	struct net_device *dev = dst_dev(dst);
+	struct net_device *dev = dst_dev_rcu(dst);
 	struct inet6_dev *idev = ip6_dst_idev(dst);
 	unsigned int hh_len = LL_RESERVED_SPACE(dev);
 	const struct in6_addr *daddr, *nexthop;
@@ -70,15 +70,12 @@ static int ip6_finish_output2(struct net *net, struct sock *sk, struct sk_buff *
 
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
@@ -123,7 +120,6 @@ static int ip6_finish_output2(struct net *net, struct sock *sk, struct sk_buff *
 
 	IP6_UPD_PO_STATS(net, idev, IPSTATS_MIB_OUT, skb->len);
 
-	rcu_read_lock();
 	nexthop = rt6_nexthop(dst_rt6_info(dst), daddr);
 	neigh = __ipv6_neigh_lookup_noref(dev, nexthop);
 
@@ -131,7 +127,6 @@ static int ip6_finish_output2(struct net *net, struct sock *sk, struct sk_buff *
 		if (unlikely(!neigh))
 			neigh = __neigh_create(&nd_tbl, nexthop, dev, false);
 		if (IS_ERR(neigh)) {
-			rcu_read_unlock();
 			IP6_INC_STATS(net, idev, IPSTATS_MIB_OUTNOROUTES);
 			kfree_skb_reason(skb, SKB_DROP_REASON_NEIGH_CREATEFAIL);
 			return -EINVAL;
@@ -139,7 +134,6 @@ static int ip6_finish_output2(struct net *net, struct sock *sk, struct sk_buff *
 	}
 	sock_confirm_neigh(skb, neigh);
 	ret = neigh_output(neigh, skb, false);
-	rcu_read_unlock();
 	return ret;
 }
 
@@ -233,22 +227,29 @@ static int ip6_finish_output(struct net *net, struct sock *sk, struct sk_buff *s
 int ip6_output(struct net *net, struct sock *sk, struct sk_buff *skb)
 {
 	struct dst_entry *dst = skb_dst(skb);
-	struct net_device *dev = dst_dev(dst), *indev = skb->dev;
-	struct inet6_dev *idev = ip6_dst_idev(dst);
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
2.51.0



