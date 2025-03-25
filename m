Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE8F7264A84;
	Tue, 25 Mar 2025 12:25:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905505; cv=none; b=ctL19Cj6J10R6ZPn839T1v/hwwBuTQsvD2yH7SwJIs1Y6FE8WbrJaT9NcPHqGz9TZs+Wx8dNqE4hw6eYYBVxPByXQRVCbG8Ck9CyspDRv9gLweoe5EuWQ16K99/sE8wwsjGWhG31FOVrFTWmHMtz6j9UzvVEYpqgTkjZzClZ32w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905505; c=relaxed/simple;
	bh=dvtPUnsf3ihV9wyzy+fRu6Nn+9wNGptPYroKXgikRPY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UlvIbaiNc1DV/Sy5NL2wvwqnOGOczcE6BJHXW0mJBZPXdgWOjhztpzQJohOfwHWVXUUUJmzWz+VOI/FOYxUSIOn47gtoJPtmFXUNHRXKchffGaUWvta2kjDJO1h834vYLV3BaDmOiLouLN6ZSEDFksTBqUlOUtFjSc+Pm6wrcS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Ej+5wft; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Ej+5wft"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 229E9C4CEEE;
	Tue, 25 Mar 2025 12:25:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905505;
	bh=dvtPUnsf3ihV9wyzy+fRu6Nn+9wNGptPYroKXgikRPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0Ej+5wftqWXdFH3InTGEzzzPB9HB/xSrhqvsk44Y6J6nxxKJbDgh76GzSoZk4H3OD
	 jAgLwIvMJLMb8AtJcdWYZ2Kf4gauasgft+YeMvxTLPKJP/DeZLRtDJD3Rp3q2xgmIZ
	 kWJj+qsQFe+XhCPDTAP7tQev+zE6lGlM7P9noxEw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+478c1bf0e6bf4a8f3a04@syzkaller.appspotmail.com,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Miguel Garcia Roman <miguelgarciaroman8@gmail.com>
Subject: [PATCH 6.1 004/198] fs/ntfs3: Fix shift-out-of-bounds in ntfs_fill_super
Date: Tue, 25 Mar 2025 08:19:26 -0400
Message-ID: <20250325122156.754147964@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122156.633329074@linuxfoundation.org>
References: <20250325122156.633329074@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

commit 91a4b1ee78cb100b19b70f077c247f211110348f upstream.

Reported-by: syzbot+478c1bf0e6bf4a8f3a04@syzkaller.appspotmail.com
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Miguel Garcia Roman <miguelgarciaroman8@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ntfs3/ntfs_fs.h |    2 +
 fs/ntfs3/super.c   |   68 +++++++++++++++++++++++++++++++++++------------------
 2 files changed, 48 insertions(+), 22 deletions(-)

--- a/fs/ntfs3/ntfs_fs.h
+++ b/fs/ntfs3/ntfs_fs.h
@@ -42,9 +42,11 @@ enum utf16_endian;
 #define MINUS_ONE_T			((size_t)(-1))
 /* Biggest MFT / smallest cluster */
 #define MAXIMUM_BYTES_PER_MFT		4096
+#define MAXIMUM_SHIFT_BYTES_PER_MFT	12
 #define NTFS_BLOCKS_PER_MFT_RECORD	(MAXIMUM_BYTES_PER_MFT / 512)
 
 #define MAXIMUM_BYTES_PER_INDEX		4096
+#define MAXIMUM_SHIFT_BYTES_PER_INDEX	12
 #define NTFS_BLOCKS_PER_INODE		(MAXIMUM_BYTES_PER_INDEX / 512)
 
 /* NTFS specific error code when fixup failed. */
