Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37F602D7380;
	Tue, 13 Oct 2026 12:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894363; cv=none; b=Yv/EztjeXxHtFCDT4vvMrk5Pi+wtfTdl23CQ1pX2B8EeaurYeezrLpMUL7M5F5Aasrvupz/dnv25smEUYtoFKvTrUQwAIcXG37iFG0CurY42U0TfmSPV//RR3ZKWHX3PDB9QatsJhMeJ+aFQtp1gjwyeFdxuX5H/a3R3KnQJtlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894363; c=relaxed/simple;
	bh=OkTC0loufrYv8lKq0OFNnbaRlHLNFqyxuLYiF3rihys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MTEMJb5wNPviwV1cwNRF3DevyF2N2uc4WMah1ixQua8Od1BpWrC1OlDh7lUFPlR3b6/9L5pBTQYRHgG1CEit83knekjRHr4fh9HdY9r5lnuDzrGo9qzSTmOr8qpIEEH8u0DjPZpQBOLBFKnF7QHSUzCSArXwpX7fmUkwLbFVgCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MkGKhyyq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MkGKhyyq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 938E21F000FF;
	Tue, 13 Oct 2026 12:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894362;
	bh=xLJP6eyl11mrjc4zuPC28wzSr3UuS8KMfeuOIQWEEQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MkGKhyyq5Ed48wlVt8OjcMMmf031fc1MKOVkxqlN/Y4ElKXNRAsL0NEil+xvPQFHi
	 Lgf+Lf3FiKpd6Ny6vdJgw1OB7aOnXvhfB0cCEuLWZ35BmMl+MRslTD3kenz67q7FTa
	 8rP48kefcNjBzgim9pIkNVkF1QuuWEnnxvyW3Yto=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 491/621] dm-pcache: validate seg_id fields from persistent memory
Date: Tue, 13 Oct 2026 13:38:06 +0200
Message-ID: <20261013112932.480356572@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bryam Vargas <hexlabsecurity@proton.me>

[ Upstream commit 90c990a68460d7b5720e5634cf650eccdf0f4098 ]

cache_pos_decode(), cache_key_decode() and the last-kset branches of
cache_replay(), the writeback worker and the GC worker take a cache
segment id from the cache device metadata and index cache->segments[]
with it without checking it against cache->n_segs. That metadata is only
CRC-protected with a fixed public seed, so whoever supplies the cache
device on a table load (CAP_SYS_ADMIN) controls the id; an out-of-range
value forms a wild pcache_cache_segment pointer that is dereferenced and
written through -- an out-of-bounds read and write driven by on-disk data.

Add cache_seg_id_valid() and reject an out-of-range id at each decode
site, failing the operation with -EIO instead of indexing past the array.
Bound the id against the initialized-segment count (cache_info.n_segs)
rather than the physical device total. A forged cache_info.n_segs below
seg_num otherwise leaves segments[cache_info.n_segs..seg_num) as zeroed
structs whose data pointer is NULL, so a forged id in that window would
still be dereferenced. A later patch guarantees cache_info.n_segs <=
seg_num, and a driver-created cache sets the two equal, so valid images
are unaffected.

Fixes: 1d57628ff95b ("dm-pcache: add persistent cache target in device-mapper")
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-pcache/cache.c           |  4 ++++
 drivers/md/dm-pcache/cache.h           | 14 ++++++++++++++
 drivers/md/dm-pcache/cache_gc.c        | 16 ++++++++++++++--
 drivers/md/dm-pcache/cache_key.c       | 11 +++++++++++
 drivers/md/dm-pcache/cache_writeback.c | 20 ++++++++++++++++----
 5 files changed, 59 insertions(+), 6 deletions(-)

