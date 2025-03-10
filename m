Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CDFE230D0F;
	Mon, 10 Mar 2025 17:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627628; cv=none; b=FnfR/9RWtFQx2Y+5UVASCRah7tNOw8vzaCpbF2+wlwMVxjhFglPj74je47qb8GjmxpZYO9dgDFIW8DAdzK36nEopsKbVrlI08YOW1p7h3dhUvp/bXju4wG2rU2x/Q8hjj4xlzt+eNO++W+tgrktQ6Jgb5gXc5IiN2z6Wzkx7E+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627628; c=relaxed/simple;
	bh=444v6QesEEZeudsQjU9NnhzXZ7oTiUia3TliEw3MfCA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WPiA+3Ao9Qd1STsdY4rZMBpf+MgZZZD5VR24M058BEurIemdLkpb5G78OgCfkvhm0H1I0BRFlQcAV8DsJyVQ9vR7xmfevS5pOFuYXv8YQNt8rxL6yRO3TCr8HC4eSD3U+4jSyJWIu7gWszV/L2r7cpGlo8GvCgN1tGCCSmfo79o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NXUqJxPv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NXUqJxPv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A462C4CEE5;
	Mon, 10 Mar 2025 17:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627628;
	bh=444v6QesEEZeudsQjU9NnhzXZ7oTiUia3TliEw3MfCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NXUqJxPvMpkrsYNXYXT/+iIQRaEkU+WoeUkSWyzGZD1utJoKfF/nAWahTSMGnMdpH
	 lt3/cWqJj5PddgWMnIC4kP4rZw2uVDWPDKhNS2F56qhChXth/8TRkD2kJn7T2/OOc2
	 TtbW9yptV4rdX9snMgdc7ieqGf31uvaTYiPjAT8s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Kun Hu <huk23@m.fudan.edu.cn>
Subject: [PATCH 6.12 195/269] exfat: fix soft lockup in exfat_clear_bitmap
Date: Mon, 10 Mar 2025 18:05:48 +0100
Message-ID: <20250310170505.472082618@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 9da33619e0ca53627641bc97d1b93ec741299111 ]

bitmap clear loop will take long time in __exfat_free_cluster()
if data size of file/dir enty is invalid.
If cluster bit in bitmap is already clear, stop clearing bitmap go to
out of loop.

Fixes: 31023864e67a ("exfat: add fat entry operations")
Reported-by: Kun Hu <huk23@m.fudan.edu.cn>, Jiaji Qin <jjtan24@m.fudan.edu.cn>
Reviewed-by: Sungjong Seo <sj1557.seo@samsung.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/exfat/balloc.c   | 10 ++++++++--
 fs/exfat/exfat_fs.h |  2 +-
 fs/exfat/fatent.c   | 11 +++++++----
 3 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/fs/exfat/balloc.c b/fs/exfat/balloc.c
index ce9be95c9172f..9ff825f1502d5 100644
--- a/fs/exfat/balloc.c
+++ b/fs/exfat/balloc.c
@@ -141,7 +141,7 @@ int exfat_set_bitmap(struct inode *inode, unsigned int clu, bool sync)
 	return 0;
 }
 
-void exfat_clear_bitmap(struct inode *inode, unsigned int clu, bool sync)
+int exfat_clear_bitmap(struct inode *inode, unsigned int clu, bool sync)
 {
 	int i, b;
 	unsigned int ent_idx;
@@ -150,13 +150,17 @@ void exfat_clear_bitmap(struct inode *inode, unsigned int clu, bool sync)
 	struct exfat_mount_options *opts = &sbi->options;
 
 	if (!is_valid_cluster(sbi, clu))
-		return;
+		return -EIO;
 
 	ent_idx = CLUSTER_TO_BITMAP_ENT(clu);
 	i = BITMAP_OFFSET_SECTOR_INDEX(sb, ent_idx);
 	b = BITMAP_OFFSET_BIT_IN_SECTOR(sb, ent_idx);
 
+	if (!test_bit_le(b, sbi->vol_amap[i]->b_data))
+		return -EIO;
+
 	clear_bit_le(b, sbi->vol_amap[i]->b_data);
+
 	exfat_update_bh(sbi->vol_amap[i], sync);
 
 	if (opts->discard) {
@@ -171,6 +175,8 @@ void exfat_clear_bitmap(struct inode *inode, unsigned int clu, bool sync)
 			opts->discard = 0;
 		}
 	}
