Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CEF8194C8F;
	Wed,  3 Jul 2024 11:25:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720005924; cv=none; b=KPpDpTwu3S1C1GS1MCcTL0q5OR8/HjTyPSHng8RVFCwUzrIPWyJx6x+Jd46GL+XjEMPjhRDis1nkx6a+joTZUIOpXlRPabzpMNvdfj2/MZ829UcqsjWYiJp9Z2qSymPDMED7nEa/MnOYOvMgnXdapXhBXaYtSWjKyrXv/8Ufc5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720005924; c=relaxed/simple;
	bh=13x4xW6y8QQAobgSRSCiMiP9UbEoClu0GnqKXiya3iI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YFpbocOhRlqKZQCE7Nbk+zJnNN4udrJKoxL7GPzf06vHQaQsDGkTPCWCrMUsbwe9TtenGL4H7FsXqhXzDYh8O6yKDDR+2TOTBQQvu6pDpyWQMIIsw3MfSqjAFAKw+Z9JfgjB0woLiO/cB+gIBIEFNwlyehAAfETed4mi/AcY6+E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M7j3M//I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M7j3M//I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F8AFC32781;
	Wed,  3 Jul 2024 11:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720005924;
	bh=13x4xW6y8QQAobgSRSCiMiP9UbEoClu0GnqKXiya3iI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M7j3M//IFzfp/8TLm9NRT+1XgOdZX3Us2Tp7GgPU0ivncpoX4wZVksgs0p5H2f9a7
	 5VnIpUTIr661tPBAMrailWKZoBMPrYo0waOXkyLmHlNCHmcly5xU+BD/973asksPQW
	 ANc9zTYILXEmP/pgR6MHaLEdOZtv/0BMpnBWwu9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Mirvish <matthew@mm12.xyz>,
	Coly Li <colyli@suse.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 240/356] bcache: fix variable length array abuse in btree_iter
Date: Wed,  3 Jul 2024 12:39:36 +0200
Message-ID: <20240703102922.194648641@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Mirvish <matthew@mm12.xyz>

[ Upstream commit 3a861560ccb35f2a4f0a4b8207fa7c2a35fc7f31 ]

btree_iter is used in two ways: either allocated on the stack with a
fixed size MAX_BSETS, or from a mempool with a dynamic size based on the
specific cache set. Previously, the struct had a fixed-length array of
size MAX_BSETS which was indexed out-of-bounds for the dynamically-sized
iterators, which causes UBSAN to complain.

This patch uses the same approach as in bcachefs's sort_iter and splits
the iterator into a btree_iter with a flexible array member and a
btree_iter_stack which embeds a btree_iter as well as a fixed-length
data array.

Cc: stable@vger.kernel.org
Closes: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/2039368
Signed-off-by: Matthew Mirvish <matthew@mm12.xyz>
Signed-off-by: Coly Li <colyli@suse.de>
Link: https://lore.kernel.org/r/20240509011117.2697-3-colyli@suse.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/bcache/bset.c      | 44 +++++++++++++++++------------------
 drivers/md/bcache/bset.h      | 28 ++++++++++++++--------
 drivers/md/bcache/btree.c     | 40 ++++++++++++++++---------------
 drivers/md/bcache/super.c     |  5 ++--
 drivers/md/bcache/sysfs.c     |  2 +-
 drivers/md/bcache/writeback.c | 10 ++++----
 6 files changed, 70 insertions(+), 59 deletions(-)

