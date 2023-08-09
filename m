Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA68F15AE3
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 10:50:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B80FC433C8;
	Wed,  9 Aug 2023 10:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691578206;
	bh=sP1DYyQo8k9yVAgXGQ6HrN1Rxo7+PkXcKsJfyvaNi8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CaaLdw8N8wuYVH6DJNXoSTnQzX1tTQfU0e+niq4FPHmeHTvzC1tJ7og1hgpv1JCtE
	 ACSwiK3BWsrUNNWokhZzICaIjh093VIeWzOC/WE/BvB4OqllySZ1O/6XJW8rN3Ttnz
	 Iro0OglaqhbwsuD25X+ic+BJ2QgiLEsmW7h9XhQI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+af5e10f73dbff48f70af@syzkaller.appspotmail.com,
	Jan Kara <jack@suse.cz>
Subject: [PATCH 6.4 144/165] ext2: Drop fragment support
Date: Wed,  9 Aug 2023 12:41:15 +0200
Message-ID: <20230809103647.509744295@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103642.720851262@linuxfoundation.org>
References: <20230809103642.720851262@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jan Kara <jack@suse.cz>

commit 404615d7f1dcd4cca200e9a7a9df3a1dcae1dd62 upstream.

Ext2 has fields in superblock reserved for subblock allocation support.
However that never landed. Drop the many years dead code.

Reported-by: syzbot+af5e10f73dbff48f70af@syzkaller.appspotmail.com
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext2/ext2.h  |   12 ------------
 fs/ext2/super.c |   23 ++++-------------------
 2 files changed, 4 insertions(+), 31 deletions(-)

--- a/fs/ext2/ext2.h
+++ b/fs/ext2/ext2.h
@@ -70,10 +70,7 @@ struct mb_cache;
  * second extended-fs super-block data in memory
  */
 struct ext2_sb_info {
-	unsigned long s_frag_size;	/* Size of a fragment in bytes */
-	unsigned long s_frags_per_block;/* Number of fragments per block */
 	unsigned long s_inodes_per_block;/* Number of inodes per block */
-	unsigned long s_frags_per_group;/* Number of fragments in a group */
 	unsigned long s_blocks_per_group;/* Number of blocks in a group */
 	unsigned long s_inodes_per_group;/* Number of inodes in a group */
 	unsigned long s_itb_per_group;	/* Number of inode table blocks per group */
@@ -189,15 +186,6 @@ static inline struct ext2_sb_info *EXT2_
 #define EXT2_FIRST_INO(s)		(EXT2_SB(s)->s_first_ino)
 
 /*
- * Macro-instructions used to manage fragments
- */
-#define EXT2_MIN_FRAG_SIZE		1024
-#define	EXT2_MAX_FRAG_SIZE		4096
-#define EXT2_MIN_FRAG_LOG_SIZE		  10
-#define EXT2_FRAG_SIZE(s)		(EXT2_SB(s)->s_frag_size)
-#define EXT2_FRAGS_PER_BLOCK(s)		(EXT2_SB(s)->s_frags_per_block)
-
-/*
  * Structure of a blocks group descriptor
  */
 struct ext2_group_desc
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -668,10 +668,9 @@ static int ext2_setup_super (struct supe
 		es->s_max_mnt_count = cpu_to_le16(EXT2_DFL_MAX_MNT_COUNT);
 	le16_add_cpu(&es->s_mnt_count, 1);
 	if (test_opt (sb, DEBUG))
-		ext2_msg(sb, KERN_INFO, "%s, %s, bs=%lu, fs=%lu, gc=%lu, "
+		ext2_msg(sb, KERN_INFO, "%s, %s, bs=%lu, gc=%lu, "
 			"bpg=%lu, ipg=%lu, mo=%04lx]",
 			EXT2FS_VERSION, EXT2FS_DATE, sb->s_blocksize,
-			sbi->s_frag_size,
 			sbi->s_groups_count,
 			EXT2_BLOCKS_PER_GROUP(sb),
 			EXT2_INODES_PER_GROUP(sb),
@@ -1012,14 +1011,7 @@ static int ext2_fill_super(struct super_
 		}
 	}
 
-	sbi->s_frag_size = EXT2_MIN_FRAG_SIZE <<
-				   le32_to_cpu(es->s_log_frag_size);
-	if (sbi->s_frag_size == 0)
-		goto cantfind_ext2;
-	sbi->s_frags_per_block = sb->s_blocksize / sbi->s_frag_size;
-
 	sbi->s_blocks_per_group = le32_to_cpu(es->s_blocks_per_group);
-	sbi->s_frags_per_group = le32_to_cpu(es->s_frags_per_group);
 	sbi->s_inodes_per_group = le32_to_cpu(es->s_inodes_per_group);
 
 	sbi->s_inodes_per_block = sb->s_blocksize / EXT2_INODE_SIZE(sb);
@@ -1045,11 +1037,10 @@ static int ext2_fill_super(struct super_
 		goto failed_mount;
 	}
 
-	if (sb->s_blocksize != sbi->s_frag_size) {
+	if (es->s_log_frag_size != es->s_log_block_size) {
 		ext2_msg(sb, KERN_ERR,
-			"error: fragsize %lu != blocksize %lu"
-			"(not supported yet)",
-			sbi->s_frag_size, sb->s_blocksize);
+			"error: fragsize log %u != blocksize log %u",
+			le32_to_cpu(es->s_log_frag_size), sb->s_blocksize_bits);
 		goto failed_mount;
 	}
 
@@ -1066,12 +1057,6 @@ static int ext2_fill_super(struct super_
 			sbi->s_blocks_per_group, sbi->s_inodes_per_group + 3);
 		goto failed_mount;
 	}
-	if (sbi->s_frags_per_group > sb->s_blocksize * 8) {
-		ext2_msg(sb, KERN_ERR,
-			"error: #fragments per group too big: %lu",
-			sbi->s_frags_per_group);
-		goto failed_mount;
-	}
 	if (sbi->s_inodes_per_group < sbi->s_inodes_per_block ||
 	    sbi->s_inodes_per_group > sb->s_blocksize * 8) {
 		ext2_msg(sb, KERN_ERR,


