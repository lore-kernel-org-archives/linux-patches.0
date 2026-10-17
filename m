Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5267B35E93B;
	Sat, 17 Oct 2026 17:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258531; cv=none; b=LAoK9aRP4/L/SbA4YelVrwnX+w6il/QQGbasJ1in9pIDIzMMttmnPdi6KjqPwTFEeMBbMpdrquOO7QzvWmJFatb0OORw6hQFR1lJ8P3SJMng95K2dnrouDUBysHWefjLRbPnmUmNLhMd2s31U0U8kuzyL4VCfGk0FpmxFLat20Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258531; c=relaxed/simple;
	bh=MXM/Aj54Wu5bf9BEkMQO9u+5i8Zhw05GxtgEMEK3QXU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NKeLLkIUS1KMFoRWBofwI6BrTxhLC9pmZD0jODikGz+YJdlH/6pIwvX37+CVf0cnE8646CCamaXpJzndZxnWb4omTw0xxKndOiBCnsjIMzoVdV/0IYkT4Xp3WFM0qGnjKQJYryDJAEpchDekg5q7XwYBplehqczrAjFQel8GpX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W6xOUxbf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W6xOUxbf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DE5D1F000C4;
	Sat, 17 Oct 2026 17:35:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258530;
	bh=X+LMjIteq7vS6UJv1QqJMfMgzRAjnN5cYA/UGKHQ74A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W6xOUxbfFKdbAQdZBSVHMNIc9/gmKM1lAgNv24cLgg6kaz0moCtVErxwNotcUo8ms
	 K2yUSVSkMmzi6nz/lYJU5qSmXz/es1lBZ+BpBJzTHjhZlaR2P8dCGN9y4Tn2+/jdtp
	 D2hnDIYsWZwI+9fEN0GxYgQ5KATnGdi5eeWGay/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0914/1674] btrfs: convert to new timestamp accessors
Date: Sat, 17 Oct 2026 17:53:06 +0200
Message-ID: <20261017160454.594642725@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit b1c38a1338c90597c7af66985a9e31152ae8cfd3 ]

Convert to using the new inode timestamp accessor functions.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
Link: https://lore.kernel.org/r/20231004185347.80880-21-jlayton@kernel.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: 5254d4181add ("btrfs: fix zero size inode with non-zero size after log replay")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/delayed-inode.c | 20 ++++++++---------
 fs/btrfs/file.c          | 18 ++++++++-------
 fs/btrfs/inode.c         | 47 ++++++++++++++++++++--------------------
 fs/btrfs/reflink.c       |  2 +-
 fs/btrfs/transaction.c   |  3 ++-
 fs/btrfs/tree-log.c      | 12 +++++-----
 6 files changed, 52 insertions(+), 50 deletions(-)

diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
index c39e39142abf1..4fde25d02298f 100644
--- a/fs/btrfs/delayed-inode.c
+++ b/fs/btrfs/delayed-inode.c
@@ -1835,19 +1835,19 @@ static void fill_stack_inode_item(struct btrfs_trans_handle *trans,
 	btrfs_set_stack_inode_block_group(inode_item, 0);
 
 	btrfs_set_stack_timespec_sec(&inode_item->atime,
-				     inode->i_atime.tv_sec);
+				     inode_get_atime_sec(inode));
 	btrfs_set_stack_timespec_nsec(&inode_item->atime,
-				      inode->i_atime.tv_nsec);
+				      inode_get_atime_nsec(inode));
 
 	btrfs_set_stack_timespec_sec(&inode_item->mtime,
-				     inode->i_mtime.tv_sec);
+				     inode_get_mtime_sec(inode));
 	btrfs_set_stack_timespec_nsec(&inode_item->mtime,
-				      inode->i_mtime.tv_nsec);
+				      inode_get_mtime_nsec(inode));
 
 	btrfs_set_stack_timespec_sec(&inode_item->ctime,
-				     inode_get_ctime(inode).tv_sec);
+				     inode_get_ctime_sec(inode));
 	btrfs_set_stack_timespec_nsec(&inode_item->ctime,
-				      inode_get_ctime(inode).tv_nsec);
+				      inode_get_ctime_nsec(inode));
 
 	btrfs_set_stack_timespec_sec(&inode_item->otime, BTRFS_I(inode)->i_otime_sec);
 	btrfs_set_stack_timespec_nsec(&inode_item->otime, BTRFS_I(inode)->i_otime_nsec);
