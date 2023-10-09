Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CDD7182A4
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P5170/P8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB888C433C8;
	Mon,  9 Oct 2023 13:28:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696858103;
	bh=uR3YDTdPPxjTdOzRvH+wIbC/FrNULOd+0M6/GD8q4Dg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P5170/P8eEbT8tqdNvUBDcxs3Sa4+UoSWpquuw8HImiLd8kOZVTfROlV7qdvJB2JZ
	 +L83m7G0Ytiq0eESrRBp0q0G4mgFBXBz6o/3K44i2TYfgc6xeI1Ax++tGDgemJXLXu
	 KCMX7ylR3ZUi6SfK2MIo/qOgO5cF3iszHJqCsRx8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Dilger <adilger@dilger.ca>,
	Wang Jianchao <wangjianchao@kuaishou.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 006/131] ext4: add new helper interface ext4_try_to_trim_range()
Date: Mon,  9 Oct 2023 15:00:46 +0200
Message-ID: <20231009130116.525568006@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130116.329529591@linuxfoundation.org>
References: <20231009130116.329529591@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wang Jianchao <wangjianchao@kuaishou.com>

[ Upstream commit 6920b3913235f517728bb69abe9b39047a987113 ]

There is no functional change in this patch but just split the
codes, which serachs free block and does trim, into a new function
ext4_try_to_trim_range. This is preparing for the following async
backgroup discard.

Reviewed-by: Andreas Dilger <adilger@dilger.ca>
Signed-off-by: Wang Jianchao <wangjianchao@kuaishou.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20210724074124.25731-3-jianchao.wan9@gmail.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Stable-dep-of: 45e4ab320c9b ("ext4: move setting of trimmed bit into ext4_try_to_trim_range()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/mballoc.c | 102 ++++++++++++++++++++++++++--------------------
 1 file changed, 57 insertions(+), 45 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index 9b4af51c99da4..5a7fe5aa0fc38 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -5194,6 +5194,54 @@ __acquires(bitlock)
 	return ret;
 }
 
+static int ext4_try_to_trim_range(struct super_block *sb,
+		struct ext4_buddy *e4b, ext4_grpblk_t start,
+		ext4_grpblk_t max, ext4_grpblk_t minblocks)
+{
+	ext4_grpblk_t next, count, free_count;
+	void *bitmap;
+	int ret = 0;
+
+	bitmap = e4b->bd_bitmap;
+	start = (e4b->bd_info->bb_first_free > start) ?
+		e4b->bd_info->bb_first_free : start;
+	count = 0;
+	free_count = 0;
+
+	while (start <= max) {
+		start = mb_find_next_zero_bit(bitmap, max + 1, start);
+		if (start > max)
+			break;
+		next = mb_find_next_bit(bitmap, max + 1, start);
+
+		if ((next - start) >= minblocks) {
+			ret = ext4_trim_extent(sb, start, next - start, e4b);
+			if (ret && ret != -EOPNOTSUPP)
+				break;
+			ret = 0;
+			count += next - start;
+		}
+		free_count += next - start;
+		start = next + 1;
+
+		if (fatal_signal_pending(current)) {
+			count = -ERESTARTSYS;
+			break;
+		}
+
+		if (need_resched()) {
+			ext4_unlock_group(sb, e4b->bd_group);
+			cond_resched();
+			ext4_lock_group(sb, e4b->bd_group);
+		}
+
+		if ((e4b->bd_info->bb_free - free_count) < minblocks)
+			break;
+	}
+
+	return count;
+}
+
 /**
  * ext4_trim_all_free -- function to trim all free space in alloc. group
  * @sb:			super block for file system
@@ -5217,10 +5265,8 @@ ext4_trim_all_free(struct super_block *sb, ext4_group_t group,
 		   ext4_grpblk_t start, ext4_grpblk_t max,
 		   ext4_grpblk_t minblocks)
 {
-	void *bitmap;
-	ext4_grpblk_t next, count = 0, free_count = 0;
 	struct ext4_buddy e4b;
-	int ret = 0;
+	int ret;
 
 	trace_ext4_trim_all_free(sb, group, start, max);
 
@@ -5230,57 +5276,23 @@ ext4_trim_all_free(struct super_block *sb, ext4_group_t group,
 			     ret, group);
 		return ret;
 	}
-	bitmap = e4b.bd_bitmap;
 
 	ext4_lock_group(sb, group);
-	if (EXT4_MB_GRP_WAS_TRIMMED(e4b.bd_info) &&
-	    minblocks >= atomic_read(&EXT4_SB(sb)->s_last_trim_minblks))
-		goto out;
-
-	start = (e4b.bd_info->bb_first_free > start) ?
-		e4b.bd_info->bb_first_free : start;
-
-	while (start <= max) {
-		start = mb_find_next_zero_bit(bitmap, max + 1, start);
-		if (start > max)
-			break;
-		next = mb_find_next_bit(bitmap, max + 1, start);
-
-		if ((next - start) >= minblocks) {
-			ret = ext4_trim_extent(sb, start, next - start, &e4b);
-			if (ret && ret != -EOPNOTSUPP)
-				break;
-			ret = 0;
-			count += next - start;
-		}
-		free_count += next - start;
-		start = next + 1;
-
-		if (fatal_signal_pending(current)) {
-			count = -ERESTARTSYS;
-			break;
-		}
-
-		if (need_resched()) {
-			ext4_unlock_group(sb, group);
-			cond_resched();
-			ext4_lock_group(sb, group);
-		}
 
-		if ((e4b.bd_info->bb_free - free_count) < minblocks)
-			break;
+	if (!EXT4_MB_GRP_WAS_TRIMMED(e4b.bd_info) ||
+	    minblocks < atomic_read(&EXT4_SB(sb)->s_last_trim_minblks)) {
+		ret = ext4_try_to_trim_range(sb, &e4b, start, max, minblocks);
+		if (ret >= 0)
+			EXT4_MB_GRP_SET_TRIMMED(e4b.bd_info);
+	} else {
+		ret = 0;
 	}
 
-	if (!ret) {
-		ret = count;
-		EXT4_MB_GRP_SET_TRIMMED(e4b.bd_info);
-	}
-out:
 	ext4_unlock_group(sb, group);
 	ext4_mb_unload_buddy(&e4b);
 
 	ext4_debug("trimmed %d blocks in the group %d\n",
-		count, group);
+		ret, group);
 
 	return ret;
 }
-- 
2.40.1



