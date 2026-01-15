Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E15986334;
	Thu, 15 Jan 2026 17:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498718; cv=none; b=csM9i09A8fQZLo1EPszQnVVIJVse5jTaJgjGXVI5+JwmC8d5ajJeTKPvOuo8ZiYHd1fTxYjyD9NdSkmJVf8Q9otPLHKFR2E63IJ5JEZojueKUpno7E/CyPbA9RVdf3f9dh2V3hOqsBPmS63Luv2EtLcrCfCXAh+0KKnIDMJplu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498718; c=relaxed/simple;
	bh=91Usxfhov88WBwxVaHTDmyUuwGpTVmkm4FXeVwdSjzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=akCIg81XvDz7GdHZZ6fON6wVnbd8GMTf/7+DLHKjTGi3KR7buGV1OTiPRwCLvtLvv3OH06BWr4IFn0qpi310TlaKyIyjH/R4EluYZN122YmieMoYXAmz70tjEIqyQ447u5+H0N7sv5qffCHJuwPWNfP1Sae9n37EuxM/+PtDZAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=twd0WZbG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="twd0WZbG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A8D7C116D0;
	Thu, 15 Jan 2026 17:38:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498717;
	bh=91Usxfhov88WBwxVaHTDmyUuwGpTVmkm4FXeVwdSjzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=twd0WZbGTRjxzMIcLePgZznc/YXvOo4iXLFX5XS4oV1JRC7UbBkwn/oIoWGvemwNO
	 jwn6PyPKtrpqDBZY7GK1Z4VWDM2+VqMm6LHUdE5IYRqLlJ1ZjK7EUqbDwol0wcXQWH
	 3rnYXpC62p5ZKxRIlOOFqC0v7iQutC4q0gVrV0xU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabriel Krisman Bertazi <krisman@suse.de>,
	Theodore Tso <tytso@mit.edu>,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Subject: [PATCH 5.15 496/554] ext4: fix error message when rejecting the default hash
Date: Thu, 15 Jan 2026 17:49:22 +0100
Message-ID: <20260115164304.271655154@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[cascardo: conflicts due to other parts of ext4_fill_super having been factored out]
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/ext4.h  |    1 +
 fs/ext4/super.c |   28 +++++++++++++++++-----------
 2 files changed, 18 insertions(+), 11 deletions(-)

--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2443,6 +2443,7 @@ static inline __le16 ext4_rec_len_to_dis
 #define DX_HASH_HALF_MD4_UNSIGNED	4
 #define DX_HASH_TEA_UNSIGNED		5
 #define DX_HASH_SIPHASH			6
+#define DX_HASH_LAST 			DX_HASH_SIPHASH
 
 static inline u32 ext4_chksum(struct ext4_sb_info *sbi, u32 crc,
 			      const void *address, unsigned int length)
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3191,14 +3191,6 @@ int ext4_feature_set_ok(struct super_blo
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
 
@@ -3897,16 +3889,27 @@ static void ext4_setup_csum_trigger(stru
 	sbi->s_journal_triggers[type].tr_triggers.t_frozen = trigger;
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
@@ -3924,6 +3927,7 @@ static void ext4_hash_info_init(struct s
 #endif
 		}
 	}
+	return 0;
 }
 
 static int ext4_fill_super(struct super_block *sb, void *data, int silent)
@@ -4444,7 +4448,9 @@ static int ext4_fill_super(struct super_
 	sbi->s_addr_per_block_bits = ilog2(EXT4_ADDR_PER_BLOCK(sb));
 	sbi->s_desc_per_block_bits = ilog2(EXT4_DESC_PER_BLOCK(sb));
 
-	ext4_hash_info_init(sb);
+	err = ext4_hash_info_init(sb);
+	if (err)
+		goto failed_mount;
 
 	/* Handle clustersize */
 	clustersize = BLOCK_SIZE << le32_to_cpu(es->s_log_cluster_size);


