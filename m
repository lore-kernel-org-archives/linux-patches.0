Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B983C1D0E3E;
	Wed,  2 Oct 2024 13:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877530; cv=none; b=oxZJHzGT7egvBtcpYt+fvWm9D2pXus+SLu48SKipSuyq1qv2KwKk1CMjVRVppJs7o+l5W63RU46h63KlW1H87rs+w7x7AsAzn19ef0O5dnnOho9l4FcudJr5lBYygx98cMwTnim+8tSvnfLF2X4x03CmT1H4KJJ/oHFcEr5eUb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877530; c=relaxed/simple;
	bh=MtHqaspD6ncZF6ypmrIz8odcfd8rBoB4CHuJG14H6Po=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bpxl56inxYxO8wQzBaQPTwfl3knr2cjfzXccP/hc7a2LydEmvQ78ksy0psHauq3VztrW2ZV5rZNpZxa+ldAFVtQ2Oi4w/SlmApN2SF1iGNEsOsHyGvMn1bIMzjz27GbO7KkQeVBFhUgrg26PyCCTfLkoz/Ir6l1Hu5LSCdCTsSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rwIzJjYG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rwIzJjYG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C623AC4CECD;
	Wed,  2 Oct 2024 13:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877530;
	bh=MtHqaspD6ncZF6ypmrIz8odcfd8rBoB4CHuJG14H6Po=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rwIzJjYG5qp7a8a0QuoTFfs+gzfJe0xXAnpCTWhtXjAOGuX+SU95I6HoU0dY8z0VX
	 IezcoAIoZ0EjQ09j72ig+qEjw5h4lvpzH9Ogkzd0iQ9mkUEsET75bkv5NSqhXMHYv3
	 Sz72bRW7bKWB+Wbp7QPscimON7KXf0qI0DqLxGrk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 110/634] erofs: tidy up `struct z_erofs_bvec`
Date: Wed,  2 Oct 2024 14:53:30 +0200
Message-ID: <20241002125815.456460267@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gao Xiang <hsiangkao@linux.alibaba.com>

[ Upstream commit 2080ca1ed3e43233c4e8480c0b9d2840886de01e ]

After revisiting the design, I believe `struct z_erofs_bvec` should
be page-based instead of folio-based due to the reasons below:

 - The minimized memory mapping block is a page;

 - Under the certain circumstances, only temporary pages needs to be
   used instead of folios since refcount, mapcount for such pages are
   unnecessary;

 - Decompressors handle all types of pages including temporary pages,
   not only folios.

When handling `struct z_erofs_bvec`, all folio-related information
is now accessed using the page_folio() helper.

The final goal of this round adaptation is to eliminate direct
accesses to `struct page` in the EROFS codebase, except for some
exceptions like `z_erofs_is_shortlived_page()` and
`z_erofs_page_is_invalidated()`, which require a new helper to
determine the memdesc type of an arbitrary page.

Actually large folios of compressed files seem to work now, yet I tend
to conduct more tests before officially enabling this for all scenarios.

Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Link: https://lore.kernel.org/r/20240703120051.3653452-4-hsiangkao@linux.alibaba.com
Stable-dep-of: 9e2f9d34dd12 ("erofs: handle overlapped pclusters out of crafted images properly")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/zdata.c | 101 +++++++++++++++++++++++------------------------
 1 file changed, 49 insertions(+), 52 deletions(-)

diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
index d6fe002a4a719..d269b092c477f 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -19,10 +19,7 @@
 typedef void *z_erofs_next_pcluster_t;
 
 struct z_erofs_bvec {
-	union {
-		struct page *page;
-		struct folio *folio;
-	};
+	struct page *page;
 	int offset;
 	unsigned int end;
 };
@@ -617,32 +614,31 @@ static void z_erofs_bind_cache(struct z_erofs_decompress_frontend *fe)
 		fe->mode = Z_EROFS_PCLUSTER_FOLLOWED_NOINPLACE;
 }
 