diff --git a/drivers/md/dm-pcache/cache.c b/drivers/md/dm-pcache/cache.c
index 8635fbf780aa0..013dfb171f0fc 100644
--- a/drivers/md/dm-pcache/cache.c
+++ b/drivers/md/dm-pcache/cache.c
@@ -118,6 +118,9 @@ int cache_pos_decode(struct pcache_cache *cache,
 	if (!latest_addr)
 		return -EIO;
 
+	if (!cache_seg_id_valid(cache, latest.cache_seg_id))
+		return -EIO;
+
 	pos->cache_seg = &cache->segments[latest.cache_seg_id];
 
 	if (latest.seg_off >= pos->cache_seg->segment.data_size)
@@ -158,6 +161,7 @@ static int cache_init(struct dm_pcache *pcache)
 	cache->cache_dev = &pcache->cache_dev;
 	cache->n_segs = cache_dev->seg_num;
 	atomic_set(&cache->gc_errors, 0);
+	atomic_set(&cache->writeback_errors, 0);
 	spin_lock_init(&cache->seg_map_lock);
 	spin_lock_init(&cache->key_head_lock);
 
diff --git a/drivers/md/dm-pcache/cache.h b/drivers/md/dm-pcache/cache.h
index bf61a4a487bc0..8809ec5ae943c 100644
--- a/drivers/md/dm-pcache/cache.h
+++ b/drivers/md/dm-pcache/cache.h
@@ -421,6 +421,20 @@ static inline bool cache_seg_is_ctrl_seg(u32 cache_seg_id)
 	return (cache_seg_id == 0);
 }
 
+/**
+ * cache_seg_id_valid - Validate a cache segment id read from the cache device.
+ * @cache: Pointer to the pcache_cache structure.
+ * @cache_seg_id: Segment id decoded from on-media metadata.
+ *
+ * On-media segment ids are only protected by a CRC, which an attacker who can
+ * format the cache device computes over their chosen value. Reject any id that
+ * would index cache->segments[] out of bounds before it is dereferenced.
+ */
+static inline bool cache_seg_id_valid(struct pcache_cache *cache, u32 cache_seg_id)
+{
+	return cache_seg_id < cache->cache_info.n_segs;
+}
+
 /**
  * cache_key_cutfront - Cuts a specified length from the front of a cache key.
  * @key: Pointer to pcache_cache_key structure.
diff --git a/drivers/md/dm-pcache/cache_gc.c b/drivers/md/dm-pcache/cache_gc.c
index 99999a92c4e67..d551848912b45 100644
--- a/drivers/md/dm-pcache/cache_gc.c
+++ b/drivers/md/dm-pcache/cache_gc.c
@@ -74,11 +74,17 @@ static bool need_gc(struct pcache_cache *cache, struct pcache_cache_pos *dirty_t
  * @cache: Pointer to the pcache_cache structure.
  * @kset_onmedia: Pointer to the kset_onmedia structure for the last kset.
  */
-static void last_kset_gc(struct pcache_cache *cache, struct pcache_cache_kset_onmedia *kset_onmedia)
+static int last_kset_gc(struct pcache_cache *cache, struct pcache_cache_kset_onmedia *kset_onmedia)
 {
 	struct dm_pcache *pcache = CACHE_TO_PCACHE(cache);
 	struct pcache_cache_segment *cur_seg, *next_seg;
 
+	if (!cache_seg_id_valid(cache, kset_onmedia->next_cache_seg_id)) {
+		pcache_dev_err(pcache, "invalid next_cache_seg_id %u in gc (n_segs %u)\n",
+				kset_onmedia->next_cache_seg_id, cache->n_segs);
+		return -EIO;
+	}
+
 	cur_seg = cache->key_tail.cache_seg;
 
 	next_seg = &cache->segments[kset_onmedia->next_cache_seg_id];
@@ -94,6 +100,8 @@ static void last_kset_gc(struct pcache_cache *cache, struct pcache_cache_kset_on
 	spin_lock(&cache->seg_map_lock);
 	__clear_bit(cur_seg->cache_seg_id, cache->seg_map);
 	spin_unlock(&cache->seg_map_lock);
+
+	return 0;
 }
 
 void pcache_cache_gc_fn(struct work_struct *work)
@@ -130,7 +138,11 @@ void pcache_cache_gc_fn(struct work_struct *work)
 			if (dirty_tail.cache_seg == key_tail.cache_seg)
 				break;
 
-			last_kset_gc(cache, kset_onmedia);
+			ret = last_kset_gc(cache, kset_onmedia);
+			if (ret) {
+				atomic_inc(&cache->gc_errors);
+				return;
+			}
 			continue;
 		}
 
