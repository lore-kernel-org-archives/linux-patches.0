Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E446817BEB6;
	Wed,  5 Feb 2025 14:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765396; cv=none; b=mDdG/dngLgoPI6mfqWrj7slfVZCZFHhSxue66+vZgs49HLtXihZd3DRubDgYzCkm1ZfUH98q3R41GYJom9xhJF9wPaB0z2SsKYK+ekmyuky59i8FxQ92EIIKSA5GSqg7n5pVv2DsPQe2rNFtey8MQBEhiuUb7BTFms5sq5A/SOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765396; c=relaxed/simple;
	bh=KUPXavbNxj/qTzU/ucKc07d4uP/6Vg4LrOfLYUnJQqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=REypwHCS2vAWl2CtuXLsFUPmUd7tQgi5fFYv+3AMBqzsvX+r6In6vZ8kVwX+dVeSsnJBng+bLBBcRmOO+B6qxarEFTj2HeNsX2jXSotjVh7f3b42/VVWz1uVAmDdSqJCGYbQ9ou3GhgYxhCLdLC2kxjkev6GwH7i3PZD3h4A9f8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cQWIv0VM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cQWIv0VM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9885C4CED1;
	Wed,  5 Feb 2025 14:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765394;
	bh=KUPXavbNxj/qTzU/ucKc07d4uP/6Vg4LrOfLYUnJQqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cQWIv0VMAiZjKC0UD+dnKEwea+B5zdtjYbYZQcNaej2XrJHHtpKjdVdZ2R98bPmuz
	 ayMsDBxOMw5iBDFJBcwKt+KEJWNbXVLU8eEmK+dXijeu8L9UVBWLl5qCtT5rTLkzyi
	 nUFqIMEF46u0K5ZZPrX7/nPlcwCJDEez0qOQfymo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 216/590] inet: ipmr: fix data-races
Date: Wed,  5 Feb 2025 14:39:31 +0100
Message-ID: <20250205134503.551087655@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

[ Upstream commit 3440fa34ad99d471f1085bc2f4dedeaebc310261 ]

Following fields of 'struct mr_mfc' can be updated
concurrently (no lock protection) from ip_mr_forward()
and ip6_mr_forward()

- bytes
- pkt
- wrong_if
- lastuse

They also can be read from other functions.

Convert bytes, pkt and wrong_if to atomic_long_t,
and use READ_ONCE()/WRITE_ONCE() for lastuse.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://patch.msgid.link/20250114221049.1190631-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlxsw/spectrum_mr.c |  8 +++---
 include/linux/mroute_base.h                   |  6 ++--
 net/ipv4/ipmr.c                               | 28 +++++++++----------
 net/ipv4/ipmr_base.c                          |  6 ++--
 net/ipv6/ip6mr.c                              | 28 +++++++++----------
 5 files changed, 38 insertions(+), 38 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_mr.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_mr.c
index 69cd689dbc83e..5afe6b155ef0d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_mr.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_mr.c
@@ -1003,10 +1003,10 @@ static void mlxsw_sp_mr_route_stats_update(struct mlxsw_sp *mlxsw_sp,
 	mr->mr_ops->route_stats(mlxsw_sp, mr_route->route_priv, &packets,
 				&bytes);
 
-	if (mr_route->mfc->mfc_un.res.pkt != packets)
-		mr_route->mfc->mfc_un.res.lastuse = jiffies;
-	mr_route->mfc->mfc_un.res.pkt = packets;
-	mr_route->mfc->mfc_un.res.bytes = bytes;
+	if (atomic_long_read(&mr_route->mfc->mfc_un.res.pkt) != packets)
+		WRITE_ONCE(mr_route->mfc->mfc_un.res.lastuse, jiffies);
+	atomic_long_set(&mr_route->mfc->mfc_un.res.pkt, packets);
+	atomic_long_set(&mr_route->mfc->mfc_un.res.bytes, bytes);
 }
 
 static void mlxsw_sp_mr_stats_update(struct work_struct *work)
diff --git a/include/linux/mroute_base.h b/include/linux/mroute_base.h
index 9dd4bf1572553..58a2401e4b551 100644
--- a/include/linux/mroute_base.h
+++ b/include/linux/mroute_base.h
@@ -146,9 +146,9 @@ struct mr_mfc {
 			unsigned long last_assert;
 			int minvif;
 			int maxvif;
-			unsigned long bytes;
-			unsigned long pkt;
-			unsigned long wrong_if;
+			atomic_long_t bytes;
+			atomic_long_t pkt;
+			atomic_long_t wrong_if;
 			unsigned long lastuse;
 			unsigned char ttls[MAXVIFS];
 			refcount_t refcount;
diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index 449a2ac40bdc0..de0d9cc7806a1 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -817,7 +817,7 @@ static void ipmr_update_thresholds(struct mr_table *mrt, struct mr_mfc *cache,
 				cache->mfc_un.res.maxvif = vifi + 1;
 		}
 	}
