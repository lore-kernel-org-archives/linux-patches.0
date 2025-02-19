Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D64D51D54E9;
	Wed, 19 Feb 2025 08:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955424; cv=none; b=cr0/T2O9BaIO3RQh1oazH5EwhqGWSe98rl0PKhk0gCpThfjUj/R2R7HQW+V+N3JkRIHXo3mQi6xsKX2vgAZLs0QPnEqrVml4y35Dvl5xHIv9phbRu94I2QlL9kyDEFQy1zM8TCyJP4AXTb2DiUUTndyKbO9dHNMxydLRqNjrQEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955424; c=relaxed/simple;
	bh=3SrB2qTeNqX940EiYnN6MsoYMToD+wA3CVYBBFe9LQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bw4j7L4el0HvZ/dG1EA/FTSjBUHTo+eu0AtaOMM47XuPRdWKXyxYMPfKXhLsrzyuV9eErTV44/xAP07jpZJt4hdDRirGAw0Jjx5BLmtTp5d7qljsmz6ms9vEiK/7VbnLVsK3iwE4NCCqijssnjMa0zBQjBgaAgmiU5l0hvL9J8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RBp+PbG6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RBp+PbG6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28F11C4CED1;
	Wed, 19 Feb 2025 08:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955424;
	bh=3SrB2qTeNqX940EiYnN6MsoYMToD+wA3CVYBBFe9LQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RBp+PbG6GDW8rHpP7UPHjlv7iPc1omcVOkzgrwrg8HhiBHi4w+gNdSNEOTf0bTyBN
	 OOxy83u7IciHlwS/nUAVsx69vpTDSjCcHI8Bij1khSxiEERZ+8FNA8x6ObQFKfi+uy
	 yIHcY+3mgfJN4raQigBSR/N4BfQs5OYBipw9deHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	David Ahern <dsahern@kernel.org>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 200/230] ndisc: extend RCU protection in ndisc_send_skb()
Date: Wed, 19 Feb 2025 09:28:37 +0100
Message-ID: <20250219082609.518652700@linuxfoundation.org>
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

[ Upstream commit ed6ae1f325d3c43966ec1b62ac1459e2b8e45640 ]

ndisc_send_skb() can be called without RTNL or RCU held.

Acquire rcu_read_lock() earlier, so that we can use dev_net_rcu()
and avoid a potential UAF.

Fixes: 1762f7e88eb3 ("[NETNS][IPV6] ndisc - make socket control per namespace")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Link: https://patch.msgid.link/20250207135841.1948589-8-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ndisc.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
index 90f8aa2d7af2e..8699d1a188dc4 100644
--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -471,16 +471,20 @@ static void ip6_nd_hdr(struct sk_buff *skb,
 void ndisc_send_skb(struct sk_buff *skb, const struct in6_addr *daddr,
 		    const struct in6_addr *saddr)
 {
+	struct icmp6hdr *icmp6h = icmp6_hdr(skb);
 	struct dst_entry *dst = skb_dst(skb);
-	struct net *net = dev_net(skb->dev);
-	struct sock *sk = net->ipv6.ndisc_sk;
 	struct inet6_dev *idev;
+	struct net *net;
+	struct sock *sk;
 	int err;
-	struct icmp6hdr *icmp6h = icmp6_hdr(skb);
 	u8 type;
 
 	type = icmp6h->icmp6_type;
 
+	rcu_read_lock();
+
+	net = dev_net_rcu(skb->dev);
+	sk = net->ipv6.ndisc_sk;
 	if (!dst) {
 		struct flowi6 fl6;
 		int oif = skb->dev->ifindex;
@@ -488,6 +492,7 @@ void ndisc_send_skb(struct sk_buff *skb, const struct in6_addr *daddr,
 		icmpv6_flow_init(sk, &fl6, type, saddr, daddr, oif);
 		dst = icmp6_dst_alloc(skb->dev, &fl6);
 		if (IS_ERR(dst)) {
+			rcu_read_unlock();
 			kfree_skb(skb);
 			return;
 		}
@@ -502,7 +507,6 @@ void ndisc_send_skb(struct sk_buff *skb, const struct in6_addr *daddr,
 
 	ip6_nd_hdr(skb, saddr, daddr, READ_ONCE(inet6_sk(sk)->hop_limit), skb->len);
 
-	rcu_read_lock();
 	idev = __in6_dev_get(dst->dev);
 	IP6_INC_STATS(net, idev, IPSTATS_MIB_OUTREQUESTS);
 
-- 
2.39.5



