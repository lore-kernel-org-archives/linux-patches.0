Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBD2715198D;
	Wed,  5 Feb 2025 14:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764193; cv=none; b=c2hInSsN0eHOYQ+F0Dg+sLo0qeaNF4pV4E6j9ZcG5mQuXRXYlc3Kmc/uVQ9vpUHz7eaCrQrnPZ//pSwcnZfTjkXYqrxT+8NXL85ZEQCD7FZbvay8rZ/R7NDWcOfVK+v8uFtpCT5zAozp0lAKjqGgN9E+3hNgHbPQ21XVQxlfcpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764193; c=relaxed/simple;
	bh=iuR3QCZTi3fFpfjSFIcvowfYntp9YZZo3kLs6DpqD3g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o66GC+s9E1FsYihsvFBHdxnQnGxtwJNS8SGCtLrMwlSa40Oj1qvl7stH2hWW1InPJ83XLvcMNjeEZXn4Z1z5rhqnElvLX1sWv5xK9+UmpAfUb++GZVkzv5Jhx55T8B3NuDixn1sVNKrUqXLK3q4tiwHSK34JH7OiBLWo3flK3Pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dKKaReId; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dKKaReId"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29A0FC4CED6;
	Wed,  5 Feb 2025 14:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764193;
	bh=iuR3QCZTi3fFpfjSFIcvowfYntp9YZZo3kLs6DpqD3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dKKaReIdlt8MSZYF0SBMyVyfNoHhi8156k2uOR2X3LaPTtiZ3fmlzSKVHERXkoKsL
	 9DVxDevFHQ9tlH6d0YPdZEzP5OiSpqJYPJLiQsLKyicOa4LU9V2sroSSRYrYyJFgwK
	 YN5sZpENInXIh1GlyvozlbBmUAuUx9RkB4UkyKAE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 148/393] netfilter: nf_tables: fix set size with rbtree backend
Date: Wed,  5 Feb 2025 14:41:07 +0100
Message-ID: <20250205134425.965890789@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 8d738c1869f611955d91d8d0fd0012d9ef207201 ]

The existing rbtree implementation uses singleton elements to represent
ranges, however, userspace provides a set size according to the number
of ranges in the set.

Adjust provided userspace set size to the number of singleton elements
in the kernel by multiplying the range by two.

Check if the no-match all-zero element is already in the set, in such
case release one slot in the set size.

Fixes: 0ed6389c483d ("netfilter: nf_tables: rename set implementations")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netfilter/nf_tables.h |  6 ++++
 net/netfilter/nf_tables_api.c     | 49 +++++++++++++++++++++++++++++--
 net/netfilter/nft_set_rbtree.c    | 43 +++++++++++++++++++++++++++
 3 files changed, 96 insertions(+), 2 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 12a30d8e7efe0..dcbf3f299548f 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -429,6 +429,9 @@ struct nft_set_ext;
  *	@remove: remove element from set
  *	@walk: iterate over all set elements
  *	@get: get set elements
+ *	@ksize: kernel set size
+ * 	@usize: userspace set size
+ *	@adjust_maxsize: delta to adjust maximum set size
  *	@commit: commit set elements
  *	@abort: abort set elements
  *	@privsize: function to return size of set private data
@@ -481,6 +484,9 @@ struct nft_set_ops {
 					       const struct nft_set *set,
 					       const struct nft_set_elem *elem,
 					       unsigned int flags);
