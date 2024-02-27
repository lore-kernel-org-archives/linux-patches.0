Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8FB513B2B9;
	Tue, 27 Feb 2024 14:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042668; cv=none; b=jQNesmENxhbgXMP+1dhx1X6aLf91q0FIihmrTW/ifWvz9jZ92Tv/uwytHDbuA6+hgVvWLfmEcFXeS69l75Ue5F0atRYXRjQRVpFyFj9hWVriTSm9tR8l58GuUMWux3ytvCKaEB4LyNnhTWOpM7k5pTxcebbLsBpxbtKSSNyR3u8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042668; c=relaxed/simple;
	bh=NeDzPS/Gy8vNwEXXiK7bMIRfDVUrhBaUXRVsGAIb12E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fuIhQyo7rpH3uxO8wlzg6yvTR+BHui7cvhDr897bX+4xgkoIcXC+D6W/4FUV9K5vxD7DYp3LF8eFSpDBKafLiPyZqjURjvTqdJYPMBCN5XBUViIFBEyKPqHpKpaeLf7WYGPMmrzYL0Dndi7ieQ3cGBNGCWoHndLVPLJuR+dqctw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZQKYmV8f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZQKYmV8f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 390D6C433C7;
	Tue, 27 Feb 2024 14:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042668;
	bh=NeDzPS/Gy8vNwEXXiK7bMIRfDVUrhBaUXRVsGAIb12E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZQKYmV8fEra8ZQf/1gZINvoXNFFIHl/70ekLMOkQnCEtzymOBRKJdc6UuiJaBQsxa
	 vk+uHZNkMLMKI5UAbXCY28APqOydHGJ8r3rPF3qniQtim/gZwUntpIPQXJWAFzZbjk
	 0wkENvIj/62Pj4RSEvXnfY1dE4e4+W3Be1XxRFJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 060/245] fs/ntfs3: Prevent generic message "attempt to access beyond end of device"
Date: Tue, 27 Feb 2024 14:24:08 +0100
Message-ID: <20240227131617.193290634@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit 5ca87d01eba7bdfe9536a157ca33c1455bb8d16c ]

It used in test environment.

Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/fsntfs.c  | 24 ++++++++++++++++++++++++
 fs/ntfs3/ntfs_fs.h | 14 +-------------
 2 files changed, 25 insertions(+), 13 deletions(-)

diff --git a/fs/ntfs3/fsntfs.c b/fs/ntfs3/fsntfs.c
index 110690edbf621..1b082b7a67ee2 100644
--- a/fs/ntfs3/fsntfs.c
+++ b/fs/ntfs3/fsntfs.c
@@ -981,6 +981,30 @@ static inline __le32 security_hash(const void *sd, size_t bytes)
 	return cpu_to_le32(hash);
 }
 
+/*
+ * simple wrapper for sb_bread_unmovable.
+ */
+struct buffer_head *ntfs_bread(struct super_block *sb, sector_t block)
+{
+	struct ntfs_sb_info *sbi = sb->s_fs_info;
+	struct buffer_head *bh;
+
+	if (unlikely(block >= sbi->volume.blocks)) {
+		/* prevent generic message "attempt to access beyond end of device" */
+		ntfs_err(sb, "try to read out of volume at offset 0x%llx",
+			 (u64)block << sb->s_blocksize_bits);
+		return NULL;
+	}
+
+	bh = sb_bread_unmovable(sb, block);
+	if (bh)
+		return bh;
+
+	ntfs_err(sb, "failed to read volume at offset 0x%llx",
+		 (u64)block << sb->s_blocksize_bits);
+	return NULL;
+}
+
 int ntfs_sb_read(struct super_block *sb, u64 lbo, size_t bytes, void *buffer)
 {
 	struct block_device *bdev = sb->s_bdev;
diff --git a/fs/ntfs3/ntfs_fs.h b/fs/ntfs3/ntfs_fs.h
index ffc8dfbb310ff..12a3b41d351c9 100644
--- a/fs/ntfs3/ntfs_fs.h
+++ b/fs/ntfs3/ntfs_fs.h
@@ -581,6 +581,7 @@ bool check_index_header(const struct INDEX_HDR *hdr, size_t bytes);
 int log_replay(struct ntfs_inode *ni, bool *initialized);
 
 /* Globals from fsntfs.c */
+struct buffer_head *ntfs_bread(struct super_block *sb, sector_t block);
 bool ntfs_fix_pre_write(struct NTFS_RECORD_HEADER *rhdr, size_t bytes);
 int ntfs_fix_post_read(struct NTFS_RECORD_HEADER *rhdr, size_t bytes,
 		       bool simple);
@@ -1011,19 +1012,6 @@ static inline u64 bytes_to_block(const struct super_block *sb, u64 size)
 	return (size + sb->s_blocksize - 1) >> sb->s_blocksize_bits;
 }
 
-static inline struct buffer_head *ntfs_bread(struct super_block *sb,
-					     sector_t block)
-{
-	struct buffer_head *bh = sb_bread_unmovable(sb, block);
-
-	if (bh)
-		return bh;
-
-	ntfs_err(sb, "failed to read volume at offset 0x%llx",
-		 (u64)block << sb->s_blocksize_bits);
-	return NULL;
-}
-
 static inline struct ntfs_inode *ntfs_i(struct inode *inode)
 {
 	return container_of(inode, struct ntfs_inode, vfs_inode);
-- 
2.43.0



