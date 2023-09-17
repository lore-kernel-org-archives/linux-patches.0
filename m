Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC3916FC9
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:41:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B3B3C43395;
	Sun, 17 Sep 2023 19:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694979714;
	bh=tkOCSz56pkadglpdsYFJs0HZU2tVHhRHQUOS/H7nF6c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GNZYXiwN1SovnqfEynJsgBiljLjDV8nnfAR0J2d+vwQiP/oDX/ZUPb3egP5tOtFhj
	 GEqBXDrwcryZS3EAONrmt5XVkKKRDi2Vjbma3CNAGJ6X1aRZ/qhePYFFVribMpE7Xf
	 79zcEiuPwz6bHAAxuNX3b1YHhA5ehaqINvhzBMt4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Wang Jianjian <wangjianjian0@foxmail.com>,
	Theodore Tso <tytso@mit.edu>
Subject: [PATCH 5.10 368/406] ext4: add correct group descriptors and reserved GDT blocks to system zone
Date: Sun, 17 Sep 2023 21:13:42 +0200
Message-ID: <20230917191110.983871593@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191101.035638219@linuxfoundation.org>
References: <20230917191101.035638219@linuxfoundation.org>
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

From: Wang Jianjian <wangjianjian0@foxmail.com>

commit 68228da51c9a436872a4ef4b5a7692e29f7e5bc7 upstream.

When setup_system_zone, flex_bg is not initialized so it is always 1.
Use a new helper function, ext4_num_base_meta_blocks() which does not
depend on sbi->s_log_groups_per_flex being initialized.

[ Squashed two patches in the Link URL's below together into a single
  commit, which is simpler to review/understand.  Also fix checkpatch
  warnings. --TYT ]

Cc: stable@kernel.org
Signed-off-by: Wang Jianjian <wangjianjian0@foxmail.com>
Link: https://lore.kernel.org/r/tencent_21AF0D446A9916ED5C51492CC6C9A0A77B05@qq.com
Link: https://lore.kernel.org/r/tencent_D744D1450CC169AEA77FCF0A64719909ED05@qq.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/balloc.c         |   15 +++++++++++----
 fs/ext4/block_validity.c |    8 ++++----
 fs/ext4/ext4.h           |    2 ++
 3 files changed, 17 insertions(+), 8 deletions(-)

--- a/fs/ext4/balloc.c
+++ b/fs/ext4/balloc.c
@@ -903,11 +903,11 @@ unsigned long ext4_bg_num_gdb(struct sup
 }
 
 /*
- * This function returns the number of file system metadata clusters at
+ * This function returns the number of file system metadata blocks at
  * the beginning of a block group, including the reserved gdt blocks.
  */
-static unsigned ext4_num_base_meta_clusters(struct super_block *sb,
-				     ext4_group_t block_group)
+unsigned int ext4_num_base_meta_blocks(struct super_block *sb,
+				       ext4_group_t block_group)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	unsigned num;
@@ -925,8 +925,15 @@ static unsigned ext4_num_base_meta_clust
 	} else { /* For META_BG_BLOCK_GROUPS */
 		num += ext4_bg_num_gdb(sb, block_group);
 	}
-	return EXT4_NUM_B2C(sbi, num);
+	return num;
 }
+
+static unsigned int ext4_num_base_meta_clusters(struct super_block *sb,
+						ext4_group_t block_group)
+{
+	return EXT4_NUM_B2C(EXT4_SB(sb), ext4_num_base_meta_blocks(sb, block_group));
+}
+
 /**
  *	ext4_inode_to_goal_block - return a hint for block allocation
  *	@inode: inode for block allocation
--- a/fs/ext4/block_validity.c
+++ b/fs/ext4/block_validity.c
@@ -217,7 +217,6 @@ int ext4_setup_system_zone(struct super_
 	struct ext4_system_blocks *system_blks;
 	struct ext4_group_desc *gdp;
 	ext4_group_t i;
-	int flex_size = ext4_flex_bg_size(sbi);
 	int ret;
 
 	system_blks = kzalloc(sizeof(*system_blks), GFP_KERNEL);
@@ -225,12 +224,13 @@ int ext4_setup_system_zone(struct super_
 		return -ENOMEM;
 
 	for (i=0; i < ngroups; i++) {
+		unsigned int meta_blks = ext4_num_base_meta_blocks(sb, i);
+
 		cond_resched();
-		if (ext4_bg_has_super(sb, i) &&
-		    ((i < 5) || ((i % flex_size) == 0))) {
+		if (meta_blks != 0) {
 			ret = add_system_zone(system_blks,
 					ext4_group_first_block_no(sb, i),
-					ext4_bg_num_gdb(sb, i) + 1, 0);
+					meta_blks, 0);
 			if (ret)
 				goto err;
 		}
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2967,6 +2967,8 @@ extern const char *ext4_decode_error(str
 extern void ext4_mark_group_bitmap_corrupted(struct super_block *sb,
 					     ext4_group_t block_group,
 					     unsigned int flags);
+extern unsigned int ext4_num_base_meta_blocks(struct super_block *sb,
+					      ext4_group_t block_group);
 
 extern __printf(6, 7)
 void __ext4_error(struct super_block *, const char *, unsigned int, int, __u64,


