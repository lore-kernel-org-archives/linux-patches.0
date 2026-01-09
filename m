Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E04833C1A3;
	Fri,  9 Jan 2026 12:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767963164; cv=none; b=Uq8tHU1mTMR2Epn+RFeFPH+S1XFuG7azeW4294RObdNRFF1n7FlL8Pip2GNY+LSX4fWNXbkLFVgyssTJq6aZtnoYS6psABb6XZbRdZZ0zEKFjpFouTJKhTzi45PSXjxbvw8KIOyNvi66pjVycSajhD6W/4aiEiQImUyxcr3a+Fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767963164; c=relaxed/simple;
	bh=xh7u64xJz7+kVTAvmxPZ14gQkQofA+TGuYZyFnZSh7k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NMfp/S+7KSrDmAgpgGTTOt2++LMOmNaS91NqejpyC+OyIV6dAkPyIy1B7qH5IoMNbme2AA5/dEJ0ZVhSCJ9OtcY3tuw0Zje6tZKBk7YzQcMSsWQehsXSR4mWtggX/TKS3/Hxet31GEWumqdumzA1ROFS6L9dj4gL/+LnBP1oPoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fr/yPeEz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fr/yPeEz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A14C2C4CEF1;
	Fri,  9 Jan 2026 12:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767963164;
	bh=xh7u64xJz7+kVTAvmxPZ14gQkQofA+TGuYZyFnZSh7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fr/yPeEzhkGR+uzp/MEZZCarv0LDy4b9RDJTnj5NeLYwLMECMcSrbH9lFTXApG8th
	 pzhsRzgeRrfByMH9iyIlKuMjnkkmfNGwCLLf0/zU8fAfCTcNH8wZqTxH56NSXtKBq0
	 kdscmRP+n4dj/X8hqnZtRL9Dn3pwnyqny7jP7HRM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Yan <yanaijie@huawei.com>,
	Theodore Tso <tytso@mit.edu>,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Subject: [PATCH 6.1 619/634] ext4: factor out ext4_hash_info_init()
Date: Fri,  9 Jan 2026 12:44:57 +0100
Message-ID: <20260109112140.929427075@linuxfoundation.org>
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

From: Jason Yan <yanaijie@huawei.com>

commit db9345d9e6f075e1ec26afadf744078ead935fec upstream.

Factor out ext4_hash_info_init() to simplify __ext4_fill_super(). No
functional change.

Signed-off-by: Jason Yan <yanaijie@huawei.com>
Link: https://lore.kernel.org/r/20230323140517.1070239-2-yanaijie@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Stable-dep-of: a2187431c395 ("ext4: fix error message when rejecting the default hash")
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/super.c |   50 ++++++++++++++++++++++++++++++--------------------
 1 file changed, 30 insertions(+), 20 deletions(-)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -5043,6 +5043,35 @@ out:
 	return ret;
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
 static int __ext4_fill_super(struct fs_context *fc, struct super_block *sb)
 {
 	struct ext4_super_block *es = NULL;
@@ -5195,26 +5224,7 @@ static int __ext4_fill_super(struct fs_c
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
 
 	if (ext4_handle_clustersize(sb))
 		goto failed_mount;


