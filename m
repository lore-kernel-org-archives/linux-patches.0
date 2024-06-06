Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5028619B3D9;
	Thu,  6 Jun 2024 14:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683380; cv=none; b=PZoDCXPq+H2uSKODQFb/zhn/z8cStW6MQEVwt61GdHJJUNq1i4ptp1HrC+9f3TWg76zeGYJLPqwReV+IUecv2lIq5gKyGpr8G2PcdEjDwAPMZRz1OWEletm/2aL5khnuQHmFFFUlp2tJAxX+IfmqcxcwbDiGkeLg6N/o4s3qoJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683380; c=relaxed/simple;
	bh=wHyQ5zfVOCaVr+K9rFhYd2W9Eige/3Rfdq7YDmHq9cQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kdO9vcbf69hbXme1f08uTYAJAslGKBb566MX1ojJ9OHk8pggT9e7zfjVBv/Tc3RbVbBHvZ6pgI/2PHTJby85bOUFWyfpp5IPQ9g+TnEiERYNycwOIBm5MzyOoN2zSbjHZJW30x+mne4q6RKqos+nP0bIdt4w6NAoh5l0HERRB10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JSqvX6Cm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JSqvX6Cm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31AABC2BD10;
	Thu,  6 Jun 2024 14:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683380;
	bh=wHyQ5zfVOCaVr+K9rFhYd2W9Eige/3Rfdq7YDmHq9cQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JSqvX6CmM5+GHgiwreqHTTmDNo/3ULmN84dHDBZsSkgPTw9psC1FzVeNAJU3XlUyM
	 Mo+jnQoLeyUzbIqDdqYOkohLqhJz5n0fOrn5LMt+HoQaFJZfVxidoJFegWCp/OqClm
	 I0+LKOB7B8fnCLk5x7brCVjh1s7XhbqwvMazT2p8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Theodore Tso <tytso@mit.edu>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 263/473] ext4: try all groups in ext4_mb_new_blocks_simple
Date: Thu,  6 Jun 2024 16:03:12 +0200
Message-ID: <20240606131708.640179318@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kemeng Shi <shikemeng@huaweicloud.com>

[ Upstream commit 19a043bb1fd1b5cb2652ca33536c55e6c0a70df0 ]

ext4_mb_new_blocks_simple ignores the group before goal, so it will fail
if free blocks reside in group before goal. Try all groups to avoid
unexpected failure.
Search finishes either if any free block is found or if no available
blocks are found. Simpliy check "i >= max" to distinguish the above
cases.

Signed-off-by: Kemeng Shi <shikemeng@huaweicloud.com>
Suggested-by: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Link: https://lore.kernel.org/r/20230603150327.3596033-8-shikemeng@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Stable-dep-of: 3f4830abd236 ("ext4: fix potential unnitialized variable")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/mballoc.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/ext4/mballoc.c b/fs/ext4/mballoc.c
index a809a80589857..a7801d2a7d1b4 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -5875,7 +5875,7 @@ static ext4_fsblk_t ext4_mb_new_blocks_simple(handle_t *handle,
 	struct buffer_head *bitmap_bh;
 	struct super_block *sb = ar->inode->i_sb;
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
-	ext4_group_t group;
+	ext4_group_t group, nr;
 	ext4_grpblk_t blkoff;
 	ext4_grpblk_t max = EXT4_CLUSTERS_PER_GROUP(sb);
 	ext4_grpblk_t i = 0;
@@ -5889,7 +5889,7 @@ static ext4_fsblk_t ext4_mb_new_blocks_simple(handle_t *handle,
 
 	ar->len = 0;
 	ext4_get_group_no_and_offset(sb, goal, &group, &blkoff);
-	for (; group < ext4_get_groups_count(sb); group++) {
+	for (nr = ext4_get_groups_count(sb); nr > 0; nr--) {
 		bitmap_bh = ext4_read_block_bitmap(sb, group);
 		if (IS_ERR(bitmap_bh)) {
 			*errp = PTR_ERR(bitmap_bh);
@@ -5913,10 +5913,13 @@ static ext4_fsblk_t ext4_mb_new_blocks_simple(handle_t *handle,
 		if (i < max)
 			break;
 
+		if (++group >= ext4_get_groups_count(sb))
+			group = 0;
+
 		blkoff = 0;
 	}
 
-	if (group >= ext4_get_groups_count(sb) || i >= max) {
+	if (i >= max) {
 		*errp = -ENOSPC;
 		return 0;
 	}
-- 
2.43.0



