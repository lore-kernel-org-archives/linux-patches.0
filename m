Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A42D1A7057;
	Thu, 15 Aug 2024 14:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730907; cv=none; b=uqE3+37/rF3UnaYkBRbqW7uiGOtWxSIWUlqGYC6tD6KFTfqAywQEC5BJbZhZLxmCNJ9zzXf6qVMlU1XNdngefzrLUC0o72SWa0ScyumKh6xeSpIcPBCjV7m9eaoVDZZe/wR98nKblW18Mgda1wEDnV/wEcjXWhx6qNIvicqNlZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730907; c=relaxed/simple;
	bh=S13t7G3xqQelV53Y5ONNp3x6tvNC6yK5WdLDNlUq1/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N3coLidDV7bhf6kjswfEI5JZS5eMr0FxNyV4NJyt6ZVFYVpgzsJmTI/bLejQ5JAZMZRd7E/FYTVOJEc/CY5KB+vWTn6LEux/Oo21ygw6CYwt0WdB+jbjNybzk9Rq0tP40j7pGHEe5br9dmV6oisV1YRw3UWuLKuZ85KCKpy3MwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eO01xhMv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eO01xhMv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 204F5C32786;
	Thu, 15 Aug 2024 14:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730907;
	bh=S13t7G3xqQelV53Y5ONNp3x6tvNC6yK5WdLDNlUq1/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eO01xhMvhybM/Ts+Velku/Jju+tOIneWiUgdD/eDKeMTsYmjl3jUC5TjWssA60K1c
	 A0+UKZ3FFzLrkL+Ok2IU6Elx4DhRyyDYuJ9RZAY/29MBNfyRbFqLFA53MBqnqugN+H
	 NyUmG2wrsCvgLBkb8y0c6E4B0zOgo/5d5BPqgnhE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phillip Lougher <phillip@squashfs.org.uk>,
	syzbot+604424eb051c2f696163@syzkaller.appspotmail.com,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 31/67] Squashfs: fix variable overflow triggered by sysbot
Date: Thu, 15 Aug 2024 15:25:45 +0200
Message-ID: <20240815131839.521744936@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131838.311442229@linuxfoundation.org>
References: <20240815131838.311442229@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Phillip Lougher <phillip@squashfs.org.uk>

[ Upstream commit 12427de9439d68b8e96ba6f50b601ef15f437612 ]

Sysbot reports a slab out of bounds write in squashfs_readahead().

This is ultimately caused by a file reporting an (infeasibly) large file
size (1407374883553280 bytes) with the minimum block size of 4K.

This causes variable overflow.

Link: https://lkml.kernel.org/r/20231113160901.6444-1-phillip@squashfs.org.uk
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Reported-by: syzbot+604424eb051c2f696163@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/000000000000b1fda20609ede0d1@google.com/
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/squashfs/file.c        | 3 ++-
 fs/squashfs/file_direct.c | 6 +++---
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/fs/squashfs/file.c b/fs/squashfs/file.c
index 8ba8c4c507707..e8df6430444b0 100644
--- a/fs/squashfs/file.c
+++ b/fs/squashfs/file.c
@@ -544,7 +544,8 @@ static void squashfs_readahead(struct readahead_control *ractl)
 	struct squashfs_page_actor *actor;
 	unsigned int nr_pages = 0;
 	struct page **pages;
-	int i, file_end = i_size_read(inode) >> msblk->block_log;
+	int i;
+	loff_t file_end = i_size_read(inode) >> msblk->block_log;
 	unsigned int max_pages = 1UL << shift;
 
 	readahead_expand(ractl, start, (len | mask) + 1);
diff --git a/fs/squashfs/file_direct.c b/fs/squashfs/file_direct.c
index f1ccad519e28c..763a3f7a75f6d 100644
--- a/fs/squashfs/file_direct.c
+++ b/fs/squashfs/file_direct.c
@@ -26,10 +26,10 @@ int squashfs_readpage_block(struct page *target_page, u64 block, int bsize,
 	struct inode *inode = target_page->mapping->host;
 	struct squashfs_sb_info *msblk = inode->i_sb->s_fs_info;
 
-	int file_end = (i_size_read(inode) - 1) >> PAGE_SHIFT;
+	loff_t file_end = (i_size_read(inode) - 1) >> PAGE_SHIFT;
 	int mask = (1 << (msblk->block_log - PAGE_SHIFT)) - 1;
-	int start_index = target_page->index & ~mask;
-	int end_index = start_index | mask;
+	loff_t start_index = target_page->index & ~mask;
+	loff_t end_index = start_index | mask;
 	int i, n, pages, bytes, res = -ENOMEM;
 	struct page **page;
 	struct squashfs_page_actor *actor;
-- 
2.43.0



