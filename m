Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 226DF1A76A1;
	Tue, 30 Jul 2024 17:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360128; cv=none; b=iUzykRbaGHsPgI89rlvfOsHxpXvbEOP/RbAKi6lYPeLEm08DVtHHWPG2uwe+XZsfGKXTyq1zNRBAagu81hlScCDNpAneEagDZuzojWR/hAL+aWBs5F6WydYo3Tluad7mrqcymr4JFHBlAxjo0H4AcjO5X5WfBmVjhP8BoenzONA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360128; c=relaxed/simple;
	bh=p9GL39TNNOGFUydRIDt1Bcm9G0UPsCsfFTkGjwyHdTU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FFlbOmyjKETenyTEaWiwNwJpKFNqeby97VCWG9QtpL9yQbosrJeiLRK7wk3/edpzjzbnP+/T7vh2oSVrVbRBaPQyXDX3T+DqDV2o0mN7p8X8LdturU5NSMNgj8gzMxorhYhvgUNqiDgen8Rxnl8aQFQLAQWTHuXfTQlEgLK+JxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wFJMd3iZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wFJMd3iZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D3FCC32782;
	Tue, 30 Jul 2024 17:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360128;
	bh=p9GL39TNNOGFUydRIDt1Bcm9G0UPsCsfFTkGjwyHdTU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wFJMd3iZuzDR24XXi9rkM+AMAtTncANZoPdrEOcD0lY2Ww2FZ5eJdteL2Fz2rig0+
	 V1sDn8bVQga4EB/xfpyJJP7J6JiNqWd14PpRKQfE+5htf1cOnJqZoaBl5ZS8Wqi8ns
	 6R7qOOCa4Hvne48WE/wQO6S9DQJpz40LpE9I3fYU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Ofir Gal <ofir.gal@volumez.com>,
	Song Liu <song@kernel.org>
Subject: [PATCH 6.10 606/809] md/md-bitmap: fix writing non bitmap pages
Date: Tue, 30 Jul 2024 17:48:02 +0200
Message-ID: <20240730151748.769964597@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ofir Gal <ofir.gal@volumez.com>

commit ab99a87542f194f28e2364a42afbf9fb48b1c724 upstream.

__write_sb_page() rounds up the io size to the optimal io size if it
doesn't exceed the data offset, but it doesn't check the final size
exceeds the bitmap length.

For example:
page count      - 1
page size       - 4K
data offset     - 1M
optimal io size - 256K

The final io size would be 256K (64 pages) but md_bitmap_storage_alloc()
allocated 1 page, the IO would write 1 valid page and 63 pages that
happens to be allocated afterwards. This leaks memory to the raid device
superblock.

This issue caused a data transfer failure in nvme-tcp. The network
drivers checks the first page of an IO with sendpage_ok(), it returns
true if the page isn't a slabpage and refcount >= 1. If the page
!sendpage_ok() the network driver disables MSG_SPLICE_PAGES.

As of now the network layer assumes all the pages of the IO are
sendpage_ok() when MSG_SPLICE_PAGES is on.

The bitmap pages aren't slab pages, the first page of the IO is
sendpage_ok(), but the additional pages that happens to be allocated
after the bitmap pages might be !sendpage_ok(). That cause
skb_splice_from_iter() to stop the data transfer, in the case below it
hangs 'mdadm --create'.

The bug is reproducible, in order to reproduce we need nvme-over-tcp
controllers with optimal IO size bigger than PAGE_SIZE. Creating a raid
with bitmap over those devices reproduces the bug.

In order to simulate large optimal IO size you can use dm-stripe with a
single device.
Script to reproduce the issue on top of brd devices using dm-stripe is
attached below (will be added to blktest).

I have added some logs to test the theory:
...
md: created bitmap (1 pages) for device md127
__write_sb_page before md_super_write offset: 16, size: 262144. pfn: 0x53ee
=== __write_sb_page before md_super_write. logging pages ===
pfn: 0x53ee, slab: 0 <-- the only page that allocated for the bitmap
pfn: 0x53ef, slab: 1
pfn: 0x53f0, slab: 0
pfn: 0x53f1, slab: 0
pfn: 0x53f2, slab: 0
pfn: 0x53f3, slab: 1
...
nvme_tcp: sendpage_ok - pfn: 0x53ee, len: 262144, offset: 0
skbuff: before sendpage_ok() - pfn: 0x53ee
skbuff: before sendpage_ok() - pfn: 0x53ef
WARNING at net/core/skbuff.c:6848 skb_splice_from_iter+0x142/0x450
skbuff: !sendpage_ok - pfn: 0x53ef. is_slab: 1, page_count: 1
...

Cc: stable@vger.kernel.org
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ofir Gal <ofir.gal@volumez.com>
Signed-off-by: Song Liu <song@kernel.org>
Link: https://lore.kernel.org/r/20240607072748.3182199-1-ofir.gal@volumez.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/md-bitmap.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -227,6 +227,8 @@ static int __write_sb_page(struct md_rde
 	struct block_device *bdev;
 	struct mddev *mddev = bitmap->mddev;
 	struct bitmap_storage *store = &bitmap->storage;
+	unsigned int bitmap_limit = (bitmap->storage.file_pages - pg_index) <<
+		PAGE_SHIFT;
 	loff_t sboff, offset = mddev->bitmap_info.offset;
 	sector_t ps = pg_index * PAGE_SIZE / SECTOR_SIZE;
 	unsigned int size = PAGE_SIZE;
@@ -269,11 +271,9 @@ static int __write_sb_page(struct md_rde
 		if (size == 0)
 			/* bitmap runs in to data */
 			return -EINVAL;
-	} else {
-		/* DATA METADATA BITMAP - no problems */
 	}
 
-	md_super_write(mddev, rdev, sboff + ps, (int) size, page);
+	md_super_write(mddev, rdev, sboff + ps, (int)min(size, bitmap_limit), page);
 	return 0;
 }
 


