Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 978AB1AC893;
	Thu, 15 Aug 2024 14:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732732; cv=none; b=Nl1CWligWZy/TbuugbAXP8PINeXj8gecyEZ598dL0MqtPM5yhM4WPz5JwWnNoEo5TP1Y8o3/zo3hCGsOP1mzfsypaDBYKHiHKSjxWIuetmrcgfkbewHIs3VyybyFiFCYl7TjDnYdcZOp2k7wm7C5OFOszx5dK6agrcxPXdIAL/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732732; c=relaxed/simple;
	bh=yvQuSHcRVk8hm0ccxHJa0sHSmBnrdVj99GYZfMMbiTk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sLNvj7COg/QE2jEtTEM8hgX9XO4YueOexEKXvcuDIYa2cu8kOFqkaVrfnTYicZZQjJl3yadPqX87L3a+VLSXWmqasRXoM3T+MqYWISeC54UsM4xAha8NIeLoDdg5uKLaWceCJFRdrng9cafHNh4mwglmLILBPaXxX3pQ3UoU+Ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nzh7zmBM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nzh7zmBM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03F77C32786;
	Thu, 15 Aug 2024 14:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732732;
	bh=yvQuSHcRVk8hm0ccxHJa0sHSmBnrdVj99GYZfMMbiTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nzh7zmBMdRK/j4qkL0SM11ZkpMJRRyWakLeINg+3CptB5Drx0oBq163ncqPhB6TRK
	 m28uaSFhvR/BrEtVfIQRR6ssmMeL2Omm2oHPO+0SOzpciYBjVpRB5GtiLmtI3/zNm1
	 LU7ZBh7NKfR9tQiizhhFe7eRrIo5qLIRcA9ddm08=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.com>,
	Roman Smirnov <r.smirnov@omp.ru>,
	Jan Kara <jack@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 269/352] udf: prevent integer overflow in udf_bitmap_free_blocks()
Date: Thu, 15 Aug 2024 15:25:35 +0200
Message-ID: <20240815131929.845672126@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roman Smirnov <r.smirnov@omp.ru>

[ Upstream commit 56e69e59751d20993f243fb7dd6991c4e522424c ]

An overflow may occur if the function is called with the last
block and an offset greater than zero. It is necessary to add
a check to avoid this.

Found by Linux Verification Center (linuxtesting.org) with Svace.

[JK: Make test cover also unalloc table freeing]

Link: https://patch.msgid.link/20240620072413.7448-1-r.smirnov@omp.ru
Suggested-by: Jan Kara <jack@suse.com>
Signed-off-by: Roman Smirnov <r.smirnov@omp.ru>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/udf/balloc.c | 36 +++++++++++++-----------------------
 1 file changed, 13 insertions(+), 23 deletions(-)

diff --git a/fs/udf/balloc.c b/fs/udf/balloc.c
index c4c18eeacb60c..aa73ab1b50a52 100644
--- a/fs/udf/balloc.c
+++ b/fs/udf/balloc.c
@@ -22,6 +22,7 @@
 #include "udfdecl.h"
 
 #include <linux/bitops.h>
+#include <linux/overflow.h>
 
 #include "udf_i.h"
 #include "udf_sb.h"
@@ -144,7 +145,6 @@ static void udf_bitmap_free_blocks(struct super_block *sb,
 {
 	struct udf_sb_info *sbi = UDF_SB(sb);
 	struct buffer_head *bh = NULL;
-	struct udf_part_map *partmap;
 	unsigned long block;
 	unsigned long block_group;
 	unsigned long bit;
@@ -153,19 +153,9 @@ static void udf_bitmap_free_blocks(struct super_block *sb,
 	unsigned long overflow;
 
 	mutex_lock(&sbi->s_alloc_mutex);
-	partmap = &sbi->s_partmaps[bloc->partitionReferenceNum];
-	if (bloc->logicalBlockNum + count < count ||
-	    (bloc->logicalBlockNum + count) > partmap->s_partition_len) {
-		udf_debug("%u < %d || %u + %u > %u\n",
-			  bloc->logicalBlockNum, 0,
-			  bloc->logicalBlockNum, count,
-			  partmap->s_partition_len);
-		goto error_return;
-	}
-
+	/* We make sure this cannot overflow when mounting the filesystem */
 	block = bloc->logicalBlockNum + offset +
 		(sizeof(struct spaceBitmapDesc) << 3);
-
 	do {
 		overflow = 0;
 		block_group = block >> (sb->s_blocksize_bits + 3);
@@ -395,7 +385,6 @@ static void udf_table_free_blocks(struct super_block *sb,
 				  uint32_t count)
 {
 	struct udf_sb_info *sbi = UDF_SB(sb);
-	struct udf_part_map *partmap;
 	uint32_t start, end;
 	uint32_t elen;
 	struct kernel_lb_addr eloc;
@@ -404,16 +393,6 @@ static void udf_table_free_blocks(struct super_block *sb,
 	struct udf_inode_info *iinfo;
 
 	mutex_lock(&sbi->s_alloc_mutex);
-	partmap = &sbi->s_partmaps[bloc->partitionReferenceNum];
-	if (bloc->logicalBlockNum + count < count ||
-	    (bloc->logicalBlockNum + count) > partmap->s_partition_len) {
-		udf_debug("%u < %d || %u + %u > %u\n",
-			  bloc->logicalBlockNum, 0,
-			  bloc->logicalBlockNum, count,
-			  partmap->s_partition_len);
-		goto error_return;
-	}
-
 	iinfo = UDF_I(table);
 	udf_add_free_space(sb, sbi->s_partition, count);
 
@@ -688,6 +667,17 @@ void udf_free_blocks(struct super_block *sb, struct inode *inode,
 {
 	uint16_t partition = bloc->partitionReferenceNum;
 	struct udf_part_map *map = &UDF_SB(sb)->s_partmaps[partition];
+	uint32_t blk;
+
+	if (check_add_overflow(bloc->logicalBlockNum, offset, &blk) ||
+	    check_add_overflow(blk, count, &blk) ||
+	    bloc->logicalBlockNum + count > map->s_partition_len) {
+		udf_debug("Invalid request to free blocks: (%d, %u), off %u, "
+			  "len %u, partition len %u\n",
+			  partition, bloc->logicalBlockNum, offset, count,
+			  map->s_partition_len);
+		return;
+	}
 
 	if (map->s_partition_flags & UDF_PART_FLAG_UNALLOC_BITMAP) {
 		udf_bitmap_free_blocks(sb, map->s_uspace.s_bitmap,
-- 
2.43.0



