Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C32861EB1A2;
	Wed, 19 Feb 2025 08:55:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955300; cv=none; b=b1YX9lEbY6cZN5l7aB9pRrlSNNVMAcxnVdyen7jv2v6lFF6rPy0OYOI6MD/Zj1neBLJ43a/ZADf0TMnQkqG5uC7Hl4yaOgBpDPujoqkEfk95jUEVOTuzwV/IYWSGucuZCxCjhqbo5cVTzv7LKcNxDrQD0QA8plMSTs5VOc0mjUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955300; c=relaxed/simple;
	bh=9463gGeHVhv05uHkqVqbd7qOE8rUtbBo40WbiX64bBo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=khLKsV3ogfBm+K6S9wW7HJYnEKhINqIXCbGaq5udV9JPF6wefYFRLN/v6l/E9lIHXitqohPRl4qU4XMzOqNjKva8VV/Ls7UceoOQU/VGxk2/jwgI9JDU1iOKfX/uxBaYTF0I0UjIw1LUSO0GBuYXfzG4mlMG9onL2wJnxgILayM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AhDigHPi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AhDigHPi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46DBEC4CED1;
	Wed, 19 Feb 2025 08:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955300;
	bh=9463gGeHVhv05uHkqVqbd7qOE8rUtbBo40WbiX64bBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AhDigHPikUQXV5HuYqTxz8Tmuf5PrOravOUmu//8wjxQ28Up3bV+e5lD2nT9xZXOE
	 hN7Z6cRtWgJsWwj9pd+ALdb9i9+bxxW8Pm7g0cEvAX3aNhyStrI12FLZwu/PM+dKD3
	 mg4CsbwMWyFU4EzUg7ctjJqMdfpynw9KBrt6yE+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 193/230] ipv6: icmp: convert to dev_net_rcu()
Date: Wed, 19 Feb 2025 09:28:30 +0100
Message-ID: <20250219082609.250322636@linuxfoundation.org>
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

[ Upstream commit 34aef2b0ce3aa4eb4ef2e1f5cad3738d527032f5 ]

icmp6_send() must acquire rcu_read_lock() sooner to ensure
the dev_net() call done from a safe context.

Other ICMPv6 uses of dev_net() seem safe, change them to
dev_net_rcu() to get LOCKDEP support to catch bugs.

Fixes: 9a43b709a230 ("[NETNS][IPV6] icmp6 - make icmpv6_socket per namespace")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20250205155120.1676781-12-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/icmp.c | 42 +++++++++++++++++++++++-------------------
 1 file changed, 23 insertions(+), 19 deletions(-)

