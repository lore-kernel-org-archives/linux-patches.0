Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624205;
	b=3fL3EMLlG+UoEef+Wd1RY4GRCDRw4FQGTULfgNUCfHaM3GWgGjugfx7V1k4eM/Pb422C
	 NnzDMbf+hUXs9Lb3ifGajiK35fdLrFcDZ1mvKx3JtIXuUeZKQIIAb9m4Yn0k9KPBqUauL
	 kx5FnEYa/kquVbVoedpzt38luh0BEfRxFrx0r8LZPdGzlt2Zhl04vsxy84sf7nmDrpmmx
	 sFuO10nfMh2ZLOcHM7rE/es87B+tWFOmdkR0YE5C8HX9v4AG2Ze0ApnQeNE8W4YzTSlf7
	 4W+gmD92UabwaoOqMjlzO19TcRD2PUTEVh1le6nIQpfWtiDrUFg7u1zO73gfqsPRqLg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624205;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kCV/EZpTkd834it+B2s4urcJ1sTdbo+vTTs56Pp7iBg=;
	b=kcDdsoAkWr94G3Ypr6j3GHmIS79F/Pfubk8nQaIqqSw2aMiLnLusHmuTHhs59Nnk9a7i
	 ztzGbsVWQEj2s/RrrnJLuz16sJOP3h0O9SLvDDZ7Au4BKXnLl4U+TfBzdwaCxIR4hXWfo
	 ebW1P2NJhwiX+E7Q9mbFz6DwgzTdXeR9vAMXXeJ5MwgWze81AeC5PTMXCzPzpXsot0I1h
	 7jLj7uLc5QxLYHSBmdZ6RPbpBvc6h7iS44ZAMxMDslAgp6cjrt2NC5A+up1MiHfm7+Frg
	 pCN1xi2OBS6uEAgfsgzy2o6Fi1qu7B82cm9maHad5ATlXPyV3G2t7x+EM8DtctAbGEw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="BpTQ//WS";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5F33606A696;
	Wed, 25 Nov 2026 16:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BpTQ//WS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD1A31F000C0;
	Wed, 25 Nov 2026 16:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624205;
	bh=kCV/EZpTkd834it+B2s4urcJ1sTdbo+vTTs56Pp7iBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BpTQ//WSzCujYdELDST42KhSjucfr/LlZdpGaOyiIEjTeSHUcENADBjpzmcIQBao1
	 FLOslIhadwwyoWyp718rviISvNtekK1TGfE32y2k3PX4Ye4N5A5RRT4ZmJPqGSg3WY
	 dRrdsWS0T4oVrFX6mmYgYZP1W3NkQrsXAU8R80cA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AutonomousCodeSecurity@microsoft.com,
	"Cen Zhang (Microsoft)" <cenzhang@linux.microsoft.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Dave Miller <davem@davem-thinkpadp1gen8.ibmlond.csb>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 117/816] ipv6: fix fib6 walker UAF on NLM_F_REPLACE
Date: Wed, 25 Nov 2026 15:27:45 +0100
Message-ID: <20261125143851.919635941@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cen Zhang (Microsoft) <cenzhang@linux.microsoft.com>

[ Upstream commit 23fec4bd76904e9df7a8cc0a81ceb14c36971da4 ]

fib6_walker uses w->leaf to remember the next fib6_info to dump, so an
RTM_GETROUTE dump can continue there on the next recvmsg().  This
assumes that whoever removes a route from the tree also updates the
walkers pointing at it.  fib6_del_route() does: it moves w->leaf to
the next route.  The NLM_F_REPLACE branch of fib6_add_rt2node() does
not: it removes the old route, fib6_add() frees it, and w->leaf keeps
pointing at the freed object.

The fn_sernum version check in fib6_dump_table() normally protects
against resuming on a stale w->leaf, but it can be bypassed:
ip6_link_failure() resets fn_sernum to -1 when the default route
fails, which an unprivileged user in a user+net namespace can cause:

  1) link failure            fn_sernum = -1
  2) dump pauses on route R
  3) replace R               fn_sernum changed, R freed
  4) link failure            fn_sernum = -1
  5) dump resumes            -1 == -1, reads freed R  <- UAF

  BUG: KASAN: slab-use-after-free in rt6_fill_node+0x1c22/0x2cd0
  Read of size 4 at addr ff11000011fa0064 by task poc/101
   rt6_fill_node <- rt6_dump_route

Fix by adjusting walkers separately for replacement and deletion.
For replacement, add fib6_walkers_replace_leaf() points w->leaf
at the new route. For deletion and ECMP sibling removal,
fib6_walkers_skip_rt() calls fib6_walkers_replace_leaf() with the
next route. Reset w->skip_in_node when updating w->leaf, and set
w->state to FWS_U when no next route remains.

