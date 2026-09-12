Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 851B642E418;
	Sat, 12 Sep 2026 08:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202586; cv=none; b=QY0F908wmJz6LmkWowxAiHz31nVsp+/h1tdmMBSrPdhK1HTIc9sDFJ4zCDmeC/dQrhMZ/4XtC+rIR5wiQQ4qyfb1lTECjVBxKL41In3O3ynQl4FZWh/CZwBAE3Irl5NG3K1r1xMyAoAfZb9H+w13pakd2Iqphcf48khgA4TefuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202586; c=relaxed/simple;
	bh=7uNur1zRuBgNYLJINmLnyyyb8WWgnizVCeKClU+fh4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r23BRLZaJROwxLpjqXoJPhkDMFxQWv3nclIOUTNQKw57EtgHDJ677qi3Me1tGS+Gj88/azK4qGJ0ifupoYnBdhSJvvbsMvGGsGiAqOryQc9HrYQZuxuJbB7uFBxygwWw/iqMsdPnd4ztLpgLiSyA0rZsKYpuYqrB/U7Vi8DjmbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F7IeSJl/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F7IeSJl/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59A491F000FF;
	Sat, 12 Sep 2026 08:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202585;
	bh=GQfDH8w2CnWZQUo0hRXaQLpdEaBUENplq9V2MNrJGe0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F7IeSJl/GsFPTVpoUl+9syO0G+WSTpW3GHQk6JTcZcAmPCyCWIvVy8s2pOb5+GwBU
	 ICJuH0umNHUw9dCrYohBYiuMN/5rPWuC4KTGdEf5xaiGKDi/DJRh92/QASzIB49q5M
	 KhdDYF3ktgfYQFuNuVF4PiMPqSbJ2O6QcH6WA0Aw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1231/1815] btrfs: zoned: flush active metadata block group at btree_writepages() start
Date: Sat, 12 Sep 2026 08:49:41 +0200
Message-ID: <20260912065717.911805195@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Thumshirn <johannes.thumshirn@wdc.com>

[ Upstream commit ecc05eda9a346848ae01a6c8bfa3f0bec133bd8b ]

btree_writepages() writes the btree inode's dirty metadata in ascending
logical address order. On a zoned filesystem only one metadata and one
system block group is active for writing at a time, and
check_bg_is_active() (via btrfs_check_meta_write_pointer()) pivots the
active block group as writeback moves from one block group to the next.

If the active block group sits at a higher logical address than another
block group that also holds dirty metadata, the ascending walk reaches
the lower one first and, to write it, has to finish the active block
group and activate the lower one. It cannot finish a block group that
still has unsent IO, and during WB_SYNC_ALL && !for_sync (commit)
writeback it deliberately refuses to wait for that IO under
fs_info->zoned_meta_io_lock, as that can deadlock. The pivot thus cannot
issue the submission itself either, so it gives up:
btrfs_check_meta_write_pointer() returns -EAGAIN, which
btrfs_write_and_wait_transaction() treats as fatal and aborts the
transaction, forcing the filesystem read-only. This happens
intermittently under metadata-heavy relocation (e.g. fstests btrfs/187).

Flush the active metadata and system block groups at the start of
btree_writepages(), under the fs_info->zoned_meta_io_lock it already
holds, so they have no unsent IO left and the later pivot can finish
them and make forward progress.

Fixes: 13bb483d32ab ("btrfs: zoned: activate metadata block group on write time")
Assisted-by: LLM (debugging, commit message)
Reviewed-by: Boris Burkov <boris@bur.io>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/extent_io.c | 113 +++++++++++++++++++++++++++++++++++--------
 1 file changed, 92 insertions(+), 21 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 7c71935e20b72..df341a605ac0c 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2496,6 +2496,76 @@ void btrfs_btree_wait_writeback_range(struct btrfs_fs_info *fs_info, u64 start,
 	}
 }
 
