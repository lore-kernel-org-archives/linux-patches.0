Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42AEE18A6C5;
	Wed,  5 Feb 2025 14:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767336; cv=none; b=FvJlqaTjptvkYQFu1saFJ53G055w7d+2Qe9UJwHq32s1llrZZyfai3cnDBWgo3Zemy588JeYH9iXzhYt2B4Eoye5odkG7sQ4jpvx4WUxdc5Hq2i79iLx+QUkXKWp47jEGAr0dsJkHfZYhBQIVEV0S6YcMk/cD2TxdMMZGyNIR6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767336; c=relaxed/simple;
	bh=IKUNSqw/uYZSklqY9I37VWObGQe2P7d+yXydux+15Kw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=raxXJW33fQWuJMEPTXGV5BaHACVbP5Cl7rBc4ZpmQtvw87fHPuks8Agb3l1Cu71UKgEmpNdDovE4gZY1NanYBjAgFSso3oN1XJ1s9Cnr0J9IcEHbeYGR5TNIaRcKQfGreJ+YkSjptwGc4A5/niG765mRf9jRxPYIe/9f3xxGUDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w8M+LBbg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w8M+LBbg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A15D7C4CEDD;
	Wed,  5 Feb 2025 14:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767336;
	bh=IKUNSqw/uYZSklqY9I37VWObGQe2P7d+yXydux+15Kw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w8M+LBbgqnjzS3uyc3AgQY9Ogakx5SAb3n5w6NE/nKUD9DDqXrh/iA5+mHdThrtnh
	 dq9QvTphoZyLv69ljGT8QNxNd2jPaNp0dbuVNpW31i+bOwj4Piy+VT5riXBL3+nqf0
	 9F/AQefZL+mqXzgUjZTseGKv6bX3YKGn9zfNVusY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 441/590] erofs: sunset `struct erofs_workgroup`
Date: Wed,  5 Feb 2025 14:43:16 +0100
Message-ID: <20250205134512.140294662@linuxfoundation.org>
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

From: Gao Xiang <hsiangkao@linux.alibaba.com>

[ Upstream commit bf1aa03980f4eb1599b866ccd2c4ac577ef56a8a ]

`struct erofs_workgroup` was introduced to provide a unique header
for all physically indexed objects.  However, after big pclusters and
shared pclusters are implemented upstream, it seems that all EROFS
encoded data (which requires transformation) can be represented with
`struct z_erofs_pcluster` directly.

