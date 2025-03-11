Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0535F25D8FF;
	Tue, 11 Mar 2025 15:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705956; cv=none; b=qVgDpU56j0LkuyjiFGsa426mgT6MbbLjdtdCidze2FVfD/SJALnJxnoJFwwzgVJVyQ2R7VDYEEVNeXvILCKoQDdSGYu3UoTeHsH1IDEHgYkK1ir7nvUfrEwaJDU1YRmbxK8cqhabR4osnYh4lmSrLv86d0E9g+H1zxo8ifYO9pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705956; c=relaxed/simple;
	bh=LzPLA1d8+Q63HIDDDP3m3EKRk5HLJ6bU5gBcw9k34VI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YLycaFWt49PbT8wLMHxFl0GQpDTUk1KotTrPFx9HuHq5ald2HYHgJ5HsXPnpHfzSkwMd6467Q/2RGi5DT9JdCweOg4CU2/msvVwtKC/OsWdMTThHnuPnVOxgOeP5BiFV1wFoVqiUav+F+24kmUJHDplRv57pA0Z6Y9jlGkjfEjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CKE0fn6e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CKE0fn6e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29337C4CEE9;
	Tue, 11 Mar 2025 15:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705955;
	bh=LzPLA1d8+Q63HIDDDP3m3EKRk5HLJ6bU5gBcw9k34VI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CKE0fn6eLs7EYD8QvKNFkNajwoEwrVckR75ebHpNWWr/4tUdkF1WVC5YWpEcpwMyz
	 GoHxgArxaQhOvPmyLBzgEeSImKYU2du4ld1v4F30ouuzBS6Ok1kFOrD2j1W0IG/A+4
	 4N/yzKswab5lkta1d4niU5IxxQqVvi3eg0vtmx7U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>
Subject: [PATCH 5.4 213/328] nilfs2: do not output warnings when clearing dirty buffers
Date: Tue, 11 Mar 2025 15:59:43 +0100
Message-ID: <20250311145723.368638487@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryusuke Konishi <konishi.ryusuke@gmail.com>

commit 299910dcb4525ac0274f3efa9527876315ba4f67 upstream.

After detecting file system corruption and degrading to a read-only mount,
dirty folios and buffers in the page cache are cleared, and a large number
of warnings are output at that time, often filling up the kernel log.

In this case, since the degrading to a read-only mount is output to the
kernel log, these warnings are not very meaningful, and are rather a
nuisance in system management and debugging.

The related nilfs2-specific page/folio routines have a silent argument
that suppresses the warning output, but since it is not currently used
meaningfully, remove both the silent argument and the warning output.

[konishi.ryusuke@gmail.com: adjusted for page/folio conversion]
Link: https://lkml.kernel.org/r/20240816090128.4561-1-konishi.ryusuke@gmail.com
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: ca76bb226bf4 ("nilfs2: do not force clear folio if buffer is referenced")
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nilfs2/inode.c |    4 ++--
 fs/nilfs2/mdt.c   |    6 +++---
 fs/nilfs2/page.c  |   20 +++-----------------
 fs/nilfs2/page.h  |    4 ++--
 4 files changed, 10 insertions(+), 24 deletions(-)

