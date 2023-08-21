Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0EC41171A
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 20:04:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52F70C433C8;
	Mon, 21 Aug 2023 20:04:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692648258;
	bh=5Gzojtg5ySZwBQUgnT6g8LeP2y/AbOKeehVljXp63Xw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x/fR+GuwlhpEpnriQowxQ4WEY/QBO6fwhHPXJld+MaP85Egqnds2kHSoLV866P1TL
	 2D9CS5NxQ69gpshfsl0qRbsL1OP/HcnMQSN49rakaFTDCo7zJ+tbjFAy6uEeK9UMU5
	 3pTlUke3iOs6y72dJ9m5OSVxd69IVQVkjnBBIbXE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
	Christoph Hellwig <hch@lst.de>,
	Qu Wenruo <wqu@suse.com>,
	Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>
Subject: [PATCH 6.4 111/234] btrfs: only subtract from len_to_oe_boundary when it is tracking an extent
Date: Mon, 21 Aug 2023 21:41:14 +0200
Message-ID: <20230821194133.720843861@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194128.754601642@linuxfoundation.org>
References: <20230821194128.754601642@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chris Mason <clm@fb.com>

commit 09c3717c3a60e3ef599bc17c70cd3ae2b979ad41 upstream.

bio_ctrl->len_to_oe_boundary is used to make sure we stay inside a zone
as we submit bios for writes.  Every time we add a page to the bio, we
decrement those bytes from len_to_oe_boundary, and then we submit the
bio if we happen to hit zero.

Most of the time, len_to_oe_boundary gets set to U32_MAX.
submit_extent_page() adds pages into our bio, and the size of the bio
ends up limited by:

- Are we contiguous on disk?
- Does bio_add_page() allow us to stuff more in?
- is len_to_oe_boundary > 0?

The len_to_oe_boundary math starts with U32_MAX, which isn't page or
sector aligned, and subtracts from it until it hits zero.  In the
non-zoned case, the last IO we submit before we hit zero is going to be
unaligned, triggering BUGs.

This is hard to trigger because bio_add_page() isn't going to make a bio
of U32_MAX size unless you give it a perfect set of pages and fully
contiguous extents on disk.  We can hit it pretty reliably while making
large swapfiles during provisioning because the machine is freshly
booted, mostly idle, and the disk is freshly formatted.  It's also
possible to trigger with reads when read_ahead_kb is set to 4GB.

The code has been clean up and shifted around a few times, but this flaw
has been lurking since the counter was added.  I think the commit
24e6c8082208 ("btrfs: simplify main loop in submit_extent_page") ended
up exposing the bug.

The fix used here is to skip doing math on len_to_oe_boundary unless
we've changed it from the default U32_MAX value.  bio_add_page() is the
real limit we want, and there's no reason to do extra math when block
layer is doing it for us.

Sample reproducer, note you'll need to change the path to the bdi and
device:

  SUBVOL=/btrfs/swapvol
  SWAPFILE=$SUBVOL/swapfile
  SZMB=8192

  mkfs.btrfs -f /dev/vdb
  mount /dev/vdb /btrfs

  btrfs subvol create $SUBVOL
  chattr +C $SUBVOL
  dd if=/dev/zero of=$SWAPFILE bs=1M count=$SZMB
  sync

  echo 4 > /proc/sys/vm/drop_caches

  echo 4194304 > /sys/class/bdi/btrfs-2/read_ahead_kb

  while true; do
	  echo 1 > /proc/sys/vm/drop_caches
	  echo 1 > /proc/sys/vm/drop_caches
	  dd of=/dev/zero if=$SWAPFILE bs=4096M count=2 iflag=fullblock
  done

Fixes: 24e6c8082208 ("btrfs: simplify main loop in submit_extent_page")
CC: stable@vger.kernel.org # 6.4+
Reviewed-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Qu Wenruo <wqu@suse.com>
Signed-off-by: Chris Mason <clm@fb.com>
Signed-off-by: David Sterba <dsterba@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/btrfs/extent_io.c |   25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -962,7 +962,30 @@ static void submit_extent_page(struct bt
 		size -= len;
 		pg_offset += len;
 		disk_bytenr += len;
-		bio_ctrl->len_to_oe_boundary -= len;
+
+		/*
+		 * len_to_oe_boundary defaults to U32_MAX, which isn't page or
+		 * sector aligned.  alloc_new_bio() then sets it to the end of
+		 * our ordered extent for writes into zoned devices.
+		 *
+		 * When len_to_oe_boundary is tracking an ordered extent, we
+		 * trust the ordered extent code to align things properly, and
+		 * the check above to cap our write to the ordered extent
+		 * boundary is correct.
+		 *
+		 * When len_to_oe_boundary is U32_MAX, the cap above would
+		 * result in a 4095 byte IO for the last page right before
+		 * we hit the bio limit of UINT_MAX.  bio_add_page() has all
+		 * the checks required to make sure we don't overflow the bio,
+		 * and we should just ignore len_to_oe_boundary completely
+		 * unless we're using it to track an ordered extent.
+		 *
+		 * It's pretty hard to make a bio sized U32_MAX, but it can
+		 * happen when the page cache is able to feed us contiguous
+		 * pages for large extents.
+		 */
+		if (bio_ctrl->len_to_oe_boundary != U32_MAX)
+			bio_ctrl->len_to_oe_boundary -= len;
 
 		/* Ordered extent boundary: move on to a new bio. */
 		if (bio_ctrl->len_to_oe_boundary == 0)


