Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30DA546EF77;
	Tue, 21 Jul 2026 18:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659615; cv=none; b=U/rMUDfjpR5HTIYiQNlQKV2ZbpfJIDW+qDn86IpcrIA0PxIETAFiSooxpIao9VxTEwctEw/JEsPgnrgmo+jPfmJcqtjneXZyQZefDKNgXTuUTxUeNgTfU+i751aUIBTVQxNiLyxo+7eLqrQ/VOQiTj+ByGVISAoFqLWMy4Up0eg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659615; c=relaxed/simple;
	bh=N6gvT6FvRWKGKhQTDw+KzfGrLqY694mC2+G43dMjlvE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hl+nd9yGvSxYfFCTFypsqfi1/fW2ACMdbRGBcfhPp/1O4Apnkc9WhriXOi1iOmG3tmWq0zVXUn8QNrPiQMuU/XEQSjJwf2cqA+CGKgFiiT9jzMKY5S/GoAkl0rWS09B7KSuev/nrzNiHJUHCVPEb0zF0kpG7nbajrvHX3J+Iwe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EfRu7+Fa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EfRu7+Fa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4854C1F000E9;
	Tue, 21 Jul 2026 18:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659613;
	bh=f4l66+G8dbpsqREC3C+kf5C/SHdmw/43qn6Wy+E1Avg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EfRu7+FaatrkFoEWpquciOoc+BN2/fTisOhgAc3gVoS6Vmn+NKoPoiKbwh7s5i+nQ
	 1WGKH1q3q2NMb05WEs13ig6OuQJ/7qxbsQLwKTxW2AiyjJjhraIJjHGRtBmKw9TYzP
	 9Lw3HNmC1g7DBy9WIDXhUkOp4LVMY0/dcKMbDZCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Filipe Manana <fdmanana@suse.com>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1588/1611] btrfs: remove folio parameter from ordered io related functions
Date: Tue, 21 Jul 2026 17:28:24 +0200
Message-ID: <20260721152551.191687825@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit a11d6912fdd9e57aff889ec97256b1d6b4e5bf06 ]

Both functions btrfs_finish_ordered_extent() and
btrfs_mark_ordered_io_finished() are accepting an optional folio
parameter.

That @folio is passed into can_finish_ordered_extent(), which later will
test and clear the ordered flag for the involved range.

However I do not think there is any other call site that can clear
ordered flags of an page cache folio and can affect
can_finish_ordered_extent().

There are limited *_clear_ordered() callers out of
can_finish_ordered_extent() function:

- btrfs_migrate_folio()
  This is completely unrelated, it's just migrating the ordered flag to
  the new folio.

- btrfs_cleanup_ordered_extents()
  We manually clean the ordered flags of all involved folios, then call
  btrfs_mark_ordered_io_finished() without a @folio parameter.
  So it doesn't need and didn't pass a @folio parameter in the first
  place.

- btrfs_writepage_fixup_worker()
  This function is going to be removed soon, and we should not hit that
  function anymore.

- btrfs_invalidate_folio()
  This is the real call site we need to bother with.

  If we already have a bio running, btrfs_finish_ordered_extent() in
  end_bbio_data_write() will be executed first, as
  btrfs_invalidate_folio() will wait for the writeback to finish.

  Thus if there is a running bio, it will not see the range has
  ordered flags, and just skip to the next range.

  If there is no bio running, meaning the ordered extent is created but
  the folio is not yet submitted.

  In that case btrfs_invalidate_folio() will manually clear the folio
  ordered range, but then manually finish the ordered extent with
  btrfs_dec_test_ordered_pending() without bothering the folio ordered
  flags.

  Meaning if the OE range with folio ordered flags will be finished
  manually without the need to call can_finish_ordered_extent().

This means all can_finish_ordered_extent() call sites should get a range
that has folio ordered flag set, thus the old "return false" branch
should never be triggered.

Now we can:

- Remove the @folio parameter from involved functions
  * btrfs_mark_ordered_io_finished()
  * btrfs_finish_ordered_extent()

  For call sites passing a @folio into those functions, let them
  manually clear the ordered flag of involved folios.

- Move btrfs_finish_ordered_extent() out of the loop in
  end_bbio_data_write()

  We only need to call btrfs_finish_ordered_extent() once per bbio,
  not per folio.