Move all members into `struct z_erofs_pcluster` for simplicity.

Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Link: https://lore.kernel.org/r/20241021035323.3280682-3-hsiangkao@linux.alibaba.com
Stable-dep-of: db902986dee4 ("erofs: fix potential return value overflow of z_erofs_shrink_scan()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/internal.h |   6 --
 fs/erofs/zdata.c    | 131 ++++++++++++++++++++------------------------
 2 files changed, 60 insertions(+), 77 deletions(-)

diff --git a/fs/erofs/internal.h b/fs/erofs/internal.h
index 5fbc76b65f5c3..edbabb3256c9a 100644
--- a/fs/erofs/internal.h
+++ b/fs/erofs/internal.h
@@ -205,12 +205,6 @@ enum {
 	EROFS_ZIP_CACHE_READAROUND
 };
 
-/* basic unit of the workstation of a super_block */
-struct erofs_workgroup {
-	pgoff_t index;
-	struct lockref lockref;
-};
-
 enum erofs_kmap_type {
 	EROFS_NO_KMAP,		/* don't map the buffer */
 	EROFS_KMAP,		/* use kmap_local_page() to map the buffer */
diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
index d2235f2a0acdc..6be6146b67d9c 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -44,12 +44,15 @@ __Z_EROFS_BVSET(z_erofs_bvset_inline, Z_EROFS_INLINE_BVECS);
  * A: Field should be accessed / updated in atomic for parallelized code.
  */
 struct z_erofs_pcluster {
-	struct erofs_workgroup obj;
 	struct mutex lock;
+	struct lockref lockref;
 
 	/* A: point to next chained pcluster or TAILs */
 	z_erofs_next_pcluster_t next;
 
+	/* I: start block address of this pcluster */
+	erofs_off_t index;
+
 	/* L: the maximum decompression size of this round */
 	unsigned int length;
 
@@ -108,7 +111,7 @@ struct z_erofs_decompressqueue {
 
 static inline bool z_erofs_is_inline_pcluster(struct z_erofs_pcluster *pcl)
 {
-	return !pcl->obj.index;
+	return !pcl->index;
 }
 
 static inline unsigned int z_erofs_pclusterpages(struct z_erofs_pcluster *pcl)
@@ -548,7 +551,7 @@ static void z_erofs_bind_cache(struct z_erofs_decompress_frontend *fe)
 		if (READ_ONCE(pcl->compressed_bvecs[i].page))
 			continue;
 
-		page = find_get_page(mc, pcl->obj.index + i);
+		page = find_get_page(mc, pcl->index + i);
 		if (!page) {
 			/* I/O is needed, no possible to decompress directly */
 			standalone = false;
@@ -564,13 +567,13 @@ static void z_erofs_bind_cache(struct z_erofs_decompress_frontend *fe)
 				continue;
 			set_page_private(newpage, Z_EROFS_PREALLOCATED_PAGE);
 		}
-		spin_lock(&pcl->obj.lockref.lock);
+		spin_lock(&pcl->lockref.lock);
 		if (!pcl->compressed_bvecs[i].page) {
 			pcl->compressed_bvecs[i].page = page ? page : newpage;
-			spin_unlock(&pcl->obj.lockref.lock);
+			spin_unlock(&pcl->lockref.lock);
 			continue;
 		}
-		spin_unlock(&pcl->obj.lockref.lock);
+		spin_unlock(&pcl->lockref.lock);
 
 		if (page)
 			put_page(page);
@@ -588,10 +591,8 @@ static void z_erofs_bind_cache(struct z_erofs_decompress_frontend *fe)
 
 /* (erofs_shrinker) disconnect cached encoded data with pclusters */
 static int erofs_try_to_free_all_cached_folios(struct erofs_sb_info *sbi,
-					       struct erofs_workgroup *grp)
+					       struct z_erofs_pcluster *pcl)
 {
-	struct z_erofs_pcluster *const pcl =
-		container_of(grp, struct z_erofs_pcluster, obj);
 	unsigned int pclusterpages = z_erofs_pclusterpages(pcl);
 	struct folio *folio;
 	int i;
@@ -626,8 +627,8 @@ static bool z_erofs_cache_release_folio(struct folio *folio, gfp_t gfp)
 		return true;
 
 	ret = false;
-	spin_lock(&pcl->obj.lockref.lock);
-	if (pcl->obj.lockref.count <= 0) {
+	spin_lock(&pcl->lockref.lock);
+	if (pcl->lockref.count <= 0) {
 		DBG_BUGON(z_erofs_is_inline_pcluster(pcl));
 		for (; bvec < end; ++bvec) {
 			if (bvec->page && page_folio(bvec->page) == folio) {
@@ -638,7 +639,7 @@ static bool z_erofs_cache_release_folio(struct folio *folio, gfp_t gfp)
 			}
 		}
 	}
-	spin_unlock(&pcl->obj.lockref.lock);
+	spin_unlock(&pcl->lockref.lock);
 	return ret;
 }
 
@@ -689,15 +690,15 @@ static int z_erofs_attach_page(struct z_erofs_decompress_frontend *fe,
 
 	if (exclusive) {
 		/* give priority for inplaceio to use file pages first */
-		spin_lock(&pcl->obj.lockref.lock);
+		spin_lock(&pcl->lockref.lock);
 		while (fe->icur > 0) {
 			if (pcl->compressed_bvecs[--fe->icur].page)
 				continue;
 			pcl->compressed_bvecs[fe->icur] = *bvec;
-			spin_unlock(&pcl->obj.lockref.lock);
+			spin_unlock(&pcl->lockref.lock);
 			return 0;
 		}
-		spin_unlock(&pcl->obj.lockref.lock);
+		spin_unlock(&pcl->lockref.lock);
 
 		/* otherwise, check if it can be used as a bvpage */
 		if (fe->mode >= Z_EROFS_PCLUSTER_FOLLOWED &&
@@ -710,20 +711,20 @@ static int z_erofs_attach_page(struct z_erofs_decompress_frontend *fe,
 	return ret;
 }
 
-static bool z_erofs_get_pcluster(struct erofs_workgroup *grp)
+static bool z_erofs_get_pcluster(struct z_erofs_pcluster *pcl)
 {
-	if (lockref_get_not_zero(&grp->lockref))
+	if (lockref_get_not_zero(&pcl->lockref))
 		return true;
 
-	spin_lock(&grp->lockref.lock);
-	if (__lockref_is_dead(&grp->lockref)) {
-		spin_unlock(&grp->lockref.lock);
+	spin_lock(&pcl->lockref.lock);
+	if (__lockref_is_dead(&pcl->lockref)) {
+		spin_unlock(&pcl->lockref.lock);
 		return false;
 	}
 
-	if (!grp->lockref.count++)
+	if (!pcl->lockref.count++)
 		atomic_long_dec(&erofs_global_shrink_cnt);
-	spin_unlock(&grp->lockref.lock);
+	spin_unlock(&pcl->lockref.lock);
 	return true;
 }
 
@@ -733,8 +734,7 @@ static int z_erofs_register_pcluster(struct z_erofs_decompress_frontend *fe)
 	struct super_block *sb = fe->inode->i_sb;
 	struct erofs_sb_info *sbi = EROFS_SB(sb);
 	bool ztailpacking = map->m_flags & EROFS_MAP_META;
-	struct z_erofs_pcluster *pcl;
-	struct erofs_workgroup *grp, *pre;
+	struct z_erofs_pcluster *pcl, *pre;
 	int err;
 
 	if (!(map->m_flags & EROFS_MAP_ENCODED) ||
@@ -748,8 +748,8 @@ static int z_erofs_register_pcluster(struct z_erofs_decompress_frontend *fe)
 	if (IS_ERR(pcl))
 		return PTR_ERR(pcl);
 
-	spin_lock_init(&pcl->obj.lockref.lock);
-	pcl->obj.lockref.count = 1;	/* one ref for this request */
+	spin_lock_init(&pcl->lockref.lock);
+	pcl->lockref.count = 1;		/* one ref for this request */
 	pcl->algorithmformat = map->m_algorithmformat;
 	pcl->length = 0;
 	pcl->partial = true;
@@ -767,13 +767,13 @@ static int z_erofs_register_pcluster(struct z_erofs_decompress_frontend *fe)
 	DBG_BUGON(!mutex_trylock(&pcl->lock));
 
 	if (ztailpacking) {
-		pcl->obj.index = 0;	/* which indicates ztailpacking */
+		pcl->index = 0;		/* which indicates ztailpacking */
 	} else {
-		pcl->obj.index = erofs_blknr(sb, map->m_pa);
+		pcl->index = erofs_blknr(sb, map->m_pa);
 		while (1) {
 			xa_lock(&sbi->managed_pslots);
-			pre = __xa_cmpxchg(&sbi->managed_pslots, grp->index,
-					   NULL, grp, GFP_KERNEL);
+			pre = __xa_cmpxchg(&sbi->managed_pslots, pcl->index,
+					   NULL, pcl, GFP_KERNEL);
 			if (!pre || xa_is_err(pre) || z_erofs_get_pcluster(pre)) {
 				xa_unlock(&sbi->managed_pslots);
 				break;
@@ -786,8 +786,7 @@ static int z_erofs_register_pcluster(struct z_erofs_decompress_frontend *fe)
 			err = xa_err(pre);
 			goto err_out;
 		} else if (pre) {
-			fe->pcl = container_of(pre,
-					struct z_erofs_pcluster, obj);
+			fe->pcl = pre;
 			err = -EEXIST;
 			goto err_out;
 		}
@@ -807,7 +806,7 @@ static int z_erofs_pcluster_begin(struct z_erofs_decompress_frontend *fe)
 	struct erofs_map_blocks *map = &fe->map;
 	struct super_block *sb = fe->inode->i_sb;
 	erofs_blk_t blknr = erofs_blknr(sb, map->m_pa);
-	struct erofs_workgroup *grp = NULL;
+	struct z_erofs_pcluster *pcl = NULL;
 	int ret;
 
 	DBG_BUGON(fe->pcl);
@@ -817,9 +816,9 @@ static int z_erofs_pcluster_begin(struct z_erofs_decompress_frontend *fe)
 	if (!(map->m_flags & EROFS_MAP_META)) {
 		while (1) {
 			rcu_read_lock();
-			grp = xa_load(&EROFS_SB(sb)->managed_pslots, blknr);
-			if (!grp || z_erofs_get_pcluster(grp)) {
-				DBG_BUGON(grp && blknr != grp->index);
+			pcl = xa_load(&EROFS_SB(sb)->managed_pslots, blknr);
+			if (!pcl || z_erofs_get_pcluster(pcl)) {
+				DBG_BUGON(pcl && blknr != pcl->index);
 				rcu_read_unlock();
 				break;
 			}
@@ -830,8 +829,8 @@ static int z_erofs_pcluster_begin(struct z_erofs_decompress_frontend *fe)
 		return -EFSCORRUPTED;
 	}
 
-	if (grp) {
-		fe->pcl = container_of(grp, struct z_erofs_pcluster, obj);
+	if (pcl) {
+		fe->pcl = pcl;
 		ret = -EEXIST;
 	} else {
 		ret = z_erofs_register_pcluster(fe);
@@ -886,21 +885,13 @@ static void z_erofs_rcu_callback(struct rcu_head *head)
 			struct z_erofs_pcluster, rcu));
 }
 
-static void erofs_workgroup_free_rcu(struct erofs_workgroup *grp)
-{
-	struct z_erofs_pcluster *const pcl =
-		container_of(grp, struct z_erofs_pcluster, obj);
-
-	call_rcu(&pcl->rcu, z_erofs_rcu_callback);
-}
-
 static bool erofs_try_to_release_pcluster(struct erofs_sb_info *sbi,
-					  struct erofs_workgroup *grp)
+					  struct z_erofs_pcluster *pcl)
 {
 	int free = false;
 
-	spin_lock(&grp->lockref.lock);
-	if (grp->lockref.count)
+	spin_lock(&pcl->lockref.lock);
+	if (pcl->lockref.count)
 		goto out;
 
 	/*
@@ -908,22 +899,22 @@ static bool erofs_try_to_release_pcluster(struct erofs_sb_info *sbi,
 	 * the XArray.  Otherwise some folios could be still attached to the
 	 * orphan old pcluster when the new one is available in the tree.
 	 */
-	if (erofs_try_to_free_all_cached_folios(sbi, grp))
+	if (erofs_try_to_free_all_cached_folios(sbi, pcl))
 		goto out;
 
 	/*
 	 * It's impossible to fail after the pcluster is freezed, but in order
 	 * to avoid some race conditions, add a DBG_BUGON to observe this.
 	 */
-	DBG_BUGON(__xa_erase(&sbi->managed_pslots, grp->index) != grp);
+	DBG_BUGON(__xa_erase(&sbi->managed_pslots, pcl->index) != pcl);
 
-	lockref_mark_dead(&grp->lockref);
+	lockref_mark_dead(&pcl->lockref);
 	free = true;
 out:
-	spin_unlock(&grp->lockref.lock);
+	spin_unlock(&pcl->lockref.lock);
 	if (free) {
 		atomic_long_dec(&erofs_global_shrink_cnt);
-		erofs_workgroup_free_rcu(grp);
+		call_rcu(&pcl->rcu, z_erofs_rcu_callback);
 	}
 	return free;
 }
@@ -931,14 +922,14 @@ static bool erofs_try_to_release_pcluster(struct erofs_sb_info *sbi,
 unsigned long z_erofs_shrink_scan(struct erofs_sb_info *sbi,
 				  unsigned long nr_shrink)
 {
-	struct erofs_workgroup *grp;
+	struct z_erofs_pcluster *pcl;
 	unsigned int freed = 0;
 	unsigned long index;
 
 	xa_lock(&sbi->managed_pslots);
-	xa_for_each(&sbi->managed_pslots, index, grp) {
+	xa_for_each(&sbi->managed_pslots, index, pcl) {
 		/* try to shrink each valid pcluster */
-		if (!erofs_try_to_release_pcluster(sbi, grp))
+		if (!erofs_try_to_release_pcluster(sbi, pcl))
 			continue;
 		xa_unlock(&sbi->managed_pslots);
 
@@ -953,16 +944,14 @@ unsigned long z_erofs_shrink_scan(struct erofs_sb_info *sbi,
 
 static void z_erofs_put_pcluster(struct z_erofs_pcluster *pcl)
 {
-	struct erofs_workgroup *grp = &pcl->obj;
-
-	if (lockref_put_or_lock(&grp->lockref))
+	if (lockref_put_or_lock(&pcl->lockref))
 		return;
 
-	DBG_BUGON(__lockref_is_dead(&grp->lockref));
-	if (grp->lockref.count == 1)
+	DBG_BUGON(__lockref_is_dead(&pcl->lockref));
+	if (pcl->lockref.count == 1)
 		atomic_long_inc(&erofs_global_shrink_cnt);
-	--grp->lockref.count;
-	spin_unlock(&grp->lockref.lock);
+	--pcl->lockref.count;
+	spin_unlock(&pcl->lockref.lock);
 }
 
 static void z_erofs_pcluster_end(struct z_erofs_decompress_frontend *fe)
@@ -1497,9 +1486,9 @@ static void z_erofs_fill_bio_vec(struct bio_vec *bvec,
 	bvec->bv_offset = 0;
 	bvec->bv_len = PAGE_SIZE;
 repeat:
-	spin_lock(&pcl->obj.lockref.lock);
+	spin_lock(&pcl->lockref.lock);
 	zbv = pcl->compressed_bvecs[nr];
-	spin_unlock(&pcl->obj.lockref.lock);
+	spin_unlock(&pcl->lockref.lock);
 	if (!zbv.page)
 		goto out_allocfolio;
 
@@ -1561,23 +1550,23 @@ static void z_erofs_fill_bio_vec(struct bio_vec *bvec,
 	folio_put(folio);
 out_allocfolio:
 	page = __erofs_allocpage(&f->pagepool, gfp, true);
-	spin_lock(&pcl->obj.lockref.lock);
+	spin_lock(&pcl->lockref.lock);
 	if (unlikely(pcl->compressed_bvecs[nr].page != zbv.page)) {
 		if (page)
 			erofs_pagepool_add(&f->pagepool, page);
-		spin_unlock(&pcl->obj.lockref.lock);
+		spin_unlock(&pcl->lockref.lock);
 		cond_resched();
 		goto repeat;
 	}
 	pcl->compressed_bvecs[nr].page = page ? page : ERR_PTR(-ENOMEM);
-	spin_unlock(&pcl->obj.lockref.lock);
+	spin_unlock(&pcl->lockref.lock);
 	bvec->bv_page = page;
 	if (!page)
 		return;
 	folio = page_folio(page);
 out_tocache:
 	if (!tocache || bs != PAGE_SIZE ||
-	    filemap_add_folio(mc, folio, pcl->obj.index + nr, gfp)) {
+	    filemap_add_folio(mc, folio, pcl->index + nr, gfp)) {
 		/* turn into a temporary shortlived folio (1 ref) */
 		folio->private = (void *)Z_EROFS_SHORTLIVED_PAGE;
 		return;
@@ -1709,7 +1698,7 @@ static void z_erofs_submit_queue(struct z_erofs_decompress_frontend *f,
 
 		/* no device id here, thus it will always succeed */
 		mdev = (struct erofs_map_dev) {
-			.m_pa = erofs_pos(sb, pcl->obj.index),
+			.m_pa = erofs_pos(sb, pcl->index),
 		};
 		(void)erofs_map_dev(sb, &mdev);
 
-- 
2.39.5



