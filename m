Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1130623F417;
	Fri,  9 Jan 2026 12:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962981; cv=none; b=dZTu690XTwUaaE4h89ZHUmSnXPHeeDp4N6FPDnQ1Q9JLGB+Gj2Zedkuqrozchoi4kvdKqqYWcXZKN5uaPo3a9d7FgDy2F7UyL99pMbSopNmPpO9CODUGLM8SNuJ6nvub1yE3G2xibuv7LUuIHCy+h1RO2qM9iG5wLH6dfUk1iZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962981; c=relaxed/simple;
	bh=OxXooTu1sgZFdBcAif6OVF4oKjo4AHW48+4EvzpuhN8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OV/aBRW8KdrmIyCvY7Ns7/1i6FDCtPJiKLg75kir3t2reC9CgMe0rgTjxWgb3/zAsJuSPz+/X8zdhO7VJWB4FzbhRPjPIINDQLzhdFrTkbeDtzo1cU1foecVDWBBYXWRtTPLSnc/HvgI92c9x1BM9ujDY2AuHw7+MN9V5z9xZz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UFB/qG7b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UFB/qG7b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89289C4CEF1;
	Fri,  9 Jan 2026 12:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962980;
	bh=OxXooTu1sgZFdBcAif6OVF4oKjo4AHW48+4EvzpuhN8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UFB/qG7b0lxaAA2UB76EBndYn6FXfMO8OnFRlWmcNLAsEEAwbHD4mXq8+aYHLdXU8
	 9BTWbJE7d2yFHUUBFamCp3s58KY7vOaZZUjbu+jLZzLNGtL9H8rj1vItpD+wJujnZe
	 pwTvcog8cauFTWHS4KeXh8A+7Ggdzr3wQhdOtAws=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 554/634] f2fs: drop inode from the donation list when the last file is closed
Date: Fri,  9 Jan 2026 12:43:52 +0100
Message-ID: <20260109112138.441487402@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jaegeuk Kim <jaegeuk@kernel.org>

[ Upstream commit 078cad8212ce4f4ebbafcc0936475b8215e1ca2a ]

Let's drop the inode from the donation list when there is no other
open file.

Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Stable-dep-of: 10b591e7fb7c ("f2fs: fix to avoid updating compression context during writeback")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/f2fs.h  |    2 ++
 fs/f2fs/file.c  |    8 +++++++-
 fs/f2fs/inode.c |    2 +-
 fs/f2fs/super.c |    1 +
 4 files changed, 11 insertions(+), 2 deletions(-)

--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -824,6 +824,7 @@ struct f2fs_inode_info {
 	/* linked in global inode list for cache donation */
 	struct list_head gdonate_list;
 	pgoff_t donate_start, donate_end; /* inclusive */
+	atomic_t open_count;		/* # of open files */
 
 	struct task_struct *atomic_write_task;	/* store atomic write task */
 	struct extent_tree *extent_tree[NR_EXTENT_CACHES];
@@ -3473,6 +3474,7 @@ int f2fs_try_to_free_nats(struct f2fs_sb
 void f2fs_update_inode(struct inode *inode, struct page *node_page);
 void f2fs_update_inode_page(struct inode *inode);
 int f2fs_write_inode(struct inode *inode, struct writeback_control *wbc);
+void f2fs_remove_donate_inode(struct inode *inode);
 void f2fs_evict_inode(struct inode *inode);
 void f2fs_handle_failed_inode(struct inode *inode);
 
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -595,7 +595,10 @@ static int f2fs_file_open(struct inode *
 	if (err)
 		return err;
 
-	return finish_preallocate_blocks(inode);
+	err = finish_preallocate_blocks(inode);
+	if (!err)
+		atomic_inc(&F2FS_I(inode)->open_count);
+	return err;
 }
 
 void f2fs_truncate_data_blocks_range(struct dnode_of_data *dn, int count)
@@ -1923,6 +1926,9 @@ out:
 
 static int f2fs_release_file(struct inode *inode, struct file *filp)
 {
+	if (atomic_dec_and_test(&F2FS_I(inode)->open_count))
+		f2fs_remove_donate_inode(inode);
+
 	/*
 	 * f2fs_release_file is called at every close calls. So we should
 	 * not drop any inmemory pages by close called by other process.
--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -743,7 +743,7 @@ int f2fs_write_inode(struct inode *inode
 	return 0;
 }
 
-static void f2fs_remove_donate_inode(struct inode *inode)
+void f2fs_remove_donate_inode(struct inode *inode)
 {
 	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
 
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -1425,6 +1425,7 @@ static struct inode *f2fs_alloc_inode(st
 	/* Initialize f2fs-specific inode info */
 	atomic_set(&fi->dirty_pages, 0);
 	atomic_set(&fi->i_compr_blocks, 0);
+	atomic_set(&fi->open_count, 0);
 	init_f2fs_rwsem(&fi->i_sem);
 	spin_lock_init(&fi->i_size_lock);
 	INIT_LIST_HEAD(&fi->dirty_list);


