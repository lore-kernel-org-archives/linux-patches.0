Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B82E979DA;
	Wed, 10 Dec 2025 07:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765351861; cv=none; b=i9nRHhiiNM2VBbmotcD4akuSxiFnvO5KOqVFhoCXUWcB/IvaNnf2CKV51uv04pDws98SMbVXQUdfXUXzYTbt6RiTLaK4s5+u8Xh2fV8Qr8RzcmXYUCXKoPdypqYv4FESGGZh35o2UN7HYlb6btYbv4nvIS2p+XB8Q7DEq+TkHBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765351861; c=relaxed/simple;
	bh=eyJk1yRxffey3bNdsBEoU2lWLXucrAM/RHlA+gZ1Adk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AQxyT9bWC0TuRb9DTxaQrHo4gX+jXCZpGUbuCWmi3xtX1m0UQmDwzCHLa/OfrgsAWUwv93+pUI5ZVjO2L2/CkNw+QnsubNBjtA/S8Cb8J2tkl/beaTcK+j4H0AfrfYP5v2CMhfV/srZ0ZOf+qMHOovf6CRFfH2MLOO15do0qiuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tHUlC56X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tHUlC56X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43067C4CEF1;
	Wed, 10 Dec 2025 07:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765351861;
	bh=eyJk1yRxffey3bNdsBEoU2lWLXucrAM/RHlA+gZ1Adk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tHUlC56X61mbpMj7whi3ynBmv317BYXSK9rwUIwwS+v+bl7LanbLa10ozZr5jMfyz
	 zQFfGW8qtI0fvIFKwJp1aFs7Zp/lDBt6lSBKVR791bWApUuwEApOjn6a/prRmAV/w0
	 tYHsmx2WMOZEVmofQu0TKHEhO4voE+Au75Q6qCpk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 01/49] xfrm: delete x->tunnel as we delete x
Date: Wed, 10 Dec 2025 16:29:31 +0900
Message-ID: <20251210072948.163659491@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251210072948.125620687@linuxfoundation.org>
References: <20251210072948.125620687@linuxfoundation.org>
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
index caaff61601a07..d51204041bf7d 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -424,7 +424,6 @@ int xfrm_input_register_afinfo(const struct xfrm_input_afinfo *afinfo);
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
index bf140ef781c1f..7fd8bc08e6eb1 100644
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
index f8cb033f102ed..e4500d481e26b 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -748,6 +748,7 @@ void __xfrm_state_destroy(struct xfrm_state *x, bool sync)
 }
 EXPORT_SYMBOL(__xfrm_state_destroy);
 
+static void xfrm_state_delete_tunnel(struct xfrm_state *x);
 int __xfrm_state_delete(struct xfrm_state *x)
 {
 	struct net *net = xs_net(x);
@@ -775,6 +776,8 @@ int __xfrm_state_delete(struct xfrm_state *x)
 
 		xfrm_dev_state_delete(x);
 
+		xfrm_state_delete_tunnel(x);
+
 		/* All xfrm_state objects are created by xfrm_state_alloc.
 		 * The xfrm_state_alloc call gives a reference, and that
 		 * is what we are dropping here.
@@ -878,10 +881,7 @@ int xfrm_state_flush(struct net *net, u8 proto, bool task_valid, bool sync)
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
 
@@ -3008,20 +3008,17 @@ void xfrm_flush_gc(void)
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
@@ -3221,8 +3218,8 @@ void xfrm_state_fini(struct net *net)
 	unsigned int sz;
 
 	flush_work(&net->xfrm.state_hash_work);
-	flush_work(&xfrm_state_gc_work);
 	xfrm_state_flush(net, 0, false, true);
+	flush_work(&xfrm_state_gc_work);
 
 	WARN_ON(!list_empty(&net->xfrm.state_all));
 
-- 
2.51.0



