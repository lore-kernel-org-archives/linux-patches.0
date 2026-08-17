Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CAE3424D6D;
	Mon, 17 Aug 2026 15:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979626; cv=none; b=Hu5QOmvTre4ZTGaCftlyEtCzJMWBXitH9dGxFnZikMETbpeRCdK4cWL9QiIYmhjOetScuiPe022QySMeYvD9Iai/35pliRbQ4g2i3ccxy+qh+L++KePs2WkH2larb1yBeoB21a+/iljSw7iJBmfmkUPTkKZNeEKRfEpjZ6bdPBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979626; c=relaxed/simple;
	bh=1PsbAp/M/3vSUrxiHuurtE8noRXlkvxJWq/218M7/jY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QavNAIEtJmDzF1sz4DIrlGvvdbZKCTkdNKr0QTFU83Ax/8WfJJ45DWs2Wt/GBtyvLEpBxO5iR/Jm/VF7X84IQLmWT6nhGo/f/I8VRlJE8Ii+oHWD3Za3Dgxgru7R+hix4tV1WW1Ia+BFQwGkiNeg7JzpTPTMmIqhQSFIUmFeq1A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h9YnT4Ds; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h9YnT4Ds"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB01F1F000E9;
	Mon, 17 Aug 2026 15:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979625;
	bh=PY7EkjKJMRkKkxttmV43a2EPPuaYmbNakbAoNAabwJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h9YnT4DsgnpDlnchTBj/t/L5o4toLm7kQHbmHFedVbVlDe82rpYpX4mgFvntQQVvE
	 w5MXJ1fwIsm8GFFwWRg+OrE82iECVuz7Hvyn1p4BufUhiwXTfcSJellO2pBAXloqBW
	 FM7XmdhTyjrL7cdGmZ/F9uRvdKJ2vh5ycsPu68/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+a725ab460fc1def9896f@syzkaller.appspotmail.com,
	Yuezhang Mo <Yuezhang.Mo@sony.com>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Jay Wang <wanjay@amazon.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 292/609] exfat: validate cluster allocation bits of the allocation bitmap
Date: Mon, 17 Aug 2026 15:29:48 +0200
Message-ID: <20260817132553.976456736@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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
[Adapted to 6.1: replaced __le_long/lel_to_cpu word-level bitmap access
 with per-bit test_bit_le() calls, as __le_long and lel_to_cpu do not
 exist in 6.1. Uses same test_bit_le API as rest of exfat bitmap code.]
Signed-off-by: Jay Wang <wanjay@amazon.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/exfat/balloc.c | 54 ++++++++++++++++++++++++++++++++++++-----------
 1 file changed, 42 insertions(+), 12 deletions(-)

diff --git a/fs/exfat/balloc.c b/fs/exfat/balloc.c
index 32209acd51be4f..2d4fe3d754bbc5 100644
--- a/fs/exfat/balloc.c
+++ b/fs/exfat/balloc.c
@@ -45,12 +45,37 @@ static const unsigned char used_bit[] = {
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
+
+	if (!is_valid_cluster(sbi, start) || !is_valid_cluster(sbi, end - 1))
+		return false;
+
+	while (start < end) {
+		ent_idx = CLUSTER_TO_BITMAP_ENT(start);
+		i = BITMAP_OFFSET_SECTOR_INDEX(sb, ent_idx);
+		b = BITMAP_OFFSET_BIT_IN_SECTOR(sb, ent_idx);
+
+		if (!test_bit_le(b, sbi->vol_amap[i]->b_data))
+			return false;
+
+		start++;
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
@@ -77,20 +102,25 @@ static int exfat_allocate_bitmap(struct super_block *sb,
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
2.53.0



