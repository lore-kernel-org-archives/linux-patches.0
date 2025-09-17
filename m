Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85FBF332A23;
	Wed, 17 Sep 2025 12:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113792; cv=none; b=p2tQBIwV5u91zz/6vpP0WfNw66HgQ9zu3psZOlTGNw0ItVmnt6LRm59bXgWgL3MhU8CHDdpmCdJrGZzZy638f7jVpD8/T8yUS1cIXBDvxwAckBhtVRXdRQtCnNGvUjKQQMMe5URqHKkMon8PvrIJcgLED8iSICFn2GBqIioAo/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113792; c=relaxed/simple;
	bh=MyiEQtosVi5n/BhC/XWg+5PFdjG9x5BJ4jghO3RIfv4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gYThpR4bVNqApz7KC19q6tZ4vRqDK510jsZlk4CCe+URHYlBEKmcer7Qf41oTpX50VISIRKvjF54PhzVmwjfCenaUXQxwQH2d4ZGr7M+DSiiBoY2a1Es6SRDphew6lz8xXGH7fL47iSDNLAsMc9QNUSoWAPiW6nfQKK0MWblWIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BjFtE+nd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BjFtE+nd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07363C4CEF0;
	Wed, 17 Sep 2025 12:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113792;
	bh=MyiEQtosVi5n/BhC/XWg+5PFdjG9x5BJ4jghO3RIfv4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BjFtE+ndlaPSnUa/SOxYmfSHns1ZK+vpe+Bl7anQZvESQL5D4E7kjVKL3Xp8sY1Za
	 uqmnC58jwxKM5DSgV3B02AwKsQuJo4QdP5nbyKw6k/MMhWC1xI218R47mSeFAQ3zKQ
	 ryhYmFXUPIJM7YArM5DXHGe2hYOd8YSK+cgI9XZ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dimitrios Apostolou <jimis@gmx.net>,
	Filipe Manana <fdmanana@suse.com>,
	Boris Burkov <boris@bur.io>,
	David Sterba <dsterba@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 053/101] btrfs: use readahead_expand() on compressed extents
Date: Wed, 17 Sep 2025 14:34:36 +0200
Message-ID: <20250917123338.123759079@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123336.863698492@linuxfoundation.org>
References: <20250917123336.863698492@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Boris Burkov <boris@bur.io>

[ Upstream commit 9e9ff875e4174be939371667d2cc81244e31232f ]

We recently received a report of poor performance doing sequential
buffered reads of a file with compressed extents. With bs=128k, a naive
sequential dd ran as fast on a compressed file as on an uncompressed
(1.2GB/s on my reproducing system) while with bs<32k, this performance
tanked down to ~300MB/s.

i.e., slow:

  dd if=some-compressed-file of=/dev/null bs=4k count=X

vs fast:

  dd if=some-compressed-file of=/dev/null bs=128k count=Y

The cause of this slowness is overhead to do with looking up extent_maps
to enable readahead pre-caching on compressed extents
(add_ra_bio_pages()), as well as some overhead in the generic VFS
readahead code we hit more in the slow case. Notably, the main
difference between the two read sizes is that in the large sized request
case, we call btrfs_readahead() relatively rarely while in the smaller
request we call it for every compressed extent. So the fast case stays
in the btrfs readahead loop:

    while ((folio = readahead_folio(rac)) != NULL)
	    btrfs_do_readpage(folio, &em_cached, &bio_ctrl, &prev_em_start);

where the slower one breaks out of that loop every time. This results in
calling add_ra_bio_pages a lot, doing lots of extent_map lookups,
extent_map locking, etc.

This happens because although add_ra_bio_pages() does add the
appropriate un-compressed file pages to the cache, it does not
communicate back to the ractl in any way. To solve this, we should be
using readahead_expand() to signal to readahead to expand the readahead
window.

This change passes the readahead_control into the btrfs_bio_ctrl and in
the case of compressed reads sets the expansion to the size of the
extent_map we already looked up anyway. It skips the subpage case as
that one already doesn't do add_ra_bio_pages().

With this change, whether we use bs=4k or bs=128k, btrfs expands the
readahead window up to the largest compressed extent we have seen so far
(in the trivial example: 128k) and the call stacks of the two modes look
identical. Notably, we barely call add_ra_bio_pages at all. And the
performance becomes identical as well. So this change certainly "fixes"
this performance problem.

Of course, it does seem to beg a few questions:

1. Will this waste too much page cache with a too large ra window?
2. Will this somehow cause bugs prevented by the more thoughtful
   checking in add_ra_bio_pages?
3. Should we delete add_ra_bio_pages?

My stabs at some answers:

1. Hard to say. See attempts at generic performance testing below. Is
   there a "readahead_shrink" we should be using? Should we expand more
   slowly, by half the remaining em size each time?
2. I don't think so. Since the new behavior is indistinguishable from
   reading the file with a larger read size passed in, I don't see why
   one would be safe but not the other.
3. Probably! I tested that and it was fine in fstests, and it seems like
   the pages would get re-used just as well in the readahead case.
   However, it is possible some reads that use page cache but not
   btrfs_readahead() could suffer. I will investigate this further as a
   follow up.

