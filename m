Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038347;
	b=PIJa2hXvO1w0YHMr0rPkBUy2foGkVii1LYoujV0H2TeVyngbmhd7zdhsd5iq2ZIXe/Tx
	 y/HlH+lrqYmLECJf38AT/RPHwl72cJOusErnBOW8CCg0nenw0OU1f5ROo1O10F1A2G31d
	 bfp7waTbzk7HG8HOThV8TqHLQbQdkF9quKnn1aGDz1H+Ve6QuTYe2mF0zknStI+oxio8e
	 O7gjZxmRugWTHRZoy8RIIrRRw2wF8BJoaZZEdqcC2tDVBv9jxpwtf6pAm7y290mjlphYo
	 j1B+XUf9W4tdvgolVeWz/B/gWmobm6cvSz/E942GODW5w0YAtxQZDhXbBBD7e3OyBpw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038347;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hRftSvJGhG5gxMRx6pkFyLsHu9yRB4nNtwcgnfwE7T0=;
	b=ShQ6JAL1HpmiTQIFA+naRncL3V19UC40gjKQDp2fWC4zil7GeWHQhbPuq2QqUWPbYbQl
	 yH6zdLZ2bbDnrsltSxlQn2awim1fOLIpyTvt53WXqtbQ4sU5hGW3PbCaKdjHFyQEF+oNr
	 3yUb+BmAiuPyggVeV1eH65SZdZDShy9nJifjULx6mENcrlrOJe8Gk+kzWOGQhNptxt1dX
	 4VGS5289mppk0b7SiLb/dXSutEeJJcnbkTsHO/zPbF2pkPabVQn9bTRXuAEddcItcGSXC
	 dg/OrdCK7pvTSScj7Do1tONLy6xrIdIe0BDw37yW3u8NrFr8jUTgCZH0jCbl3ot6ecQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v3FMLPcg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CE7F606A31C;
	Wed, 18 Nov 2026 21:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v3FMLPcg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AC171F000C4;
	Wed, 18 Nov 2026 21:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038347;
	bh=hRftSvJGhG5gxMRx6pkFyLsHu9yRB4nNtwcgnfwE7T0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v3FMLPcgeXDdcssZuZ/TSO684qnKNiUICPYVyV1r3LM9rJ0nUcJcCz1lzRzK7TRxx
	 6A/FWfHAC4QZbY7wFYvNcVbjLkFKvpyt0F8jKosM7Jw0s5YB8xCjJsOQXhwFammpVR
	 DhrXzR2AOYB0D2noyb5ceeB88WFYM7yTj/PDOEPo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1712/3318] f2fs: convert f2fs_mpage_readpages() to use folio
Date: Wed, 18 Nov 2026 15:38:54 +0100
Message-ID: <20261118150413.227501634@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit db92e6c729d87e6f5b0f467f01a96dbf1e452106 ]

