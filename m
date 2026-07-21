Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 686243B42CB;
	Tue, 21 Jul 2026 20:45:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666708; cv=none; b=q5tyRjlIZ3Ht8uCDJWWbbTMbxHab4aErSE7I9W4+sJ6L95fquZ7sdDq7xOIwnyOKnp4EnwrGRpJ9lvLMTZVXkcZUcKVoOgw0/uHQxfzk2BlZAbz7W0ORRV8bH2O6uwz6m5TEe1Lz/Voj8RYZX5vzG0Ghi07TZv//tWH69vaWG7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666708; c=relaxed/simple;
	bh=FKFT9ubFQzuDLRgvEpHtX6zx6Z7+PVcup9SrBCJHu8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SSWYuY8aJFQ+yljMmpsmJCAysZZjDU8+sbJwx3qYSYq/hE+5yfWeIHh4hxPlsuXxZlbIXoKSA8ATJiDHvIKgUQDPjTUcmeWfUaewkemZ0/TIrGoGKNNy1ZRZmR7P9z9MmNUdaWhAE4zuIwAon1vQnim7zbBBLZlhdTcd4o8RdU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XaTgIDXd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XaTgIDXd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C81141F00A3A;
	Tue, 21 Jul 2026 20:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666707;
	bh=hyb8ioObtunD5zB9Tl49C3ahlmM+8F+ylmaF/ekBJIU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XaTgIDXd7kExW8M7QvGGAjxBWRZ3ylYfSnvV6W4O5ddKtuF3egFjMXhJYPV52YFYO
	 MRWorEdQ3XRCrS1EVwVClnspa2keuAprIHUd+RnK5TeMRcLMfV5bjK7wsIHHyjul3n
	 mXzFyOT3XthLJmY69w7RXJgYwHcac0JGMc38Mmns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0742/1266] netfilter: ipset: annotate "pos" for concurrent readers/writers
Date: Tue, 21 Jul 2026 17:19:39 +0200
Message-ID: <20260721152458.476051396@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

From: Jozsef Kadlecsik <kadlec@netfilter.org>

[ Upstream commit 7f7445840b7771338618930e45ee641104b38ed8 ]

The "pos" structure member of struct hbucket stores the first
free slot in the hash bucket of a hash type of set and there
are concurrent readers/writers. Annotate accesses properly.

Fixes: 18f84d41d34f ("netfilter: ipset: Introduce RCU locking in hash:* types")
Signed-off-by: Jozsef Kadlecsik <kadlec@netfilter.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Stable-dep-of: e4b4984e28c1 ("netfilter: ipset: Don't use test_bit() in lockless RCU readers in hash types")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/ipset/ip_set_hash_gen.h | 62 ++++++++++++++++-----------
 1 file changed, 38 insertions(+), 24 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_gen.h b/net/netfilter/ipset/ip_set_hash_gen.h
index a41b50489e227e..3ed883b4be54b4 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -385,8 +385,9 @@ static void
 mtype_ext_cleanup(struct ip_set *set, struct hbucket *n)
 {
 	int i;
+	u8 pos = smp_load_acquire(&n->pos);
 
-	for (i = 0; i < n->pos; i++)
+	for (i = 0; i < pos; i++)
 		if (test_bit(i, n->used))
 			ip_set_ext_destroy(set, ahash_data(n, i, set->dsize));
 }
@@ -489,7 +490,7 @@ mtype_gc_do(struct ip_set *set, struct htype *h, struct htable *t, u32 r)
 #ifdef IP_SET_HASH_WITH_NETS
 	u8 k;
 #endif
