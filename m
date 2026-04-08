Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E587B67E;
	Wed,  8 Apr 2026 18:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672351; cv=none; b=i3IKLPHavK0ZpRJXbI6Ix/1615C6uYi8JucHNZ/um4hGml0OqcpgR7eXv5jdIbnjQw+HEW6dGEuSMr9zmEU9enO3mNSsaUKPYRnuHDxy7up/JonGpxcRH7T++EetCAtfqmoRbiPDnn9pR+reBNmuEs0Ou3kIFiez3kt8B7yXNNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672351; c=relaxed/simple;
	bh=u5edfsdbfmvxbFPDeKbQi+yymC+G8keo9lTBbMuQ9no=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fPvBUx5zghQnaib7w7OdRxPSdinVyrUsG+NU1AOxuOs6w9P/CXU+Q1+nAhYlWpl5U4VF95PhApbeUO7k78gR8lGnGzAsTDoZdAU4ptRiRTxKmqcP7FjcjkgcSt99nC/4gF1dqU9NCdffv2TrSiH/Dqhc/aZ+K+UNWC8jXPG8qu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mcxA8pfd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mcxA8pfd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33287C19421;
	Wed,  8 Apr 2026 18:19:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672351;
	bh=u5edfsdbfmvxbFPDeKbQi+yymC+G8keo9lTBbMuQ9no=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mcxA8pfd4/CRK7sg7PsM+aUUoZ9yEGkSfygrZsMRMGBViROMaeEqN4j/bdsz61g0t
	 2aHpE587w4rK4R6WdySipWzXMKtKoAC7Qs6UfYyZ1hTc9eZQCzQBLeqBgyD7JrIsgO
	 UgZSwXVeIzRhx0iDSIwMVNbkN+uK7wQXlqSuQTjM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Yan <yanaijie@huawei.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 286/312] ext4: factor out ext4_percpu_param_init() and ext4_percpu_param_destroy()
Date: Wed,  8 Apr 2026 20:03:23 +0200
Message-ID: <20260408175944.440096762@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Yan <yanaijie@huawei.com>

[ Upstream commit 1f79467c8a6be64940a699de1bd43338a6dd9fdd ]

Factor out ext4_percpu_param_init() and ext4_percpu_param_destroy(). And
also use ext4_percpu_param_destroy() in ext4_put_super() to avoid
duplicated code. No functional change.

Signed-off-by: Jason Yan <yanaijie@huawei.com>
Link: https://lore.kernel.org/r/20230323140517.1070239-3-yanaijie@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Stable-dep-of: 496bb99b7e66 ("ext4: fix the might_sleep() warnings in kvfree()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/super.c |   85 ++++++++++++++++++++++++++++++--------------------------
 1 file changed, 46 insertions(+), 39 deletions(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1193,6 +1193,49 @@ static inline void ext4_quota_off_umount
 }
 #endif
 
+static int ext4_percpu_param_init(struct ext4_sb_info *sbi)
+{
+	ext4_fsblk_t block;
+	int err;
+
+	block = ext4_count_free_clusters(sbi->s_sb);
+	ext4_free_blocks_count_set(sbi->s_es, EXT4_C2B(sbi, block));
+	err = percpu_counter_init(&sbi->s_freeclusters_counter, block,
+				  GFP_KERNEL);
+	if (!err) {
+		unsigned long freei = ext4_count_free_inodes(sbi->s_sb);
+		sbi->s_es->s_free_inodes_count = cpu_to_le32(freei);
+		err = percpu_counter_init(&sbi->s_freeinodes_counter, freei,
+					  GFP_KERNEL);
+	}
+	if (!err)
+		err = percpu_counter_init(&sbi->s_dirs_counter,
+					  ext4_count_dirs(sbi->s_sb), GFP_KERNEL);
+	if (!err)
+		err = percpu_counter_init(&sbi->s_dirtyclusters_counter, 0,
+					  GFP_KERNEL);
+	if (!err)
+		err = percpu_counter_init(&sbi->s_sra_exceeded_retry_limit, 0,
+					  GFP_KERNEL);
+	if (!err)
+		err = percpu_init_rwsem(&sbi->s_writepages_rwsem);
+
+	if (err)
+		ext4_msg(sbi->s_sb, KERN_ERR, "insufficient memory");
+
+	return err;
+}
+
+static void ext4_percpu_param_destroy(struct ext4_sb_info *sbi)
+{
+	percpu_counter_destroy(&sbi->s_freeclusters_counter);
+	percpu_counter_destroy(&sbi->s_freeinodes_counter);
+	percpu_counter_destroy(&sbi->s_dirs_counter);
+	percpu_counter_destroy(&sbi->s_dirtyclusters_counter);
+	percpu_counter_destroy(&sbi->s_sra_exceeded_retry_limit);
+	percpu_free_rwsem(&sbi->s_writepages_rwsem);
+}
+
 static void ext4_put_super(struct super_block *sb)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
