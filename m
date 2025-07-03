Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAE5C2EF672;
	Thu,  3 Jul 2025 15:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555126; cv=none; b=UhVxFONbLeIuRVSc8oxjh6rv24fQUuXeOtMpyXF5GVF4RZl7qU1DzCGItePN4IwWU8Bf8R0+ynNnYKruMACMcg4LMYnYKEEWPyOu4CRLIu2J58Ns7ZpuoHUkbhAhEQzxas2InXffgfPJnP2lzqDgdmuEeKvQ4uQwwx8xAaJOreI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555126; c=relaxed/simple;
	bh=vfFIHgu+fu2v6a47NKJ2WMt4N1HJQ/p6zIEmagvT2Lg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sYoMdr7u9hpJ9WuTRx0qDWCSdxft4oHYglGwqr9GxfBUS4YnGC9BNV+cRppZjySukHpWNaB0tBrmfR8ADkZohRThKL13z0/btuXoRM0aUiyLajUwpnSwRSK5mGN6XOTqidtsUQ5eouFOqmQD3+mPKPVJq7nP5xeNoiXAeu5G3b8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jvjes4ME; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jvjes4ME"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28AE8C4CEEE;
	Thu,  3 Jul 2025 15:05:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555126;
	bh=vfFIHgu+fu2v6a47NKJ2WMt4N1HJQ/p6zIEmagvT2Lg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jvjes4ME3KmuGtEa47qeWkA4WuqFrpHZL7is/J5ihfpymmMY2iVZvZpVbAqg7ggLD
	 5jvnHPZa2kQ2AUzWvRJJKhglOPE25hKjCu8AjbXKb45+LPjQJNcB7oQuzZwmG8TuXK
	 kFFLY224F5iGa3c0M5PxX19wceCIZSwOqMBv2H68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuan-Wei Chiu <visitorckw@gmail.com>,
	Robert Pang <robertpang@google.com>,
	Coly Li <colyli@kernel.org>,
	"Ching-Chun (Jim) Huang" <jserv@ccns.ncku.edu.tw>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.15 183/263] Revert "bcache: update min_heap_callbacks to use default builtin swap"
Date: Thu,  3 Jul 2025 16:41:43 +0200
Message-ID: <20250703144011.681748426@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuan-Wei Chiu <visitorckw@gmail.com>

commit 845f1f2d69f3f49b3d8c142265952c8257e3368c upstream.

Patch series "bcache: Revert min_heap migration due to performance
regression".

This patch series reverts the migration of bcache from its original heap
implementation to the generic min_heap library.  While the original change
aimed to simplify the code and improve maintainability, it introduced a
severe performance regression in real-world scenarios.

As reported by Robert, systems using bcache now suffer from periodic
latency spikes, with P100 (max) latency increasing from 600 ms to 2.4
seconds every 5 minutes.  This degrades bcache's value as a low-latency
caching layer, and leads to frequent timeouts and application stalls in
production environments.

The primary cause of this regression is the behavior of the generic
min_heap implementation's bottom-up sift_down, which performs up to 2 *
log2(n) comparisons when many elements are equal.  The original top-down
variant used by bcache only required O(1) comparisons in such cases.  The
issue was further exacerbated by commit 92a8b224b833 ("lib/min_heap:
introduce non-inline versions of min heap API functions"), which
introduced non-inlined versions of the min_heap API, adding function call
overhead to a performance-critical hot path.


This patch (of 3):

This reverts commit 3d8a9a1c35227c3f1b0bd132c9f0a80dbda07b65.

Although removing the custom swap function simplified the code, this
change is part of a broader migration to the generic min_heap API that
introduced significant performance regressions in bcache.

As reported by Robert, bcache now suffers from latency spikes, with P100
(max) latency increasing from 600 ms to 2.4 seconds every 5 minutes.
These regressions degrade bcache's effectiveness as a low-latency cache
layer and lead to frequent timeouts and application stalls in production
environments.

This revert is part of a series of changes to restore previous performance
by undoing the min_heap transition.

Link: https://lkml.kernel.org/r/20250614202353.1632957-1-visitorckw@gmail.com
Link: https://lore.kernel.org/lkml/CAJhEC05+0S69z+3+FB2Cd0hD+pCRyWTKLEOsc8BOmH73p1m+KQ@mail.gmail.com
Link: https://lkml.kernel.org/r/20250614202353.1632957-2-visitorckw@gmail.com
Fixes: 866898efbb25 ("bcache: remove heap-related macros and switch to generic min_heap")
Fixes: 92a8b224b833 ("lib/min_heap: introduce non-inline versions of min heap API functions")
Signed-off-by: Kuan-Wei Chiu <visitorckw@gmail.com>
Reported-by: Robert Pang <robertpang@google.com>
Closes: https://lore.kernel.org/linux-bcache/CAJhEC06F_AtrPgw2-7CvCqZgeStgCtitbD-ryuPpXQA-JG5XXw@mail.gmail.com
Acked-by: Coly Li <colyli@kernel.org>
Cc: Ching-Chun (Jim) Huang <jserv@ccns.ncku.edu.tw>
Cc: Kent Overstreet <kent.overstreet@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/bcache/alloc.c    | 11 +++++++++--
 drivers/md/bcache/bset.c     | 14 +++++++++++---
 drivers/md/bcache/extents.c  | 10 +++++++++-
 drivers/md/bcache/movinggc.c | 10 +++++++++-
 4 files changed, 38 insertions(+), 7 deletions(-)

diff --git a/drivers/md/bcache/alloc.c b/drivers/md/bcache/alloc.c
index 8998e61efa40..da50f6661bae 100644
--- a/drivers/md/bcache/alloc.c
+++ b/drivers/md/bcache/alloc.c
@@ -189,16 +189,23 @@ static inline bool new_bucket_min_cmp(const void *l, const void *r, void *args)
 	return new_bucket_prio(ca, *lhs) < new_bucket_prio(ca, *rhs);
 }
 
