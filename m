Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68A893019D8;
	Sat, 12 Sep 2026 14:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224248; cv=none; b=F5bQG27f9to6yazqxulnj6bWCJ+kXaRmJxtWl7qyoWbrvwfS4mDyo1EQLi2zUaUJvEtwHUBNW7dxej1mMA1RNUVzzBrjnZeydj5PlfU31PHC73wB44XqJzMU3uthP1OTdyFWfuukq8ghonhejNtQFvBHGOw+aMW+BTfUYyFpG8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224248; c=relaxed/simple;
	bh=jyi2Q1DyFI5OblghfhNvACrnEBt+oWVfN4n2S2maXto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mFyGijLnzPaR38O7b5gWmYJef/xLbOSXV8zaInraS+HE6zCE/FHnJYC4ANLYcGfUwLHSLeXnJZ0TGxqxmss/Gx9XZtDIcmGfmCi0mFUumQObvLovpZa+DMRIAR0T8RRuRrzGZ6qhv3pOx4TlUQcY3nHvDdwvNN9pmTvYxKL12nc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JHGqbB8Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JHGqbB8Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14B0B1F000FF;
	Sat, 12 Sep 2026 14:44:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224247;
	bh=vtX3GG9G0wgkd19M6wR1wjkENKem8qyEi8ULqJxQVYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JHGqbB8ZK1cVqZO4pXWXZU4Yu8x+5vMcPTZUTVEprE4FAcCEOIhpFEiUW7Lv53YkM
	 O+d1bJQW/UpHBs3tWXz4pVH85J7RC0/lpovgz1BsO9TDjMLWNEYmmacfyzsardcPR+
	 m+nCYkwF+WPfjDyHS3kOq+RRn1H1Q2+5iKUH0QkM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0912/1424] nilfs2: convert nilfs_page_bug() to nilfs_folio_bug()
Date: Sat, 12 Sep 2026 08:55:44 +0200
Message-ID: <20260912065627.749293270@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

[ Upstream commit b4f19e3bce903712e347ce7f88d0c4f6e43277f9 ]

All callers have a folio now, so convert it.

Link: https://lkml.kernel.org/r/20231127143036.2425-18-konishi.ryusuke@gmail.com
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 66f4ad3ce158 ("nilfs2: fix BUG in nilfs_copy_dirty_pages() on dirty state mismatch")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nilfs2/btnode.c |  4 ++--
 fs/nilfs2/page.c   | 25 +++++++++++++------------
 fs/nilfs2/page.h   |  6 +++---
 3 files changed, 18 insertions(+), 17 deletions(-)

