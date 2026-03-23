Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62FB83AE70F;
	Mon, 23 Mar 2026 14:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277678; cv=none; b=XKqyJYbcY1R3kF3NCq9T52JygnZegU8a6dkUxT1I1VbrcJwQV7oLz/6H4CnIkOOOq3noc88l4OfSdf8qhBPaX2G6cvONWO+MnYjSKVLfRQ0pKAAo04BYGN6zvecg3NCVq74hHDpBG6wte9nnP23JMChKdFpR+WC7y2lAkBQSO4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277678; c=relaxed/simple;
	bh=Wj/ejgB4YCkld6AcLLi26AGQP4klXgCFvzWHiInBPZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C3frAKg8JjJkfgWkVYRdnuKHmG4B4Pzjf4ddVdB+KiEPP80qgjY9St5e6DMp3PiZp0xNPHXogiH+S22LdSwYZJFH0lSdU94Q9E4X7AMkKrgOfBbsl2gsEXD03+iifaMl2+jIlQ19/hwaU1h2OQyTmhVPUDbEZypez/kqY225c+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MgxVnPvj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MgxVnPvj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4E7CC4CEF7;
	Mon, 23 Mar 2026 14:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277678;
	bh=Wj/ejgB4YCkld6AcLLi26AGQP4klXgCFvzWHiInBPZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MgxVnPvjcMrMrgpiyv+NnuqR5iGwVAIsqoX8pTSMiAnmRL0t7lzprdzgDIgCMPkgj
	 RyynHwS42KKswK6+ekcZyBJq3HhC66wPoADX2Wa0pUgWIvGU+c7jQ2rxMRm5fqp4i/
	 7cdznK3Lcw9P46k2F4j8PXED54FVWR+8O/n0oudQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 068/567] ext4: convert bd_bitmap_page to bd_bitmap_folio
Date: Mon, 23 Mar 2026 14:39:48 +0100
Message-ID: <20260323134535.504070080@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Wilcox (Oracle) <willy@infradead.org>

[ Upstream commit 99b150d84e4939735cfce245e32e3d29312c68ec ]

