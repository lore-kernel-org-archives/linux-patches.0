Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B554533B6F0;
	Fri,  9 Jan 2026 12:21:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961305; cv=none; b=awVa2/ejhCBZvys4zG3VPQca9+0Fd5h3ka20LwBHck9OPuIy+1TLrR/H5dqLI/P34D4HEI0kYdA5DvHwPrDe2wosX0wGdEuiujOy8JuRvC7tVoE38avgoEMvhQxal0bCKCYVvtmeligM9MZ7Dd7gsyr/+wdWCFoAHTbXw1imv6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961305; c=relaxed/simple;
	bh=btnDQ4kge5eeAtX3YOogmvsmpnXwfvLsQcvvP2cg2Ds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ErYoMrYnZpB6co51ijD6F9A9t85UguyHeHu3UN91M6o9i4shClz0wDqzRKjz+z6xqYWm2+bZ/831n9uSEPxae1+g52vqkYg+QHCEVSEHo/37gdRPvSopunsZ0fPKIzhn0v8NNymEDIuCy9vpxjQgu2kvLWobTVmVVSXQBQGCKqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yY9M7Fii; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yY9M7Fii"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 384DAC4CEF1;
	Fri,  9 Jan 2026 12:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961305;
	bh=btnDQ4kge5eeAtX3YOogmvsmpnXwfvLsQcvvP2cg2Ds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yY9M7Fii9TKMJRZPGKj983SA1zoCf3s+0LQfEhu/uhhD22d09vOu5ZDKolLF7mw3f
	 Vc3QD3h63I/fWJzTEZiKfTYQtk7W2aB4McBlzU8nqfagXwarpOmzRkPQMuShIIZn0M
	 ppyyY509gT/ykqeqx/Iyd7uNWcZEjU7Dfx7nEvhI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabriel Krisman Bertazi <krisman@suse.de>,
	Theodore Tso <tytso@mit.edu>,
	Ankan Biswas <spyjetfayed@gmail.com>
Subject: [PATCH 6.6 675/737] ext4: fix error message when rejecting the default hash
Date: Fri,  9 Jan 2026 12:43:34 +0100
Message-ID: <20260109112159.443868142@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
[ The commit a2187431c395 intended to remove the if-block which was used
  for an old SIPHASH rejection check. ]
Signed-off-by: Ankan Biswas <spyjetfayed@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/ext4.h  |    1 +
 fs/ext4/super.c |   20 +++++++++++++++++---
 2 files changed, 18 insertions(+), 3 deletions(-)

--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2459,6 +2459,7 @@ static inline __le16 ext4_rec_len_to_dis
 #define DX_HASH_HALF_MD4_UNSIGNED	4
 #define DX_HASH_TEA_UNSIGNED		5
 #define DX_HASH_SIPHASH			6
+#define DX_HASH_LAST 			DX_HASH_SIPHASH
 
 static inline u32 ext4_chksum(struct ext4_sb_info *sbi, u32 crc,
 			      const void *address, unsigned int length)
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5140,16 +5140,27 @@ out:
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
@@ -5167,6 +5178,7 @@ static void ext4_hash_info_init(struct s
 #endif
 		}
 	}
+	return 0;
 }
 
 static int ext4_block_group_meta_init(struct super_block *sb, int silent)
@@ -5311,7 +5323,9 @@ static int __ext4_fill_super(struct fs_c
 	if (err)
 		goto failed_mount;
 
-	ext4_hash_info_init(sb);
+	err = ext4_hash_info_init(sb);
+	if (err)
+		goto failed_mount;
 
 	err = ext4_handle_clustersize(sb);
 	if (err)


