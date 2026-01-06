Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5F72345724;
	Tue,  6 Jan 2026 17:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721411; cv=none; b=MsZl/s868uVBU4FYjaTRdbITdi/8C8+WmH3j6uNryFf0/35X8nmQRN6a9WNBRUs0DK4ZZIulHUJwkqypLJxiIpbITJ9s1RBJe9eZgej73HSB/qhg7qeszkkUAFabumXBoA1WeLepZeCNxvDiavMfgsMYBFFKlin/wDUI+a7+Gr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721411; c=relaxed/simple;
	bh=TI3qlYumQxX9nf4o28aDjuCb7LrtNuSplXXwAO9lbvg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J0AVo/fUiW/fbhdX8uGzCUcc05eayMx8PRnjf3ufeTM2r2SGmATFdU5ZxybAKzLmv8WMvmmDAw/GpXfqxaplBO9kIFCzLesu/35FDNUDD+XPvN91BckW7fXH5fbwCuIGU7+roui6uq6e4e0QmhJgVbrJf3KyquHgc3m4fcariGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l765eRcb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l765eRcb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55EE6C2BC9E;
	Tue,  6 Jan 2026 17:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721410;
	bh=TI3qlYumQxX9nf4o28aDjuCb7LrtNuSplXXwAO9lbvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l765eRcb/frhQaZYjhghpIFX19oHuz9+zeu1eEX+94O1SbXL3msUDDzIxm3GxQfX9
	 Ijhl2l478r8tkWGIIrsunqHAS2n8n06SpT0MYjn4xRAxRhQ2xqbp/fFCx//7ULU/aM
	 LePYCDf1K5BUDw6Gsaaimk7GviIjaVZeEnFhBUDU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 496/567] f2fs: drop inode from the donation list when the last file is closed
Date: Tue,  6 Jan 2026 18:04:38 +0100
Message-ID: <20260106170509.712417819@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -859,6 +859,7 @@ struct f2fs_inode_info {
 	/* linked in global inode list for cache donation */
 	struct list_head gdonate_list;
 	pgoff_t donate_start, donate_end; /* inclusive */
+	atomic_t open_count;		/* # of open files */
 
 	struct task_struct *atomic_write_task;	/* store atomic write task */
 	struct extent_tree *extent_tree[NR_EXTENT_CACHES];
@@ -3600,6 +3601,7 @@ int f2fs_try_to_free_nats(struct f2fs_sb
 void f2fs_update_inode(struct inode *inode, struct page *node_page);
 void f2fs_update_inode_page(struct inode *inode);
 int f2fs_write_inode(struct inode *inode, struct writeback_control *wbc);
+void f2fs_remove_donate_inode(struct inode *inode);
 void f2fs_evict_inode(struct inode *inode);
 void f2fs_handle_failed_inode(struct inode *inode);
 
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -631,7 +631,10 @@ static int f2fs_file_open(struct inode *
 	if (err)
 		return err;
 
-	return finish_preallocate_blocks(inode);
+	err = finish_preallocate_blocks(inode);
+	if (!err)
+		atomic_inc(&F2FS_I(inode)->open_count);
+	return err;
 }
 
 void f2fs_truncate_data_blocks_range(struct dnode_of_data *dn, int count)
@@ -1992,6 +1995,9 @@ out:
 
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
@@ -807,7 +807,7 @@ int f2fs_write_inode(struct inode *inode
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


