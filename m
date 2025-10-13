Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3D643090E8;
	Mon, 13 Oct 2025 15:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760370265; cv=none; b=QuewpVcqGsqYAfFp5rCZa0svXdkTBtjsg0UsIrfhheS9z887DT0NbhHnNzJR+GjMynuqxY+DeDuOfjdzpNreZ+hYaTZz45mqcWgseD9CiZ6RjyV+q0LwnJrPJYcjbgqkqzUHEf+DlAKmBuQf20Bgz2jaNnr/sg8trriXoowsFQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760370265; c=relaxed/simple;
	bh=ISandJV3s3VVvUf6Rb8SU1TgsOQreXfcXsuTZBbdCFM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Trq6//3P4BKsctl12gpSvZaLIi0/4v6wApISCavdziuSLmFbvEg498r5+GYQBRe7/Ixgs3MG41E+RXV3wVIILGIqEjZ0mz28HXB7DPujtZV1mJ1wKgRvIsp+SVeglcM24kKvxc9oiqNVAUd9HIsdHTH1YrW5VFKb6/3vBmqbcpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hSBlGI89; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hSBlGI89"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A04EC4CEE7;
	Mon, 13 Oct 2025 15:44:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760370265;
	bh=ISandJV3s3VVvUf6Rb8SU1TgsOQreXfcXsuTZBbdCFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hSBlGI89tCZXJXTY0XL5n3Fhfng3KxeGMwWfQtX9mhz4IKs7jRtkjWQtzuhTYvZeM
	 ivzrIWjCqB7OnrC6iI9DYbvA44sXMK2PzxxdREhipVX+s8tWwgNC42aID+GK24qDyC
	 A8/ZbO2kpXZ/+gkuTW7Hp1t+hnbfRrGJIgsCuaaQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Jan Kara <jack@suse.cz>,
	Zhang Yi <yi.zhang@huawei.com>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 6.17 537/563] ext4: fix checks for orphan inodes
Date: Mon, 13 Oct 2025 16:46:38 +0200
Message-ID: <20251013144430.763410659@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1982,6 +1982,16 @@ static inline bool ext4_verity_in_progre
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
@@ -4748,7 +4748,7 @@ static int ext4_fill_raw_inode(struct in
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
@@ -1438,9 +1438,9 @@ static void ext4_free_in_core_inode(stru
 
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


