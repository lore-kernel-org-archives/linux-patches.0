Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8C081DF27C;
	Tue,  8 Oct 2024 12:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392156; cv=none; b=apgQO4eQqBBxLAMG5nJ7/x8adBXgUwC1QtaEAKI3HUefYkDuM3yD8mp9kc6e7/tJ/xkFfhXQpGty0AGh8VracKAXglg7Jen6KjZPsf8Cn0G1u8iwzfLNlfkbwz/QwP3tIb6wABre7TTKw5TsLIAUW1dLwP0BbzF5qLJ2mbyS9GI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392156; c=relaxed/simple;
	bh=8vOaPVSZShk7w7tVhzMr7X8e6V9x/FMlidK4LM2FbYo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BR5zrf1G0kI/gfIhdhd4bDADqnM0W7jD+CLWz8b2yfmIIQn0d2KNR5VjLtuhXvgLotxA4HG6yOMlJanXIBm4lNt5R0psZuI5cfEjxGZzOGOeUWs5EHQJVa2jSleyY+96Dv322bPBpYBs+rIUIYhT4uMYci+ehPj5vDiF0tiUoQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pDBDQsos; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pDBDQsos"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 499C3C4CEC7;
	Tue,  8 Oct 2024 12:55:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392156;
	bh=8vOaPVSZShk7w7tVhzMr7X8e6V9x/FMlidK4LM2FbYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pDBDQsos/4lZrUeT0OieMbg107LAWhKGOpAlN2jdm4lxOmuMk399+aDHM0xz5CrYi
	 N+n+4ciOnzefyX/AHr2Mycl/4aEbHJDMNC7sMPcaxCxCA4oF253DE9HA/S3GxR4heN
	 KEwnXObVbE3HzXSZsOr+9W+HJRbrUwkS6GeEzLPU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabriel Krisman Bertazi <krisman@suse.de>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 332/558] ext4: fix error message when rejecting the default hash
Date: Tue,  8 Oct 2024 14:06:02 +0200
Message-ID: <20241008115715.369198435@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabriel Krisman Bertazi <krisman@suse.de>

[ Upstream commit a2187431c395cdfbf144e3536f25468c64fc7cfa ]

Commit 985b67cd8639 ("ext4: filesystems without casefold feature cannot
be mounted with siphash") properly rejects volumes where
s_def_hash_version is set to DX_HASH_SIPHASH, but the check and the
error message should not look into casefold setup - a filesystem should
never have DX_HASH_SIPHASH as the default hash.  Fix it and, since we
are there, move the check to ext4_hash_info_init.

Fixes:985b67cd8639 ("ext4: filesystems without casefold feature cannot
be mounted with siphash")

Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
Link: https://patch.msgid.link/87jzg1en6j.fsf_-_@mailhost.krisman.be
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/ext4.h  |  1 +
 fs/ext4/super.c | 27 +++++++++++++++++----------
 2 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 08acd152261ed..8bd302392d759 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2462,6 +2462,7 @@ static inline __le16 ext4_rec_len_to_disk(unsigned len, unsigned blocksize)
 #define DX_HASH_HALF_MD4_UNSIGNED	4
 #define DX_HASH_TEA_UNSIGNED		5
 #define DX_HASH_SIPHASH			6
+#define DX_HASH_LAST 			DX_HASH_SIPHASH
 
 static inline u32 ext4_chksum(struct ext4_sb_info *sbi, u32 crc,
 			      const void *address, unsigned int length)
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index b3f47d6879ebf..1cd4e20cc320d 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3583,13 +3583,6 @@ int ext4_feature_set_ok(struct super_block *sb, int readonly)
 			 "mounted without CONFIG_UNICODE");
 		return 0;
 	}
-	if (EXT4_SB(sb)->s_es->s_def_hash_version == DX_HASH_SIPHASH &&
-	    !ext4_has_feature_casefold(sb)) {
-		ext4_msg(sb, KERN_ERR,
-			 "Filesystem without casefold feature cannot be "
-			 "mounted with siphash");
-		return 0;
-	}
 
 	if (readonly)
 		return 1;
@@ -5095,16 +5088,27 @@ static int ext4_load_super(struct super_block *sb, ext4_fsblk_t *lsb,
 	return ret;
 }
 
-static void ext4_hash_info_init(struct super_block *sb)
+static int ext4_hash_info_init(struct super_block *sb)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	struct ext4_super_block *es = sbi->s_es;
 	unsigned int i;
 
+	sbi->s_def_hash_version = es->s_def_hash_version;
+
+	if (sbi->s_def_hash_version > DX_HASH_LAST) {
+		ext4_msg(sb, KERN_ERR,
+			 "Invalid default hash set in the superblock");
+		return -EINVAL;
+	} else if (sbi->s_def_hash_version == DX_HASH_SIPHASH) {
+		ext4_msg(sb, KERN_ERR,
+			 "SIPHASH is not a valid default hash value");
+		return -EINVAL;
+	}
+
 	for (i = 0; i < 4; i++)
 		sbi->s_hash_seed[i] = le32_to_cpu(es->s_hash_seed[i]);
 
-	sbi->s_def_hash_version = es->s_def_hash_version;
 	if (ext4_has_feature_dir_index(sb)) {
 		i = le32_to_cpu(es->s_flags);
 		if (i & EXT2_FLAGS_UNSIGNED_HASH)
@@ -5122,6 +5126,7 @@ static void ext4_hash_info_init(struct super_block *sb)
 #endif
 		}
 	}
+	return 0;
 }
 
 static int ext4_block_group_meta_init(struct super_block *sb, int silent)
@@ -5269,7 +5274,9 @@ static int __ext4_fill_super(struct fs_context *fc, struct super_block *sb)
 	if (err)
 		goto failed_mount;
 
-	ext4_hash_info_init(sb);
+	err = ext4_hash_info_init(sb);
+	if (err)
+		goto failed_mount;
 
 	err = ext4_handle_clustersize(sb);
 	if (err)
-- 
2.43.0



