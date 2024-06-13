Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B5D86EB56;
	Thu, 13 Jun 2024 12:17:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718281051; cv=none; b=k7iW+VqPcFM7x0fLntbOCwadbtvbl5qUih0+vfcG/Mz2OeOr/FOAXyTwp8sdp/Kif0DkXAPKfAeI/6YXphdFjY/qZys/9Ow/QQYp8HeJM0YG7aCUjp461qoc5qDyXcvUEg9ETRAOmgk0SIJFu5+gk6OyiHhS7nl0OhstNeHy4/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718281051; c=relaxed/simple;
	bh=CY9+iCuVE1JlSds7/D/Y+Goh484XRD2tA1Mw7xMwF1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O5WUPh9YcuQWCVJplPuv2cOBTlvf8COcC4rPwpnoUb7cwF7SfLOsLv0mMQoI6HQmuDTYCPK60yS45XKtfqBe+Rfgwo1uNdUo6sA4mBkFd3fN4zfCLpjyhXKFBU6FIy22Ftgrv51BNAH6KGrYQUAe7vuTnmlDgYhmDvjPBm4SQHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qr+DYYN/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qr+DYYN/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACBA5C2BBFC;
	Thu, 13 Jun 2024 12:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718281051;
	bh=CY9+iCuVE1JlSds7/D/Y+Goh484XRD2tA1Mw7xMwF1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qr+DYYN/5tLS2SDrDfk04/R7IT197rS8YwaWCQgahtTOFlTLIZB20oR9TpneG7OsE
	 IPtsBoehDrNf8Khk8ek7mJeBLdoGqES6xWCK9TpS2cfzA4RohmITF5Yt8eTZnlztKF
	 9p5nHmg+TaU7qjQxtLk4aaSHcfYpr/p3RJUoaeXo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Theodore Tso <tytso@mit.edu>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 123/317] ext4: try all groups in ext4_mb_new_blocks_simple
Date: Thu, 13 Jun 2024 13:32:21 +0200
Message-ID: <20240613113252.308554818@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113247.525431100@linuxfoundation.org>
References: <20240613113247.525431100@linuxfoundation.org>
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
index f54f23afd93d2..de69929495a5a 100644
--- a/fs/ext4/mballoc.c
+++ b/fs/ext4/mballoc.c
@@ -5350,7 +5350,7 @@ static ext4_fsblk_t ext4_mb_new_blocks_simple(handle_t *handle,
 	struct buffer_head *bitmap_bh;
 	struct super_block *sb = ar->inode->i_sb;
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
-	ext4_group_t group;
+	ext4_group_t group, nr;
 	ext4_grpblk_t blkoff;
 	ext4_grpblk_t max = EXT4_CLUSTERS_PER_GROUP(sb);
 	ext4_grpblk_t i = 0;
@@ -5364,7 +5364,7 @@ static ext4_fsblk_t ext4_mb_new_blocks_simple(handle_t *handle,
 
 	ar->len = 0;
 	ext4_get_group_no_and_offset(sb, goal, &group, &blkoff);
-	for (; group < ext4_get_groups_count(sb); group++) {
+	for (nr = ext4_get_groups_count(sb); nr > 0; nr--) {
 		bitmap_bh = ext4_read_block_bitmap(sb, group);
 		if (IS_ERR(bitmap_bh)) {
 			*errp = PTR_ERR(bitmap_bh);
@@ -5388,10 +5388,13 @@ static ext4_fsblk_t ext4_mb_new_blocks_simple(handle_t *handle,
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