Fixes: 4a287eba2de3 ("IPv6 routing, NLM_F_* flag support: REPLACE and EXCL flags support, warn about missing CREATE flag")
Cc: AutonomousCodeSecurity@microsoft.com
Signed-off-by: Cen Zhang (Microsoft) <cenzhang@linux.microsoft.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Dave Miller <davem@davem-thinkpadp1gen8.ibmlond.csb>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/ip6_fib.c | 50 ++++++++++++++++++++++++++++++++++------------
 1 file changed, 37 insertions(+), 13 deletions(-)

diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index 630b520f72410..aab1dddf1f59f 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -89,6 +89,40 @@ static void fib6_walker_unlink(struct net *net, struct fib6_walker *w)
 	write_unlock_bh(&net->ipv6.fib6_walker_lock);
 }
 
+/* @old is leaving the tree.  Walkers resting on it continue from @new, or
+ * climb to the parent node when there is no @new.  Called with tb6_lock
+ * held.
+ */
+static void fib6_walkers_replace_leaf(struct net *net, struct fib6_info *old,
+				      struct fib6_info *new)
+{
+	struct fib6_walker *w;
+
+	read_lock(&net->ipv6.fib6_walker_lock);
+	FOR_WALKERS(net, w) {
+		if (w->state == FWS_C && w->leaf == old) {
+			pr_debug("walker %p adjusted by unlink of %p\n", w, old);
+			w->leaf = new;
+			w->skip_in_node = 0;
+			if (!new)
+				w->state = FWS_U;
+		}
+	}
+	read_unlock(&net->ipv6.fib6_walker_lock);
+}
+
+/* @rt is removed from its node: walkers resting on it continue from the
+ * next route of the node.
+ */
+static void fib6_walkers_skip_rt(struct net *net, struct fib6_info *rt)
+{
+	struct fib6_info *next;
+
+	next = rcu_dereference_protected(rt->fib6_next,
+					 lockdep_is_held(&rt->fib6_table->tb6_lock));
+	fib6_walkers_replace_leaf(net, rt, next);
+}
+
 static int fib6_new_sernum(struct net *net)
 {
 	int new, old = atomic_read(&net->ipv6.fib6_sernum);
@@ -1302,6 +1336,7 @@ static int fib6_add_rt2node(struct fib6_node *fn, struct fib6_info *rt,
 		rcu_assign_pointer(rt->fib6_node, fn);
 		rt->fib6_next = iter->fib6_next;
 		rcu_assign_pointer(*ins, rt);
+		fib6_walkers_replace_leaf(info->nl_net, iter, rt);
 		if (!info->skip_notify)
 			inet6_rt_notify(RTM_NEWROUTE, rt, info, NLM_F_REPLACE);
 		if (!(fn->fn_flags & RTN_RTINFO)) {
@@ -1324,6 +1359,7 @@ static int fib6_add_rt2node(struct fib6_node *fn, struct fib6_info *rt,
 				if (iter->fib6_metric > rt->fib6_metric)
 					break;
 				if (rt6_qualify_for_ecmp(iter)) {
+					fib6_walkers_skip_rt(info->nl_net, iter);
 					*ins = iter->fib6_next;
 					iter->fib6_node = NULL;
 					fib6_purge_rt(iter, fn, info->nl_net);
@@ -1933,7 +1969,6 @@ static void fib6_del_route(struct fib6_table *table, struct fib6_node *fn,
 			   struct fib6_info __rcu **rtp, struct nl_info *info)
 {
 	struct fib6_info *leaf, *replace_rt = NULL;
-	struct fib6_walker *w;
 	struct fib6_info *rt = rcu_dereference_protected(*rtp,
 				    lockdep_is_held(&table->tb6_lock));
 	struct net *net = info->nl_net;
@@ -1984,18 +2019,7 @@ static void fib6_del_route(struct fib6_table *table, struct fib6_node *fn,
 		rt6_multipath_rebalance(next_sibling);
 	}
 
-	/* Adjust walkers */
-	read_lock(&net->ipv6.fib6_walker_lock);
-	FOR_WALKERS(net, w) {
-		if (w->state == FWS_C && w->leaf == rt) {
-			pr_debug("walker %p adjusted by delroute\n", w);
-			w->leaf = rcu_dereference_protected(rt->fib6_next,
-					    lockdep_is_held(&table->tb6_lock));
-			if (!w->leaf)
-				w->state = FWS_U;
-		}
-	}
-	read_unlock(&net->ipv6.fib6_walker_lock);
+	fib6_walkers_skip_rt(net, rt);
 
 	/* If it was last route, call fib6_repair_tree() to:
 	 * 1. For root node, put back null_entry as how the table was created.
-- 
2.53.0



