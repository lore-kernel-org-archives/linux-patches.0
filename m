Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14F0E41A503;
	Sat, 12 Sep 2026 13:09:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789218562; cv=none; b=ZEQE31BN/YJHgMvITJN9lU1PV1LFq4qPGndfJ++QmNSuh1rl8es2ojr3znpV+v9Im7g/mT4T6rToSZvnEUVOU2vqvcsX/U/+ieyGJzik4rPWY1ElMAT2gH3c70gqoU3U5iWNfwg9PQGLW/mfrt6zNJr9uUKMv+OCrhg8cBdvgf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789218562; c=relaxed/simple;
	bh=47dbhs+py1rQH3i6JzSL0JFT85Dex31h3JLngJ2VOXM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VQXgo3/X6b30DG3pS1mWyy5qVuV8qbZqn6X35iZFbypRS9HWkZKEndcFH2/ap5yhQ+mowKzK77Iht+NEqgDrx4adMVcBwgkQGXC/ldYwdSfRG2yyUDnzVQHkjEGg54qQ9xMkjTIHLR6xOe5Kb9woO81cDEKh7pQD+9urZaWM2OM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0b7AaHsj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0b7AaHsj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F10A81F000FF;
	Sat, 12 Sep 2026 13:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789218561;
	bh=BSLFree4mpRwpk2qNtiAe4veQ1J2n/fVDGxhMrEYtrE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0b7AaHsj0sK7ir6eA7ws1oBPyj0Pk9yPqZEnbmDoc1AIAL/TXE3TkIKCywlCjj4KQ
	 HfpBmiBzZwbVFxH9S18Fz5kIu29DT1JhYjK/8UdMB6MUUBiqTrjsctQiDhxqPh9Tl9
	 2gApYXmVXgcM8YGcYmKfw+eb09SgI8FmGWMSUG2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1171/1376] erofs: convert z_erofs_bind_cache() to folios
Date: Sat, 12 Sep 2026 08:59:57 +0200
Message-ID: <20260912065633.650515519@linuxfoundation.org>
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

[ Upstream commit e180b8c4c23beb876927a999c49c18b361fa7975 ]

The managed cache uses a pseudo inode to keep (necessary) compressed
data.

Currently, it still uses zero-order folios, so this is just a trivial
conversion, except that the use of the pagepool is temporarily dropped.

Drop some obsoleted comments too.

Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Link: https://lore.kernel.org/r/20250114034429.431408-4-hsiangkao@linux.alibaba.com
Stable-dep-of: 988c3c186c73 ("erofs: fix unused pcluster_pools for higher page sizes")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/compress.h | 23 +-------------------
 fs/erofs/zdata.c    | 51 ++++++++++++++++++---------------------------
 2 files changed, 21 insertions(+), 53 deletions(-)

diff --git a/fs/erofs/compress.h b/fs/erofs/compress.h
index 106fc3315dece..2704d7a592a5e 100644
--- a/fs/erofs/compress.h
+++ b/fs/erofs/compress.h
@@ -30,29 +30,8 @@ struct z_erofs_decompressor {
 	char *name;
 };
 
-/* some special page->private (unsigned long, see below) */
 #define Z_EROFS_SHORTLIVED_PAGE		(-1UL << 2)
-#define Z_EROFS_PREALLOCATED_PAGE	(-2UL << 2)
-
-/*
- * For all pages in a pcluster, page->private should be one of
- * Type                         Last 2bits      page->private
- * short-lived page             00              Z_EROFS_SHORTLIVED_PAGE
- * preallocated page (tryalloc) 00              Z_EROFS_PREALLOCATED_PAGE
- * cached/managed page          00              pointer to z_erofs_pcluster
- * online page (file-backed,    01/10/11        sub-index << 2 | count
- *              some pages can be used for inplace I/O)
- *
- * page->mapping should be one of
- * Type                 page->mapping
- * short-lived page     NULL
- * preallocated page    NULL
- * cached/managed page  non-NULL or NULL (invalidated/truncated page)
- * online page          non-NULL
- *
- * For all managed pages, PG_private should be set with 1 extra refcount,
- * which is used for page reclaim / migration.
- */
+#define Z_EROFS_PREALLOCATED_FOLIO	((void *)(-2UL << 2))
 
 /*
  * Currently, short-lived pages are pages directly from buddy system
diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
index d625e3be9ec6c..85f5b3cf1e110 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -514,13 +514,11 @@ static void z_erofs_bind_cache(struct z_erofs_frontend *fe)
 	struct z_erofs_pcluster *pcl = fe->pcl;
 	unsigned int pclusterpages = z_erofs_pclusterpages(pcl);
 	bool shouldalloc = z_erofs_should_alloc_cache(fe);
-	bool standalone = true;
-	/*
-	 * optimistic allocation without direct reclaim since inplace I/O
-	 * can be used if low memory otherwise.
-	 */
+	bool may_bypass = true;
+	/* Optimistic allocation, as in-place I/O can be used as a fallback */
 	gfp_t gfp = (mapping_gfp_mask(mc) & ~__GFP_DIRECT_RECLAIM) |
 			__GFP_NOMEMALLOC | __GFP_NORETRY | __GFP_NOWARN;
