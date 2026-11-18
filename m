Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038350;
	b=yG/O90W5k83A8Hq+Lcz29uVXQmPtBtHe5ma+nLFAiXMwWvGUq+tWA2DwYqHvD8Zi4Ieq
	 R5jRj1D0A6LW7tWcFHoKz2/IWvjsCRbi5IIRtv14nYeUwYZ0MMghL3Przkja0e6i7xssT
	 qKxiMEfd65Y8ruR4pr7W8ot+322pIfQi7ZXP7QFclJcVkr3Jeclm4ER57Bk5+3DbICd/6
	 DLwcIJmtNiqCwwZVHKvVKOyKCJjwUjmjqJ0JCywTk41tmlvK4ig8gWldkkEVc0AxjbyCf
	 3wirTTIt7QdrI6B/7UmsByZL7Q9XupPUFYXsPJPU6NhV0wNC1emMCGE4c1PdxV3ES1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038350;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FLtRiMpyWvDkxQAbPT6bzPdrV1bG80whU7w0zgOR4wM=;
	b=LVjNPxM7GLg10+TA9rYJCCSQzn1ImtwEq9Yv+Oyb1CA5Dx+bhvaBrm2RUqFs1TGmkw6M
	 OPXC4Z9clVt5sQXV5eP1MUammi4bzMMzzJsds3osjZ4XoJGNcR7OT/T82JnVjCVGJQbxo
	 8vgX8IIDWfy03ze08igBtTk+0Zv2pxfgAUISh9C0+ndbU6AGnRGU3Xt1RL/tdl6GI3cJJ
	 RkiAz9JLsr1XsfGcO+srVc55hEvrtHIncMjcyVRm6BlqQaFBTd5L3bXh3ckDvKAkKu82z
	 kmijbiSHwIbXWez9QtD8jFM2DvlTop/4Lfcre5M1TTIwO3zh0ObJBRmMNy5507nFl8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mQZ8Bz3Y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F4153606A31C;
	Wed, 18 Nov 2026 21:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mQZ8Bz3Y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 565781F000C4;
	Wed, 18 Nov 2026 21:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038349;
	bh=FLtRiMpyWvDkxQAbPT6bzPdrV1bG80whU7w0zgOR4wM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mQZ8Bz3YrnTM/nOQMPfTg3Jcic2R9XmnQ8e/kzb2OhA+1DTUJUF9QX9RRgPWYTote
	 xdqEkaAzoDh5yTsUlreTlC+g1iQ2biZEOTDrQ5DeFYiE52hvyrHwHgzHqrKwlqw3E1
	 2TlKR/VvvyjO8br/yWQIMoPpqi3mIupJ9MlGvOd0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1713/3318] f2fs: convert f2fs_read_single_page() to use folio
Date: Wed, 18 Nov 2026 15:38:55 +0100
Message-ID: <20261118150413.256584297@linuxfoundation.org>
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

[ Upstream commit ed54eed355675f79d9322c07d92f38037fc6b514 ]

Convert f2fs_read_single_page() to use folio and related
functionality.

Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Stable-dep-of: b3c984358925 ("f2fs: remove mappedtodisk flag usage in mmap write path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/data.c | 27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 05ea56610fd79..6412cacf2d53c 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -2089,7 +2089,7 @@ static inline loff_t f2fs_readpage_limit(struct inode *inode)
 	return i_size_read(inode);
 }
 
-static int f2fs_read_single_page(struct inode *inode, struct page *page,
+static int f2fs_read_single_page(struct inode *inode, struct folio *folio,
 					unsigned nr_pages,
 					struct f2fs_map_blocks *map,
 					struct bio **bio_ret,
@@ -2102,9 +2102,10 @@ static int f2fs_read_single_page(struct inode *inode, struct page *page,
 	sector_t last_block;
 	sector_t last_block_in_file;
 	sector_t block_nr;
+	pgoff_t index = folio_index(folio);
 	int ret = 0;
 
-	block_in_file = (sector_t)page_index(page);
+	block_in_file = (sector_t)index;
 	last_block = block_in_file + nr_pages;
 	last_block_in_file = bytes_to_blks(inode,
 			f2fs_readpage_limit(inode) + blocksize - 1);
@@ -2135,7 +2136,7 @@ static int f2fs_read_single_page(struct inode *inode, struct page *page,
 got_it:
 	if ((map->m_flags & F2FS_MAP_MAPPED)) {
 		block_nr = map->m_pblk + block_in_file - map->m_lblk;
-		SetPageMappedToDisk(page);
+		folio_set_mappedtodisk(folio);
 
 		if (!f2fs_is_valid_blkaddr(F2FS_I_SB(inode), block_nr,
 						DATA_GENERIC_ENHANCE_READ)) {
@@ -2146,15 +2147,15 @@ static int f2fs_read_single_page(struct inode *inode, struct page *page,
 		}
 	} else {
 zero_out:
-		zero_user_segment(page, 0, PAGE_SIZE);
-		if (f2fs_need_verity(inode, page->index) &&
-		    !fsverity_verify_page(page)) {
+		folio_zero_segment(folio, 0, folio_size(folio));
+		if (f2fs_need_verity(inode, index) &&
+		    !fsverity_verify_folio(folio)) {
 			ret = -EIO;
 			goto out;
 		}
-		if (!PageUptodate(page))
-			SetPageUptodate(page);
-		unlock_page(page);
+		if (!folio_test_uptodate(folio))
+			folio_mark_uptodate(folio);
+		folio_unlock(folio);
 		goto out;
 	}
 
@@ -2164,14 +2165,14 @@ static int f2fs_read_single_page(struct inode *inode, struct page *page,
 	 */
 	if (bio && (!page_is_mergeable(F2FS_I_SB(inode), bio,
 				       *last_block_in_bio, block_nr) ||
-		    !f2fs_crypt_mergeable_bio(bio, inode, page->index, NULL))) {
+		    !f2fs_crypt_mergeable_bio(bio, inode, index, NULL))) {
 submit_and_realloc:
 		f2fs_submit_read_bio(F2FS_I_SB(inode), bio, DATA);
 		bio = NULL;
 	}
 	if (bio == NULL) {
 		bio = f2fs_grab_read_bio(inode, block_nr, nr_pages,
-				is_readahead ? REQ_RAHEAD : 0, page->index,
+				is_readahead ? REQ_RAHEAD : 0, index,
 				false);
 		if (IS_ERR(bio)) {
 			ret = PTR_ERR(bio);
@@ -2186,7 +2187,7 @@ static int f2fs_read_single_page(struct inode *inode, struct page *page,
 	 */
 	f2fs_wait_on_block_writeback(inode, block_nr);
 
-	if (bio_add_page(bio, page, blocksize, 0) < blocksize)
+	if (!bio_add_folio(bio, folio, blocksize, 0))
 		goto submit_and_realloc;
 
 	inc_page_count(F2FS_I_SB(inode), F2FS_RD_DATA);
@@ -2454,7 +2455,7 @@ static int f2fs_mpage_readpages(struct inode *inode,
 read_single_page:
 #endif
 
-		ret = f2fs_read_single_page(inode, &folio->page, max_nr_pages, &map,
+		ret = f2fs_read_single_page(inode, folio, max_nr_pages, &map,
 					&bio, &last_block_in_bio, rac);
 		if (ret) {
 #ifdef CONFIG_F2FS_FS_COMPRESSION
-- 
2.53.0



