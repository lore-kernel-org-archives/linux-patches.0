Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0905E26296;
	Mon, 14 Oct 2024 15:02:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918166; cv=none; b=jFXnZxJ8sP39+4+j6w6LmUELiuhE94uOvnPMwCuC2MtW3JK9fJ99sgar0BexTo7QroYMlSg7uqrWw9RvRfAtkFRdAL/q+AakwmWMcK93qJggUzo/duXcB1+iRZz15F2lRonNKhpwnfsH7N30ye6dJbCO6xT7XDhLL+3BQECecRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918166; c=relaxed/simple;
	bh=KzZlNBDoIrt8kq1xBpe1Dj1fl7Q6Z2zNqYjMJvZXjz8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=om1M20aNz7jKChnikDWKs8DTnd6aKSYv6krtSm7UQxixU04ozlVDl8xyU4VjZfk5ON10MtLhf2D9StXR6NbJjNYXK808q1KstRs6ZR5PgnMn5/oQps1bfaPJ+yclkLeNB8R2k5e7YK2DgZuh7ATX/g12Q8XwJlEltYBxcsojwXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FhTOdqfK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FhTOdqfK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 648B3C4CEC3;
	Mon, 14 Oct 2024 15:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918165;
	bh=KzZlNBDoIrt8kq1xBpe1Dj1fl7Q6Z2zNqYjMJvZXjz8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FhTOdqfKqx+3KlQuA6C4Ndb5b58LuqZE4qSnv0nP+iqqbY2/R3g7IQYc/ukefMf6M
	 uBg5LC+CnXy8B1GiI3ph5wjMLzzP5+ISeDslaxuKvdFEaia1i6DhUIG0LmtzUjaFUy
	 +7Bh6DghaK3xaqvyaXWeuDPH2k0GUbQuNJwgF53Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+ebea2790904673d7c618@syzkaller.appspotmail.com,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 242/798] f2fs: get rid of online repaire on corrupted directory
Date: Mon, 14 Oct 2024 16:13:16 +0200
Message-ID: <20241014141227.424835256@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit 884ee6dc85b959bc152f15bca80c30f06069e6c4 ]

syzbot reports a f2fs bug as below:

kernel BUG at fs/f2fs/inode.c:896!
RIP: 0010:f2fs_evict_inode+0x1598/0x15c0 fs/f2fs/inode.c:896
Call Trace:
 evict+0x532/0x950 fs/inode.c:704
 dispose_list fs/inode.c:747 [inline]
 evict_inodes+0x5f9/0x690 fs/inode.c:797
 generic_shutdown_super+0x9d/0x2d0 fs/super.c:627
 kill_block_super+0x44/0x90 fs/super.c:1696
 kill_f2fs_super+0x344/0x690 fs/f2fs/super.c:4898
 deactivate_locked_super+0xc4/0x130 fs/super.c:473
 cleanup_mnt+0x41f/0x4b0 fs/namespace.c:1373
 task_work_run+0x24f/0x310 kernel/task_work.c:228
 ptrace_notify+0x2d2/0x380 kernel/signal.c:2402
 ptrace_report_syscall include/linux/ptrace.h:415 [inline]
 ptrace_report_syscall_exit include/linux/ptrace.h:477 [inline]
 syscall_exit_work+0xc6/0x190 kernel/entry/common.c:173
 syscall_exit_to_user_mode_prepare kernel/entry/common.c:200 [inline]
 __syscall_exit_to_user_mode_work kernel/entry/common.c:205 [inline]
 syscall_exit_to_user_mode+0x279/0x370 kernel/entry/common.c:218
 do_syscall_64+0x100/0x230 arch/x86/entry/common.c:89
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0010:f2fs_evict_inode+0x1598/0x15c0 fs/f2fs/inode.c:896

Online repaire on corrupted directory in f2fs_lookup() can generate
dirty data/meta while racing w/ readonly remount, it may leave dirty
inode after filesystem becomes readonly, however, checkpoint() will
skips flushing dirty inode in a state of readonly mode, result in
above panic.

