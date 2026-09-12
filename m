Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFB613921DE;
	Sat, 12 Sep 2026 07:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789196655; cv=none; b=cPfY7sqMdp8NdgHCmtqlWb6ydHpfGyTFaKXvopJOKqi1hnTL0YE/5bsrAucBi5kPPywcsLvwcip/37velhh/pJGR4+g4iX+lEVaDWS+VfdUGUc3VYxOWM3Efwv0ZwmQeiqmoA6u7SftNnoCXDxoijLNWvImRZA+o8cfmX+i1VoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789196655; c=relaxed/simple;
	bh=AWTwM5Tz8KKVCWaeLwy2Bwxcx9Ew0inMogY1KHxdR6o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cnnk8MG7vn2OOKuIh7QGcFBODJvvKE61H3UkXOJBdkHdDSIRErfYwB7B3bDnzjN47vTSiCaNxOY4JJ+K2RWRY+JZNFbgvXnMQUEdaEgeOLQ+HC/Uft1LklX3wEiBTyNdzWrbWDJi7CDclFoFiyVBW3Q3FwIVVqj0tHYhxvcbgkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U1h8vgez; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U1h8vgez"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E2371F00893;
	Sat, 12 Sep 2026 07:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789196649;
	bh=uvxWG4WQd6WKGwkkpQVyGI8vMIk7fLx2pnFDujYIxhw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U1h8vgezJw8cROm3WKD8n7dk7Q6E+HoJPJKTOw4uQmOD5iRy5gZ1ZmkNt/+o3L7aB
	 ci7BH1JB1N/k6rXUPZTmj5JF5u7uzhSV6NBDvnSQK0uHNvem1f6ZJXNI2ITSOaztZ2
	 PFiSeH4JTxKUsb8JYDK1yCqGprh3XxyVsh+sBiz4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bryam Vargas <hexlabsecurity@proton.me>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0010/1815] dm-pcache: validate the persisted dirty_tail chain at load
Date: Sat, 12 Sep 2026 08:29:20 +0200
Message-ID: <20260912065649.250189031@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bryam Vargas <hexlabsecurity@proton.me>

[ Upstream commit 58d620ee9e01d4bdbceaf2ae1450d307a2a9d58b ]

The writeback worker follows the persisted dirty_tail chain, which is
decoded from the cache device independently of the key_tail chain that
cache_replay() walks and bounds. A crafted image, whose on-media fields are
authenticated only by a crc32c with a fixed seed, can aim dirty_tail at a
chain of last ksets that never terminates, so cache_writeback_fn() re-arms
itself with no delay forever.

Walk the dirty_tail chain once at load with the same hop cap cache_replay()
uses and fail the table load with -EIO if it does not reach an end within
n_segs hops.

Fixes: 1d57628ff95b ("dm-pcache: add persistent cache target in device-mapper")
Cc: stable@vger.kernel.org
Signed-off-by: Bryam Vargas <hexlabsecurity@proton.me>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
[ replaced the unavailable cache_seg_id_valid() helper with an equivalent bounds check against cache->cache_info.n_segs ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-pcache/cache.c     |    7 +++
 drivers/md/dm-pcache/cache.h     |    2 +
 drivers/md/dm-pcache/cache_key.c |   69 +++++++++++++++++++++++++++++++++++++++
 3 files changed, 78 insertions(+)

--- a/drivers/md/dm-pcache/cache.c
+++ b/drivers/md/dm-pcache/cache.c
@@ -202,6 +202,7 @@ static int cache_tail_init(struct pcache
 {
 	struct dm_pcache *pcache = CACHE_TO_PCACHE(cache);
 	bool new_cache = !(cache->cache_info.flags & PCACHE_CACHE_FLAGS_INIT_DONE);
+	int ret;
 
 	if (new_cache) {
 		__set_bit(0, cache->seg_map);
@@ -218,6 +219,12 @@ static int cache_tail_init(struct pcache
 			pcache_dev_err(pcache, "Corrupted key tail or dirty tail.\n");
 			return -EIO;
 		}
+
+		ret = cache_verify_dirty_tail(cache);
+		if (ret) {
+			pcache_dev_err(pcache, "dirty tail chain does not terminate (crafted cache image?)\n");
+			return ret;
+		}
 	}
 
 	return 0;
--- a/drivers/md/dm-pcache/cache.h
+++ b/drivers/md/dm-pcache/cache.h
@@ -666,6 +666,8 @@ static inline int cache_decode_dirty_tai
 				&cache->dirty_tail_index);
 }
 
+int cache_verify_dirty_tail(struct pcache_cache *cache);
+
 int pcache_cache_init(void);
 void pcache_cache_exit(void);
 #endif /* _PCACHE_CACHE_H */
--- a/drivers/md/dm-pcache/cache_key.c
+++ b/drivers/md/dm-pcache/cache_key.c
@@ -843,6 +843,75 @@ out:
 	return ret;
 }
 
+/*
+ * cache_verify_dirty_tail - reject a persisted dirty_tail whose last-kset
+ * chain does not terminate.
+ *
+ * dirty_tail is decoded independently of the key_tail chain cache_replay()
+ * walks, so replay's hop cap does not cover it. A crafted chain that loops
+ * back on itself makes the writeback worker re-arm forever; walk it once here
+ * with the same cap and fail the load if it does not end within n_segs hops.
+ */
+int cache_verify_dirty_tail(struct pcache_cache *cache)
+{
+	struct pcache_cache_pos pos;
+	struct pcache_cache_kset_onmedia *kset_onmedia;
+	u32 to_copy, last_hops = 0, count = 0;
+	int ret = 0;
+
+	kset_onmedia = kzalloc(PCACHE_KSET_ONMEDIA_SIZE_MAX, GFP_KERNEL);
+	if (!kset_onmedia)
+		return -ENOMEM;
+
+	cache_pos_copy(&pos, &cache->dirty_tail);
+
+	while (true) {
+		to_copy = min(PCACHE_KSET_ONMEDIA_SIZE_MAX, cache_seg_remain(&pos));
+		ret = copy_mc_to_kernel(kset_onmedia, cache_pos_addr(&pos), to_copy);
+		if (ret) {
+			ret = -EIO;
+			goto out;
+		}
+
+		/* A missing, short or corrupt kset is the normal end of the chain. */
+		if (!kset_onmedia_valid(kset_onmedia) ||
+		    kset_onmedia->crc != cache_kset_crc(kset_onmedia)) {
+			ret = 0;
+			goto out;
+		}
+
+		if (kset_onmedia->flags & PCACHE_KSET_FLAGS_LAST) {
+			if (kset_onmedia->next_cache_seg_id >= cache->cache_info.n_segs) {
+				ret = -EIO;
+				goto out;
+			}
+
+			if (++last_hops > cache->n_segs) {
+				ret = -EIO;
+				goto out;
+			}
+
+			pos.cache_seg = &cache->segments[kset_onmedia->next_cache_seg_id];
+			pos.seg_off = 0;
+			continue;
+		}
+
+		if (get_kset_onmedia_size(kset_onmedia) > cache_seg_remain(&pos)) {
+			ret = -EIO;
+			goto out;
+		}
+
+		cache_pos_advance(&pos, get_kset_onmedia_size(kset_onmedia));
+		if (++count > 512) {
+			cond_resched();
+			count = 0;
+		}
+	}
+out:
+	kfree(kset_onmedia);
+	return ret;
+}
+
 int cache_tree_init(struct pcache_cache *cache, struct pcache_cache_tree *cache_tree, u32 n_subtrees)
 {
 	int ret;