-	u8 htable_bits = t->htable_bits;
+	u8 pos, htable_bits = t->htable_bits;
 
 	spin_lock_bh(&t->hregion[r].lock);
 	for (i = ahash_bucket_start(r, htable_bits);
@@ -497,7 +498,8 @@ mtype_gc_do(struct ip_set *set, struct htype *h, struct htable *t, u32 r)
 		n = __ipset_dereference(hbucket(t, i));
 		if (!n)
 			continue;
-		for (j = 0, d = 0; j < n->pos; j++) {
+		pos = smp_load_acquire(&n->pos);
+		for (j = 0, d = 0; j < pos; j++) {
 			if (!test_bit(j, n->used)) {
 				d++;
 				continue;
@@ -533,7 +535,7 @@ mtype_gc_do(struct ip_set *set, struct htype *h, struct htable *t, u32 r)
 				/* Still try to delete expired elements. */
 				continue;
 			tmp->size = n->size - AHASH_INIT_SIZE;
-			for (j = 0, d = 0; j < n->pos; j++) {
+			for (j = 0, d = 0; j < pos; j++) {
 				if (!test_bit(j, n->used))
 					continue;
 				data = ahash_data(n, j, dsize);
@@ -622,7 +624,7 @@ mtype_resize(struct ip_set *set, bool retried)
 {
 	struct htype *h = set->data;
 	struct htable *t, *orig;
-	u8 htable_bits;
+	u8 pos, htable_bits;
 	size_t hsize, dsize = set->dsize;
 #ifdef IP_SET_HASH_WITH_NETS
 	u8 flags;
@@ -684,7 +686,8 @@ mtype_resize(struct ip_set *set, bool retried)
 			n = __ipset_dereference(hbucket(orig, i));
 			if (!n)
 				continue;
-			for (j = 0; j < n->pos; j++) {
+			pos = smp_load_acquire(&n->pos);
+			for (j = 0; j < pos; j++) {
 				if (!test_bit(j, n->used))
 					continue;
 				data = ahash_data(n, j, dsize);
@@ -808,9 +811,10 @@ mtype_ext_size(struct ip_set *set, u32 *elements, size_t *ext_size)
 {
 	struct htype *h = set->data;
 	const struct htable *t;
-	u32 i, j, r;
 	struct hbucket *n;
 	struct mtype_elem *data;
+	u32 i, j, r;
+	u8 pos;
 
 	t = rcu_dereference_bh(h->table);
 	for (r = 0; r < ahash_numof_locks(t->htable_bits); r++) {
@@ -819,7 +823,8 @@ mtype_ext_size(struct ip_set *set, u32 *elements, size_t *ext_size)
 			n = rcu_dereference_bh(hbucket(t, i));
 			if (!n)
 				continue;
-			for (j = 0; j < n->pos; j++) {
+			pos = smp_load_acquire(&n->pos);
+			for (j = 0; j < pos; j++) {
 				if (!test_bit(j, n->used))
 					continue;
 				data = ahash_data(n, j, set->dsize);
@@ -843,10 +848,11 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 	const struct mtype_elem *d = value;
 	struct mtype_elem *data;
 	struct hbucket *n, *old = ERR_PTR(-ENOENT);
-	int i, j = -1, npos = 0, ret;
+	int i, j = -1, ret;
 	bool flag_exist = flags & IPSET_FLAG_EXIST;
 	bool deleted = false, forceadd = false, reuse = false;
 	u32 r, key, multi = 0, elements, maxelem;
+	u8 npos = 0;
 
 	rcu_read_lock_bh();
 	t = rcu_dereference_bh(h->table);
@@ -888,8 +894,8 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 			ext_size(AHASH_INIT_SIZE, set->dsize);
 		goto copy_elem;
 	}
-	npos = n->pos;
-	for (i = 0; i < n->pos; i++) {
+	npos = smp_load_acquire(&n->pos);
+	for (i = 0; i < npos; i++) {
 		if (!test_bit(i, n->used)) {
 			/* Reuse first deleted entry */
 			if (j == -1) {
@@ -933,7 +939,7 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 	if (elements >= maxelem)
 		goto set_full;
 	/* Create a new slot */
-	if (n->pos >= n->size) {
+	if (npos >= n->size) {
 #ifdef IP_SET_HASH_WITH_MULTI
 		if (h->bucketsize >= AHASH_MAX_TUNED)
 			goto set_full;
@@ -962,8 +968,7 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 	}
 
 copy_elem:
-	j = npos;
-	npos = n->pos + 1;
+	j = npos++;
 	data = ahash_data(n, j, set->dsize);
 copy_data:
 	t->hregion[r].elements++;
@@ -986,7 +991,8 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 	if (SET_WITH_TIMEOUT(set))
 		ip_set_timeout_set(ext_timeout(data, set), ext->timeout);
 	smp_mb__before_atomic();
-	n->pos = npos;
+	/* Ensure all data writes are visible before updating position */
+	smp_store_release(&n->pos, npos);
 	set_bit(j, n->used);
 	if (old != ERR_PTR(-ENOENT)) {
 		rcu_assign_pointer(hbucket(t, key), n);
@@ -1045,6 +1051,7 @@ mtype_del(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 	int i, j, k, r, ret = -IPSET_ERR_EXIST;
 	u32 key, multi = 0;
 	size_t dsize = set->dsize;
+	u8 pos;
 
 	/* Userspace add and resize is excluded by the mutex.
 	 * Kernespace add does not trigger resize.
@@ -1060,7 +1067,8 @@ mtype_del(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 	n = rcu_dereference_bh(hbucket(t, key));
 	if (!n)
 		goto out;
-	for (i = 0, k = 0; i < n->pos; i++) {
+	pos = smp_load_acquire(&n->pos);
+	for (i = 0, k = 0; i < pos; i++) {
 		if (!test_bit(i, n->used)) {
 			k++;
 			continue;
@@ -1074,8 +1082,8 @@ mtype_del(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 		ret = 0;
 		clear_bit(i, n->used);
 		smp_mb__after_atomic();
-		if (i + 1 == n->pos)
-			n->pos--;
+		if (i + 1 == pos)
+			smp_store_release(&n->pos, --pos);
 		t->hregion[r].elements--;
 #ifdef IP_SET_HASH_WITH_NETS
 		for (j = 0; j < IPSET_NET_COUNT; j++)
@@ -1097,11 +1105,11 @@ mtype_del(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 				x->flags = flags;
 			}
 		}
-		for (; i < n->pos; i++) {
+		for (; i < pos; i++) {
 			if (!test_bit(i, n->used))
 				k++;
 		}
-		if (k == n->pos) {
+		if (k == pos) {
 			t->hregion[r].ext_size -= ext_size(n->size, dsize);
 			rcu_assign_pointer(hbucket(t, key), NULL);
 			kfree_rcu(n, rcu);
@@ -1112,7 +1120,7 @@ mtype_del(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 			if (!tmp)
 				goto out;
 			tmp->size = n->size - AHASH_INIT_SIZE;
-			for (j = 0, k = 0; j < n->pos; j++) {
+			for (j = 0, k = 0; j < pos; j++) {
 				if (!test_bit(j, n->used))
 					continue;
 				data = ahash_data(n, j, dsize);
@@ -1173,6 +1181,7 @@ mtype_test_cidrs(struct ip_set *set, struct mtype_elem *d,
 	int ret, i, j = 0;
 #endif
 	u32 key, multi = 0;
+	u8 pos;
 
 	pr_debug("test by nets\n");
 	for (; j < NLEN && h->nets[j].cidr[0] && !multi; j++) {
@@ -1190,7 +1199,8 @@ mtype_test_cidrs(struct ip_set *set, struct mtype_elem *d,
 		n = rcu_dereference_bh(hbucket(t, key));
 		if (!n)
 			continue;
-		for (i = 0; i < n->pos; i++) {
+		pos = smp_load_acquire(&n->pos);
+		for (i = 0; i < pos; i++) {
 			if (!test_bit(i, n->used))
 				continue;
 			data = ahash_data(n, i, set->dsize);
@@ -1224,6 +1234,7 @@ mtype_test(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 	struct mtype_elem *data;
 	int i, ret = 0;
 	u32 key, multi = 0;
+	u8 pos;
 
 	rcu_read_lock_bh();
 	t = rcu_dereference_bh(h->table);
@@ -1246,7 +1257,8 @@ mtype_test(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 		ret = 0;
 		goto out;
 	}
-	for (i = 0; i < n->pos; i++) {
+	pos = smp_load_acquire(&n->pos);
+	for (i = 0; i < pos; i++) {
 		if (!test_bit(i, n->used))
 			continue;
 		data = ahash_data(n, i, set->dsize);
@@ -1363,6 +1375,7 @@ mtype_list(const struct ip_set *set,
 	/* We assume that one hash bucket fills into one page */
 	void *incomplete;
 	int i, ret = 0;
+	u8 pos;
 
 	atd = nla_nest_start(skb, IPSET_ATTR_ADT);
 	if (!atd)
@@ -1381,7 +1394,8 @@ mtype_list(const struct ip_set *set,
 			 cb->args[IPSET_CB_ARG0], t, n);
 		if (!n)
 			continue;
-		for (i = 0; i < n->pos; i++) {
+		pos = smp_load_acquire(&n->pos);
+		for (i = 0; i < pos; i++) {
 			if (!test_bit(i, n->used))
 				continue;
 			e = ahash_data(n, i, set->dsize);
-- 
2.53.0



