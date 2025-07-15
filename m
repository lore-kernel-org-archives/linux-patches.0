Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E80652D8778;
	Tue, 15 Jul 2025 13:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587337; cv=none; b=jptmz6ILXXUgUW396MPJ/kvx37h5Nb8XoMAd48RAfvgECBsDlxUv+dGBHwD3KHGzg8hnfEvMhygZngRQynCN7kK1/eNGr+ULOZOTQj3eQ29zC/R8fXc35kbC48VkR7xC2iKmcWThhLOmQb27MhREu/F5+ZKtAS81iGRoscdT/1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587337; c=relaxed/simple;
	bh=rKQVyzLZNhHVUMLqc9YlXFyPnAU72w/XE4IeT/eK5HE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YlzkBXYQ7uXWr6XA6SFIOrRFh5GAlz2xo8ua1ps3CA2s2dn9xgwo9YK86EPn8qnzMqRhaEP27QxsyOCXtmZVNG5zdpyfN3x1dEqyRU0s6GVTpvHMjr2CXRDZ6KtQBRlWWxgh+4yuQmrbRBt9wQcgSJgMGhsqD/2uCRmtrDq+MSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lsis1anx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lsis1anx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79C05C4CEE3;
	Tue, 15 Jul 2025 13:48:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587336;
	bh=rKQVyzLZNhHVUMLqc9YlXFyPnAU72w/XE4IeT/eK5HE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lsis1anxVZx5bDbUvFbwI3Kq+B/RVbdfUkh76HH89rl1YaVkA0MRWmpmn5EPT5o4K
	 F4aAOFAwPoyjM1l7wo7OV1hJVm21h6Xjp7HcodtQPveyVU3sKOS1bUHlPIGwbX8fCx
	 2G75fwvfknXnP4OEgLJdZlbzzjoZP08sKG9IKRjs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Yue Hu <huyue2@coolpad.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 62/88] erofs: avoid on-stack pagepool directly passed by arguments
Date: Tue, 15 Jul 2025 15:14:38 +0200
Message-ID: <20250715130757.057582033@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130754.497128560@linuxfoundation.org>
References: <20250715130754.497128560@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gao Xiang <hsiangkao@linux.alibaba.com>

[ Upstream commit 6ab5eed6002edc5a29b683285e90459a7df6ce2b ]

On-stack pagepool is used so that short-lived temporary pages could be
shared within a single I/O request (e.g. among multiple pclusters).

