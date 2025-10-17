Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03BFA330B20;
	Fri, 17 Oct 2025 15:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716305; cv=none; b=AD3AxRakOrlk1WXIrqZh2GtzGtgehqBMoGGnKUKbHZTRvobzo+4L1eAep5VJVE3pIiTH/ZaO8qvZKdRQZ2cW03ZogHyWFYmpf3JOuiERr2fHf4P/bECe+QIrX7NxV9QKs24c2gD3PyTg5NNy1iQ5ByHYbo5JLKtrTF7FR+3h9rU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716305; c=relaxed/simple;
	bh=YI/hbDVGHFQKwkCywh0jIsMNoAxyUxIEqCx5IOyM7e4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fTNhybaXRq95pey2K6aztW0gArx2zzeu+LefbZAeNYkGD4d+91Y/AurSAlIt3WSBrYhaodq0/DSzy4jsArkHjoVvCU08XJV6JbnDA7sVDeg8JUsVCLD+CDwpAqTeyLAuhQrc3eLeMk8mbAKgtT0TR2svqYl52Jxt4nZnPREv9pU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=etC9EOj3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="etC9EOj3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81BF3C4CEE7;
	Fri, 17 Oct 2025 15:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716304;
	bh=YI/hbDVGHFQKwkCywh0jIsMNoAxyUxIEqCx5IOyM7e4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=etC9EOj3f0C2R8KUg/ij8xAau9F9zAmHE+2HVn0QYIaIXNtreXWrME22TO57j5D24
	 LyBYUnfZc10wM7iV1vedEyA1OnurOEqNtTAxC4E6MRRjVir5ypT1vNPIadrIPe8/ma
	 y7546yLA0+3Iz463v4z8kLv71DcTW03RKJ0ggOB0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Jan Kara <jack@suse.cz>,
	Zhang Yi <yi.zhang@huawei.com>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.15 112/276] ext4: fix checks for orphan inodes
Date: Fri, 17 Oct 2025 16:53:25 +0200
Message-ID: <20251017145146.567236899@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1944,6 +1944,16 @@ static inline bool ext4_verity_in_progre
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
@@ -327,7 +327,7 @@ static void ext4_inode_extension_cleanup
 	 * to cleanup the orphan list in ext4_handle_inode_extension(). Do it
 	 * now.
 	 */
-	if (!list_empty(&EXT4_I(inode)->i_orphan) && inode->i_nlink) {
+	if (ext4_inode_orphan_tracked(inode) && inode->i_nlink) {
 		handle_t *handle = ext4_journal_start(inode, EXT4_HT_INODE, 2);
 
 		if (IS_ERR(handle)) {
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -5122,7 +5122,7 @@ static int ext4_do_update_inode(handle_t
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
@@ -1352,9 +1352,9 @@ static void ext4_free_in_core_inode(stru
 
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