I tested the performance implications of this change in 3 ways (using
compress-force=zstd:3 for compression):

Directly test the affected workload of small sequential reads on a
compressed file (improved from ~250MB/s to ~1.2GB/s)

==========for-next==========
  dd /mnt/lol/non-cmpr 4k
  1048576+0 records in
  1048576+0 records out
  4294967296 bytes (4.3 GB, 4.0 GiB) copied, 6.02983 s, 712 MB/s
  dd /mnt/lol/non-cmpr 128k
  32768+0 records in
  32768+0 records out
  4294967296 bytes (4.3 GB, 4.0 GiB) copied, 5.92403 s, 725 MB/s
  dd /mnt/lol/cmpr 4k
  1048576+0 records in
  1048576+0 records out
  4294967296 bytes (4.3 GB, 4.0 GiB) copied, 17.8832 s, 240 MB/s
  dd /mnt/lol/cmpr 128k
  32768+0 records in
  32768+0 records out
  4294967296 bytes (4.3 GB, 4.0 GiB) copied, 3.71001 s, 1.2 GB/s

==========ra-expand==========
  dd /mnt/lol/non-cmpr 4k
  1048576+0 records in
  1048576+0 records out
  4294967296 bytes (4.3 GB, 4.0 GiB) copied, 6.09001 s, 705 MB/s
  dd /mnt/lol/non-cmpr 128k
  32768+0 records in
  32768+0 records out
  4294967296 bytes (4.3 GB, 4.0 GiB) copied, 6.07664 s, 707 MB/s
  dd /mnt/lol/cmpr 4k
  1048576+0 records in
  1048576+0 records out
  4294967296 bytes (4.3 GB, 4.0 GiB) copied, 3.79531 s, 1.1 GB/s
  dd /mnt/lol/cmpr 128k
  32768+0 records in
  32768+0 records out
  4294967296 bytes (4.3 GB, 4.0 GiB) copied, 3.69533 s, 1.2 GB/s

Built the linux kernel from clean (no change)

Ran fsperf. Mostly neutral results with some improvements and
regressions here and there.

Reported-by: Dimitrios Apostolou <jimis@gmx.net>
Link: https://lore.kernel.org/linux-btrfs/34601559-6c16-6ccc-1793-20a97ca0dbba@gmx.net/
Reviewed-by: Filipe Manana <fdmanana@suse.com>
Signed-off-by: Boris Burkov <boris@bur.io>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/extent_io.c |   34 +++++++++++++++++++++++++++++++++-
 1 file changed, 33 insertions(+), 1 deletion(-)

--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -103,6 +103,7 @@ struct btrfs_bio_ctrl {
 	blk_opf_t opf;
 	btrfs_bio_end_io_t end_io_func;
 	struct writeback_control *wbc;
+	struct readahead_control *ractl;
 };
 
 static void submit_one_bio(struct btrfs_bio_ctrl *bio_ctrl)
@@ -952,6 +953,23 @@ __get_extent_map(struct inode *inode, st
 	}
 	return em;
 }
+
+static void btrfs_readahead_expand(struct readahead_control *ractl,
+				   const struct extent_map *em)
+{
+	const u64 ra_pos = readahead_pos(ractl);
+	const u64 ra_end = ra_pos + readahead_length(ractl);
+	const u64 em_end = em->start + em->ram_bytes;
+
+	/* No expansion for holes and inline extents. */
+	if (em->block_start > EXTENT_MAP_LAST_BYTE)
+		return;
+
+	ASSERT(em_end >= ra_pos);
+	if (em_end > ra_end)
+		readahead_expand(ractl, ra_pos, em_end - ra_pos);
+}
+
 /*
  * basic readpage implementation.  Locked extent state structs are inserted
  * into the tree that are removed when the IO is done (by the end_io
@@ -1023,6 +1041,17 @@ static int btrfs_do_readpage(struct page
 
 		iosize = min(extent_map_end(em) - cur, end - cur + 1);
 		iosize = ALIGN(iosize, blocksize);
+
+		/*
+		 * Only expand readahead for extents which are already creating
+		 * the pages anyway in add_ra_bio_pages, which is compressed
+		 * extents in the non subpage case.
+		 */
+		if (bio_ctrl->ractl &&
+		    !btrfs_is_subpage(fs_info, page) &&
+		    compress_type != BTRFS_COMPRESS_NONE)
+			btrfs_readahead_expand(bio_ctrl->ractl, em);
+
 		if (compress_type != BTRFS_COMPRESS_NONE)
 			disk_bytenr = em->block_start;
 		else
@@ -2224,7 +2253,10 @@ int extent_writepages(struct address_spa
 
 void extent_readahead(struct readahead_control *rac)
 {
-	struct btrfs_bio_ctrl bio_ctrl = { .opf = REQ_OP_READ | REQ_RAHEAD };
+	struct btrfs_bio_ctrl bio_ctrl = {
+		.opf = REQ_OP_READ | REQ_RAHEAD,
+		.ractl = rac
+	};
 	struct page *pagepool[16];
 	struct extent_map *em_cached = NULL;
 	u64 prev_em_start = (u64)-1;