diff --git a/drivers/md/dm-pcache/cache_key.c b/drivers/md/dm-pcache/cache_key.c
index c5a8ac02b216b..1526f5aa6a8db 100644
--- a/drivers/md/dm-pcache/cache_key.c
+++ b/drivers/md/dm-pcache/cache_key.c
@@ -103,6 +103,12 @@ int cache_key_decode(struct pcache_cache *cache,
 		return -EIO;
 	}
 
+	if (!cache_seg_id_valid(cache, key_onmedia->cache_seg_id)) {
+		pcache_dev_err(pcache, "invalid cache_seg_id %u in cache key (n_segs %u)\n",
+				key_onmedia->cache_seg_id, cache->n_segs);
+		return -EIO;
+	}
+
 	key->cache_pos.cache_seg = &cache->segments[key_onmedia->cache_seg_id];
 	key->cache_pos.seg_off = key_onmedia->cache_seg_off;
 
@@ -810,6 +816,11 @@ int cache_replay(struct pcache_cache *cache)
 				goto out;
 			}
 
+			if (!cache_seg_id_valid(cache, kset_onmedia->next_cache_seg_id)) {
+				ret = -EIO;
+				goto out;
+			}
+
 			next_seg = &cache->segments[kset_onmedia->next_cache_seg_id];
 
 			pos->cache_seg = next_seg;
diff --git a/drivers/md/dm-pcache/cache_writeback.c b/drivers/md/dm-pcache/cache_writeback.c
index 656e4d0489121..c8a4c8110a581 100644
--- a/drivers/md/dm-pcache/cache_writeback.c
+++ b/drivers/md/dm-pcache/cache_writeback.c
@@ -196,12 +196,18 @@ static int cache_kset_insert_tree(struct pcache_cache *cache, struct pcache_cach
 	return ret;
 }
 
-static void last_kset_writeback(struct pcache_cache *cache,
+static int last_kset_writeback(struct pcache_cache *cache,
 		struct pcache_cache_kset_onmedia *last_kset_onmedia)
 {
 	struct dm_pcache *pcache = CACHE_TO_PCACHE(cache);
 	struct pcache_cache_segment *next_seg;
 
+	if (!cache_seg_id_valid(cache, last_kset_onmedia->next_cache_seg_id)) {
+		pcache_dev_err(pcache, "invalid next_cache_seg_id %u in writeback (n_segs %u)\n",
+				last_kset_onmedia->next_cache_seg_id, cache->n_segs);
+		return -EIO;
+	}
+
 	pcache_dev_debug(pcache, "last kset, next: %u\n", last_kset_onmedia->next_cache_seg_id);
 
 	next_seg = &cache->segments[last_kset_onmedia->next_cache_seg_id];
@@ -211,6 +217,8 @@ static void last_kset_writeback(struct pcache_cache *cache,
 	cache->dirty_tail.seg_off = 0;
 	cache_encode_dirty_tail(cache);
 	mutex_unlock(&cache->dirty_tail_lock);
+
+	return 0;
 }
 
 void cache_writeback_fn(struct work_struct *work)
@@ -244,7 +252,11 @@ void cache_writeback_fn(struct work_struct *work)
 	}
 
 	if (kset_onmedia->flags & PCACHE_KSET_FLAGS_LAST) {
-		last_kset_writeback(cache, kset_onmedia);
+		ret = last_kset_writeback(cache, kset_onmedia);
+		if (ret) {
+			atomic_inc(&cache->writeback_errors);
+			goto unlock;
+		}
 		delay = 0;
 		goto queue_work;
 	}
@@ -256,8 +268,8 @@ void cache_writeback_fn(struct work_struct *work)
 
 	ret = cache_kset_insert_tree(cache, kset_onmedia);
 	if (ret) {
-		delay = PCACHE_CACHE_WRITEBACK_INTERVAL;
-		goto queue_work;
+		atomic_inc(&cache->writeback_errors);
+		goto unlock;
 	}
 
 	cache_wb_tree_writeback(cache, get_kset_onmedia_size(kset_onmedia));
-- 
2.53.0



