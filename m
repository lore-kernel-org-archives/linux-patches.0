Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46E731D0BAC;
	Wed,  2 Oct 2024 14:13:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878388; cv=none; b=g1PgKgFqATxEN9nGrSobsjSV9KdBtI+8g2GkO7tJEQR8nvu+Jcr6OXPqcb/ei+kwkBfyu0AlAWhwcLsRnFvP5xw1a9+0qX5KccSWTejuGRTZJWWntfPpWyzrKnBTgPF/SUIrTjN79+8FE6lhsQMvxXf5IHHqI+WR5Z5S4uKto5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878388; c=relaxed/simple;
	bh=okDspFFL/i3jOw8knnIY46Y3/PjmJkxXBhCv2A9MdiE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p4SBopaJdw4JF3MWr8dGnywBZesryRl0qyDKbwqOx2x60QQYm9hVHqGf6ADXW0znlJsLHvUE/x3k5xKNvRu2P7SXvru7yJrgl9v3lJeUNkRZLkCK1bctETHhTBQFuqA3nIFm+rjzLRnNHHa6UdWNRsuoyis9MdF/za09D+SDRZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LQ6HRKld; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LQ6HRKld"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C50EFC4CEC2;
	Wed,  2 Oct 2024 14:13:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878388;
	bh=okDspFFL/i3jOw8knnIY46Y3/PjmJkxXBhCv2A9MdiE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LQ6HRKldJomHrY5hMKn79Fmvr7FaRBt9KN+ZVtKpCzhNySOhJ0bCdmNFyw7MfFBwH
	 AG6/v0YFP6DcwPpdDkWUxfyMk/fq73zNPEyMe+kKs9yqezSP4Es5wZStYk4Payk2Q0
	 fxupYXhIcEbFJcuGoClM52qnh0w0/a0SNwXEyjaA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daeho Jeong <daehojeong@google.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 396/634] f2fs: atomic: fix to avoid racing w/ GC
Date: Wed,  2 Oct 2024 14:58:16 +0200
Message-ID: <20241002125826.734887308@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit 1a0bd289a5db1df8df8fab949633a0b8d3f235ee ]

Case #1:
SQLite App		GC Thread		Kworker		Shrinker
- f2fs_ioc_start_atomic_write

- f2fs_ioc_commit_atomic_write
 - f2fs_commit_atomic_write
  - filemap_write_and_wait_range
  : write atomic_file's data to cow_inode
								echo 3 > drop_caches
								to drop atomic_file's
								cache.
			- f2fs_gc
			 - gc_data_segment
			  - move_data_page
			   - set_page_dirty

						- writepages
						 - f2fs_do_write_data_page
						 : overwrite atomic_file's data
						   to cow_inode
  - f2fs_down_write(&fi->i_gc_rwsem[WRITE])
  - __f2fs_commit_atomic_write
  - f2fs_up_write(&fi->i_gc_rwsem[WRITE])

Case #2:
SQLite App		GC Thread		Kworker
- f2fs_ioc_start_atomic_write

						- __writeback_single_inode
						 - do_writepages
						  - f2fs_write_cache_pages
						   - f2fs_write_single_data_page
						    - f2fs_do_write_data_page
						    : write atomic_file's data to cow_inode
			- f2fs_gc
			 - gc_data_segment
			  - move_data_page
			   - set_page_dirty

						- writepages
						 - f2fs_do_write_data_page
						 : overwrite atomic_file's data to cow_inode
- f2fs_ioc_commit_atomic_write

In above cases racing in between atomic_write and GC, previous
data in atomic_file may be overwrited to cow_file, result in
data corruption.

This patch introduces PAGE_PRIVATE_ATOMIC_WRITE bit flag in page.private,
and use it to indicate that there is last dirty data in atomic file,
and the data should be writebacked into cow_file, if the flag is not
tagged in page, we should never write data across files.

Fixes: 3db1de0e582c ("f2fs: change the current atomic write way")
Cc: Daeho Jeong <daehojeong@google.com>
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/data.c | 10 +++++++++-
 fs/f2fs/f2fs.h |  8 +++++++-
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 467f67cf2b380..825f6bcb7fc2e 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -2645,10 +2645,13 @@ int f2fs_do_write_data_page(struct f2fs_io_info *fio)
 	struct dnode_of_data dn;
 	struct node_info ni;
 	bool ipu_force = false;
