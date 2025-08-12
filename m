Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D23322F4A0A;
	Tue, 12 Aug 2025 18:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024148; cv=none; b=doEpd3TYQmDNYyRL7g9jRsetL9bGluxlhKIoTGafyu5ivWTUZgGvZlCXJhDTo55+BLJoF1hdGOhnJVzKsiYwBYTvjPRZFxHh64HcDenYokwLX33Q25z5kDuxTVJ2u/hhxZz+fVIkB9rQb1Z6hwcLZSH0zSYvzsfc7bTs5ydE+Eg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024148; c=relaxed/simple;
	bh=dbemQandyH1TmwLzr8ZiaHkgZasQw1S3AgwRg2FTkbE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M484B+9RfnrjVF+toaNy34b4Aqmn85LRVv/USS/G9h2lbr9O+9KVo+BF+g6kDC7FvtmcnhPEBdq9QucD3kmjbAYf/G+zoaCGu0L5CImyT6TCKpLODfGAtXzt6UpSFMISuYn6U/LKIPjn5O9kZk+pUTr5RK6s1ghbwVG5igjCUP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uXawPeOI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uXawPeOI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 409D9C4CEF0;
	Tue, 12 Aug 2025 18:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024148;
	bh=dbemQandyH1TmwLzr8ZiaHkgZasQw1S3AgwRg2FTkbE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uXawPeOIJUywtRIQ+WP6rP9PYkCXWrzQa7+xetz+QinG4MoNrCUvULU7cnDWP5ubv
	 ohcj69wsp748VQaQ3HoD6J5y3N6xPV45mB1C8cCDbfKMLZaSdswJlilgHl1Ehet8CP
	 W8/Gh3voiC1By6JdqnZxNrHcVuC/uD1j6QAXw+04=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 289/627] ipv6: annotate data-races around rt->fib6_nsiblings
Date: Tue, 12 Aug 2025 19:29:44 +0200
Message-ID: <20250812173430.309270017@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 31d7d67ba1274f42494256d52e86da80ed09f3cb ]

rt->fib6_nsiblings can be read locklessly, add corresponding
READ_ONCE() and WRITE_ONCE() annotations.

Fixes: 66f5d6ce53e6 ("ipv6: replace rwlock with rcu and spinlock in fib6_table")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20250725140725.3626540-5-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ip6_fib.c | 20 +++++++++++++-------
 net/ipv6/route.c   |  5 +++--
 2 files changed, 16 insertions(+), 9 deletions(-)

diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index af7db69d9eac..4d68bd853dba 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -445,15 +445,17 @@ struct fib6_dump_arg {
 static int fib6_rt_dump(struct fib6_info *rt, struct fib6_dump_arg *arg)
 {
 	enum fib_event_type fib_event = FIB_EVENT_ENTRY_REPLACE;
+	unsigned int nsiblings;
 	int err;
 
 	if (!rt || rt == arg->net->ipv6.fib6_null_entry)
 		return 0;
 
-	if (rt->fib6_nsiblings)
+	nsiblings = READ_ONCE(rt->fib6_nsiblings);
+	if (nsiblings)
 		err = call_fib6_multipath_entry_notifier(arg->nb, fib_event,
 							 rt,
-							 rt->fib6_nsiblings,
+							 nsiblings,
 							 arg->extack);
 	else
 		err = call_fib6_entry_notifier(arg->nb, fib_event, rt,
@@ -1138,7 +1140,7 @@ static int fib6_add_rt2node(struct fib6_node *fn, struct fib6_info *rt,
 
 			if (rt6_duplicate_nexthop(iter, rt)) {
 				if (rt->fib6_nsiblings)
-					rt->fib6_nsiblings = 0;
+					WRITE_ONCE(rt->fib6_nsiblings, 0);
 				if (!(iter->fib6_flags & RTF_EXPIRES))
 					return -EEXIST;
 				if (!(rt->fib6_flags & RTF_EXPIRES)) {
@@ -1167,7 +1169,8 @@ static int fib6_add_rt2node(struct fib6_node *fn, struct fib6_info *rt,
 			 */
 			if (rt_can_ecmp &&
 			    rt6_qualify_for_ecmp(iter))
-				rt->fib6_nsiblings++;
+				WRITE_ONCE(rt->fib6_nsiblings,
+					   rt->fib6_nsiblings + 1);
 		}
 
 		if (iter->fib6_metric > rt->fib6_metric)
@@ -1217,7 +1220,8 @@ static int fib6_add_rt2node(struct fib6_node *fn, struct fib6_info *rt,
 		fib6_nsiblings = 0;
 		list_for_each_entry_safe(sibling, temp_sibling,
 					 &rt->fib6_siblings, fib6_siblings) {
-			sibling->fib6_nsiblings++;
+			WRITE_ONCE(sibling->fib6_nsiblings,
+				   sibling->fib6_nsiblings + 1);
 			BUG_ON(sibling->fib6_nsiblings != rt->fib6_nsiblings);
 			fib6_nsiblings++;
 		}
@@ -1264,7 +1268,8 @@ static int fib6_add_rt2node(struct fib6_node *fn, struct fib6_info *rt,
 				list_for_each_entry_safe(sibling, next_sibling,
 							 &rt->fib6_siblings,
 							 fib6_siblings)
-					sibling->fib6_nsiblings--;
+					WRITE_ONCE(sibling->fib6_nsiblings,
+						   sibling->fib6_nsiblings - 1);
 				WRITE_ONCE(rt->fib6_nsiblings, 0);
 				list_del_rcu(&rt->fib6_siblings);
 				rcu_read_lock();
@@ -2014,7 +2019,8 @@ static void fib6_del_route(struct fib6_table *table, struct fib6_node *fn,
 			notify_del = true;
 		list_for_each_entry_safe(sibling, next_sibling,
 					 &rt->fib6_siblings, fib6_siblings)
-			sibling->fib6_nsiblings--;
+			WRITE_ONCE(sibling->fib6_nsiblings,
+				   sibling->fib6_nsiblings - 1);
 		WRITE_ONCE(rt->fib6_nsiblings, 0);
 		list_del_rcu(&rt->fib6_siblings);
 		rt6_multipath_rebalance(next_sibling);
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index bf71c8ce002f..8adae86fbe72 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -5346,7 +5346,8 @@ static void ip6_route_mpath_notify(struct fib6_info *rt,
 	 */
 	rcu_read_lock();
 
-	if ((nlflags & NLM_F_APPEND) && rt_last && rt_last->fib6_nsiblings) {
+	if ((nlflags & NLM_F_APPEND) && rt_last &&
+	    READ_ONCE(rt_last->fib6_nsiblings)) {
 		rt = list_first_or_null_rcu(&rt_last->fib6_siblings,
 					    struct fib6_info,
 					    fib6_siblings);
@@ -5856,7 +5857,7 @@ static int rt6_fill_node(struct net *net, struct sk_buff *skb,
 		if (dst->lwtstate &&
 		    lwtunnel_fill_encap(skb, dst->lwtstate, RTA_ENCAP, RTA_ENCAP_TYPE) < 0)
 			goto nla_put_failure;
-	} else if (rt->fib6_nsiblings) {
+	} else if (READ_ONCE(rt->fib6_nsiblings)) {
 		struct fib6_info *sibling;
 		struct nlattr *mp;
 
-- 
2.39.5



