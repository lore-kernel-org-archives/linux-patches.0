Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78B0D2C026C;
	Sat, 17 Oct 2026 16:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254154; cv=none; b=hNvT9QjVZo9wTWL90gEI9GykLoRStyZoMURe5wkKm61/DEZz7Skh1m58L5Rslp2YlRbJHqFFQzFadeze9aO0FPgzoC8JijAXcH2UPTJI0mfmcceKxPDSMDNPFjBQ58XPFTzhBNl1aoumQHdorEc1oAGkrHgxicrrs3UcZirUYTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254154; c=relaxed/simple;
	bh=fzpAv51xDaQieok0lzJXtHmuClp3+QPajNtxJhlxhJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h0Ql2ukW2AqwM6lV7FkD1j6gKGKckWl99J73CwELHolk5Qgo60EnAWpC4LkVeDU8CszMm2e8u7LnY3qP5LrEYceCohTZchyWLOe/IeqMzmzdbjbDR6Aq0qmn5Bng1IRRz3z7l+cec2Izh71GCVOmt+rMeyBj8uxzFlWjjXB7AUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W2qv9P3w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W2qv9P3w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1E4B1F000C4;
	Sat, 17 Oct 2026 16:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254153;
	bh=E1TvVzF/uI/CCSSt8UoNE+dR5UGIzsPJW933f+bDOfg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W2qv9P3wbzHlh+8jEgU7HYzNWPyr/jvR8Tvt9MZpvJUP93D0biUt6vz9/JjYzv0OI
	 90OZn6QYgyXv+agrU75sYV5Hmmluxs3FipUg7maQ9mI8IAJCWzPm9nZWiIQEY2jY42
	 6A1c68vcOB6EvAjKplv/5U06URuO+HQHMNYkZPQQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Yongpeng Yang <yangyongpeng@xiaomi.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 336/869] f2fs: fix fsck inconsistency caused by incorrect nat_entry flag usage
Date: Sat, 17 Oct 2026 17:52:57 +0200
Message-ID: <20261017160045.695814992@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

From: Yongpeng Yang <yangyongpeng@xiaomi.com>

[ Upstream commit 019f9dda7f66e55eb94cd32e1d3fff5835f73fbc ]

f2fs_need_dentry_mark() reads nat_entry flags without mutual exclusion
with the checkpoint path, which can result in an incorrect inode block
marking state. The scenario is as follows:

create & write & fsync 'file A'                 write checkpoint
- f2fs_do_sync_file // inline inode
 - f2fs_write_inode // inode folio is dirty
                                                - f2fs_write_checkpoint
                                                 - f2fs_flush_merged_writes
                                                 - f2fs_sync_node_pages
 - f2fs_fsync_node_pages // no dirty node
 - f2fs_need_inode_block_update // return true
 - f2fs_fsync_node_pages // inode dirtied
  - f2fs_need_dentry_mark //return true
                                                 - f2fs_flush_nat_entries
                                                - f2fs_write_checkpoint end
  - __write_node_folio // inode with DENT_BIT_SHIFT set
  SPO, "fsck --dry-run" find inode has already checkpointed but still
  with DENT_BIT_SHIFT set

The state observed by f2fs_need_dentry_mark() can differ from the state
observed in __write_node_folio() after acquiring sbi->node_write. The
root cause is that the semantics of IS_CHECKPOINTED and
HAS_FSYNCED_INODE are only guaranteed after the checkpoint write has
fully completed.

This patch moves set_dentry_mark() into __write_node_folio() and
protects it with the sbi->node_write lock.

Cc: stable@kernel.org
Fixes: 88bd02c9472a ("f2fs: fix conditions to remain recovery information in f2fs_sync_file")
Signed-off-by: Yongpeng Yang <yangyongpeng@xiaomi.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/node.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 56d5fb77569d7..111eba597a4a4 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -1878,9 +1878,6 @@ int f2fs_fsync_node_pages(struct f2fs_sb_info *sbi, struct inode *inode,
 					if (is_inode_flag_set(inode,
 								FI_DIRTY_INODE))
 						f2fs_update_inode(inode, page);
-					if (!atomic)
-						set_dentry_mark(page,
-							f2fs_need_dentry_mark(sbi, ino));
 				}
 				/* may be written by other thread */
 				if (!PageDirty(page))
-- 
2.53.0



