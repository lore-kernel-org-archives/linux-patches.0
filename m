Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E60AA25D8E8;
	Tue, 11 Mar 2025 15:13:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706005; cv=none; b=kNZ19Q+fsvDv1XTmzmf/TaUIQL31vaur6pbnei8SI0KdDtRO6ecbx6JmdRgNVv/1prZ+tv04d4TrGJVGCfzdF5rJelKZMrRNW5MyoSK4dlsXzNsFPdy3AAF6BPP1V4Z7Lp9QrRDmrobAn7OPpqeFuAiwyXnY8tH20LaSwXXt0bI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706005; c=relaxed/simple;
	bh=QIGNOi28471RkVGiYjmlwldPpkE9sohoTpzAWlU9h1g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BbYS+el9j0+yWrxv/xRwOt6Fe8VlKToNTSUgPqUjDaAANar4zJNpyrDB1kJbjqDIisTk8w3XZ91Z0cDSHwYYdvhtl4tZsXX5fpYNQ0EnwbxmpXMJSBmvUbdfj08jiiyvsAOk8t5IgB/gxCSExMbJwIjxGsq7WDhgEZCuVVqaRAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FSAGblyx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FSAGblyx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37EE2C4CEEC;
	Tue, 11 Mar 2025 15:13:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706004;
	bh=QIGNOi28471RkVGiYjmlwldPpkE9sohoTpzAWlU9h1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FSAGblyxnugtRf/UKDfgHctfiDCMt0KT2TkO4hm+tZ/tsSFFq05kDzgV0ycY/8EsL
	 flyBkBamvYO5VfcPDcRzAhOA5mF6D1nliQcaFHsgMCfTsbMSOvRT2ZiZL2wINZZ1cH
	 1zKRB4QfIgxgeGZUmh0rsOT82dILiKgLxw8GdZn4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	David Ahern <dsahern@kernel.org>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 211/328] ndisc: extend RCU protection in ndisc_send_skb()
Date: Tue, 11 Mar 2025 15:59:41 +0100
Message-ID: <20250311145723.288825850@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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
index 92e35b3096dba..fe10f1ce167be 100644
--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -470,16 +470,20 @@ static void ndisc_send_skb(struct sk_buff *skb,
 			   const struct in6_addr *daddr,
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
@@ -487,6 +491,7 @@ static void ndisc_send_skb(struct sk_buff *skb,
 		icmpv6_flow_init(sk, &fl6, type, saddr, daddr, oif);
 		dst = icmp6_dst_alloc(skb->dev, &fl6);
 		if (IS_ERR(dst)) {
+			rcu_read_unlock();
 			kfree_skb(skb);
 			return;
 		}
@@ -501,7 +506,6 @@ static void ndisc_send_skb(struct sk_buff *skb,
 
 	ip6_nd_hdr(skb, saddr, daddr, inet6_sk(sk)->hop_limit, skb->len);
 
-	rcu_read_lock();
 	idev = __in6_dev_get(dst->dev);
 	IP6_UPD_PO_STATS(net, idev, IPSTATS_MIB_OUT, skb->len);
 
-- 
2.39.5



