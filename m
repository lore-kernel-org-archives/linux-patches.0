Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214944;
	b=HOI1ONOEcjD1qH1tZrSnr6dYApdrpZ7g1yEwQxzSXkkS3ExanKnX0Bx5VZSwtxMM8x4V
	 Lj4u8USnnZK5ZJWLWlt6GIZ+c9X0pzLTBunjs6awR8OygLMCp9xqituLRu2g48afrs0oR
	 e8Qu5AZeYEkj1/f1AjhTAGcoIyBLI8aqSkxGD51MzXudMiPpb2t+oASik/UqXLwbtdRXw
	 DGW6Cij3diyWw9xHHv3cgneOpUUEumn6yJddqSpLHcJhQDikmxBZDZYqhBX4EJSDPkjyX
	 Qfix8Ia90zsVEuC4vRZxaV2zEdaShCdhagqTA+SkBT+OREEzyMruJi2J0CMgT49KUQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214944;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ipQjnwg1grm0sJ9OF/2tJBQwyYWwMcW/E7W+ageXmFk=;
	b=a0NAUMo+l6qooCUoNCQdq08ktb9bT9fZenxMrb4zOFU2oOToikPBKWBYoA3DC7utAicw
	 t7Jkmq35dyU/CMd3xBx4xW91qrEsDA3qAVD8htMGrESQACmdwfhiX8EGdAY29fBNpcrDJ
	 djK9ztRKuZK5TIvFBE3jMpzaIMf6hkVmwQ+K+djeH/TQxA2cHFg/70xRkl1RXC6XcBByL
	 NG80P26etYjcaMSG6aCRJ0hz1MHO4EBVdAI05sgGvWoirpWzOmW5z6V7M/DeZ7O7+WhSy
	 Jlq0dKQqBzdW+idr3KlvQo8u88c22KUxorBtH+HP7D1yKIFL/F8+34uonDjBmHwcVSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0g3s9EpT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B658A606A323;
	Wed, 28 Oct 2026 19:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0g3s9EpT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 112551F01828;
	Wed, 28 Oct 2026 19:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214943;
	bh=ipQjnwg1grm0sJ9OF/2tJBQwyYWwMcW/E7W+ageXmFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0g3s9EpT93aMzP+TgnNnmul9aQrxnRCL3+viVqyeUMj9SO7WB3QLrT+XVl+fV/YFz
	 LZXUqVBR2IlWTv8Ob6p1uOzieoi9cZ4b0dOK9IzLXuqNUv3lagqkedriyhQ7G32HO2
	 jV5NVeyrYOxwe5twNQWNBAR10HxRT0V6uOxCz4nY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1035/1887] ext4: convert bd_bitmap_page to bd_bitmap_folio
