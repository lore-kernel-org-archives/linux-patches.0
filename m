Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F4632F0C62;
	Wed, 20 May 2026 17:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298994; cv=none; b=WIu59b+zEepDu2MrFDRxIDZVa93z/WGFQ6dqvXzwa4pFkic51CihzNBzaafKABmIBDRE4imfu7Al88wVx4BgHUZWL/yClENvgA5hGpbB4pCdPhyxoNDQ63rGC3PFADH/yXu1ul9daJqqzt7aM8O2WS8ZvoG3PVkhyEsw9QDux+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298994; c=relaxed/simple;
	bh=ZEycEP7NfYAl9kgGyDpOLiEHrYcCzPi8m8tPey5XO+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YPBo0vpAGG8nQ7uFriB5CmZZReRACQliUh1ZV46rOMCbizxFSrllPwh7kjiQ4bGAR481Nwmiuq4iplsywnsvjVYXmaecmqFBxkhHWcCAyYDBNqfXJQLaK9YG396HjSOIkhlWV0NAcXGTLPAuDTb0IRnbGufOZIl3XNOXOQcLdHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YRfI3oSI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YRfI3oSI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0052C1F000E9;
	Wed, 20 May 2026 17:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298993;
	bh=W9tPojonAKJALsksOzHTvT/W8LWvq09J+f1IXCqGBLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YRfI3oSIFrURV8VSRgGSW9XGG6d6FRkvmYS6jgsUhUUAfr1Nj8Kua+IBIMN1jFRd/
	 I7Nyj9Xm9MACP/fuVPmcyBKSGPMNBvm/Yn6TM3SBt2L7zv+o7JnoVjdh5jhJ2k44lB
	 heBuQPwXDzZiHhkaSwF+XO+9TtKPk2n5Hmnw0sL4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 581/957] f2fs: use f2fs_filemap_get_folio() instead of f2fs_pagecache_get_page()
Date: Wed, 20 May 2026 18:17:44 +0200
Message-ID: <20260520162147.130422770@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Chao Yu <chao@kernel.org>

[ Upstream commit e0b89d00ea9f846da42fc92f200c96254d0e2fef ]

Let's use f2fs_filemap_get_folio() instead of f2fs_pagecache_get_page() in
ra_data_block() and move_data_block(), then remove f2fs_pagecache_get_page()
since it has no user.

Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Stable-dep-of: 570e2ccc7cb3 ("f2fs: avoid reading already updated pages during GC")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/f2fs.h | 10 ----------
 fs/f2fs/gc.c   | 23 +++++++++++++----------
 2 files changed, 13 insertions(+), 20 deletions(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 939bd1fb57070..c0747dd2ce511 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -2996,16 +2996,6 @@ static inline struct folio *f2fs_filemap_get_folio(
 	return __filemap_get_folio(mapping, index, fgp_flags, gfp_mask);
 }
 
-static inline struct page *f2fs_pagecache_get_page(
-				struct address_space *mapping, pgoff_t index,
-				fgf_t fgp_flags, gfp_t gfp_mask)
-{
-	if (time_to_inject(F2FS_M_SB(mapping), FAULT_PAGE_GET))
-		return NULL;
-
-	return pagecache_get_page(mapping, index, fgp_flags, gfp_mask);
-}
-
 static inline void f2fs_folio_put(struct folio *folio, bool unlock)
 {
 	if (IS_ERR_OR_NULL(folio))
diff --git a/fs/f2fs/gc.c b/fs/f2fs/gc.c
index 9d2f4f22fd396..5647e76c6bdb0 100644
--- a/fs/f2fs/gc.c
+++ b/fs/f2fs/gc.c
@@ -1211,7 +1211,7 @@ static int ra_data_block(struct inode *inode, pgoff_t index)
 	struct address_space *mapping = f2fs_is_cow_file(inode) ?
 				F2FS_I(inode)->atomic_inode->i_mapping : inode->i_mapping;
 	struct dnode_of_data dn;
-	struct folio *folio;
+	struct folio *folio, *efolio;
 	struct f2fs_io_info fio = {
 		.sbi = sbi,
 		.ino = inode->i_ino,
@@ -1266,14 +1266,15 @@ static int ra_data_block(struct inode *inode, pgoff_t index)
 
 	f2fs_wait_on_block_writeback(inode, dn.data_blkaddr);
 
-	fio.encrypted_page = f2fs_pagecache_get_page(META_MAPPING(sbi),
-					dn.data_blkaddr,
+	efolio = f2fs_filemap_get_folio(META_MAPPING(sbi), dn.data_blkaddr,
 					FGP_LOCK | FGP_CREAT, GFP_NOFS);
-	if (!fio.encrypted_page) {
-		err = -ENOMEM;
+	if (IS_ERR(efolio)) {
+		err = PTR_ERR(efolio);
 		goto put_folio;
 	}
 
+	fio.encrypted_page = &efolio->page;
+
 	err = f2fs_submit_page_bio(&fio);
 	if (err)
 		goto put_encrypted_page;
@@ -1313,7 +1314,7 @@ static int move_data_block(struct inode *inode, block_t bidx,
 	struct dnode_of_data dn;
 	struct f2fs_summary sum;
 	struct node_info ni;
-	struct folio *folio, *mfolio;
+	struct folio *folio, *mfolio, *efolio;
 	block_t newaddr;
 	int err = 0;
 	bool lfs_mode = f2fs_lfs_mode(fio.sbi);
@@ -1407,14 +1408,16 @@ static int move_data_block(struct inode *inode, block_t bidx,
 		goto up_out;
 	}
 
-	fio.encrypted_page = f2fs_pagecache_get_page(META_MAPPING(fio.sbi),
-				newaddr, FGP_LOCK | FGP_CREAT, GFP_NOFS);
-	if (!fio.encrypted_page) {
-		err = -ENOMEM;
+	efolio = f2fs_filemap_get_folio(META_MAPPING(fio.sbi), newaddr,
+					FGP_LOCK | FGP_CREAT, GFP_NOFS);
+	if (IS_ERR(efolio)) {
+		err = PTR_ERR(efolio);
 		f2fs_folio_put(mfolio, true);
 		goto recover_block;
 	}
 
+	fio.encrypted_page = &efolio->page;
+
 	/* write target block */
 	f2fs_wait_on_page_writeback(fio.encrypted_page, DATA, true, true);
 	memcpy(page_address(fio.encrypted_page),
-- 
2.53.0