-/* called by erofs_shrinker to get rid of all cached compressed bvecs */
+/* (erofs_shrinker) disconnect cached encoded data with pclusters */
 int erofs_try_to_free_all_cached_folios(struct erofs_sb_info *sbi,
 					struct erofs_workgroup *grp)
 {
 	struct z_erofs_pcluster *const pcl =
 		container_of(grp, struct z_erofs_pcluster, obj);
 	unsigned int pclusterpages = z_erofs_pclusterpages(pcl);
+	struct folio *folio;
 	int i;
 
 	DBG_BUGON(z_erofs_is_inline_pcluster(pcl));
-	/* There is no actice user since the pcluster is now freezed */
+	/* Each cached folio contains one page unless bs > ps is supported */
 	for (i = 0; i < pclusterpages; ++i) {
-		struct folio *folio = pcl->compressed_bvecs[i].folio;
+		if (pcl->compressed_bvecs[i].page) {
+			folio = page_folio(pcl->compressed_bvecs[i].page);
+			/* Avoid reclaiming or migrating this folio */
+			if (!folio_trylock(folio))
+				return -EBUSY;
 
-		if (!folio)
-			continue;
-
-		/* Avoid reclaiming or migrating this folio */
-		if (!folio_trylock(folio))
-			return -EBUSY;
-
-		if (!erofs_folio_is_managed(sbi, folio))
-			continue;
-		pcl->compressed_bvecs[i].folio = NULL;
-		folio_detach_private(folio);
-		folio_unlock(folio);
+			if (!erofs_folio_is_managed(sbi, folio))
+				continue;
+			pcl->compressed_bvecs[i].page = NULL;
+			folio_detach_private(folio);
+			folio_unlock(folio);
+		}
 	}
 	return 0;
 }
