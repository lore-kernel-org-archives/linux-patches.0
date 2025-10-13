Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AB5330AD06;
	Mon, 13 Oct 2025 15:17:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368675; cv=none; b=dywgekSFgSUehjJJsk2gdbOm9nQT6dnbiepN9bwsvkXQO8H1nGTbRow+aowWgS/NxqjlSW68Kgpo80vxpzM2MrVSq9H1VVrHsVBHTnpzjSpjDPMXCftr/3JT9wR/YtR8TWze4UHLec8CMb3DeiumgehWxp0+OsibY3KD8oVaLTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368675; c=relaxed/simple;
	bh=70CN2zRpWN3c0RxvflXcjVfZLBcR0buAC15C7gTSJqo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hvM6B5rSy4j6PGIWVuBCh6OPrkXYGkuYiFEsx7lKH0QNNgLC2ZDWsWg/q+BsHzROx+bMicOYkV1TnDwDSXRuNQjh+aP1q3mZ/8nFgbipn7wbtWR+PwVuUJIYYk3v16EsKH6lvdow8o0oQwHUVKoQUKbESvktKpdcFpty1DfWR3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IfEnn1Z6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IfEnn1Z6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB530C4CEE7;
	Mon, 13 Oct 2025 15:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368675;
	bh=70CN2zRpWN3c0RxvflXcjVfZLBcR0buAC15C7gTSJqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IfEnn1Z6DJRO+c+ppMRQEqT6EyIAhINk66KqaKrnlXqL5d3lnVOY5R6Zr8q8lD2+c
	 1RywGFQbMnlB2xtvyCqzRWciUhK6BhN2yP+oG7muV80FTRmln1YI+dWgfNHSVUfQc7
	 3d0VZtfoeeve10N5FfHveNwLGLLhxakM6smbEoeE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Jan Kara <jack@suse.cz>,
	Zhang Yi <yi.zhang@huawei.com>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.12 242/262] ext4: fix checks for orphan inodes
Date: Mon, 13 Oct 2025 16:46:24 +0200
Message-ID: <20251013144334.953291810@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

From: Jan Kara <jack@suse.cz>

commit acf943e9768ec9d9be80982ca0ebc4bfd6b7631e upstream.

When orphan file feature is enabled, inode can be tracked as orphan
either in the standard orphan list or in the orphan file. The first can
be tested by checking ei->i_orphan list head, the second is recorded by
EXT4_STATE_ORPHAN_FILE inode state flag. There are several places where
we want to check whether inode is tracked as orphan and only some of
them properly check for both possibilities. Luckily the consequences are
mostly minor, the worst that can happen is that we track an inode as
orphan although we don't need to and e2fsck then complains (resulting in
occasional ext4/307 xfstest failures). Fix the problem by introducing a
helper for checking whether an inode is tracked as orphan and use it in
appropriate places.

Fixes: 4a79a98c7b19 ("ext4: Improve scalability of ext4 orphan file handling")
Cc: stable@kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
Reviewed-by: Zhang Yi <yi.zhang@huawei.com>
Message-ID: <20250925123038.20264-2-jack@suse.cz>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/ext4.h   |   10 ++++++++++
 fs/ext4/file.c   |    2 +-
 fs/ext4/inode.c  |    2 +-
 fs/ext4/orphan.c |    6 +-----
 fs/ext4/super.c  |    4 ++--
 5 files changed, 15 insertions(+), 9 deletions(-)

--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -1970,6 +1970,16 @@ static inline bool ext4_verity_in_progre
 #define NEXT_ORPHAN(inode) EXT4_I(inode)->i_dtime
 
 /*
+ * Check whether the inode is tracked as orphan (either in orphan file or
+ * orphan list).
+ */
+static inline bool ext4_inode_orphan_tracked(struct inode *inode)
+{
+	return ext4_test_inode_state(inode, EXT4_STATE_ORPHAN_FILE) ||
+		!list_empty(&EXT4_I(inode)->i_orphan);
+}
+
+/*
  * Codes for operating systems
  */
 #define EXT4_OS_LINUX		0
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -354,7 +354,7 @@ static void ext4_inode_extension_cleanup
 	 * to cleanup the orphan list in ext4_handle_inode_extension(). Do it
 	 * now.
 	 */
-	if (!list_empty(&EXT4_I(inode)->i_orphan) && inode->i_nlink) {
+	if (ext4_inode_orphan_tracked(inode) && inode->i_nlink) {
 		handle_t *handle = ext4_journal_start(inode, EXT4_HT_INODE, 2);
 
 		if (IS_ERR(handle)) {
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4330,7 +4330,7 @@ static int ext4_fill_raw_inode(struct in
 		 * old inodes get re-used with the upper 16 bits of the
 		 * uid/gid intact.
 		 */
-		if (ei->i_dtime && list_empty(&ei->i_orphan)) {
+		if (ei->i_dtime && !ext4_inode_orphan_tracked(inode)) {
 			raw_inode->i_uid_high = 0;
 			raw_inode->i_gid_high = 0;
 		} else {
--- a/fs/ext4/orphan.c
+++ b/fs/ext4/orphan.c
@@ -109,11 +109,7 @@ int ext4_orphan_add(handle_t *handle, st
 
 	WARN_ON_ONCE(!(inode->i_state & (I_NEW | I_FREEING)) &&
 		     !inode_is_locked(inode));
-	/*
-	 * Inode orphaned in orphan file or in orphan list?
-	 */
-	if (ext4_test_inode_state(inode, EXT4_STATE_ORPHAN_FILE) ||
-	    !list_empty(&EXT4_I(inode)->i_orphan))
+	if (ext4_inode_orphan_tracked(inode))
 		return 0;
 
 	/*
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1461,9 +1461,9 @@ static void ext4_free_in_core_inode(stru
 
 static void ext4_destroy_inode(struct inode *inode)
 {
-	if (!list_empty(&(EXT4_I(inode)->i_orphan))) {
+	if (ext4_inode_orphan_tracked(inode)) {
 		ext4_msg(inode->i_sb, KERN_ERR,
-			 "Inode %lu (%p): orphan list check failed!",
+			 "Inode %lu (%p): inode tracked as orphan!",
 			 inode->i_ino, EXT4_I(inode));
 		print_hex_dump(KERN_INFO, "", DUMP_PREFIX_ADDRESS, 16, 4,
 				EXT4_I(inode), sizeof(struct ext4_inode_info),


