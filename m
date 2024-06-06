Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BF311BA874;
	Thu,  6 Jun 2024 14:18:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683485; cv=none; b=WWCjMS6DtxoHz4G0+rjF4vfXd7Fw6QT0VJl7K+nBnVtkEKp8g0PvV+KSxLW1UmZ/K6JlsXzfKE04mHSYNnuJGV5LrZoah2bjvUhq0Lm+MpiK4jFQIXvsjHbpXs6WWqcBu+LeZ5U+Wv+IVLZnDK5grxiJlwoTQXg8lmhmN3rWbsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683485; c=relaxed/simple;
	bh=CdjnpSpoKBWpeFfnyFxGNCtzv+aaJuSF9nPWr+06X3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZTH7Nn/HtyirUtTm66Oq5XTXjIcm2FFGi5IOd7Hg90twGJ+xRhc+d6v79I4btVzGK5SVZLoNPx4lD2Lh5Ias8R7/WeIQHoYJIrVgyqZRQTCJ32w1glDNKQ8l/HM4FAEkYUZNI33DGonPN+yNaCekWq3Hgo879+lezQ03g/fFSr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2q7rEro/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2q7rEro/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCF31C32781;
	Thu,  6 Jun 2024 14:18:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683484;
	bh=CdjnpSpoKBWpeFfnyFxGNCtzv+aaJuSF9nPWr+06X3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2q7rEro/wSaOew2tUvk3MYIDzfqkQmKoPqIFnmVzanW727H1kiiv++AAJF1ERXMXR
	 YKIZRBfqTFQGNMOFbcSoCPPlJv1OV853hRHGoyegw9lROLDDk1+7mrEG0R5miUwH/O
	 Bn8p/RbH780Ts77Mu6/x0rfGeV1xeYYLduiAU1gU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 341/473] f2fs: compress: fix to update i_compr_blocks correctly
Date: Thu,  6 Jun 2024 16:04:30 +0200
Message-ID: <20240606131711.173551440@linuxfoundation.org>
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
index 1c47c7cbcd6cd..69023b8fc67a7 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -3588,7 +3588,8 @@ static int reserve_compress_blocks(struct dnode_of_data *dn, pgoff_t count,
 
 	while (count) {
 		int compr_blocks = 0;
-		blkcnt_t reserved;
+		blkcnt_t reserved = 0;
+		blkcnt_t to_reserved;
 		int ret;
 
 		for (i = 0; i < cluster_size; i++) {
@@ -3608,20 +3609,26 @@ static int reserve_compress_blocks(struct dnode_of_data *dn, pgoff_t count,
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
 
@@ -3632,7 +3639,7 @@ static int reserve_compress_blocks(struct dnode_of_data *dn, pgoff_t count,
 
 		f2fs_i_compr_blocks_update(dn->inode, compr_blocks, true);
 
-		*reserved_blocks += reserved;
+		*reserved_blocks += to_reserved;
 next:
 		count -= cluster_size;
 	}
-- 
2.43.0



