Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3647359FA0;
	Fri,  9 Jan 2026 12:20:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961244; cv=none; b=rEjjOgMzVzDdNj0UeTU9HxFdF/vonKS/vsAtAXknrO/0NEpinW/B+YbnbSCuNaANdaM4vnlxcJRkRlxbKaQFKHcmjWHepiL1RLDINgx9zOpS5zfDw2Q5at+EcETCHOnyH/C8NQ8yREyYSyaVa4UIIGwH72Imjredtow3kGmc134=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961244; c=relaxed/simple;
	bh=hA7wW4jOOmBt5CQdXgVoIWhS2rakVyuvko09btGdnoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oOjA+MtrWBcpZJ+FKZg2DFRKn+gole6WSTnhCQFmgiVc+sc+KswjQEMslObzah1C+hLQi+CJqtnF2236ayGvLEvfVzxj3TYi0BWut/fLLhXJAuvvdB36hHGboWT02vw8F/OaIGlrDd3Zb4pZS09Nq8V5OYsgm4mkOIzYRObduiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FJ+939V7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FJ+939V7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6386EC4CEF1;
	Fri,  9 Jan 2026 12:20:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961244;
	bh=hA7wW4jOOmBt5CQdXgVoIWhS2rakVyuvko09btGdnoM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FJ+939V7of8T35hpC7Qk7s2/vWjpl4bc0b+XDp6T5cbcYinWqQYslR9tfZZwASP/m
	 0aX1MJ3DsvdkhaAZZreC0TZgn4KTcF+pMZuXL6Z6bNm4hWKFAwjv2v7zk2OraX+Amq
	 HGc4zIUsvVC2B1/Xzeors8Uz5tM8zYlH9x0q7gYQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 686/737] f2fs: drop inode from the donation list when the last file is closed
Date: Fri,  9 Jan 2026 12:43:45 +0100
Message-ID: <20260109112159.865479823@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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
@@ -841,6 +841,7 @@ struct f2fs_inode_info {
 	/* linked in global inode list for cache donation */
 	struct list_head gdonate_list;
 	pgoff_t donate_start, donate_end; /* inclusive */
+	atomic_t open_count;		/* # of open files */
 
 	struct task_struct *atomic_write_task;	/* store atomic write task */
 	struct extent_tree *extent_tree[NR_EXTENT_CACHES];
@@ -3560,6 +3561,7 @@ int f2fs_try_to_free_nats(struct f2fs_sb
 void f2fs_update_inode(struct inode *inode, struct page *node_page);
 void f2fs_update_inode_page(struct inode *inode);
 int f2fs_write_inode(struct inode *inode, struct writeback_control *wbc);
+void f2fs_remove_donate_inode(struct inode *inode);
 void f2fs_evict_inode(struct inode *inode);
 void f2fs_handle_failed_inode(struct inode *inode);
 
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -621,7 +621,10 @@ static int f2fs_file_open(struct inode *
 	if (err)
 		return err;
 
-	return finish_preallocate_blocks(inode);
+	err = finish_preallocate_blocks(inode);
+	if (!err)
+		atomic_inc(&F2FS_I(inode)->open_count);
+	return err;
 }
 
 void f2fs_truncate_data_blocks_range(struct dnode_of_data *dn, int count)
@@ -1966,6 +1969,9 @@ out:
 
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
@@ -811,7 +811,7 @@ int f2fs_write_inode(struct inode *inode
 	return 0;
 }
 
-static void f2fs_remove_donate_inode(struct inode *inode)
+void f2fs_remove_donate_inode(struct inode *inode)
 {
 	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
 
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -1409,6 +1409,7 @@ static struct inode *f2fs_alloc_inode(st
 	/* Initialize f2fs-specific inode info */
 	atomic_set(&fi->dirty_pages, 0);
 	atomic_set(&fi->i_compr_blocks, 0);
+	atomic_set(&fi->open_count, 0);
 	init_f2fs_rwsem(&fi->i_sem);
 	spin_lock_init(&fi->i_size_lock);
 	INIT_LIST_HEAD(&fi->dirty_list);


