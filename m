Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18DAB22301;
	Mon,  1 Apr 2024 16:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987343; cv=none; b=A15th7CZmr7YYAeKN0Nuz0C56menea6eWIqyYzlqJspYzVkC1DryZqQbIBlE63YdaHo0Y9AjvU4gambzL55C2GcBclZp+gUo+WUQnt6qhpKvDGmrIV3NPahOrDuELqMQZUV4jej/5RquTtT9UAQ0nbJgKbEH7nt0ClSdfKPp/Sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987343; c=relaxed/simple;
	bh=lMexzwI+XmKL0iEzAHtDf3F2iarKY/aQDU7IeFjh4xs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jVBio3N7Uxmd7aWUAWTtITntvrZgEnmsvgA/VxlhLlXFfKDz7lIksJym/kKhp6sUze3dEHceBj3QO+afHsA00K0RkXHvm4BUNMwQfwjB25878E5yP3KQMrqnX+8hkuPlJdQ+hejAi8/KBHu+VxVyaRjnW1N7ZbicixO2gaOY59g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sNFKELhj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sNFKELhj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31CF6C433F1;
	Mon,  1 Apr 2024 16:02:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987342;
	bh=lMexzwI+XmKL0iEzAHtDf3F2iarKY/aQDU7IeFjh4xs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sNFKELhjT633FDJuWY3M0Uq1S4zIx0Fg95Nf0B9It0Oh4PtrVP14QTjZTEjijlYZ5
	 aNT1ikjvG+eP+ZDiNfuY7zqHSgX8SaFfpTndmELniPO3RH04I5AoHWFYiYIBwlfQEa
	 PmI8Hoa2q5q9aUXqcs1+4OY3ff+RbR1fSKkvK90Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Anand Jain <anand.jain@oracle.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 231/399] btrfs: add helpers to get fs_info from page/folio pointers
Date: Mon,  1 Apr 2024 17:43:17 +0200
Message-ID: <20240401152556.076007491@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Sterba <dsterba@suse.com>

[ Upstream commit b33d2e535f9b2a1c4210cfc4843ac0dbacbeebcc ]

