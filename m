Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7779E13957E;
	Tue, 26 Aug 2025 13:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213235; cv=none; b=fWr8FQWQ56jOk1aN86vOZW0Cj6Mq3Mru/ReNzpDDEddQU2XrNLyQqCmmP96ZHmTPDEtV1+T27o6qQ6l5Fqx1gdruEId7YvPc68W8A77MPHHGqudZ9BERR8nvly8OzB1rlNnEtcFPmSMRxCFu+HVQRTFPd1Jes2vlKnPTTIs3a8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213235; c=relaxed/simple;
	bh=seRF3WoU1w5IdVuSd1YCJzUs+qNngXD0JjEaPbtSdxw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cZhTRJ/4lHqvH9W2TqIqOSPzOsPm5FAGdXkzWI8zkdL40NC3c6qQGmkeZOeD4+JwFbC+AFbelyo5U0mgDHFyaa03bMYv52r8Z2m/zdSngToOje5s1Qd/rnsNxeR6YzMGbs5vKboiCURrFZ5ZQEU6EFuhTJa0BeiZcZNtaC2TgAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=myE21JxT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="myE21JxT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09576C4CEF1;
	Tue, 26 Aug 2025 13:00:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213235;
	bh=seRF3WoU1w5IdVuSd1YCJzUs+qNngXD0JjEaPbtSdxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=myE21JxTkI84f1qItOx2JsJbIXxouIcOmJJmvEGjrJT/YvFkgeQJ3DGuh0jYp55mL
	 423wjq37pqCEqI26P6KwHkPBX7qGaDKx+Na4s9AdxRY23Ew/1l79hq8d1YQYh79N5P
	 0EdKzBaq2kQ1s2w6LetU4cnfQk997mA+F2Kaau3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuezhang Mo <Yuezhang.Mo@sony.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 272/587] exfat: add cluster chain loop check for dir
Date: Tue, 26 Aug 2025 13:07:01 +0200
Message-ID: <20250826110959.847863854@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Yuezhang Mo <Yuezhang.Mo@sony.com>

[ Upstream commit 99f9a97dce39ad413c39b92c90393bbd6778f3fd ]

An infinite loop may occur if the following conditions occur due to
file system corruption.

(1) Condition for exfat_count_dir_entries() to loop infinitely.
    - The cluster chain includes a loop.
    - There is no UNUSED entry in the cluster chain.

(2) Condition for exfat_create_upcase_table() to loop infinitely.
    - The cluster chain of the root directory includes a loop.
    - There are no UNUSED entry and up-case table entry in the cluster
      chain of the root directory.

(3) Condition for exfat_load_bitmap() to loop infinitely.
    - The cluster chain of the root directory includes a loop.
    - There are no UNUSED entry and bitmap entry in the cluster chain
      of the root directory.

(4) Condition for exfat_find_dir_entry() to loop infinitely.
    - The cluster chain includes a loop.
    - The unused directory entries were exhausted by some operation.

(5) Condition for exfat_check_dir_empty() to loop infinitely.
    - The cluster chain includes a loop.
    - The unused directory entries were exhausted by some operation.
    - All files and sub-directories under the directory are deleted.

This commit adds checks to break the above infinite loop.

Signed-off-by: Yuezhang Mo <Yuezhang.Mo@sony.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/exfat/dir.c    | 12 ++++++++++++
 fs/exfat/fatent.c | 10 ++++++++++
 fs/exfat/namei.c  |  5 +++++
 fs/exfat/super.c  | 32 +++++++++++++++++++++-----------
 4 files changed, 48 insertions(+), 11 deletions(-)

