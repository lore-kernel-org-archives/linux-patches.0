Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01274611B
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:41:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84AA1C433D2;
	Sun, 28 May 2023 19:41:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685302869;
	bh=Vn2iljI9e0T/K28XJB0twwjZtWRTFI02ulin/D1OkJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ly5xfCOOdHV4hBep6N8otWptOkodINQXXJVO+Ot5emx0H1++1h/qyBY0j3NuaeEPn
	 C4cmI/qbB8btqn0eGaguAY8wN2eVfViSs6vFQQKPD3jfZnY8pJGYbAOkEcTDXl7gKi
	 7ksMUeoVKVIj9U4KJG8jIjgWNB2uDCpQkcRstfxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 022/211] ext4: reflect error codes from ext4_multi_mount_protect() to its callers
Date: Sun, 28 May 2023 20:09:03 +0100
Message-Id: <20230528190844.074758468@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190843.514829708@linuxfoundation.org>
References: <20230528190843.514829708@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Theodore Ts'o <tytso@mit.edu>

[ Upstream commit 3b50d5018ed06a647bb26c44bb5ae74e59c903c7 ]

This will allow more fine-grained errno codes to be returned by the
mount system call.

Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Stable-dep-of: a44be64bbecb ("ext4: don't clear SB_RDONLY when remounting r/w until quota is re-enabled")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/mmp.c   |  9 ++++++++-
 fs/ext4/super.c | 16 +++++++++-------
 2 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/fs/ext4/mmp.c b/fs/ext4/mmp.c
index bc364c119af6a..92c863fd9a78d 100644
--- a/fs/ext4/mmp.c
+++ b/fs/ext4/mmp.c
@@ -290,6 +290,7 @@ int ext4_multi_mount_protect(struct super_block *sb,
 	if (mmp_block < le32_to_cpu(es->s_first_data_block) ||
 	    mmp_block >= ext4_blocks_count(es)) {
 		ext4_warning(sb, "Invalid MMP block in superblock");
+		retval = -EINVAL;
 		goto failed;
 	}
 
@@ -315,6 +316,7 @@ int ext4_multi_mount_protect(struct super_block *sb,
 
 	if (seq == EXT4_MMP_SEQ_FSCK) {
 		dump_mmp_msg(sb, mmp, "fsck is running on the filesystem");
+		retval = -EBUSY;
 		goto failed;
 	}
 
@@ -328,6 +330,7 @@ int ext4_multi_mount_protect(struct super_block *sb,
 
 	if (schedule_timeout_interruptible(HZ * wait_time) != 0) {
 		ext4_warning(sb, "MMP startup interrupted, failing mount\n");
+		retval = -ETIMEDOUT;
 		goto failed;
 	}
 
@@ -338,6 +341,7 @@ int ext4_multi_mount_protect(struct super_block *sb,
 	if (seq != le32_to_cpu(mmp->mmp_seq)) {
 		dump_mmp_msg(sb, mmp,
 			     "Device is already active on another node.");
+		retval = -EBUSY;
 		goto failed;
 	}
 
@@ -357,6 +361,7 @@ int ext4_multi_mount_protect(struct super_block *sb,
 	 */
 	if (schedule_timeout_interruptible(HZ * wait_time) != 0) {
 		ext4_warning(sb, "MMP startup interrupted, failing mount");
+		retval = -ETIMEDOUT;
 		goto failed;
 	}
 
@@ -367,6 +372,7 @@ int ext4_multi_mount_protect(struct super_block *sb,
 	if (seq != le32_to_cpu(mmp->mmp_seq)) {
 		dump_mmp_msg(sb, mmp,
 			     "Device is already active on another node.");
+		retval = -EBUSY;
 		goto failed;
 	}
 
@@ -383,6 +389,7 @@ int ext4_multi_mount_protect(struct super_block *sb,
 		EXT4_SB(sb)->s_mmp_tsk = NULL;
 		ext4_warning(sb, "Unable to create kmmpd thread for %s.",
 			     sb->s_id);
+		retval = -ENOMEM;
 		goto failed;
 	}
 
@@ -390,5 +397,5 @@ int ext4_multi_mount_protect(struct super_block *sb,
 
 failed:
 	brelse(bh);
-	return 1;
+	return retval;
 }
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index d75aa45a846d1..edd1409663932 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4777,9 +4777,11 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 	needs_recovery = (es->s_last_orphan != 0 ||
 			  ext4_has_feature_journal_needs_recovery(sb));
 
-	if (ext4_has_feature_mmp(sb) && !sb_rdonly(sb))
-		if (ext4_multi_mount_protect(sb, le64_to_cpu(es->s_mmp_block)))
+	if (ext4_has_feature_mmp(sb) && !sb_rdonly(sb)) {
+		err = ext4_multi_mount_protect(sb, le64_to_cpu(es->s_mmp_block));
+		if (err)
 			goto failed_mount3a;
+	}
 
 	/*
 	 * The first inode we look at is the journal inode.  Don't try
@@ -5988,12 +5990,12 @@ static int ext4_remount(struct super_block *sb, int *flags, char *data)
 				goto restore_opts;
 
 			sb->s_flags &= ~SB_RDONLY;
-			if (ext4_has_feature_mmp(sb))
-				if (ext4_multi_mount_protect(sb,
-						le64_to_cpu(es->s_mmp_block))) {
-					err = -EROFS;
+			if (ext4_has_feature_mmp(sb)) {
+				err = ext4_multi_mount_protect(sb,
+						le64_to_cpu(es->s_mmp_block));
+				if (err)
 					goto restore_opts;
-				}
+			}
 #ifdef CONFIG_QUOTA
 			enable_quota = 1;
 #endif
-- 
2.39.2