Convert f2fs_mpage_readpages() to use folio and related
functionality.

Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Stable-dep-of: b3c984358925 ("f2fs: remove mappedtodisk flag usage in mmap write path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/data.c | 80 +++++++++++++++++++++++++-------------------------
 1 file changed, 40 insertions(+), 40 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 435eaf4f7547b..05ea56610fd79 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -2375,7 +2375,7 @@ int f2fs_read_multi_pages(struct compress_ctx *cc, struct bio **bio_ret,
  * Major change was from block_size == page_size in f2fs by default.
  */
 static int f2fs_mpage_readpages(struct inode *inode,
-		struct readahead_control *rac, struct page *page)
+		struct readahead_control *rac, struct folio *folio)
 {
 	struct bio *bio = NULL;
 	sector_t last_block_in_bio = 0;
@@ -2395,6 +2395,7 @@ static int f2fs_mpage_readpages(struct inode *inode,
 #endif
 	unsigned nr_pages = rac ? readahead_count(rac) : 1;
 	unsigned max_nr_pages = nr_pages;
+	pgoff_t index;
 	int ret = 0;
 
 	map.m_pblk = 0;
@@ -2408,64 +2409,63 @@ static int f2fs_mpage_readpages(struct inode *inode,
 
 	for (; nr_pages; nr_pages--) {
 		if (rac) {
-			page = readahead_page(rac);
-			prefetchw(&page->flags);
+			folio = readahead_folio(rac);
+			prefetchw(&folio->flags);
 		}
 
-#ifdef CONFIG_F2FS_FS_COMPRESSION
-		if (f2fs_compressed_file(inode)) {
-			/* there are remained compressed pages, submit them */
-			if (!f2fs_cluster_can_merge_page(&cc, page->index)) {
-				ret = f2fs_read_multi_pages(&cc, &bio,
-							max_nr_pages,
-							&last_block_in_bio,
-							rac != NULL, false);
-				f2fs_destroy_compress_ctx(&cc, false);
-				if (ret)
-					goto set_error_page;
-			}
-			if (cc.cluster_idx == NULL_CLUSTER) {
-				if (nc_cluster_idx ==
-					page->index >> cc.log_cluster_size) {
-					goto read_single_page;
-				}
-
-				ret = f2fs_is_compressed_cluster(inode, page->index);
-				if (ret < 0)
-					goto set_error_page;
-				else if (!ret) {
-					nc_cluster_idx =
-						page->index >> cc.log_cluster_size;
-					goto read_single_page;
-				}
+		index = folio_index(folio);
 
-				nc_cluster_idx = NULL_CLUSTER;
-			}
-			ret = f2fs_init_compress_ctx(&cc);
+#ifdef CONFIG_F2FS_FS_COMPRESSION
+		if (!f2fs_compressed_file(inode))
+			goto read_single_page;
+
+		/* there are remained compressed pages, submit them */
+		if (!f2fs_cluster_can_merge_page(&cc, index)) {
+			ret = f2fs_read_multi_pages(&cc, &bio,
+						max_nr_pages,
+						&last_block_in_bio,
+						rac != NULL, false);
+			f2fs_destroy_compress_ctx(&cc, false);
 			if (ret)
 				goto set_error_page;
+		}
+		if (cc.cluster_idx == NULL_CLUSTER) {
+			if (nc_cluster_idx == index >> cc.log_cluster_size)
+				goto read_single_page;
 
-			f2fs_compress_ctx_add_page(&cc, page);
+			ret = f2fs_is_compressed_cluster(inode, index);
+			if (ret < 0)
+				goto set_error_page;
+			else if (!ret) {
+				nc_cluster_idx =
+					index >> cc.log_cluster_size;
+				goto read_single_page;
+			}
 
-			goto next_page;
+			nc_cluster_idx = NULL_CLUSTER;
 		}
+		ret = f2fs_init_compress_ctx(&cc);
+		if (ret)
+			goto set_error_page;
+
+		f2fs_compress_ctx_add_page(&cc, &folio->page);
+
+		goto next_page;
 read_single_page:
 #endif
 
-		ret = f2fs_read_single_page(inode, page, max_nr_pages, &map,
+		ret = f2fs_read_single_page(inode, &folio->page, max_nr_pages, &map,
 					&bio, &last_block_in_bio, rac);
 		if (ret) {
 #ifdef CONFIG_F2FS_FS_COMPRESSION
 set_error_page:
 #endif
-			zero_user_segment(page, 0, PAGE_SIZE);
-			unlock_page(page);
+			folio_zero_segment(folio, 0, folio_size(folio));
+			folio_unlock(folio);
 		}
 #ifdef CONFIG_F2FS_FS_COMPRESSION
 next_page:
 #endif
-		if (rac)
-			put_page(page);
 
 #ifdef CONFIG_F2FS_FS_COMPRESSION
 		if (f2fs_compressed_file(inode)) {
@@ -2502,7 +2502,7 @@ static int f2fs_read_data_folio(struct file *file, struct folio *folio)
 	if (f2fs_has_inline_data(inode))
 		ret = f2fs_read_inline_data(inode, page);
 	if (ret == -EAGAIN)
-		ret = f2fs_mpage_readpages(inode, NULL, page);
+		ret = f2fs_mpage_readpages(inode, NULL, folio);
 	return ret;
 }
 
-- 
2.53.0



