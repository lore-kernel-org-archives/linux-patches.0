Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B33D94F3914;
	Tue, 13 Oct 2026 12:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895378; cv=none; b=iRT6zCC7U24kaAyzYpjPlXBADNu/kSUo4VnZklcDqi81LNPJD/UeeeDEtyDX0reO6rlIOZ+KgTkQBOvhNWaYCG9rmM6TFZfn7BsovOFhvsvGvZkZhuKA9opJM6ZPfd9x7xbyGWHXQXtNRqNosuzOMH0THq+G0LhX3MCLw50a1gE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895378; c=relaxed/simple;
	bh=84dgKCbWsRQ9ZvycgrjRCsEq+fyCO1AozIf4MPNXlGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l6qWquLxcmScSCWV1xutrVe/nHnDZLqigf8nNtt1tyjTrqFdO+tP/dhEi5bZi66opUBDxi4B6KSMJ8ECe3hN8VOiohhL1LUPVSQ4vcF5mpReu1nonZQSW9QUNN8ohSFhERuGlOQ4po0hjqeleVVHRDgNxJ0WBw9ibbjaGL65JPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1p8FNhRp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1p8FNhRp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 116EC1F000FF;
	Tue, 13 Oct 2026 12:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895376;
	bh=c7lK34a5oj9cZLJEC53HQ+qeZ9lOQoPFyqc5H0TsD8w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1p8FNhRpw61svYuYSx2WPobptkCtdlGonzfAzhf6l8tyRaXXWTk2Myqmwvp36eRLW
	 6GwNVovX1zxYt2JnTJnRlc86CiJf2s39DwoZ2h1SNkvzvU2/zGsNx3XbqOIO0JIHaW
	 z81/jtHYyfMvvDiaoYPBJydtAvabt1hOjPbhvDVM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	"Miguel Gazquez (Schneider Electric)" <miguel.gazquez@bootlin.com>
Subject: [PATCH 6.12 254/497] ipv6: use RCU in ip6_output()
Date: Tue, 13 Oct 2026 13:37:01 +0200
Message-ID: <20261013112913.920464146@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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
Signed-off-by: Miguel Gazquez (Schneider Electric) <miguel.gazquez@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ip6_output.c | 29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index e53dbf14873a2..50ed10b448c44 100644
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
@@ -125,7 +122,6 @@ static int ip6_finish_output2(struct net *net, struct sock *sk, struct sk_buff *
 
 	IP6_UPD_PO_STATS(net, idev, IPSTATS_MIB_OUT, skb->len);
 
-	rcu_read_lock();
 	nexthop = rt6_nexthop(dst_rt6_info(dst), daddr);
 	neigh = __ipv6_neigh_lookup_noref(dev, nexthop);
 
@@ -133,7 +129,6 @@ static int ip6_finish_output2(struct net *net, struct sock *sk, struct sk_buff *
 		if (unlikely(!neigh))
 			neigh = __neigh_create(&nd_tbl, nexthop, dev, false);
 		if (IS_ERR(neigh)) {
-			rcu_read_unlock();
 			IP6_INC_STATS(net, idev, IPSTATS_MIB_OUTNOROUTES);
 			kfree_skb_reason(skb, SKB_DROP_REASON_NEIGH_CREATEFAIL);
 			return -EINVAL;
@@ -141,7 +136,6 @@ static int ip6_finish_output2(struct net *net, struct sock *sk, struct sk_buff *
 	}
 	sock_confirm_neigh(skb, neigh);
 	ret = neigh_output(neigh, skb, false);
-	rcu_read_unlock();
 	return ret;
 }
 
@@ -235,22 +229,29 @@ static int ip6_finish_output(struct net *net, struct sock *sk, struct sk_buff *s
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
2.53.0