+
+	return 0;
 }
 
 /*
diff --git a/fs/exfat/exfat_fs.h b/fs/exfat/exfat_fs.h
index 3cdc1de362a94..d2ba8e2d0c398 100644
--- a/fs/exfat/exfat_fs.h
+++ b/fs/exfat/exfat_fs.h
@@ -452,7 +452,7 @@ int exfat_count_num_clusters(struct super_block *sb,
 int exfat_load_bitmap(struct super_block *sb);
 void exfat_free_bitmap(struct exfat_sb_info *sbi);
 int exfat_set_bitmap(struct inode *inode, unsigned int clu, bool sync);
-void exfat_clear_bitmap(struct inode *inode, unsigned int clu, bool sync);
+int exfat_clear_bitmap(struct inode *inode, unsigned int clu, bool sync);
 unsigned int exfat_find_free_bitmap(struct super_block *sb, unsigned int clu);
 int exfat_count_used_clusters(struct super_block *sb, unsigned int *ret_count);
 int exfat_trim_fs(struct inode *inode, struct fstrim_range *range);
diff --git a/fs/exfat/fatent.c b/fs/exfat/fatent.c
index 9e5492ac409b0..6f3651c6ca91e 100644
--- a/fs/exfat/fatent.c
+++ b/fs/exfat/fatent.c
@@ -175,6 +175,7 @@ static int __exfat_free_cluster(struct inode *inode, struct exfat_chain *p_chain
 		BITMAP_OFFSET_SECTOR_INDEX(sb, CLUSTER_TO_BITMAP_ENT(clu));
 
 	if (p_chain->flags == ALLOC_NO_FAT_CHAIN) {
+		int err;
 		unsigned int last_cluster = p_chain->dir + p_chain->size - 1;
 		do {
 			bool sync = false;
@@ -189,7 +190,9 @@ static int __exfat_free_cluster(struct inode *inode, struct exfat_chain *p_chain
 				cur_cmap_i = next_cmap_i;
 			}
 
-			exfat_clear_bitmap(inode, clu, (sync && IS_DIRSYNC(inode)));
+			err = exfat_clear_bitmap(inode, clu, (sync && IS_DIRSYNC(inode)));
+			if (err)
+				break;
 			clu++;
 			num_clusters++;
 		} while (num_clusters < p_chain->size);
@@ -210,12 +213,13 @@ static int __exfat_free_cluster(struct inode *inode, struct exfat_chain *p_chain
 				cur_cmap_i = next_cmap_i;
 			}
 
-			exfat_clear_bitmap(inode, clu, (sync && IS_DIRSYNC(inode)));
+			if (exfat_clear_bitmap(inode, clu, (sync && IS_DIRSYNC(inode))))
+				break;
 			clu = n_clu;
 			num_clusters++;
 
 			if (err)
-				goto dec_used_clus;
+				break;
 
 			if (num_clusters >= sbi->num_clusters - EXFAT_FIRST_CLUSTER) {
 				/*
@@ -229,7 +233,6 @@ static int __exfat_free_cluster(struct inode *inode, struct exfat_chain *p_chain
 		} while (clu != EXFAT_EOF_CLUSTER);
 	}
 
-dec_used_clus:
 	sbi->used_clusters -= num_clusters;
 	return 0;
 }
-- 
2.39.5



