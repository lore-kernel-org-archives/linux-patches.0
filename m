Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A7728F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:21:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92117C433C7;
	Sun, 16 Jul 2023 20:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689538890;
	bh=HHTOsYWhoGpBSzfPfgcOq5LUyZPm2PblHSIIFFK1/RE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d1Y181JzQVppHWlaVNq3kPGg3753K6iDJOLvqlSvWM9B4Vt+UtRg7j/Rvlo9zyXp0
	 zKrhr/dOGlttSLKBJ8wfgl25OYdN55E3iKApPjKpcYQIV85xFjk7OVygYCe/6fkqaX
	 +5SeZBzlaoJ9TV18T6slHSECu+XLbeMtH0KjO0dU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 612/800] f2fs: fix potential deadlock due to unpaired node_write lock use
Date: Sun, 16 Jul 2023 21:47:45 +0200
Message-ID: <20230716195003.324850694@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chao Yu <chao@kernel.org>

[ Upstream commit f082c6b205a06953f26c40bdc7621cc5a58ceb7c ]

If S_NOQUOTA is cleared from inode during data page writeback of quota
file, it may miss to unlock node_write lock, result in potential
deadlock, fix to use the lock in paired.

Kworker					Thread
- writepage
 if (IS_NOQUOTA())
   f2fs_down_read(&sbi->node_write);
					- vfs_cleanup_quota_inode
					 - inode->i_flags &= ~S_NOQUOTA;
 if (IS_NOQUOTA())
   f2fs_up_read(&sbi->node_write);

Fixes: 79963d967b49 ("f2fs: shrink node_write lock coverage")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/compress.c | 7 ++++---
 fs/f2fs/data.c     | 7 ++++---
 2 files changed, 8 insertions(+), 6 deletions(-)

diff --git a/fs/f2fs/compress.c b/fs/f2fs/compress.c
index 11653fa792897..2ec7cf4544180 100644
--- a/fs/f2fs/compress.c
+++ b/fs/f2fs/compress.c
@@ -1215,6 +1215,7 @@ static int f2fs_write_compressed_pages(struct compress_ctx *cc,
 	unsigned int last_index = cc->cluster_size - 1;
 	loff_t psize;
 	int i, err;
+	bool quota_inode = IS_NOQUOTA(inode);
 
 	/* we should bypass data pages to proceed the kworker jobs */
 	if (unlikely(f2fs_cp_error(sbi))) {
@@ -1222,7 +1223,7 @@ static int f2fs_write_compressed_pages(struct compress_ctx *cc,
 		goto out_free;
 	}
 
-	if (IS_NOQUOTA(inode)) {
+	if (quota_inode) {
 		/*
 		 * We need to wait for node_write to avoid block allocation during
 		 * checkpoint. This can only happen to quota writes which can cause
@@ -1344,7 +1345,7 @@ static int f2fs_write_compressed_pages(struct compress_ctx *cc,
 		set_inode_flag(inode, FI_FIRST_BLOCK_WRITTEN);
 
 	f2fs_put_dnode(&dn);
-	if (IS_NOQUOTA(inode))
+	if (quota_inode)
 		f2fs_up_read(&sbi->node_write);
 	else
 		f2fs_unlock_op(sbi);
@@ -1370,7 +1371,7 @@ static int f2fs_write_compressed_pages(struct compress_ctx *cc,
 out_put_dnode:
 	f2fs_put_dnode(&dn);
 out_unlock_op:
-	if (IS_NOQUOTA(inode))
+	if (quota_inode)
 		f2fs_up_read(&sbi->node_write);
 	else
 		f2fs_unlock_op(sbi);
diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 7165b1202f539..4a0ee9cc43b5d 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -2775,6 +2775,7 @@ int f2fs_write_single_data_page(struct page *page, int *submitted,
 	loff_t psize = (loff_t)(page->index + 1) << PAGE_SHIFT;
 	unsigned offset = 0;
 	bool need_balance_fs = false;
+	bool quota_inode = IS_NOQUOTA(inode);
 	int err = 0;
 	struct f2fs_io_info fio = {
 		.sbi = sbi,
@@ -2832,19 +2833,19 @@ int f2fs_write_single_data_page(struct page *page, int *submitted,
 		goto out;
 
 	/* Dentry/quota blocks are controlled by checkpoint */
-	if (S_ISDIR(inode->i_mode) || IS_NOQUOTA(inode)) {
+	if (S_ISDIR(inode->i_mode) || quota_inode) {
 		/*
 		 * We need to wait for node_write to avoid block allocation during
 		 * checkpoint. This can only happen to quota writes which can cause
 		 * the below discard race condition.
 		 */
-		if (IS_NOQUOTA(inode))
+		if (quota_inode)
 			f2fs_down_read(&sbi->node_write);
 
 		fio.need_lock = LOCK_DONE;
 		err = f2fs_do_write_data_page(&fio);
 
-		if (IS_NOQUOTA(inode))
+		if (quota_inode)
 			f2fs_up_read(&sbi->node_write);
 
 		goto done;
-- 
2.39.2