--- a/fs/ntfs3/super.c
+++ b/fs/ntfs3/super.c
@@ -680,7 +680,7 @@ static u32 true_sectors_per_clst(const s
  * ntfs_init_from_boot - Init internal info from on-disk boot sector.
  */
 static int ntfs_init_from_boot(struct super_block *sb, u32 sector_size,
-			       u64 dev_size)
+		  u64 dev_size)
 {
 	struct ntfs_sb_info *sbi = sb->s_fs_info;
 	int err;
@@ -705,12 +705,12 @@ static int ntfs_init_from_boot(struct su
 
 	/* 0x55AA is not mandaroty. Thanks Maxim Suhanov*/
 	/*if (0x55 != boot->boot_magic[0] || 0xAA != boot->boot_magic[1])
-	 *	goto out;
+	 *  goto out;
 	 */
 
 	boot_sector_size = (u32)boot->bytes_per_sector[1] << 8;
 	if (boot->bytes_per_sector[0] || boot_sector_size < SECTOR_SIZE ||
-	    !is_power_of_2(boot_sector_size)) {
+		!is_power_of_2(boot_sector_size)) {
 		goto out;
 	}
 
@@ -733,15 +733,49 @@ static int ntfs_init_from_boot(struct su
 
 	/* Check MFT record size. */
 	if ((boot->record_size < 0 &&
-	     SECTOR_SIZE > (2U << (-boot->record_size))) ||
-	    (boot->record_size >= 0 && !is_power_of_2(boot->record_size))) {
+		 SECTOR_SIZE > (2U << (-boot->record_size))) ||
+		(boot->record_size >= 0 && !is_power_of_2(boot->record_size))) {
+		goto out;
+	}
+
+	/* Calculate cluster size */
+	sbi->cluster_size = boot_sector_size * sct_per_clst;
+	sbi->cluster_bits = blksize_bits(sbi->cluster_size);
+
+	if (boot->record_size >= 0) {
+		record_size = (u32)boot->record_size << sbi->cluster_bits;
+	} else if (-boot->record_size <= MAXIMUM_SHIFT_BYTES_PER_MFT) {
+		record_size = 1u << (-boot->record_size);
+	} else {
+		ntfs_err(sb, "%s: invalid record size %d.", "NTFS",
+			 boot->record_size);
+		goto out;
+	}
+
+	sbi->record_size = record_size;
+	sbi->record_bits = blksize_bits(record_size);
+	sbi->attr_size_tr = (5 * record_size >> 4); // ~320 bytes
+
+	if (record_size > MAXIMUM_BYTES_PER_MFT) {
+		ntfs_err(sb, "Unsupported bytes per MFT record %u.",
+			 record_size);
+		goto out;
+	}
+
+	if (boot->index_size >= 0) {
+		sbi->index_size = (u32)boot->index_size << sbi->cluster_bits;
+	} else if (-boot->index_size <= MAXIMUM_SHIFT_BYTES_PER_INDEX) {
+		sbi->index_size = 1u << (-boot->index_size);
+	} else {
+		ntfs_err(sb, "%s: invalid index size %d.", "NTFS",
+			 boot->index_size);
 		goto out;
 	}
 
 	/* Check index record size. */
 	if ((boot->index_size < 0 &&
-	     SECTOR_SIZE > (2U << (-boot->index_size))) ||
-	    (boot->index_size >= 0 && !is_power_of_2(boot->index_size))) {
+		 SECTOR_SIZE > (2U << (-boot->index_size))) ||
+		(boot->index_size >= 0 && !is_power_of_2(boot->index_size))) {
 		goto out;
 	}
 
@@ -762,9 +796,6 @@ static int ntfs_init_from_boot(struct su
 		dev_size += sector_size - 1;
 	}
 
-	sbi->cluster_size = boot_sector_size * sct_per_clst;
-	sbi->cluster_bits = blksize_bits(sbi->cluster_size);
-
 	sbi->mft.lbo = mlcn << sbi->cluster_bits;
 	sbi->mft.lbo2 = mlcn2 << sbi->cluster_bits;
 
@@ -785,9 +816,9 @@ static int ntfs_init_from_boot(struct su
 	sbi->cluster_mask = sbi->cluster_size - 1;
 	sbi->cluster_mask_inv = ~(u64)sbi->cluster_mask;
 	sbi->record_size = record_size = boot->record_size < 0
-						 ? 1 << (-boot->record_size)
-						 : (u32)boot->record_size
-							   << sbi->cluster_bits;
+		? 1 << (-boot->record_size)
+		: (u32)boot->record_size
+		  << sbi->cluster_bits;
 
 	if (record_size > MAXIMUM_BYTES_PER_MFT || record_size < SECTOR_SIZE)
 		goto out;
@@ -801,8 +832,8 @@ static int ntfs_init_from_boot(struct su
 		ALIGN(sizeof(enum ATTR_TYPE), 8);
 
 	sbi->index_size = boot->index_size < 0
-				  ? 1u << (-boot->index_size)
-				  : (u32)boot->index_size << sbi->cluster_bits;
+		? 1u << (-boot->index_size)
+		: (u32)boot->index_size << sbi->cluster_bits;
 
 	sbi->volume.ser_num = le64_to_cpu(boot->serial_num);
 
@@ -871,13 +902,6 @@ static int ntfs_init_from_boot(struct su
 	sb->s_maxbytes = 0xFFFFFFFFull << sbi->cluster_bits;
 #endif
 
-	/*
-	 * Compute the MFT zone at two steps.
-	 * It would be nice if we are able to allocate 1/8 of
-	 * total clusters for MFT but not more then 512 MB.
-	 */
-	sbi->zone_max = min_t(CLST, 0x20000000 >> sbi->cluster_bits, clusters >> 3);
-
 	err = 0;
 
 out:


