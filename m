Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214329;
	b=w06lHH+ptHC9MULPBMbFDje0hvbSpmXc0Di+VE83cHh0PsuJ2nrStknw7aIPlrmWymyg
	 V3UmCp/kNpgaV3m/fCB+Oe2FgXPEACk0r8EV9x0cknQHhMMZEU6UFN/UKnQVXJQ6S4ayq
	 B2owjcoa/EzGckoihvHY0ObfDstbj0fEWqZlDgwadVDRQFZ2zeMW22crsrvNzjUg0S+hQ
	 L7nrc0Y8xAJfLPXSHO6enogSli3VJ1LN9vyBEzTYdc5B+LhkTy1jwCNpmztJ0u9w04Gnn
	 lntn0cL9wdKmheJk+PmT9SXdXOI0IkN0u2ghaciiyLA49vBFBYbkC2r5gtHFAdrUeQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214329;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nGmWgZDkRZRVGBAg0qbGNuzp1thibgbTHpAqgIJDkBA=;
	b=N6in790kEGMbLEHKYwFYcer9r1B5itstRSpeY84voZ875VxL9fgZ6BoUL3yxaC0us29h
	 VsTpbU1Q3ZSPGrt3Gd3Kx3MqY+3d6wTIHvpJ0gmetCc55VIty3HPCmlFyu4anDWbfWwvV
	 7eZQXy0KlogslMaCh4112SholRQOEvn6oOIhfOTgGQe7JCA+wTImtp8wgylFxHYJkXSt4
	 WtRrdbDeP2EYCxUSVS68XcCu3JcXd7wddsIHesjqjUaqDFEAZ1s9+ldC5LsFfgAWA5cK2
	 YDr7rydr409wPHEewkuTdTYXiscyiArtR9EYZ8SE+XzumuymW18BvT0CmfrfHnCSSbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ylG5hO58;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ED34606A322;
	Wed, 28 Oct 2026 19:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ylG5hO58
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F14E1F01825;
	Wed, 28 Oct 2026 19:05:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214328;
	bh=nGmWgZDkRZRVGBAg0qbGNuzp1thibgbTHpAqgIJDkBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ylG5hO587dCIkDsttVbDwFdWzNEkmNn4ilW0JrI9ssFSn2baqIpqw7x2dZS3oFypv
	 Z2Cr7TjWjIYTxebZQq6D/rh20UUf4fC6vCjkBHuAqCdRZy8RZd6mIiHCpulVEiM2AD
	 O3RPF2msqKO/p/Pu7VfGyypPEjpkpi94snfNTWds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuezhang Mo <Yuezhang.Mo@sony.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0821/1887] exfat: add cluster chain loop check for dir
Date: Wed, 28 Oct 2026 17:48:37 +0100
Message-ID: <20261028170518.109452552@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index dda10bca9ac98..d8c789d768076 100644
--- a/fs/exfat/dir.c
+++ b/fs/exfat/dir.c
@@ -943,6 +943,7 @@ int exfat_find_dir_entry(struct super_block *sb, struct exfat_inode_info *ei,
 	struct exfat_hint_femp candi_empty;
 	struct exfat_sb_info *sbi = EXFAT_SB(sb);
 	int num_entries = exfat_calc_num_entries(p_uniname);
+	unsigned int clu_count = 0;
 
 	if (num_entries < 0)
 		return num_entries;
@@ -1100,6 +1101,10 @@ int exfat_find_dir_entry(struct super_block *sb, struct exfat_inode_info *ei,
 		} else {
 			if (exfat_get_next_cluster(sb, &clu.dir))
 				return -EIO;
+
+			/* break if the cluster chain includes a loop */
+			if (unlikely(++clu_count > EXFAT_DATA_CLUSTER_COUNT(sbi)))
+				goto not_found;
 		}
 	}
 
@@ -1178,6 +1183,7 @@ int exfat_count_dir_entries(struct super_block *sb, struct exfat_chain *p_dir)
 	int i, count = 0;
 	int dentries_per_clu;
 	unsigned int entry_type;
+	unsigned int clu_count = 0;
 	struct exfat_chain clu;
 	struct exfat_dentry *ep;
 	struct exfat_sb_info *sbi = EXFAT_SB(sb);
@@ -1210,6 +1216,12 @@ int exfat_count_dir_entries(struct super_block *sb, struct exfat_chain *p_dir)
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
index e7e160d022566..bacd68bc7b8a0 100644
--- a/fs/exfat/fatent.c
+++ b/fs/exfat/fatent.c
@@ -470,5 +470,15 @@ int exfat_count_num_clusters(struct super_block *sb,
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
index 7f84ea80c8a6c..605c9d617d7c4 100644
--- a/fs/exfat/namei.c
+++ b/fs/exfat/namei.c
@@ -892,6 +892,7 @@ static int exfat_check_dir_empty(struct super_block *sb,
 {
 	int i, dentries_per_clu;
 	unsigned int type;
+	unsigned int clu_count = 0;
 	struct exfat_chain clu;
 	struct exfat_dentry *ep;
 	struct exfat_sb_info *sbi = EXFAT_SB(sb);
@@ -928,6 +929,10 @@ static int exfat_check_dir_empty(struct super_block *sb,
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
index 52b852a4121b0..e377fbc6e847e 100644
--- a/fs/exfat/super.c
+++ b/fs/exfat/super.c
@@ -336,13 +336,12 @@ static void exfat_hash_init(struct super_block *sb)
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
@@ -355,12 +354,9 @@ static int exfat_read_root(struct inode *inode)
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
@@ -580,7 +576,8 @@ static int exfat_verify_boot_region(struct super_block *sb)
 }
 
 /* mount the file system volume */
-static int __exfat_fill_super(struct super_block *sb)
+static int __exfat_fill_super(struct super_block *sb,
+		struct exfat_chain *root_clu)
 {
 	int ret;
 	struct exfat_sb_info *sbi = EXFAT_SB(sb);
@@ -597,6 +594,18 @@ static int __exfat_fill_super(struct super_block *sb)
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
@@ -631,6 +640,7 @@ static int exfat_fill_super(struct super_block *sb, struct fs_context *fc)
 	struct exfat_sb_info *sbi = sb->s_fs_info;
 	struct exfat_mount_options *opts = &sbi->options;
 	struct inode *root_inode;
+	struct exfat_chain root_clu;
 	int err;
 
 	if (opts->allow_utime == (unsigned short)-1)
@@ -649,7 +659,7 @@ static int exfat_fill_super(struct super_block *sb, struct fs_context *fc)
 	sb->s_time_min = EXFAT_MIN_TIMESTAMP_SECS;
 	sb->s_time_max = EXFAT_MAX_TIMESTAMP_SECS;
 
-	err = __exfat_fill_super(sb);
+	err = __exfat_fill_super(sb, &root_clu);
 	if (err) {
 		exfat_err(sb, "failed to recognize exfat type");
 		goto check_nls_io;
@@ -684,7 +694,7 @@ static int exfat_fill_super(struct super_block *sb, struct fs_context *fc)
 
 	root_inode->i_ino = EXFAT_ROOT_INO;
 	inode_set_iversion(root_inode, 1);
-	err = exfat_read_root(root_inode);
+	err = exfat_read_root(root_inode, &root_clu);
 	if (err) {
 		exfat_err(sb, "failed to initialize root inode");
 		goto put_inode;
-- 
2.53.0



