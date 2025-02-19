Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E7651CAA6F;
	Wed, 19 Feb 2025 08:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739955434; cv=none; b=o3d27SBmYCNdTKMctQB0QIY2dllF8uj32wtrMpVTcEjw/hmOSS/pgyg/9tJ8NvLvjW/V25c4QOqY19e6W6dsfYhb8cbIHDiGNYVqVztfbyCfqBpXp6XDQ8Xq7ZIMAdBxLGxHzOOgBzsIVbmfZ2io0GohT+paLSSiffKz2DKyCuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739955434; c=relaxed/simple;
	bh=HRhK2GqputYkiF3V7qAXDaXLYp0mIo/GhdXG/WM0/cw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V3C9JwzaQWTQhMb/FuFcv98E52HBaZ9RfQLUBp/I9apT8v6rIrSDU7S+rFWIN9L9I9q1bujWeWdqyaQgrLEGW/ge5mHdBTqbVEs0hR7gNU7p+p+fFRVYqlb/8RELEUcJ2kUE5ZTAuD8iGXDS0lsYgQP9AXvGC6PKcchkRzCd7VA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z8l5Zl3m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z8l5Zl3m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B36C2C4CEE6;
	Wed, 19 Feb 2025 08:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739955434;
	bh=HRhK2GqputYkiF3V7qAXDaXLYp0mIo/GhdXG/WM0/cw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z8l5Zl3mzA6Ws5Neco0PaACMy0dse1SkYB/pbJpSBh3ntaSO09xJ9GLoBauaZepmJ
	 B6zwYtTqr7slr0E062V3wmrcDTGIJenTGjB0lJJXDs/igtcO3YwJVEsDf8ftTWC/u0
	 mdyyz/YvuqT+qSpj/pPFhRpISkEPI8z4QMqOUHEA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qu Wenruo <wqu@suse.com>,
	Filipe Manana <fdmanana@suse.com>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 203/230] btrfs: fix stale page cache after race between readahead and direct IO write
Date: Wed, 19 Feb 2025 09:28:40 +0100
Message-ID: <20250219082609.637306319@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
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

From: Filipe Manana <fdmanana@suse.com>

[ Upstream commit acc18e1c1d8c0d59d793cf87790ccfcafb1bf5f0 ]

After commit ac325fc2aad5 ("btrfs: do not hold the extent lock for entire
read") we can now trigger a race between a task doing a direct IO write
and readahead. When this race is triggered it results in tasks getting
stale data when they attempt do a buffered read (including the task that
did the direct IO write).

This race can be sporadically triggered with test case generic/418, failing
like this:

   $ ./check generic/418
   FSTYP         -- btrfs
   PLATFORM      -- Linux/x86_64 debian0 6.13.0-rc7-btrfs-next-185+ #17 SMP PREEMPT_DYNAMIC Mon Feb  3 12:28:46 WET 2025
   MKFS_OPTIONS  -- /dev/sdc
   MOUNT_OPTIONS -- /dev/sdc /home/fdmanana/btrfs-tests/scratch_1

   generic/418 14s ... - output mismatch (see /home/fdmanana/git/hub/xfstests/results//generic/418.out.bad)
#      --- tests/generic/418.out	2020-06-10 19:29:03.850519863 +0100
#      +++ /home/fdmanana/git/hub/xfstests/results//generic/418.out.bad	2025-02-03 15:42:36.974609476 +0000
       @@ -1,2 +1,5 @@
        QA output created by 418
       +cmpbuf: offset 0: Expected: 0x1, got 0x0
       +[6:0] FAIL - comparison failed, offset 24576
       +diotest -wp -b 4096 -n 8 -i 4 failed at loop 3
        Silence is golden
       ...
       (Run 'diff -u /home/fdmanana/git/hub/xfstests/tests/generic/418.out /home/fdmanana/git/hub/xfstests/results//generic/418.out.bad'  to see the entire diff)
   Ran: generic/418
   Failures: generic/418
   Failed 1 of 1 tests

The race happens like this:

1) A file has a prealloc extent for the range [16K, 28K);

2) Task A starts a direct IO write against file range [24K, 28K).
   At the start of the direct IO write it invalidates the page cache at
   __iomap_dio_rw() with kiocb_invalidate_pages() for the 4K page at file
   offset 24K;

3) Task A enters btrfs_dio_iomap_begin() and locks the extent range
   [24K, 28K);

4) Task B starts a readahead for file range [16K, 28K), entering
   btrfs_readahead().

   First it attempts to read the page at offset 16K by entering
   btrfs_do_readpage(), where it calls get_extent_map(), locks the range
   [16K, 20K) and gets the extent map for the range [16K, 28K), caching
   it into the 'em_cached' variable declared in the local stack of
   btrfs_readahead(), and then unlocks the range [16K, 20K).

   Since the extent map has the prealloc flag, at btrfs_do_readpage() we
   zero out the page's content and don't submit any bio to read the page
   from the extent.

   Then it attempts to read the page at offset 20K entering
   btrfs_do_readpage() where we reuse the previously cached extent map
   (decided by get_extent_map()) since it spans the page's range and
   it's still in the inode's extent map tree.

   Just like for the previous page, we zero out the page's content since
   the extent map has the prealloc flag set.

   Then it attempts to read the page at offset 24K entering
   btrfs_do_readpage() where we reuse the previously cached extent map
   (decided by get_extent_map()) since it spans the page's range and
   it's still in the inode's extent map tree.

   Just like for the previous pages, we zero out the page's content since
   the extent map has the prealloc flag set. Note that we didn't lock the
   extent range [24K, 28K), so we didn't synchronize with the ongoing
   direct IO write being performed by task A;

