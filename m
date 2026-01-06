Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAC492DF6EA;
	Tue,  6 Jan 2026 17:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721327; cv=none; b=ZudfULnCzARuawbxmuCM9L0MLMrRrrDnl2KfJdGoNTApUl/BE2CO3oQLCJuZHpbpHMFLvrxszyDO57SxukwULRyxM+0Q9uPyC3qMOkRhgbdDrdEzYaR/7fjKwR074TROq2KwZH/p8VrYUgijNZLgZKA5L+Ryy5SDoZNIbfnrY5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721327; c=relaxed/simple;
	bh=M2DchLKRX+8SwO6vQjqbKK0QQlkkwDm6pHZfr4GEgAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=komC13fwTNyz96B+G2O1H7CX726QSbsQ4oWE0HM4jCNj0LvXCqt7eulMqdEUAEE9P+uTPbJ5oMMyLRqKasljjdKgpn9UUqizLvldxIyO57z1KsaopP3FFPc2gE8kvKVoeorvRr9+XOicumquIM/B1TWx61l44tu5PLp+h6i35rU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yZTiVk1q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yZTiVk1q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A128C116C6;
	Tue,  6 Jan 2026 17:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721326;
	bh=M2DchLKRX+8SwO6vQjqbKK0QQlkkwDm6pHZfr4GEgAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yZTiVk1qxR0MjaGREerB18m3KfIY67vBgsCotN9xiun/nfN7ZAmvFoimsD2bh9MXp
	 SmW1x+ruUtrmOMB1dWWOqzE9+UHSn3swkO/1v2nNvlgSqoEbZAVc4rLbFS+p7Gp2vI
	 sPYOZ/VDYJKIuEU8rNhtWeL3JEDStlpK3xXOng6I=
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
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 504/567] block: freeze queue when updating zone resources
Date: Tue,  6 Jan 2026 18:04:46 +0100
Message-ID: <20260106170510.014112753@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damien Le Moal <dlemoal@kernel.org>

[ Upstream commit bba4322e3f303b2d656e748be758320b567f046f ]

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
[ adapted blk_mq_freeze_queue/unfreeze_queue calls to single-argument void API ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-zoned.c |   39 +++++++++++++++++++++++----------------
 1 file changed, 23 insertions(+), 16 deletions(-)

--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -1514,6 +1514,11 @@ static int disk_update_zone_resources(st
 	unsigned int nr_seq_zones, nr_conv_zones;
 	unsigned int pool_size;
 	struct queue_limits lim;
+	int ret = 0;
+
+	lim = queue_limits_start_update(q);
+
+	blk_mq_freeze_queue(q);
 
 	disk->nr_zones = args->nr_zones;
 	disk->zone_capacity = args->zone_capacity;
@@ -1523,11 +1528,10 @@ static int disk_update_zone_resources(st
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
@@ -1564,7 +1568,15 @@ static int disk_update_zone_resources(st
 	}
 
 commit:
-	return queue_limits_commit_update_frozen(q, &lim);
+	ret = queue_limits_commit_update(q, &lim);
+
+unfreeze:
+	if (ret)
+		disk_free_zone_resources(disk);
+
+	blk_mq_unfreeze_queue(q);
+
+	return ret;
 }
 
 static int blk_revalidate_conv_zone(struct blk_zone *zone, unsigned int idx,
@@ -1785,19 +1797,14 @@ int blk_revalidate_disk_zones(struct gen
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
-		blk_mq_freeze_queue(q);
-		disk_free_zone_resources(disk);
-		blk_mq_unfreeze_queue(q);
-	}
+		return disk_update_zone_resources(disk, &args);
+
+	pr_warn("%s: failed to revalidate zones\n", disk->disk_name);
+
+	blk_mq_freeze_queue(q);
+	disk_free_zone_resources(disk);
+	blk_mq_unfreeze_queue(q);
 
 	return ret;
 }


