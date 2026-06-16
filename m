Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7801832E728;
	Tue, 16 Jun 2026 17:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781631246; cv=none; b=gv7a9KHg6V7cS4fmP8VZNYf60WyTs29c8gHXXGDN/B4HJuHfp/C1LqjYuTbwQNinx8YLx3eESnKlWD6HaiOb/jQGz2jmTU63kc3oYNSu3rs+Kb243PR05qeompnGSpW3GJVZMJPeYYg/WkGaUszXOVOzffRgNn/vOQykZNUwxoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781631246; c=relaxed/simple;
	bh=Gi5mUBpqVK+d3T8hOoeQapHx/v3pkKCkhiMk2RWlLu0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MJ6/z5fH4iGf5dkTRK7QEnRMqdOvqnMvtxOmL+Nfb0iiY55rbx2z9pG07rZ6PdX62QR9Ux9ddy1srzVViBf6kzNUpH5+c0usM4RiJFhbiPFhrZiQqkcCPrQa2Ox0O0E/00XXLzjMTIT26Bsk7YL6Trzy3JdKCpYJKIiVn0elSU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lalzleqK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lalzleqK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 627C61F000E9;
	Tue, 16 Jun 2026 17:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781631245;
	bh=ZaSHEvXSaP8dh88dTbdQc7VNaTEyil2h0QIw5n2plto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lalzleqKzp+jf/W2DpYWj8r04tOzGB+B9L1jcMKyai6XXO8ClV9NwHTmovSoqBkDh
	 r38ZrGunhboC0tXmx8VSmi1UOBBlCHgyEnLaKKtrGwjyiazfBIv/UN8BMsNiWRy0jh
	 pxzjumSDgBbfAC5RvVZG27OFSj4AudruBi6x7Qic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Vegard Nossum <vegard.nossum@oracle.com>,
	Jakub Acs <acsjakub@amazon.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 185/522] netfilter: nf_tables: restore set elements when delete set fails
Date: Tue, 16 Jun 2026 20:25:32 +0530
Message-ID: <20260616145134.771219230@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit e79b47a8615d42c68aaeb68971593333667382ed ]

>From abort path, nft_mapelem_activate() needs to restore refcounters to
the original state. Currently, it uses the set->ops->walk() to iterate
over these set elements. The existing set iterator skips inactive
elements in the next generation, this does not work from the abort path
to restore the original state since it has to skip active elements
instead (not inactive ones).

This patch moves the check for inactive elements to the set iterator
callback, then it reverses the logic for the .activate case which
needs to skip active elements.

Toggle next generation bit for elements when delete set command is
invoked and call nft_clear() from .activate (abort) path to restore the
next generation bit.

The splat below shows an object in mappings memleak:

