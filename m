Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F6D833ADB8;
	Fri,  9 Jan 2026 11:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959314; cv=none; b=HrBKHoN6Y9MBFEz94vMhh4OcvNSul8cU6nd9SkDeNSQszE0gQ6OpZe9m0MwQWgW5DIsUKnzCy3QQp1jPT5xdbrhopvi3oNJrK6/rsh+af7nzaEW3Ae0AZEkF/L8N3h/50xY/c3JrtWBfx6aYwHevoLuiCKQkzg3t5j8AkodRnl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959314; c=relaxed/simple;
	bh=zpXE3hpnCDvodpJI0eFXhxYmZdLagQFTgFJ9+FQsKQ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oD0TSeGoA1Ihft1+RV0TWh6yHjFUVVWg8ktlAgqTRgxXscZlsCOOqc8gP5Fch3opCvcN+T6xGYiXRe6QxWn/J0am+E6TEIR5ioMhNDhXvXJtlfgOdPIeupmpU+wPs1SvsNwANv3peAWbh+aUtMVegLS3E52eZ5+wKbzk5My2nVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pu09du9D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pu09du9D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F380C4CEF1;
	Fri,  9 Jan 2026 11:48:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959313;
	bh=zpXE3hpnCDvodpJI0eFXhxYmZdLagQFTgFJ9+FQsKQ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pu09du9Dv4Qe7Q+B8znIv4oqoXZQTkTO4pW6mwmt45/ZK+vC6oW02U1+AZQgvr9gV
	 5mnomH+YvevmB55N/ADn8/uHQT8mzK9sxFGnwz5Os4R8LlRIsg85RO2jxSPCSVVRu5
	 VOLNyj2Uw3ePnasqVdPtcZcSKQ0qxhDUuUwqdBEI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 001/737] xfrm: delete x->tunnel as we delete x
Date: Fri,  9 Jan 2026 12:32:20 +0100
Message-ID: <20260109112134.043575655@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit b441cf3f8c4b8576639d20c8eb4aa32917602ecd ]

