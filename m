Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CA3033A02F;
	Tue, 11 Nov 2025 01:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824565; cv=none; b=ZYsaQuMT11yYbgg+dfwS7Zt6Q2kN1Qx2paOLziSPnvRgu/onaFaO/7ZqmX/mT8DyxBWodrY4GaavsXGHBkf4fbQHBBpL23Ra5Rxo9P/usAW7JrO/RU7m5Jn1oWL5efdbT9PWYuLjVgB1ju4fm3w+PkaUE+rQjmVEH1txMPg56lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824565; c=relaxed/simple;
	bh=5+5t0qVRyMR8T48NZKrwSWNLH7UzFSrGldVoCqGQ1oc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N4+1JRcPy7U920uFoWzHu/QgszQrr7i3zVoAsA1VX33AuQS5Rxvv+NxgvFBxYHMaxu9M9JY669hobFLWwi72zbOkKPwfPpKv7xqVHWW95iYyO6fhEtorx5PVIs+rcdCtg9SHg1SKp+DZIhVyk2ANR0AV+AzBmddA1uTLgkwNKrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mvMN5Oc8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mvMN5Oc8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34D90C116D0;
	Tue, 11 Nov 2025 01:29:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824565;
	bh=5+5t0qVRyMR8T48NZKrwSWNLH7UzFSrGldVoCqGQ1oc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mvMN5Oc8xC171Kl2M39XXwYhMbi70yTmv+UYiTQH/iTnRhnVs/rjkbX7eqfv8kBMm
	 dCBeNcWRjD8+PIIZvenIdN2nVQ/tTsXj1VlLn64ytnG7vcEE+XZhhUtA/T4g57h0V9
	 KlMJCqW9Pyj/0LO9QCYwWK319fFiHz+hjx3xGrbo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+a725ab460fc1def9896f@syzkaller.appspotmail.com,
	Yuezhang Mo <Yuezhang.Mo@sony.com>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 443/565] exfat: validate cluster allocation bits of the allocation bitmap
Date: Tue, 11 Nov 2025 09:44:59 +0900
Message-ID: <20251111004536.851167170@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namjae Jeon <linkinjeon@kernel.org>

[ Upstream commit 79c1587b6cda74deb0c86fc7ba194b92958c793c ]

syzbot created an exfat image with cluster bits not set for the allocation
bitmap. exfat-fs reads and uses the allocation bitmap without checking
this. The problem is that if the start cluster of the allocation bitmap
is 6, cluster 6 can be allocated when creating a directory with mkdir.
exfat zeros out this cluster in exfat_mkdir, which can delete existing
entries. This can reallocate the allocated entries. In addition,
the allocation bitmap is also zeroed out, so cluster 6 can be reallocated.
This patch adds exfat_test_bitmap_range to validate that clusters used for
the allocation bitmap are correctly marked as in-use.

Reported-by: syzbot+a725ab460fc1def9896f@syzkaller.appspotmail.com
Tested-by: syzbot+a725ab460fc1def9896f@syzkaller.appspotmail.com
Reviewed-by: Yuezhang Mo <Yuezhang.Mo@sony.com>
Reviewed-by: Sungjong Seo <sj1557.seo@samsung.com>
Signed-off-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/exfat/balloc.c | 72 +++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 60 insertions(+), 12 deletions(-)

diff --git a/fs/exfat/balloc.c b/fs/exfat/balloc.c
index 9ff825f1502d5..b2b55ad76b7fd 100644
--- a/fs/exfat/balloc.c
+++ b/fs/exfat/balloc.c
@@ -26,12 +26,55 @@
 /*
  *  Allocation Bitmap Management Functions
  */
+static bool exfat_test_bitmap_range(struct super_block *sb, unsigned int clu,
+		unsigned int count)
+{
+	struct exfat_sb_info *sbi = EXFAT_SB(sb);
+	unsigned int start = clu;
+	unsigned int end = clu + count;
+	unsigned int ent_idx, i, b;
+	unsigned int bit_offset, bits_to_check;
+	__le_long *bitmap_le;
+	unsigned long mask, word;
+
+	if (!is_valid_cluster(sbi, start) || !is_valid_cluster(sbi, end - 1))
+		return false;
+
+	while (start < end) {
+		ent_idx = CLUSTER_TO_BITMAP_ENT(start);
+		i = BITMAP_OFFSET_SECTOR_INDEX(sb, ent_idx);
+		b = BITMAP_OFFSET_BIT_IN_SECTOR(sb, ent_idx);
+
+		bitmap_le = (__le_long *)sbi->vol_amap[i]->b_data;
+
+		/* Calculate how many bits we can check in the current word */
+		bit_offset = b % BITS_PER_LONG;
+		bits_to_check = min(end - start,
+				    (unsigned int)(BITS_PER_LONG - bit_offset));
+
+		/* Create a bitmask for the range of bits to check */
+		if (bits_to_check >= BITS_PER_LONG)
+			mask = ~0UL;
+		else
+			mask = ((1UL << bits_to_check) - 1) << bit_offset;
+		word = lel_to_cpu(bitmap_le[b / BITS_PER_LONG]);
+
+		/* Check if all bits in the mask are set */
+		if ((word & mask) != mask)
+			return false;
+
+		start += bits_to_check;
+	}
+
+	return true;
+}
+
 static int exfat_allocate_bitmap(struct super_block *sb,
 		struct exfat_dentry *ep)
 {
 	struct exfat_sb_info *sbi = EXFAT_SB(sb);
 	long long map_size;
-	unsigned int i, need_map_size;
+	unsigned int i, j, need_map_size;
 	sector_t sector;
 
 	sbi->map_clu = le32_to_cpu(ep->dentry.bitmap.start_clu);
@@ -58,20 +101,25 @@ static int exfat_allocate_bitmap(struct super_block *sb,
 	sector = exfat_cluster_to_sector(sbi, sbi->map_clu);
 	for (i = 0; i < sbi->map_sectors; i++) {
 		sbi->vol_amap[i] = sb_bread(sb, sector + i);
-		if (!sbi->vol_amap[i]) {
-			/* release all buffers and free vol_amap */
-			int j = 0;
-
-			while (j < i)
-				brelse(sbi->vol_amap[j++]);
-
-			kvfree(sbi->vol_amap);
-			sbi->vol_amap = NULL;
-			return -EIO;
-		}
+		if (!sbi->vol_amap[i])
+			goto err_out;
 	}
 
+	if (exfat_test_bitmap_range(sb, sbi->map_clu,
+		EXFAT_B_TO_CLU_ROUND_UP(map_size, sbi)) == false)
+		goto err_out;
+
 	return 0;
+
+err_out:
+	j = 0;
+	/* release all buffers and free vol_amap */
+	while (j < i)
+		brelse(sbi->vol_amap[j++]);
+
+	kvfree(sbi->vol_amap);
+	sbi->vol_amap = NULL;
+	return -EIO;
 }
 
 int exfat_load_bitmap(struct super_block *sb)
-- 
2.51.0



