Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE68B35B157;
	Fri,  9 Jan 2026 12:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767963167; cv=none; b=Ss1vWNoKF3Rwzt33HhTxw7krCtmUIrVo6CQ5wDJIwKiAVR3cEB+g8+WiRnOtwIMGxKdMKAw3CVsOxHFcm9Fw8kLBJIiYPARCiQFz0RHw8oQFs5BSYrP6c+7iNLhw7SmmQ3OjDxZ3F2bwNry8nKhgZi5PP/6AP4lK6YXJRZNaX28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767963167; c=relaxed/simple;
	bh=dEujkZ7dNVwNB+hvAoQdbU8e9FmBwYVjUmfw2I24cGA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rVs0nPbCcqABHu4oRGp7XVo/f3wtM9t1cvaYBsCDx36hZQpGWYkrVOp+lgEiAaic/QurOE1HCOVI1no7f39XKCm/loeHHrM7wlJhqcVUGuiK6TykeDb0Ree80E1HWJ2wtf7S9brQO1iXyZWhw7f1iaNZE19tafy0X26DrO9nm+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1oCBP27V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1oCBP27V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F86CC4CEF1;
	Fri,  9 Jan 2026 12:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767963166;
	bh=dEujkZ7dNVwNB+hvAoQdbU8e9FmBwYVjUmfw2I24cGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1oCBP27VEdmm+sLkhI9o9AaRsI8pib3KvxDsuEvz5G2IMzDgKtb7mu+aZq5r92uuP
	 GcLmVQ2vwbh5xoue3kPSJAUf2syHn8GKmyQU6pDh6dq7gHLWFZQuw8alEss5jUHDcP
	 l16gldI/R27AWTYuK6S5tcxEZatQ47ssMvgDpiUQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabriel Krisman Bertazi <krisman@suse.de>,
	Theodore Tso <tytso@mit.edu>,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Subject: [PATCH 6.1 620/634] ext4: fix error message when rejecting the default hash
Date: Fri,  9 Jan 2026 12:44:58 +0100
Message-ID: <20260109112140.966967003@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

From: Gabriel Krisman Bertazi <krisman@suse.de>

commit a2187431c395cdfbf144e3536f25468c64fc7cfa upstream.

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
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/ext4.h  |    1 +
 fs/ext4/super.c |   28 +++++++++++++++++-----------
 2 files changed, 18 insertions(+), 11 deletions(-)

--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2460,6 +2460,7 @@ static inline __le16 ext4_rec_len_to_dis
 #define DX_HASH_HALF_MD4_UNSIGNED	4
 #define DX_HASH_TEA_UNSIGNED		5
 #define DX_HASH_SIPHASH			6
+#define DX_HASH_LAST 			DX_HASH_SIPHASH
 
 static inline u32 ext4_chksum(struct ext4_sb_info *sbi, u32 crc,
 			      const void *address, unsigned int length)
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3552,14 +3552,6 @@ int ext4_feature_set_ok(struct super_blo
 	}
 #endif
 
-	if (EXT4_SB(sb)->s_es->s_def_hash_version == DX_HASH_SIPHASH &&
-	    !ext4_has_feature_casefold(sb)) {
-		ext4_msg(sb, KERN_ERR,
-			 "Filesystem without casefold feature cannot be "
-			 "mounted with siphash");
-		return 0;
-	}
-
 	if (readonly)
 		return 1;
 
@@ -5043,16 +5035,27 @@ out:
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
@@ -5070,6 +5073,7 @@ static void ext4_hash_info_init(struct s
 #endif
 		}
 	}
+	return 0;
 }
 
 static int __ext4_fill_super(struct fs_context *fc, struct super_block *sb)
@@ -5224,7 +5228,9 @@ static int __ext4_fill_super(struct fs_c
 	sbi->s_addr_per_block_bits = ilog2(EXT4_ADDR_PER_BLOCK(sb));
 	sbi->s_desc_per_block_bits = ilog2(EXT4_DESC_PER_BLOCK(sb));
 
-	ext4_hash_info_init(sb);
+	err = ext4_hash_info_init(sb);
+	if (err)
+		goto failed_mount;
 
 	if (ext4_handle_clustersize(sb))
 		goto failed_mount;