Let's get rid of online repaire in f2fs_lookup(), and leave the work
to fsck.f2fs.

Fixes: 510022a85839 ("f2fs: add F2FS_INLINE_DOTS to recover missing dot dentries")
Reported-by: syzbot+ebea2790904673d7c618@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/000000000000a7b20f061ff2d56a@google.com
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/f2fs.h          | 11 -------
 fs/f2fs/namei.c         | 68 -----------------------------------------
 include/linux/f2fs_fs.h |  2 +-
 3 files changed, 1 insertion(+), 80 deletions(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index dc637dfb1ead2..4ec6621c5fd92 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -771,7 +771,6 @@ enum {
 	FI_NEED_IPU,		/* used for ipu per file */
 	FI_ATOMIC_FILE,		/* indicate atomic file */
 	FI_DATA_EXIST,		/* indicate data exists */
-	FI_INLINE_DOTS,		/* indicate inline dot dentries */
 	FI_SKIP_WRITES,		/* should skip data page writeback */
 	FI_OPU_WRITE,		/* used for opu per file */
 	FI_DIRTY_FILE,		/* indicate regular/symlink has dirty pages */
@@ -3000,7 +2999,6 @@ static inline void __mark_inode_dirty_flag(struct inode *inode,
 			return;
 		fallthrough;
 	case FI_DATA_EXIST:
-	case FI_INLINE_DOTS:
 	case FI_PIN_FILE:
 	case FI_COMPRESS_RELEASED:
 	case FI_ATOMIC_COMMITTED:
@@ -3125,8 +3123,6 @@ static inline void get_inline_info(struct inode *inode, struct f2fs_inode *ri)
 		set_bit(FI_INLINE_DENTRY, fi->flags);
 	if (ri->i_inline & F2FS_DATA_EXIST)
 		set_bit(FI_DATA_EXIST, fi->flags);
-	if (ri->i_inline & F2FS_INLINE_DOTS)
-		set_bit(FI_INLINE_DOTS, fi->flags);
 	if (ri->i_inline & F2FS_EXTRA_ATTR)
 		set_bit(FI_EXTRA_ATTR, fi->flags);
 	if (ri->i_inline & F2FS_PIN_FILE)
@@ -3147,8 +3143,6 @@ static inline void set_raw_inline(struct inode *inode, struct f2fs_inode *ri)
 		ri->i_inline |= F2FS_INLINE_DENTRY;
 	if (is_inode_flag_set(inode, FI_DATA_EXIST))
 		ri->i_inline |= F2FS_DATA_EXIST;
-	if (is_inode_flag_set(inode, FI_INLINE_DOTS))
-		ri->i_inline |= F2FS_INLINE_DOTS;
 	if (is_inode_flag_set(inode, FI_EXTRA_ATTR))
 		ri->i_inline |= F2FS_EXTRA_ATTR;
 	if (is_inode_flag_set(inode, FI_PIN_FILE))
@@ -3235,11 +3229,6 @@ static inline int f2fs_exist_data(struct inode *inode)
 	return is_inode_flag_set(inode, FI_DATA_EXIST);
 }
 
-static inline int f2fs_has_inline_dots(struct inode *inode)
-{
-	return is_inode_flag_set(inode, FI_INLINE_DOTS);
-}
-
 static inline int f2fs_is_mmap_file(struct inode *inode)
 {
 	return is_inode_flag_set(inode, FI_MMAP_FILE);
diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
index cd66584bed0fd..9da104c0743c4 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -445,62 +445,6 @@ struct dentry *f2fs_get_parent(struct dentry *child)
 	return d_obtain_alias(f2fs_iget(child->d_sb, ino));
 }
 
-static int __recover_dot_dentries(struct inode *dir, nid_t pino)
-{
-	struct f2fs_sb_info *sbi = F2FS_I_SB(dir);
-	struct qstr dot = QSTR_INIT(".", 1);
-	struct f2fs_dir_entry *de;
-	struct page *page;
-	int err = 0;
-
-	if (f2fs_readonly(sbi->sb)) {
-		f2fs_info(sbi, "skip recovering inline_dots inode (ino:%lu, pino:%u) in readonly mountpoint",
-			  dir->i_ino, pino);
-		return 0;
-	}
-
-	if (!S_ISDIR(dir->i_mode)) {
-		f2fs_err(sbi, "inconsistent inode status, skip recovering inline_dots inode (ino:%lu, i_mode:%u, pino:%u)",
-			  dir->i_ino, dir->i_mode, pino);
-		set_sbi_flag(sbi, SBI_NEED_FSCK);
-		return -ENOTDIR;
-	}
-
-	err = f2fs_dquot_initialize(dir);
-	if (err)
-		return err;
-
-	f2fs_balance_fs(sbi, true);
-
-	f2fs_lock_op(sbi);
-
-	de = f2fs_find_entry(dir, &dot, &page);
-	if (de) {
-		f2fs_put_page(page, 0);
-	} else if (IS_ERR(page)) {
-		err = PTR_ERR(page);
-		goto out;
-	} else {
-		err = f2fs_do_add_link(dir, &dot, NULL, dir->i_ino, S_IFDIR);
-		if (err)
-			goto out;
-	}
-
-	de = f2fs_find_entry(dir, &dotdot_name, &page);
-	if (de)
-		f2fs_put_page(page, 0);
-	else if (IS_ERR(page))
-		err = PTR_ERR(page);
-	else
-		err = f2fs_do_add_link(dir, &dotdot_name, NULL, pino, S_IFDIR);
-out:
-	if (!err)
-		clear_inode_flag(dir, FI_INLINE_DOTS);
-
-	f2fs_unlock_op(sbi);
-	return err;
-}
-
 static struct dentry *f2fs_lookup(struct inode *dir, struct dentry *dentry,
 		unsigned int flags)
 {
@@ -510,7 +454,6 @@ static struct dentry *f2fs_lookup(struct inode *dir, struct dentry *dentry,
 	struct dentry *new;
 	nid_t ino = -1;
 	int err = 0;
-	unsigned int root_ino = F2FS_ROOT_INO(F2FS_I_SB(dir));
 	struct f2fs_filename fname;
 
 	trace_f2fs_lookup_start(dir, dentry, flags);
@@ -547,17 +490,6 @@ static struct dentry *f2fs_lookup(struct inode *dir, struct dentry *dentry,
 		goto out;
 	}
 
-	if ((dir->i_ino == root_ino) && f2fs_has_inline_dots(dir)) {
-		err = __recover_dot_dentries(dir, root_ino);
-		if (err)
-			goto out_iput;
-	}
-
-	if (f2fs_has_inline_dots(inode)) {
-		err = __recover_dot_dentries(inode, dir->i_ino);
-		if (err)
-			goto out_iput;
-	}
 	if (IS_ENCRYPTED(dir) &&
 	    (S_ISDIR(inode->i_mode) || S_ISLNK(inode->i_mode)) &&
 	    !fscrypt_has_permitted_context(dir, inode)) {
diff --git a/include/linux/f2fs_fs.h b/include/linux/f2fs_fs.h
index 1e0df607e40c4..c61d8fc1deb3e 100644
--- a/include/linux/f2fs_fs.h
+++ b/include/linux/f2fs_fs.h
@@ -264,7 +264,7 @@ struct f2fs_extent {
 #define F2FS_INLINE_DATA	0x02	/* file inline data flag */
 #define F2FS_INLINE_DENTRY	0x04	/* file inline dentry flag */
 #define F2FS_DATA_EXIST		0x08	/* file inline data exist flag */
-#define F2FS_INLINE_DOTS	0x10	/* file having implicit dot dentries */
+#define F2FS_INLINE_DOTS	0x10	/* file having implicit dot dentries (obsolete) */
 #define F2FS_EXTRA_ATTR		0x20	/* file having extra attribute */
 #define F2FS_PIN_FILE		0x40	/* file should not be gced */
 #define F2FS_COMPRESS_RELEASED	0x80	/* file released compressed blocks */
-- 
2.43.0



