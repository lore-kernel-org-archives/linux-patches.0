Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1671D3368B8;
	Tue, 21 Jul 2026 17:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655413; cv=none; b=GsmOrJhvVYpfb/YzKgQH2rdV2loRtu10Hhfq05zeQJV6aoQb1SMZpL3CE/7HkY7rWN5mvBC4tnqdQh9IwHdXWUctE/M3Lnb0DLX4zN2m0kBsU8N2bVLaLnLNlXriqZDoOmFWhzci/FV/QZjvz2a2M66L2RpBE3UKre3MSRB+AgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655413; c=relaxed/simple;
	bh=xD6LIJ4KU73sTI7TnbrG9d+7O2zlf01qhiQWgEUrWJQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iZvxBxCz4D9P1UjxgJgnRwwtq7Gnd4LnkKhkxE4X4M/+mtVpVcw4Yht9bMsiYRyLb96+pQmYwJn+bTfRDzSZZgQ9x/2DhG0KC7tIOFlpYe+5onL2qItPRBoUBDmnhi9sVudTo1xEnpyoyaIsq2uU+SsMtsHFmyX2W5zkwve8zMc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q/Uby8zq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q/Uby8zq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C7CB1F000E9;
	Tue, 21 Jul 2026 17:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655412;
	bh=o5O4VGsypK/UfeApL7ZIDWzgZnMuFhqyvXLSoB7ZM5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q/Uby8zqinz6TXDdhiUmc07fE3DVU3sZ1rdu7JJ9qxFmdnu33J1T4fWjX3YlXamuU
	 VgLegdmP60w60pV1bw0Eg6NL0d+kY5AXbs/ppb4K3QkH4zEdj5B9NQy1fMtEz4Fl3v
	 CSYW5x/U6+/iG4uU4mZruAj8HLlACZjnYe/S1Ybo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 2072/2077] exfat: add data_start_bytes and exfat_cluster_to_phys_bytes() helper
Date: Tue, 21 Jul 2026 17:29:05 +0200
Message-ID: <20260721152641.575071955@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 3b9450beeb961c7ddf4cccddba37fcfa6d1fcb7a ]

This caches the data area start offset in bytes (data_start_bytes)
and introduces a helper function exfat_cluster_to_phys_bytes() to compute
the physical byte position of a given cluster.

Acked-by: Christoph Hellwig <hch@lst.de>
Acked-by: "Darrick J. Wong" <djwong@kernel.org>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Stable-dep-of: 044472d5ee7d ("iomap: consolidate bio submission")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/exfat/exfat_fs.h |    8 ++++++++
 fs/exfat/super.c    |    1 +
 2 files changed, 9 insertions(+)

--- a/fs/exfat/exfat_fs.h
+++ b/fs/exfat/exfat_fs.h
@@ -227,6 +227,7 @@ struct exfat_sb_info {
 	unsigned long long FAT1_start_sector; /* FAT1 start sector */
 	unsigned long long FAT2_start_sector; /* FAT2 start sector */
 	unsigned long long data_start_sector; /* data area start sector */
+	unsigned long long data_start_bytes;
 	unsigned int num_FAT_sectors; /* num of FAT sectors */
 	unsigned int root_dir; /* root dir cluster */
 	unsigned int dentries_per_clu; /* num of dentries per cluster */
@@ -400,6 +401,13 @@ static inline loff_t exfat_ondisk_size(c
 	return ((loff_t)inode->i_blocks) << 9;
 }
 
+static inline loff_t exfat_cluster_to_phys_bytes(struct exfat_sb_info *sbi,
+		unsigned int clus)
+{
+	return ((loff_t)(clus - EXFAT_RESERVED_CLUSTERS) << sbi->cluster_size_bits) +
+		sbi->data_start_bytes;
+}
+
 /*
  * helpers for cluster size to byte conversion.
  */
--- a/fs/exfat/super.c
+++ b/fs/exfat/super.c
@@ -499,6 +499,7 @@ static int exfat_read_boot_sector(struct
 	if (p_boot->num_fats == 2)
 		sbi->FAT2_start_sector += sbi->num_FAT_sectors;
 	sbi->data_start_sector = le32_to_cpu(p_boot->clu_offset);
+	sbi->data_start_bytes = sbi->data_start_sector << p_boot->sect_size_bits;
 	sbi->num_sectors = le64_to_cpu(p_boot->vol_length);
 	/* because the cluster index starts with 2 */
 	sbi->num_clusters = le32_to_cpu(p_boot->clu_count) +