@@ -1259,12 +1302,7 @@ static void ext4_put_super(struct super_
 		kvfree(flex_groups);
 	}
 	rcu_read_unlock();
-	percpu_counter_destroy(&sbi->s_freeclusters_counter);
-	percpu_counter_destroy(&sbi->s_freeinodes_counter);
-	percpu_counter_destroy(&sbi->s_dirs_counter);
-	percpu_counter_destroy(&sbi->s_dirtyclusters_counter);
-	percpu_counter_destroy(&sbi->s_sra_exceeded_retry_limit);
-	percpu_free_rwsem(&sbi->s_writepages_rwsem);
+	ext4_percpu_param_destroy(sbi);
 #ifdef CONFIG_QUOTA
 	for (i = 0; i < EXT4_MAXQUOTAS; i++)
 		kfree(get_qf_name(sb, sbi, i));
@@ -5088,7 +5126,6 @@ static int __ext4_fill_super(struct fs_c
 	struct ext4_super_block *es = NULL;
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	struct flex_groups **flex_groups;
-	ext4_fsblk_t block;
 	ext4_fsblk_t logical_sb_block;
 	struct inode *root;
 	int ret = -ENOMEM;
@@ -5496,33 +5533,8 @@ static int __ext4_fill_super(struct fs_c
 		sbi->s_journal->j_commit_callback =
 			ext4_journal_commit_callback;
 
-	block = ext4_count_free_clusters(sb);
-	ext4_free_blocks_count_set(sbi->s_es,
-				   EXT4_C2B(sbi, block));
-	err = percpu_counter_init(&sbi->s_freeclusters_counter, block,
-				  GFP_KERNEL);
-	if (!err) {
-		unsigned long freei = ext4_count_free_inodes(sb);
-		sbi->s_es->s_free_inodes_count = cpu_to_le32(freei);
-		err = percpu_counter_init(&sbi->s_freeinodes_counter, freei,
-					  GFP_KERNEL);
-	}
-	if (!err)
-		err = percpu_counter_init(&sbi->s_dirs_counter,
-					  ext4_count_dirs(sb), GFP_KERNEL);
-	if (!err)
-		err = percpu_counter_init(&sbi->s_dirtyclusters_counter, 0,
-					  GFP_KERNEL);
-	if (!err)
-		err = percpu_counter_init(&sbi->s_sra_exceeded_retry_limit, 0,
-					  GFP_KERNEL);
-	if (!err)
-		err = percpu_init_rwsem(&sbi->s_writepages_rwsem);
-
-	if (err) {
-		ext4_msg(sb, KERN_ERR, "insufficient memory");
+	if (ext4_percpu_param_init(sbi))
 		goto failed_mount6;
-	}
 
 	if (ext4_has_feature_flex_bg(sb))
 		if (!ext4_fill_flex_info(sb)) {
@@ -5613,12 +5625,7 @@ failed_mount6:
 		kvfree(flex_groups);
 	}
 	rcu_read_unlock();
-	percpu_counter_destroy(&sbi->s_freeclusters_counter);
-	percpu_counter_destroy(&sbi->s_freeinodes_counter);
-	percpu_counter_destroy(&sbi->s_dirs_counter);
-	percpu_counter_destroy(&sbi->s_dirtyclusters_counter);
-	percpu_counter_destroy(&sbi->s_sra_exceeded_retry_limit);
-	percpu_free_rwsem(&sbi->s_writepages_rwsem);
+	ext4_percpu_param_destroy(sbi);
 failed_mount5:
 	ext4_ext_release(sb);
 	ext4_release_system_zone(sb);


