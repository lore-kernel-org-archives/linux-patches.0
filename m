Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96DF713C9C4;
	Wed,  5 Feb 2025 13:58:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763931; cv=none; b=X3aOsL4pD0mn/+JUowZWAtV+6GpK+rbZZ/ZrAUzazbaGeUrqbvnf3+tpJpt0vdsxs878cUs3vIHWHlIzRUFLXRRpd/Ka+7YpUupFf6olr0JcatNPN7kndrhjXD8RpKb4dId0MpWsK8j2BVuKeTPpasXuf+YnLMYqGB0bWf6wESc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763931; c=relaxed/simple;
	bh=HMPAgSr4nOFvE0/eSd4Q9RRZJvvXDJAALRKXE5z+xd0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OD0irYLE6p5PSLy05X2UOeL8hsAqVGkFQtKb4OhCBtuQF8joQZznqsG3m5paClngS8NyJjPy/PYbgWUxUBSxEggUgy1DLFeeCNvIH8MOkn4tWnXtj+UEtx6CzPPjJP7A5SvZzUyVGis36MMUqruFc3F2XPSdk3PjzC1YWQxjghs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WG2p1w3B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WG2p1w3B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 057F1C4CED1;
	Wed,  5 Feb 2025 13:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763931;
	bh=HMPAgSr4nOFvE0/eSd4Q9RRZJvvXDJAALRKXE5z+xd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WG2p1w3B5nLCjD66RHbu4SM0DhuyTcQdGIVmqW6YZNOIyOngYWSYHDLArvCx+raaI
	 TWT9U+HQp7yJepGadlvuFEhQfjvhCpGypQSOL2PXWAgdjf7xewrneoyZuafScrDUGU
	 LtBd6MoLqAmrZZt8qxVRx3z5wiSElWvnujKaQTM4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	John Garry <john.g.garry@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 031/623] block: Ensure start sector is aligned for stacking atomic writes
Date: Wed,  5 Feb 2025 14:36:13 +0100
Message-ID: <20250205134457.418306946@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Garry <john.g.garry@oracle.com>

[ Upstream commit 6564862d646e7d630929ba1ff330740bb215bdac ]

For stacking atomic writes, ensure that the start sector is aligned with
the device atomic write unit min and any boundary. Otherwise, we may
permit misaligned atomic writes.

Rework bdev_can_atomic_write() into a common helper to resuse the
alignment check. There also use atomic_write_hw_unit_min, which is more
proper (than atomic_write_unit_min).

Fixes: d7f36dc446e89 ("block: Support atomic writes limits for stacked devices")
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: John Garry <john.g.garry@oracle.com>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Link: https://lore.kernel.org/r/20250109114000.2299896-2-john.g.garry@oracle.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-settings.c   |  7 +++++--
 include/linux/blkdev.h | 21 ++++++++++++---------
 2 files changed, 17 insertions(+), 11 deletions(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index b017637d9e735..64f2e67238d77 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -608,7 +608,7 @@ static bool blk_stack_atomic_writes_head(struct queue_limits *t,
 }
 
 static void blk_stack_atomic_writes_limits(struct queue_limits *t,
-				struct queue_limits *b)
+				struct queue_limits *b, sector_t start)
 {
 	if (!(t->features & BLK_FEAT_ATOMIC_WRITES_STACKED))
 		goto unsupported;
@@ -616,6 +616,9 @@ static void blk_stack_atomic_writes_limits(struct queue_limits *t,
 	if (!b->atomic_write_unit_min)
 		goto unsupported;
 
+	if (!blk_atomic_write_start_sect_aligned(start, b))
+		goto unsupported;
+
 	/*
 	 * If atomic_write_hw_max is set, we have already stacked 1x bottom
 	 * device, so check for compliance.
@@ -798,7 +801,7 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 		t->zone_write_granularity = 0;
 		t->max_zone_append_sectors = 0;
 	}
-	blk_stack_atomic_writes_limits(t, b);
+	blk_stack_atomic_writes_limits(t, b, start);
 
 	return ret;
 }
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index e0ce4d6913cde..495813277597f 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1701,6 +1701,15 @@ struct io_comp_batch {
 	void (*complete)(struct io_comp_batch *);
 };
 
+static inline bool blk_atomic_write_start_sect_aligned(sector_t sector,
+						struct queue_limits *limits)
+{
+	unsigned int alignment = max(limits->atomic_write_hw_unit_min,
+				limits->atomic_write_hw_boundary);
+
+	return IS_ALIGNED(sector, alignment >> SECTOR_SHIFT);
+}
+
 static inline bool bdev_can_atomic_write(struct block_device *bdev)
 {
 	struct request_queue *bd_queue = bdev->bd_queue;
@@ -1709,15 +1718,9 @@ static inline bool bdev_can_atomic_write(struct block_device *bdev)
 	if (!limits->atomic_write_unit_min)
 		return false;
 
-	if (bdev_is_partition(bdev)) {
-		sector_t bd_start_sect = bdev->bd_start_sect;
-		unsigned int alignment =
-			max(limits->atomic_write_unit_min,
-			    limits->atomic_write_hw_boundary);
-
-		if (!IS_ALIGNED(bd_start_sect, alignment >> SECTOR_SHIFT))
-			return false;
-	}
+	if (bdev_is_partition(bdev))
+		return blk_atomic_write_start_sect_aligned(bdev->bd_start_sect,
+							limits);
 
 	return true;
 }
-- 
2.39.5



