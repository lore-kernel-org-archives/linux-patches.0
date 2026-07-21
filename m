Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0AD135C686;
	Tue, 21 Jul 2026 22:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672975; cv=none; b=VrOuTLruOOI45CyF5KOtgKPmr+NuhIH/evUKSMYlMGAGmYHNi8P0W4Jw0nWLKuD6F5Eghtx0IaZQYVnhrc+OZBspeGodXgIlbNlhZnqAFRjjvFd1Glx7XjFbpB9Hjt/YLTZYOLtxGBey29AKfuTX7Mc4//iTNJ1LBZ3nVFrfQ2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672975; c=relaxed/simple;
	bh=l4Po+PxU8ViiE2pvgQMpd8MuZl+a5VKpnwBDNDlNDMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WgmRhSv2ygS+LKVoKO5EEYih9NssxPtE0tq/sH4lAWiTpKq7M/uWigrfBb+4Y8wl+TZVnk0MDZ/io2Lv0jsnRiqAqfJmPPE2XaHsbRuT/Ddld4ecc4RqFeqfPkJ9A5z5orPwinMExN87D/k9qih8rNq7v4PYe3M21yLnBeaj4WY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pHeHJGkr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pHeHJGkr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D6451F000E9;
	Tue, 21 Jul 2026 22:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672973;
	bh=0/EJ2NO+kpy03bismAPfrPfReX/lP1HsX4W5KT2J1Ps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pHeHJGkrgw1YOcn5u/1e2noRBICYR/YPUtr8pMudEbnzWqU6aSn8Vf2IbmFoSraGT
	 s7AqyX27MjnVTLQc+V4loVuttQh5ROszVT/B6w5CoYchpfBzVasm/kPcHKT9C4g9/I
	 g56mRX518xHbCx6lT7GCYT8kyGw1ZmihvzQ8J3kk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boris Burkov <boris@bur.io>,
	Qu Wenruo <wqu@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 828/843] btrfs: fix false IO failure after falling back to buffered write
Date: Tue, 21 Jul 2026 17:27:43 +0200
Message-ID: <20260721152424.703847602@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qu Wenruo <wqu@suse.com>

[ Upstream commit 66ff4d366e7eb4d31813d2acabf3af512ce03aa5 ]

[BUG]
The test case generic/362 will fail with "nodatasum" mount option (*):

 MOUNT_OPTIONS -- -o nodatasum /dev/mapper/test-scratch1 /mnt/scratch

# generic/362  0s ... - output mismatch (see /home/adam/xfstests/results//generic/362.out.bad)
#    --- tests/generic/362.out	2024-08-24 15:31:37.200000000 +0930
#    +++ /home/adam/xfstests/results//generic/362.out.bad	2026-05-27 10:21:17.574771567 +0930
#    @@ -1,2 +1,3 @@
#     QA output created by 362
#    +First write failed: Input/output error
#     Silence is golden
#    ...

*: If the test case has been executed before with default data checksum,
the failure will not reproduce. Need the following fix to make it
reliably reproducible:
https://lore.kernel.org/linux-btrfs/20260528111659.87113-1-wqu@suse.com/

[CAUSE]
Inside __iomap_dio_rw(), the -EFAULT/-ENOTBLK error is not directly returned.
Thus we never got an error pointer from __iomap_dio_rw().

The call chain looks like this:

 btrfs_direct_write()
 |- btrfs_dio_write()
 |-  __iomap_dio_rw()
 |  |- iomap_iter()
 |  |  |- btrfs_dio_iomap_begin()
 |  |     Now an ordered extent is allocated for the 4K write.
 |  |
 |  |- iomi.status = iomap_dio_iter()
 |  |  Where iomap_dio_iter() returned -EFAULT.
 |  |
 |  |- ret = iomap_iter()
 |  |  |- btrfs_dio_iomap_end()
 |  |  |  |- btrfs_finish_ordered_extent(uptodate = false)
 |  |  |  |  |- can_finish_ordered_extent()
 |  |  |  |     |- btrfs_mark_ordered_extent_error()
 |  |  |  |        |- mapping_set_error()
 |  |  |  |           Now the address space is marked error.
 |  |  |  | return -ENOTBLK
 |  |  |- return -ENOTBLK
 |  |- if (ret == -ENOTBLK) { ret = 0; }
 |     Now the return value is reset to 0.
 |     Thus no error pointer will be returned.
 |
 |- ret = iomap_dio_complete()
 |  Since no byte is submitted, @ret is 0.
 |
 |- Fallback to buffered IO
 |  And the buffered write finished without error
 |
 |- filemap_fdatawait_range()
    |- filemap_check_errors()
       The previous error is recorded, thus an error is returned

However the buffered write is properly submitted and finished, the error
is from the btrfs_finish_ordered_extent() call with @uptodate = false.

[FIX]
When a short dio write happened, any range that is submitted will have
btrfs_extract_ordered_extent() to be called, thus the submitted range
will always have an OE just covering the submitted range.

