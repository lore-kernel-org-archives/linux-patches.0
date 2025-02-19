Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C80E1CEAC3;
	Wed, 19 Feb 2025 08:57:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955428; cv=none; b=NFpROX17KR5htogBdCyhidEzysxr1P8wfT2CKQ6l+pUa8+m+dpx31KPJJOuGgmILCJ8NqeY1FbAkFvRqM0Tv/fAbUOXf/ADtBk4NApJqzsF5KpA99T5a4jtzVLk29b39qXKGb2XMoD2nZXXw9ZZ4zIt6iNnE3/zhuOsgnbqRKqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955428; c=relaxed/simple;
	bh=/y/4fMivZqleO6sfoD7ror3mhFqUdX9/DpZ5WbjykFg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IZMyBs6efD+105jxThv+9bgRJ0n7CnFSQaRhWrTzaIL7O+T3zAIutbl3G9wW65yDzdKTbvnetg4eUx8A5iwph6oO97bAol6esU7ml7CNxnu21MdNAo5tr+dzqQFtmRMhz9LeYpMwl7XmOmBD9ta34oz2FlNGKeaOLlGiaxtd4+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jb7nOOJ6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jb7nOOJ6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6037CC4CED1;
	Wed, 19 Feb 2025 08:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955428;
	bh=/y/4fMivZqleO6sfoD7ror3mhFqUdX9/DpZ5WbjykFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jb7nOOJ6+B7ck5NLkoAD3zhvtZv/HNyLwDMKktBOcsyIBbDl+S7KkOKjkLob5TQFw
	 lxJEd5QfPAZy/+p9g7Nl8HDsgK98v3QLeoqX3oKSQaLlBIjeWK9FjVrP+rLoUhV22e
	 TXPN6I8h2oRAEBDGSQHQo0Q/nTzL8/uTx8O8z9SI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	David Ahern <dsahern@kernel.org>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 201/230] ipv6: mcast: extend RCU protection in igmp6_send()
Date: Wed, 19 Feb 2025 09:28:38 +0100
Message-ID: <20250219082609.556945772@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index b244dbf61d5f3..6551648512585 100644
--- a/net/ipv6/mcast.c
+++ b/net/ipv6/mcast.c
@@ -2122,21 +2122,21 @@ static void mld_send_cr(struct inet6_dev *idev)
 
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
@@ -2147,19 +2147,21 @@ static void igmp6_send(struct in6_addr *addr, struct net_device *dev, int type)
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
 
@@ -2184,9 +2186,6 @@ static void igmp6_send(struct in6_addr *addr, struct net_device *dev, int type)
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