The ipcomp fallback tunnels currently get deleted (from the various
lists and hashtables) as the last user state that needed that fallback
is destroyed (not deleted). If a reference to that user state still
exists, the fallback state will remain on the hashtables/lists,
triggering the WARN in xfrm_state_fini. Because of those remaining
references, the fix in commit f75a2804da39 ("xfrm: destroy xfrm_state
synchronously on net exit path") is not complete.

We recently fixed one such situation in TCP due to defered freeing of
skbs (commit 9b6412e6979f ("tcp: drop secpath at the same time as we
currently drop dst")). This can also happen due to IP reassembly: skbs
with a secpath remain on the reassembly queue until netns
destruction. If we can't guarantee that the queues are flushed by the
time xfrm_state_fini runs, there may still be references to a (user)
xfrm_state, preventing the timely deletion of the corresponding
fallback state.

Instead of chasing each instance of skbs holding a secpath one by one,
this patch fixes the issue directly within xfrm, by deleting the
fallback state as soon as the last user state depending on it has been
deleted. Destruction will still happen when the final reference is
dropped.

A separate lockdep class for the fallback state is required since
we're going to lock x->tunnel while x is locked.

Fixes: 9d4139c76905 ("netns xfrm: per-netns xfrm_state_all list")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/xfrm.h      |  1 -
 net/ipv4/ipcomp.c       |  2 ++
 net/ipv6/ipcomp6.c      |  2 ++
 net/ipv6/xfrm6_tunnel.c |  2 +-
 net/xfrm/xfrm_ipcomp.c  |  1 -
 net/xfrm/xfrm_state.c   | 19 ++++++++-----------
 6 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 84a1c8c861d29..f7a52b9b56acc 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -414,7 +414,6 @@ int xfrm_input_register_afinfo(const struct xfrm_input_afinfo *afinfo);
 int xfrm_input_unregister_afinfo(const struct xfrm_input_afinfo *afinfo);
 
 void xfrm_flush_gc(void);
-void xfrm_state_delete_tunnel(struct xfrm_state *x);
 
 struct xfrm_type {
 	struct module		*owner;
diff --git a/net/ipv4/ipcomp.c b/net/ipv4/ipcomp.c
index 5a4fb2539b08b..9a45aed508d19 100644
--- a/net/ipv4/ipcomp.c
+++ b/net/ipv4/ipcomp.c
@@ -54,6 +54,7 @@ static int ipcomp4_err(struct sk_buff *skb, u32 info)
 }
 
 /* We always hold one tunnel user reference to indicate a tunnel */
+static struct lock_class_key xfrm_state_lock_key;
 static struct xfrm_state *ipcomp_tunnel_create(struct xfrm_state *x)
 {
 	struct net *net = xs_net(x);
@@ -62,6 +63,7 @@ static struct xfrm_state *ipcomp_tunnel_create(struct xfrm_state *x)
 	t = xfrm_state_alloc(net);
 	if (!t)
 		goto out;
+	lockdep_set_class(&t->lock, &xfrm_state_lock_key);
 
 	t->id.proto = IPPROTO_IPIP;
 	t->id.spi = x->props.saddr.a4;
diff --git a/net/ipv6/ipcomp6.c b/net/ipv6/ipcomp6.c
index 72d4858dec18a..8607569de34f3 100644
--- a/net/ipv6/ipcomp6.c
+++ b/net/ipv6/ipcomp6.c
@@ -71,6 +71,7 @@ static int ipcomp6_err(struct sk_buff *skb, struct inet6_skb_parm *opt,
 	return 0;
 }
 
+static struct lock_class_key xfrm_state_lock_key;
 static struct xfrm_state *ipcomp6_tunnel_create(struct xfrm_state *x)
 {
 	struct net *net = xs_net(x);
@@ -79,6 +80,7 @@ static struct xfrm_state *ipcomp6_tunnel_create(struct xfrm_state *x)
 	t = xfrm_state_alloc(net);
 	if (!t)
 		goto out;
+	lockdep_set_class(&t->lock, &xfrm_state_lock_key);
 
 	t->id.proto = IPPROTO_IPV6;
 	t->id.spi = xfrm6_tunnel_alloc_spi(net, (xfrm_address_t *)&x->props.saddr);
diff --git a/net/ipv6/xfrm6_tunnel.c b/net/ipv6/xfrm6_tunnel.c
index 1323f2f6928e2..1702b4de1c1ef 100644
--- a/net/ipv6/xfrm6_tunnel.c
+++ b/net/ipv6/xfrm6_tunnel.c
@@ -334,8 +334,8 @@ static void __net_exit xfrm6_tunnel_net_exit(struct net *net)
 	struct xfrm6_tunnel_net *xfrm6_tn = xfrm6_tunnel_pernet(net);
 	unsigned int i;
 
-	xfrm_flush_gc();
 	xfrm_state_flush(net, 0, false, true);
+	xfrm_flush_gc();
 
 	for (i = 0; i < XFRM6_TUNNEL_SPI_BYADDR_HSIZE; i++)
 		WARN_ON_ONCE(!hlist_empty(&xfrm6_tn->spi_byaddr[i]));
diff --git a/net/xfrm/xfrm_ipcomp.c b/net/xfrm/xfrm_ipcomp.c
index 9c0fa0e1786a2..f2e70e918f114 100644
--- a/net/xfrm/xfrm_ipcomp.c
+++ b/net/xfrm/xfrm_ipcomp.c
@@ -315,7 +315,6 @@ void ipcomp_destroy(struct xfrm_state *x)
 	struct ipcomp_data *ipcd = x->data;
 	if (!ipcd)
 		return;
-	xfrm_state_delete_tunnel(x);
 	mutex_lock(&ipcomp_resource_mutex);
 	ipcomp_free_data(ipcd);
 	mutex_unlock(&ipcomp_resource_mutex);
diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index ded559f557675..7c8aeec4fe274 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -736,6 +736,7 @@ void __xfrm_state_destroy(struct xfrm_state *x, bool sync)
 }
 EXPORT_SYMBOL(__xfrm_state_destroy);
 
+static void xfrm_state_delete_tunnel(struct xfrm_state *x);
 int __xfrm_state_delete(struct xfrm_state *x)
 {
 	struct net *net = xs_net(x);
@@ -756,6 +757,8 @@ int __xfrm_state_delete(struct xfrm_state *x)
 
 		xfrm_dev_state_delete(x);
 
+		xfrm_state_delete_tunnel(x);
+
 		/* All xfrm_state objects are created by xfrm_state_alloc.
 		 * The xfrm_state_alloc call gives a reference, and that
 		 * is what we are dropping here.
@@ -859,10 +862,7 @@ int xfrm_state_flush(struct net *net, u8 proto, bool task_valid, bool sync)
 				err = xfrm_state_delete(x);
 				xfrm_audit_state_delete(x, err ? 0 : 1,
 							task_valid);
-				if (sync)
-					xfrm_state_put_sync(x);
-				else
-					xfrm_state_put(x);
+				xfrm_state_put(x);
 				if (!err)
 					cnt++;
 
@@ -2798,20 +2798,17 @@ void xfrm_flush_gc(void)
 }
 EXPORT_SYMBOL(xfrm_flush_gc);
 
-/* Temporarily located here until net/xfrm/xfrm_tunnel.c is created */
-void xfrm_state_delete_tunnel(struct xfrm_state *x)
+static void xfrm_state_delete_tunnel(struct xfrm_state *x)
 {
 	if (x->tunnel) {
 		struct xfrm_state *t = x->tunnel;
 
-		if (atomic_read(&t->tunnel_users) == 2)
+		if (atomic_dec_return(&t->tunnel_users) == 1)
 			xfrm_state_delete(t);
-		atomic_dec(&t->tunnel_users);
-		xfrm_state_put_sync(t);
+		xfrm_state_put(t);
 		x->tunnel = NULL;
 	}
 }
-EXPORT_SYMBOL(xfrm_state_delete_tunnel);
 
 u32 xfrm_state_mtu(struct xfrm_state *x, int mtu)
 {
@@ -2989,8 +2986,8 @@ void xfrm_state_fini(struct net *net)
 	unsigned int sz;
 
 	flush_work(&net->xfrm.state_hash_work);
-	flush_work(&xfrm_state_gc_work);
 	xfrm_state_flush(net, 0, false, true);
+	flush_work(&xfrm_state_gc_work);
 
 	WARN_ON(!list_empty(&net->xfrm.state_all));
 
-- 
2.51.0



