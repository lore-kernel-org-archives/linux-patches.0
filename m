Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D7912C15B2;
	Tue, 31 Mar 2026 16:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975785; cv=none; b=ludHlbvGaUWMCkIqLB5qx6wPYa1PSvtgVRUNUQyInmanmQZpLOovXrReahOWniNE8qPYtx/rLxPpKfzM8M3vHAIC02DbQhh1NNsR+O+63uJ8qRpFVFYYRk+Vf7cjR3nP97TCwlRXOJBrQm8lWVie2zdUz1xmMkUxqcHuakWAfeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975785; c=relaxed/simple;
	bh=URxOLJZuXuv3IDYAPzQQL50fvEqLcDrn0loa2gToTRc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FnLznIA2O7Gsnqrmpy5mL0J0wy3uW6DkuyFqCMgu+koVBPdgrv1jfPlSPrsy3/jcRNFlsL6DaWDcz8qpyBActFiCvgGGNjLYRUdA3DnentlD81Z0MXiWUeyoJV9QpnFGZWftE+n56nqEvqNG5TAHv7pp0IL+UAzhCWfhQkTfOns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CkZcEAYA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CkZcEAYA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B83EAC19423;
	Tue, 31 Mar 2026 16:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975785;
	bh=URxOLJZuXuv3IDYAPzQQL50fvEqLcDrn0loa2gToTRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CkZcEAYAGFs/urY+eMJNKzw3VCZUoLjNLOlg7YdV5kqVgWCWk5GWC8Q0EXc//QjMg
	 JMHQ+bidKTqBw2go6UavpY0ileM5SjSDzgD+3PKu820nLMPrNpnJrhe1bxZHWEFkE8
	 Gm15DN0mRj2BqCzfb69Qxm3WdWmEMknEYV0R98LI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 086/244] ipv6: Dont remove permanent routes with exceptions from tb6_gc_hlist.
Date: Tue, 31 Mar 2026 18:20:36 +0200
Message-ID: <20260331161744.856082602@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
References: <20260331161741.651718120@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 6cb867ce48784..74b78c80af71d 100644
--- a/include/net/ip6_fib.h
+++ b/include/net/ip6_fib.h
@@ -506,12 +506,14 @@ void fib6_rt_update(struct net *net, struct fib6_info *rt,
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
@@ -544,6 +546,23 @@ static inline void fib6_remove_gc_list(struct fib6_info *f6i)
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
index e57a2b1841616..63ada312061c6 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -2860,7 +2860,7 @@ void addrconf_prefix_rcv(struct net_device *dev, u8 *opt, int len, bool sllao)
 					fib6_add_gc_list(rt);
 				} else {
 					fib6_clean_expires(rt);
-					fib6_remove_gc_list(rt);
+					fib6_may_remove_gc_list(net, rt);
 				}
 
 				spin_unlock_bh(&table->tb6_lock);
@@ -4850,7 +4850,7 @@ static int modify_prefix_route(struct net *net, struct inet6_ifaddr *ifp,
 
 		if (!(flags & RTF_EXPIRES)) {
 			fib6_clean_expires(f6i);
-			fib6_remove_gc_list(f6i);
+			fib6_may_remove_gc_list(net, f6i);
 		} else {
 			fib6_set_expires(f6i, expires);
 			fib6_add_gc_list(f6i);
diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index fca68fb1b74c2..2072c788c912a 100644
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
@@ -2314,8 +2314,8 @@ static void fib6_flush_trees(struct net *net)
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
index 36324d1905f81..31c9e3b73f2da 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -1034,7 +1034,7 @@ int rt6_route_rcv(struct net_device *dev, u8 *opt, int len,
 
 		if (!addrconf_finite_timeout(lifetime)) {
 			fib6_clean_expires(rt);
-			fib6_remove_gc_list(rt);
+			fib6_may_remove_gc_list(net, rt);
 		} else {
 			fib6_set_expires(rt, jiffies + HZ * lifetime);
 			fib6_add_gc_list(rt);
-- 
2.51.0



