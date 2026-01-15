Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFAE126CE04;
	Thu, 15 Jan 2026 17:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768498715; cv=none; b=F8CBiFXJ+YJPIhuELcbaIXh3vgSFhxj5FWtsbmFgSzfTBLixQzx0kV2vKGjda+74+G2VXxiIHdYSd/e46oUHD7g8DE9/o+VcNFCee1t7weDd9n/XttyYLAp3WrI42x76m+w7Gh0FSXmUTAb+43aYk7wEfRwA6GTmaDP7mFfTTFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768498715; c=relaxed/simple;
	bh=zGzw/8l5s7BXgrp95t8Z47XklL/n7SlmTG8nwLOtbmI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CIdwf4+AYtfSYEgP3dAKDiG4KOjLOPrdI3EbtKQm0zzSWoi887IXAvBrune1SIsOaPNFbMCUfW5b9SBbzPU6KnFnQRQ+oTGgCwH1sGJDb3jvN9LwWQxOCvgJiIrVHZFZ6X82eKj2xdP1IWMO4BP21e+LLtwrI0gBfS1HaxkPdns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nsREkB2f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nsREkB2f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A26BC116D0;
	Thu, 15 Jan 2026 17:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768498714;
	bh=zGzw/8l5s7BXgrp95t8Z47XklL/n7SlmTG8nwLOtbmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nsREkB2fBkZtwiLLD7Vpwqy0/HU8bXXSd7kOk1sdW4tSycaPJU6TZ40gZZGb0qnkF
	 fFs/3UMqO87HLahtq0cv35TEDAuVxGKUZG7NtnmN/YpzsOOu1Ksq4pC/zr4g8fR9K7
	 SxCxip8aSlDvDqZs16huHNwOecm0PKh2ZTg3+/aI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Yan <yanaijie@huawei.com>,
	Theodore Tso <tytso@mit.edu>,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Subject: [PATCH 5.15 495/554] ext4: factor out ext4_hash_info_init()
Date: Thu, 15 Jan 2026 17:49:21 +0100
Message-ID: <20260115164304.235360620@linuxfoundation.org>
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

From: Jason Yan <yanaijie@huawei.com>

commit db9345d9e6f075e1ec26afadf744078ead935fec upstream.

Factor out ext4_hash_info_init() to simplify __ext4_fill_super(). No
functional change.

Signed-off-by: Jason Yan <yanaijie@huawei.com>
Link: https://lore.kernel.org/r/20230323140517.1070239-2-yanaijie@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Stable-dep-of: a2187431c395 ("ext4: fix error message when rejecting the default hash")
[cascardo: conflicts due to other parts of ext4_fill_super having been factored out]
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/super.c |   50 ++++++++++++++++++++++++++++++--------------------
 1 file changed, 30 insertions(+), 20 deletions(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3897,6 +3897,35 @@ static void ext4_setup_csum_trigger(stru
 	sbi->s_journal_triggers[type].tr_triggers.t_frozen = trigger;
 }
 
+static void ext4_hash_info_init(struct super_block *sb)
+{
+	struct ext4_sb_info *sbi = EXT4_SB(sb);
+	struct ext4_super_block *es = sbi->s_es;
+	unsigned int i;
+
+	for (i = 0; i < 4; i++)
+		sbi->s_hash_seed[i] = le32_to_cpu(es->s_hash_seed[i]);
+
+	sbi->s_def_hash_version = es->s_def_hash_version;
+	if (ext4_has_feature_dir_index(sb)) {
+		i = le32_to_cpu(es->s_flags);
+		if (i & EXT2_FLAGS_UNSIGNED_HASH)
+			sbi->s_hash_unsigned = 3;
+		else if ((i & EXT2_FLAGS_SIGNED_HASH) == 0) {
+#ifdef __CHAR_UNSIGNED__
+			if (!sb_rdonly(sb))
+				es->s_flags |=
+					cpu_to_le32(EXT2_FLAGS_UNSIGNED_HASH);
+			sbi->s_hash_unsigned = 3;
+#else
+			if (!sb_rdonly(sb))
+				es->s_flags |=
+					cpu_to_le32(EXT2_FLAGS_SIGNED_HASH);
+#endif
+		}
+	}
+}
+
 static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 {
 	struct dax_device *dax_dev = fs_dax_get_by_bdev(sb->s_bdev);
@@ -4415,26 +4444,7 @@ static int ext4_fill_super(struct super_
 	sbi->s_addr_per_block_bits = ilog2(EXT4_ADDR_PER_BLOCK(sb));
 	sbi->s_desc_per_block_bits = ilog2(EXT4_DESC_PER_BLOCK(sb));
 
-	for (i = 0; i < 4; i++)
-		sbi->s_hash_seed[i] = le32_to_cpu(es->s_hash_seed[i]);
-	sbi->s_def_hash_version = es->s_def_hash_version;
-	if (ext4_has_feature_dir_index(sb)) {
-		i = le32_to_cpu(es->s_flags);
-		if (i & EXT2_FLAGS_UNSIGNED_HASH)
-			sbi->s_hash_unsigned = 3;
-		else if ((i & EXT2_FLAGS_SIGNED_HASH) == 0) {
-#ifdef __CHAR_UNSIGNED__
-			if (!sb_rdonly(sb))
-				es->s_flags |=
-					cpu_to_le32(EXT2_FLAGS_UNSIGNED_HASH);
-			sbi->s_hash_unsigned = 3;
-#else
-			if (!sb_rdonly(sb))
-				es->s_flags |=
-					cpu_to_le32(EXT2_FLAGS_SIGNED_HASH);
-#endif
-		}
-	}
+	ext4_hash_info_init(sb);
 
 	/* Handle clustersize */
 	clustersize = BLOCK_SIZE << le32_to_cpu(es->s_log_cluster_size);


