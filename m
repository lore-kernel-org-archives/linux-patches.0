Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 507051DC9B3;
	Wed,  5 Feb 2025 14:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767470; cv=none; b=VBVY2FPaBQ/DP5jflqOg2ZaaYXji4dDFBXib1TvDDaUsDqNhpuAH75aSLdSnYRWzCXNgGAdm1g+A/4kZ0IeAzQ+82+vpDnVaLJRdqKds4SqXIC23puf068bw3r9+wZIrvP3w33icInKalKMBiOfzlmAjWwc/58aJqlHPq8iNxZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767470; c=relaxed/simple;
	bh=U8NH2J9ZVSwJDTxHYOTx2XDO2KLZnUvUYig1Sav1nvs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LRH1sDjLSpTQeskSHA4ycRKL4WJacQS9dmtbXB3DEU7fSDP7Fc+lRnQ/s6VLhpTM1IOWsO/+92Nk7xDGrBMZWDMPhIrvX/8pyldgJDunuBoVwuEfA3139ZVwt6b3t4ajhyz3WPGlkH9nxl44Hv4Mx4tANILzgE/nzzcWWefIosQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hwT9eUzI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hwT9eUzI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB8A5C4CED6;
	Wed,  5 Feb 2025 14:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767470;
	bh=U8NH2J9ZVSwJDTxHYOTx2XDO2KLZnUvUYig1Sav1nvs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hwT9eUzIHpIzfB7Uu7TNr9WDzRsQzBkq2WBIYm1qMosIb5poDLdUrhPX+5LSm3fgY
	 eNSU0gyTEvl24cQEVBLIVyvKNXy6zYK9x1fI6NWEdhYX7vKcP9IvJzsyVTHApGKF6l
	 xhCmwIi5snY5eASZARR2lYMmcz754dmKkFEDnY6k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+5f9f31cb7d985f584d8e@syzkaller.appspotmail.com,
	Florian Westphal <fw@strlen.de>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>,
	Dmitry Vyukov <dvyukov@google.com>
Subject: [PATCH 6.12 461/590] xfrm: state: fix out-of-bounds read during lookup
Date: Wed,  5 Feb 2025 14:43:36 +0100
Message-ID: <20250205134512.899372884@linuxfoundation.org>
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

From: Florian Westphal <fw@strlen.de>

[ Upstream commit e952837f3ddb0ff726d5b582aa1aad9aa38d024d ]

lookup and resize can run in parallel.

The xfrm_state_hash_generation seqlock ensures a retry, but the hash
functions can observe a hmask value that is too large for the new hlist
array.

rehash does:
  rcu_assign_pointer(net->xfrm.state_bydst, ndst) [..]
  net->xfrm.state_hmask = nhashmask;

