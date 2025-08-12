Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39E3426FA77;
	Tue, 12 Aug 2025 19:13:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026035; cv=none; b=ru3AHauNeGGfJdmBreO/qtm1EdtYFJWVqIkCCSLLJSHxzSE+Q9cRz2kqTdSNkJBwVyIlWjAjAkrnAC45dNF02Ht5FvgmmCKnZAhWaR+aOqR+hjFarUE8EEX1NeHqqsx2SB/ckJlhECXLYjUPMBfPD3W4b6F1pJcpb5PspL7t4WE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026035; c=relaxed/simple;
	bh=eaGU4s6G0liIgnZIklJyBeux1271HBLRrxcVjbn9/sw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZHnyKtTnSAIXkCSNIN4l891bdbUNXMbDYDC+H/A82sCrAA+dEifoUR4Zp4jbpjHx03/Q/pbraefRZAe7uI5M+E42KODiEBMd4wMT/h8wRjmoWCjSXJUa8YiH2llhpSwYTJS1bQvFi/MJX04RKiUUQ7GzAH/cthw81clYwVSDe3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0/zL9hgz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0/zL9hgz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9353CC4CEF0;
	Tue, 12 Aug 2025 19:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026035;
	bh=eaGU4s6G0liIgnZIklJyBeux1271HBLRrxcVjbn9/sw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0/zL9hgz9Cw8aAneRANcD9rS3Ocgtg/DgB+0dLIUpOdMiJBuhy4PdhzzVCQE1uAf1
	 3QW+8GqkdYMmHSBY4/06r1KiZZVxC61vqUWPGsHzTo2sdURHozeMIS2jGq+gjAfi9Y
	 wvE7nHf7tSZ2MVZ3tM8fB6sxoNHf46Cis5iiI6OM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 216/480] ipv6: annotate data-races around rt->fib6_nsiblings
Date: Tue, 12 Aug 2025 19:47:04 +0200
Message-ID: <20250812174406.366474762@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index d7cf38f91c5b..3ac7e15d8d23 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -433,15 +433,17 @@ struct fib6_dump_arg {
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
@@ -1119,7 +1121,7 @@ static int fib6_add_rt2node(struct fib6_node *fn, struct fib6_info *rt,
 
 			if (rt6_duplicate_nexthop(iter, rt)) {
 				if (rt->fib6_nsiblings)
-					rt->fib6_nsiblings = 0;
+					WRITE_ONCE(rt->fib6_nsiblings, 0);
 				if (!(iter->fib6_flags & RTF_EXPIRES))
 					return -EEXIST;
 				if (!(rt->fib6_flags & RTF_EXPIRES)) {
@@ -1148,7 +1150,8 @@ static int fib6_add_rt2node(struct fib6_node *fn, struct fib6_info *rt,
 			 */
 			if (rt_can_ecmp &&
 			    rt6_qualify_for_ecmp(iter))
-				rt->fib6_nsiblings++;
+				WRITE_ONCE(rt->fib6_nsiblings,
+					   rt->fib6_nsiblings + 1);
 		}
 
 		if (iter->fib6_metric > rt->fib6_metric)
@@ -1198,7 +1201,8 @@ static int fib6_add_rt2node(struct fib6_node *fn, struct fib6_info *rt,
 		fib6_nsiblings = 0;
 		list_for_each_entry_safe(sibling, temp_sibling,
 					 &rt->fib6_siblings, fib6_siblings) {
-			sibling->fib6_nsiblings++;
+			WRITE_ONCE(sibling->fib6_nsiblings,
+				   sibling->fib6_nsiblings + 1);
 			BUG_ON(sibling->fib6_nsiblings != rt->fib6_nsiblings);
 			fib6_nsiblings++;
 		}
@@ -1243,7 +1247,8 @@ static int fib6_add_rt2node(struct fib6_node *fn, struct fib6_info *rt,
 				list_for_each_entry_safe(sibling, next_sibling,
 							 &rt->fib6_siblings,
 							 fib6_siblings)
-					sibling->fib6_nsiblings--;
+					WRITE_ONCE(sibling->fib6_nsiblings,
+						   sibling->fib6_nsiblings - 1);
 				WRITE_ONCE(rt->fib6_nsiblings, 0);
 				list_del_rcu(&rt->fib6_siblings);
 				rt6_multipath_rebalance(next_sibling);
@@ -1961,7 +1966,8 @@ static void fib6_del_route(struct fib6_table *table, struct fib6_node *fn,
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
index 506afe11fe3c..aa1341fc9933 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -5249,7 +5249,8 @@ static void ip6_route_mpath_notify(struct fib6_info *rt,
 	 */
 	rcu_read_lock();
 
-	if ((nlflags & NLM_F_APPEND) && rt_last && rt_last->fib6_nsiblings) {
+	if ((nlflags & NLM_F_APPEND) && rt_last &&
+	    READ_ONCE(rt_last->fib6_nsiblings)) {
 		rt = list_first_or_null_rcu(&rt_last->fib6_siblings,
 					    struct fib6_info,
 					    fib6_siblings);
@@ -5782,7 +5783,7 @@ static int rt6_fill_node(struct net *net, struct sk_buff *skb,
 		if (dst->lwtstate &&
 		    lwtunnel_fill_encap(skb, dst->lwtstate, RTA_ENCAP, RTA_ENCAP_TYPE) < 0)
 			goto nla_put_failure;
-	} else if (rt->fib6_nsiblings) {
+	} else if (READ_ONCE(rt->fib6_nsiblings)) {
 		struct fib6_info *sibling;
 		struct nlattr *mp;
 
-- 
2.39.5



