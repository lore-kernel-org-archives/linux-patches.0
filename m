Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 650E6198E93;
	Thu,  6 Jun 2024 14:09:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682946; cv=none; b=FHAXyAnMaQ0+frqhlsd57jCrF8zb6E3R/6feKhcgly7/wAMje2cP3E7G42OXNzdaC+AZcey3/u1Ijz9HfwXzjd8aLmOHAWRIbNnDb505q0aMlsyX0OEu2rLfP6GdgvgPn05AyyerEA/hTx1UvfVTLzbHDdsxRNSbqWZi0gAk6TY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682946; c=relaxed/simple;
	bh=7YzqRFmMqOHqmj1g8zhcmT7K8L4eMqHNWi1izyi5Wd0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YIU84JeZFGEfyXiNTkGz4UGxsc1fFqQ+luQgCLSgE/QWtcwwLjqUCf1m20qLvhodyMHq+aVKgc44+9TP7MmXD6CbaF+A0S0b7P3Zx4RM5kgy+X4lEZ6dXpg51ZWOLQb6itP8wXZbctq3lZsD6vt6caubH261RbqOoIPw1e5aLOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JjOd/m0N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JjOd/m0N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48A58C2BD10;
	Thu,  6 Jun 2024 14:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682946;
	bh=7YzqRFmMqOHqmj1g8zhcmT7K8L4eMqHNWi1izyi5Wd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JjOd/m0NpNGMm6yqcm8Iz484bRgCAbKOdH5PYKUdj9l2vwDX5aV8lvAddRXTr8r4g
	 vUk4K9UTFssw1W8L4YDK0/ror44z0DLuhxc1Gr5EHGybWKqOpgd3BafjrFBuVXlDOh
	 Ojshm1ehSUX8cOWv+4UOOvw0m0a5s8Vb3lRjpMK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 107/374] f2fs: compress: fix to update i_compr_blocks correctly
Date: Thu,  6 Jun 2024 16:01:26 +0200
Message-ID: <20240606131655.510105282@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit 186e7d71534df4589405925caca5597af7626c12 ]

Previously, we account reserved blocks and compressed blocks into
@compr_blocks, then, f2fs_i_compr_blocks_update(,compr_blocks) will
update i_compr_blocks incorrectly, fix it.

Meanwhile, for the case all blocks in cluster were reserved, fix to
update dn->ofs_in_node correctly.

Fixes: eb8fbaa53374 ("f2fs: compress: fix to check unreleased compressed cluster")
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/file.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index 2566dc8a777de..34becfc142d80 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -3645,7 +3645,8 @@ static int reserve_compress_blocks(struct dnode_of_data *dn, pgoff_t count,
 
 	while (count) {
 		int compr_blocks = 0;
-		blkcnt_t reserved;
+		blkcnt_t reserved = 0;
+		blkcnt_t to_reserved;
 		int ret;
 
 		for (i = 0; i < cluster_size; i++) {
@@ -3665,20 +3666,26 @@ static int reserve_compress_blocks(struct dnode_of_data *dn, pgoff_t count,
 			 * fails in release_compress_blocks(), so NEW_ADDR
 			 * is a possible case.
 			 */
-			if (blkaddr == NEW_ADDR ||
-				__is_valid_data_blkaddr(blkaddr)) {
+			if (blkaddr == NEW_ADDR) {
+				reserved++;
+				continue;
+			}
+			if (__is_valid_data_blkaddr(blkaddr)) {
 				compr_blocks++;
 				continue;
 			}
 		}
 
-		reserved = cluster_size - compr_blocks;
+		to_reserved = cluster_size - compr_blocks - reserved;
 
 		/* for the case all blocks in cluster were reserved */
-		if (reserved == 1)
+		if (to_reserved == 1) {
+			dn->ofs_in_node += cluster_size;
 			goto next;
+		}
 
-		ret = inc_valid_block_count(sbi, dn->inode, &reserved, false);
+		ret = inc_valid_block_count(sbi, dn->inode,
+						&to_reserved, false);
 		if (unlikely(ret))
 			return ret;
 
@@ -3689,7 +3696,7 @@ static int reserve_compress_blocks(struct dnode_of_data *dn, pgoff_t count,
 
 		f2fs_i_compr_blocks_update(dn->inode, compr_blocks, true);
 
-		*reserved_blocks += reserved;
+		*reserved_blocks += to_reserved;
 next:
 		count -= cluster_size;
 	}
-- 
2.43.0



