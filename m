Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FEF051597D;
	Wed, 30 Sep 2026 16:52:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787173; cv=none; b=YI5js3qFYdLBDofhrBC3bqUvkU01XWf7gKuJAvA6Ep+6Ab69nJDsJvp5dbnR12Vz89aDqg5obzNYyMF2Cf21yMjSM3r4YlwAXV4NLemrmCnJRTNrCRaG9MEQ3EnNugn/wCx6Nrolumnb+JFwD68iqy5n4DvH2m4hJkDFgaqORyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787173; c=relaxed/simple;
	bh=hjEVaExrotJOpazsJTFE/R3brt4v3gGn4JkVr0QjKFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fGGWxtN5SxLgQBM75aSJBz3C2zM8mqd2G4ZpsyYJhAK4P8c4MLMSodpjHlUZgZlR09cSTsS5jDbYPNWajj/iQcNmsJw5+1mgc1uYjw+pIbWageXs6m2HDC5Pyxu8yDmL/DabUxSY+i3mV6Xbc6VgjXTVHH5mOdqaHMsv4RE3O8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wo3LsGRm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wo3LsGRm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3894E1F000FF;
	Wed, 30 Sep 2026 16:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787171;
	bh=ssRQZ5XkmhtJl7WYRBzNUMc+DZS6pTu9co8HKkPJ+dU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wo3LsGRmkHeRZrOzNmFy1B4Fefuf+JcGNvYrMZacy8Wfj4d++iMnSvWNUMd0yhkr9
	 ltySjWh8C5AjgSs5HRIs/YP0HUYIVbEau1U00fVoMO+4kiSLqmIJ3Y51ETcHsbXuMD
	 pGu7CtPfOXOhdNA3zuN+uDQZUAgLl5OZyt0qOAA8=
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
Subject: [PATCH 7.2 136/457] ipv6: Fix dst leak for uncached routes.
Date: Wed, 30 Sep 2026 17:24:01 +0200
Message-ID: <20260930152348.983004292@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 745ab62154ace..0a6c4ceb95a7a 100644
--- a/include/net/ip6_route.h
+++ b/include/net/ip6_route.h
@@ -101,12 +101,12 @@ static inline struct dst_entry *ip6_route_output(struct net *net,
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
index c94ad52d03f24..8fddcc631fcb6 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -139,6 +139,7 @@ void rt6_uncached_list_add(struct rt6_info *rt)
 {
 	struct uncached_list *ul = raw_cpu_ptr(&rt6_uncached_list);
 
+	/* Set once and never cleared: non-NULL marks an uncached route. */
 	rt->dst.rt_uncached_list = ul;
 
 	spin_lock_bh(&ul->lock);
@@ -2726,8 +2727,8 @@ struct dst_entry *ip6_route_output_flags(struct net *net,
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
@@ -2836,7 +2837,7 @@ INDIRECT_CALLABLE_SCOPE struct dst_entry *ip6_dst_check(struct dst_entry *dst,
 	from = rcu_dereference(rt->from);
 
 	if (from && (rt->rt6i_flags & RTF_PCPU ||
-	    unlikely(!list_empty(&rt->dst.rt_uncached))))
+	    unlikely(rt->dst.rt_uncached_list)))
 		dst_ret = rt6_dst_from_check(rt, from, cookie);
 	else
 		dst_ret = rt6_check(rt, from, cookie);
-- 
2.53.0



