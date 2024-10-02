Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 382281D0BAC;
	Wed,  2 Oct 2024 14:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878391; cv=none; b=HrvWQ3QZWNNVskGRVnqnBojyrldEOvDXcjIY08MMY3pNIR4iFU1TVqc98bjWO6D57ijO1M4biCPA1Do2jKpldk2mtnE0/DUepiWPSZl0Ed3vh4p0TB24p7cl0o4Z4/tcHHWKiSIrDG5RFuFXpaH6o4DWBmVNYAMAm9MzSJnOo68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878391; c=relaxed/simple;
	bh=saYqRPhr2a+OvIDba++QETdmV0QY+/XQCTuRe5hJSqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bpbpOd6qjh6UCfJpbE1NwrlbGBpBJEz01TniIKgzgakkhdJjMbRs24bVRWQrfE1o2lEh9vBYhJlHo1vJw4wvtKQlKLeY/ccBezMYYPPHPZ9BAh19bd50hxdA8DtuyU4Y3UvE32SeTVD6SP8aBkZAxcWryAFweKSEYbQxoyXQ0VE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V+QI5Slj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V+QI5Slj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB3E9C4CEC2;
	Wed,  2 Oct 2024 14:13:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878391;
	bh=saYqRPhr2a+OvIDba++QETdmV0QY+/XQCTuRe5hJSqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V+QI5SljywW6/j1Ygxn4Xq9p9B1ZIoDLD1UoYgi0HmNxnqB9nY5QsB2prVHJAQXba
	 OIzTbhUZTv25fcAL3w0ECXn+FxuYQRns8EYTW/L7kkK5GKOSUl3eKE6mNwuupEmkVq
	 9VTNnAfmGZm8SfT69jbN1wxOUFMSEZtFe8geS2YY=
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
Subject: [PATCH 6.10 397/634] f2fs: reduce expensive checkpoint trigger frequency
Date: Wed,  2 Oct 2024 14:58:17 +0200
Message-ID: <20241002125826.774314015@linuxfoundation.org>
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
index ba2b9f2db10e6..c7bc3ba59a31f 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -285,6 +285,7 @@ enum {
 	APPEND_INO,		/* for append ino list */
 	UPDATE_INO,		/* for update ino list */
 	TRANS_DIR_INO,		/* for transactions dir ino list */
+	XATTR_DIR_INO,		/* for xattr updated dir ino list */
 	FLUSH_INO,		/* for multiple device flushing */
 	MAX_INO_ENTRY,		/* max. list */
 };
@@ -1155,6 +1156,7 @@ enum cp_reason_type {
 	CP_FASTBOOT_MODE,
 	CP_SPEC_LOG_NUM,
 	CP_RECOVER_DIR,
+	CP_XATTR_DIR,
 };
 
 enum iostat_type {
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 387ce167dda1b..fa6299a88492f 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -218,6 +218,9 @@ static inline enum cp_reason_type need_do_checkpoint(struct inode *inode)
 		f2fs_exist_written_data(sbi, F2FS_I(inode)->i_pino,
 							TRANS_DIR_INO))
 		cp_reason = CP_RECOVER_DIR;
+	else if (f2fs_exist_written_data(sbi, F2FS_I(inode)->i_pino,
+							XATTR_DIR_INO))
+		cp_reason = CP_XATTR_DIR;
 
 	return cp_reason;
 }
diff --git a/fs/f2fs/xattr.c b/fs/f2fs/xattr.c
index f290fe9327c49..3f38749436796 100644
--- a/fs/f2fs/xattr.c
+++ b/fs/f2fs/xattr.c
@@ -629,6 +629,7 @@ static int __f2fs_setxattr(struct inode *inode, int index,
 			const char *name, const void *value, size_t size,
 			struct page *ipage, int flags)
 {
+	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
 	struct f2fs_xattr_entry *here, *last;
 	void *base_addr, *last_base_addr;
 	int found, newsize;
@@ -772,9 +773,18 @@ static int __f2fs_setxattr(struct inode *inode, int index,
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
index ed794b5fefbe3..2851c823095bc 100644
--- a/include/trace/events/f2fs.h
+++ b/include/trace/events/f2fs.h
@@ -139,7 +139,8 @@ TRACE_DEFINE_ENUM(EX_BLOCK_AGE);
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



