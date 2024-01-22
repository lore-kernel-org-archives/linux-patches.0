Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85CAD5024E;
	Tue, 23 Jan 2024 01:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974726; cv=none; b=ugqIDjRLe1nu3Bmy+Q9AxuCDElAEjHxbkqKUnclx73kOeqPRHGaQttJio8HJLbqgsiTvHvt76Gv6J+tp7/4hbxiOs7P3efwYX7Iur+CXzxS4SaD39JRq/Y4lk7p8PM8fk536ErU5/JT4ZKE1ozobDBW+OqhoEt0y/K8+gO51MJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974726; c=relaxed/simple;
	bh=S7NhL1RbTUpYrzgrp1nn1K22fgPA2Qt+QqYM3sjnxho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nvIf4Go65xt5bqohKpKoDNOdLysb7jks/VOWGbcNxRn7k8P7FATndaE3zvdAFlembvIyxe2IfvYvrvvaiw85WmGRTyMaXN+7zJoShbpvYnKn7GnJruJdQx3ysroI2mt1AzBhe0E1sI+ZsDrr0W4D/mOEunDRzYD5HBQjaBz2LbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CRBRPglb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CRBRPglb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C167C433F1;
	Tue, 23 Jan 2024 01:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974726;
	bh=S7NhL1RbTUpYrzgrp1nn1K22fgPA2Qt+QqYM3sjnxho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CRBRPglbfbJP5IHmR5TRrJHhTdJyUJ5bfg8JyCq5DIqBJ37jcG4TwV/1WruwK3tGM
	 BMCkrdzM0d6iHx0ylyUvTd720Sb5yRwEM+AuSSGxCyJfX47n4bg1M7o0ANadwLaCp0
	 qPIuhjP8pBVmIa/EPX9f0UjHIX+YOJhNiInVj1No=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Min Li <min15.li@samsung.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.15 269/374] block: add check that partition length needs to be aligned with block size
Date: Mon, 22 Jan 2024 15:58:45 -0800
Message-ID: <20240122235754.133023117@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


