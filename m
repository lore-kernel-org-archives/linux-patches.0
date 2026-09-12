Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4695A3385A5;
	Sat, 12 Sep 2026 13:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789218567; cv=none; b=FqTcjQgoCWUMNIIOFDXbld+/GE/kakUfoE8IUYzVm4UYp4TCm7/QpUHETmDFAqFYI0zx9BGrVbTNORKCqfN4f80c73UHM2JEfvJCuPty6wbgHw/wwHvh35vv0UDYGoA84XXdAkpxJNWlXr3+6vS+eQYFwF6szwj9X9Pi/kYfk+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789218567; c=relaxed/simple;
	bh=Am3ZU/O0PZeLNup+zdeXwUVbYk9XXorCk/ploKxjV4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QPBZCO7a9zEBfGfa/A5mDi/K6m+IICcEemKfG28mu6Mm+B7FD0Y+cB3/EP8h3Ci5f4l49knq/v6/ibORVEw9bIx6kLpkNGXG2gGBezu9nhK4MBhDeSbOHasoWmBVRnCWo6r8LBRuv+8Do6KPAp/zYRcSAlOj1ujSDm3b4PFjBgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kKDIt+Mm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kKDIt+Mm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 016251F000FF;
	Sat, 12 Sep 2026 13:09:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789218565;
	bh=2j/DlWAwaUAKbdaPkqewmNfwCsOHLPuW7PEKq4M2FqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kKDIt+MmTV5roDKF3B6FmpuOOTnOFV9MfVbUei966xzhTT+Tf+ORI40+nWe60h9Z9
	 IWdz97Dw/MyeDo+N0+RNrV27PXxOcHMAWv+AECkpq027v36Xoh5WEf8nAhw8tSSR8f
	 ihBsZzTUg4TMnYBScaBGxRrPyl0Dzbfzyft9i9X0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Chao Yu <chao@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1172/1376] erofs: support unaligned encoded data
Date: Sat, 12 Sep 2026 08:59:58 +0200
Message-ID: <20260912065633.673196974@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gao Xiang <hsiangkao@linux.alibaba.com>

[ Upstream commit 7361d1e3763baaf7b9349c576137851458ad38d1 ]

We're almost there.  It's straight-forward to adapt the current
decompression subsystem to support unaligned encoded (compressed) data.

Note that unaligned data is not encouraged because of worse I/O and
caching efficiency unless the corresponding compressor doesn't support
fixed-sized output compression natively like Zstd.

Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Acked-by: Chao Yu <chao@kernel.org>
Link: https://lore.kernel.org/r/20250310095459.2620647-10-hsiangkao@linux.alibaba.com
Stable-dep-of: 988c3c186c73 ("erofs: fix unused pcluster_pools for higher page sizes")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/decompressor.c |  2 +-
 fs/erofs/zdata.c        | 92 ++++++++++++++++++++---------------------
 2 files changed, 46 insertions(+), 48 deletions(-)

diff --git a/fs/erofs/decompressor.c b/fs/erofs/decompressor.c
index 87009c4d2cf3a..39695addce076 100644
--- a/fs/erofs/decompressor.c
+++ b/fs/erofs/decompressor.c
@@ -326,7 +326,7 @@ static int z_erofs_transform_plain(struct z_erofs_decompress_req *rq,
 		rq->outputsize -= cur;
 	}
 