-	cache->mfc_un.res.lastuse = jiffies;
+	WRITE_ONCE(cache->mfc_un.res.lastuse, jiffies);
 }
 
 static int vif_add(struct net *net, struct mr_table *mrt,
@@ -1667,9 +1667,9 @@ int ipmr_ioctl(struct sock *sk, int cmd, void *arg)
 		rcu_read_lock();
 		c = ipmr_cache_find(mrt, sr->src.s_addr, sr->grp.s_addr);
 		if (c) {
-			sr->pktcnt = c->_c.mfc_un.res.pkt;
-			sr->bytecnt = c->_c.mfc_un.res.bytes;
-			sr->wrong_if = c->_c.mfc_un.res.wrong_if;
+			sr->pktcnt = atomic_long_read(&c->_c.mfc_un.res.pkt);
+			sr->bytecnt = atomic_long_read(&c->_c.mfc_un.res.bytes);
+			sr->wrong_if = atomic_long_read(&c->_c.mfc_un.res.wrong_if);
 			rcu_read_unlock();
 			return 0;
 		}
@@ -1739,9 +1739,9 @@ int ipmr_compat_ioctl(struct sock *sk, unsigned int cmd, void __user *arg)
 		rcu_read_lock();
 		c = ipmr_cache_find(mrt, sr.src.s_addr, sr.grp.s_addr);
 		if (c) {
-			sr.pktcnt = c->_c.mfc_un.res.pkt;
-			sr.bytecnt = c->_c.mfc_un.res.bytes;
-			sr.wrong_if = c->_c.mfc_un.res.wrong_if;
+			sr.pktcnt = atomic_long_read(&c->_c.mfc_un.res.pkt);
+			sr.bytecnt = atomic_long_read(&c->_c.mfc_un.res.bytes);
+			sr.wrong_if = atomic_long_read(&c->_c.mfc_un.res.wrong_if);
 			rcu_read_unlock();
 
 			if (copy_to_user(arg, &sr, sizeof(sr)))
@@ -1974,9 +1974,9 @@ static void ip_mr_forward(struct net *net, struct mr_table *mrt,
 	int vif, ct;
 
 	vif = c->_c.mfc_parent;
-	c->_c.mfc_un.res.pkt++;
-	c->_c.mfc_un.res.bytes += skb->len;
-	c->_c.mfc_un.res.lastuse = jiffies;
+	atomic_long_inc(&c->_c.mfc_un.res.pkt);
+	atomic_long_add(skb->len, &c->_c.mfc_un.res.bytes);
+	WRITE_ONCE(c->_c.mfc_un.res.lastuse, jiffies);
 
 	if (c->mfc_origin == htonl(INADDR_ANY) && true_vifi >= 0) {
 		struct mfc_cache *cache_proxy;
@@ -2007,7 +2007,7 @@ static void ip_mr_forward(struct net *net, struct mr_table *mrt,
 			goto dont_forward;
 		}
 
-		c->_c.mfc_un.res.wrong_if++;
+		atomic_long_inc(&c->_c.mfc_un.res.wrong_if);
 
 		if (true_vifi >= 0 && mrt->mroute_do_assert &&
 		    /* pimsm uses asserts, when switching from RPT to SPT,
@@ -3015,9 +3015,9 @@ static int ipmr_mfc_seq_show(struct seq_file *seq, void *v)
 
 		if (it->cache != &mrt->mfc_unres_queue) {
 			seq_printf(seq, " %8lu %8lu %8lu",
-				   mfc->_c.mfc_un.res.pkt,
-				   mfc->_c.mfc_un.res.bytes,
-				   mfc->_c.mfc_un.res.wrong_if);
+				   atomic_long_read(&mfc->_c.mfc_un.res.pkt),
+				   atomic_long_read(&mfc->_c.mfc_un.res.bytes),
+				   atomic_long_read(&mfc->_c.mfc_un.res.wrong_if));
 			for (n = mfc->_c.mfc_un.res.minvif;
 			     n < mfc->_c.mfc_un.res.maxvif; n++) {
 				if (VIF_EXISTS(mrt, n) &&
diff --git a/net/ipv4/ipmr_base.c b/net/ipv4/ipmr_base.c
index f0af12a2f70bc..03b6eee407a24 100644
--- a/net/ipv4/ipmr_base.c
+++ b/net/ipv4/ipmr_base.c
@@ -263,9 +263,9 @@ int mr_fill_mroute(struct mr_table *mrt, struct sk_buff *skb,
 	lastuse = READ_ONCE(c->mfc_un.res.lastuse);
 	lastuse = time_after_eq(jiffies, lastuse) ? jiffies - lastuse : 0;
 
-	mfcs.mfcs_packets = c->mfc_un.res.pkt;
-	mfcs.mfcs_bytes = c->mfc_un.res.bytes;
-	mfcs.mfcs_wrong_if = c->mfc_un.res.wrong_if;
+	mfcs.mfcs_packets = atomic_long_read(&c->mfc_un.res.pkt);
+	mfcs.mfcs_bytes = atomic_long_read(&c->mfc_un.res.bytes);
+	mfcs.mfcs_wrong_if = atomic_long_read(&c->mfc_un.res.wrong_if);
 	if (nla_put_64bit(skb, RTA_MFC_STATS, sizeof(mfcs), &mfcs, RTA_PAD) ||
 	    nla_put_u64_64bit(skb, RTA_EXPIRES, jiffies_to_clock_t(lastuse),
 			      RTA_PAD))
diff --git a/net/ipv6/ip6mr.c b/net/ipv6/ip6mr.c
index d5057401701c1..440048d609c37 100644
--- a/net/ipv6/ip6mr.c
+++ b/net/ipv6/ip6mr.c
@@ -506,9 +506,9 @@ static int ipmr_mfc_seq_show(struct seq_file *seq, void *v)
 
 		if (it->cache != &mrt->mfc_unres_queue) {
 			seq_printf(seq, " %8lu %8lu %8lu",
-				   mfc->_c.mfc_un.res.pkt,
-				   mfc->_c.mfc_un.res.bytes,
-				   mfc->_c.mfc_un.res.wrong_if);
+				   atomic_long_read(&mfc->_c.mfc_un.res.pkt),
+				   atomic_long_read(&mfc->_c.mfc_un.res.bytes),
+				   atomic_long_read(&mfc->_c.mfc_un.res.wrong_if));
 			for (n = mfc->_c.mfc_un.res.minvif;
 			     n < mfc->_c.mfc_un.res.maxvif; n++) {
 				if (VIF_EXISTS(mrt, n) &&
@@ -870,7 +870,7 @@ static void ip6mr_update_thresholds(struct mr_table *mrt,
 				cache->mfc_un.res.maxvif = vifi + 1;
 		}
 	}
-	cache->mfc_un.res.lastuse = jiffies;
+	WRITE_ONCE(cache->mfc_un.res.lastuse, jiffies);
 }
 
 static int mif6_add(struct net *net, struct mr_table *mrt,
@@ -1928,9 +1928,9 @@ int ip6mr_ioctl(struct sock *sk, int cmd, void *arg)
 		c = ip6mr_cache_find(mrt, &sr->src.sin6_addr,
 				     &sr->grp.sin6_addr);
 		if (c) {
-			sr->pktcnt = c->_c.mfc_un.res.pkt;
-			sr->bytecnt = c->_c.mfc_un.res.bytes;
-			sr->wrong_if = c->_c.mfc_un.res.wrong_if;
+			sr->pktcnt = atomic_long_read(&c->_c.mfc_un.res.pkt);
+			sr->bytecnt = atomic_long_read(&c->_c.mfc_un.res.bytes);
+			sr->wrong_if = atomic_long_read(&c->_c.mfc_un.res.wrong_if);
 			rcu_read_unlock();
 			return 0;
 		}
@@ -2000,9 +2000,9 @@ int ip6mr_compat_ioctl(struct sock *sk, unsigned int cmd, void __user *arg)
 		rcu_read_lock();
 		c = ip6mr_cache_find(mrt, &sr.src.sin6_addr, &sr.grp.sin6_addr);
 		if (c) {
-			sr.pktcnt = c->_c.mfc_un.res.pkt;
-			sr.bytecnt = c->_c.mfc_un.res.bytes;
-			sr.wrong_if = c->_c.mfc_un.res.wrong_if;
+			sr.pktcnt = atomic_long_read(&c->_c.mfc_un.res.pkt);
+			sr.bytecnt = atomic_long_read(&c->_c.mfc_un.res.bytes);
+			sr.wrong_if = atomic_long_read(&c->_c.mfc_un.res.wrong_if);
 			rcu_read_unlock();
 
 			if (copy_to_user(arg, &sr, sizeof(sr)))
@@ -2125,9 +2125,9 @@ static void ip6_mr_forward(struct net *net, struct mr_table *mrt,
 	int true_vifi = ip6mr_find_vif(mrt, dev);
 
 	vif = c->_c.mfc_parent;
-	c->_c.mfc_un.res.pkt++;
-	c->_c.mfc_un.res.bytes += skb->len;
-	c->_c.mfc_un.res.lastuse = jiffies;
+	atomic_long_inc(&c->_c.mfc_un.res.pkt);
+	atomic_long_add(skb->len, &c->_c.mfc_un.res.bytes);
+	WRITE_ONCE(c->_c.mfc_un.res.lastuse, jiffies);
 
 	if (ipv6_addr_any(&c->mf6c_origin) && true_vifi >= 0) {
 		struct mfc6_cache *cache_proxy;
@@ -2145,7 +2145,7 @@ static void ip6_mr_forward(struct net *net, struct mr_table *mrt,
 	 * Wrong interface: drop packet and (maybe) send PIM assert.
 	 */
 	if (rcu_access_pointer(mrt->vif_table[vif].dev) != dev) {
-		c->_c.mfc_un.res.wrong_if++;
+		atomic_long_inc(&c->_c.mfc_un.res.wrong_if);
 
 		if (true_vifi >= 0 && mrt->mroute_do_assert &&
 		    /* pimsm uses asserts, when switching from RPT to SPT,
-- 
2.39.5



