Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC48418658
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 11:50:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 721B4C433C7;
	Wed, 20 Sep 2023 11:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695210602;
	bh=nhyjApE0O9F4m5n4pLA4NI/jdMn/ByzqC0MhHYUuqjM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LP16F//lOhi3uEUI9gxtiieOqt3Nfys65VPZodRqVemZfXtVgncY+fS3pPUrctRLB
	 5ulwHTaWCsL+pPls6vS8LF3txTys5Jypj5BsV5epNd49/I+sMueTPm7mQxmJ2/0gRU
	 PiwKe5JFXOz0k29ebhwpY5/iZl5vHjkJRQM7Hksw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naohiro Aota <naohiro.aota@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 138/211] btrfs: zoned: activate metadata block group on write time
Date: Wed, 20 Sep 2023 13:29:42 +0200
Message-ID: <20230920112850.117164831@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112845.859868994@linuxfoundation.org>
References: <20230920112845.859868994@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Naohiro Aota <naohiro.aota@wdc.com>

[ Upstream commit 13bb483d32abb6f8ebd40141d87eb68f11cc2dd2 ]

In the current implementation, block groups are activated at reservation
time to ensure that all reserved bytes can be written to an active metadata
block group. However, this approach has proven to be less efficient, as it
activates block groups more frequently than necessary, putting pressure on
the active zone resource and leading to potential issues such as early
ENOSPC or hung_task.

Another drawback of the current method is that it hampers metadata
over-commit, and necessitates additional flush operations and block group
allocations, resulting in decreased overall performance.

To address these issues, this commit introduces a write-time activation of
metadata and system block group. This involves reserving at least one
active block group specifically for a metadata and system block group.

Since metadata write-out is always allocated sequentially, when we need to
write to a non-active block group, we can wait for the ongoing IOs to
complete, activate a new block group, and then proceed with writing to the
new block group.

Fixes: b09315139136 ("btrfs: zoned: activate metadata block group on flush_space")
CC: stable@vger.kernel.org # 6.1+
Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/block-group.c | 11 ++++++
 fs/btrfs/fs.h          |  3 ++
 fs/btrfs/zoned.c       | 81 ++++++++++++++++++++++++++++++++++++++++--
 3 files changed, 93 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 82324c327a502..75385503a35b6 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -4273,6 +4273,17 @@ int btrfs_free_block_groups(struct btrfs_fs_info *info)
 	struct btrfs_caching_control *caching_ctl;
 	struct rb_node *n;
 
