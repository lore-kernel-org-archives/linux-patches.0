Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 254A3334C3E;
	Mon, 29 Dec 2025 16:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767026039; cv=none; b=ah1XwA7WRRWrpnzuernE03779ZnciNVM6bPU/BLcLVzDzOeXbZLlvdEaTB4BFRHKnJt4F0SlOjFroxxLEFJQFhkLNVcsusPUqrVbg4Gk1wPVMPGLafWuVBTCSyfKai1KuuRnkq0tHkqedbXoluKCn9twPQAnN+wrpwmepjKpEqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767026039; c=relaxed/simple;
	bh=+gumCn7GxjiS7wEeXFIMMNoHpIviFeAv4eo+LN0hbFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iWXu+3vnMS+219GSQ+uDIRABsqshIe9uyZXo5fMINSrKEbIX4DvhYR8TSwiqmaXhCvanC3SK1QtNFAha4IBYdGNBlEFth/MvaEbRxNz33nnQ/6WPXKKYPSADv0nYSYX6FJX9QOPToDGe0CvFvgqIAB6Q53TQlLgpIxtJmh5As0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lcBIPgPA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lcBIPgPA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57D08C4CEF7;
	Mon, 29 Dec 2025 16:33:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767026038;
	bh=+gumCn7GxjiS7wEeXFIMMNoHpIviFeAv4eo+LN0hbFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lcBIPgPAIBC1Rlktz/Uf7Hx7iqCzYs3bigBtP1A6pAu9bNl8Msjz2uLCEpYJbpA9R
	 RNthOzyBjDyHltuMpdNB5GuqPbAXS+2c/ihf/khY8WWxgbjKq1yRuGt1dyc2iN66t6
	 AnARcgmg10YGVyrd91CHbavKMizmHJQT2+vrWtEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Hannes Reinecke <hare@suse.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.18 426/430] block: freeze queue when updating zone resources
Date: Mon, 29 Dec 2025 17:13:48 +0100
Message-ID: <20251229160739.990424982@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damien Le Moal <dlemoal@kernel.org>

commit bba4322e3f303b2d656e748be758320b567f046f upstream.

Modify disk_update_zone_resources() to freeze the device queue before
updating the number of zones, zone capacity and other zone related
resources. The locking order resulting from the call to
queue_limits_commit_update_frozen() is preserved, that is, the queue
limits lock is first taken by calling queue_limits_start_update() before
freezing the queue, and the queue is unfrozen after executing
queue_limits_commit_update(), which replaces the call to
queue_limits_commit_update_frozen().

This change ensures that there are no in-flights I/Os when the zone
resources are updated due to a zone revalidation. In case of error when
the limits are applied, directly call disk_free_zone_resources() from
disk_update_zone_resources() while the disk queue is still frozen to
avoid needing to freeze & unfreeze the queue again in
blk_revalidate_disk_zones(), thus simplifying that function code a
little.

Fixes: 0b83c86b444a ("block: Prevent potential deadlock in blk_revalidate_disk_zones()")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-zoned.c |   42 ++++++++++++++++++++++++------------------
 1 file changed, 24 insertions(+), 18 deletions(-)

--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -1516,8 +1516,13 @@ static int disk_update_zone_resources(st
 {
 	struct request_queue *q = disk->queue;
 	unsigned int nr_seq_zones, nr_conv_zones;
-	unsigned int pool_size;
+	unsigned int pool_size, memflags;
 	struct queue_limits lim;
+	int ret = 0;
+
+	lim = queue_limits_start_update(q);
+
+	memflags = blk_mq_freeze_queue(q);
 
 	disk->nr_zones = args->nr_zones;
 	disk->zone_capacity = args->zone_capacity;
@@ -1527,11 +1532,10 @@ static int disk_update_zone_resources(st
 	if (nr_conv_zones >= disk->nr_zones) {
 		pr_warn("%s: Invalid number of conventional zones %u / %u\n",
 			disk->disk_name, nr_conv_zones, disk->nr_zones);
-		return -ENODEV;
+		ret = -ENODEV;
+		goto unfreeze;
 	}
 
-	lim = queue_limits_start_update(q);
-
 	/*
 	 * Some devices can advertize zone resource limits that are larger than
 	 * the number of sequential zones of the zoned block device, e.g. a
@@ -1568,7 +1572,15 @@ static int disk_update_zone_resources(st
 	}
 
 commit:
-	return queue_limits_commit_update_frozen(q, &lim);
+	ret = queue_limits_commit_update(q, &lim);
+
+unfreeze:
+	if (ret)
+		disk_free_zone_resources(disk);
+
+	blk_mq_unfreeze_queue(q, memflags);
+
+	return ret;
 }
 
 static int blk_revalidate_conv_zone(struct blk_zone *zone, unsigned int idx,
@@ -1733,7 +1745,7 @@ int blk_revalidate_disk_zones(struct gen
 	sector_t zone_sectors = q->limits.chunk_sectors;
 	sector_t capacity = get_capacity(disk);
 	struct blk_revalidate_zone_args args = { };
-	unsigned int noio_flag;
+	unsigned int memflags, noio_flag;
 	int ret = -ENOMEM;
 
 	if (WARN_ON_ONCE(!blk_queue_is_zoned(q)))
@@ -1783,20 +1795,14 @@ int blk_revalidate_disk_zones(struct gen
 		ret = -ENODEV;
 	}
 
-	/*
-	 * Set the new disk zone parameters only once the queue is frozen and
-	 * all I/Os are completed.
-	 */
 	if (ret > 0)
-		ret = disk_update_zone_resources(disk, &args);
-	else
-		pr_warn("%s: failed to revalidate zones\n", disk->disk_name);
-	if (ret) {
-		unsigned int memflags = blk_mq_freeze_queue(q);
+		return disk_update_zone_resources(disk, &args);
 
-		disk_free_zone_resources(disk);
-		blk_mq_unfreeze_queue(q, memflags);
-	}
+	pr_warn("%s: failed to revalidate zones\n", disk->disk_name);
+
+	memflags = blk_mq_freeze_queue(q);
+	disk_free_zone_resources(disk);
+	blk_mq_unfreeze_queue(q, memflags);
 
 	return ret;
 }