--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -170,7 +170,7 @@ static int nilfs_writepages(struct addre
 	int err = 0;
 
 	if (sb_rdonly(inode->i_sb)) {
-		nilfs_clear_dirty_pages(mapping, false);
+		nilfs_clear_dirty_pages(mapping);
 		return -EROFS;
 	}
 
@@ -193,7 +193,7 @@ static int nilfs_writepage(struct page *
 		 * have dirty pages that try to be flushed in background.
 		 * So, here we simply discard this dirty page.
 		 */
-		nilfs_clear_dirty_page(page, false);
+		nilfs_clear_dirty_page(page);
 		unlock_page(page);
 		return -EROFS;
 	}
--- a/fs/nilfs2/mdt.c
+++ b/fs/nilfs2/mdt.c
@@ -410,7 +410,7 @@ nilfs_mdt_write_page(struct page *page,
 		 * have dirty pages that try to be flushed in background.
 		 * So, here we simply discard this dirty page.
 		 */
-		nilfs_clear_dirty_page(page, false);
+		nilfs_clear_dirty_page(page);
 		unlock_page(page);
 		return -EROFS;
 	}
@@ -631,10 +631,10 @@ void nilfs_mdt_restore_from_shadow_map(s
 	if (mi->mi_palloc_cache)
 		nilfs_palloc_clear_cache(inode);
 
-	nilfs_clear_dirty_pages(inode->i_mapping, true);
+	nilfs_clear_dirty_pages(inode->i_mapping);
 	nilfs_copy_back_pages(inode->i_mapping, shadow->inode->i_mapping);
 
-	nilfs_clear_dirty_pages(ii->i_assoc_inode->i_mapping, true);
+	nilfs_clear_dirty_pages(ii->i_assoc_inode->i_mapping);
 	nilfs_copy_back_pages(ii->i_assoc_inode->i_mapping,
 			      NILFS_I(shadow->inode)->i_assoc_inode->i_mapping);
 
--- a/fs/nilfs2/page.c
+++ b/fs/nilfs2/page.c
@@ -355,9 +355,8 @@ repeat:
 /**
  * nilfs_clear_dirty_pages - discard dirty pages in address space
  * @mapping: address space with dirty pages for discarding
- * @silent: suppress [true] or print [false] warning messages
  */
-void nilfs_clear_dirty_pages(struct address_space *mapping, bool silent)
+void nilfs_clear_dirty_pages(struct address_space *mapping)
 {
 	struct pagevec pvec;
 	unsigned int i;
@@ -378,7 +377,7 @@ void nilfs_clear_dirty_pages(struct addr
 			 * was acquired.  Skip processing in that case.
 			 */
 			if (likely(page->mapping == mapping))
-				nilfs_clear_dirty_page(page, silent);
+				nilfs_clear_dirty_page(page);
 
 			unlock_page(page);
 		}
@@ -390,19 +389,11 @@ void nilfs_clear_dirty_pages(struct addr
 /**
  * nilfs_clear_dirty_page - discard dirty page
  * @page: dirty page that will be discarded
- * @silent: suppress [true] or print [false] warning messages
  */
-void nilfs_clear_dirty_page(struct page *page, bool silent)
+void nilfs_clear_dirty_page(struct page *page)
 {
-	struct inode *inode = page->mapping->host;
-	struct super_block *sb = inode->i_sb;
-
 	BUG_ON(!PageLocked(page));
 
-	if (!silent)
-		nilfs_warn(sb, "discard dirty page: offset=%lld, ino=%lu",
-			   page_offset(page), inode->i_ino);
-
 	ClearPageUptodate(page);
 	ClearPageMappedToDisk(page);
 	ClearPageChecked(page);
@@ -418,11 +409,6 @@ void nilfs_clear_dirty_page(struct page
 		bh = head = page_buffers(page);
 		do {
 			lock_buffer(bh);
-			if (!silent)
-				nilfs_warn(sb,
-					   "discard dirty block: blocknr=%llu, size=%zu",
-					   (u64)bh->b_blocknr, bh->b_size);
-
 			set_mask_bits(&bh->b_state, clear_bits, 0);
 			unlock_buffer(bh);
 		} while (bh = bh->b_this_page, bh != head);
--- a/fs/nilfs2/page.h
+++ b/fs/nilfs2/page.h
@@ -41,8 +41,8 @@ void nilfs_page_bug(struct page *);
 
 int nilfs_copy_dirty_pages(struct address_space *, struct address_space *);
 void nilfs_copy_back_pages(struct address_space *, struct address_space *);
-void nilfs_clear_dirty_page(struct page *, bool);
-void nilfs_clear_dirty_pages(struct address_space *, bool);
+void nilfs_clear_dirty_page(struct page *page);
+void nilfs_clear_dirty_pages(struct address_space *mapping);
 void nilfs_mapping_init(struct address_space *mapping, struct inode *inode);
 unsigned int nilfs_page_count_clean_buffers(struct page *, unsigned int,
 					    unsigned int);


