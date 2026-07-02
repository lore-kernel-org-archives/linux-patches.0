Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A327E35E1C0;
	Thu,  2 Jul 2026 16:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009859; cv=none; b=IPdqOnlk9FB73O+jOGs/uSogI+I4S2sTsgVZ8Vi4d/zNZB9388Ytxr/wRJDQbm5j7JmFRpsSmQi7KL+eAl8bifyuFgz2s9ECnR81eLD269kVfO5I1Nf8e6Jt9fCWx3gZN6VBnGGlcFfgmpjipGBw0JFwuy9AeAffJVdUf3VG+oM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009859; c=relaxed/simple;
	bh=tsN7aMpTnCrL5HAQTjz4XKEIYPQ8AL1agyilMhfSewo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cdBxI7SZ5920U+4yIYH6pbeAw8Uiuw92hF+gkX0fJfTgkcULvvSIe0DO0JykxkkOehlGsNZB3ddul3oxA2iAtRkoLeRXA0NrUeCGCgTkBHwlQ8ZEv5Efy2vIT1cR9rdWuY2pdm22uC3fc4ljZCfHgVsBLkuI6upOhIJBVobODMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iwP9XXwz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iwP9XXwz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C832C1F00A3A;
	Thu,  2 Jul 2026 16:30:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783009857;
	bh=teI6Qu4Ffpr1whbTubfAl9CPqa+ezr4nclAxAE9V+c4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iwP9XXwzdMMtFMz/nxLB0wrugXETwmtg7iqar/0ITQOCpIJRJ6vPqKXy22AwrQrMO
	 A7He+OUAh9pYfCwseiHegsrYpC7vtQd4boQ9er0C1AjRYgw6BpG26mR/0ph6oXkixu
	 nVjBzciSJHAef3MNHOIBAk67zZzylBAB4T6jKM20=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>,
	Shivani Agarwal <shivani.agarwal@broadcom.com>
Subject: [PATCH 6.1 011/129] netfilter: nf_tables: fix set size with rbtree backend
Date: Thu,  2 Jul 2026 18:18:50 +0200
Message-ID: <20260702155112.395847341@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.163984240@linuxfoundation.org>
References: <20260702155112.163984240@linuxfoundation.org>
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
[ Shivani: Modified to apply on 6.1.y ]
Signed-off-by: Shivani Agarwal <shivani.agarwal@broadcom.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netfilter/nf_tables.h |  6 ++++
 net/netfilter/nf_tables_api.c     | 49 +++++++++++++++++++++++++++++--
 net/netfilter/nft_set_rbtree.c    | 43 +++++++++++++++++++++++++++
 3 files changed, 96 insertions(+), 2 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index dafa0a32e6e1df..3329c2eaea9f07 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -422,6 +422,9 @@ struct nft_set_ext;
  *	@remove: remove element from set
  *	@walk: iterate over all set elements
  *	@get: get set elements
+ *	@ksize: kernel set size
+ *	@usize: userspace set size
+ *	@adjust_maxsize: delta to adjust maximum set size
  *	@privsize: function to return size of set private data
  *	@init: initialize private data of new set instance
  *	@destroy: destroy private data of set instance
@@ -470,6 +473,9 @@ struct nft_set_ops {
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
index b6b7b0b3539dc9..0d406dab5cac19 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4277,6 +4277,14 @@ static int nf_tables_fill_set_concat(struct sk_buff *skb,
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
@@ -4341,7 +4349,8 @@ static int nf_tables_fill_set(struct sk_buff *skb, const struct nft_ctx *ctx,
 	if (!nest)
 		goto nla_put_failure;
 	if (set->size &&
-	    nla_put_be32(skb, NFTA_SET_DESC_SIZE, htonl(set->size)))
+	    nla_put_be32(skb, NFTA_SET_DESC_SIZE,
+			 htonl(nft_set_userspace_size(set->ops, set->size))))
 		goto nla_put_failure;
 
 	if (set->field_count > 1 &&
@@ -4711,6 +4720,15 @@ static bool nft_set_is_same(const struct nft_set *set,
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
@@ -4893,6 +4911,9 @@ static int nf_tables_newset(struct sk_buff *skb, const struct nfnl_info *info,
 		if (err < 0)
 			return err;
 
+		if (desc.size)
+			desc.size = nft_set_kernel_size(set->ops, &desc);
+
 		err = 0;
 		if (!nft_set_is_same(set, &desc, exprs, num_exprs, flags)) {
 			NL_SET_BAD_ATTR(extack, nla[NFTA_SET_NAME]);
@@ -4915,6 +4936,9 @@ static int nf_tables_newset(struct sk_buff *skb, const struct nfnl_info *info,
 	if (IS_ERR(ops))
 		return PTR_ERR(ops);
 
+	if (desc.size)
+		desc.size = nft_set_kernel_size(ops, &desc);
+
 	udlen = 0;
 	if (nla[NFTA_SET_USERDATA])
 		udlen = nla_len(nla[NFTA_SET_USERDATA]);
@@ -6356,6 +6380,27 @@ static bool nft_setelem_valid_key_end(const struct nft_set *set,
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
@@ -6700,7 +6745,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	}
 
 	if (!(flags & NFT_SET_ELEM_CATCHALL)) {
-		unsigned int max = set->size ? set->size + set->ndeact : UINT_MAX;
+		unsigned int max = nft_set_maxsize(set);
 
 		if (!atomic_add_unless(&set->nelems, 1, max)) {
 			err = -ENFILE;
diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtree.c
index 23e4e656f7f0cb..433094c4200f97 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -773,6 +773,46 @@ static bool nft_rbtree_estimate(const struct nft_set_desc *desc, u32 features,
 	return true;
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
@@ -789,5 +829,8 @@ const struct nft_set_type nft_set_rbtree_type = {
 		.lookup		= nft_rbtree_lookup,
 		.walk		= nft_rbtree_walk,
 		.get		= nft_rbtree_get,
+		.ksize		= nft_rbtree_ksize,
+		.usize		= nft_rbtree_usize,
+		.adjust_maxsize = nft_rbtree_adjust_maxsize,
 	},
 };
-- 
2.53.0



