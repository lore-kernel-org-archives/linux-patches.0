Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D53E321455;
	Mon, 18 Aug 2025 14:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755526021; cv=none; b=p0XTKKsFtlOUJVEJJvaHN7REVRDzTexm65z8TPpWkD09GnaMk+DTrZWZ02J0Bak5Vl6J7eq3WVr4C9gkUDqW6HrqObIl4av8o4rWZrqWo8sy++jT7pGgJ6freubgNYg1dtTmzD/6rBiHCNKnMQAG61NC8aL1SKfciDq335Hfd2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755526021; c=relaxed/simple;
	bh=bd1nwHPNvCxJXqAZ5LDy6ePqmc0TXje+r1jiUjGObyE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hWt90wecbI0Nr1C4Z5Dfp/iDwYuEcQSBvERIqkDJ3e8vmH6Im3PZG1ljibhnpRqTRe7/KwMV2iPgTEpzoo5FDtrHJk+j87HsIcSq2Bt0P63tzt8W0TjAm7skCPVmNsPz2JZAP2Bsr08Coe/Y5XB1O7GuL5PeHJLlijtBuvlkhSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G4nIGK80; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G4nIGK80"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D072AC113D0;
	Mon, 18 Aug 2025 14:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755526021;
	bh=bd1nwHPNvCxJXqAZ5LDy6ePqmc0TXje+r1jiUjGObyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G4nIGK80+AGjVjYI+fcBw/WDtMraBlkof1mur+v6vPM4JGwWRXcbswbvVCDrxbYmT
	 2Hex0mOoIPaq5t1xm88TJt4XD+URmrxOQYX5ru2wtd3NpXzKMuiUCPzZcL22yNR3vg
	 kwagTGnleaFiMuhDTBLK5T6Mj3BvxsyRo2VRmtpM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuezhang Mo <Yuezhang.Mo@sony.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 435/570] exfat: add cluster chain loop check for dir
Date: Mon, 18 Aug 2025 14:47:02 +0200
Message-ID: <20250818124522.585037403@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index 3103b932b674..ee060e26f51d 100644
--- a/fs/exfat/dir.c
+++ b/fs/exfat/dir.c
@@ -996,6 +996,7 @@ int exfat_find_dir_entry(struct super_block *sb, struct exfat_inode_info *ei,
 	struct exfat_hint_femp candi_empty;
 	struct exfat_sb_info *sbi = EXFAT_SB(sb);
 	int num_entries = exfat_calc_num_entries(p_uniname);
+	unsigned int clu_count = 0;
 
 	if (num_entries < 0)
 		return num_entries;
@@ -1133,6 +1134,10 @@ int exfat_find_dir_entry(struct super_block *sb, struct exfat_inode_info *ei,
 		} else {
 			if (exfat_get_next_cluster(sb, &clu.dir))
 				return -EIO;
+
+			/* break if the cluster chain includes a loop */
+			if (unlikely(++clu_count > EXFAT_DATA_CLUSTER_COUNT(sbi)))
+				goto not_found;
 		}
 	}
 
@@ -1195,6 +1200,7 @@ int exfat_count_dir_entries(struct super_block *sb, struct exfat_chain *p_dir)
 	int i, count = 0;
 	int dentries_per_clu;
 	unsigned int entry_type;
+	unsigned int clu_count = 0;
 	struct exfat_chain clu;
 	struct exfat_dentry *ep;
 	struct exfat_sb_info *sbi = EXFAT_SB(sb);
@@ -1227,6 +1233,12 @@ int exfat_count_dir_entries(struct super_block *sb, struct exfat_chain *p_dir)
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
index 23065f948ae7..232cc7f8ab92 100644
--- a/fs/exfat/fatent.c
+++ b/fs/exfat/fatent.c
@@ -490,5 +490,15 @@ int exfat_count_num_clusters(struct super_block *sb,
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
index fede0283d6e2..f5f1c4e8a29f 100644
--- a/fs/exfat/namei.c
+++ b/fs/exfat/namei.c
@@ -890,6 +890,7 @@ static int exfat_check_dir_empty(struct super_block *sb,
 {
 	int i, dentries_per_clu;
 	unsigned int type;
+	unsigned int clu_count = 0;
 	struct exfat_chain clu;
 	struct exfat_dentry *ep;
 	struct exfat_sb_info *sbi = EXFAT_SB(sb);
@@ -926,6 +927,10 @@ static int exfat_check_dir_empty(struct super_block *sb,
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
index 7ed858937d45..3a9ec75ab452 100644
--- a/fs/exfat/super.c
+++ b/fs/exfat/super.c
@@ -341,13 +341,12 @@ static void exfat_hash_init(struct super_block *sb)
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
@@ -360,12 +359,9 @@ static int exfat_read_root(struct inode *inode)
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
@@ -578,7 +574,8 @@ static int exfat_verify_boot_region(struct super_block *sb)
 }
 
 /* mount the file system volume */
-static int __exfat_fill_super(struct super_block *sb)
+static int __exfat_fill_super(struct super_block *sb,
+		struct exfat_chain *root_clu)
 {
 	int ret;
 	struct exfat_sb_info *sbi = EXFAT_SB(sb);
@@ -595,6 +592,18 @@ static int __exfat_fill_super(struct super_block *sb)
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
@@ -627,6 +636,7 @@ static int exfat_fill_super(struct super_block *sb, struct fs_context *fc)
 	struct exfat_sb_info *sbi = sb->s_fs_info;
 	struct exfat_mount_options *opts = &sbi->options;
 	struct inode *root_inode;
+	struct exfat_chain root_clu;
 	int err;
 
 	if (opts->allow_utime == (unsigned short)-1)
@@ -645,7 +655,7 @@ static int exfat_fill_super(struct super_block *sb, struct fs_context *fc)
 	sb->s_time_min = EXFAT_MIN_TIMESTAMP_SECS;
 	sb->s_time_max = EXFAT_MAX_TIMESTAMP_SECS;
 
-	err = __exfat_fill_super(sb);
+	err = __exfat_fill_super(sb, &root_clu);
 	if (err) {
 		exfat_err(sb, "failed to recognize exfat type");
 		goto check_nls_io;
@@ -680,7 +690,7 @@ static int exfat_fill_super(struct super_block *sb, struct fs_context *fc)
 
 	root_inode->i_ino = EXFAT_ROOT_INO;
 	inode_set_iversion(root_inode, 1);
-	err = exfat_read_root(root_inode);
+	err = exfat_read_root(root_inode, &root_clu);
 	if (err) {
 		exfat_err(sb, "failed to initialize root inode");
 		goto put_inode;
-- 
2.39.5



