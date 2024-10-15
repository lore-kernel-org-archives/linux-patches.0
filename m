Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E48F1C07E5;
	Tue, 15 Oct 2024 13:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997465; cv=none; b=iIpADoBpR/nzm095kAlm6P3siSYPSlV+rRm/8TEqNNhvJFkLmBCkqQlI4rd0CYG0nR6iTldWrR/dk8XZW+Dp1QqCb42gcIB9GHTOui3S12UIqoEU71GJr1Z1qkq6igxBqRrmT08v/GMVU09d2qRW1cjBRP2jjKrrM4nUnmzf3Q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997465; c=relaxed/simple;
	bh=9CdNgYT49eSdyGG4S628KNpIsgjx/D26eC+EWFEw5z0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=soEE0N1+A8pZPhPY+22dmaAZeNVpeQ8LGN2jD1jqQO6TwSWMFrYW6PlVhgVpIE9jO5x1DJrO04NG3wzkLypMI1BDQ4v8I5ZWY8dJxjKvHQHXGACqwn/DcEea5+nbyKhV26WxgaxPgN+1RrI42cHFHHiZawJIStcQtvSuqd3EkSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A/Qi9pZV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A/Qi9pZV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79ED5C4CEC6;
	Tue, 15 Oct 2024 13:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997465;
	bh=9CdNgYT49eSdyGG4S628KNpIsgjx/D26eC+EWFEw5z0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A/Qi9pZVi6d3Zb/Yi2XYQcfiy83JZ/8xoigFTTdMbmHfN6PUDxyuBfHlUtGDTwWan
	 n0jcqE8U0ayGUqNWQ+eUnrq2ZWxYRY4Lt6DGtHbRxmpW9kY0mQ5ULbRf7Uiee9D0NC
	 PITldhv5icMmf19tquEx8NWh9a9TqZlfBCeRTmJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	wangzijie <wangzijie1@honor.com>,
	Zhiguo Niu <zhiguo.niu@unisoc.com>,
	Yunlei He <heyunlei@hihonor.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 190/518] f2fs: reduce expensive checkpoint trigger frequency
Date: Tue, 15 Oct 2024 14:41:34 +0200
Message-ID: <20241015123924.317100139@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit aaf8c0b9ae042494cb4585883b15c1332de77840 ]

We may trigger high frequent checkpoint for below case:
1. mkdir /mnt/dir1; set dir1 encrypted
2. touch /mnt/file1; fsync /mnt/file1
3. mkdir /mnt/dir2; set dir2 encrypted
4. touch /mnt/file2; fsync /mnt/file2
...

Although, newly created dir and file are not related, due to
commit bbf156f7afa7 ("f2fs: fix lost xattrs of directories"), we will
trigger checkpoint whenever fsync() comes after a new encrypted dir
created.

In order to avoid such performance regression issue, let's record an
entry including directory's ino in global cache whenever we update
directory's xattr data, and then triggerring checkpoint() only if
xattr metadata of target file's parent was updated.

This patch updates to cover below no encryption case as well:
1) parent is checkpointed
2) set_xattr(dir) w/ new xnid
3) create(file)
4) fsync(file)

Fixes: bbf156f7afa7 ("f2fs: fix lost xattrs of directories")
Reported-by: wangzijie <wangzijie1@honor.com>
Reported-by: Zhiguo Niu <zhiguo.niu@unisoc.com>
Tested-by: Zhiguo Niu <zhiguo.niu@unisoc.com>
Reported-by: Yunlei He <heyunlei@hihonor.com>
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/f2fs.h              |  2 ++
 fs/f2fs/file.c              |  3 +++
 fs/f2fs/xattr.c             | 14 ++++++++++++--
 include/trace/events/f2fs.h |  3 ++-
 4 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index a858a1f7f53d0..3da7be53a3de4 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -250,6 +250,7 @@ enum {
 	APPEND_INO,		/* for append ino list */
 	UPDATE_INO,		/* for update ino list */
 	TRANS_DIR_INO,		/* for transactions dir ino list */
+	XATTR_DIR_INO,		/* for xattr updated dir ino list */
 	FLUSH_INO,		/* for multiple device flushing */
 	MAX_INO_ENTRY,		/* max. list */
 };
