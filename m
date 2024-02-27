Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82B4113A275
	for <patches@lists.linux.dev>; Tue, 27 Feb 2024 12:59:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709038750; cv=none; b=rmJw0G4o3m5sZgrSx63mlwiNIt2MGKdmCvUnmTdkU24hHeKTA8h+fZp5HmR9mAByPXB9v31mpFxkREZs5NtHsPZRJAr0zM0kXvyPTOE0EMZda7dk/+lJdzHYe4huFFCp0N25NdPPdX7EVVSI8glBgvR4ihzu4LODuTLuE8vc/rI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709038750; c=relaxed/simple;
	bh=hOug0CSRgW26TYbU2Qi9lU8t+ce5oDn7+1OaX2vk1LU=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MeBDCn/LKrUv8BMGh2AJDzwkm6GGPbpu5GfEJn+7NG8jtBUGJiZvy6iHE1StV05ah4ZBBqSva3z6skmf7fX4mBfQHGQ8ARQXVbY38uZoVvtQDH0Z1iCPsR/hLKdH4Df6HmkOzYIZ+k1Kt0GaTUYmKvUIyeEbcVkgstY5qidqyrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4Tkcvd6BNXzpSy2;
	Tue, 27 Feb 2024 20:57:17 +0800 (CST)
Received: from dggpeml500021.china.huawei.com (unknown [7.185.36.21])
	by mail.maildlp.com (Postfix) with ESMTPS id 681E0140499;
	Tue, 27 Feb 2024 20:59:05 +0800 (CST)
Received: from huawei.com (10.175.127.227) by dggpeml500021.china.huawei.com
 (7.185.36.21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.35; Tue, 27 Feb
 2024 20:59:04 +0800
From: Baokun Li <libaokun1@huawei.com>
To: <stable@vger.kernel.org>
CC: <gregkh@linuxfoundation.org>, <sashal@kernel.org>, <tytso@mit.edu>,
	<jack@suse.cz>, <patches@lists.linux.dev>, <yi.zhang@huawei.com>,
	<yangerkun@huawei.com>, <libaokun1@huawei.com>
Subject: [PATCH 5.15 2/2] ext4: avoid bb_free and bb_fragments inconsistency in mb_free_blocks()
Date: Tue, 27 Feb 2024 21:00:50 +0800
Message-ID: <20240227130050.805571-2-libaokun1@huawei.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240227130050.805571-1-libaokun1@huawei.com>
References: <20240227130050.805571-1-libaokun1@huawei.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpeml500021.china.huawei.com (7.185.36.21)

commit 2331fd4a49864e1571b4f50aa3aa1536ed6220d0 upstream.

After updating bb_free in mb_free_blocks, it is possible to return without
updating bb_fragments because the block being freed is found to have
already been freed, which leads to inconsistency between bb_free and
bb_fragments.

Since the group may be unlocked in ext4_grp_locked_error(), this can lead
to problems such as dividing by zero when calculating the average fragment
length. Hence move the update of bb_free to after the block double-free
check guarantees that the corresponding statistics are updated only after
the core block bitmap is modified.

Fixes: eabe0444df90 ("ext4: speed-up releasing blocks on commit")
CC:  <stable@vger.kernel.org> # 3.10
Suggested-by: Jan Kara <jack@suse.cz>
Signed-off-by: Baokun Li <libaokun1@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20240104142040.2835097-5-libaokun1@huawei.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Baokun Li <libaokun1@huawei.com>
---
 fs/ext4/mballoc.c | 39 +++++++++++++++++++++------------------
 1 file changed, 21 insertions(+), 18 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 63e4c3b9e608..3328e32a0d69 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -1835,11 +1835,6 @@ static void mb_free_blocks(struct inode *inode, struct ext4_buddy *e4b,
 	mb_check_buddy(e4b);
 	mb_free_blocks_double(inode, e4b, first, count);
 
-	this_cpu_inc(discard_pa_seq);
-	e4b->bd_info->bb_free += count;
-	if (first < e4b->bd_info->bb_first_free)
-		e4b->bd_info->bb_first_free = first;
-
 	/* access memory sequentially: check left neighbour,
 	 * clear range and then check right neighbour
 	 */
@@ -1853,23 +1848,31 @@ static void mb_free_blocks(struct inode *inode, struct ext4_buddy *e4b,
 		struct ext4_sb_info *sbi = EXT4_SB(sb);
 		ext4_fsblk_t blocknr;
 
+		/*
+		 * Fastcommit replay can free already freed blocks which
+		 * corrupts allocation info. Regenerate it.
+		 */
+		if (sbi->s_mount_state & EXT4_FC_REPLAY) {
+			mb_regenerate_buddy(e4b);
+			goto check;
+		}
+
 		blocknr = ext4_group_first_block_no(sb, e4b->bd_group);
 		blocknr += EXT4_C2B(sbi, block);
-		if (!(sbi->s_mount_state & EXT4_FC_REPLAY)) {
-			ext4_grp_locked_error(sb, e4b->bd_group,
-					      inode ? inode->i_ino : 0,
-					      blocknr,
-					      "freeing already freed block (bit %u); block bitmap corrupt.",
-					      block);
-			ext4_mark_group_bitmap_corrupted(
-				sb, e4b->bd_group,
+		ext4_grp_locked_error(sb, e4b->bd_group,
+				      inode ? inode->i_ino : 0, blocknr,
+				      "freeing already freed block (bit %u); block bitmap corrupt.",
+				      block);
+		ext4_mark_group_bitmap_corrupted(sb, e4b->bd_group,
 				EXT4_GROUP_INFO_BBITMAP_CORRUPT);
-		} else {
-			mb_regenerate_buddy(e4b);
-		}
-		goto done;
+		return;
 	}
 
+	this_cpu_inc(discard_pa_seq);
+	e4b->bd_info->bb_free += count;
+	if (first < e4b->bd_info->bb_first_free)
+		e4b->bd_info->bb_first_free = first;
+
 	/* let's maintain fragments counter */
 	if (left_is_free && right_is_free)
 		e4b->bd_info->bb_fragments--;
@@ -1894,9 +1897,9 @@ static void mb_free_blocks(struct inode *inode, struct ext4_buddy *e4b,
 	if (first <= last)
 		mb_buddy_mark_free(e4b, first >> 1, last >> 1);
 
-done:
 	mb_set_largest_free_order(sb, e4b->bd_info);
 	mb_update_avg_fragment_size(sb, e4b->bd_info);
+check:
 	mb_check_buddy(e4b);
 }
 
-- 
2.31.1