+	u32				(*ksize)(u32 size);
+	u32				(*usize)(u32 size);
+	u32				(*adjust_maxsize)(const struct nft_set *set);
 	void				(*commit)(struct nft_set *set);
 	void				(*abort)(const struct nft_set *set);
 	u64				(*privsize)(const struct nlattr * const nla[],
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 1d1e998acd675..42dac335074fb 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4552,6 +4552,14 @@ static int nf_tables_fill_set_concat(struct sk_buff *skb,
 	return 0;
 }
 
+static u32 nft_set_userspace_size(const struct nft_set_ops *ops, u32 size)
+{
+	if (ops->usize)
+		return ops->usize(size);
+
+	return size;
+}
+
 static int nf_tables_fill_set(struct sk_buff *skb, const struct nft_ctx *ctx,
 			      const struct nft_set *set, u16 event, u16 flags)
 {
@@ -4622,7 +4630,8 @@ static int nf_tables_fill_set(struct sk_buff *skb, const struct nft_ctx *ctx,
 	if (!nest)
 		goto nla_put_failure;
 	if (set->size &&
-	    nla_put_be32(skb, NFTA_SET_DESC_SIZE, htonl(set->size)))
+	    nla_put_be32(skb, NFTA_SET_DESC_SIZE,
+			 htonl(nft_set_userspace_size(set->ops, set->size))))
 		goto nla_put_failure;
 
 	if (set->field_count > 1 &&
@@ -4992,6 +5001,15 @@ static bool nft_set_is_same(const struct nft_set *set,
 	return true;
 }
 
+static u32 nft_set_kernel_size(const struct nft_set_ops *ops,
+			       const struct nft_set_desc *desc)
+{
+	if (ops->ksize)
+		return ops->ksize(desc->size);
+
+	return desc->size;
+}
+
 static int nf_tables_newset(struct sk_buff *skb, const struct nfnl_info *info,
 			    const struct nlattr * const nla[])
 {
@@ -5174,6 +5192,9 @@ static int nf_tables_newset(struct sk_buff *skb, const struct nfnl_info *info,
 		if (err < 0)
 			return err;
 
+		if (desc.size)
+			desc.size = nft_set_kernel_size(set->ops, &desc);
+
 		err = 0;
 		if (!nft_set_is_same(set, &desc, exprs, num_exprs, flags)) {
 			NL_SET_BAD_ATTR(extack, nla[NFTA_SET_NAME]);
@@ -5196,6 +5217,9 @@ static int nf_tables_newset(struct sk_buff *skb, const struct nfnl_info *info,
 	if (IS_ERR(ops))
 		return PTR_ERR(ops);
 
+	if (desc.size)
+		desc.size = nft_set_kernel_size(ops, &desc);
+
 	udlen = 0;
 	if (nla[NFTA_SET_USERDATA])
 		udlen = nla_len(nla[NFTA_SET_USERDATA]);
@@ -6679,6 +6703,27 @@ static bool nft_setelem_valid_key_end(const struct nft_set *set,
 	return true;
 }
 
+static u32 nft_set_maxsize(const struct nft_set *set)
+{
+	u32 maxsize, delta;
+
+	if (!set->size)
+		return UINT_MAX;
+
+	if (set->ops->adjust_maxsize)
+		delta = set->ops->adjust_maxsize(set);
+	else
+		delta = 0;
+
+	if (check_add_overflow(set->size, set->ndeact, &maxsize))
+		return UINT_MAX;
+
+	if (check_add_overflow(maxsize, delta, &maxsize))
+		return UINT_MAX;
+
+	return maxsize;
+}
+
 static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 			    const struct nlattr *attr, u32 nlmsg_flags)
 {
@@ -7023,7 +7068,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	}
 
 	if (!(flags & NFT_SET_ELEM_CATCHALL)) {
-		unsigned int max = set->size ? set->size + set->ndeact : UINT_MAX;
+		unsigned int max = nft_set_maxsize(set);
 
 		if (!atomic_add_unless(&set->nelems, 1, max)) {
 			err = -ENFILE;
diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 26af6008861a6..8ad1e008d12b5 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -756,6 +756,46 @@ static void nft_rbtree_gc_init(const struct nft_set *set)
 	priv->last_gc = jiffies;
 }
 
+/* rbtree stores ranges as singleton elements, each range is composed of two
+ * elements ...
+ */
+static u32 nft_rbtree_ksize(u32 size)
+{
+	return size * 2;
+}
+
+/* ... hide this detail to userspace. */
+static u32 nft_rbtree_usize(u32 size)
+{
+	if (!size)
+		return 0;
+
+	return size / 2;
+}
+
+static u32 nft_rbtree_adjust_maxsize(const struct nft_set *set)
+{
+	struct nft_rbtree *priv = nft_set_priv(set);
+	struct nft_rbtree_elem *rbe;
+	struct rb_node *node;
+	const void *key;
+
+	node = rb_last(&priv->root);
+	if (!node)
+		return 0;
+
+	rbe = rb_entry(node, struct nft_rbtree_elem, node);
+	if (!nft_rbtree_interval_end(rbe))
+		return 0;
+
+	key = nft_set_ext_key(&rbe->ext);
+	if (memchr(key, 1, set->klen))
+		return 0;
+
+	/* this is the all-zero no-match element. */
+	return 1;
+}
+
 const struct nft_set_type nft_set_rbtree_type = {
 	.features	= NFT_SET_INTERVAL | NFT_SET_MAP | NFT_SET_OBJECT | NFT_SET_TIMEOUT,
 	.ops		= {
@@ -774,5 +814,8 @@ const struct nft_set_type nft_set_rbtree_type = {
 		.lookup		= nft_rbtree_lookup,
 		.walk		= nft_rbtree_walk,
 		.get		= nft_rbtree_get,
+		.ksize		= nft_rbtree_ksize,
+		.usize		= nft_rbtree_usize,
+		.adjust_maxsize = nft_rbtree_adjust_maxsize,
 	},
 };
-- 
2.39.5