5) Task A enters btrfs_create_dio_extent() and creates an ordered extent
   for the range [24K, 28K), with the flags BTRFS_ORDERED_DIRECT and
   BTRFS_ORDERED_PREALLOC set;

6) Task A unlocks the range [24K, 28K) at btrfs_dio_iomap_begin();

7) The ordered extent enters btrfs_finish_one_ordered() and locks the
   range [24K, 28K);

8) Task A enters fs/iomap/direct-io.c:iomap_dio_complete() and it tries
   to invalidate the page at offset 24K by calling
   kiocb_invalidate_post_direct_write(), resulting in a call chain that
   ends up at btrfs_release_folio().

   The btrfs_release_folio() call ends up returning false because the range
   for the page at file offset 24K is currently locked by the task doing
   the ordered extent completion in the previous step (7), so we have:

   btrfs_release_folio() ->
      __btrfs_release_folio() ->
         try_release_extent_mapping() ->
	     try_release_extent_state()

   This last function checking that the range is locked and returning false
   and propagating it up to btrfs_release_folio().

   So this results in a failure to invalidate the page and
   kiocb_invalidate_post_direct_write() triggers this message logged in
   dmesg:

     Page cache invalidation failure on direct I/O.  Possible data corruption due to collision with buffered I/O!

   After this we leave the page cache with stale data for the file range
   [24K, 28K), filled with zeroes instead of the data written by direct IO
   write (all bytes with a 0x01 value), so any task attempting to read with
   buffered IO, including the task that did the direct IO write, will get
   all bytes in the range with a 0x00 value instead of the written data.

Fix this by locking the range, with btrfs_lock_and_flush_ordered_range(),
at the two callers of btrfs_do_readpage() instead of doing it at
get_extent_map(), just like we did before commit ac325fc2aad5 ("btrfs: do
not hold the extent lock for entire read"), and unlocking the range after
all the calls to btrfs_do_readpage(). This way we never reuse a cached
extent map without flushing any pending ordered extents from a concurrent
direct IO write.

Fixes: ac325fc2aad5 ("btrfs: do not hold the extent lock for entire read")
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/extent_io.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index e6e6c4dc53c48..fe08c983d5bb4 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -906,7 +906,6 @@ static struct extent_map *get_extent_map(struct btrfs_inode *inode,
 					 u64 len, struct extent_map **em_cached)
 {
 	struct extent_map *em;
-	struct extent_state *cached_state = NULL;
 
 	ASSERT(em_cached);
 
@@ -922,14 +921,12 @@ static struct extent_map *get_extent_map(struct btrfs_inode *inode,
 		*em_cached = NULL;
 	}
 
-	btrfs_lock_and_flush_ordered_range(inode, start, start + len - 1, &cached_state);
 	em = btrfs_get_extent(inode, folio, start, len);
 	if (!IS_ERR(em)) {
 		BUG_ON(*em_cached);
 		refcount_inc(&em->refs);
 		*em_cached = em;
 	}
-	unlock_extent(&inode->io_tree, start, start + len - 1, &cached_state);
 
 	return em;
 }
@@ -1086,11 +1083,18 @@ static int btrfs_do_readpage(struct folio *folio, struct extent_map **em_cached,
 
 int btrfs_read_folio(struct file *file, struct folio *folio)
 {
+	struct btrfs_inode *inode = folio_to_inode(folio);
+	const u64 start = folio_pos(folio);
+	const u64 end = start + folio_size(folio) - 1;
+	struct extent_state *cached_state = NULL;
 	struct btrfs_bio_ctrl bio_ctrl = { .opf = REQ_OP_READ };
 	struct extent_map *em_cached = NULL;
 	int ret;
 
+	btrfs_lock_and_flush_ordered_range(inode, start, end, &cached_state);
 	ret = btrfs_do_readpage(folio, &em_cached, &bio_ctrl, NULL);
+	unlock_extent(&inode->io_tree, start, end, &cached_state);
+
 	free_extent_map(em_cached);
 
 	/*
@@ -2267,12 +2271,20 @@ void btrfs_readahead(struct readahead_control *rac)
 {
 	struct btrfs_bio_ctrl bio_ctrl = { .opf = REQ_OP_READ | REQ_RAHEAD };
 	struct folio *folio;
+	struct btrfs_inode *inode = BTRFS_I(rac->mapping->host);
+	const u64 start = readahead_pos(rac);
+	const u64 end = start + readahead_length(rac) - 1;
+	struct extent_state *cached_state = NULL;
 	struct extent_map *em_cached = NULL;
 	u64 prev_em_start = (u64)-1;
 
+	btrfs_lock_and_flush_ordered_range(inode, start, end, &cached_state);
+
 	while ((folio = readahead_folio(rac)) != NULL)
 		btrfs_do_readpage(folio, &em_cached, &bio_ctrl, &prev_em_start);
 
+	unlock_extent(&inode->io_tree, start, end, &cached_state);
+
 	if (em_cached)
 		free_extent_map(em_cached);
 	submit_one_bio(&bio_ctrl);
-- 
2.39.5



