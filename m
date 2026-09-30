Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A7DF4E324D;
	Wed, 30 Sep 2026 16:25:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785512; cv=none; b=cYTF7dezISKuA22qRvyJiuacUHGxafyTLlzGhUjq4WDXAayj5x8THgOpQAn1ukfeYTtyoQSdwPXX0DjFIwQRd83iaBYbiViBhibC7c/O/lN12nQSM+UjE6JWA9SpWqXTPGMKyjjkDVA3EkCOkh887EvvTGbTRg2UMz4UxgByaW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785512; c=relaxed/simple;
	bh=B1j0DM3CzzjOUPi7hyGHSxUcSH7IHgsJmn43Q0Pqh2M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cRIQGKXT9GQSR4M5XlbDI/aBk0+DMNfuxxl1KGe53h+aAXszfOYKsYdgbrTaJdFAgpQWfSdMfHSQVoAoNsZiB2mxQZFYf14fTvKdHInL8F03WyOFf2zWcVZi53cazJfoYipB/vubhwXS2IJIjFoddyVRTg1ogaB9nJxmhphrf54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c/+LrCic; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c/+LrCic"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C37FB1F000FF;
	Wed, 30 Sep 2026 16:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785506;
	bh=Y5GVBOiJs/dJi6j7QdGYEk0YH8Tn7JnMEEjYXA5TtrI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c/+LrCicIFDq9tVYkgcVPikOIKoDJTWSS6vJQtUnI9Wajl+zAYbNguU9neqeIABkQ
	 36AshqBamSIxdomqrL0Iz4yodEnnVRb8FmEV3Cl94UA1Ysg8dXcJ9dhW6WPlgTY+X7
	 UXReHt3y5Zdh/QJaGTlFg57hlHcvFk9Fsw91U0fo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	"Miguel Gazquez (Schneider Electric)" <miguel.gazquez@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 496/982] ipv4: start using dst_dev_rcu()
Date: Wed, 30 Sep 2026 17:20:32 +0200
Message-ID: <20260930152427.435278609@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
[ minor modifications to fix conflict, added rcu_read_lock and unlock
to ip_defrag function ]
Signed-off-by: Miguel Gazquez (Schneider Electric) <miguel.gazquez@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/icmp.c        | 6 +++---
 net/ipv4/ip_fragment.c | 9 +++++++--
 net/ipv4/ipmr.c        | 2 +-
 net/ipv4/route.c       | 4 ++--
 4 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index f0c8c3366740a..5c38af80bc14e 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -320,17 +320,17 @@ static bool icmpv4_xrlim_allow(struct net *net, struct rtable *rt,
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
index a70ede523297c..43b1265f5ac19 100644
--- a/net/ipv4/ip_fragment.c
+++ b/net/ipv4/ip_fragment.c
@@ -481,13 +481,16 @@ static int ip_frag_reasm(struct ipq *qp, struct sk_buff *skb,
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
+	rcu_read_lock();
+	dev = skb->dev ? : skb_dst_dev_rcu(skb);
+	vif = l3mdev_master_ifindex_rcu(dev);
 	qp = ip_find(net, ip_hdr(skb), user, vif);
 	if (qp) {
 		int ret;
@@ -497,9 +500,11 @@ int ip_defrag(struct net *net, struct sk_buff *skb, u32 user)
 		ret = ip_frag_queue(qp, skb);
 
 		spin_unlock(&qp->q.lock);
+		rcu_read_unlock();
 		ipq_put(qp);
 		return ret;
 	}
+	rcu_read_unlock();
 
 	__IP_INC_STATS(net, IPSTATS_MIB_REASMFAILS);
 	kfree_skb(skb);
diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index f64651c0dea6c..8d4f556fced2c 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -1879,7 +1879,7 @@ static void ipmr_queue_xmit(struct net *net, struct mr_table *mrt,
 			goto out_free;
 	}
 
-	dev = rt->dst.dev;
+	dev = dst_dev_rcu(&rt->dst);
 
 	if (skb->len+encap > dst_mtu(&rt->dst) && (ntohs(iph->frag_off) & IP_DF)) {
 		/* Do not fragment multicasts. Alas, IPv4 does not
diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index e3cce307e0e9c..5528a5543df51 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -416,11 +416,11 @@ static struct neighbour *ipv4_neigh_lookup(const struct dst_entry *dst,
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
2.53.0



