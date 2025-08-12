Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83A462F5E;
	Tue, 12 Aug 2025 18:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022411; cv=none; b=U/jhziwLdRu6Cwp2azhMOsSUKBjnilfXPaWUtgvo6oRZNF7dGDzAQKwPzYpVrCv217RhV0pTK3hUf/Ulw4oT2OlXYd2lug09BuKhDjtHKL9n9b+7NyWGT1ewarz+e36Dk+qmFPvQQ4igD0mvR8eDl2L5QqvI1GRSW9kNMTzQX6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022411; c=relaxed/simple;
	bh=tPREHKfGwQQ6CFotQSXFbPNxCisSQT2SCoh6E/YSoCo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LiUwRL+udmgDgrkEuh6yCwZdBDzh3NvfyQ6A+s4arxL7ldJ+Ant6ZutapQcA9nOJAQgLhV1vF7maoV+4AzmoM/V1ct3hh1GY4VDMYQmuXvjnV0yXRV5oH6fdhr/w4PbOkQ7J0msVby1byoin2XGPLMCdPf4ZRp1LgmIxZbA9eY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BT5WQEiv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BT5WQEiv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEF9AC4CEF1;
	Tue, 12 Aug 2025 18:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022411;
	bh=tPREHKfGwQQ6CFotQSXFbPNxCisSQT2SCoh6E/YSoCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BT5WQEiv4SgOspBXzpeT4jqJHLwR2z8yciNpEvW6ImS06sGnxAlEkcQ7vQ1mN+KeY
	 ukBN0l8cV35NOIjt7+cdQY7D3AxDUaFzqLCkAzIQKHFEJc2FrV7lNOl67YHDg/J54f
	 NXu4xcVBJ3jkEa9o38vCbO72puWuUGINLKQx/Yx8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 148/369] ipv6: annotate data-races around rt->fib6_nsiblings
Date: Tue, 12 Aug 2025 19:27:25 +0200
Message-ID: <20250812173020.350712644@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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
index c53303e89390..aa1046fbf28e 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -440,15 +440,17 @@ struct fib6_dump_arg {
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
@@ -1126,7 +1128,7 @@ static int fib6_add_rt2node(struct fib6_node *fn, struct fib6_info *rt,
 
 			if (rt6_duplicate_nexthop(iter, rt)) {
 				if (rt->fib6_nsiblings)
-					rt->fib6_nsiblings = 0;
+					WRITE_ONCE(rt->fib6_nsiblings, 0);
 				if (!(iter->fib6_flags & RTF_EXPIRES))
 					return -EEXIST;
 				if (!(rt->fib6_flags & RTF_EXPIRES)) {
@@ -1155,7 +1157,8 @@ static int fib6_add_rt2node(struct fib6_node *fn, struct fib6_info *rt,
 			 */
 			if (rt_can_ecmp &&
 			    rt6_qualify_for_ecmp(iter))
-				rt->fib6_nsiblings++;
+				WRITE_ONCE(rt->fib6_nsiblings,
+					   rt->fib6_nsiblings + 1);
 		}
 
 		if (iter->fib6_metric > rt->fib6_metric)
@@ -1205,7 +1208,8 @@ static int fib6_add_rt2node(struct fib6_node *fn, struct fib6_info *rt,
 		fib6_nsiblings = 0;
 		list_for_each_entry_safe(sibling, temp_sibling,
 					 &rt->fib6_siblings, fib6_siblings) {
-			sibling->fib6_nsiblings++;
+			WRITE_ONCE(sibling->fib6_nsiblings,
+				   sibling->fib6_nsiblings + 1);
 			BUG_ON(sibling->fib6_nsiblings != rt->fib6_nsiblings);
 			fib6_nsiblings++;
 		}
@@ -1250,7 +1254,8 @@ static int fib6_add_rt2node(struct fib6_node *fn, struct fib6_info *rt,
 				list_for_each_entry_safe(sibling, next_sibling,
 							 &rt->fib6_siblings,
 							 fib6_siblings)
-					sibling->fib6_nsiblings--;
+					WRITE_ONCE(sibling->fib6_nsiblings,
+						   sibling->fib6_nsiblings - 1);
 				WRITE_ONCE(rt->fib6_nsiblings, 0);
 				list_del_rcu(&rt->fib6_siblings);
 				rt6_multipath_rebalance(next_sibling);
@@ -1968,7 +1973,8 @@ static void fib6_del_route(struct fib6_table *table, struct fib6_node *fn,
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
index 8b84ed926cd1..22866444efc0 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -5240,7 +5240,8 @@ static void ip6_route_mpath_notify(struct fib6_info *rt,
 	 */
 	rcu_read_lock();
 
-	if ((nlflags & NLM_F_APPEND) && rt_last && rt_last->fib6_nsiblings) {
+	if ((nlflags & NLM_F_APPEND) && rt_last &&
+	    READ_ONCE(rt_last->fib6_nsiblings)) {
 		rt = list_first_or_null_rcu(&rt_last->fib6_siblings,
 					    struct fib6_info,
 					    fib6_siblings);
@@ -5773,7 +5774,7 @@ static int rt6_fill_node(struct net *net, struct sk_buff *skb,
 		if (dst->lwtstate &&
 		    lwtunnel_fill_encap(skb, dst->lwtstate, RTA_ENCAP, RTA_ENCAP_TYPE) < 0)
 			goto nla_put_failure;
-	} else if (rt->fib6_nsiblings) {
+	} else if (READ_ONCE(rt->fib6_nsiblings)) {
 		struct fib6_info *sibling;
 		struct nlattr *mp;
 
-- 
2.39.5