There is no need to make this a multi-page folio, so leave all the
infrastructure around it in pages.  But since we're locking it, playing
with its refcount and checking whether it's uptodate, it needs to move
to the folio API.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Link: https://lore.kernel.org/r/20240416172900.244637-2-willy@infradead.org
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Stable-dep-of: bdc56a9c46b2 ("ext4: fix e4b bitmap inconsistency reports")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/mballoc.c | 98 ++++++++++++++++++++++++-----------------------
 fs/ext4/mballoc.h |  2 +-
 2 files changed, 52 insertions(+), 48 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index ade2090155c1c..b5a5b89dfc98f 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -1461,9 +1461,10 @@ static int ext4_mb_get_buddy_page_lock(struct super_block *sb,
 	int block, pnum, poff;
 	int blocks_per_page;
 	struct page *page;
+	struct folio *folio;
 
 	e4b->bd_buddy_page = NULL;
-	e4b->bd_bitmap_page = NULL;
+	e4b->bd_bitmap_folio = NULL;
 
 	blocks_per_page = PAGE_SIZE / sb->s_blocksize;
 	/*
@@ -1474,12 +1475,13 @@ static int ext4_mb_get_buddy_page_lock(struct super_block *sb,
 	block = group * 2;
 	pnum = block / blocks_per_page;
 	poff = block % blocks_per_page;
-	page = find_or_create_page(inode->i_mapping, pnum, gfp);
-	if (!page)
-		return -ENOMEM;
-	BUG_ON(page->mapping != inode->i_mapping);
-	e4b->bd_bitmap_page = page;
-	e4b->bd_bitmap = page_address(page) + (poff * sb->s_blocksize);
+	folio = __filemap_get_folio(inode->i_mapping, pnum,
+			FGP_LOCK | FGP_ACCESSED | FGP_CREAT, gfp);
+	if (IS_ERR(folio))
+		return PTR_ERR(folio);
+	BUG_ON(folio->mapping != inode->i_mapping);
+	e4b->bd_bitmap_folio = folio;
+	e4b->bd_bitmap = folio_address(folio) + (poff * sb->s_blocksize);
 
 	if (blocks_per_page >= 2) {
 		/* buddy and bitmap are on the same page */
@@ -1497,9 +1499,9 @@ static int ext4_mb_get_buddy_page_lock(struct super_block *sb,
 
 static void ext4_mb_put_buddy_page_lock(struct ext4_buddy *e4b)
 {
-	if (e4b->bd_bitmap_page) {
-		unlock_page(e4b->bd_bitmap_page);
-		put_page(e4b->bd_bitmap_page);
+	if (e4b->bd_bitmap_folio) {
+		folio_unlock(e4b->bd_bitmap_folio);
+		folio_put(e4b->bd_bitmap_folio);
 	}
 	if (e4b->bd_buddy_page) {
 		unlock_page(e4b->bd_buddy_page);
@@ -1519,6 +1521,7 @@ int ext4_mb_init_group(struct super_block *sb, ext4_group_t group, gfp_t gfp)
 	struct ext4_group_info *this_grp;
 	struct ext4_buddy e4b;
 	struct page *page;
+	struct folio *folio;
 	int ret = 0;
 
 	might_sleep();
@@ -1545,11 +1548,11 @@ int ext4_mb_init_group(struct super_block *sb, ext4_group_t group, gfp_t gfp)
 		goto err;
 	}
 
-	page = e4b.bd_bitmap_page;
-	ret = ext4_mb_init_cache(page, NULL, gfp);
+	folio = e4b.bd_bitmap_folio;
+	ret = ext4_mb_init_cache(&folio->page, NULL, gfp);
 	if (ret)
 		goto err;
-	if (!PageUptodate(page)) {
+	if (!folio_test_uptodate(folio)) {
 		ret = -EIO;
 		goto err;
 	}
@@ -1591,6 +1594,7 @@ ext4_mb_load_buddy_gfp(struct super_block *sb, ext4_group_t group,
 	int pnum;
 	int poff;
 	struct page *page;
+	struct folio *folio;
 	int ret;
 	struct ext4_group_info *grp;
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
@@ -1609,7 +1613,7 @@ ext4_mb_load_buddy_gfp(struct super_block *sb, ext4_group_t group,
 	e4b->bd_sb = sb;
 	e4b->bd_group = group;
 	e4b->bd_buddy_page = NULL;
-	e4b->bd_bitmap_page = NULL;
+	e4b->bd_bitmap_folio = NULL;
 
 	if (unlikely(EXT4_MB_GRP_NEED_INIT(grp))) {
 		/*
@@ -1630,53 +1634,53 @@ ext4_mb_load_buddy_gfp(struct super_block *sb, ext4_group_t group,
 	pnum = block / blocks_per_page;
 	poff = block % blocks_per_page;
 
-	/* we could use find_or_create_page(), but it locks page
-	 * what we'd like to avoid in fast path ... */
-	page = find_get_page_flags(inode->i_mapping, pnum, FGP_ACCESSED);
-	if (page == NULL || !PageUptodate(page)) {
-		if (page)
+	/* Avoid locking the folio in the fast path ... */
+	folio = __filemap_get_folio(inode->i_mapping, pnum, FGP_ACCESSED, 0);
+	if (IS_ERR(folio) || !folio_test_uptodate(folio)) {
+		if (!IS_ERR(folio))
 			/*
-			 * drop the page reference and try
-			 * to get the page with lock. If we
+			 * drop the folio reference and try
+			 * to get the folio with lock. If we
 			 * are not uptodate that implies
-			 * somebody just created the page but
-			 * is yet to initialize the same. So
+			 * somebody just created the folio but
+			 * is yet to initialize it. So
 			 * wait for it to initialize.
 			 */
-			put_page(page);
-		page = find_or_create_page(inode->i_mapping, pnum, gfp);
-		if (page) {
-			if (WARN_RATELIMIT(page->mapping != inode->i_mapping,
-	"ext4: bitmap's paging->mapping != inode->i_mapping\n")) {
+			folio_put(folio);
+		folio = __filemap_get_folio(inode->i_mapping, pnum,
+				FGP_LOCK | FGP_ACCESSED | FGP_CREAT, gfp);
+		if (!IS_ERR(folio)) {
+			if (WARN_RATELIMIT(folio->mapping != inode->i_mapping,
+	"ext4: bitmap's mapping != inode->i_mapping\n")) {
 				/* should never happen */
-				unlock_page(page);
+				folio_unlock(folio);
 				ret = -EINVAL;
 				goto err;
 			}
-			if (!PageUptodate(page)) {
-				ret = ext4_mb_init_cache(page, NULL, gfp);
+			if (!folio_test_uptodate(folio)) {
+				ret = ext4_mb_init_cache(&folio->page, NULL, gfp);
 				if (ret) {
-					unlock_page(page);
+					folio_unlock(folio);
 					goto err;
 				}
-				mb_cmp_bitmaps(e4b, page_address(page) +
+				mb_cmp_bitmaps(e4b, folio_address(folio) +
 					       (poff * sb->s_blocksize));
 			}
-			unlock_page(page);
+			folio_unlock(folio);
 		}
 	}
-	if (page == NULL) {
-		ret = -ENOMEM;
+	if (IS_ERR(folio)) {
+		ret = PTR_ERR(folio);
 		goto err;
 	}
-	if (!PageUptodate(page)) {
+	if (!folio_test_uptodate(folio)) {
 		ret = -EIO;
 		goto err;
 	}
 
 	/* Pages marked accessed already */
-	e4b->bd_bitmap_page = page;
-	e4b->bd_bitmap = page_address(page) + (poff * sb->s_blocksize);
+	e4b->bd_bitmap_folio = folio;
+	e4b->bd_bitmap = folio_address(folio) + (poff * sb->s_blocksize);
 
 	block++;
 	pnum = block / blocks_per_page;
@@ -1724,8 +1728,8 @@ ext4_mb_load_buddy_gfp(struct super_block *sb, ext4_group_t group,
 err:
 	if (page)
 		put_page(page);
-	if (e4b->bd_bitmap_page)
-		put_page(e4b->bd_bitmap_page);
+	if (e4b->bd_bitmap_folio)
+		folio_put(e4b->bd_bitmap_folio);
 
 	e4b->bd_buddy = NULL;
 	e4b->bd_bitmap = NULL;
@@ -1740,8 +1744,8 @@ static int ext4_mb_load_buddy(struct super_block *sb, ext4_group_t group,
 
 static void ext4_mb_unload_buddy(struct ext4_buddy *e4b)
 {
-	if (e4b->bd_bitmap_page)
-		put_page(e4b->bd_bitmap_page);
+	if (e4b->bd_bitmap_folio)
+		folio_put(e4b->bd_bitmap_folio);
 	if (e4b->bd_buddy_page)
 		put_page(e4b->bd_buddy_page);
 }
@@ -2167,7 +2171,7 @@ static void ext4_mb_use_best_found(struct ext4_allocation_context *ac,
 	 * double allocate blocks. The reference is dropped
 	 * in ext4_mb_release_context
 	 */
-	ac->ac_bitmap_page = e4b->bd_bitmap_page;
+	ac->ac_bitmap_page = &e4b->bd_bitmap_folio->page;
 	get_page(ac->ac_bitmap_page);
 	ac->ac_buddy_page = e4b->bd_buddy_page;
 	get_page(ac->ac_buddy_page);
@@ -3902,7 +3906,7 @@ static void ext4_free_data_in_buddy(struct super_block *sb,
 		 * balance refcounts from ext4_mb_free_metadata()
 		 */
 		put_page(e4b.bd_buddy_page);
-		put_page(e4b.bd_bitmap_page);
+		folio_put(e4b.bd_bitmap_folio);
 	}
 	ext4_unlock_group(sb, entry->efd_group);
 	ext4_mb_unload_buddy(&e4b);
@@ -6348,7 +6352,7 @@ ext4_mb_free_metadata(handle_t *handle, struct ext4_buddy *e4b,
 	struct rb_node *parent = NULL, *new_node;
 
 	BUG_ON(!ext4_handle_valid(handle));
-	BUG_ON(e4b->bd_bitmap_page == NULL);
+	BUG_ON(e4b->bd_bitmap_folio == NULL);
 	BUG_ON(e4b->bd_buddy_page == NULL);
 
 	new_node = &new_entry->efd_node;
@@ -6361,7 +6365,7 @@ ext4_mb_free_metadata(handle_t *handle, struct ext4_buddy *e4b,
 		 * on-disk bitmap and lose not-yet-available
 		 * blocks */
 		get_page(e4b->bd_buddy_page);
-		get_page(e4b->bd_bitmap_page);
+		folio_get(e4b->bd_bitmap_folio);
 	}
 	while (*n) {
 		parent = *n;
diff --git a/fs/ext4/mballoc.h b/fs/ext4/mballoc.h
index dd16050022f52..2d0aca8dc02e8 100644
--- a/fs/ext4/mballoc.h
+++ b/fs/ext4/mballoc.h
@@ -218,7 +218,7 @@ struct ext4_allocation_context {
 struct ext4_buddy {
 	struct page *bd_buddy_page;
 	void *bd_buddy;
-	struct page *bd_bitmap_page;
+	struct folio *bd_bitmap_folio;
 	void *bd_bitmap;
 	struct ext4_group_info *bd_info;
 	struct super_block *bd_sb;
-- 
2.51.0