Date: Wed, 28 Oct 2026 17:52:11 +0100
Message-ID: <20261028170522.965283058@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 3b9a345b94140..4b3635438632f 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -1360,9 +1360,10 @@ static int ext4_mb_get_buddy_page_lock(struct super_block *sb,
 	int block, pnum, poff;
 	int blocks_per_page;
 	struct page *page;
+	struct folio *folio;
 
 	e4b->bd_buddy_page = NULL;
-	e4b->bd_bitmap_page = NULL;
+	e4b->bd_bitmap_folio = NULL;
 
 	blocks_per_page = PAGE_SIZE / sb->s_blocksize;
 	/*
@@ -1373,12 +1374,13 @@ static int ext4_mb_get_buddy_page_lock(struct super_block *sb,
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
@@ -1396,9 +1398,9 @@ static int ext4_mb_get_buddy_page_lock(struct super_block *sb,
 
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
@@ -1418,6 +1420,7 @@ int ext4_mb_init_group(struct super_block *sb, ext4_group_t group, gfp_t gfp)
 	struct ext4_group_info *this_grp;
 	struct ext4_buddy e4b;
 	struct page *page;
+	struct folio *folio;
 	int ret = 0;
 
 	might_sleep();
@@ -1444,11 +1447,11 @@ int ext4_mb_init_group(struct super_block *sb, ext4_group_t group, gfp_t gfp)
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
@@ -1490,6 +1493,7 @@ ext4_mb_load_buddy_gfp(struct super_block *sb, ext4_group_t group,
 	int pnum;
 	int poff;
 	struct page *page;
+	struct folio *folio;
 	int ret;
 	struct ext4_group_info *grp;
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
@@ -1508,7 +1512,7 @@ ext4_mb_load_buddy_gfp(struct super_block *sb, ext4_group_t group,
 	e4b->bd_sb = sb;
 	e4b->bd_group = group;
 	e4b->bd_buddy_page = NULL;
-	e4b->bd_bitmap_page = NULL;
+	e4b->bd_bitmap_folio = NULL;
 
 	if (unlikely(EXT4_MB_GRP_NEED_INIT(grp))) {
 		/*
@@ -1529,53 +1533,53 @@ ext4_mb_load_buddy_gfp(struct super_block *sb, ext4_group_t group,
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
@@ -1623,8 +1627,8 @@ ext4_mb_load_buddy_gfp(struct super_block *sb, ext4_group_t group,
 err:
 	if (page)
 		put_page(page);
-	if (e4b->bd_bitmap_page)
-		put_page(e4b->bd_bitmap_page);
+	if (e4b->bd_bitmap_folio)
+		folio_put(e4b->bd_bitmap_folio);
 
 	e4b->bd_buddy = NULL;
 	e4b->bd_bitmap = NULL;
@@ -1639,8 +1643,8 @@ static int ext4_mb_load_buddy(struct super_block *sb, ext4_group_t group,
 
 static void ext4_mb_unload_buddy(struct ext4_buddy *e4b)
 {
-	if (e4b->bd_bitmap_page)
-		put_page(e4b->bd_bitmap_page);
+	if (e4b->bd_bitmap_folio)
+		folio_put(e4b->bd_bitmap_folio);
 	if (e4b->bd_buddy_page)
 		put_page(e4b->bd_buddy_page);
 }
@@ -2065,7 +2069,7 @@ static void ext4_mb_use_best_found(struct ext4_allocation_context *ac,
 	 * double allocate blocks. The reference is dropped
 	 * in ext4_mb_release_context
 	 */
-	ac->ac_bitmap_page = e4b->bd_bitmap_page;
+	ac->ac_bitmap_page = &e4b->bd_bitmap_folio->page;
 	get_page(ac->ac_bitmap_page);
 	ac->ac_buddy_page = e4b->bd_buddy_page;
 	get_page(ac->ac_buddy_page);
@@ -3727,7 +3731,7 @@ static void ext4_free_data_in_buddy(struct super_block *sb,
 		 * balance refcounts from ext4_mb_free_metadata()
 		 */
 		put_page(e4b.bd_buddy_page);
-		put_page(e4b.bd_bitmap_page);
+		folio_put(e4b.bd_bitmap_folio);
 	}
 	ext4_unlock_group(sb, entry->efd_group);
 	ext4_mb_unload_buddy(&e4b);
@@ -5889,7 +5893,7 @@ ext4_mb_free_metadata(handle_t *handle, struct ext4_buddy *e4b,
 	struct rb_node *parent = NULL, *new_node;
 
 	BUG_ON(!ext4_handle_valid(handle));
-	BUG_ON(e4b->bd_bitmap_page == NULL);
+	BUG_ON(e4b->bd_bitmap_folio == NULL);
 	BUG_ON(e4b->bd_buddy_page == NULL);
 
 	new_node = &new_entry->efd_node;
@@ -5902,7 +5906,7 @@ ext4_mb_free_metadata(handle_t *handle, struct ext4_buddy *e4b,
 		 * on-disk bitmap and lose not-yet-available
 		 * blocks */
 		get_page(e4b->bd_buddy_page);
-		get_page(e4b->bd_bitmap_page);
+		folio_get(e4b->bd_bitmap_folio);
 	}
 	while (*n) {
 		parent = *n;
diff --git a/fs/ext4/mballoc.h b/fs/ext4/mballoc.h
index 2d95fcab941f6..24e7c7a04f674 100644
--- a/fs/ext4/mballoc.h
+++ b/fs/ext4/mballoc.h
@@ -203,7 +203,7 @@ struct ext4_allocation_context {
 struct ext4_buddy {
 	struct page *bd_buddy_page;
 	void *bd_buddy;
-	struct page *bd_bitmap_page;
+	struct folio *bd_bitmap_folio;
 	void *bd_bitmap;
 	struct ext4_group_info *bd_info;
 	struct super_block *bd_sb;
-- 
2.53.0