[43929.457523] ------------[ cut here ]------------
[43929.457532] WARNING: CPU: 0 PID: 1139 at include/net/netfilter/nf_tables.h:1237 nft_setelem_data_deactivate+0xe4/0xf0 [nf_tables]
[...]
[43929.458014] RIP: 0010:nft_setelem_data_deactivate+0xe4/0xf0 [nf_tables]
[43929.458076] Code: 83 f8 01 77 ab 49 8d 7c 24 08 e8 37 5e d0 de 49 8b 6c 24 08 48 8d 7d 50 e8 e9 5c d0 de 8b 45 50 8d 50 ff 89 55 50 85 c0 75 86 <0f> 0b eb 82 0f 0b eb b3 0f 1f 40 00 90 90 90 90 90 90 90 90 90 90
[43929.458081] RSP: 0018:ffff888140f9f4b0 EFLAGS: 00010246
[43929.458086] RAX: 0000000000000000 RBX: ffff8881434f5288 RCX: dffffc0000000000
[43929.458090] RDX: 00000000ffffffff RSI: ffffffffa26d28a7 RDI: ffff88810ecc9550
[43929.458093] RBP: ffff88810ecc9500 R08: 0000000000000001 R09: ffffed10281f3e8f
[43929.458096] R10: 0000000000000003 R11: ffff0000ffff0000 R12: ffff8881434f52a0
[43929.458100] R13: ffff888140f9f5f4 R14: ffff888151c7a800 R15: 0000000000000002
[43929.458103] FS:  00007f0c687c4740(0000) GS:ffff888390800000(0000) knlGS:0000000000000000
[43929.458107] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[43929.458111] CR2: 00007f58dbe5b008 CR3: 0000000123602005 CR4: 00000000001706f0
[43929.458114] Call Trace:
[43929.458118]  <TASK>
[43929.458121]  ? __warn+0x9f/0x1a0
[43929.458127]  ? nft_setelem_data_deactivate+0xe4/0xf0 [nf_tables]
[43929.458188]  ? report_bug+0x1b1/0x1e0
[43929.458196]  ? handle_bug+0x3c/0x70
[43929.458200]  ? exc_invalid_op+0x17/0x40
[43929.458211]  ? nft_setelem_data_deactivate+0xd7/0xf0 [nf_tables]
[43929.458271]  ? nft_setelem_data_deactivate+0xe4/0xf0 [nf_tables]
[43929.458332]  nft_mapelem_deactivate+0x24/0x30 [nf_tables]
[43929.458392]  nft_rhash_walk+0xdd/0x180 [nf_tables]
[43929.458453]  ? __pfx_nft_rhash_walk+0x10/0x10 [nf_tables]
[43929.458512]  ? rb_insert_color+0x2e/0x280
[43929.458520]  nft_map_deactivate+0xdc/0x1e0 [nf_tables]
[43929.458582]  ? __pfx_nft_map_deactivate+0x10/0x10 [nf_tables]
[43929.458642]  ? __pfx_nft_mapelem_deactivate+0x10/0x10 [nf_tables]
[43929.458701]  ? __rcu_read_unlock+0x46/0x70
[43929.458709]  nft_delset+0xff/0x110 [nf_tables]
[43929.458769]  nft_flush_table+0x16f/0x460 [nf_tables]
[43929.458830]  nf_tables_deltable+0x501/0x580 [nf_tables]

