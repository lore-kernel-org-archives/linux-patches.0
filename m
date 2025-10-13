Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDCC430B51C;
	Mon, 13 Oct 2025 15:32:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369566; cv=none; b=ECeLHgi0e/yG+JtaubAm8oXqWOUwnA2v/T9eIIXyYTJRaVb36OUNksxP6mMJIkBEPiUK4aWe0ESa8ueh2/ugsoCKkVnA0G8uEqTbiiRUZtA7O4CrL+J8aoxPz11fkfc/8JJdWG44T/4bwUXD5gm1NdlsVHVGwizsC/Yf6L+TCwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369566; c=relaxed/simple;
	bh=pbJvDc3+hfPD4YEcS67IqwTW+CoyCYRzT3iHXmfpMDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yr/+1yx0aW+ZY29ea7BWwlROmT/sF7p9xgPzDyDR38i2+UhvCTIDXSvEBkcJLk3MeV67G6L4Xcl2ja7q4xdaGifEASxBGLPAO+qTJlr3Y6kjRqkPCq/mBf1aAZnd3LrV3Bp9zjRMuZUPrIdQSpZDioPk7X/KCsEm1UEAHGmqP0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SueScK9u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SueScK9u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79F7BC4CEE7;
	Mon, 13 Oct 2025 15:32:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369565;
	bh=pbJvDc3+hfPD4YEcS67IqwTW+CoyCYRzT3iHXmfpMDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SueScK9uOUaiEu38i5MMhGybO39yJWC98l8dbD2mJ2IOPQKVJuyirqMKHew3/O7ak
	 itu3QPIr7C35tANsHESE/48hITVGgQqlOmtPpz+esi+bh3rMwnuY16I8NNLsPvg60s
	 OStxsTosiGJjYw0ZGKCW+iU6x5SLP9+cVCSmRHQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 291/563] ipv4: start using dst_dev_rcu()
Date: Mon, 13 Oct 2025 16:42:32 +0200
Message-ID: <20251013144421.811312959@linuxfoundation.org>
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

[ Upstream commit 6ad8de3cefdb6ffa6708b21c567df0dbf82c43a8 ]

Change icmpv4_xrlim_allow(), ip_defrag() to prevent possible UAF.

Change ipmr_prepare_xmit(), ipmr_queue_fwd_xmit(), ip_mr_output(),
ipv4_neigh_lookup() to use lockdep enabled dst_dev_rcu().

Fixes: 4a6ce2b6f2ec ("net: introduce a new function dst_dev_put()")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://patch.msgid.link/20250828195823.3958522-9-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/icmp.c        | 6 +++---
 net/ipv4/ip_fragment.c | 6 ++++--
 net/ipv4/ipmr.c        | 6 +++---
 net/ipv4/route.c       | 4 ++--
 4 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index c48c572f024da..1be0d91620a38 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -318,17 +318,17 @@ static bool icmpv4_xrlim_allow(struct net *net, struct rtable *rt,
 		return true;
 
 	/* No rate limit on loopback */
-	dev = dst_dev(dst);
+	rcu_read_lock();
+	dev = dst_dev_rcu(dst);
 	if (dev && (dev->flags & IFF_LOOPBACK))
 		goto out;
 
-	rcu_read_lock();
 	peer = inet_getpeer_v4(net->ipv4.peers, fl4->daddr,
 			       l3mdev_master_ifindex_rcu(dev));
 	rc = inet_peer_xrlim_allow(peer,
 				   READ_ONCE(net->ipv4.sysctl_icmp_ratelimit));
-	rcu_read_unlock();
 out:
+	rcu_read_unlock();
 	if (!rc)
 		__ICMP_INC_STATS(net, ICMP_MIB_RATELIMITHOST);
 	else
diff --git a/net/ipv4/ip_fragment.c b/net/ipv4/ip_fragment.c
index b2584cce90ae1..f7012479713ba 100644
--- a/net/ipv4/ip_fragment.c
+++ b/net/ipv4/ip_fragment.c
@@ -476,14 +476,16 @@ static int ip_frag_reasm(struct ipq *qp, struct sk_buff *skb,
 /* Process an incoming IP datagram fragment. */
 int ip_defrag(struct net *net, struct sk_buff *skb, u32 user)
 {
-	struct net_device *dev = skb->dev ? : skb_dst_dev(skb);
-	int vif = l3mdev_master_ifindex_rcu(dev);
+	struct net_device *dev;
 	struct ipq *qp;
+	int vif;
 
 	__IP_INC_STATS(net, IPSTATS_MIB_REASMREQDS);
 
 	/* Lookup (or create) queue header */
 	rcu_read_lock();
+	dev = skb->dev ? : skb_dst_dev_rcu(skb);
+	vif = l3mdev_master_ifindex_rcu(dev);
 	qp = ip_find(net, ip_hdr(skb), user, vif);
 	if (qp) {
 		int ret, refs = 0;
diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index e86a8a862c411..8c568fbddb5fb 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -1904,7 +1904,7 @@ static int ipmr_prepare_xmit(struct net *net, struct mr_table *mrt,
 		return -1;
 	}
 
-	encap += LL_RESERVED_SPACE(rt->dst.dev) + rt->dst.header_len;
+	encap += LL_RESERVED_SPACE(dst_dev_rcu(&rt->dst)) + rt->dst.header_len;
 
 	if (skb_cow(skb, encap)) {
 		ip_rt_put(rt);
@@ -1957,7 +1957,7 @@ static void ipmr_queue_fwd_xmit(struct net *net, struct mr_table *mrt,
 	 * result in receiving multiple packets.
 	 */
 	NF_HOOK(NFPROTO_IPV4, NF_INET_FORWARD,
-		net, NULL, skb, skb->dev, rt->dst.dev,
+		net, NULL, skb, skb->dev, dst_dev_rcu(&rt->dst),
 		ipmr_forward_finish);
 	return;
 
@@ -2301,7 +2301,7 @@ int ip_mr_output(struct net *net, struct sock *sk, struct sk_buff *skb)
 
 	guard(rcu)();
 
-	dev = rt->dst.dev;
+	dev = dst_dev_rcu(&rt->dst);
 
 	if (IPCB(skb)->flags & IPSKB_FORWARDED)
 		goto mc_output;
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 97b96275a775d..5582ccd673eeb 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -413,11 +413,11 @@ static struct neighbour *ipv4_neigh_lookup(const struct dst_entry *dst,
 					   const void *daddr)
 {
 	const struct rtable *rt = container_of(dst, struct rtable, dst);
-	struct net_device *dev = dst_dev(dst);
+	struct net_device *dev;
 	struct neighbour *n;
 
 	rcu_read_lock();
-
+	dev = dst_dev_rcu(dst);
 	if (likely(rt->rt_gw_family == AF_INET)) {
 		n = ip_neigh_gw4(dev, rt->rt_gw4);
 	} else if (rt->rt_gw_family == AF_INET6) {
-- 
2.51.0