diff --git a/net/ipv6/icmp.c b/net/ipv6/icmp.c
index a6984a29fdb9d..4d14ab7f7e99f 100644
--- a/net/ipv6/icmp.c
+++ b/net/ipv6/icmp.c
@@ -76,7 +76,7 @@ static int icmpv6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 {
 	/* icmpv6_notify checks 8 bytes can be pulled, icmp6hdr is 8 bytes */
 	struct icmp6hdr *icmp6 = (struct icmp6hdr *) (skb->data + offset);
-	struct net *net = dev_net(skb->dev);
+	struct net *net = dev_net_rcu(skb->dev);
 
 	if (type == ICMPV6_PKT_TOOBIG)
 		ip6_update_pmtu(skb, net, info, skb->dev->ifindex, 0, sock_net_uid(net, NULL));
@@ -473,7 +473,10 @@ void icmp6_send(struct sk_buff *skb, u8 type, u8 code, __u32 info,
 
 	if (!skb->dev)
 		return;
-	net = dev_net(skb->dev);
+
+	rcu_read_lock();
+
+	net = dev_net_rcu(skb->dev);
 	mark = IP6_REPLY_MARK(net, skb->mark);
 	/*
 	 *	Make sure we respect the rules
@@ -496,7 +499,7 @@ void icmp6_send(struct sk_buff *skb, u8 type, u8 code, __u32 info,
 		    !(type == ICMPV6_PARAMPROB &&
 		      code == ICMPV6_UNK_OPTION &&
 		      (opt_unrec(skb, info))))
-			return;
+			goto out;
 
 		saddr = NULL;
 	}
@@ -526,7 +529,7 @@ void icmp6_send(struct sk_buff *skb, u8 type, u8 code, __u32 info,
 	if ((addr_type == IPV6_ADDR_ANY) || (addr_type & IPV6_ADDR_MULTICAST)) {
 		net_dbg_ratelimited("icmp6_send: addr_any/mcast source [%pI6c > %pI6c]\n",
 				    &hdr->saddr, &hdr->daddr);
-		return;
+		goto out;
 	}
 
 	/*
@@ -535,7 +538,7 @@ void icmp6_send(struct sk_buff *skb, u8 type, u8 code, __u32 info,
 	if (is_ineligible(skb)) {
 		net_dbg_ratelimited("icmp6_send: no reply to icmp error [%pI6c > %pI6c]\n",
 				    &hdr->saddr, &hdr->daddr);
-		return;
+		goto out;
 	}
 
 	/* Needed by both icmpv6_global_allow and icmpv6_xmit_lock */
@@ -582,7 +585,7 @@ void icmp6_send(struct sk_buff *skb, u8 type, u8 code, __u32 info,
 	np = inet6_sk(sk);
 
 	if (!icmpv6_xrlim_allow(sk, type, &fl6, apply_ratelimit))
-		goto out;
+		goto out_unlock;
 
 	tmp_hdr.icmp6_type = type;
 	tmp_hdr.icmp6_code = code;
@@ -600,7 +603,7 @@ void icmp6_send(struct sk_buff *skb, u8 type, u8 code, __u32 info,
 
 	dst = icmpv6_route_lookup(net, skb, sk, &fl6);
 	if (IS_ERR(dst))
-		goto out;
+		goto out_unlock;
 
 	ipc6.hlimit = ip6_sk_dst_hoplimit(np, &fl6, dst);
 
@@ -616,7 +619,6 @@ void icmp6_send(struct sk_buff *skb, u8 type, u8 code, __u32 info,
 		goto out_dst_release;
 	}
 
-	rcu_read_lock();
 	idev = __in6_dev_get(skb->dev);
 
 	if (ip6_append_data(sk, icmpv6_getfrag, &msg,
@@ -630,13 +632,15 @@ void icmp6_send(struct sk_buff *skb, u8 type, u8 code, __u32 info,
 		icmpv6_push_pending_frames(sk, &fl6, &tmp_hdr,
 					   len + sizeof(struct icmp6hdr));
 	}
-	rcu_read_unlock();
+
 out_dst_release:
 	dst_release(dst);
-out:
+out_unlock:
 	icmpv6_xmit_unlock(sk);
 out_bh_enable:
 	local_bh_enable();
+out:
+	rcu_read_unlock();
 }
 EXPORT_SYMBOL(icmp6_send);
 
@@ -679,8 +683,8 @@ int ip6_err_gen_icmpv6_unreach(struct sk_buff *skb, int nhs, int type,
 	skb_pull(skb2, nhs);
 	skb_reset_network_header(skb2);
 
-	rt = rt6_lookup(dev_net(skb->dev), &ipv6_hdr(skb2)->saddr, NULL, 0,
-			skb, 0);
+	rt = rt6_lookup(dev_net_rcu(skb->dev), &ipv6_hdr(skb2)->saddr,
+			NULL, 0, skb, 0);
 
 	if (rt && rt->dst.dev)
 		skb2->dev = rt->dst.dev;
@@ -717,7 +721,7 @@ EXPORT_SYMBOL(ip6_err_gen_icmpv6_unreach);
 
 static enum skb_drop_reason icmpv6_echo_reply(struct sk_buff *skb)
 {
-	struct net *net = dev_net(skb->dev);
+	struct net *net = dev_net_rcu(skb->dev);
 	struct sock *sk;
 	struct inet6_dev *idev;
 	struct ipv6_pinfo *np;
@@ -832,7 +836,7 @@ enum skb_drop_reason icmpv6_notify(struct sk_buff *skb, u8 type,
 				   u8 code, __be32 info)
 {
 	struct inet6_skb_parm *opt = IP6CB(skb);
-	struct net *net = dev_net(skb->dev);
+	struct net *net = dev_net_rcu(skb->dev);
 	const struct inet6_protocol *ipprot;
 	enum skb_drop_reason reason;
 	int inner_offset;
@@ -889,7 +893,7 @@ enum skb_drop_reason icmpv6_notify(struct sk_buff *skb, u8 type,
 static int icmpv6_rcv(struct sk_buff *skb)
 {
 	enum skb_drop_reason reason = SKB_DROP_REASON_NOT_SPECIFIED;
-	struct net *net = dev_net(skb->dev);
+	struct net *net = dev_net_rcu(skb->dev);
 	struct net_device *dev = icmp6_dev(skb);
 	struct inet6_dev *idev = __in6_dev_get(dev);
 	const struct in6_addr *saddr, *daddr;
@@ -921,7 +925,7 @@ static int icmpv6_rcv(struct sk_buff *skb)
 		skb_set_network_header(skb, nh);
 	}
 
-	__ICMP6_INC_STATS(dev_net(dev), idev, ICMP6_MIB_INMSGS);
+	__ICMP6_INC_STATS(dev_net_rcu(dev), idev, ICMP6_MIB_INMSGS);
 
 	saddr = &ipv6_hdr(skb)->saddr;
 	daddr = &ipv6_hdr(skb)->daddr;
@@ -939,7 +943,7 @@ static int icmpv6_rcv(struct sk_buff *skb)
 
 	type = hdr->icmp6_type;
 
-	ICMP6MSGIN_INC_STATS(dev_net(dev), idev, type);
+	ICMP6MSGIN_INC_STATS(dev_net_rcu(dev), idev, type);
 
 	switch (type) {
 	case ICMPV6_ECHO_REQUEST:
@@ -1034,9 +1038,9 @@ static int icmpv6_rcv(struct sk_buff *skb)
 
 csum_error:
 	reason = SKB_DROP_REASON_ICMP_CSUM;
-	__ICMP6_INC_STATS(dev_net(dev), idev, ICMP6_MIB_CSUMERRORS);
+	__ICMP6_INC_STATS(dev_net_rcu(dev), idev, ICMP6_MIB_CSUMERRORS);
 discard_it:
-	__ICMP6_INC_STATS(dev_net(dev), idev, ICMP6_MIB_INERRORS);
+	__ICMP6_INC_STATS(dev_net_rcu(dev), idev, ICMP6_MIB_INERRORS);
 drop_no_count:
 	kfree_skb_reason(skb, reason);
 	return 0;
-- 
2.39.5