@@ -1890,11 +1890,11 @@ int btrfs_fill_inode(struct inode *inode, u32 *rdev)
 	btrfs_inode_split_flags(btrfs_stack_inode_flags(inode_item),
 				&BTRFS_I(inode)->flags, &BTRFS_I(inode)->ro_flags);
 
-	inode->i_atime.tv_sec = btrfs_stack_timespec_sec(&inode_item->atime);
-	inode->i_atime.tv_nsec = btrfs_stack_timespec_nsec(&inode_item->atime);
+	inode_set_atime(inode, btrfs_stack_timespec_sec(&inode_item->atime),
+			btrfs_stack_timespec_nsec(&inode_item->atime));
 
-	inode->i_mtime.tv_sec = btrfs_stack_timespec_sec(&inode_item->mtime);
-	inode->i_mtime.tv_nsec = btrfs_stack_timespec_nsec(&inode_item->mtime);
+	inode_set_mtime(inode, btrfs_stack_timespec_sec(&inode_item->mtime),
+			btrfs_stack_timespec_nsec(&inode_item->mtime));
 
 	inode_set_ctime(inode, btrfs_stack_timespec_sec(&inode_item->ctime),
 			btrfs_stack_timespec_nsec(&inode_item->ctime));
diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 7db2344a748cf..4211194c18cf1 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1100,17 +1100,18 @@ void btrfs_check_nocow_unlock(struct btrfs_inode *inode)
 
 static void update_time_for_write(struct inode *inode)
 {
-	struct timespec64 now, ctime;
+	struct timespec64 now, ts;
 
 	if (IS_NOCMTIME(inode))
 		return;
 
 	now = current_time(inode);
-	if (!timespec64_equal(&inode->i_mtime, &now))
-		inode->i_mtime = now;
+	ts = inode_get_mtime(inode);
+	if (!timespec64_equal(&ts, &now))
+		inode_set_mtime_to_ts(inode, now);
 
-	ctime = inode_get_ctime(inode);
-	if (!timespec64_equal(&ctime, &now))
+	ts = inode_get_ctime(inode);
+	if (!timespec64_equal(&ts, &now))
 		inode_set_ctime_to_ts(inode, now);
 
 	if (IS_I_VERSION(inode))
@@ -2511,7 +2512,8 @@ int btrfs_replace_file_extents(struct btrfs_inode *inode,
 		inode_inc_iversion(&inode->vfs_inode);
 
 		if (!extent_info || extent_info->update_times)
-			inode->vfs_inode.i_mtime = inode_set_ctime_current(&inode->vfs_inode);
+			inode_set_mtime_to_ts(&inode->vfs_inode,
+					      inode_set_ctime_current(&inode->vfs_inode));
 
 		ret = btrfs_update_inode(trans, inode);
 		if (unlikely(ret)) {
@@ -2754,7 +2756,7 @@ static int btrfs_punch_hole(struct file *file, loff_t offset, loff_t len)
 
 	ASSERT(trans != NULL);
 	inode_inc_iversion(inode);
-	inode->i_mtime = inode_set_ctime_current(inode);
+	inode_set_mtime_to_ts(inode, inode_set_ctime_current(inode));
 	ret = btrfs_update_inode(trans, BTRFS_I(inode));
 	updated_inode = true;
 	btrfs_end_transaction(trans);
@@ -2774,7 +2776,7 @@ static int btrfs_punch_hole(struct file *file, loff_t offset, loff_t len)
 		struct timespec64 now = inode_set_ctime_current(inode);
 
 		inode_inc_iversion(inode);
-		inode->i_mtime = now;
+		inode_set_mtime_to_ts(inode, now);
 		trans = btrfs_start_transaction(root, 1);
 		if (IS_ERR(trans)) {
 			ret = PTR_ERR(trans);
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 8945e35a1f3a2..ea41ded4c6843 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -3938,11 +3938,11 @@ static int btrfs_read_locked_inode(struct inode *inode,
 	btrfs_inode_set_file_extent_range(BTRFS_I(inode), 0,
 			round_up(i_size_read(inode), fs_info->sectorsize));
 
-	inode->i_atime.tv_sec = btrfs_timespec_sec(leaf, &inode_item->atime);
-	inode->i_atime.tv_nsec = btrfs_timespec_nsec(leaf, &inode_item->atime);
+	inode_set_atime(inode, btrfs_timespec_sec(leaf, &inode_item->atime),
+			btrfs_timespec_nsec(leaf, &inode_item->atime));
 
-	inode->i_mtime.tv_sec = btrfs_timespec_sec(leaf, &inode_item->mtime);
-	inode->i_mtime.tv_nsec = btrfs_timespec_nsec(leaf, &inode_item->mtime);
+	inode_set_mtime(inode, btrfs_timespec_sec(leaf, &inode_item->mtime),
+			btrfs_timespec_nsec(leaf, &inode_item->mtime));
 
 	inode_set_ctime(inode, btrfs_timespec_sec(leaf, &inode_item->ctime),
 			btrfs_timespec_nsec(leaf, &inode_item->ctime));
@@ -4104,19 +4104,19 @@ static void fill_inode_item(struct btrfs_trans_handle *trans,
 	btrfs_set_token_inode_nlink(&token, item, inode->i_nlink);
 
 	btrfs_set_token_timespec_sec(&token, &item->atime,
-				     inode->i_atime.tv_sec);
+				     inode_get_atime_sec(inode));
 	btrfs_set_token_timespec_nsec(&token, &item->atime,
-				      inode->i_atime.tv_nsec);
+				      inode_get_atime_nsec(inode));
 
 	btrfs_set_token_timespec_sec(&token, &item->mtime,
-				     inode->i_mtime.tv_sec);
+				     inode_get_mtime_sec(inode));
 	btrfs_set_token_timespec_nsec(&token, &item->mtime,
-				      inode->i_mtime.tv_nsec);
+				      inode_get_mtime_nsec(inode));
 
 	btrfs_set_token_timespec_sec(&token, &item->ctime,
-				     inode_get_ctime(inode).tv_sec);
+				     inode_get_ctime_sec(inode));
 	btrfs_set_token_timespec_nsec(&token, &item->ctime,
-				      inode_get_ctime(inode).tv_nsec);
+				      inode_get_ctime_nsec(inode));
 
 	btrfs_set_token_timespec_sec(&token, &item->otime, BTRFS_I(inode)->i_otime_sec);
 	btrfs_set_token_timespec_nsec(&token, &item->otime, BTRFS_I(inode)->i_otime_nsec);