+	if (btrfs_is_zoned(info)) {
+		if (info->active_meta_bg) {
+			btrfs_put_block_group(info->active_meta_bg);
+			info->active_meta_bg = NULL;
+		}
+		if (info->active_system_bg) {
+			btrfs_put_block_group(info->active_system_bg);
+			info->active_system_bg = NULL;
+		}
+	}
+
 	write_lock(&info->block_group_cache_lock);
 	while (!list_empty(&info->caching_block_groups)) {
 		caching_ctl = list_entry(info->caching_block_groups.next,
diff --git a/fs/btrfs/fs.h b/fs/btrfs/fs.h
index 203d2a2678287..1f2d331121064 100644
--- a/fs/btrfs/fs.h
+++ b/fs/btrfs/fs.h
@@ -766,6 +766,9 @@ struct btrfs_fs_info {
 	u64 data_reloc_bg;
 	struct mutex zoned_data_reloc_io_lock;
 
+	struct btrfs_block_group *active_meta_bg;
+	struct btrfs_block_group *active_system_bg;
+
 	u64 nr_global_roots;
 
 	spinlock_t zone_active_bgs_lock;
diff --git a/fs/btrfs/zoned.c b/fs/btrfs/zoned.c
index cc117283d0c88..f97e927499d7a 100644
--- a/fs/btrfs/zoned.c
+++ b/fs/btrfs/zoned.c
@@ -65,6 +65,9 @@
 
 #define SUPER_INFO_SECTORS	((u64)BTRFS_SUPER_INFO_SIZE >> SECTOR_SHIFT)
 
+static void wait_eb_writebacks(struct btrfs_block_group *block_group);
+static int do_zone_finish(struct btrfs_block_group *block_group, bool fully_written);
+
 static inline bool sb_zone_is_full(const struct blk_zone *zone)
 {
 	return (zone->cond == BLK_ZONE_COND_FULL) ||
@@ -1758,6 +1761,62 @@ void btrfs_finish_ordered_zoned(struct btrfs_ordered_extent *ordered)
 	}
 }
 
+static bool check_bg_is_active(struct btrfs_eb_write_context *ctx,
+			       struct btrfs_block_group **active_bg)
+{
+	const struct writeback_control *wbc = ctx->wbc;
+	struct btrfs_block_group *block_group = ctx->zoned_bg;
+	struct btrfs_fs_info *fs_info = block_group->fs_info;
+
+	if (test_bit(BLOCK_GROUP_FLAG_ZONE_IS_ACTIVE, &block_group->runtime_flags))
+		return true;
+
+	if (fs_info->treelog_bg == block_group->start) {
+		if (!btrfs_zone_activate(block_group)) {
+			int ret_fin = btrfs_zone_finish_one_bg(fs_info);
+
+			if (ret_fin != 1 || !btrfs_zone_activate(block_group))
+				return false;
+		}
+	} else if (*active_bg != block_group) {
+		struct btrfs_block_group *tgt = *active_bg;
+
+		/* zoned_meta_io_lock protects fs_info->active_{meta,system}_bg. */
+		lockdep_assert_held(&fs_info->zoned_meta_io_lock);
+
+		if (tgt) {
+			/*
+			 * If there is an unsent IO left in the allocated area,
+			 * we cannot wait for them as it may cause a deadlock.
+			 */
+			if (tgt->meta_write_pointer < tgt->start + tgt->alloc_offset) {
+				if (wbc->sync_mode == WB_SYNC_NONE ||
+				    (wbc->sync_mode == WB_SYNC_ALL && !wbc->for_sync))
+					return false;
+			}
+
+			/* Pivot active metadata/system block group. */
+			btrfs_zoned_meta_io_unlock(fs_info);
+			wait_eb_writebacks(tgt);
+			do_zone_finish(tgt, true);
+			btrfs_zoned_meta_io_lock(fs_info);
+			if (*active_bg == tgt) {
+				btrfs_put_block_group(tgt);
+				*active_bg = NULL;
+			}
+		}
+		if (!btrfs_zone_activate(block_group))
+			return false;
+		if (*active_bg != block_group) {
+			ASSERT(*active_bg == NULL);
+			*active_bg = block_group;
+			btrfs_get_block_group(block_group);
+		}
+	}
+
+	return true;
+}
+
 /*
  * Check if @ctx->eb is aligned to the write pointer.
  *
@@ -1792,8 +1851,26 @@ int btrfs_check_meta_write_pointer(struct btrfs_fs_info *fs_info,
 		ctx->zoned_bg = block_group;
 	}
 
-	if (block_group->meta_write_pointer == eb->start)
-		return 0;
+	if (block_group->meta_write_pointer == eb->start) {
+		struct btrfs_block_group **tgt;
+
+		if (!test_bit(BTRFS_FS_ACTIVE_ZONE_TRACKING, &fs_info->flags))
+			return 0;
+
+		if (block_group->flags & BTRFS_BLOCK_GROUP_SYSTEM)
+			tgt = &fs_info->active_system_bg;
+		else
+			tgt = &fs_info->active_meta_bg;
+		if (check_bg_is_active(ctx, tgt))
+			return 0;
+	}
+
+	/*
+	 * Since we may release fs_info->zoned_meta_io_lock, someone can already
+	 * start writing this eb. In that case, we can just bail out.
+	 */
+	if (block_group->meta_write_pointer > eb->start)
+		return -EBUSY;
 
 	/* If for_sync, this hole will be filled with trasnsaction commit. */
 	if (wbc->sync_mode == WB_SYNC_ALL && !wbc->for_sync)
-- 
2.40.1



