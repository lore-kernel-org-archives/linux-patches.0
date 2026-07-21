Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1F97415F12;
	Tue, 21 Jul 2026 21:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669551; cv=none; b=hxrTq2sRN1s9gfNnRmA7REQMpSZSEzfgQFbNbFA3c4WSVj36tmXcCfa7Rj/qIsiNHdcG/iEnCHPB40eMbe40+s/1i7zyoiFhMFNlFe66hOp8V7DT89hFwFJiT082Wk+vjHh0KUeqamBUVdUzATMZpMJXbMODPlZWIbr+Dy8ht30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669551; c=relaxed/simple;
	bh=vfTQglmcP+MrtR2//nhicHbfWX7m1uWy3dT6VHOzDSM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LvmC941TdYOr3TKlIf0VTiG3cHAM0JPxbn2v3//jmUhQLkOp8+ywhpUGQ6YU3ynOrkDD7srAxFPcjw6R7Za/Bba7Cch/3FydFYQdmfkBAZ/HZwmUNPm++kgc6Yjol8LeYOPBMJ+iDf89I2ysyAZjZZfQxxzPRQKhcZJRZxR9nOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z4LgkdQ4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z4LgkdQ4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 629381F00A3A;
	Tue, 21 Jul 2026 21:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669549;
	bh=nChqbfdqZREINBXwWEkKSAu+KtHzSHMFqp2QxHsD+hA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z4LgkdQ4Gheekm1cAUGxFGR9u7eU+xE49gBQ7YIzRadUjKjmoGg4LjFLSJGtElXLh
	 WyuK8oc4vsHlAhNjhWBOgdD5rG5WgWcsc/a61wsN7BBHig0sX7+pcQSu6HrLzeqZPb
	 KJXVjsQe0np7FFUZf+2U+1j5ADisqBj89iKFz348=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jozsef Kadlecsik <kadlec@netfilter.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0596/1067] netfilter: ipset: annotate "pos" for concurrent readers/writers
Date: Tue, 21 Jul 2026 17:19:57 +0200
Message-ID: <20260721152437.938027093@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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
index dea04887b8e699..25c51a8e2bfb12 100644
--- a/net/netfilter/ipset/ip_set_hash_gen.h
+++ b/net/netfilter/ipset/ip_set_hash_gen.h
@@ -373,8 +373,9 @@ static void
 mtype_ext_cleanup(struct ip_set *set, struct hbucket *n)
 {
 	int i;
+	u8 pos = smp_load_acquire(&n->pos);
 
-	for (i = 0; i < n->pos; i++)
+	for (i = 0; i < pos; i++)
 		if (test_bit(i, n->used))
 			ip_set_ext_destroy(set, ahash_data(n, i, set->dsize));
 }
@@ -477,7 +478,7 @@ mtype_gc_do(struct ip_set *set, struct htype *h, struct htable *t, u32 r)
 #ifdef IP_SET_HASH_WITH_NETS
 	u8 k;
 #endif
