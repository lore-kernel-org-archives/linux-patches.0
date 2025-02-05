Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 531C218B460;
	Wed,  5 Feb 2025 14:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767463; cv=none; b=rJwrZX+H/fTsb61cYjkXFwpVUV75Tzv0e1b8MpAjWrVI6D2+Lrcz1cxHCncvnVxosWmSgWE8933+H3H+Fs8sh2Hs+tyWaMGrx+usx41oZbfwMEJcoxjau2OKtlCBmu72xgh5VwodcP67s/U1SOMnv/sqc01wr7nREnYMYUv1EJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767463; c=relaxed/simple;
	bh=lvqNBH/EjZVKKL/sZ7xOy5I/EosQDA9tioqmfHDVm7M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dlm7ObvEvU5DnyTZSEN5Ma3rCOgoPjX6d81eFuohKGixIpQzzKlC0IW1W45m+RB4+31/if6U9iPEbuITnF91NyXuVxLZ95B30jYTrqY0z1O168JGOacDMXPJbgDrCRWDmjnVudByLPGNjTrxsczb0X1Nc0YoPBRzh54NxBYbQh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=10I4uhyD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="10I4uhyD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B577BC4CED1;
	Wed,  5 Feb 2025 14:57:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767463;
	bh=lvqNBH/EjZVKKL/sZ7xOy5I/EosQDA9tioqmfHDVm7M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=10I4uhyDaYgA7uuyXVzO/tOCDVl8vzIfEf0wupY2KD2z132Mr4e7FCVNN/9fxwWYR
	 EPF0hg8RGrcWR67z+WsM4ernSlnNdqB+Q7ECgoXxDft3k0j65K92O0OPlECndsIz7P
	 V1C4jniJ90PvHh9XIaOo8iYb0N5HNKoUsRwqVuyk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Antony Antony <antony.antony@secunet.com>,
	Tobias Brunner <tobias@strongswan.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 460/590] xfrm: Add an inbound percpu state cache.
Date: Wed,  5 Feb 2025 14:43:35 +0100
Message-ID: <20250205134512.860877343@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

From: Steffen Klassert <steffen.klassert@secunet.com>

[ Upstream commit 81a331a0e72ddc2f75092603d9577bd1a0ca23ad ]

Now that we can have percpu xfrm states, the number of active
states might increase. To get a better lookup performance,
we add a percpu cache to cache the used inbound xfrm states.

Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Tested-by: Antony Antony <antony.antony@secunet.com>
Tested-by: Tobias Brunner <tobias@strongswan.org>
Stable-dep-of: e952837f3ddb ("xfrm: state: fix out-of-bounds read during lookup")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netns/xfrm.h |  1 +
 include/net/xfrm.h       |  5 ++++
 net/ipv4/esp4_offload.c  |  6 ++---
 net/ipv6/esp6_offload.c  |  6 ++---
 net/xfrm/xfrm_input.c    |  2 +-
 net/xfrm/xfrm_state.c    | 57 ++++++++++++++++++++++++++++++++++++++++
 6 files changed, 70 insertions(+), 7 deletions(-)