+	struct folio *folio, *newfolio;
 	unsigned int i;
 
 	if (i_blocksize(fe->inode) != PAGE_SIZE ||
@@ -528,47 +526,42 @@ static void z_erofs_bind_cache(struct z_erofs_frontend *fe)
 		return;
 
 	for (i = 0; i < pclusterpages; ++i) {
-		struct page *page, *newpage;
-
 		/* Inaccurate check w/o locking to avoid unneeded lookups */
 		if (READ_ONCE(pcl->compressed_bvecs[i].page))
 			continue;
 
-		page = find_get_page(mc, pcl->index + i);
-		if (!page) {
-			/* I/O is needed, no possible to decompress directly */
-			standalone = false;
+		folio = filemap_get_folio(mc, pcl->index + i);
+		if (IS_ERR(folio)) {
+			may_bypass = false;
 			if (!shouldalloc)
 				continue;
 
 			/*
-			 * Try cached I/O if allocation succeeds or fallback to
-			 * in-place I/O instead to avoid any direct reclaim.
+			 * Allocate a managed folio for cached I/O, or it may be
+			 * then filled with a file-backed folio for in-place I/O
 			 */
-			newpage = erofs_allocpage(&fe->pagepool, gfp);
-			if (!newpage)
+			newfolio = filemap_alloc_folio(gfp, 0);
+			if (!newfolio)
 				continue;
-			set_page_private(newpage, Z_EROFS_PREALLOCATED_PAGE);
+			newfolio->private = Z_EROFS_PREALLOCATED_FOLIO;
+			folio = NULL;
 		}
 		spin_lock(&pcl->lockref.lock);
 		if (!pcl->compressed_bvecs[i].page) {
-			pcl->compressed_bvecs[i].page = page ? page : newpage;
+			pcl->compressed_bvecs[i].page =
+				folio_page(folio ?: newfolio, 0);
 			spin_unlock(&pcl->lockref.lock);
 			continue;
 		}
 		spin_unlock(&pcl->lockref.lock);
-
-		if (page)
-			put_page(page);
-		else if (newpage)
-			erofs_pagepool_add(&fe->pagepool, newpage);
+		folio_put(folio ?: newfolio);
 	}
 
 	/*
-	 * don't do inplace I/O if all compressed pages are available in
-	 * managed cache since it can be moved to the bypass queue instead.
+	 * Don't perform in-place I/O if all compressed pages are available in
+	 * the managed cache, as the pcluster can be moved to the bypass queue.
 	 */
-	if (standalone)
+	if (may_bypass)
 		fe->mode = Z_EROFS_PCLUSTER_FOLLOWED_NOINPLACE;
 }
 
@@ -1478,12 +1471,8 @@ static void z_erofs_fill_bio_vec(struct bio_vec *bvec,
 	DBG_BUGON(z_erofs_is_shortlived_page(bvec->bv_page));
 
 	folio = page_folio(zbv.page);
-	/*
-	 * Handle preallocated cached folios.  We tried to allocate such folios
-	 * without triggering direct reclaim.  If allocation failed, inplace
-	 * file-backed folios will be used instead.
-	 */
-	if (folio->private == (void *)Z_EROFS_PREALLOCATED_PAGE) {
+	/* For preallocated managed folios, add them to page cache here */
+	if (folio->private == Z_EROFS_PREALLOCATED_FOLIO) {
 		tocache = true;
 		goto out_tocache;
 	}
-- 
2.53.0