+	bool atomic_commit;
 	int err = 0;
 
 	/* Use COW inode to make dnode_of_data for atomic write */
-	if (f2fs_is_atomic_file(inode))
+	atomic_commit = f2fs_is_atomic_file(inode) &&
+				page_private_atomic(fio->page);
+	if (atomic_commit)
 		set_new_dnode(&dn, F2FS_I(inode)->cow_inode, NULL, NULL, 0);
 	else
 		set_new_dnode(&dn, inode, NULL, NULL, 0);
@@ -2747,6 +2750,8 @@ int f2fs_do_write_data_page(struct f2fs_io_info *fio)
 	f2fs_outplace_write_data(&dn, fio);
 	trace_f2fs_do_write_data_page(page_folio(page), OPU);
 	set_inode_flag(inode, FI_APPEND_WRITE);
+	if (atomic_commit)
+		clear_page_private_atomic(page);
 out_writepage:
 	f2fs_put_dnode(&dn);
 out:
@@ -3716,6 +3721,9 @@ static int f2fs_write_end(struct file *file,
 
 	set_page_dirty(page);
 
+	if (f2fs_is_atomic_file(inode))
+		set_page_private_atomic(page);
+
 	if (pos + copied > i_size_read(inode) &&
 	    !f2fs_verity_in_progress(inode)) {
 		f2fs_i_size_write(inode, pos + copied);
diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index 92fda31c68cdc..ba2b9f2db10e6 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -1418,7 +1418,8 @@ static inline void f2fs_clear_bit(unsigned int nr, char *addr);
  * bit 1	PAGE_PRIVATE_ONGOING_MIGRATION
  * bit 2	PAGE_PRIVATE_INLINE_INODE
  * bit 3	PAGE_PRIVATE_REF_RESOURCE
- * bit 4-	f2fs private data
+ * bit 4	PAGE_PRIVATE_ATOMIC_WRITE
+ * bit 5-	f2fs private data
  *
  * Layout B: lowest bit should be 0
  * page.private is a wrapped pointer.
@@ -1428,6 +1429,7 @@ enum {
 	PAGE_PRIVATE_ONGOING_MIGRATION,		/* data page which is on-going migrating */
 	PAGE_PRIVATE_INLINE_INODE,		/* inode page contains inline data */
 	PAGE_PRIVATE_REF_RESOURCE,		/* dirty page has referenced resources */
+	PAGE_PRIVATE_ATOMIC_WRITE,		/* data page from atomic write path */
 	PAGE_PRIVATE_MAX
 };
 
@@ -2396,14 +2398,17 @@ static inline void clear_page_private_##name(struct page *page) \
 PAGE_PRIVATE_GET_FUNC(nonpointer, NOT_POINTER);
 PAGE_PRIVATE_GET_FUNC(inline, INLINE_INODE);
 PAGE_PRIVATE_GET_FUNC(gcing, ONGOING_MIGRATION);
+PAGE_PRIVATE_GET_FUNC(atomic, ATOMIC_WRITE);
 
 PAGE_PRIVATE_SET_FUNC(reference, REF_RESOURCE);
 PAGE_PRIVATE_SET_FUNC(inline, INLINE_INODE);
 PAGE_PRIVATE_SET_FUNC(gcing, ONGOING_MIGRATION);
+PAGE_PRIVATE_SET_FUNC(atomic, ATOMIC_WRITE);
 
 PAGE_PRIVATE_CLEAR_FUNC(reference, REF_RESOURCE);
 PAGE_PRIVATE_CLEAR_FUNC(inline, INLINE_INODE);
 PAGE_PRIVATE_CLEAR_FUNC(gcing, ONGOING_MIGRATION);
+PAGE_PRIVATE_CLEAR_FUNC(atomic, ATOMIC_WRITE);
 
 static inline unsigned long get_page_private_data(struct page *page)
 {
@@ -2435,6 +2440,7 @@ static inline void clear_page_private_all(struct page *page)
 	clear_page_private_reference(page);
 	clear_page_private_gcing(page);
 	clear_page_private_inline(page);
+	clear_page_private_atomic(page);
 
 	f2fs_bug_on(F2FS_P_SB(page), page_private(page));
 }
-- 
2.43.0



