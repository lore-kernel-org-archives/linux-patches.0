Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACCEA1CA8F;
	Mon,  1 Apr 2024 16:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987307; cv=none; b=B1Q8KpvldJMO4CuZn7ciWgf9BYYEkoYS2BCtQDfgHOl1j/VGs98CV5HLk1ggT2zo/i7yESr+HkHTSnFE6kMaratZZxhfdwar51m9cB+Rahb3HEuDChj/F86SJyvg1gHrx6a/Y7voGyg6F1lV3jfoLm1AdG9r9/th9r7P2O+JEwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987307; c=relaxed/simple;
	bh=NgQf+vX7oDoswOEIyYunN5pbbhri7vyw/bwPeicWmP4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BK1Zw1FWitIoyw2uSw3/iQykb1DLTnizyPb6eQDEQT8N3edAIjxKxGsAK6WbnmKZ+hxmxzi7Rf4nhoWfxSpgPNtxQK8lMFnrrzCx2L60dW+YTPoO0nGuapjBFsTaCWM24kWRw79YMV4V1U1Gs5u2NmhvlF/4pUzj8oXnWvzdDmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rf9r6g6Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rf9r6g6Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5DEAC433C7;
	Mon,  1 Apr 2024 16:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987307;
	bh=NgQf+vX7oDoswOEIyYunN5pbbhri7vyw/bwPeicWmP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rf9r6g6Z6xw4JvF8rdwzE6K8Ocu1ixoN7PsjT33XAxpj9p/NJ8xHKEwt9gPdLfSjo
	 AzBGc5YAX1ZMhFMojfWhthxUxqN5h3A1KRPYxj2c+DrnnOVPxhLLVC3xYUVo36rgPL
	 YP2pEpCbB6ySIh4Z9gPjqurD+97aex6vj2MF21hY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Anand Jain <anand.jain@oracle.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 230/399] btrfs: add helpers to get inode from page/folio pointers
Date: Mon,  1 Apr 2024 17:43:16 +0200
Message-ID: <20240401152556.046828126@linuxfoundation.org>
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

[ Upstream commit c8293894afa718653688b2fa98ab68317c875a00 ]

Add convenience helpers to get a struct btrfs_inode from a page or folio
pointer instead of open coding the chain or intermediate BTRFS_I. This
is implemented as a macro (still with type checking) so we don't need
full definitions of struct page or address_space.

Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Anand Jain <anand.jain@oracle.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 86211eea8ae1 ("btrfs: qgroup: validate btrfs_qgroup_inherit parameter")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/disk-io.c   | 3 ++-
 fs/btrfs/extent_io.c | 8 ++++----
 fs/btrfs/fs.h        | 5 +++++
 fs/btrfs/inode.c     | 2 +-
 4 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 091104a327326..e9eb3f0f245b2 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -529,7 +529,8 @@ static void btree_invalidate_folio(struct folio *folio, size_t offset,
 				 size_t length)
 {
 	struct extent_io_tree *tree;
-	tree = &BTRFS_I(folio->mapping->host)->io_tree;
+
+	tree = &folio_to_inode(folio)->io_tree;
 	extent_invalidate_folio(tree, folio, offset);
 	btree_release_folio(folio, GFP_NOFS);
 	if (folio_get_private(folio)) {
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 3b47654ed3e8f..cf94e88bf8d05 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -827,7 +827,7 @@ static void submit_extent_page(struct btrfs_bio_ctrl *bio_ctrl,
 			       u64 disk_bytenr, struct page *page,
 			       size_t size, unsigned long pg_offset)
 {
-	struct btrfs_inode *inode = BTRFS_I(page->mapping->host);
+	struct btrfs_inode *inode = page_to_inode(page);
 
 	ASSERT(pg_offset + size <= PAGE_SIZE);
 	ASSERT(bio_ctrl->end_io_func);
@@ -1161,7 +1161,7 @@ static int btrfs_do_readpage(struct page *page, struct extent_map **em_cached,
 int btrfs_read_folio(struct file *file, struct folio *folio)
 {
 	struct page *page = &folio->page;
-	struct btrfs_inode *inode = BTRFS_I(page->mapping->host);
+	struct btrfs_inode *inode = page_to_inode(page);
 	u64 start = page_offset(page);
 	u64 end = start + PAGE_SIZE - 1;
 	struct btrfs_bio_ctrl bio_ctrl = { .opf = REQ_OP_READ };
@@ -1184,7 +1184,7 @@ static inline void contiguous_readpages(struct page *pages[], int nr_pages,
 					struct btrfs_bio_ctrl *bio_ctrl,
 					u64 *prev_em_start)
 {
-	struct btrfs_inode *inode = BTRFS_I(pages[0]->mapping->host);
+	struct btrfs_inode *inode = page_to_inode(pages[0]);
 	int index;
 
 	btrfs_lock_and_flush_ordered_range(inode, start, end, NULL);
@@ -2382,7 +2382,7 @@ int try_release_extent_mapping(struct page *page, gfp_t mask)
 	struct extent_map *em;
 	u64 start = page_offset(page);
 	u64 end = start + PAGE_SIZE - 1;
-	struct btrfs_inode *btrfs_inode = BTRFS_I(page->mapping->host);
+	struct btrfs_inode *btrfs_inode = page_to_inode(page);
 	struct extent_io_tree *tree = &btrfs_inode->io_tree;
 	struct extent_map_tree *map = &btrfs_inode->extent_tree;
 
diff --git a/fs/btrfs/fs.h b/fs/btrfs/fs.h
index f8bb73d6ab68c..1cfd16f956e77 100644
--- a/fs/btrfs/fs.h
+++ b/fs/btrfs/fs.h
@@ -829,6 +829,11 @@ struct btrfs_fs_info {
 #endif
 };
 
+#define page_to_inode(_page)	(BTRFS_I(_Generic((_page),			\
+					  struct page *: (_page))->mapping->host))
+#define folio_to_inode(_folio)	(BTRFS_I(_Generic((_folio),			\
+					  struct folio *: (_folio))->mapping->host))
+
 static inline u64 btrfs_get_fs_generation(const struct btrfs_fs_info *fs_info)
 {
 	return READ_ONCE(fs_info->generation);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index bd3f348d503dc..6948440286e55 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -7970,7 +7970,7 @@ static int btrfs_migrate_folio(struct address_space *mapping,
 static void btrfs_invalidate_folio(struct folio *folio, size_t offset,
 				 size_t length)
 {
-	struct btrfs_inode *inode = BTRFS_I(folio->mapping->host);
+	struct btrfs_inode *inode = folio_to_inode(folio);
 	struct btrfs_fs_info *fs_info = inode->root->fs_info;
 	struct extent_io_tree *tree = &inode->io_tree;
 	struct extent_state *cached_state = NULL;
-- 
2.43.0



