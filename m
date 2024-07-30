Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53005189537;
	Tue, 30 Jul 2024 16:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358574; cv=none; b=kuaf6EHxI+1W/gUYIiMy6Z5Emkanbc/Ev01guilGPM+Lx/n0MggnkLo1mLCya7qtwlSDs25A8lge/iUBtdZYIHL0B5j+fElaegrDJOw+1me6yXb4v1Z1yfnxa7zVBDHNI/J1X5jlOp0pyZ/guiWj3PeQ5qut3FObZ9ncdxm3398=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358574; c=relaxed/simple;
	bh=a9q8igH7ppooWfi5MgMRFN9VxbNvJ8tW+5Obb04ZWfo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M/szRsZIZccpVfmiJ3bsXXiZoNwRYrlocZjcwefA79aAsEjuLVvjJE5s53z4NigNSnvcgCIisUpEu1eI4cKZRgZAHQIjPMZtMLM9Y3BZWmJsWxZwOtugwn7s2KVxe8c69+Yw+pIWlaimyXjytxan88KrPz9EdD5/VjuQ1NROvPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZaCFWF1D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZaCFWF1D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A52CC4AF0C;
	Tue, 30 Jul 2024 16:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358574;
	bh=a9q8igH7ppooWfi5MgMRFN9VxbNvJ8tW+5Obb04ZWfo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZaCFWF1DbV/XqTaBTE7w/1aIt1J6bS+4Pw/WGCXD3rBdofV/Hy+vr1CVugPuI9+aB
	 m6jnFnjTTMaR6eFXasqItyJi8vwhZ6H7Ci/yICZSOfX98xIniY6XhFggWGcCU38uIS
	 FjriKhHD6I1+vNm1SUftATEOoPkAJWBmYHeeD9AM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yunlei He <heyunlei@oppo.com>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 403/440] f2fs: fix to update user block counts in block_operations()
Date: Tue, 30 Jul 2024 17:50:36 +0200
Message-ID: <20240730151631.539946245@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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
index 13d8774706758..ad4073cde397b 100644
--- a/fs/f2fs/checkpoint.c
+++ b/fs/f2fs/checkpoint.c
@@ -1178,6 +1178,11 @@ static void __prepare_cp_block(struct f2fs_sb_info *sbi)
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
@@ -1569,11 +1574,6 @@ static int do_checkpoint(struct f2fs_sb_info *sbi, struct cp_control *cpc)
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



