Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE83F7318E;
	Tue, 23 Jan 2024 02:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975445; cv=none; b=YnZ50QRfNySXR57JgSfuYzQBVLJnPp9RHQIoc010BnfpFwWS0AJHIinM+gGln9GS3YT8yQJl8uBvJstx4eAoaJpJ5u1NJOMiZ+XRfJOJTwUUEUJ6Hh/qQ04Z/L+Xa9n9V8o+OrQLAG2IXv2XKfOTSacWTOtLr2YndSUSB3eN5z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975445; c=relaxed/simple;
	bh=ekwQia3Vdpl/cm+X9No2gy7kguelVI6nyYfWDZd4VOc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RnA+hHRhbilPLGcudX52YmnG+B5zsDvVmL+MR/U5E5g08jD+tr4Ckh9lZwP+GZgmc14jsgmHzvUkM364N8B6IqwRUGcNLXoR3m5/Hzq/QKn6GVnxrqq38kuOK+GZMMs+BZxd5VAZxZPqVDKU4kZEWtYxWCwGMj+5PxXoFF/gn18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L+CA/Yaf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L+CA/Yaf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4983C43399;
	Tue, 23 Jan 2024 02:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975444;
	bh=ekwQia3Vdpl/cm+X9No2gy7kguelVI6nyYfWDZd4VOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L+CA/YafVAFc5/gRICEQ/kBLNkUkXDTwjx2c5HD7bfGaqFL0Pl/FaukoOmjWgNUJC
	 5NcDavOs4vbQOYU1nBZEQOwbyLG6wNyolDbFalM9UAf81uTanmJ/ffLvLRN4sz705Z
	 yybX98Rq4g3egb4O3RjV5ylRzgGhAceR4BBrimR8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Min Li <min15.li@samsung.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 401/583] block: add check that partition length needs to be aligned with block size
Date: Mon, 22 Jan 2024 15:57:32 -0800
Message-ID: <20240122235824.257771643@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Min Li <min15.li@samsung.com>

commit 6f64f866aa1ae6975c95d805ed51d7e9433a0016 upstream.

Before calling add partition or resize partition, there is no check
on whether the length is aligned with the logical block size.
If the logical block size of the disk is larger than 512 bytes,
then the partition size maybe not the multiple of the logical block size,
and when the last sector is read, bio_truncate() will adjust the bio size,
resulting in an IO error if the size of the read command is smaller than
the logical block size.If integrity data is supported, this will also
result in a null pointer dereference when calling bio_integrity_free.

Cc:  <stable@vger.kernel.org>
Signed-off-by: Min Li <min15.li@samsung.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://lore.kernel.org/r/20230629142517.121241-1-min15.li@samsung.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/ioctl.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -18,7 +18,7 @@ static int blkpg_do_ioctl(struct block_d
 {
 	struct gendisk *disk = bdev->bd_disk;
 	struct blkpg_partition p;
-	long long start, length;
+	sector_t start, length;
 
 	if (disk->flags & GENHD_FL_NO_PART)
 		return -EINVAL;
@@ -35,14 +35,17 @@ static int blkpg_do_ioctl(struct block_d
 	if (op == BLKPG_DEL_PARTITION)
 		return bdev_del_partition(disk, p.pno);
 
+	if (p.start < 0 || p.length <= 0 || p.start + p.length < 0)
+		return -EINVAL;
+	/* Check that the partition is aligned to the block size */
+	if (!IS_ALIGNED(p.start | p.length, bdev_logical_block_size(bdev)))
+		return -EINVAL;
+
 	start = p.start >> SECTOR_SHIFT;
 	length = p.length >> SECTOR_SHIFT;
 
 	switch (op) {
 	case BLKPG_ADD_PARTITION:
-		/* check if partition is aligned to blocksize */
-		if (p.start & (bdev_logical_block_size(bdev) - 1))
-			return -EINVAL;
 		return bdev_add_partition(disk, p.pno, start, length);
 	case BLKPG_RESIZE_PARTITION:
 		return bdev_resize_partition(disk, p.pno, start, length);