@@ -650,9 +646,9 @@ int erofs_try_to_free_all_cached_folios(struct erofs_sb_info *sbi,
 static bool z_erofs_cache_release_folio(struct folio *folio, gfp_t gfp)
 {
 	struct z_erofs_pcluster *pcl = folio_get_private(folio);
-	unsigned int pclusterpages = z_erofs_pclusterpages(pcl);
+	struct z_erofs_bvec *bvec = pcl->compressed_bvecs;
+	struct z_erofs_bvec *end = bvec + z_erofs_pclusterpages(pcl);
 	bool ret;
-	int i;
 
 	if (!folio_test_private(folio))
 		return true;
@@ -661,9 +657,9 @@ static bool z_erofs_cache_release_folio(struct folio *folio, gfp_t gfp)
 	spin_lock(&pcl->obj.lockref.lock);
 	if (pcl->obj.lockref.count <= 0) {
 		DBG_BUGON(z_erofs_is_inline_pcluster(pcl));
-		for (i = 0; i < pclusterpages; ++i) {
-			if (pcl->compressed_bvecs[i].folio == folio) {
-				pcl->compressed_bvecs[i].folio = NULL;
+		for (; bvec < end; ++bvec) {
+			if (bvec->page && page_folio(bvec->page) == folio) {
+				bvec->page = NULL;
 				folio_detach_private(folio);
 				ret = true;
 				break;
@@ -1066,7 +1062,7 @@ static bool z_erofs_is_sync_decompress(struct erofs_sb_info *sbi,
 
 static bool z_erofs_page_is_invalidated(struct page *page)
 {
-	return !page->mapping && !z_erofs_is_shortlived_page(page);
+	return !page_folio(page)->mapping && !z_erofs_is_shortlived_page(page);
 }
 
 struct z_erofs_decompress_backend {
@@ -1419,7 +1415,7 @@ static void z_erofs_fill_bio_vec(struct bio_vec *bvec,
 	bool tocache = false;
 	struct z_erofs_bvec zbv;
 	struct address_space *mapping;
-	struct page *page;
+	struct folio *folio;
 	int bs = i_blocksize(f->inode);
 
 	/* Except for inplace folios, the entire folio can be used for I/Os */
@@ -1429,23 +1425,25 @@ static void z_erofs_fill_bio_vec(struct bio_vec *bvec,
 	spin_lock(&pcl->obj.lockref.lock);
 	zbv = pcl->compressed_bvecs[nr];
 	spin_unlock(&pcl->obj.lockref.lock);
-	if (!zbv.folio)
+	if (!zbv.page)
 		goto out_allocfolio;
 
-	bvec->bv_page = &zbv.folio->page;
+	bvec->bv_page = zbv.page;
 	DBG_BUGON(z_erofs_is_shortlived_page(bvec->bv_page));
+
+	folio = page_folio(zbv.page);
 	/*
 	 * Handle preallocated cached folios.  We tried to allocate such folios
 	 * without triggering direct reclaim.  If allocation failed, inplace
 	 * file-backed folios will be used instead.
 	 */
-	if (zbv.folio->private == (void *)Z_EROFS_PREALLOCATED_PAGE) {
-		zbv.folio->private = 0;
+	if (folio->private == (void *)Z_EROFS_PREALLOCATED_PAGE) {
+		folio->private = 0;
 		tocache = true;
 		goto out_tocache;
 	}
 
-	mapping = READ_ONCE(zbv.folio->mapping);
+	mapping = READ_ONCE(folio->mapping);
 	/*
 	 * File-backed folios for inplace I/Os are all locked steady,
 	 * therefore it is impossible for `mapping` to be NULL.
@@ -1457,21 +1455,21 @@ static void z_erofs_fill_bio_vec(struct bio_vec *bvec,
 		return;
 	}
 
-	folio_lock(zbv.folio);
-	if (zbv.folio->mapping == mc) {
+	folio_lock(folio);
+	if (folio->mapping == mc) {
 		/*
 		 * The cached folio is still in managed cache but without
 		 * a valid `->private` pcluster hint.  Let's reconnect them.
 		 */
-		if (!folio_test_private(zbv.folio)) {
-			folio_attach_private(zbv.folio, pcl);
+		if (!folio_test_private(folio)) {
+			folio_attach_private(folio, pcl);
 			/* compressed_bvecs[] already takes a ref before */
-			folio_put(zbv.folio);
+			folio_put(folio);
 		}
 
 		/* no need to submit if it is already up-to-date */
-		if (folio_test_uptodate(zbv.folio)) {
-			folio_unlock(zbv.folio);
+		if (folio_test_uptodate(folio)) {
+			folio_unlock(folio);
 			bvec->bv_page = NULL;
 		}
 		return;
@@ -1481,32 +1479,31 @@ static void z_erofs_fill_bio_vec(struct bio_vec *bvec,
 	 * It has been truncated, so it's unsafe to reuse this one. Let's
 	 * allocate a new page for compressed data.
 	 */
-	DBG_BUGON(zbv.folio->mapping);
+	DBG_BUGON(folio->mapping);
 	tocache = true;
-	folio_unlock(zbv.folio);
-	folio_put(zbv.folio);
+	folio_unlock(folio);
+	folio_put(folio);
 out_allocfolio:
-	page = erofs_allocpage(&f->pagepool, gfp | __GFP_NOFAIL);
+	zbv.page = erofs_allocpage(&f->pagepool, gfp | __GFP_NOFAIL);
 	spin_lock(&pcl->obj.lockref.lock);
-	if (pcl->compressed_bvecs[nr].folio) {
-		erofs_pagepool_add(&f->pagepool, page);
+	if (pcl->compressed_bvecs[nr].page) {
+		erofs_pagepool_add(&f->pagepool, zbv.page);
 		spin_unlock(&pcl->obj.lockref.lock);
 		cond_resched();
 		goto repeat;
 	}
-	pcl->compressed_bvecs[nr].folio = zbv.folio = page_folio(page);
+	bvec->bv_page = pcl->compressed_bvecs[nr].page = zbv.page;
+	folio = page_folio(zbv.page);
+	/* first mark it as a temporary shortlived folio (now 1 ref) */
+	folio->private = (void *)Z_EROFS_SHORTLIVED_PAGE;
 	spin_unlock(&pcl->obj.lockref.lock);
-	bvec->bv_page = page;
 out_tocache:
 	if (!tocache || bs != PAGE_SIZE ||
-	    filemap_add_folio(mc, zbv.folio, pcl->obj.index + nr, gfp)) {
-		/* turn into a temporary shortlived folio (1 ref) */
-		zbv.folio->private = (void *)Z_EROFS_SHORTLIVED_PAGE;
+	    filemap_add_folio(mc, folio, pcl->obj.index + nr, gfp))
 		return;
-	}
-	folio_attach_private(zbv.folio, pcl);
+	folio_attach_private(folio, pcl);
 	/* drop a refcount added by allocpage (then 2 refs in total here) */
-	folio_put(zbv.folio);
+	folio_put(folio);
 }
 
 static struct z_erofs_decompressqueue *jobqueue_init(struct super_block *sb,
-- 
2.43.0