diff --git a/include/net/netns/xfrm.h b/include/net/netns/xfrm.h
index ae60d66640954..23dd647fe0248 100644
--- a/include/net/netns/xfrm.h
+++ b/include/net/netns/xfrm.h
@@ -43,6 +43,7 @@ struct netns_xfrm {
 	struct hlist_head	__rcu *state_bysrc;
 	struct hlist_head	__rcu *state_byspi;
 	struct hlist_head	__rcu *state_byseq;
+	struct hlist_head	 __percpu *state_cache_input;
 	unsigned int		state_hmask;
 	unsigned int		state_num;
 	struct work_struct	state_hash_work;
diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 0b394c5fb5f3a..2b87999bd5aae 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -185,6 +185,7 @@ struct xfrm_state {
 	struct hlist_node	byspi;
 	struct hlist_node	byseq;
 	struct hlist_node	state_cache;
+	struct hlist_node	state_cache_input;
 
 	refcount_t		refcnt;
 	spinlock_t		lock;
@@ -1650,6 +1651,10 @@ int xfrm_state_update(struct xfrm_state *x);
 struct xfrm_state *xfrm_state_lookup(struct net *net, u32 mark,
 				     const xfrm_address_t *daddr, __be32 spi,
 				     u8 proto, unsigned short family);
+struct xfrm_state *xfrm_input_state_lookup(struct net *net, u32 mark,
+					   const xfrm_address_t *daddr,
+					   __be32 spi, u8 proto,
+					   unsigned short family);
 struct xfrm_state *xfrm_state_lookup_byaddr(struct net *net, u32 mark,
 					    const xfrm_address_t *daddr,
 					    const xfrm_address_t *saddr,
diff --git a/net/ipv4/esp4_offload.c b/net/ipv4/esp4_offload.c
index 80c4ea0e12f48..e0d94270da28a 100644
--- a/net/ipv4/esp4_offload.c
+++ b/net/ipv4/esp4_offload.c
@@ -53,9 +53,9 @@ static struct sk_buff *esp4_gro_receive(struct list_head *head,
 		if (sp->len == XFRM_MAX_DEPTH)
 			goto out_reset;
 
-		x = xfrm_state_lookup(dev_net(skb->dev), skb->mark,
-				      (xfrm_address_t *)&ip_hdr(skb)->daddr,
-				      spi, IPPROTO_ESP, AF_INET);
+		x = xfrm_input_state_lookup(dev_net(skb->dev), skb->mark,
+					    (xfrm_address_t *)&ip_hdr(skb)->daddr,
+					    spi, IPPROTO_ESP, AF_INET);
 
 		if (unlikely(x && x->dir && x->dir != XFRM_SA_DIR_IN)) {
 			/* non-offload path will record the error and audit log */
diff --git a/net/ipv6/esp6_offload.c b/net/ipv6/esp6_offload.c
index 919ebfabbe4ee..7b41fb4f00b58 100644
--- a/net/ipv6/esp6_offload.c
+++ b/net/ipv6/esp6_offload.c
@@ -80,9 +80,9 @@ static struct sk_buff *esp6_gro_receive(struct list_head *head,
 		if (sp->len == XFRM_MAX_DEPTH)
 			goto out_reset;
 
-		x = xfrm_state_lookup(dev_net(skb->dev), skb->mark,
-				      (xfrm_address_t *)&ipv6_hdr(skb)->daddr,
-				      spi, IPPROTO_ESP, AF_INET6);
+		x = xfrm_input_state_lookup(dev_net(skb->dev), skb->mark,
+					    (xfrm_address_t *)&ipv6_hdr(skb)->daddr,
+					    spi, IPPROTO_ESP, AF_INET6);
 
 		if (unlikely(x && x->dir && x->dir != XFRM_SA_DIR_IN)) {
 			/* non-offload path will record the error and audit log */
diff --git a/net/xfrm/xfrm_input.c b/net/xfrm/xfrm_input.c
index 749e7eea99e46..841a60a6fbfea 100644
--- a/net/xfrm/xfrm_input.c
+++ b/net/xfrm/xfrm_input.c
@@ -572,7 +572,7 @@ int xfrm_input(struct sk_buff *skb, int nexthdr, __be32 spi, int encap_type)
 			goto drop;
 		}
 
-		x = xfrm_state_lookup(net, mark, daddr, spi, nexthdr, family);
+		x = xfrm_input_state_lookup(net, mark, daddr, spi, nexthdr, family);
 		if (x == NULL) {
 			secpath_reset(skb);
 			XFRM_INC_STATS(net, LINUX_MIB_XFRMINNOSTATES);
diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index a2047825f6c88..e3266a5d4f90d 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -754,6 +754,9 @@ int __xfrm_state_delete(struct xfrm_state *x)
 			hlist_del_rcu(&x->byseq);
 		if (!hlist_unhashed(&x->state_cache))
 			hlist_del_rcu(&x->state_cache);
+		if (!hlist_unhashed(&x->state_cache_input))
+			hlist_del_rcu(&x->state_cache_input);
+
 		if (x->id.spi)
 			hlist_del_rcu(&x->byspi);
 		net->xfrm.state_num--;
@@ -1106,6 +1109,52 @@ static struct xfrm_state *__xfrm_state_lookup(struct net *net, u32 mark,
 	return NULL;
 }
 
+struct xfrm_state *xfrm_input_state_lookup(struct net *net, u32 mark,
+					   const xfrm_address_t *daddr,
+					   __be32 spi, u8 proto,
+					   unsigned short family)
+{
+	struct hlist_head *state_cache_input;
+	struct xfrm_state *x = NULL;
+	int cpu = get_cpu();
+
+	state_cache_input =  per_cpu_ptr(net->xfrm.state_cache_input, cpu);
+
+	rcu_read_lock();
+	hlist_for_each_entry_rcu(x, state_cache_input, state_cache_input) {
+		if (x->props.family != family ||
+		    x->id.spi       != spi ||
+		    x->id.proto     != proto ||
+		    !xfrm_addr_equal(&x->id.daddr, daddr, family))
+			continue;
+
+		if ((mark & x->mark.m) != x->mark.v)
+			continue;
+		if (!xfrm_state_hold_rcu(x))
+			continue;
+		goto out;
+	}
+
+	x = __xfrm_state_lookup(net, mark, daddr, spi, proto, family);
+
+	if (x && x->km.state == XFRM_STATE_VALID) {
+		spin_lock_bh(&net->xfrm.xfrm_state_lock);
+		if (hlist_unhashed(&x->state_cache_input)) {
+			hlist_add_head_rcu(&x->state_cache_input, state_cache_input);
+		} else {
+			hlist_del_rcu(&x->state_cache_input);
+			hlist_add_head_rcu(&x->state_cache_input, state_cache_input);
+		}
+		spin_unlock_bh(&net->xfrm.xfrm_state_lock);
+	}
+
+out:
+	rcu_read_unlock();
+	put_cpu();
+	return x;
+}
+EXPORT_SYMBOL(xfrm_input_state_lookup);
+
 static struct xfrm_state *__xfrm_state_lookup_byaddr(struct net *net, u32 mark,
 						     const xfrm_address_t *daddr,
 						     const xfrm_address_t *saddr,
@@ -3079,6 +3128,11 @@ int __net_init xfrm_state_init(struct net *net)
 	net->xfrm.state_byseq = xfrm_hash_alloc(sz);
 	if (!net->xfrm.state_byseq)
 		goto out_byseq;
+
+	net->xfrm.state_cache_input = alloc_percpu(struct hlist_head);
+	if (!net->xfrm.state_cache_input)
+		goto out_state_cache_input;
+
 	net->xfrm.state_hmask = ((sz / sizeof(struct hlist_head)) - 1);
 
 	net->xfrm.state_num = 0;
@@ -3088,6 +3142,8 @@ int __net_init xfrm_state_init(struct net *net)
 			       &net->xfrm.xfrm_state_lock);
 	return 0;
 
+out_state_cache_input:
+	xfrm_hash_free(net->xfrm.state_byseq, sz);
 out_byseq:
 	xfrm_hash_free(net->xfrm.state_byspi, sz);
 out_byspi:
@@ -3117,6 +3173,7 @@ void xfrm_state_fini(struct net *net)
 	xfrm_hash_free(net->xfrm.state_bysrc, sz);
 	WARN_ON(!hlist_empty(net->xfrm.state_bydst));
 	xfrm_hash_free(net->xfrm.state_bydst, sz);
+	free_percpu(net->xfrm.state_cache_input);
 }
 
 #ifdef CONFIG_AUDITSYSCALL
-- 
2.39.5



