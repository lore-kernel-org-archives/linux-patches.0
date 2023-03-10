Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B71578481
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:06:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E3B7C433EF;
	Fri, 10 Mar 2023 14:06:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678457197;
	bh=g9InTsGkJbiAN5lVrdDqYy8CLaVfcwr1FVWKXnMIIA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nVtGLlq9SO4BwAwfIfwtk/krwM8sU8xPI1ZHB6/sAIP03SuOAawdkeXiNE0rKxT5m
	 DA3idE0J97D26zhlxQXBRFq0K+vE27mGFkKqXoVazFnfWjgDu9QflpvUWSEKsgPRb4
	 uMCv/jKugaX5V6sYp6gb3N9LpVQFSnbX5tY2hoG8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+823000d23b3400619f7c@syzkaller.appspotmail.com,
	Daeho Jeong <daehojeong@google.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 053/200] f2fs: synchronize atomic write aborts
Date: Fri, 10 Mar 2023 14:37:40 +0100
Message-Id: <20230310133718.743917087@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133717.050159289@linuxfoundation.org>
References: <20230310133717.050159289@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Daeho Jeong <daehojeong@google.com>

[ Upstream commit a46bebd502fe1a3bd1d22f64cedd93e7e7702693 ]

To fix a race condition between atomic write aborts, I use the inode
lock and make COW inode to be re-usable thoroughout the whole
atomic file inode lifetime.

Reported-by: syzbot+823000d23b3400619f7c@syzkaller.appspotmail.com
Fixes: 3db1de0e582c ("f2fs: change the current atomic write way")
Signed-off-by: Daeho Jeong <daehojeong@google.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/file.c    | 44 +++++++++++++++++++++++++++++---------------
 fs/f2fs/inode.c   | 11 +++++++++--
 fs/f2fs/segment.c |  3 ---
 fs/f2fs/super.c   |  2 --
 4 files changed, 38 insertions(+), 22 deletions(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 8a576c004b72a..773b3ddc2cd72 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -1865,7 +1865,10 @@ static int f2fs_release_file(struct inode *inode, struct file *filp)
 			atomic_read(&inode->i_writecount) != 1)
 		return 0;
 
+	inode_lock(inode);
 	f2fs_abort_atomic_write(inode, true);
+	inode_unlock(inode);
+
 	return 0;
 }
 
@@ -1880,8 +1883,12 @@ static int f2fs_file_flush(struct file *file, fl_owner_t id)
 	 * before dropping file lock, it needs to do in ->flush.
 	 */
 	if (F2FS_I(inode)->atomic_write_task == current &&
-				(current->flags & PF_EXITING))
+				(current->flags & PF_EXITING)) {
+		inode_lock(inode);
 		f2fs_abort_atomic_write(inode, true);
+		inode_unlock(inode);
+	}
+
 	return 0;
 }
 
@@ -2087,19 +2094,28 @@ static int f2fs_ioc_start_atomic_write(struct file *filp)
 		goto out;
 	}
 
-	/* Create a COW inode for atomic write */
-	pinode = f2fs_iget(inode->i_sb, fi->i_pino);
-	if (IS_ERR(pinode)) {
-		f2fs_up_write(&fi->i_gc_rwsem[WRITE]);
-		ret = PTR_ERR(pinode);
-		goto out;
-	}
+	/* Check if the inode already has a COW inode */
+	if (fi->cow_inode == NULL) {
+		/* Create a COW inode for atomic write */
+		pinode = f2fs_iget(inode->i_sb, fi->i_pino);
+		if (IS_ERR(pinode)) {
+			f2fs_up_write(&fi->i_gc_rwsem[WRITE]);
+			ret = PTR_ERR(pinode);
+			goto out;
+		}
 
-	ret = f2fs_get_tmpfile(mnt_userns, pinode, &fi->cow_inode);
-	iput(pinode);
-	if (ret) {
-		f2fs_up_write(&fi->i_gc_rwsem[WRITE]);
-		goto out;
+		ret = f2fs_get_tmpfile(mnt_userns, pinode, &fi->cow_inode);
+		iput(pinode);
+		if (ret) {
+			f2fs_up_write(&fi->i_gc_rwsem[WRITE]);
+			goto out;
+		}
+
+		set_inode_flag(fi->cow_inode, FI_COW_FILE);
+		clear_inode_flag(fi->cow_inode, FI_INLINE_DATA);
+	} else {
+		/* Reuse the already created COW inode */
+		f2fs_do_truncate_blocks(fi->cow_inode, 0, true);
 	}
 
 	f2fs_write_inode(inode, NULL);
@@ -2111,8 +2127,6 @@ static int f2fs_ioc_start_atomic_write(struct file *filp)
 	stat_inc_atomic_inode(inode);
 
 	set_inode_flag(inode, FI_ATOMIC_FILE);
-	set_inode_flag(fi->cow_inode, FI_COW_FILE);
-	clear_inode_flag(fi->cow_inode, FI_INLINE_DATA);
 	f2fs_up_write(&fi->i_gc_rwsem[WRITE]);
 
 	f2fs_update_time(sbi, REQ_TIME);
diff --git a/fs/f2fs/inode.c b/fs/f2fs/inode.c
index e8413b080e0a7..229ddc2f7b079 100644
--- a/fs/f2fs/inode.c
+++ b/fs/f2fs/inode.c
@@ -764,11 +764,18 @@ int f2fs_write_inode(struct inode *inode, struct writeback_control *wbc)
 void f2fs_evict_inode(struct inode *inode)
 {
 	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
-	nid_t xnid = F2FS_I(inode)->i_xattr_nid;
+	struct f2fs_inode_info *fi = F2FS_I(inode);
+	nid_t xnid = fi->i_xattr_nid;
 	int err = 0;
 
 	f2fs_abort_atomic_write(inode, true);
 
+	if (fi->cow_inode) {
+		clear_inode_flag(fi->cow_inode, FI_COW_FILE);
+		iput(fi->cow_inode);
+		fi->cow_inode = NULL;
+	}
+
 	trace_f2fs_evict_inode(inode);
 	truncate_inode_pages_final(&inode->i_data);
 
@@ -855,7 +862,7 @@ void f2fs_evict_inode(struct inode *inode)
 	stat_dec_inline_inode(inode);
 	stat_dec_compr_inode(inode);
 	stat_sub_compr_blocks(inode,
-			atomic_read(&F2FS_I(inode)->i_compr_blocks));
+			atomic_read(&fi->i_compr_blocks));
 
 	if (likely(!f2fs_cp_error(sbi) &&
 				!is_sbi_flag_set(sbi, SBI_CP_DISABLED)))
diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 63c6894099799..8d1e8c537daf0 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -192,9 +192,6 @@ void f2fs_abort_atomic_write(struct inode *inode, bool clean)
 	if (!f2fs_is_atomic_file(inode))
 		return;
 
-	clear_inode_flag(fi->cow_inode, FI_COW_FILE);
-	iput(fi->cow_inode);
-	fi->cow_inode = NULL;
 	release_atomic_write_cnt(inode);
 	clear_inode_flag(inode, FI_ATOMIC_COMMITTED);
 	clear_inode_flag(inode, FI_ATOMIC_FILE);
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index eaabb85cb4ddb..14c87399efea2 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -1416,8 +1416,6 @@ static int f2fs_drop_inode(struct inode *inode)
 			atomic_inc(&inode->i_count);
 			spin_unlock(&inode->i_lock);
 
-			f2fs_abort_atomic_write(inode, true);
-
 			/* should remain fi->extent_tree for writepage */
 			f2fs_destroy_extent_node(inode);
 
-- 
2.39.2