+static inline void new_bucket_swap(void *l, void *r, void __always_unused *args)
+{
+	struct bucket **lhs = l, **rhs = r;
+
+	swap(*lhs, *rhs);
+}
+
 static void invalidate_buckets_lru(struct cache *ca)
 {
 	struct bucket *b;
 	const struct min_heap_callbacks bucket_max_cmp_callback = {
 		.less = new_bucket_max_cmp,
-		.swp = NULL,
+		.swp = new_bucket_swap,
 	};
 	const struct min_heap_callbacks bucket_min_cmp_callback = {
 		.less = new_bucket_min_cmp,
-		.swp = NULL,
+		.swp = new_bucket_swap,
 	};
 
 	ca->heap.nr = 0;
diff --git a/drivers/md/bcache/bset.c b/drivers/md/bcache/bset.c
index 68258a16e125..bd97d8626887 100644
--- a/drivers/md/bcache/bset.c
+++ b/drivers/md/bcache/bset.c
@@ -1093,6 +1093,14 @@ static inline bool new_btree_iter_cmp(const void *l, const void *r, void __alway
 	return bkey_cmp(_l->k, _r->k) <= 0;
 }
 
+static inline void new_btree_iter_swap(void *iter1, void *iter2, void __always_unused *args)
+{
+	struct btree_iter_set *_iter1 = iter1;
+	struct btree_iter_set *_iter2 = iter2;
+
+	swap(*_iter1, *_iter2);
+}
+
 static inline bool btree_iter_end(struct btree_iter *iter)
 {
 	return !iter->heap.nr;
@@ -1103,7 +1111,7 @@ void bch_btree_iter_push(struct btree_iter *iter, struct bkey *k,
 {
 	const struct min_heap_callbacks callbacks = {
 		.less = new_btree_iter_cmp,
-		.swp = NULL,
+		.swp = new_btree_iter_swap,
 	};
 
 	if (k != end)
@@ -1149,7 +1157,7 @@ static inline struct bkey *__bch_btree_iter_next(struct btree_iter *iter,
 	struct bkey *ret = NULL;
 	const struct min_heap_callbacks callbacks = {
 		.less = cmp,
-		.swp = NULL,
+		.swp = new_btree_iter_swap,
 	};
 
 	if (!btree_iter_end(iter)) {
@@ -1223,7 +1231,7 @@ static void btree_mergesort(struct btree_keys *b, struct bset *out,
 		: bch_ptr_invalid;
 	const struct min_heap_callbacks callbacks = {
 		.less = b->ops->sort_cmp,
-		.swp = NULL,
+		.swp = new_btree_iter_swap,
 	};
 
 	/* Heapify the iterator, using our comparison function */
diff --git a/drivers/md/bcache/extents.c b/drivers/md/bcache/extents.c
index 4b84fda1530a..a7221e5dbe81 100644
--- a/drivers/md/bcache/extents.c
+++ b/drivers/md/bcache/extents.c
@@ -266,12 +266,20 @@ static bool new_bch_extent_sort_cmp(const void *l, const void *r, void __always_
 	return !(c ? c > 0 : _l->k < _r->k);
 }
 
+static inline void new_btree_iter_swap(void *iter1, void *iter2, void __always_unused *args)
+{
+	struct btree_iter_set *_iter1 = iter1;
+	struct btree_iter_set *_iter2 = iter2;
+
+	swap(*_iter1, *_iter2);
+}
+
 static struct bkey *bch_extent_sort_fixup(struct btree_iter *iter,
 					  struct bkey *tmp)
 {
 	const struct min_heap_callbacks callbacks = {
 		.less = new_bch_extent_sort_cmp,
-		.swp = NULL,
+		.swp = new_btree_iter_swap,
 	};
 	while (iter->heap.nr > 1) {
 		struct btree_iter_set *top = iter->heap.data, *i = top + 1;
diff --git a/drivers/md/bcache/movinggc.c b/drivers/md/bcache/movinggc.c
index 45ca134cbf02..d6c73dd8eb2b 100644
--- a/drivers/md/bcache/movinggc.c
+++ b/drivers/md/bcache/movinggc.c
@@ -190,6 +190,14 @@ static bool new_bucket_cmp(const void *l, const void *r, void __always_unused *a
 	return GC_SECTORS_USED(*_l) >= GC_SECTORS_USED(*_r);
 }
 
+static void new_bucket_swap(void *l, void *r, void __always_unused *args)
+{
+	struct bucket **_l = l;
+	struct bucket **_r = r;
+
+	swap(*_l, *_r);
+}
+
 static unsigned int bucket_heap_top(struct cache *ca)
 {
 	struct bucket *b;
@@ -204,7 +212,7 @@ void bch_moving_gc(struct cache_set *c)
 	unsigned long sectors_to_move, reserve_sectors;
 	const struct min_heap_callbacks callbacks = {
 		.less = new_bucket_cmp,
-		.swp = NULL,
+		.swp = new_bucket_swap,
 	};
 
 	if (!c->copy_gc_enabled)
-- 
2.50.0



