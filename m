Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C98051E43A;
	Wed, 30 Sep 2026 18:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793049; cv=none; b=kJWvSVxDAs5nLtrZE3asuHWH85eFHW1Xu5/UqWTupp9YNSo/KOFNKizy4teHkibcWb53RNfk+1U8qCO+8UvtAsl/AYXheohi1Xin2BwWn2jcSaqXeDGDjkkMuFRn6HenSh+fUY8BY+F4S95ZVPuW3hjltwrg982cafEP9MJoSSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793049; c=relaxed/simple;
	bh=/SfRlwhJ+iZOBAuOavTPGiJEJjjD/1XpOXfPPx4UFuY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TBDyXZn/me3pshxjtmAkLCStA6sNClsGbqi3CGN2GA8nqz+E678BOP/UFjvDTE5sgOsl2ACyUX5/uCOS37S4J4TcL1/xMTws3XWkFvu4f2cMueXH5xR6YraC78jUR4d/OjLoGFdQs/I7nqXDCnLL6iPEp52feb+EhBQd6h5EZp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PiSoopDF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PiSoopDF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AE071F0089C;
	Wed, 30 Sep 2026 18:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793047;
	bh=B9JhzsD6IExvnJIf2KS3+M8Nb0bFOOjnZMx9jJDttoE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PiSoopDFK0OqVXYB48szfDVu0h7CbJrumWYDAuKa2asqgE8zDLQ4KqPGFzEIJUYWf
	 bVr9KdA8AlBeIDGrW1kRWTlvvKkmxPRVfKMMgO+gOr9uvoTY7zQkM1x1NhGW3wrpDR
	 4qrkEhFOLnqAfhxWbfs2UNYc+lgsBPCYQcsyb4rw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Hangbin Liu <liuhangbin@kylinos.cn>,
	Xuanqiang Luo <luoxuanqiang@kylinos.cn>,
	Ido Schimmel <idosch@nvidia.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 115/395] ipv6: Fix dst leak for uncached routes.
Date: Wed, 30 Sep 2026 17:26:17 +0200
Message-ID: <20260930152343.137726761@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit be31fe6333f534155e6b408f1ef6d77974bb41aa ]

ip6_route_output_flags(), ip6_rt_put_flags(), and ip6_dst_check()
detect an uncached route by list_empty(&rt->dst.rt_uncached),
which replaced the static DST_NOCACHE flag check in commit
a4c2fd7f7891 ("net: remove DST_NOCACHE flag").

When a device is unregistered, rt6_uncached_list_flush_dev()
unlinks uncached routes tied to the device from rt6_uncached_list.

Previously, they were moved to another list with list_move()
(__list_del_entry() + list_add()), and since commit 98aa546af5e4
("inet: remove (struct uncached_list)->quarantine"), the routes
are just unlinked with list_del_init().

If list_del_init() runs concurrently, list_empty() evaluates to
true; ip6_route_output_flags() calls dst_hold_safe() incorrectly
and ip6_rt_put_flags() skips ip6_rt_put(), leaking dst, and thus
dev tied via rt->from as well.

The same race is partially fixed by commit 9a6f0c4d5796 ("dst:
fix races in rt6_uncached_list_del() and rt_del_uncached_list()").

Let's check rt6->dst.rt_uncached_list instead.

Note that IPv4 does not have the same issue.

Fixes: 98aa546af5e4 ("inet: remove (struct uncached_list)->quarantine")
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Hangbin Liu <liuhangbin@kylinos.cn>
Reviewed-by: Xuanqiang Luo <luoxuanqiang@kylinos.cn>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260920191558.2990636-1-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/ip6_route.h | 4 ++--
 net/ipv6/route.c        | 7 ++++---
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/include/net/ip6_route.h b/include/net/ip6_route.h
index 2e8ca123d1465..4137bdf05baae 100644
--- a/include/net/ip6_route.h
+++ b/include/net/ip6_route.h
@@ -94,12 +94,12 @@ static inline struct dst_entry *ip6_route_output(struct net *net,
 }
 
 /* Only conditionally release dst if flags indicates
- * !RT6_LOOKUP_F_DST_NOREF or dst is in uncached_list.
+ * !RT6_LOOKUP_F_DST_NOREF or dst is uncached.
  */
 static inline void ip6_rt_put_flags(struct rt6_info *rt, int flags)
 {
 	if (!(flags & RT6_LOOKUP_F_DST_NOREF) ||
-	    !list_empty(&rt->dst.rt_uncached))
+	    rt->dst.rt_uncached_list)
 		ip6_rt_put(rt);
 }
 
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index c71e93e17017e..e99b4901091a2 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -139,6 +139,7 @@ void rt6_uncached_list_add(struct rt6_info *rt)
 {
 	struct uncached_list *ul = raw_cpu_ptr(&rt6_uncached_list);
 
+	/* Set once and never cleared: non-NULL marks an uncached route. */
 	rt->dst.rt_uncached_list = ul;
 
 	spin_lock_bh(&ul->lock);
@@ -2721,8 +2722,8 @@ struct dst_entry *ip6_route_output_flags(struct net *net,
 	rcu_read_lock();
 	dst = ip6_route_output_flags_noref(net, sk, fl6, flags);
 	rt6 = dst_rt6_info(dst);
-	/* For dst cached in uncached_list, refcnt is already taken. */
-	if (list_empty(&rt6->dst.rt_uncached) && !dst_hold_safe(dst)) {
+	/* For an uncached dst, refcnt is already taken. */
+	if (!rt6->dst.rt_uncached_list && !dst_hold_safe(dst)) {
 		dst = &net->ipv6.ip6_null_entry->dst;
 		dst_hold(dst);
 	}
@@ -2831,7 +2832,7 @@ INDIRECT_CALLABLE_SCOPE struct dst_entry *ip6_dst_check(struct dst_entry *dst,
 	from = rcu_dereference(rt->from);
 
 	if (from && (rt->rt6i_flags & RTF_PCPU ||
-	    unlikely(!list_empty(&rt->dst.rt_uncached))))
+	    unlikely(rt->dst.rt_uncached_list)))
 		dst_ret = rt6_dst_from_check(rt, from, cookie);
 	else
 		dst_ret = rt6_check(rt, from, cookie);
-- 
2.53.0