-	u8 htable_bits = t->htable_bits;
+	u8 pos, htable_bits = t->htable_bits;
 
 	spin_lock_bh(&t->hregion[r].lock);
 	for (i = ahash_bucket_start(r, htable_bits);
@@ -485,7 +486,8 @@ mtype_gc_do(struct ip_set *set, struct htype *h, struct htable *t, u32 r)
 		n = __ipset_dereference(hbucket(t, i));
 		if (!n)
 			continue;
-		for (j = 0, d = 0; j < n->pos; j++) {
+		pos = smp_load_acquire(&n->pos);
+		for (j = 0, d = 0; j < pos; j++) {
 			if (!test_bit(j, n->used)) {
 				d++;
 				continue;
@@ -521,7 +523,7 @@ mtype_gc_do(struct ip_set *set, struct htype *h, struct htable *t, u32 r)
 				/* Still try to delete expired elements. */
 				continue;
 			tmp->size = n->size - AHASH_INIT_SIZE;
-			for (j = 0, d = 0; j < n->pos; j++) {
+			for (j = 0, d = 0; j < pos; j++) {
 				if (!test_bit(j, n->used))
 					continue;
 				data = ahash_data(n, j, dsize);
@@ -610,7 +612,7 @@ mtype_resize(struct ip_set *set, bool retried)
 {
 	struct htype *h = set->data;
 	struct htable *t, *orig;
-	u8 htable_bits;
+	u8 pos, htable_bits;
 	size_t hsize, dsize = set->dsize;
 #ifdef IP_SET_HASH_WITH_NETS
 	u8 flags;
@@ -672,7 +674,8 @@ mtype_resize(struct ip_set *set, bool retried)
 			n = __ipset_dereference(hbucket(orig, i));
 			if (!n)
 				continue;
-			for (j = 0; j < n->pos; j++) {
+			pos = smp_load_acquire(&n->pos);
+			for (j = 0; j < pos; j++) {
 				if (!test_bit(j, n->used))
 					continue;
 				data = ahash_data(n, j, dsize);
@@ -796,9 +799,10 @@ mtype_ext_size(struct ip_set *set, u32 *elements, size_t *ext_size)
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
@@ -807,7 +811,8 @@ mtype_ext_size(struct ip_set *set, u32 *elements, size_t *ext_size)
 			n = rcu_dereference_bh(hbucket(t, i));
 			if (!n)
 				continue;
-			for (j = 0; j < n->pos; j++) {
+			pos = smp_load_acquire(&n->pos);
+			for (j = 0; j < pos; j++) {
 				if (!test_bit(j, n->used))
 					continue;
 				data = ahash_data(n, j, set->dsize);
@@ -831,10 +836,11 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
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
@@ -876,8 +882,8 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
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
@@ -921,7 +927,7 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 	if (elements >= maxelem)
 		goto set_full;
 	/* Create a new slot */
-	if (n->pos >= n->size) {
+	if (npos >= n->size) {
 #ifdef IP_SET_HASH_WITH_MULTI
 		if (h->bucketsize >= AHASH_MAX_TUNED)
 			goto set_full;
@@ -950,8 +956,7 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 	}
 
 copy_elem:
-	j = npos;
-	npos = n->pos + 1;
+	j = npos++;
 	data = ahash_data(n, j, set->dsize);
 copy_data:
 	t->hregion[r].elements++;
@@ -974,7 +979,8 @@ mtype_add(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 	if (SET_WITH_TIMEOUT(set))
 		ip_set_timeout_set(ext_timeout(data, set), ext->timeout);
 	smp_mb__before_atomic();
-	n->pos = npos;
+	/* Ensure all data writes are visible before updating position */
+	smp_store_release(&n->pos, npos);
 	set_bit(j, n->used);
 	if (old != ERR_PTR(-ENOENT)) {
 		rcu_assign_pointer(hbucket(t, key), n);
@@ -1033,6 +1039,7 @@ mtype_del(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 	int i, j, k, r, ret = -IPSET_ERR_EXIST;
 	u32 key, multi = 0;
 	size_t dsize = set->dsize;
+	u8 pos;
 
 	/* Userspace add and resize is excluded by the mutex.
 	 * Kernespace add does not trigger resize.
@@ -1048,7 +1055,8 @@ mtype_del(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 	n = rcu_dereference_bh(hbucket(t, key));
 	if (!n)
 		goto out;
-	for (i = 0, k = 0; i < n->pos; i++) {
+	pos = smp_load_acquire(&n->pos);
+	for (i = 0, k = 0; i < pos; i++) {
 		if (!test_bit(i, n->used)) {
 			k++;
 			continue;
@@ -1062,8 +1070,8 @@ mtype_del(struct ip_set *set, void *value, const struct ip_set_ext *ext,
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
@@ -1085,11 +1093,11 @@ mtype_del(struct ip_set *set, void *value, const struct ip_set_ext *ext,
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
@@ -1100,7 +1108,7 @@ mtype_del(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 			if (!tmp)
 				goto out;
 			tmp->size = n->size - AHASH_INIT_SIZE;
-			for (j = 0, k = 0; j < n->pos; j++) {
+			for (j = 0, k = 0; j < pos; j++) {
 				if (!test_bit(j, n->used))
 					continue;
 				data = ahash_data(n, j, dsize);
@@ -1161,6 +1169,7 @@ mtype_test_cidrs(struct ip_set *set, struct mtype_elem *d,
 	int ret, i, j = 0;
 #endif
 	u32 key, multi = 0;
+	u8 pos;
 
 	pr_debug("test by nets\n");
 	for (; j < NLEN && h->nets[j].cidr[0] && !multi; j++) {
@@ -1178,7 +1187,8 @@ mtype_test_cidrs(struct ip_set *set, struct mtype_elem *d,
 		n = rcu_dereference_bh(hbucket(t, key));
 		if (!n)
 			continue;
-		for (i = 0; i < n->pos; i++) {
+		pos = smp_load_acquire(&n->pos);
+		for (i = 0; i < pos; i++) {
 			if (!test_bit(i, n->used))
 				continue;
 			data = ahash_data(n, i, set->dsize);
@@ -1212,6 +1222,7 @@ mtype_test(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 	struct mtype_elem *data;
 	int i, ret = 0;
 	u32 key, multi = 0;
+	u8 pos;
 
 	rcu_read_lock_bh();
 	t = rcu_dereference_bh(h->table);
@@ -1234,7 +1245,8 @@ mtype_test(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 		ret = 0;
 		goto out;
 	}
-	for (i = 0; i < n->pos; i++) {
+	pos = smp_load_acquire(&n->pos);
+	for (i = 0; i < pos; i++) {
 		if (!test_bit(i, n->used))
 			continue;
 		data = ahash_data(n, i, set->dsize);
@@ -1339,6 +1351,7 @@ mtype_list(const struct ip_set *set,
 	/* We assume that one hash bucket fills into one page */
 	void *incomplete;
 	int i, ret = 0;
+	u8 pos;
 
 	atd = nla_nest_start(skb, IPSET_ATTR_ADT);
 	if (!atd)
@@ -1357,7 +1370,8 @@ mtype_list(const struct ip_set *set,
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