The remaining OE range is never submitted, thus they should be treated
as truncated, not an error. So that we can properly reclaim and not
insert an unnecessary file extent item, without marking the mapping as
error.

Extract a helper, btrfs_mark_ordered_extent_truncated(), and utilize
that helper to mark the direct IO ordered extent as truncated, so it
won't cause failure for the later buffered fallback.

[REASON FOR NO FIXES TAG]
The bug itself is pretty old, at commit f85781fb505e ("btrfs: switch to
iomap for direct IO") we're already passing @uptodate=false finishing
the OE.
But at that time OE with IOERR won't call mapping_set_error(), so it's
not exposed.
Later commit d61bec08b904 ("btrfs: mark ordered extent and inode with
error if we fail to finish") finally exposed the bug, but that commit
is doing a correct job, not the root cause.

Anyway the bug is very old, dating back to 5.1x days, thus only CC to
stable.

CC: stable@vger.kernel.org # 5.15+
Reviewed-by: Boris Burkov <boris@bur.io>
Signed-off-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/inode.c        |   34 ++++++++++++++++++++++++++--------
 fs/btrfs/ordered-data.c |   13 +++++++++++++
 fs/btrfs/ordered-data.h |    2 ++
 3 files changed, 41 insertions(+), 8 deletions(-)

--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -8207,12 +8207,34 @@ static int btrfs_dio_iomap_end(struct in
 	if (submitted < length) {
 		pos += submitted;
 		length -= submitted;
-		if (write)
+		if (write) {
+			struct btrfs_ordered_extent *ordered;
+
+			/*
+			 * We have a short write. Any range that was properly
+			 * submitted will be finished through the bio
+			 * completion path with an uptodate status matching
+			 * the bio status.
+			 *
+			 * The remaining range was never submitted, so mark
+			 * it as truncated and finish it without an error, so
+			 * the extent is reclaimed without inserting a file
+			 * extent item for it and without marking the mapping
+			 * as failed, which would make a later buffered write
+			 * fallback fail with a false -EIO.
+			 */
+			ordered = btrfs_lookup_ordered_extent(BTRFS_I(inode),
+							      pos);
+			ASSERT(ordered);
+			btrfs_mark_ordered_extent_truncated(ordered,
+					pos - ordered->file_offset);
+			btrfs_put_ordered_extent(ordered);
 			__endio_write_update_ordered(BTRFS_I(inode), pos,
-					length, false);
-		else
+					length, true);
+		} else {
 			unlock_extent(&BTRFS_I(inode)->io_tree, pos,
 				      pos + length - 1);
+		}
 		ret = -ENOTBLK;
 	}
 
@@ -8839,11 +8861,7 @@ static void btrfs_invalidatepage(struct
 					 EXTENT_LOCKED | EXTENT_DO_ACCOUNTING |
 					 EXTENT_DEFRAG, 1, 0, &cached_state);
 
-		spin_lock_irq(&inode->ordered_tree.lock);
-		set_bit(BTRFS_ORDERED_TRUNCATED, &ordered->flags);
-		ordered->truncated_len = min(ordered->truncated_len,
-					     cur - ordered->file_offset);
-		spin_unlock_irq(&inode->ordered_tree.lock);
+		btrfs_mark_ordered_extent_truncated(ordered, cur - ordered->file_offset);
 
 		if (btrfs_dec_test_ordered_pending(inode, &ordered,
 						   cur, range_end + 1 - cur)) {
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -298,6 +298,19 @@ void btrfs_add_ordered_sum(struct btrfs_
 	spin_unlock_irq(&tree->lock);
 }
 
+void btrfs_mark_ordered_extent_truncated(struct btrfs_ordered_extent *ordered,
+					 u64 truncate_len)
+{
+	struct btrfs_ordered_inode_tree *tree;
+
+	tree = &BTRFS_I(ordered->inode)->ordered_tree;
+	ASSERT(truncate_len <= ordered->num_bytes);
+	spin_lock_irq(&tree->lock);
+	set_bit(BTRFS_ORDERED_TRUNCATED, &ordered->flags);
+	ordered->truncated_len = min(ordered->truncated_len, truncate_len);
+	spin_unlock_irq(&tree->lock);
+}
+
 /*
  * Mark all ordered extents io inside the specified range finished.
  *
--- a/fs/btrfs/ordered-data.h
+++ b/fs/btrfs/ordered-data.h
@@ -212,6 +212,8 @@ void btrfs_lock_and_flush_ordered_range(
 					struct extent_state **cached_state);
 int btrfs_split_ordered_extent(struct btrfs_ordered_extent *ordered, u64 pre,
 			       u64 post);
+void btrfs_mark_ordered_extent_truncated(struct btrfs_ordered_extent *ordered,
+					 u64 truncate_len);
 int __init ordered_data_init(void);
 void __cold ordered_data_exit(void);
 


