Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB31A26ADD;
	Mon, 24 Feb 2025 14:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408288; cv=none; b=Glq3oqsrgdTrje1dsm6Jgq9q9v2a2ywgZezd1GSt7293vrGxK8E7IupGCj1jdngSNl2evovJNDeslYnMAaPZnV2IVOJUmVvoFx7OhQpyp4MX2iPtpKCKhbuGs2AwvxRC2LTMavyZVoaWrV4oabkyWf1p0+ysd/Cs3km3tSpIQKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408288; c=relaxed/simple;
	bh=uRHW7RpTgz7jJsOvTGAgIao2Igv4QBtS6O0s/NsrIxg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SA2YQqbFu9f6r+Y1wvgFoAdGUFILd53kDLXH4oa8GAm3W3jEznD/XsVBF6nwlP/VHnjxjFOZe8mEMX2kjOLOPiIf4Vx0xIN6CVK0X79GMtjkOG8QckrcGfifnbhYpFvxD0Xd1FE5+QIBN/DPFwVw4Vj5LRTYsWqBVPmD/a1eeoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DUtCww+s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DUtCww+s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18942C4CED6;
	Mon, 24 Feb 2025 14:44:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408288;
	bh=uRHW7RpTgz7jJsOvTGAgIao2Igv4QBtS6O0s/NsrIxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DUtCww+sXAqq+LzsHBTP/DZ2bMN2s/5RwJ3lBbRB3diThZ2DTq90TVDwtNwsB41r4
	 JDmh5CAgrKa353FeosWR50zgr2/V+0k1/mos9dsVuftJ6nAalFsjvwunt8KOYnpPMv
	 3aOjbm9dyF/HtAGvS9c6XV5/V7Obm8pEUAOSU8+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 014/154] btrfs: fix double accounting race when extent_writepage_io() failed
Date: Mon, 24 Feb 2025 15:33:33 +0100
Message-ID: <20250224142607.635074913@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142607.058226288@linuxfoundation.org>
References: <20250224142607.058226288@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit 8bf334beb3496da3c3fbf3daf3856f7eec70dacc ]

[BUG]
If submit_one_sector() failed inside extent_writepage_io() for sector
size < page size cases (e.g. 4K sector size and 64K page size), then
we can hit double ordered extent accounting error.

This should be very rare, as submit_one_sector() only fails when we
failed to grab the extent map, and such extent map should exist inside
the memory and has been pinned.

[CAUSE]
For example we have the following folio layout:

    0  4K          32K    48K   60K 64K
    |//|           |//////|     |///|

Where |///| is the dirty range we need to writeback. The 3 different
dirty ranges are submitted for regular COW.

Now we hit the following sequence:

- submit_one_sector() returned 0 for [0, 4K)

- submit_one_sector() returned 0 for [32K, 48K)

- submit_one_sector() returned error for [60K, 64K)

- btrfs_mark_ordered_io_finished() called for the whole folio
  This will mark the following ranges as finished:
  * [0, 4K)
  * [32K, 48K)
    Both ranges have their IO already submitted, this cleanup will
    lead to double accounting.

  * [60K, 64K)
    That's the correct cleanup.

The only good news is, this error is only theoretical, as the target
extent map is always pinned, thus we should directly grab it from
memory, other than reading it from the disk.

[FIX]
Instead of calling btrfs_mark_ordered_io_finished() for the whole folio
range, which can touch ranges we should not touch, instead
move the error handling inside extent_writepage_io().

So that we can cleanup exact sectors that ought to be submitted but failed.

This provides much more accurate cleanup, avoiding the double accounting.

CC: stable@vger.kernel.org # 5.15+
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/extent_io.c | 37 ++++++++++++++++++++++++-------------
 1 file changed, 24 insertions(+), 13 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 15cbb2a865e5e..660a5b9c08e9e 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -1431,6 +1431,7 @@ static noinline_for_stack int extent_writepage_io(struct btrfs_inode *inode,
 	struct btrfs_fs_info *fs_info = inode->root->fs_info;
 	unsigned long range_bitmap = 0;
 	bool submitted_io = false;
+	bool error = false;
 	const u64 folio_start = folio_pos(folio);
 	u64 cur;
 	int bit;
@@ -1473,11 +1474,26 @@ static noinline_for_stack int extent_writepage_io(struct btrfs_inode *inode,
 			break;
 		}
 		ret = submit_one_sector(inode, folio, cur, bio_ctrl, i_size);
-		if (ret < 0)
-			goto out;
+		if (unlikely(ret < 0)) {
+			/*
+			 * bio_ctrl may contain a bio crossing several folios.
+			 * Submit it immediately so that the bio has a chance
+			 * to finish normally, other than marked as error.
+			 */
+			submit_one_bio(bio_ctrl);
+			/*
+			 * Failed to grab the extent map which should be very rare.
+			 * Since there is no bio submitted to finish the ordered
+			 * extent, we have to manually finish this sector.
+			 */
+			btrfs_mark_ordered_io_finished(inode, folio, cur,
+						       fs_info->sectorsize, false);
+			error = true;
+			continue;
+		}
 		submitted_io = true;
 	}
-out:
+
 	/*
 	 * If we didn't submitted any sector (>= i_size), folio dirty get
 	 * cleared but PAGECACHE_TAG_DIRTY is not cleared (only cleared
@@ -1485,8 +1501,11 @@ static noinline_for_stack int extent_writepage_io(struct btrfs_inode *inode,
 	 *
 	 * Here we set writeback and clear for the range. If the full folio
 	 * is no longer dirty then we clear the PAGECACHE_TAG_DIRTY tag.
+	 *
+	 * If we hit any error, the corresponding sector will still be dirty
+	 * thus no need to clear PAGECACHE_TAG_DIRTY.
 	 */
-	if (!submitted_io) {
+	if (!submitted_io && !error) {
 		btrfs_folio_set_writeback(fs_info, folio, start, len);
 		btrfs_folio_clear_writeback(fs_info, folio, start, len);
 	}
@@ -1506,7 +1525,6 @@ static int extent_writepage(struct folio *folio, struct btrfs_bio_ctrl *bio_ctrl
 {
 	struct btrfs_inode *inode = BTRFS_I(folio->mapping->host);
 	struct btrfs_fs_info *fs_info = inode->root->fs_info;
-	const u64 page_start = folio_pos(folio);
 	int ret;
 	size_t pg_offset;
 	loff_t i_size = i_size_read(&inode->vfs_inode);
@@ -1549,10 +1567,6 @@ static int extent_writepage(struct folio *folio, struct btrfs_bio_ctrl *bio_ctrl
 
 	bio_ctrl->wbc->nr_to_write--;
 
-	if (ret)
-		btrfs_mark_ordered_io_finished(inode, folio,
-					       page_start, PAGE_SIZE, !ret);
-
 done:
 	if (ret < 0)
 		mapping_set_error(folio->mapping, ret);
@@ -2312,11 +2326,8 @@ void extent_write_locked_range(struct inode *inode, const struct folio *locked_f
 		if (ret == 1)
 			goto next_page;
 
-		if (ret) {
-			btrfs_mark_ordered_io_finished(BTRFS_I(inode), folio,
-						       cur, cur_len, !ret);
+		if (ret)
 			mapping_set_error(mapping, ret);
-		}
 		btrfs_folio_end_lock(fs_info, folio, cur, cur_len);
 		if (ret < 0)
 			found_error = true;
-- 
2.39.5



