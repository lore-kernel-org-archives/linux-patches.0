Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 952FA371CE3;
	Wed, 20 May 2026 16:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294443; cv=none; b=Vu3R3gPaQgN9uu/JC6OVoxR0ylA0xcFhPVLNfhCtflCxhHBRXMtYlBQV/98LSP3svA1Vtj6niG0ySjLzVdPs6CBu+F2G0NOAb/5D09s4Yu5NghpSM+rlZPXBM3jGtKMFw+GizsY9Oj0Ll11R5z2EDQRSHZcponzKqwhuGXwmxTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294443; c=relaxed/simple;
	bh=r423r2prTJF1IAsWbKjxXu+H2okSuOyBnSyoiOhRXC0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LtkfM8X6yBwuTg2QmIf+dcrU1KQHfi3gRFaI2CiqLJ5IBdgWhpQeCy+ZE5FGJKcb8m/MmsN32xCa9vu1MmA+q5LzJYxsHpxCFL/kk+b1eFLvwP1zlWFj25Ci2C148IIKtmhN16uTqfciHTcDMXsQtbx6S/5DJGoFjs+mEObx2Ho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0f8rNYuJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0f8rNYuJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6A681F000E9;
	Wed, 20 May 2026 16:27:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294442;
	bh=W6jz7bJZRimlxkpmrR+H6F/4YKYWQkjLRsanqkg5iCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0f8rNYuJJUm5qwDdE7OLZ9nt7W580QxQVPs4wImZf7Qx/vL728sOsxCpVvPVdGGIP
	 JG1JdY4LvUPGR84t+eXLZYiTg2iIS+6whyTrHnOXuQ70xVmeN5co7VSxc6HLQTBPOU
	 0R9bkIxHMHa2gtG+Z6E11C0mAhYDw1B/woneC1EM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Jackie Liu <liuyun01@kylinos.cn>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0009/1146] block: fix zones_cond memory leak on zone revalidation error paths
Date: Wed, 20 May 2026 18:04:19 +0200
Message-ID: <20260520162148.604250843@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jackie Liu <liuyun01@kylinos.cn>

[ Upstream commit 2a2f520fda824b5a25c93f2249578ea150c24e06 ]

When blk_revalidate_disk_zones() fails after disk_revalidate_zone_resources()
has allocated args.zones_cond, the memory is leaked because no error path
frees it.

Fixes: 6e945ffb6555 ("block: use zone condition to determine conventional zones")
Suggested-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>
Link: https://patch.msgid.link/20260331111216.24242-1-liu.yun@linux.dev
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-zoned.c | 26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index 7aae3c236cad6..a4d82342e37ac 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -1877,6 +1877,7 @@ static int disk_revalidate_zone_resources(struct gendisk *disk,
 {
 	struct queue_limits *lim = &disk->queue->limits;
 	unsigned int pool_size;
+	int ret = 0;
 
 	args->disk = disk;
 	args->nr_zones =
@@ -1899,10 +1900,13 @@ static int disk_revalidate_zone_resources(struct gendisk *disk,
 		pool_size =
 			min(BLK_ZONE_WPLUG_DEFAULT_POOL_SIZE, args->nr_zones);
 
-	if (!disk->zone_wplugs_hash)
-		return disk_alloc_zone_resources(disk, pool_size);
+	if (!disk->zone_wplugs_hash) {
+		ret = disk_alloc_zone_resources(disk, pool_size);
+		if (ret)
+			kfree(args->zones_cond);
+	}
 
-	return 0;
+	return ret;
 }
 
 /*
@@ -1934,6 +1938,7 @@ static int disk_update_zone_resources(struct gendisk *disk,
 	disk->zone_capacity = args->zone_capacity;
 	disk->last_zone_capacity = args->last_zone_capacity;
 	disk_set_zones_cond_array(disk, args->zones_cond);
+	args->zones_cond = NULL;
 
 	/*
 	 * Some devices can advertise zone resource limits that are larger than
@@ -2216,21 +2221,30 @@ int blk_revalidate_disk_zones(struct gendisk *disk)
 	}
 	memalloc_noio_restore(noio_flag);
 
+	if (ret <= 0)
+		goto free_resources;
+
 	/*
 	 * If zones where reported, make sure that the entire disk capacity
 	 * has been checked.
 	 */
-	if (ret > 0 && args.sector != capacity) {
+	if (args.sector != capacity) {
 		pr_warn("%s: Missing zones from sector %llu\n",
 			disk->disk_name, args.sector);
 		ret = -ENODEV;
+		goto free_resources;
 	}
 
-	if (ret > 0)
-		return disk_update_zone_resources(disk, &args);
+	ret = disk_update_zone_resources(disk, &args);
+	if (ret)
+		goto free_resources;
+
+	return 0;
 
+free_resources:
 	pr_warn("%s: failed to revalidate zones\n", disk->disk_name);
 
+	kfree(args.zones_cond);
 	memflags = blk_mq_freeze_queue(q);
 	disk_free_zone_resources(disk);
 	blk_mq_unfreeze_queue(q, memflags);
-- 
2.53.0