Fixes: 628bd3e49cba ("netfilter: nf_tables: drop map element references from preparation phase")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
(cherry picked from commit e79b47a8615d42c68aaeb68971593333667382ed)
[Vegard: CVE-2024-27012; fixed conflicts due to missing commits
 0e1ea651c9717ddcd8e0648d8468477a31867b0a ("netfilter: nf_tables: shrink
 memory consumption of set elements") and
 9dad402b89e81a0516bad5e0ac009b7a0a80898f ("netfilter: nf_tables: expose
 opaque set element as struct nft_elem_priv") so we pass the correct types
 and values to nft_setelem_data_deactivate(), nft_setelem_validate(),
 nft_set_elem_ext(), etc.]
Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[acsjakub: clean cherry-pick of the commit 164936b2fc88
 ("netfilter: nf_tables: restore set elements when delete set fails")
 from 6.6.y. Plus, add "[ Upstream commit .." header to the message]
Signed-off-by: Jakub Acs <acsjakub@amazon.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c  | 41 ++++++++++++++++++++++++++++++----
 net/netfilter/nft_set_bitmap.c |  4 +---
 net/netfilter/nft_set_hash.c   |  8 ++-----
 net/netfilter/nft_set_pipapo.c |  5 +----
 net/netfilter/nft_set_rbtree.c |  4 +---
 5 files changed, 42 insertions(+), 20 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 0c422428263873..201e2cc0453992 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -594,6 +594,12 @@ static int nft_mapelem_deactivate(const struct nft_ctx *ctx,
 				  const struct nft_set_iter *iter,
 				  struct nft_set_elem *elem)
 {
+	struct nft_set_ext *ext = nft_set_elem_ext(set, elem->priv);
+
+	if (!nft_set_elem_active(ext, iter->genmask))
+		return 0;
+
+	nft_set_elem_change_active(ctx->net, set, ext);
 	nft_setelem_data_deactivate(ctx->net, set, elem);
 
 	return 0;
@@ -619,6 +625,7 @@ static void nft_map_catchall_deactivate(const struct nft_ctx *ctx,
 			continue;
 
 		elem.priv = catchall->elem;
+		nft_set_elem_change_active(ctx->net, set, ext);
 		nft_setelem_data_deactivate(ctx->net, set, &elem);
 		break;
 	}
@@ -3593,6 +3600,9 @@ int nft_setelem_validate(const struct nft_ctx *ctx, struct nft_set *set,
 	const struct nft_data *data;
 	int err;
 
+	if (!nft_set_elem_active(ext, iter->genmask))
+		return 0;
+
 	if (nft_set_ext_exists(ext, NFT_SET_EXT_FLAGS) &&
 	    *nft_set_ext_flags(ext) & NFT_SET_ELEM_INTERVAL_END)
 		return 0;
@@ -3616,19 +3626,22 @@ int nft_setelem_validate(const struct nft_ctx *ctx, struct nft_set *set,
 
 int nft_set_catchall_validate(const struct nft_ctx *ctx, struct nft_set *set)
 {
-	u8 genmask = nft_genmask_next(ctx->net);
+	struct nft_set_iter dummy_iter = {
+		.genmask	= nft_genmask_next(ctx->net),
+	};
 	struct nft_set_elem_catchall *catchall;
 	struct nft_set_elem elem;
+
 	struct nft_set_ext *ext;
 	int ret = 0;
 
 	list_for_each_entry_rcu(catchall, &set->catchall_list, list) {
 		ext = nft_set_elem_ext(set, catchall->elem);
-		if (!nft_set_elem_active(ext, genmask))
+		if (!nft_set_elem_active(ext, dummy_iter.genmask))
 			continue;
 
 		elem.priv = catchall->elem;
-		ret = nft_setelem_validate(ctx, set, NULL, &elem);
+		ret = nft_setelem_validate(ctx, set, &dummy_iter, &elem);
 		if (ret < 0)
 			return ret;
 	}
@@ -5103,6 +5116,11 @@ static int nf_tables_bind_check_setelem(const struct nft_ctx *ctx,
 					const struct nft_set_iter *iter,
 					struct nft_set_elem *elem)
 {
+	const struct nft_set_ext *ext = nft_set_elem_ext(set, elem->priv);
+
+	if (!nft_set_elem_active(ext, iter->genmask))
+		return 0;
+
 	return nft_setelem_data_validate(ctx, set, elem);
 }
 
@@ -5197,6 +5215,13 @@ static int nft_mapelem_activate(const struct nft_ctx *ctx,
 				const struct nft_set_iter *iter,
 				struct nft_set_elem *elem)
 {
+	struct nft_set_ext *ext = nft_set_elem_ext(set, elem->priv);
+
+	/* called from abort path, reverse check to undo changes. */
+	if (nft_set_elem_active(ext, iter->genmask))
+		return 0;
+
+	nft_clear(ctx->net, ext);
 	nft_setelem_data_activate(ctx->net, set, elem);
 
 	return 0;
@@ -5215,6 +5240,7 @@ static void nft_map_catchall_activate(const struct nft_ctx *ctx,
 		if (nft_set_elem_active(ext, genmask))
 			continue;
 
+		nft_clear(ctx->net, ext);
 		elem.priv = catchall->elem;
 		nft_setelem_data_activate(ctx->net, set, &elem);
 		break;
@@ -5488,6 +5514,9 @@ static int nf_tables_dump_setelem(const struct nft_ctx *ctx,
 	const struct nft_set_ext *ext = nft_set_elem_ext(set, elem->priv);
 	struct nft_set_dump_args *args;
 
+	if (!nft_set_elem_active(ext, iter->genmask))
+		return 0;
+
 	if (nft_set_elem_expired(ext) || nft_set_elem_is_dead(ext))
 		return 0;
 
@@ -6220,7 +6249,7 @@ static void nft_setelem_activate(struct net *net, struct nft_set *set,
 	struct nft_set_ext *ext = nft_set_elem_ext(set, elem->priv);
 
 	if (nft_setelem_is_catchall(set, elem)) {
-		nft_set_elem_change_active(net, set, ext);
+		nft_clear(net, ext);
 	} else {
 		set->ops->activate(net, set, elem);
 	}
@@ -6902,9 +6931,13 @@ static int nft_setelem_flush(const struct nft_ctx *ctx,
 			     const struct nft_set_iter *iter,
 			     struct nft_set_elem *elem)
 {
+	const struct nft_set_ext *ext = nft_set_elem_ext(set, elem->priv);
 	struct nft_trans *trans;
 	int err;
 
+	if (!nft_set_elem_active(ext, iter->genmask))
+		return 0;
+
 	trans = nft_trans_alloc_gfp(ctx, NFT_MSG_DELSETELEM,
 				    sizeof(struct nft_trans_elem), GFP_ATOMIC);
 	if (!trans)
diff --git a/net/netfilter/nft_set_bitmap.c b/net/netfilter/nft_set_bitmap.c
index 1e5e7a181e0bc2..cbf7f7825f1b88 100644
--- a/net/netfilter/nft_set_bitmap.c
+++ b/net/netfilter/nft_set_bitmap.c
@@ -171,7 +171,7 @@ static void nft_bitmap_activate(const struct net *net,
 	nft_bitmap_location(set, nft_set_ext_key(&be->ext), &idx, &off);
 	/* Enter 11 state. */
 	priv->bitmap[idx] |= (genmask << off);
-	nft_set_elem_change_active(net, set, &be->ext);
+	nft_clear(net, &be->ext);
 }
 
 static bool nft_bitmap_flush(const struct net *net,
@@ -223,8 +223,6 @@ static void nft_bitmap_walk(const struct nft_ctx *ctx,
 	list_for_each_entry_rcu(be, &priv->list, head) {
 		if (iter->count < iter->skip)
 			goto cont;
-		if (!nft_set_elem_active(&be->ext, iter->genmask))
-			goto cont;
 
 		elem.priv = be;
 
diff --git a/net/netfilter/nft_set_hash.c b/net/netfilter/nft_set_hash.c
index 9ea4a09903186d..5a74ee4b7dfb35 100644
--- a/net/netfilter/nft_set_hash.c
+++ b/net/netfilter/nft_set_hash.c
@@ -196,7 +196,7 @@ static void nft_rhash_activate(const struct net *net, const struct nft_set *set,
 {
 	struct nft_rhash_elem *he = elem->priv;
 
-	nft_set_elem_change_active(net, set, &he->ext);
+	nft_clear(net, &he->ext);
 }
 
 static bool nft_rhash_flush(const struct net *net,
@@ -285,8 +285,6 @@ static void nft_rhash_walk(const struct nft_ctx *ctx, struct nft_set *set,
 
 		if (iter->count < iter->skip)
 			goto cont;
-		if (!nft_set_elem_active(&he->ext, iter->genmask))
-			goto cont;
 
 		elem.priv = he;
 
@@ -615,7 +613,7 @@ static void nft_hash_activate(const struct net *net, const struct nft_set *set,
 {
 	struct nft_hash_elem *he = elem->priv;
 
-	nft_set_elem_change_active(net, set, &he->ext);
+	nft_clear(net, &he->ext);
 }
 
 static bool nft_hash_flush(const struct net *net,
@@ -669,8 +667,6 @@ static void nft_hash_walk(const struct nft_ctx *ctx, struct nft_set *set,
 		hlist_for_each_entry_rcu(he, &priv->table[i], node) {
 			if (iter->count < iter->skip)
 				goto cont;
-			if (!nft_set_elem_active(&he->ext, iter->genmask))
-				goto cont;
 
 			elem.priv = he;
 
diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index cfd0d020f3382b..11473275c6e263 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -1849,7 +1849,7 @@ static void nft_pipapo_activate(const struct net *net,
 {
 	struct nft_pipapo_elem *e = elem->priv;
 
-	nft_set_elem_change_active(net, set, &e->ext);
+	nft_clear(net, &e->ext);
 }
 
 /**
@@ -2151,9 +2151,6 @@ static void nft_pipapo_walk(const struct nft_ctx *ctx, struct nft_set *set,
 
 		e = f->mt[r].e;
 
-		if (!nft_set_elem_active(&e->ext, iter->genmask))
-			goto cont;
-
 		elem.priv = e;
 
 		iter->err = iter->fn(ctx, set, iter, &elem);
diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 426becaad1b94f..23e4e656f7f0cb 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -548,7 +548,7 @@ static void nft_rbtree_activate(const struct net *net,
 {
 	struct nft_rbtree_elem *rbe = elem->priv;
 
-	nft_set_elem_change_active(net, set, &rbe->ext);
+	nft_clear(net, &rbe->ext);
 }
 
 static bool nft_rbtree_flush(const struct net *net,
@@ -618,8 +618,6 @@ static void nft_rbtree_walk(const struct nft_ctx *ctx,
 
 		if (iter->count < iter->skip)
 			goto cont;
-		if (!nft_set_elem_active(&rbe->ext, iter->genmask))
-			goto cont;
 
 		elem.priv = rbe;
 
-- 
2.53.0