-	for (; rq->outputsize; rq->pageofs_in = 0, cur += PAGE_SIZE, ni++) {
+	for (; rq->outputsize; rq->pageofs_in = 0, cur += insz, ni++) {
 		insz = min(PAGE_SIZE - rq->pageofs_in, rq->outputsize);
 		rq->outputsize -= insz;
 		if (!rq->in[ni])
diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
index 85f5b3cf1e110..335427d05908c 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -45,8 +45,8 @@ struct z_erofs_pcluster {
 	/* A: point to next chained pcluster or TAILs */
 	struct z_erofs_pcluster *next;
 
-	/* I: start block address of this pcluster */
-	erofs_off_t index;
+	/* I: start physical position of this pcluster */
+	erofs_off_t pos;
 
 	/* L: the maximum decompression size of this round */
 	unsigned int length;
@@ -74,6 +74,9 @@ struct z_erofs_pcluster {
 	/* I: compression algorithm format */
 	unsigned char algorithmformat;
 
+	/* I: whether compressed data is in-lined or not */
+	bool from_meta;
+
 	/* L: whether partial decompression or not */
 	bool partial;
 
@@ -100,14 +103,9 @@ struct z_erofs_decompressqueue {
 	bool eio, sync;
 };
 
-static inline bool z_erofs_is_inline_pcluster(struct z_erofs_pcluster *pcl)
-{
-	return !pcl->index;
-}
-
 static inline unsigned int z_erofs_pclusterpages(struct z_erofs_pcluster *pcl)
 {
-	return PAGE_ALIGN(pcl->pclustersize) >> PAGE_SHIFT;
+	return PAGE_ALIGN(pcl->pageofs_in + pcl->pclustersize) >> PAGE_SHIFT;
 }
 
 static bool erofs_folio_is_managed(struct erofs_sb_info *sbi, struct folio *fo)
@@ -131,7 +129,7 @@ struct z_erofs_pcluster_slab {
 
 static struct z_erofs_pcluster_slab pcluster_pool[] __read_mostly = {
 	_PCLP(1), _PCLP(4), _PCLP(16), _PCLP(64), _PCLP(128),
-	_PCLP(Z_EROFS_PCLUSTER_MAX_PAGES)
+	_PCLP(Z_EROFS_PCLUSTER_MAX_PAGES + 1)
 };
 
 struct z_erofs_bvec_iter {
@@ -265,7 +263,6 @@ static struct z_erofs_pcluster *z_erofs_alloc_pcluster(unsigned int size)
 		pcl = kmem_cache_zalloc(pcs->slab, GFP_KERNEL);
 		if (!pcl)
 			return ERR_PTR(-ENOMEM);
-		pcl->pclustersize = size;
 		return pcl;
 	}
 	return ERR_PTR(-EINVAL);
@@ -514,6 +511,7 @@ static void z_erofs_bind_cache(struct z_erofs_frontend *fe)
 	struct z_erofs_pcluster *pcl = fe->pcl;
 	unsigned int pclusterpages = z_erofs_pclusterpages(pcl);
 	bool shouldalloc = z_erofs_should_alloc_cache(fe);
+	pgoff_t poff = pcl->pos >> PAGE_SHIFT;
 	bool may_bypass = true;
 	/* Optimistic allocation, as in-place I/O can be used as a fallback */
 	gfp_t gfp = (mapping_gfp_mask(mc) & ~__GFP_DIRECT_RECLAIM) |
@@ -530,7 +528,7 @@ static void z_erofs_bind_cache(struct z_erofs_frontend *fe)
 		if (READ_ONCE(pcl->compressed_bvecs[i].page))
 			continue;
 
-		folio = filemap_get_folio(mc, pcl->index + i);
+		folio = filemap_get_folio(mc, poff + i);
 		if (IS_ERR(folio)) {
 			may_bypass = false;
 			if (!shouldalloc)
@@ -573,7 +571,7 @@ static int erofs_try_to_free_all_cached_folios(struct erofs_sb_info *sbi,
 	struct folio *folio;
 	int i;
 
-	DBG_BUGON(z_erofs_is_inline_pcluster(pcl));
+	DBG_BUGON(pcl->from_meta);
 	/* Each cached folio contains one page unless bs > ps is supported */
 	for (i = 0; i < pclusterpages; ++i) {
 		if (pcl->compressed_bvecs[i].page) {
@@ -605,7 +603,7 @@ static bool z_erofs_cache_release_folio(struct folio *folio, gfp_t gfp)
 	ret = false;
 	spin_lock(&pcl->lockref.lock);
 	if (pcl->lockref.count <= 0) {
-		DBG_BUGON(z_erofs_is_inline_pcluster(pcl));
+		DBG_BUGON(pcl->from_meta);
 		for (; bvec < end; ++bvec) {
 			if (bvec->page && page_folio(bvec->page) == folio) {
 				bvec->page = NULL;
@@ -665,16 +663,20 @@ static int z_erofs_attach_page(struct z_erofs_frontend *fe,
 	int ret;
 
 	if (exclusive) {
-		/* give priority for inplaceio to use file pages first */
-		spin_lock(&pcl->lockref.lock);
-		while (fe->icur > 0) {
-			if (pcl->compressed_bvecs[--fe->icur].page)
-				continue;
-			pcl->compressed_bvecs[fe->icur] = *bvec;
+		/* Inplace I/O is limited to one page for uncompressed data */
+		if (pcl->algorithmformat < Z_EROFS_COMPRESSION_MAX ||
+		    fe->icur <= 1) {
+			/* Try to prioritize inplace I/O here */
+			spin_lock(&pcl->lockref.lock);
+			while (fe->icur > 0) {
+				if (pcl->compressed_bvecs[--fe->icur].page)
+					continue;
+				pcl->compressed_bvecs[fe->icur] = *bvec;
+				spin_unlock(&pcl->lockref.lock);
+				return 0;
+			}
 			spin_unlock(&pcl->lockref.lock);
-			return 0;
 		}
-		spin_unlock(&pcl->lockref.lock);
 
 		/* otherwise, check if it can be used as a bvpage */
 		if (fe->mode >= Z_EROFS_PCLUSTER_FOLLOWED &&
@@ -709,28 +711,27 @@ static int z_erofs_register_pcluster(struct z_erofs_frontend *fe)
 	struct erofs_map_blocks *map = &fe->map;
 	struct super_block *sb = fe->inode->i_sb;
 	struct erofs_sb_info *sbi = EROFS_SB(sb);
-	bool ztailpacking = map->m_flags & EROFS_MAP_META;
 	struct z_erofs_pcluster *pcl, *pre;
+	unsigned int pageofs_in;
 	int err;
 
-	if (!(map->m_flags & EROFS_MAP_ENCODED) ||
-	    (!ztailpacking && !erofs_blknr(sb, map->m_pa))) {
-		DBG_BUGON(1);
-		return -EFSCORRUPTED;
-	}
-
-	/* no available pcluster, let's allocate one */
-	pcl = z_erofs_alloc_pcluster(map->m_plen);
+	pageofs_in = erofs_blkoff(sb, map->m_pa);
+	pcl = z_erofs_alloc_pcluster(pageofs_in + map->m_plen);
 	if (IS_ERR(pcl))
 		return PTR_ERR(pcl);
 
 	spin_lock_init(&pcl->lockref.lock);
 	pcl->lockref.count = 1;		/* one ref for this request */
 	pcl->algorithmformat = map->m_algorithmformat;
+	pcl->pclustersize = map->m_plen;
+	pcl->pageofs_in = pageofs_in;
 	pcl->length = 0;
 	pcl->partial = true;
 	pcl->next = fe->head;
+	pcl->pos = map->m_pa;
+	pcl->pageofs_in = pageofs_in;
 	pcl->pageofs_out = map->m_la & ~PAGE_MASK;
+	pcl->from_meta = map->m_flags & EROFS_MAP_META;
 	fe->mode = Z_EROFS_PCLUSTER_FOLLOWED;
 
 	/*
@@ -740,13 +741,10 @@ static int z_erofs_register_pcluster(struct z_erofs_frontend *fe)
 	mutex_init(&pcl->lock);
 	DBG_BUGON(!mutex_trylock(&pcl->lock));
 
-	if (ztailpacking) {
-		pcl->index = 0;		/* which indicates ztailpacking */
-	} else {
-		pcl->index = erofs_blknr(sb, map->m_pa);
+	if (!pcl->from_meta) {
 		while (1) {
 			xa_lock(&sbi->managed_pslots);
-			pre = __xa_cmpxchg(&sbi->managed_pslots, pcl->index,
+			pre = __xa_cmpxchg(&sbi->managed_pslots, pcl->pos,
 					   NULL, pcl, GFP_KERNEL);
 			if (!pre || xa_is_err(pre) || z_erofs_get_pcluster(pre)) {
 				xa_unlock(&sbi->managed_pslots);
@@ -778,7 +776,6 @@ static int z_erofs_pcluster_begin(struct z_erofs_frontend *fe)
 {
 	struct erofs_map_blocks *map = &fe->map;
 	struct super_block *sb = fe->inode->i_sb;
-	erofs_blk_t blknr = erofs_blknr(sb, map->m_pa);
 	struct z_erofs_pcluster *pcl = NULL;
 	void *ptr = NULL;
 	int ret;
@@ -790,9 +787,9 @@ static int z_erofs_pcluster_begin(struct z_erofs_frontend *fe)
 	if (!(map->m_flags & EROFS_MAP_META)) {
 		while (1) {
 			rcu_read_lock();
-			pcl = xa_load(&EROFS_SB(sb)->managed_pslots, blknr);
+			pcl = xa_load(&EROFS_SB(sb)->managed_pslots, map->m_pa);
 			if (!pcl || z_erofs_get_pcluster(pcl)) {
-				DBG_BUGON(pcl && blknr != pcl->index);
+				DBG_BUGON(pcl && map->m_pa != pcl->pos);
 				rcu_read_unlock();
 				break;
 			}
@@ -834,7 +831,7 @@ static int z_erofs_pcluster_begin(struct z_erofs_frontend *fe)
 
 	z_erofs_bvec_iter_begin(&fe->biter, &fe->pcl->bvset,
 				Z_EROFS_INLINE_BVECS, fe->pcl->vcnt);
-	if (!z_erofs_is_inline_pcluster(fe->pcl)) {
+	if (!fe->pcl->from_meta) {
 		/* bind cache first when cached decompression is preferred */
 		z_erofs_bind_cache(fe);
 	} else {
@@ -871,7 +868,7 @@ static bool __erofs_try_to_release_pcluster(struct erofs_sb_info *sbi,
 	 * It's impossible to fail after the pcluster is freezed, but in order
 	 * to avoid some race conditions, add a DBG_BUGON to observe this.
 	 */
-	DBG_BUGON(__xa_erase(&sbi->managed_pslots, pcl->index) != pcl);
+	DBG_BUGON(__xa_erase(&sbi->managed_pslots, pcl->pos) != pcl);
 
 	lockref_mark_dead(&pcl->lockref);
 	return true;
@@ -1207,7 +1204,7 @@ static int z_erofs_parse_in_bvecs(struct z_erofs_backend *be, bool *overlapped)
 		}
 		be->compressed_pages[i] = page;
 
-		if (z_erofs_is_inline_pcluster(pcl) ||
+		if (pcl->from_meta ||
 		    erofs_folio_is_managed(EROFS_SB(be->sb), page_folio(page))) {
 			if (!PageUptodate(page))
 				err = -EIO;
@@ -1285,7 +1282,7 @@ static int z_erofs_decompress_pcluster(struct z_erofs_backend *be, bool eio)
 				 }, be->pagepool);
 
 	/* must handle all compressed pages before actual file pages */
-	if (z_erofs_is_inline_pcluster(pcl)) {
+	if (pcl->from_meta) {
 		page = pcl->compressed_bvecs[0].page;
 		WRITE_ONCE(pcl->compressed_bvecs[0].page, NULL);
 		put_page(page);
@@ -1344,7 +1341,7 @@ static int z_erofs_decompress_pcluster(struct z_erofs_backend *be, bool eio)
 	WRITE_ONCE(pcl->next, NULL);
 	mutex_unlock(&pcl->lock);
 
-	if (z_erofs_is_inline_pcluster(pcl))
+	if (pcl->from_meta)
 		z_erofs_free_pcluster(pcl);
 	else
 		z_erofs_put_pcluster(sbi, pcl, try_free);
@@ -1537,7 +1534,7 @@ static void z_erofs_fill_bio_vec(struct bio_vec *bvec,
 	folio = page_folio(page);
 out_tocache:
 	if (!tocache || bs != PAGE_SIZE ||
-	    filemap_add_folio(mc, folio, pcl->index + nr, gfp)) {
+	    filemap_add_folio(mc, folio, (pcl->pos >> PAGE_SHIFT) + nr, gfp)) {
 		/* turn into a temporary shortlived folio (1 ref) */
 		folio->private = (void *)Z_EROFS_SHORTLIVED_PAGE;
 		return;
@@ -1654,19 +1651,20 @@ static void z_erofs_submit_queue(struct z_erofs_frontend *f,
 
 		pcl = next;
 		next = READ_ONCE(pcl->next);
-		if (z_erofs_is_inline_pcluster(pcl)) {
+		if (pcl->from_meta) {
 			z_erofs_move_to_bypass_queue(pcl, next, qtail);
 			continue;
 		}
 
 		/* no device id here, thus it will always succeed */
 		mdev = (struct erofs_map_dev) {
-			.m_pa = erofs_pos(sb, pcl->index),
+			.m_pa = round_down(pcl->pos, sb->s_blocksize),
 		};
 		(void)erofs_map_dev(sb, &mdev);
 
 		cur = mdev.m_pa;
-		end = cur + pcl->pclustersize;
+		end = round_up(cur + pcl->pageofs_in + pcl->pclustersize,
+			       sb->s_blocksize);
 		do {
 			bvec.bv_page = NULL;
 			if (bio && (cur != last_pa ||
-- 
2.53.0