+static int write_meta_extent_buffer(struct btrfs_eb_write_context *ctx,
+				    struct writeback_control *wbc)
+{
+	struct extent_buffer *eb = ctx->eb;
+	int ret;
+
+	ret = btrfs_check_meta_write_pointer(eb->fs_info, ctx);
+	if (ret)
+		return ret;
+
+	if (!lock_extent_buffer_for_io(eb, wbc))
+		return 0;
+
+	/* Implies write in zoned mode. */
+	if (ctx->zoned_bg) {
+		/* Mark the last eb in the block group. */
+		btrfs_schedule_zone_finish_bg(ctx->zoned_bg, eb);
+		ctx->zoned_bg->meta_write_pointer += eb->len;
+	}
+	write_one_eb(eb, wbc);
+	return 0;
+}
+
+/*
+ * On a zoned filesystem, write out the currently dirty metadata extent buffers
+ * of @bg. Used to flush the active metadata/system block group before the
+ * ascending-address walk in btree_writepages(), so that walk can pivot the
+ * active block group away (finishing it) instead of aborting the commit; see
+ * the caller for details.
+ */
+static void flush_active_meta_bg(struct address_space *mapping,
+				 struct writeback_control *wbc,
+				 struct btrfs_eb_write_context *ctx,
+				 struct btrfs_block_group *bg)
+{
+	struct btrfs_fs_info *fs_info = inode_to_fs_info(mapping->host);
+	unsigned long index = bg->start >> fs_info->nodesize_bits;
+	unsigned long end = (btrfs_block_group_end(bg) - 1) >> fs_info->nodesize_bits;
+	struct eb_batch batch;
+	unsigned int nr_ebs;
+
+	ASSERT(btrfs_is_zoned(fs_info));
+	lockdep_assert_held(&fs_info->zoned_meta_io_lock);
+
+	eb_batch_init(&batch);
+	while (index <= end &&
+	       (nr_ebs = buffer_tree_get_ebs_tag(fs_info, &index, end,
+						 PAGECACHE_TAG_DIRTY, &batch))) {
+		struct extent_buffer *eb;
+
+		while ((eb = eb_batch_next(&batch)) != NULL) {
+			ctx->eb = eb;
+
+			/*
+			 * If the eb is behind the write pointer (-EBUSY, e.g.
+			 * already being written by someone else) skip it and
+			 * carry on. Only a hole at the write pointer (-EAGAIN)
+			 * stops the flush. The main walk in btree_writepages()
+			 * then deals with it.
+			 */
+			if (write_meta_extent_buffer(ctx, wbc) == -EAGAIN) {
+				eb_batch_release(&batch);
+				return;
+			}
+		}
+		eb_batch_release(&batch);
+		cond_resched();
+	}
+}
+
 int btree_writepages(struct address_space *mapping, struct writeback_control *wbc)
 {
 	struct btrfs_eb_write_context ctx = { .wbc = wbc };
@@ -2531,6 +2601,22 @@ int btree_writepages(struct address_space *mapping, struct writeback_control *wb
 	else
 		tag = PAGECACHE_TAG_DIRTY;
 	btrfs_zoned_meta_io_lock(fs_info);
+
+	/*
+	 * On a zoned filesystem, flush the currently active metadata/system
+	 * block group(s) first, under this same lock, so the ascending-address
+	 * walk below can pivot the active block group instead of aborting the
+	 * transaction commit with -EAGAIN.
+	 */
+	if (btrfs_is_zoned(fs_info) && wbc->sync_mode == WB_SYNC_ALL &&
+	    !wbc->for_sync) {
+		if (fs_info->active_meta_bg)
+			flush_active_meta_bg(mapping, wbc, &ctx,
+					     fs_info->active_meta_bg);
+		if (fs_info->active_system_bg)
+			flush_active_meta_bg(mapping, wbc, &ctx,
+					     fs_info->active_system_bg);
+	}
 retry:
 	if (wbc->sync_mode == WB_SYNC_ALL)
 		buffer_tree_tag_for_writeback(fs_info, index, end);
@@ -2541,28 +2627,13 @@ int btree_writepages(struct address_space *mapping, struct writeback_control *wb
 		while ((eb = eb_batch_next(&batch)) != NULL) {
 			ctx.eb = eb;
 
-			ret = btrfs_check_meta_write_pointer(eb->fs_info, &ctx);
-			if (ret) {
-				if (ret == -EBUSY)
-					ret = 0;
-
-				if (ret) {
-					done = true;
-					break;
-				}
-				continue;
-			}
-
-			if (!lock_extent_buffer_for_io(eb, wbc))
-				continue;
-
-			/* Implies write in zoned mode. */
-			if (ctx.zoned_bg) {
-				/* Mark the last eb in the block group. */
-				btrfs_schedule_zone_finish_bg(ctx.zoned_bg, eb);
-				ctx.zoned_bg->meta_write_pointer += eb->len;
+			ret = write_meta_extent_buffer(&ctx, wbc);
+			if (ret == -EBUSY) {
+				ret = 0;
+			} else if (ret) {
+				done = true;
+				break;
 			}
-			write_one_eb(eb, wbc);
 		}
 		nr_to_write_done = (wbc->nr_to_write <= 0);
 		eb_batch_release(&batch);
-- 
2.53.0