diff --git a/fs/exfat/dir.c b/fs/exfat/dir.c
index f4f81e349cef..6139a57fde70 100644
--- a/fs/exfat/dir.c
+++ b/fs/exfat/dir.c
@@ -994,6 +994,7 @@ int exfat_find_dir_entry(struct super_block *sb, struct exfat_inode_info *ei,
 	struct exfat_hint_femp candi_empty;
 	struct exfat_sb_info *sbi = EXFAT_SB(sb);
 	int num_entries = exfat_calc_num_entries(p_uniname);
+	unsigned int clu_count = 0;
 
 	if (num_entries < 0)
 		return num_entries;
@@ -1131,6 +1132,10 @@ int exfat_find_dir_entry(struct super_block *sb, struct exfat_inode_info *ei,
 		} else {
 			if (exfat_get_next_cluster(sb, &clu.dir))
 				return -EIO;
+
+			/* break if the cluster chain includes a loop */
+			if (unlikely(++clu_count > EXFAT_DATA_CLUSTER_COUNT(sbi)))
+				goto not_found;
 		}
 	}
 
@@ -1214,6 +1219,7 @@ int exfat_count_dir_entries(struct super_block *sb, struct exfat_chain *p_dir)
 	int i, count = 0;
 	int dentries_per_clu;
 	unsigned int entry_type;
+	unsigned int clu_count = 0;
 	struct exfat_chain clu;
 	struct exfat_dentry *ep;
 	struct exfat_sb_info *sbi = EXFAT_SB(sb);
@@ -1246,6 +1252,12 @@ int exfat_count_dir_entries(struct super_block *sb, struct exfat_chain *p_dir)
 		} else {
 			if (exfat_get_next_cluster(sb, &(clu.dir)))
 				return -EIO;
+
+			if (unlikely(++clu_count > sbi->used_clusters)) {
+				exfat_fs_error(sb, "FAT or bitmap is corrupted");
+				return -EIO;
+			}
+
 		}
 	}
 
diff --git a/fs/exfat/fatent.c b/fs/exfat/fatent.c
index 24e1e05f9f34..407880901ee3 100644
--- a/fs/exfat/fatent.c
+++ b/fs/exfat/fatent.c
@@ -461,5 +461,15 @@ int exfat_count_num_clusters(struct super_block *sb,
 	}
 
 	*ret_count = count;
+
+	/*
+	 * since exfat_count_used_clusters() is not called, sbi->used_clusters
+	 * cannot be used here.
+	 */
+	if (unlikely(i == sbi->num_clusters && clu != EXFAT_EOF_CLUSTER)) {
+		exfat_fs_error(sb, "The cluster chain has a loop");
+		return -EIO;
+	}
+
 	return 0;
 }
diff --git a/fs/exfat/namei.c b/fs/exfat/namei.c
index f340e96b499f..4657f893dea7 100644
--- a/fs/exfat/namei.c
+++ b/fs/exfat/namei.c
@@ -893,6 +893,7 @@ static int exfat_check_dir_empty(struct super_block *sb,
 {
 	int i, dentries_per_clu;
 	unsigned int type;
+	unsigned int clu_count = 0;
 	struct exfat_chain clu;
 	struct exfat_dentry *ep;
 	struct exfat_sb_info *sbi = EXFAT_SB(sb);
@@ -929,6 +930,10 @@ static int exfat_check_dir_empty(struct super_block *sb,
 		} else {
 			if (exfat_get_next_cluster(sb, &(clu.dir)))
 				return -EIO;
+
+			/* break if the cluster chain includes a loop */
+			if (unlikely(++clu_count > EXFAT_DATA_CLUSTER_COUNT(sbi)))
+				break;
 		}
 	}
 
diff --git a/fs/exfat/super.c b/fs/exfat/super.c
index 2778bd9b631e..5affc11d1461 100644
--- a/fs/exfat/super.c
+++ b/fs/exfat/super.c
@@ -327,13 +327,12 @@ static void exfat_hash_init(struct super_block *sb)
 		INIT_HLIST_HEAD(&sbi->inode_hashtable[i]);
 }
 