@@ -1070,6 +1071,7 @@ enum cp_reason_type {
 	CP_FASTBOOT_MODE,
 	CP_SPEC_LOG_NUM,
 	CP_RECOVER_DIR,
+	CP_XATTR_DIR,
 };
 
 enum iostat_type {
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 8f7aa4010bb90..060bd64502c68 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -214,6 +214,9 @@ static inline enum cp_reason_type need_do_checkpoint(struct inode *inode)
 		f2fs_exist_written_data(sbi, F2FS_I(inode)->i_pino,
 							TRANS_DIR_INO))
 		cp_reason = CP_RECOVER_DIR;
+	else if (f2fs_exist_written_data(sbi, F2FS_I(inode)->i_pino,
+							XATTR_DIR_INO))
+		cp_reason = CP_XATTR_DIR;
 
 	return cp_reason;
 }
diff --git a/fs/f2fs/xattr.c b/fs/f2fs/xattr.c
index c92ddc8c33a14..bd7099457018d 100644
--- a/fs/f2fs/xattr.c
+++ b/fs/f2fs/xattr.c
@@ -627,6 +627,7 @@ static int __f2fs_setxattr(struct inode *inode, int index,
 			const char *name, const void *value, size_t size,
 			struct page *ipage, int flags)
 {
+	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
 	struct f2fs_xattr_entry *here, *last;
 	void *base_addr, *last_base_addr;
 	int found, newsize;
@@ -756,9 +757,18 @@ static int __f2fs_setxattr(struct inode *inode, int index,
 	if (index == F2FS_XATTR_INDEX_ENCRYPTION &&
 			!strcmp(name, F2FS_XATTR_NAME_ENCRYPTION_CONTEXT))
 		f2fs_set_encrypted_inode(inode);
-	if (S_ISDIR(inode->i_mode))
-		set_sbi_flag(F2FS_I_SB(inode), SBI_NEED_CP);
 
+	if (!S_ISDIR(inode->i_mode))
+		goto same;
+	/*
+	 * In restrict mode, fsync() always try to trigger checkpoint for all
+	 * metadata consistency, in other mode, it triggers checkpoint when
+	 * parent's xattr metadata was updated.
+	 */
+	if (F2FS_OPTION(sbi).fsync_mode == FSYNC_MODE_STRICT)
+		set_sbi_flag(sbi, SBI_NEED_CP);
+	else
+		f2fs_add_ino_entry(sbi, inode->i_ino, XATTR_DIR_INO);
 same:
 	if (is_inode_flag_set(inode, FI_ACL_MODE)) {
 		inode->i_mode = F2FS_I(inode)->i_acl_mode;
diff --git a/include/trace/events/f2fs.h b/include/trace/events/f2fs.h
index e8cd19e91de11..1eb386122f1c2 100644
--- a/include/trace/events/f2fs.h
+++ b/include/trace/events/f2fs.h
@@ -145,7 +145,8 @@ TRACE_DEFINE_ENUM(CP_RESIZE);
 		{ CP_NODE_NEED_CP,	"node needs cp" },		\
 		{ CP_FASTBOOT_MODE,	"fastboot mode" },		\
 		{ CP_SPEC_LOG_NUM,	"log type is 2" },		\
-		{ CP_RECOVER_DIR,	"dir needs recovery" })
+		{ CP_RECOVER_DIR,	"dir needs recovery" },		\
+		{ CP_XATTR_DIR,		"dir's xattr updated" })
 
 #define show_shutdown_mode(type)					\
 	__print_symbolic(type,						\
-- 
2.43.0