Add convenience helpers to get a fs_info from a page or folio pointer
instead of open coding the chain or using btrfs_sb() that in some cases
does one more pointer hop.  This is implemented as a macro (still with
type checking) so we don't need full definitions of struct page, folio,
btrfs_root and btrfs_fs_info. The latter can't be static inlines as this
would create loop between ctree.h <-> fs.h, or the headers would have to
be restructured.

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 86211eea8ae1 ("btrfs: qgroup: validate btrfs_qgroup_inherit parameter")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/compression.c |  2 +-
 fs/btrfs/disk-io.c     |  2 +-
 fs/btrfs/extent_io.c   | 16 ++++++++--------
 fs/btrfs/fs.h          |  3 +++
 fs/btrfs/inode.c       |  2 +-
 fs/btrfs/lzo.c         |  2 +-
 6 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index 68345f73d429a..aeb3b2aa73310 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -1039,7 +1039,7 @@ static int btrfs_decompress_bio(struct compressed_bio *cb)
 int btrfs_decompress(int type, const u8 *data_in, struct page *dest_page,
 		     unsigned long dest_pgoff, size_t srclen, size_t destlen)
 {
-	struct btrfs_fs_info *fs_info = btrfs_sb(dest_page->mapping->host->i_sb);
+	struct btrfs_fs_info *fs_info = page_to_fs_info(dest_page);
 	struct list_head *workspace;
 	const u32 sectorsize = fs_info->sectorsize;
 	int ret;
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index e9eb3f0f245b2..6096628fdb21f 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -534,7 +534,7 @@ static void btree_invalidate_folio(struct folio *folio, size_t offset,
 	extent_invalidate_folio(tree, folio, offset);
 	btree_release_folio(folio, GFP_NOFS);
 	if (folio_get_private(folio)) {
-		btrfs_warn(BTRFS_I(folio->mapping->host)->root->fs_info,
+		btrfs_warn(folio_to_fs_info(folio),
 			   "folio private not zero on folio %llu",
 			   (unsigned long long)folio_pos(folio));
 		folio_detach_private(folio);
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index cf94e88bf8d05..a6c712429fd2d 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -433,7 +433,7 @@ static bool btrfs_verify_page(struct page *page, u64 start)
 
 static void end_page_read(struct page *page, bool uptodate, u64 start, u32 len)
 {
-	struct btrfs_fs_info *fs_info = btrfs_sb(page->mapping->host->i_sb);
+	struct btrfs_fs_info *fs_info = page_to_fs_info(page);
 	struct folio *folio = page_folio(page);
 
 	ASSERT(page_offset(page) <= start &&
@@ -948,7 +948,7 @@ int set_folio_extent_mapped(struct folio *folio)
 	if (folio_test_private(folio))
 		return 0;
 
-	fs_info = btrfs_sb(folio->mapping->host->i_sb);
+	fs_info = folio_to_fs_info(folio);
 
 	if (btrfs_is_subpage(fs_info, folio->mapping))
 		return btrfs_attach_subpage(fs_info, folio, BTRFS_SUBPAGE_DATA);
@@ -967,7 +967,7 @@ void clear_page_extent_mapped(struct page *page)
 	if (!folio_test_private(folio))
 		return;
 
-	fs_info = btrfs_sb(page->mapping->host->i_sb);
+	fs_info = page_to_fs_info(page);
 	if (btrfs_is_subpage(fs_info, page->mapping))
 		return btrfs_detach_subpage(fs_info, folio);
 
@@ -1770,7 +1770,7 @@ static noinline_for_stack void write_one_eb(struct extent_buffer *eb,
  */
 static int submit_eb_subpage(struct page *page, struct writeback_control *wbc)
 {
-	struct btrfs_fs_info *fs_info = btrfs_sb(page->mapping->host->i_sb);
+	struct btrfs_fs_info *fs_info = page_to_fs_info(page);
 	struct folio *folio = page_folio(page);
 	int submitted = 0;
 	u64 page_start = page_offset(page);
@@ -1861,7 +1861,7 @@ static int submit_eb_page(struct page *page, struct btrfs_eb_write_context *ctx)
 	if (!folio_test_private(folio))
 		return 0;
 
-	if (btrfs_sb(page->mapping->host->i_sb)->nodesize < PAGE_SIZE)
+	if (page_to_fs_info(page)->nodesize < PAGE_SIZE)
 		return submit_eb_subpage(page, wbc);
 
 	spin_lock(&mapping->i_private_lock);
@@ -2313,7 +2313,7 @@ int extent_invalidate_folio(struct extent_io_tree *tree,
 	struct extent_state *cached_state = NULL;
 	u64 start = folio_pos(folio);
 	u64 end = start + folio_size(folio) - 1;
-	size_t blocksize = btrfs_sb(folio->mapping->host->i_sb)->sectorsize;
+	size_t blocksize = folio_to_fs_info(folio)->sectorsize;
 
 	/* This function is only called for the btree inode */
 	ASSERT(tree->owner == IO_TREE_BTREE_INODE_IO);
@@ -4940,7 +4940,7 @@ static struct extent_buffer *get_next_extent_buffer(
 
 static int try_release_subpage_extent_buffer(struct page *page)
 {
-	struct btrfs_fs_info *fs_info = btrfs_sb(page->mapping->host->i_sb);
+	struct btrfs_fs_info *fs_info = page_to_fs_info(page);
 	u64 cur = page_offset(page);
 	const u64 end = page_offset(page) + PAGE_SIZE;
 	int ret;
@@ -5013,7 +5013,7 @@ int try_release_extent_buffer(struct page *page)
 	struct folio *folio = page_folio(page);
 	struct extent_buffer *eb;
 
-	if (btrfs_sb(page->mapping->host->i_sb)->nodesize < PAGE_SIZE)
+	if (page_to_fs_info(page)->nodesize < PAGE_SIZE)
 		return try_release_subpage_extent_buffer(page);
 
 	/*
diff --git a/fs/btrfs/fs.h b/fs/btrfs/fs.h
index 1cfd16f956e77..0e15b2a791bf1 100644
--- a/fs/btrfs/fs.h
+++ b/fs/btrfs/fs.h
@@ -834,6 +834,9 @@ struct btrfs_fs_info {
 #define folio_to_inode(_folio)	(BTRFS_I(_Generic((_folio),			\
 					  struct folio *: (_folio))->mapping->host))
 
+#define page_to_fs_info(_page)	 (page_to_inode(_page)->root->fs_info)
+#define folio_to_fs_info(_folio) (folio_to_inode(_folio)->root->fs_info)
+
 static inline u64 btrfs_get_fs_generation(const struct btrfs_fs_info *fs_info)
 {
 	return READ_ONCE(fs_info->generation);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 6948440286e55..1e800c8bb4d9f 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7903,7 +7903,7 @@ static void btrfs_readahead(struct readahead_control *rac)
  */
 static void wait_subpage_spinlock(struct page *page)
 {
-	struct btrfs_fs_info *fs_info = btrfs_sb(page->mapping->host->i_sb);
+	struct btrfs_fs_info *fs_info = page_to_fs_info(page);
 	struct folio *folio = page_folio(page);
 	struct btrfs_subpage *subpage;
 
diff --git a/fs/btrfs/lzo.c b/fs/btrfs/lzo.c
index e43bc0fdc74ec..110a2c304bdc7 100644
--- a/fs/btrfs/lzo.c
+++ b/fs/btrfs/lzo.c
@@ -429,7 +429,7 @@ int lzo_decompress(struct list_head *ws, const u8 *data_in,
 		size_t destlen)
 {
 	struct workspace *workspace = list_entry(ws, struct workspace, list);
-	struct btrfs_fs_info *fs_info = btrfs_sb(dest_page->mapping->host->i_sb);
+	struct btrfs_fs_info *fs_info = page_to_fs_info(dest_page);
 	const u32 sectorsize = fs_info->sectorsize;
 	size_t in_len;
 	size_t out_len;
-- 
2.43.0