Moving the remaining frontend-related uses into
z_erofs_decompress_frontend to avoid too many arguments.

Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Reviewed-by: Yue Hu <huyue2@coolpad.com>
Link: https://lore.kernel.org/r/20230526201459.128169-3-hsiangkao@linux.alibaba.com
Stable-dep-of: 99f7619a77a0 ("erofs: fix to add missing tracepoint in erofs_read_folio()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/zdata.c | 64 +++++++++++++++++++++++-------------------------
 1 file changed, 30 insertions(+), 34 deletions(-)

diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
index ff82610eb14c9..ac8c082798512 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -236,13 +236,14 @@ static void z_erofs_bvec_iter_begin(struct z_erofs_bvec_iter *iter,
 
 static int z_erofs_bvec_enqueue(struct z_erofs_bvec_iter *iter,
 				struct z_erofs_bvec *bvec,
-				struct page **candidate_bvpage)
+				struct page **candidate_bvpage,
+				struct page **pagepool)
 {
 	if (iter->cur >= iter->nr) {
 		struct page *nextpage = *candidate_bvpage;
 
 		if (!nextpage) {
-			nextpage = alloc_page(GFP_NOFS);
+			nextpage = erofs_allocpage(pagepool, GFP_NOFS);
 			if (!nextpage)
 				return -ENOMEM;
 			set_page_private(nextpage, Z_EROFS_SHORTLIVED_PAGE);
@@ -406,6 +407,7 @@ struct z_erofs_decompress_frontend {
 	struct erofs_map_blocks map;
 	struct z_erofs_bvec_iter biter;
 
+	struct page *pagepool;
 	struct page *candidate_bvpage;
 	struct z_erofs_pcluster *pcl;
 	z_erofs_next_pcluster_t owned_head;
@@ -440,8 +442,7 @@ static bool z_erofs_should_alloc_cache(struct z_erofs_decompress_frontend *fe)
 	return false;
 }
 
-static void z_erofs_bind_cache(struct z_erofs_decompress_frontend *fe,
-			       struct page **pagepool)
+static void z_erofs_bind_cache(struct z_erofs_decompress_frontend *fe)
 {
 	struct address_space *mc = MNGD_MAPPING(EROFS_I_SB(fe->inode));
 	struct z_erofs_pcluster *pcl = fe->pcl;
@@ -482,7 +483,7 @@ static void z_erofs_bind_cache(struct z_erofs_decompress_frontend *fe,
 			 * succeeds or fallback to in-place I/O instead
 			 * to avoid any direct reclaim.
 			 */
-			newpage = erofs_allocpage(pagepool, gfp);
+			newpage = erofs_allocpage(&fe->pagepool, gfp);
 			if (!newpage)
 				continue;
 			set_page_private(newpage, Z_EROFS_PREALLOCATED_PAGE);
@@ -495,7 +496,7 @@ static void z_erofs_bind_cache(struct z_erofs_decompress_frontend *fe,
 		if (page)
 			put_page(page);
 		else if (newpage)
-			erofs_pagepool_add(pagepool, newpage);
+			erofs_pagepool_add(&fe->pagepool, newpage);
 	}
 
 	/*
@@ -593,7 +594,8 @@ static int z_erofs_attach_page(struct z_erofs_decompress_frontend *fe,
 		    !fe->candidate_bvpage)
 			fe->candidate_bvpage = bvec->page;
 	}
-	ret = z_erofs_bvec_enqueue(&fe->biter, bvec, &fe->candidate_bvpage);
+	ret = z_erofs_bvec_enqueue(&fe->biter, bvec, &fe->candidate_bvpage,
+				   &fe->pagepool);
 	fe->pcl->vcnt += (ret >= 0);
 	return ret;
 }
@@ -797,7 +799,7 @@ static int z_erofs_read_fragment(struct inode *inode, erofs_off_t pos,
 }
 
 static int z_erofs_do_read_page(struct z_erofs_decompress_frontend *fe,
-				struct page *page, struct page **pagepool)
+				struct page *page)
 {
 	struct inode *const inode = fe->inode;
 	struct erofs_map_blocks *const map = &fe->map;
@@ -858,7 +860,7 @@ static int z_erofs_do_read_page(struct z_erofs_decompress_frontend *fe,
 		fe->mode = Z_EROFS_PCLUSTER_FOLLOWED_NOINPLACE;
 	} else {
 		/* bind cache first when cached decompression is preferred */
-		z_erofs_bind_cache(fe, pagepool);
+		z_erofs_bind_cache(fe);
 	}
 hitted:
 	/*
@@ -1470,7 +1472,6 @@ static void z_erofs_decompressqueue_endio(struct bio *bio)
 }
 
 static void z_erofs_submit_queue(struct z_erofs_decompress_frontend *f,
-				 struct page **pagepool,
 				 struct z_erofs_decompressqueue *fgq,
 				 bool *force_fg, bool readahead)
 {
@@ -1528,8 +1529,8 @@ static void z_erofs_submit_queue(struct z_erofs_decompress_frontend *f,
 		do {
 			struct page *page;
 
-			page = pickup_page_for_submission(pcl, i++, pagepool,
-							  mc);
+			page = pickup_page_for_submission(pcl, i++,
+					&f->pagepool, mc);
 			if (!page)
 				continue;
 
@@ -1594,16 +1595,16 @@ static void z_erofs_submit_queue(struct z_erofs_decompress_frontend *f,
 }
 
 static void z_erofs_runqueue(struct z_erofs_decompress_frontend *f,
-			     struct page **pagepool, bool force_fg, bool ra)
+			     bool force_fg, bool ra)
 {
 	struct z_erofs_decompressqueue io[NR_JOBQUEUES];
 
 	if (f->owned_head == Z_EROFS_PCLUSTER_TAIL)
 		return;
-	z_erofs_submit_queue(f, pagepool, io, &force_fg, ra);
+	z_erofs_submit_queue(f, io, &force_fg, ra);
 
 	/* handle bypass queue (no i/o pclusters) immediately */
-	z_erofs_decompress_queue(&io[JQ_BYPASS], pagepool);
+	z_erofs_decompress_queue(&io[JQ_BYPASS], &f->pagepool);
 
 	if (!force_fg)
 		return;
@@ -1612,7 +1613,7 @@ static void z_erofs_runqueue(struct z_erofs_decompress_frontend *f,
 	wait_for_completion_io(&io[JQ_SUBMIT].u.done);
 
 	/* handle synchronous decompress queue in the caller context */
-	z_erofs_decompress_queue(&io[JQ_SUBMIT], pagepool);
+	z_erofs_decompress_queue(&io[JQ_SUBMIT], &f->pagepool);
 }
 
 /*
@@ -1620,8 +1621,7 @@ static void z_erofs_runqueue(struct z_erofs_decompress_frontend *f,
  * approximate readmore strategies as a start.
  */
 static void z_erofs_pcluster_readmore(struct z_erofs_decompress_frontend *f,
-				      struct readahead_control *rac,
-				      struct page **pagepool, bool backmost)
+		struct readahead_control *rac, bool backmost)
 {
 	struct inode *inode = f->inode;
 	struct erofs_map_blocks *map = &f->map;
@@ -1663,7 +1663,7 @@ static void z_erofs_pcluster_readmore(struct z_erofs_decompress_frontend *f,
 			if (PageUptodate(page)) {
 				unlock_page(page);
 			} else {
-				err = z_erofs_do_read_page(f, page, pagepool);
+				err = z_erofs_do_read_page(f, page);
 				if (err)
 					erofs_err(inode->i_sb,
 						  "readmore error at page %lu @ nid %llu",
@@ -1684,27 +1684,24 @@ static int z_erofs_read_folio(struct file *file, struct folio *folio)
 	struct inode *const inode = page->mapping->host;
 	struct erofs_sb_info *const sbi = EROFS_I_SB(inode);
 	struct z_erofs_decompress_frontend f = DECOMPRESS_FRONTEND_INIT(inode);
-	struct page *pagepool = NULL;
 	int err;
 
 	trace_erofs_readpage(page, false);
 	f.headoffset = (erofs_off_t)page->index << PAGE_SHIFT;
 
-	z_erofs_pcluster_readmore(&f, NULL, &pagepool, true);
-	err = z_erofs_do_read_page(&f, page, &pagepool);
-	z_erofs_pcluster_readmore(&f, NULL, &pagepool, false);
-
+	z_erofs_pcluster_readmore(&f, NULL, true);
+	err = z_erofs_do_read_page(&f, page);
+	z_erofs_pcluster_readmore(&f, NULL, false);
 	(void)z_erofs_collector_end(&f);
 
 	/* if some compressed cluster ready, need submit them anyway */
-	z_erofs_runqueue(&f, &pagepool, z_erofs_is_sync_decompress(sbi, 0),
-			 false);
+	z_erofs_runqueue(&f, z_erofs_is_sync_decompress(sbi, 0), false);
 
 	if (err)
 		erofs_err(inode->i_sb, "failed to read, err [%d]", err);
 
 	erofs_put_metabuf(&f.map.buf);
-	erofs_release_pages(&pagepool);
+	erofs_release_pages(&f.pagepool);
 	return err;
 }
 
@@ -1713,12 +1710,12 @@ static void z_erofs_readahead(struct readahead_control *rac)
 	struct inode *const inode = rac->mapping->host;
 	struct erofs_sb_info *const sbi = EROFS_I_SB(inode);
 	struct z_erofs_decompress_frontend f = DECOMPRESS_FRONTEND_INIT(inode);
-	struct page *pagepool = NULL, *head = NULL, *page;
+	struct page *head = NULL, *page;
 	unsigned int nr_pages;
 
 	f.headoffset = readahead_pos(rac);
 
-	z_erofs_pcluster_readmore(&f, rac, &pagepool, true);
+	z_erofs_pcluster_readmore(&f, rac, true);
 	nr_pages = readahead_count(rac);
 	trace_erofs_readpages(inode, readahead_index(rac), nr_pages, false);
 
@@ -1734,20 +1731,19 @@ static void z_erofs_readahead(struct readahead_control *rac)
 		/* traversal in reverse order */
 		head = (void *)page_private(page);
 
-		err = z_erofs_do_read_page(&f, page, &pagepool);
+		err = z_erofs_do_read_page(&f, page);
 		if (err)
 			erofs_err(inode->i_sb,
 				  "readahead error at page %lu @ nid %llu",
 				  page->index, EROFS_I(inode)->nid);
 		put_page(page);
 	}
-	z_erofs_pcluster_readmore(&f, rac, &pagepool, false);
+	z_erofs_pcluster_readmore(&f, rac, false);
 	(void)z_erofs_collector_end(&f);
 
-	z_erofs_runqueue(&f, &pagepool,
-			 z_erofs_is_sync_decompress(sbi, nr_pages), true);
+	z_erofs_runqueue(&f, z_erofs_is_sync_decompress(sbi, nr_pages), true);
 	erofs_put_metabuf(&f.map.buf);
-	erofs_release_pages(&pagepool);
+	erofs_release_pages(&f.pagepool);
 }
 
 const struct address_space_operations z_erofs_aops = {
-- 
2.39.5