diff --git a/fs/nilfs2/btnode.c b/fs/nilfs2/btnode.c
index 26873a02a7481..2573939dde266 100644
--- a/fs/nilfs2/btnode.c
+++ b/fs/nilfs2/btnode.c
@@ -204,7 +204,7 @@ int nilfs_btnode_prepare_change_key(struct address_space *btnc,
 retry:
 		/* BUG_ON(oldkey != obh->b_folio->index); */
 		if (unlikely(oldkey != ofolio->index))
-			NILFS_PAGE_BUG(&ofolio->page,
+			NILFS_FOLIO_BUG(ofolio,
 				       "invalid oldkey %lld (newkey=%lld)",
 				       (unsigned long long)oldkey,
 				       (unsigned long long)newkey);
@@ -260,7 +260,7 @@ void nilfs_btnode_commit_change_key(struct address_space *btnc,
 	if (nbh == NULL) {	/* blocksize == pagesize */
 		ofolio = obh->b_folio;
 		if (unlikely(oldkey != ofolio->index))
-			NILFS_PAGE_BUG(&ofolio->page,
+			NILFS_FOLIO_BUG(ofolio,
 				       "invalid oldkey %lld (newkey=%lld)",
 				       (unsigned long long)oldkey,
 				       (unsigned long long)newkey);
diff --git a/fs/nilfs2/page.c b/fs/nilfs2/page.c
index d9a34f5010622..06204110ae1f2 100644
--- a/fs/nilfs2/page.c
+++ b/fs/nilfs2/page.c
@@ -151,29 +151,30 @@ bool nilfs_folio_buffers_clean(struct folio *folio)
 	return true;
 }
 
-void nilfs_page_bug(struct page *page)
+void nilfs_folio_bug(struct folio *folio)
 {
+	struct buffer_head *bh, *head;
 	struct address_space *m;
 	unsigned long ino;
 
-	if (unlikely(!page)) {
-		printk(KERN_CRIT "NILFS_PAGE_BUG(NULL)\n");
+	if (unlikely(!folio)) {
+		printk(KERN_CRIT "NILFS_FOLIO_BUG(NULL)\n");
 		return;
 	}
 
-	m = page->mapping;
+	m = folio->mapping;
 	ino = m ? m->host->i_ino : 0;
 
-	printk(KERN_CRIT "NILFS_PAGE_BUG(%p): cnt=%d index#=%llu flags=0x%lx "
+	printk(KERN_CRIT "NILFS_FOLIO_BUG(%p): cnt=%d index#=%llu flags=0x%lx "
 	       "mapping=%p ino=%lu\n",
-	       page, page_ref_count(page),
-	       (unsigned long long)page->index, page->flags, m, ino);
+	       folio, folio_ref_count(folio),
+	       (unsigned long long)folio->index, folio->flags, m, ino);
 
-	if (page_has_buffers(page)) {
-		struct buffer_head *bh, *head;
+	head = folio_buffers(folio);
+	if (head) {
 		int i = 0;
 
-		bh = head = page_buffers(page);
+		bh = head;
 		do {
 			printk(KERN_CRIT
 			       " BH[%d] %p: cnt=%d block#=%llu state=0x%lx\n",
@@ -257,7 +258,7 @@ int nilfs_copy_dirty_pages(struct address_space *dmap,
 
 		folio_lock(folio);
 		if (unlikely(!folio_test_dirty(folio)))
-			NILFS_PAGE_BUG(&folio->page, "inconsistent dirty state");
+			NILFS_FOLIO_BUG(folio, "inconsistent dirty state");
 
 		dfolio = filemap_grab_folio(dmap, folio->index);
 		if (unlikely(IS_ERR(dfolio))) {
@@ -267,7 +268,7 @@ int nilfs_copy_dirty_pages(struct address_space *dmap,
 			break;
 		}
 		if (unlikely(!folio_buffers(folio)))
-			NILFS_PAGE_BUG(&folio->page,
+			NILFS_FOLIO_BUG(folio,
 				       "found empty page in dat page cache");
 
 		nilfs_copy_page(&dfolio->page, &folio->page, 1);
diff --git a/fs/nilfs2/page.h b/fs/nilfs2/page.h
index 69e03ff2e8695..bff6257ef83bd 100644
--- a/fs/nilfs2/page.h
+++ b/fs/nilfs2/page.h
@@ -37,7 +37,7 @@ struct buffer_head *nilfs_grab_buffer(struct inode *, struct address_space *,
 void nilfs_forget_buffer(struct buffer_head *);
 void nilfs_copy_buffer(struct buffer_head *, struct buffer_head *);
 bool nilfs_folio_buffers_clean(struct folio *);
-void nilfs_page_bug(struct page *);
+void nilfs_folio_bug(struct folio *);
 
 int nilfs_copy_dirty_pages(struct address_space *, struct address_space *);
 void nilfs_copy_back_pages(struct address_space *, struct address_space *);
@@ -49,8 +49,8 @@ unsigned long nilfs_find_uncommitted_extent(struct inode *inode,
 					    sector_t start_blk,
 					    sector_t *blkoff);
 
-#define NILFS_PAGE_BUG(page, m, a...) \
-	do { nilfs_page_bug(page); BUG(); } while (0)
+#define NILFS_FOLIO_BUG(folio, m, a...) \
+	do { nilfs_folio_bug(folio); BUG(); } while (0)
 
 static inline struct buffer_head *
 nilfs_page_get_nth_block(struct page *page, unsigned int count)
-- 
2.53.0