-static int exfat_read_root(struct inode *inode)
+static int exfat_read_root(struct inode *inode, struct exfat_chain *root_clu)
 {
 	struct super_block *sb = inode->i_sb;
 	struct exfat_sb_info *sbi = EXFAT_SB(sb);
 	struct exfat_inode_info *ei = EXFAT_I(inode);
-	struct exfat_chain cdir;
-	int num_subdirs, num_clu = 0;
+	int num_subdirs;
 
 	exfat_chain_set(&ei->dir, sbi->root_dir, 0, ALLOC_FAT_CHAIN);
 	ei->entry = -1;
@@ -346,12 +345,9 @@ static int exfat_read_root(struct inode *inode)
 	ei->hint_stat.clu = sbi->root_dir;
 	ei->hint_femp.eidx = EXFAT_HINT_NONE;
 
-	exfat_chain_set(&cdir, sbi->root_dir, 0, ALLOC_FAT_CHAIN);
-	if (exfat_count_num_clusters(sb, &cdir, &num_clu))
-		return -EIO;
-	i_size_write(inode, num_clu << sbi->cluster_size_bits);
+	i_size_write(inode, EXFAT_CLU_TO_B(root_clu->size, sbi));
 
-	num_subdirs = exfat_count_dir_entries(sb, &cdir);
+	num_subdirs = exfat_count_dir_entries(sb, root_clu);
 	if (num_subdirs < 0)
 		return -EIO;
 	set_nlink(inode, num_subdirs + EXFAT_MIN_SUBDIR);
@@ -567,7 +563,8 @@ static int exfat_verify_boot_region(struct super_block *sb)
 }
 
 /* mount the file system volume */
-static int __exfat_fill_super(struct super_block *sb)
+static int __exfat_fill_super(struct super_block *sb,
+		struct exfat_chain *root_clu)
 {
 	int ret;
 	struct exfat_sb_info *sbi = EXFAT_SB(sb);
@@ -584,6 +581,18 @@ static int __exfat_fill_super(struct super_block *sb)
 		goto free_bh;
 	}
 
+	/*
+	 * Call exfat_count_num_cluster() before searching for up-case and
+	 * bitmap directory entries to avoid infinite loop if they are missing
+	 * and the cluster chain includes a loop.
+	 */
+	exfat_chain_set(root_clu, sbi->root_dir, 0, ALLOC_FAT_CHAIN);
+	ret = exfat_count_num_clusters(sb, root_clu, &root_clu->size);
+	if (ret) {
+		exfat_err(sb, "failed to count the number of clusters in root");
+		goto free_bh;
+	}
+
 	ret = exfat_create_upcase_table(sb);
 	if (ret) {
 		exfat_err(sb, "failed to load upcase table");
@@ -618,6 +627,7 @@ static int exfat_fill_super(struct super_block *sb, struct fs_context *fc)
 	struct exfat_sb_info *sbi = sb->s_fs_info;
 	struct exfat_mount_options *opts = &sbi->options;
 	struct inode *root_inode;
+	struct exfat_chain root_clu;
 	int err;
 
 	if (opts->allow_utime == (unsigned short)-1)
@@ -636,7 +646,7 @@ static int exfat_fill_super(struct super_block *sb, struct fs_context *fc)
 	sb->s_time_min = EXFAT_MIN_TIMESTAMP_SECS;
 	sb->s_time_max = EXFAT_MAX_TIMESTAMP_SECS;
 
-	err = __exfat_fill_super(sb);
+	err = __exfat_fill_super(sb, &root_clu);
 	if (err) {
 		exfat_err(sb, "failed to recognize exfat type");
 		goto check_nls_io;
@@ -671,7 +681,7 @@ static int exfat_fill_super(struct super_block *sb, struct fs_context *fc)
 
 	root_inode->i_ino = EXFAT_ROOT_INO;
 	inode_set_iversion(root_inode, 1);
-	err = exfat_read_root(root_inode);
+	err = exfat_read_root(root_inode, &root_clu);
 	if (err) {
 		exfat_err(sb, "failed to initialize root inode");
 		goto put_inode;
-- 
2.39.5



