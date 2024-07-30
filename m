Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F16CA1A76A4;
	Tue, 30 Jul 2024 17:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359721; cv=none; b=LWPB/RHCb9/GCMXvI8zH5yl7EaOU7DlwFP7AerNAUUzDF31dCUAh0IqdHNM7oOtKuYkXqUXm3cL0LoBvWEmUCzdfCLkqbuKgt116gdvky34sayPB/yCxadDdbR+EMpkQEzpn2IvMjeo3iLNWh9JR8HulXDLP51sKcOFyX/F3w78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359721; c=relaxed/simple;
	bh=Jw9GsFjIJYQZ5FaDuC3z3ayjDZq+g9X4yodlvvCSGQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F/nQY/S2wNpjKWr6jmyGDI1H5LAfsBOYfWT3kiZ58H8jz1s2ZohwF6sFUG9CV8WTE1cR5uKJIkCIx2jPIXruF2g58yRSYcWOUzzXBEzYmV5i6/144Tk1a165y4PHS1Asx3wUFn4gvJBNB6dskByZc9vyKzFxEuB2tx8YnlEwhi0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=abYhQoOl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="abYhQoOl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47CA6C4AF0F;
	Tue, 30 Jul 2024 17:15:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359720;
	bh=Jw9GsFjIJYQZ5FaDuC3z3ayjDZq+g9X4yodlvvCSGQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=abYhQoOl2+8bTjvYCDfIBX03mjOfBc4RRKW5LwqpamnOkhBZuJtFGGslvBkTixYgd
	 ZzVTpY9DNpduUwUZaZmCGEuhdl9sJWi5k0pLKXeYb8PX9ygenQd0mZstuei4mDMP1M
	 bHM5D9Qm48NZ7oNbUgXN6t51+SiqjrUHoxyp60bw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunlei He <heyunlei@oppo.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 527/568] f2fs: fix to update user block counts in block_operations()
Date: Tue, 30 Jul 2024 17:50:34 +0200
Message-ID: <20240730151700.756488487@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

From: Chao Yu <chao@kernel.org>

[ Upstream commit f06c0f82e38bbda7264d6ef3c90045ad2810e0f3 ]

Commit 59c9081bc86e ("f2fs: allow write page cache when writting cp")
allows write() to write data to page cache during checkpoint, so block
count fields like .total_valid_block_count, .alloc_valid_block_count
and .rf_node_block_count may encounter race condition as below:

CP				Thread A
- write_checkpoint
 - block_operations
  - f2fs_down_write(&sbi->node_change)
  - __prepare_cp_block
  : ckpt->valid_block_count = .total_valid_block_count
  - f2fs_up_write(&sbi->node_change)
				- write
				 - f2fs_preallocate_blocks
				  - f2fs_map_blocks(,F2FS_GET_BLOCK_PRE_AIO)
				   - f2fs_map_lock
				    - f2fs_down_read(&sbi->node_change)
				   - f2fs_reserve_new_blocks
				    - inc_valid_block_count
				    : percpu_counter_add(&sbi->alloc_valid_block_count, count)
				    : sbi->total_valid_block_count += count
				    - f2fs_up_read(&sbi->node_change)
 - do_checkpoint
 : sbi->last_valid_block_count = sbi->total_valid_block_count
 : percpu_counter_set(&sbi->alloc_valid_block_count, 0)
 : percpu_counter_set(&sbi->rf_node_block_count, 0)
				- fsync
				 - need_do_checkpoint
				  - f2fs_space_for_roll_forward
				  : alloc_valid_block_count was reset to zero,
				    so, it may missed last data during checkpoint

Let's change to update .total_valid_block_count, .alloc_valid_block_count
and .rf_node_block_count in block_operations(), then their access can be
protected by .node_change and .cp_rwsem lock, so that it can avoid above
race condition.

Fixes: 59c9081bc86e ("f2fs: allow write page cache when writting cp")
Cc: Yunlei He <heyunlei@oppo.com>
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/checkpoint.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/f2fs/checkpoint.c b/fs/f2fs/checkpoint.c
index 58ce751da92bf..1a33a8c1623f2 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -1170,6 +1170,11 @@ static void __prepare_cp_block(struct f2fs_sb_info *sbi)
 	ckpt->valid_node_count = cpu_to_le32(valid_node_count(sbi));
 	ckpt->valid_inode_count = cpu_to_le32(valid_inode_count(sbi));
 	ckpt->next_free_nid = cpu_to_le32(last_nid);
+
+	/* update user_block_counts */
+	sbi->last_valid_block_count = sbi->total_valid_block_count;
+	percpu_counter_set(&sbi->alloc_valid_block_count, 0);
+	percpu_counter_set(&sbi->rf_node_block_count, 0);
 }
 
 static bool __need_flush_quota(struct f2fs_sb_info *sbi)
@@ -1559,11 +1564,6 @@ static int do_checkpoint(struct f2fs_sb_info *sbi, struct cp_control *cpc)
 		start_blk += NR_CURSEG_NODE_TYPE;
 	}
 
-	/* update user_block_counts */
-	sbi->last_valid_block_count = sbi->total_valid_block_count;
-	percpu_counter_set(&sbi->alloc_valid_block_count, 0);
-	percpu_counter_set(&sbi->rf_node_block_count, 0);
-
 	/* Here, we have one bio having CP pack except cp pack 2 page */
 	f2fs_sync_meta_pages(sbi, META, LONG_MAX, FS_CP_META_IO);
 	/* Wait for all dirty meta pages to be submitted for IO */
-- 
2.43.0