While state lookup does:
  h = xfrm_dst_hash(net, daddr, saddr, tmpl->reqid, encap_family);
  hlist_for_each_entry_rcu(x, net->xfrm.state_bydst + h, bydst) {

This is only safe in case the update to state_bydst is larger than
net->xfrm.xfrm_state_hmask (or if the lookup function gets
serialized via state spinlock again).

Fix this by prefetching state_hmask and the associated pointers.
The xfrm_state_hash_generation seqlock retry will ensure that the pointer
and the hmask will be consistent.

The existing helpers, like xfrm_dst_hash(), are now unsafe for RCU side,
add lockdep assertions to document that they are only safe for insert
side.

xfrm_state_lookup_byaddr() uses the spinlock rather than RCU.
AFAICS this is an oversight from back when state lookup was converted to
RCU, this lock should be replaced with RCU in a future patch.

Reported-by: syzbot+5f9f31cb7d985f584d8e@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/CACT4Y+azwfrE3uz6A5ZErov5YN2LYBN5KrsymBerT36VU8qzBA@mail.gmail.com/
Diagnosed-by: Dmitry Vyukov <dvyukov@google.com>
Fixes: c2f672fc9464 ("xfrm: state lookup can be lockless")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_state.c | 89 ++++++++++++++++++++++++++++++++++---------
 1 file changed, 70 insertions(+), 19 deletions(-)

diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index e3266a5d4f90d..567f02ff88597 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -34,6 +34,8 @@
 
 #define xfrm_state_deref_prot(table, net) \
 	rcu_dereference_protected((table), lockdep_is_held(&(net)->xfrm.xfrm_state_lock))
+#define xfrm_state_deref_check(table, net) \
+	rcu_dereference_check((table), lockdep_is_held(&(net)->xfrm.xfrm_state_lock))
 
 static void xfrm_state_gc_task(struct work_struct *work);
 
@@ -62,6 +64,8 @@ static inline unsigned int xfrm_dst_hash(struct net *net,
 					 u32 reqid,
 					 unsigned short family)
 {
+	lockdep_assert_held(&net->xfrm.xfrm_state_lock);
+
 	return __xfrm_dst_hash(daddr, saddr, reqid, family, net->xfrm.state_hmask);
 }
 
@@ -70,6 +74,8 @@ static inline unsigned int xfrm_src_hash(struct net *net,
 					 const xfrm_address_t *saddr,
 					 unsigned short family)
 {
+	lockdep_assert_held(&net->xfrm.xfrm_state_lock);
+
 	return __xfrm_src_hash(daddr, saddr, family, net->xfrm.state_hmask);
 }
 
@@ -77,11 +83,15 @@ static inline unsigned int
 xfrm_spi_hash(struct net *net, const xfrm_address_t *daddr,
 	      __be32 spi, u8 proto, unsigned short family)
 {
+	lockdep_assert_held(&net->xfrm.xfrm_state_lock);
+
 	return __xfrm_spi_hash(daddr, spi, proto, family, net->xfrm.state_hmask);
 }
 
 static unsigned int xfrm_seq_hash(struct net *net, u32 seq)
 {
+	lockdep_assert_held(&net->xfrm.xfrm_state_lock);
+
 	return __xfrm_seq_hash(seq, net->xfrm.state_hmask);
 }
 
@@ -1041,16 +1051,38 @@ xfrm_init_tempstate(struct xfrm_state *x, const struct flowi *fl,
 	x->props.family = tmpl->encap_family;
 }
 
-static struct xfrm_state *__xfrm_state_lookup_all(struct net *net, u32 mark,
+struct xfrm_hash_state_ptrs {
+	const struct hlist_head *bydst;
+	const struct hlist_head *bysrc;
+	const struct hlist_head *byspi;
+	unsigned int hmask;
+};
+
+static void xfrm_hash_ptrs_get(const struct net *net, struct xfrm_hash_state_ptrs *ptrs)
+{
+	unsigned int sequence;
+
+	do {
+		sequence = read_seqcount_begin(&net->xfrm.xfrm_state_hash_generation);
+
+		ptrs->bydst = xfrm_state_deref_check(net->xfrm.state_bydst, net);
+		ptrs->bysrc = xfrm_state_deref_check(net->xfrm.state_bysrc, net);
+		ptrs->byspi = xfrm_state_deref_check(net->xfrm.state_byspi, net);
+		ptrs->hmask = net->xfrm.state_hmask;
+	} while (read_seqcount_retry(&net->xfrm.xfrm_state_hash_generation, sequence));
+}
+
+static struct xfrm_state *__xfrm_state_lookup_all(const struct xfrm_hash_state_ptrs *state_ptrs,
+						  u32 mark,
 						  const xfrm_address_t *daddr,
 						  __be32 spi, u8 proto,
 						  unsigned short family,
 						  struct xfrm_dev_offload *xdo)
 {
-	unsigned int h = xfrm_spi_hash(net, daddr, spi, proto, family);
+	unsigned int h = __xfrm_spi_hash(daddr, spi, proto, family, state_ptrs->hmask);
 	struct xfrm_state *x;
 
-	hlist_for_each_entry_rcu(x, net->xfrm.state_byspi + h, byspi) {
+	hlist_for_each_entry_rcu(x, state_ptrs->byspi + h, byspi) {
 #ifdef CONFIG_XFRM_OFFLOAD
 		if (xdo->type == XFRM_DEV_OFFLOAD_PACKET) {
 			if (x->xso.type != XFRM_DEV_OFFLOAD_PACKET)
@@ -1084,15 +1116,16 @@ static struct xfrm_state *__xfrm_state_lookup_all(struct net *net, u32 mark,
 	return NULL;
 }
 
-static struct xfrm_state *__xfrm_state_lookup(struct net *net, u32 mark,
+static struct xfrm_state *__xfrm_state_lookup(const struct xfrm_hash_state_ptrs *state_ptrs,
+					      u32 mark,
 					      const xfrm_address_t *daddr,
 					      __be32 spi, u8 proto,
 					      unsigned short family)
 {
-	unsigned int h = xfrm_spi_hash(net, daddr, spi, proto, family);
+	unsigned int h = __xfrm_spi_hash(daddr, spi, proto, family, state_ptrs->hmask);
 	struct xfrm_state *x;
 
-	hlist_for_each_entry_rcu(x, net->xfrm.state_byspi + h, byspi) {
+	hlist_for_each_entry_rcu(x, state_ptrs->byspi + h, byspi) {
 		if (x->props.family != family ||
 		    x->id.spi       != spi ||
 		    x->id.proto     != proto ||
@@ -1114,6 +1147,7 @@ struct xfrm_state *xfrm_input_state_lookup(struct net *net, u32 mark,
 					   __be32 spi, u8 proto,
 					   unsigned short family)
 {
+	struct xfrm_hash_state_ptrs state_ptrs;
 	struct hlist_head *state_cache_input;
 	struct xfrm_state *x = NULL;
 	int cpu = get_cpu();
@@ -1135,7 +1169,9 @@ struct xfrm_state *xfrm_input_state_lookup(struct net *net, u32 mark,
 		goto out;
 	}
 
-	x = __xfrm_state_lookup(net, mark, daddr, spi, proto, family);
+	xfrm_hash_ptrs_get(net, &state_ptrs);
+
+	x = __xfrm_state_lookup(&state_ptrs, mark, daddr, spi, proto, family);
 
 	if (x && x->km.state == XFRM_STATE_VALID) {
 		spin_lock_bh(&net->xfrm.xfrm_state_lock);
@@ -1155,15 +1191,16 @@ struct xfrm_state *xfrm_input_state_lookup(struct net *net, u32 mark,
 }
 EXPORT_SYMBOL(xfrm_input_state_lookup);
 
-static struct xfrm_state *__xfrm_state_lookup_byaddr(struct net *net, u32 mark,
+static struct xfrm_state *__xfrm_state_lookup_byaddr(const struct xfrm_hash_state_ptrs *state_ptrs,
+						     u32 mark,
 						     const xfrm_address_t *daddr,
 						     const xfrm_address_t *saddr,
 						     u8 proto, unsigned short family)
 {
-	unsigned int h = xfrm_src_hash(net, daddr, saddr, family);
+	unsigned int h = __xfrm_src_hash(daddr, saddr, family, state_ptrs->hmask);
 	struct xfrm_state *x;
 
-	hlist_for_each_entry_rcu(x, net->xfrm.state_bysrc + h, bysrc) {
+	hlist_for_each_entry_rcu(x, state_ptrs->bysrc + h, bysrc) {
 		if (x->props.family != family ||
 		    x->id.proto     != proto ||
 		    !xfrm_addr_equal(&x->id.daddr, daddr, family) ||
@@ -1183,14 +1220,17 @@ static struct xfrm_state *__xfrm_state_lookup_byaddr(struct net *net, u32 mark,
 static inline struct xfrm_state *
 __xfrm_state_locate(struct xfrm_state *x, int use_spi, int family)
 {
+	struct xfrm_hash_state_ptrs state_ptrs;
 	struct net *net = xs_net(x);
 	u32 mark = x->mark.v & x->mark.m;
 
+	xfrm_hash_ptrs_get(net, &state_ptrs);
+
 	if (use_spi)
-		return __xfrm_state_lookup(net, mark, &x->id.daddr,
+		return __xfrm_state_lookup(&state_ptrs, mark, &x->id.daddr,
 					   x->id.spi, x->id.proto, family);
 	else
-		return __xfrm_state_lookup_byaddr(net, mark,
+		return __xfrm_state_lookup_byaddr(&state_ptrs, mark,
 						  &x->id.daddr,
 						  &x->props.saddr,
 						  x->id.proto, family);
@@ -1264,6 +1304,7 @@ xfrm_state_find(const xfrm_address_t *daddr, const xfrm_address_t *saddr,
 		unsigned short family, u32 if_id)
 {
 	static xfrm_address_t saddr_wildcard = { };
+	struct xfrm_hash_state_ptrs state_ptrs;
 	struct net *net = xp_net(pol);
 	unsigned int h, h_wildcard;
 	struct xfrm_state *x, *x0, *to_put;
@@ -1328,8 +1369,10 @@ xfrm_state_find(const xfrm_address_t *daddr, const xfrm_address_t *saddr,
 	else if (acquire_in_progress) /* XXX: acquire_in_progress should not happen */
 		WARN_ON(1);
 
-	h = xfrm_dst_hash(net, daddr, saddr, tmpl->reqid, encap_family);
-	hlist_for_each_entry_rcu(x, net->xfrm.state_bydst + h, bydst) {
+	xfrm_hash_ptrs_get(net, &state_ptrs);
+
+	h = __xfrm_dst_hash(daddr, saddr, tmpl->reqid, encap_family, state_ptrs.hmask);
+	hlist_for_each_entry_rcu(x, state_ptrs.bydst + h, bydst) {
 #ifdef CONFIG_XFRM_OFFLOAD
 		if (pol->xdo.type == XFRM_DEV_OFFLOAD_PACKET) {
 			if (x->xso.type != XFRM_DEV_OFFLOAD_PACKET)
@@ -1362,8 +1405,9 @@ xfrm_state_find(const xfrm_address_t *daddr, const xfrm_address_t *saddr,
 	if (best || acquire_in_progress)
 		goto found;
 
-	h_wildcard = xfrm_dst_hash(net, daddr, &saddr_wildcard, tmpl->reqid, encap_family);
-	hlist_for_each_entry_rcu(x, net->xfrm.state_bydst + h_wildcard, bydst) {
+	h_wildcard = __xfrm_dst_hash(daddr, &saddr_wildcard, tmpl->reqid,
+				     encap_family, state_ptrs.hmask);
+	hlist_for_each_entry_rcu(x, state_ptrs.bydst + h_wildcard, bydst) {
 #ifdef CONFIG_XFRM_OFFLOAD
 		if (pol->xdo.type == XFRM_DEV_OFFLOAD_PACKET) {
 			if (x->xso.type != XFRM_DEV_OFFLOAD_PACKET)
@@ -1401,7 +1445,7 @@ xfrm_state_find(const xfrm_address_t *daddr, const xfrm_address_t *saddr,
 
 	if (!x && !error && !acquire_in_progress) {
 		if (tmpl->id.spi &&
-		    (x0 = __xfrm_state_lookup_all(net, mark, daddr,
+		    (x0 = __xfrm_state_lookup_all(&state_ptrs, mark, daddr,
 						  tmpl->id.spi, tmpl->id.proto,
 						  encap_family,
 						  &pol->xdo)) != NULL) {
@@ -2179,10 +2223,13 @@ struct xfrm_state *
 xfrm_state_lookup(struct net *net, u32 mark, const xfrm_address_t *daddr, __be32 spi,
 		  u8 proto, unsigned short family)
 {
+	struct xfrm_hash_state_ptrs state_ptrs;
 	struct xfrm_state *x;
 
 	rcu_read_lock();
-	x = __xfrm_state_lookup(net, mark, daddr, spi, proto, family);
+	xfrm_hash_ptrs_get(net, &state_ptrs);
+
+	x = __xfrm_state_lookup(&state_ptrs, mark, daddr, spi, proto, family);
 	rcu_read_unlock();
 	return x;
 }
@@ -2193,10 +2240,14 @@ xfrm_state_lookup_byaddr(struct net *net, u32 mark,
 			 const xfrm_address_t *daddr, const xfrm_address_t *saddr,
 			 u8 proto, unsigned short family)
 {
+	struct xfrm_hash_state_ptrs state_ptrs;
 	struct xfrm_state *x;
 
 	spin_lock_bh(&net->xfrm.xfrm_state_lock);
-	x = __xfrm_state_lookup_byaddr(net, mark, daddr, saddr, proto, family);
+
+	xfrm_hash_ptrs_get(net, &state_ptrs);
+
+	x = __xfrm_state_lookup_byaddr(&state_ptrs, mark, daddr, saddr, proto, family);
 	spin_unlock_bh(&net->xfrm.xfrm_state_lock);
 	return x;
 }
-- 
2.39.5