- Add an ASSERT() to make sure all folio ranges have ordered flags
  It's only for end_bbio_data_write().

  And we already have enough safe nets to catch over-accounting of ordered
  extents.

Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Stable-dep-of: 66ff4d366e7e ("btrfs: fix false IO failure after falling back to buffered write")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/compression.c  |    2 +-
 fs/btrfs/direct-io.c    |    9 ++++-----
 fs/btrfs/extent_io.c    |   23 ++++++++++++++---------
 fs/btrfs/inode.c        |   10 ++++++----
 fs/btrfs/ordered-data.c |   29 +++++------------------------
 fs/btrfs/ordered-data.h |    6 ++----
 6 files changed, 32 insertions(+), 47 deletions(-)

--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -324,7 +324,7 @@ static void btrfs_finish_compressed_writ
 	struct compressed_bio *cb =
 		container_of(work, struct compressed_bio, write_end_work);
 
-	btrfs_finish_ordered_extent(cb->bbio.ordered, NULL, cb->start, cb->len,
+	btrfs_finish_ordered_extent(cb->bbio.ordered, cb->start, cb->len,
 				    cb->bbio.bio.bi_status == BLK_STS_OK);
 
 	if (cb->writeback)
--- a/fs/btrfs/direct-io.c
+++ b/fs/btrfs/direct-io.c
@@ -625,7 +625,7 @@ static int btrfs_dio_iomap_end(struct in
 		pos += submitted;
 		length -= submitted;
 		if (write)
-			btrfs_finish_ordered_extent(dio_data->ordered, NULL,
+			btrfs_finish_ordered_extent(dio_data->ordered,
 						    pos, length, false);
 		else
 			btrfs_unlock_dio_extent(&BTRFS_I(inode)->io_tree, pos,
@@ -657,9 +657,8 @@ static void btrfs_dio_end_io(struct btrf
 	}
 
 	if (btrfs_op(bio) == BTRFS_MAP_WRITE) {
-		btrfs_finish_ordered_extent(bbio->ordered, NULL,
-					    dip->file_offset, dip->bytes,
-					    !bio->bi_status);
+		btrfs_finish_ordered_extent(bbio->ordered, dip->file_offset,
+					    dip->bytes, !bio->bi_status);
 	} else {
 		btrfs_unlock_dio_extent(&inode->io_tree, dip->file_offset,
 					dip->file_offset + dip->bytes - 1, NULL);
@@ -735,7 +734,7 @@ static void btrfs_dio_submit_io(const st
 
 		ret = btrfs_extract_ordered_extent(bbio, dio_data->ordered);
 		if (ret) {
-			btrfs_finish_ordered_extent(dio_data->ordered, NULL,
+			btrfs_finish_ordered_extent(dio_data->ordered,
 						    file_offset, dip->bytes,
 						    !ret);
 			bio->bi_status = errno_to_blk_status(ret);
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -523,6 +523,7 @@ static void end_bbio_data_write(struct b
 	int error = blk_status_to_errno(bio->bi_status);
 	struct folio_iter fi;
 	const u32 sectorsize = fs_info->sectorsize;
+	u32 bio_size = 0;
 
 	ASSERT(!bio_flagged(bio, BIO_CLONED));
 	bio_for_each_folio_all(fi, bio) {
@@ -530,6 +531,7 @@ static void end_bbio_data_write(struct b
 		u64 start = folio_pos(folio) + fi.offset;
 		u32 len = fi.length;
 
+		bio_size += len;
 		/* Our read/write should always be sector aligned. */
 		if (!IS_ALIGNED(fi.offset, sectorsize))
 			btrfs_err(fs_info,
@@ -540,13 +542,15 @@ static void end_bbio_data_write(struct b
 		"incomplete page write with offset %zu and length %zu",
 				   fi.offset, fi.length);
 
-		btrfs_finish_ordered_extent(bbio->ordered, folio, start, len,
-					    !error);
 		if (error)
 			mapping_set_error(folio->mapping, error);
+
+		ASSERT(btrfs_folio_test_ordered(fs_info, folio, start, len));
+		btrfs_folio_clear_ordered(fs_info, folio, start, len);
 		btrfs_folio_clear_writeback(fs_info, folio, start, len);
 	}
 
+	btrfs_finish_ordered_extent(bbio->ordered, bbio->file_offset, bio_size, !error);
 	bio_put(bio);
 }
 
@@ -1566,7 +1570,8 @@ static noinline_for_stack int writepage_
 			u64 start = page_start + (start_bit << fs_info->sectorsize_bits);
 			u32 len = (end_bit - start_bit) << fs_info->sectorsize_bits;
 
-			btrfs_mark_ordered_io_finished(inode, folio, start, len, false);
+			btrfs_folio_clear_ordered(fs_info, folio, start, len);
+			btrfs_mark_ordered_io_finished(inode, start, len, false);
 		}
 		return ret;
 	}
@@ -1642,6 +1647,7 @@ static int submit_one_sector(struct btrf
 		 * ordered extent.
 		 */
 		btrfs_folio_clear_dirty(fs_info, folio, filepos, sectorsize);
+		btrfs_folio_clear_ordered(fs_info, folio, filepos, sectorsize);
 		btrfs_folio_set_writeback(fs_info, folio, filepos, sectorsize);
 		btrfs_folio_clear_writeback(fs_info, folio, filepos, sectorsize);
 
@@ -1649,8 +1655,8 @@ static int submit_one_sector(struct btrf
 		 * Since there is no bio submitted to finish the ordered
 		 * extent, we have to manually finish this sector.
 		 */
-		btrfs_mark_ordered_io_finished(inode, folio, filepos,
-					       fs_info->sectorsize, false);
+		btrfs_mark_ordered_io_finished(inode, filepos, fs_info->sectorsize,
+					       false);
 		return PTR_ERR(em);
 	}
 
@@ -1761,8 +1767,8 @@ static noinline_for_stack int extent_wri
 			spin_unlock_irqrestore(&inode->ordered_tree_lock, flags);
 			btrfs_put_ordered_extent(ordered);
 
-			btrfs_mark_ordered_io_finished(inode, folio, cur,
-						       fs_info->sectorsize, true);
+			btrfs_folio_clear_ordered(fs_info, folio, cur, fs_info->sectorsize);
+			btrfs_mark_ordered_io_finished(inode, cur, fs_info->sectorsize, true);
 			/*
 			 * This range is beyond i_size, thus we don't need to
 			 * bother writing back.
@@ -2640,8 +2646,7 @@ void extent_write_locked_range(struct in
 		if (IS_ERR(folio)) {
 			cur_end = min(round_down(cur, PAGE_SIZE) + PAGE_SIZE - 1, end);
 			cur_len = cur_end + 1 - cur;
-			btrfs_mark_ordered_io_finished(BTRFS_I(inode), NULL,
-						       cur, cur_len, false);
+			btrfs_mark_ordered_io_finished(BTRFS_I(inode), cur, cur_len, false);
 			mapping_set_error(mapping, PTR_ERR(folio));
 			cur = cur_end;
 			continue;
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -424,7 +424,7 @@ static inline void btrfs_cleanup_ordered
 		folio_put(folio);
 	}
 
-	return btrfs_mark_ordered_io_finished(inode, NULL, offset, bytes, false);
+	return btrfs_mark_ordered_io_finished(inode, offset, bytes, false);
 }
 
 static int btrfs_dirty_inode(struct btrfs_inode *inode);
@@ -2864,7 +2864,9 @@ out_page:
 		 * to reflect the errors and clean the page.
 		 */
 		mapping_set_error(folio->mapping, ret);
-		btrfs_mark_ordered_io_finished(inode, folio, page_start,
+		btrfs_folio_clear_ordered(fs_info, folio, page_start,
+					  folio_size(folio));
+		btrfs_mark_ordered_io_finished(inode, page_start,
 					       folio_size(folio), !ret);
 		folio_clear_dirty_for_io(folio);
 	}
@@ -7679,11 +7681,11 @@ static void btrfs_invalidate_folio(struc
 					       EXTENT_LOCKED | EXTENT_DO_ACCOUNTING |
 					       EXTENT_DEFRAG, &cached_state);
 
-		spin_lock_irq(&inode->ordered_tree_lock);
+		spin_lock(&inode->ordered_tree_lock);
 		set_bit(BTRFS_ORDERED_TRUNCATED, &ordered->flags);
 		ordered->truncated_len = min(ordered->truncated_len,
 					     cur - ordered->file_offset);
-		spin_unlock_irq(&inode->ordered_tree_lock);
+		spin_unlock(&inode->ordered_tree_lock);
 
 		/*
 		 * If the ordered extent has finished, we're safe to delete all
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -348,30 +348,13 @@ static void finish_ordered_fn(struct btr
 }
 
 static bool can_finish_ordered_extent(struct btrfs_ordered_extent *ordered,
-				      struct folio *folio, u64 file_offset,
-				      u64 len, bool uptodate)
+				      u64 file_offset, u64 len, bool uptodate)
 {
 	struct btrfs_inode *inode = ordered->inode;
 	struct btrfs_fs_info *fs_info = inode->root->fs_info;
 
 	lockdep_assert_held(&inode->ordered_tree_lock);
 
-	if (folio) {
-		ASSERT(folio->mapping);
-		ASSERT(folio_pos(folio) <= file_offset);
-		ASSERT(file_offset + len <= folio_end(folio));
-
-		/*
-		 * Ordered flag indicates whether we still have
-		 * pending io unfinished for the ordered extent.
-		 *
-		 * If it's not set, we need to skip to next range.
-		 */
-		if (!btrfs_folio_test_ordered(fs_info, folio, file_offset, len))
-			return false;
-		btrfs_folio_clear_ordered(fs_info, folio, file_offset, len);
-	}
-
 	/* Now we're fine to update the accounting. */
 	if (WARN_ON_ONCE(len > ordered->bytes_left)) {
 		btrfs_crit(fs_info,
@@ -413,8 +396,7 @@ static void btrfs_queue_ordered_fn(struc
 }
 
 void btrfs_finish_ordered_extent(struct btrfs_ordered_extent *ordered,
-				 struct folio *folio, u64 file_offset, u64 len,
-				 bool uptodate)
+				 u64 file_offset, u64 len, bool uptodate)
 {
 	struct btrfs_inode *inode = ordered->inode;
 	unsigned long flags;
@@ -423,7 +405,7 @@ void btrfs_finish_ordered_extent(struct
 	trace_btrfs_finish_ordered_extent(inode, file_offset, len, uptodate);
 
 	spin_lock_irqsave(&inode->ordered_tree_lock, flags);
-	ret = can_finish_ordered_extent(ordered, folio, file_offset, len,
+	ret = can_finish_ordered_extent(ordered, file_offset, len,
 					uptodate);
 	spin_unlock_irqrestore(&inode->ordered_tree_lock, flags);
 
@@ -476,8 +458,7 @@ void btrfs_finish_ordered_extent(struct
  * extent(s) covering it.
  */
 void btrfs_mark_ordered_io_finished(struct btrfs_inode *inode,
-				    struct folio *folio, u64 file_offset,
-				    u64 num_bytes, bool uptodate)
+				    u64 file_offset, u64 num_bytes, bool uptodate)
 {
 	struct rb_node *node;
 	struct btrfs_ordered_extent *entry = NULL;
@@ -540,7 +521,7 @@ void btrfs_mark_ordered_io_finished(stru
 		ASSERT(end + 1 - cur < U32_MAX);
 		len = end + 1 - cur;
 
-		if (can_finish_ordered_extent(entry, folio, cur, len, uptodate)) {
+		if (can_finish_ordered_extent(entry, cur, len, uptodate)) {
 			spin_unlock_irqrestore(&inode->ordered_tree_lock, flags);
 			btrfs_queue_ordered_fn(entry);
 			spin_lock_irqsave(&inode->ordered_tree_lock, flags);
--- a/fs/btrfs/ordered-data.h
+++ b/fs/btrfs/ordered-data.h
@@ -164,11 +164,9 @@ void btrfs_put_ordered_extent(struct btr
 void btrfs_remove_ordered_extent(struct btrfs_inode *btrfs_inode,
 				struct btrfs_ordered_extent *entry);
 void btrfs_finish_ordered_extent(struct btrfs_ordered_extent *ordered,
-				 struct folio *folio, u64 file_offset, u64 len,
-				 bool uptodate);
+				 u64 file_offset, u64 len, bool uptodate);
 void btrfs_mark_ordered_io_finished(struct btrfs_inode *inode,
-				    struct folio *folio, u64 file_offset,
-				    u64 num_bytes, bool uptodate);
+				    u64 file_offset, u64 num_bytes, bool uptodate);
 bool btrfs_dec_test_ordered_pending(struct btrfs_inode *inode,
 				    struct btrfs_ordered_extent **cached,
 				    u64 file_offset, u64 io_size);


