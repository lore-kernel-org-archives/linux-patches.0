Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 693062EE262;
	Tue, 31 Mar 2026 16:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974987; cv=none; b=LpNejpHNvd8SMNw56plYh/5jvHk6SC2i5J7itduop3ZiS6nAzbPTM235odQD0Ag/Qm11Oxxu70Lu6vMTfXjtEZO+l1hxfpGbabY5TpybYasbWm+xrv63K2C1R6U+EPnsLIWE7KvrqxM5cSTLqejEiuYBDwQUGAj009v4GW2VaaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974987; c=relaxed/simple;
	bh=cPjuQi3+JBJmxlg4ZLvPMlbICSlneDyfIsbUIVxGrsA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fKgttyTnz2R56sB2RKBdLqmT0Jc8qvwbjRZsH8LDYhVt8GKN2HGkEyu87dXk5PJUhcPY6ESjnELGk4d+NQ/QvsreYhUcwr26atfCTqlOxdW04arsphLQoiANwc1H1jlqiWYSx8A2nT4gL5LiFrdcp8nLIrXMa1CnIyD227zvsO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RBPBFndj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RBPBFndj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2D86C19424;
	Tue, 31 Mar 2026 16:36:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974987;
	bh=cPjuQi3+JBJmxlg4ZLvPMlbICSlneDyfIsbUIVxGrsA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RBPBFndjiBUJ6Mjqk0gYVfgwfrGvtSs64xUCAfQ94vBg57iMMm8kO9ghKoBJyJVAR
	 Rycndqn/5OrRZ/JNdY4SAPfZ+f9nWoOCQl0v2kh3PS5aHEARcOAyMW1Vycwkf0OQWL
	 wbBI553/E0s7NslJzO6m/l7cm8SFeQn1d3ni3fwA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 119/342] ipv6: Dont remove permanent routes with exceptions from tb6_gc_hlist.
Date: Tue, 31 Mar 2026 18:19:12 +0200
Message-ID: <20260331161803.389118910@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit 4be7b99c253f0c85a255cc1db7127ba3232dfa30 ]

The cited commit mechanically put fib6_remove_gc_list()
just after every fib6_clean_expires() call.

When a temporary route is promoted to a permanent route,
there may already be exception routes tied to it.

If fib6_remove_gc_list() removes the route from tb6_gc_hlist,
such exception routes will no longer be aged.

Let's replace fib6_remove_gc_list() with a new helper
fib6_may_remove_gc_list() and use fib6_age_exceptions() there.

Note that net->ipv6 is only compiled when CONFIG_IPV6 is
enabled, so fib6_{add,remove,may_remove}_gc_list() are guarded.

Fixes: 5eb902b8e719 ("net/ipv6: Remove expired routes with a separated list of routes.")
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://patch.msgid.link/20260320072317.2561779-3-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/ip6_fib.h | 21 ++++++++++++++++++++-
 net/ipv6/addrconf.c   |  4 ++--
 net/ipv6/ip6_fib.c    |  6 +++---
 net/ipv6/route.c      |  2 +-
 4 files changed, 26 insertions(+), 7 deletions(-)

diff --git a/include/net/ip6_fib.h b/include/net/ip6_fib.h
index 88b0dd4d8e094..9f8b6814a96a0 100644
--- a/include/net/ip6_fib.h
+++ b/include/net/ip6_fib.h
@@ -507,12 +507,14 @@ void fib6_rt_update(struct net *net, struct fib6_info *rt,
 void inet6_rt_notify(int event, struct fib6_info *rt, struct nl_info *info,
 		     unsigned int flags);
 
+void fib6_age_exceptions(struct fib6_info *rt, struct fib6_gc_args *gc_args,
+			 unsigned long now);
 void fib6_run_gc(unsigned long expires, struct net *net, bool force);
-
 void fib6_gc_cleanup(void);
 
 int fib6_init(void);
 
+#if IS_ENABLED(CONFIG_IPV6)
 /* Add the route to the gc list if it is not already there
  *
  * The callers should hold f6i->fib6_table->tb6_lock.
@@ -545,6 +547,23 @@ static inline void fib6_remove_gc_list(struct fib6_info *f6i)
 		hlist_del_init(&f6i->gc_link);
 }
 
+static inline void fib6_may_remove_gc_list(struct net *net,
+					   struct fib6_info *f6i)
+{
+	struct fib6_gc_args gc_args;
+
+	if (hlist_unhashed(&f6i->gc_link))
+		return;
+
+	gc_args.timeout = READ_ONCE(net->ipv6.sysctl.ip6_rt_gc_interval);
+	gc_args.more = 0;
+
+	rcu_read_lock();
+	fib6_age_exceptions(f6i, &gc_args, jiffies);
+	rcu_read_unlock();
+}
+#endif
+
 struct ipv6_route_iter {
 	struct seq_net_private p;
 	struct fib6_walker w;
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 27ab9d7adc649..3dcfa4b3094a8 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -2863,7 +2863,7 @@ void addrconf_prefix_rcv(struct net_device *dev, u8 *opt, int len, bool sllao)
 					fib6_add_gc_list(rt);
 				} else {
 					fib6_clean_expires(rt);
-					fib6_remove_gc_list(rt);
+					fib6_may_remove_gc_list(net, rt);
 				}
 
 				spin_unlock_bh(&table->tb6_lock);
@@ -4836,7 +4836,7 @@ static int modify_prefix_route(struct net *net, struct inet6_ifaddr *ifp,
 
 		if (!(flags & RTF_EXPIRES)) {
 			fib6_clean_expires(f6i);
-			fib6_remove_gc_list(f6i);
+			fib6_may_remove_gc_list(net, f6i);
 		} else {
 			fib6_set_expires(f6i, expires);
 			fib6_add_gc_list(f6i);
diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index a22af1c8f93ac..ffa7733598333 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -1133,7 +1133,7 @@ static int fib6_add_rt2node(struct fib6_node *fn, struct fib6_info *rt,
 					return -EEXIST;
 				if (!(rt->fib6_flags & RTF_EXPIRES)) {
 					fib6_clean_expires(iter);
-					fib6_remove_gc_list(iter);
+					fib6_may_remove_gc_list(info->nl_net, iter);
 				} else {
 					fib6_set_expires(iter, rt->expires);
 					fib6_add_gc_list(iter);
@@ -2348,8 +2348,8 @@ static void fib6_flush_trees(struct net *net)
 /*
  *	Garbage collection
  */
-static void fib6_age_exceptions(struct fib6_info *rt, struct fib6_gc_args *gc_args,
-				unsigned long now)
+void fib6_age_exceptions(struct fib6_info *rt, struct fib6_gc_args *gc_args,
+			 unsigned long now)
 {
 	bool may_expire = rt->fib6_flags & RTF_EXPIRES && rt->expires;
 	int old_more = gc_args->more;
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index e01331d965313..446f4de7d6a22 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -1033,7 +1033,7 @@ int rt6_route_rcv(struct net_device *dev, u8 *opt, int len,
 
 		if (!addrconf_finite_timeout(lifetime)) {
 			fib6_clean_expires(rt);
-			fib6_remove_gc_list(rt);
+			fib6_may_remove_gc_list(net, rt);
 		} else {
 			fib6_set_expires(rt, jiffies + HZ * lifetime);
 			fib6_add_gc_list(rt);
-- 
2.51.0