diff --git a/drivers/md/bcache/bset.c b/drivers/md/bcache/bset.c
index 94d38e8a59b32..cb544207427b1 100644
--- a/drivers/md/bcache/bset.c
+++ b/drivers/md/bcache/bset.c
@@ -54,7 +54,7 @@ void bch_dump_bucket(struct btree_keys *b)
 int __bch_count_data(struct btree_keys *b)
 {
 	unsigned int ret = 0;
-	struct btree_iter iter;
+	struct btree_iter_stack iter;
 	struct bkey *k;
 
 	if (b->ops->is_extents)
@@ -67,7 +67,7 @@ void __bch_check_keys(struct btree_keys *b, const char *fmt, ...)
 {
 	va_list args;
 	struct bkey *k, *p = NULL;
-	struct btree_iter iter;
+	struct btree_iter_stack iter;
 	const char *err;
 
 	for_each_key(b, k, &iter) {
@@ -879,7 +879,7 @@ unsigned int bch_btree_insert_key(struct btree_keys *b, struct bkey *k,
 	unsigned int status = BTREE_INSERT_STATUS_NO_INSERT;
 	struct bset *i = bset_tree_last(b)->data;
 	struct bkey *m, *prev = NULL;
-	struct btree_iter iter;
+	struct btree_iter_stack iter;
 	struct bkey preceding_key_on_stack = ZERO_KEY;
 	struct bkey *preceding_key_p = &preceding_key_on_stack;
 
@@ -895,9 +895,9 @@ unsigned int bch_btree_insert_key(struct btree_keys *b, struct bkey *k,
 	else
 		preceding_key(k, &preceding_key_p);
 
-	m = bch_btree_iter_init(b, &iter, preceding_key_p);
+	m = bch_btree_iter_stack_init(b, &iter, preceding_key_p);
 
-	if (b->ops->insert_fixup(b, k, &iter, replace_key))
+	if (b->ops->insert_fixup(b, k, &iter.iter, replace_key))
 		return status;
 
 	status = BTREE_INSERT_STATUS_INSERT;
@@ -1100,33 +1100,33 @@ void bch_btree_iter_push(struct btree_iter *iter, struct bkey *k,
 				 btree_iter_cmp));
 }
 
-static struct bkey *__bch_btree_iter_init(struct btree_keys *b,
-					  struct btree_iter *iter,
-					  struct bkey *search,
-					  struct bset_tree *start)
+static struct bkey *__bch_btree_iter_stack_init(struct btree_keys *b,
+						struct btree_iter_stack *iter,
+						struct bkey *search,
+						struct bset_tree *start)
 {
 	struct bkey *ret = NULL;
 
-	iter->size = ARRAY_SIZE(iter->data);
-	iter->used = 0;
+	iter->iter.size = ARRAY_SIZE(iter->stack_data);
+	iter->iter.used = 0;
 
 #ifdef CONFIG_BCACHE_DEBUG
-	iter->b = b;
+	iter->iter.b = b;
 #endif
 
 	for (; start <= bset_tree_last(b); start++) {
 		ret = bch_bset_search(b, start, search);
-		bch_btree_iter_push(iter, ret, bset_bkey_last(start->data));
+		bch_btree_iter_push(&iter->iter, ret, bset_bkey_last(start->data));
 	}
 
 	return ret;
 }
 
-struct bkey *bch_btree_iter_init(struct btree_keys *b,
-				 struct btree_iter *iter,
+struct bkey *bch_btree_iter_stack_init(struct btree_keys *b,
+				 struct btree_iter_stack *iter,
 				 struct bkey *search)
 {
-	return __bch_btree_iter_init(b, iter, search, b->set);
+	return __bch_btree_iter_stack_init(b, iter, search, b->set);
 }
 
 static inline struct bkey *__bch_btree_iter_next(struct btree_iter *iter,
@@ -1293,10 +1293,10 @@ void bch_btree_sort_partial(struct btree_keys *b, unsigned int start,
 			    struct bset_sort_state *state)
 {
 	size_t order = b->page_order, keys = 0;
-	struct btree_iter iter;
+	struct btree_iter_stack iter;
 	int oldsize = bch_count_data(b);
 
-	__bch_btree_iter_init(b, &iter, NULL, &b->set[start]);
+	__bch_btree_iter_stack_init(b, &iter, NULL, &b->set[start]);
 
 	if (start) {
 		unsigned int i;
@@ -1307,7 +1307,7 @@ void bch_btree_sort_partial(struct btree_keys *b, unsigned int start,
 		order = get_order(__set_bytes(b->set->data, keys));
 	}
 
-	__btree_sort(b, &iter, start, order, false, state);
+	__btree_sort(b, &iter.iter, start, order, false, state);
 
 	EBUG_ON(oldsize >= 0 && bch_count_data(b) != oldsize);
 }
@@ -1323,11 +1323,11 @@ void bch_btree_sort_into(struct btree_keys *b, struct btree_keys *new,
 			 struct bset_sort_state *state)
 {
 	uint64_t start_time = local_clock();
-	struct btree_iter iter;
+	struct btree_iter_stack iter;
 
-	bch_btree_iter_init(b, &iter, NULL);
+	bch_btree_iter_stack_init(b, &iter, NULL);
 
-	btree_mergesort(b, new->set->data, &iter, false, true);
+	btree_mergesort(b, new->set->data, &iter.iter, false, true);
 
 	bch_time_stats_update(&state->time, start_time);
 
diff --git a/drivers/md/bcache/bset.h b/drivers/md/bcache/bset.h
index a50dcfda656f5..2ed6dbd35d6e5 100644
--- a/drivers/md/bcache/bset.h
+++ b/drivers/md/bcache/bset.h
@@ -321,7 +321,14 @@ struct btree_iter {
 #endif
 	struct btree_iter_set {
 		struct bkey *k, *end;
-	} data[MAX_BSETS];
+	} data[];
+};
+
+/* Fixed-size btree_iter that can be allocated on the stack */
+
+struct btree_iter_stack {
+	struct btree_iter iter;
+	struct btree_iter_set stack_data[MAX_BSETS];
 };
 
 typedef bool (*ptr_filter_fn)(struct btree_keys *b, const struct bkey *k);
@@ -333,9 +340,9 @@ struct bkey *bch_btree_iter_next_filter(struct btree_iter *iter,
 
 void bch_btree_iter_push(struct btree_iter *iter, struct bkey *k,
 			 struct bkey *end);
-struct bkey *bch_btree_iter_init(struct btree_keys *b,
-				 struct btree_iter *iter,
-				 struct bkey *search);
+struct bkey *bch_btree_iter_stack_init(struct btree_keys *b,
+				       struct btree_iter_stack *iter,
+				       struct bkey *search);
 
 struct bkey *__bch_bset_search(struct btree_keys *b, struct bset_tree *t,
 			       const struct bkey *search);
@@ -350,13 +357,14 @@ static inline struct bkey *bch_bset_search(struct btree_keys *b,
 	return search ? __bch_bset_search(b, t, search) : t->data->start;
 }
 
-#define for_each_key_filter(b, k, iter, filter)				\
-	for (bch_btree_iter_init((b), (iter), NULL);			\
-	     ((k) = bch_btree_iter_next_filter((iter), (b), filter));)
+#define for_each_key_filter(b, k, stack_iter, filter)                      \
+	for (bch_btree_iter_stack_init((b), (stack_iter), NULL);           \
+	     ((k) = bch_btree_iter_next_filter(&((stack_iter)->iter), (b), \
+					       filter));)
 
-#define for_each_key(b, k, iter)					\
-	for (bch_btree_iter_init((b), (iter), NULL);			\
-	     ((k) = bch_btree_iter_next(iter));)
+#define for_each_key(b, k, stack_iter)                           \
+	for (bch_btree_iter_stack_init((b), (stack_iter), NULL); \
+	     ((k) = bch_btree_iter_next(&((stack_iter)->iter)));)
 
 /* Sorting */
 
diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index e22dfcf1ed6d8..066b4aafd49e5 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -1283,7 +1283,7 @@ static bool btree_gc_mark_node(struct btree *b, struct gc_stat *gc)
 	uint8_t stale = 0;
 	unsigned int keys = 0, good_keys = 0;
 	struct bkey *k;
-	struct btree_iter iter;
+	struct btree_iter_stack iter;
 	struct bset_tree *t;
 
 	gc->nodes++;
@@ -1544,7 +1544,7 @@ static int btree_gc_rewrite_node(struct btree *b, struct btree_op *op,
 static unsigned int btree_gc_count_keys(struct btree *b)
 {
 	struct bkey *k;
-	struct btree_iter iter;
+	struct btree_iter_stack iter;
 	unsigned int ret = 0;
 
 	for_each_key_filter(&b->keys, k, &iter, bch_ptr_bad)
@@ -1585,17 +1585,18 @@ static int btree_gc_recurse(struct btree *b, struct btree_op *op,
 	int ret = 0;
 	bool should_rewrite;
 	struct bkey *k;
-	struct btree_iter iter;
+	struct btree_iter_stack iter;
 	struct gc_merge_info r[GC_MERGE_NODES];
 	struct gc_merge_info *i, *last = r + ARRAY_SIZE(r) - 1;
 
-	bch_btree_iter_init(&b->keys, &iter, &b->c->gc_done);
+	bch_btree_iter_stack_init(&b->keys, &iter, &b->c->gc_done);
 
 	for (i = r; i < r + ARRAY_SIZE(r); i++)
 		i->b = ERR_PTR(-EINTR);
 
 	while (1) {
-		k = bch_btree_iter_next_filter(&iter, &b->keys, bch_ptr_bad);
+		k = bch_btree_iter_next_filter(&iter.iter, &b->keys,
+					       bch_ptr_bad);
 		if (k) {
 			r->b = bch_btree_node_get(b->c, op, k, b->level - 1,
 						  true, b);
@@ -1885,7 +1886,7 @@ static int bch_btree_check_recurse(struct btree *b, struct btree_op *op)
 {
 	int ret = 0;
 	struct bkey *k, *p = NULL;
-	struct btree_iter iter;
+	struct btree_iter_stack iter;
 
 	for_each_key_filter(&b->keys, k, &iter, bch_ptr_invalid)
 		bch_initial_mark_key(b->c, b->level, k);
@@ -1893,10 +1894,10 @@ static int bch_btree_check_recurse(struct btree *b, struct btree_op *op)
 	bch_initial_mark_key(b->c, b->level + 1, &b->key);
 
 	if (b->level) {
-		bch_btree_iter_init(&b->keys, &iter, NULL);
+		bch_btree_iter_stack_init(&b->keys, &iter, NULL);
 
 		do {
-			k = bch_btree_iter_next_filter(&iter, &b->keys,
+			k = bch_btree_iter_next_filter(&iter.iter, &b->keys,
 						       bch_ptr_bad);
 			if (k) {
 				btree_node_prefetch(b, k);
@@ -1924,7 +1925,7 @@ static int bch_btree_check_thread(void *arg)
 	struct btree_check_info *info = arg;
 	struct btree_check_state *check_state = info->state;
 	struct cache_set *c = check_state->c;
-	struct btree_iter iter;
+	struct btree_iter_stack iter;
 	struct bkey *k, *p;
 	int cur_idx, prev_idx, skip_nr;
 
@@ -1933,8 +1934,8 @@ static int bch_btree_check_thread(void *arg)
 	ret = 0;
 
 	/* root node keys are checked before thread created */
-	bch_btree_iter_init(&c->root->keys, &iter, NULL);
-	k = bch_btree_iter_next_filter(&iter, &c->root->keys, bch_ptr_bad);
+	bch_btree_iter_stack_init(&c->root->keys, &iter, NULL);
+	k = bch_btree_iter_next_filter(&iter.iter, &c->root->keys, bch_ptr_bad);
 	BUG_ON(!k);
 
 	p = k;
@@ -1952,7 +1953,7 @@ static int bch_btree_check_thread(void *arg)
 		skip_nr = cur_idx - prev_idx;
 
 		while (skip_nr) {
-			k = bch_btree_iter_next_filter(&iter,
+			k = bch_btree_iter_next_filter(&iter.iter,
 						       &c->root->keys,
 						       bch_ptr_bad);
 			if (k)
@@ -2025,7 +2026,7 @@ int bch_btree_check(struct cache_set *c)
 	int ret = 0;
 	int i;
 	struct bkey *k = NULL;
-	struct btree_iter iter;
+	struct btree_iter_stack iter;
 	struct btree_check_state check_state;
 
 	/* check and mark root node keys */
@@ -2521,11 +2522,11 @@ static int bch_btree_map_nodes_recurse(struct btree *b, struct btree_op *op,
 
 	if (b->level) {
 		struct bkey *k;
-		struct btree_iter iter;
+		struct btree_iter_stack iter;
 
-		bch_btree_iter_init(&b->keys, &iter, from);
+		bch_btree_iter_stack_init(&b->keys, &iter, from);
 
-		while ((k = bch_btree_iter_next_filter(&iter, &b->keys,
+		while ((k = bch_btree_iter_next_filter(&iter.iter, &b->keys,
 						       bch_ptr_bad))) {
 			ret = bcache_btree(map_nodes_recurse, k, b,
 				    op, from, fn, flags);
@@ -2554,11 +2555,12 @@ int bch_btree_map_keys_recurse(struct btree *b, struct btree_op *op,
 {
 	int ret = MAP_CONTINUE;
 	struct bkey *k;
-	struct btree_iter iter;
+	struct btree_iter_stack iter;
 
-	bch_btree_iter_init(&b->keys, &iter, from);
+	bch_btree_iter_stack_init(&b->keys, &iter, from);
 
-	while ((k = bch_btree_iter_next_filter(&iter, &b->keys, bch_ptr_bad))) {
+	while ((k = bch_btree_iter_next_filter(&iter.iter, &b->keys,
+					       bch_ptr_bad))) {
 		ret = !b->level
 			? fn(op, b, k)
 			: bcache_btree(map_keys_recurse, k,
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index 8ec48d8a5821c..48624e6bf0d79 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1920,8 +1920,9 @@ struct cache_set *bch_cache_set_alloc(struct cache_sb *sb)
 	INIT_LIST_HEAD(&c->btree_cache_freed);
 	INIT_LIST_HEAD(&c->data_buckets);
 
-	iter_size = ((meta_bucket_pages(sb) * PAGE_SECTORS) / sb->block_size + 1) *
-		sizeof(struct btree_iter_set);
+	iter_size = sizeof(struct btree_iter) +
+		    ((meta_bucket_pages(sb) * PAGE_SECTORS) / sb->block_size) *
+			    sizeof(struct btree_iter_set);
 
 	c->devices = kcalloc(c->nr_uuids, sizeof(void *), GFP_KERNEL);
 	if (!c->devices)
diff --git a/drivers/md/bcache/sysfs.c b/drivers/md/bcache/sysfs.c
index fa146012003df..7024eaed8d486 100644
--- a/drivers/md/bcache/sysfs.c
+++ b/drivers/md/bcache/sysfs.c
@@ -658,7 +658,7 @@ static unsigned int bch_root_usage(struct cache_set *c)
 	unsigned int bytes = 0;
 	struct bkey *k;
 	struct btree *b;
-	struct btree_iter iter;
+	struct btree_iter_stack iter;
 
 	goto lock_root;
 
diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index 1e96679afcf4a..142eaf0ff9aea 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -898,15 +898,15 @@ static int bch_dirty_init_thread(void *arg)
 	struct dirty_init_thrd_info *info = arg;
 	struct bch_dirty_init_state *state = info->state;
 	struct cache_set *c = state->c;
-	struct btree_iter iter;
+	struct btree_iter_stack iter;
 	struct bkey *k, *p;
 	int cur_idx, prev_idx, skip_nr;
 
 	k = p = NULL;
 	prev_idx = 0;
 
-	bch_btree_iter_init(&c->root->keys, &iter, NULL);
-	k = bch_btree_iter_next_filter(&iter, &c->root->keys, bch_ptr_bad);
+	bch_btree_iter_stack_init(&c->root->keys, &iter, NULL);
+	k = bch_btree_iter_next_filter(&iter.iter, &c->root->keys, bch_ptr_bad);
 	BUG_ON(!k);
 
 	p = k;
@@ -920,7 +920,7 @@ static int bch_dirty_init_thread(void *arg)
 		skip_nr = cur_idx - prev_idx;
 
 		while (skip_nr) {
-			k = bch_btree_iter_next_filter(&iter,
+			k = bch_btree_iter_next_filter(&iter.iter,
 						       &c->root->keys,
 						       bch_ptr_bad);
 			if (k)
@@ -969,7 +969,7 @@ void bch_sectors_dirty_init(struct bcache_device *d)
 	int i;
 	struct btree *b = NULL;
 	struct bkey *k = NULL;
-	struct btree_iter iter;
+	struct btree_iter_stack iter;
 	struct sectors_dirty_init op;
 	struct cache_set *c = d->c;
 	struct bch_dirty_init_state state;
-- 
2.43.0



