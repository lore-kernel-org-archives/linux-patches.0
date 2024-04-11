Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3579379FD;
	Thu, 11 Apr 2024 10:40:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832023; cv=none; b=VNrwNZAxT2I3v9N5GiDPcX0RS0mWjJzsgT66j/YWi/yJMz2EnnXhsllR1RvkcbPzFlvml9N2qA9Z+CqVl9eWMA907zG7ML6qdyhcndH6m5TEFSUMJqYxpamIdOFTD0Q9+Fg4UOormxTUTlmfyml/wqnln3yCL4t69yYjLBdFZcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832023; c=relaxed/simple;
	bh=eQadKMUqpSpV9e0rKjTk0PFvdkPFBeng1k+sP5kPPKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DQX6CT+8+Dx6afE7RS1NKX84MXlyozmKfzfMlVp9VRoFDh8VOM0kmLNzLHrM4RZUtbf3H9jX4AD16kiy0yEIsTJCT/v64XF0jPzOLVROuzTzAljWFFwUFvHbGi6KBs2VPQJG2Gf7XNhlESNh38o9A1ODEmrAvd2EMJPdEYvcEaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1JyUYBml; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1JyUYBml"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEAB4C433F1;
	Thu, 11 Apr 2024 10:40:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832023;
	bh=eQadKMUqpSpV9e0rKjTk0PFvdkPFBeng1k+sP5kPPKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1JyUYBml5jtFVOoMtF+Ic5NUs/C7iNpQ33hF0GeymAOQdl+QAq5u02/pGMrYo5k8Q
	 PXpbo5ViRiDNywqsi47rtB/6Bgwk+CXB7y1AfNLBSUutKm/8dCHsxoab2kXMOkOcG9
	 gTmJNUYtTGv9kX91AKzirjpIoMD365EY7tRiOxxk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Min Li <min15.li@samsung.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Ashwin Dayanand Kamat <ashwin.kamat@broadcom.com>
Subject: [PATCH 5.10 205/294] block: add check that partition length needs to be aligned with block size
Date: Thu, 11 Apr 2024 11:56:08 +0200
Message-ID: <20240411095441.773298614@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ashwin Dayanand Kamat <ashwin.kamat@broadcom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/ioctl.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -17,7 +17,7 @@ static int blkpg_do_ioctl(struct block_d
 			  struct blkpg_partition __user *upart, int op)
 {
 	struct blkpg_partition p;
-	long long start, length;
+	sector_t start, length;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
@@ -32,6 +32,12 @@ static int blkpg_do_ioctl(struct block_d
 	if (op == BLKPG_DEL_PARTITION)
 		return bdev_del_partition(bdev, p.pno);
 
+	if (p.start < 0 || p.length <= 0 || p.start + p.length < 0)
+		return -EINVAL;
+	/* Check that the partition is aligned to the block size */
+	if (!IS_ALIGNED(p.start | p.length, bdev_logical_block_size(bdev)))
+		return -EINVAL;
+
 	start = p.start >> SECTOR_SHIFT;
 	length = p.length >> SECTOR_SHIFT;
 
@@ -46,9 +52,6 @@ static int blkpg_do_ioctl(struct block_d
 
 	switch (op) {
 	case BLKPG_ADD_PARTITION:
-		/* check if partition is aligned to blocksize */
-		if (p.start & (bdev_logical_block_size(bdev) - 1))
-			return -EINVAL;
 		return bdev_add_partition(bdev, p.pno, start, length);
 	case BLKPG_RESIZE_PARTITION:
 		return bdev_resize_partition(bdev, p.pno, start, length);