@@ -4313,8 +4313,7 @@ static int __btrfs_unlink_inode(struct btrfs_trans_handle *trans,
 	inode_inc_iversion(&inode->vfs_inode);
 	inode_set_ctime_current(&inode->vfs_inode);
 	inode_inc_iversion(&dir->vfs_inode);
-	inode_set_ctime_current(&inode->vfs_inode);
-	dir->vfs_inode.i_mtime = inode_set_ctime_current(&dir->vfs_inode);
+	inode_set_mtime_to_ts(&dir->vfs_inode, inode_set_ctime_current(&dir->vfs_inode));
 	ret = btrfs_update_inode(trans, dir);
 out:
 	return ret;
@@ -4484,7 +4483,7 @@ static int btrfs_unlink_subvol(struct btrfs_trans_handle *trans,
 
 	btrfs_i_size_write(dir, dir->vfs_inode.i_size - fname.disk_name.len * 2);
 	inode_inc_iversion(&dir->vfs_inode);
-	dir->vfs_inode.i_mtime = inode_set_ctime_current(&dir->vfs_inode);
+	inode_set_mtime_to_ts(&dir->vfs_inode, inode_set_ctime_current(&dir->vfs_inode));
 	ret = btrfs_update_inode_fallback(trans, dir);
 	if (ret)
 		btrfs_abort_transaction(trans, ret);
@@ -5153,7 +5152,8 @@ static int btrfs_setsize(struct inode *inode, struct iattr *attr)
 	if (newsize != oldsize) {
 		inode_inc_iversion(inode);
 		if (!(mask & (ATTR_CTIME | ATTR_MTIME))) {
-			inode->i_mtime = inode_set_ctime_current(inode);
+			inode_set_mtime_to_ts(inode,
+					      inode_set_ctime_current(inode));
 		}
 	}
 
@@ -5797,10 +5797,10 @@ static struct inode *new_simple_dir(struct inode *dir,
 	inode->i_opflags &= ~IOP_XATTR;
 	inode->i_fop = &simple_dir_operations;
 	inode->i_mode = S_IFDIR | S_IRUGO | S_IWUSR | S_IXUGO;
-	inode->i_mtime = inode_set_ctime_current(inode);
-	inode->i_atime = dir->i_atime;
-	BTRFS_I(inode)->i_otime_sec = inode->i_mtime.tv_sec;
-	BTRFS_I(inode)->i_otime_nsec = inode->i_mtime.tv_nsec;
+	inode_set_mtime_to_ts(inode, inode_set_ctime_current(inode));
+	inode_set_atime_to_ts(inode, inode_get_atime(dir));
+	BTRFS_I(inode)->i_otime_sec = inode_get_mtime_sec(inode);
+	BTRFS_I(inode)->i_otime_nsec = inode_get_mtime_nsec(inode);
 	inode->i_uid = dir->i_uid;
 	inode->i_gid = dir->i_gid;
 
@@ -6494,10 +6494,9 @@ int btrfs_create_new_inode(struct btrfs_trans_handle *trans,
 		goto discard;
 	}
 
-	inode->i_mtime = inode_set_ctime_current(inode);
-	inode->i_atime = inode->i_mtime;
-	BTRFS_I(inode)->i_otime_sec = inode->i_mtime.tv_sec;
-	BTRFS_I(inode)->i_otime_nsec = inode->i_mtime.tv_nsec;
+	simple_inode_init_ts(inode);
+	BTRFS_I(inode)->i_otime_sec = inode_get_mtime_sec(inode);
+	BTRFS_I(inode)->i_otime_nsec = inode_get_mtime_nsec(inode);
 
 	/*
 	 * We're going to fill the inode item now, so at this point the inode
@@ -6662,8 +6661,8 @@ int btrfs_add_link(struct btrfs_trans_handle *trans,
 	 * values (the ones it had when the fsync was done).
 	 */
 	if (!test_bit(BTRFS_FS_LOG_RECOVERING, &root->fs_info->flags))
-		parent_inode->vfs_inode.i_mtime =
-			inode_set_ctime_current(&parent_inode->vfs_inode);
+		inode_set_mtime_to_ts(&parent_inode->vfs_inode,
+				      inode_set_ctime_current(&parent_inode->vfs_inode));
 
 	ret = btrfs_update_inode(trans, parent_inode);
 	if (ret)
diff --git a/fs/btrfs/reflink.c b/fs/btrfs/reflink.c
index 60e78c446b38b..0a919f76ee00a 100644
--- a/fs/btrfs/reflink.c
+++ b/fs/btrfs/reflink.c
@@ -29,7 +29,7 @@ static int clone_finish_inode_update(struct btrfs_trans_handle *trans,
 
 	inode_inc_iversion(inode);
 	if (!no_time_update) {
-		inode->i_mtime = inode_set_ctime_current(inode);
+		inode_set_mtime_to_ts(inode, inode_set_ctime_current(inode));
 	}
 	/*
 	 * We round up to the block size at eof when determining which
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 6dce8c299d699..5e7b8d47c3c87 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1878,7 +1878,8 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 
 	btrfs_i_size_write(BTRFS_I(parent_inode), parent_inode->i_size +
 						  fname.disk_name.len * 2);
-	parent_inode->i_mtime = inode_set_ctime_current(parent_inode);
+	inode_set_mtime_to_ts(parent_inode,
+			      inode_set_ctime_current(parent_inode));
 	ret = btrfs_update_inode_fallback(trans, BTRFS_I(parent_inode));
 	if (ret) {
 		btrfs_abort_transaction(trans, ret);
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index 642d35816a61b..7f8544c426518 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -4277,19 +4277,19 @@ static void fill_inode_item(struct btrfs_trans_handle *trans,
 	btrfs_set_token_inode_nlink(&token, item, inode->i_nlink);
 
 	btrfs_set_token_timespec_sec(&token, &item->atime,
-				     inode->i_atime.tv_sec);
+				     inode_get_atime_sec(inode));
 	btrfs_set_token_timespec_nsec(&token, &item->atime,
-				      inode->i_atime.tv_nsec);
+				      inode_get_atime_nsec(inode));
 
 	btrfs_set_token_timespec_sec(&token, &item->mtime,
-				     inode->i_mtime.tv_sec);
+				     inode_get_mtime_sec(inode));
 	btrfs_set_token_timespec_nsec(&token, &item->mtime,
-				      inode->i_mtime.tv_nsec);
+				      inode_get_mtime_nsec(inode));
 
 	btrfs_set_token_timespec_sec(&token, &item->ctime,
-				     inode_get_ctime(inode).tv_sec);
+				     inode_get_ctime_sec(inode));
 	btrfs_set_token_timespec_nsec(&token, &item->ctime,
-				      inode_get_ctime(inode).tv_nsec);
+				      inode_get_ctime_nsec(inode));
 
 	btrfs_set_timespec_sec(leaf, &item->otime, BTRFS_I(inode)->i_otime_sec);
 	btrfs_set_timespec_nsec(leaf, &item->otime, BTRFS_I(inode)->i_otime_nsec);
-- 
2.53.0



