Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F2962EE26F;
	Tue, 17 Jun 2025 16:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178285; cv=none; b=Am/mS8rogJmN7DlyJEvoOc8G8uVIIH7cNE9Q9EGNbp69J1mry2nbjiI8jsSllEmwRPlDoiKlQ9nlD6M9q+c+m8lHEZMGwE5oRcuc3JPqhwitzSMUly4e24GQcODVS2wRiN2sx+CWzkhVhJ877WlywQMngM3OGYsKnFcP463bzJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178285; c=relaxed/simple;
	bh=3QN4AatPJPqQAJgULRkfooIwGmTkS9kNNNeiGQVjS7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y0S95RI47v9yeBd6LJ5zvCRhcsCvMbaX1342kf1abQIfxWv+O4CBlCwd4SnuYHTlUvxN3x3DifTyaNfRmPiLpOr9exx2twEaV/FDyNzYE8RoJ0XVTLilq373pobK4YRaqV3UIpPi/RAR5oi3jSBhMCpcJ2uAl+iTwKZgsGyO4E8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g/nRbBcr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g/nRbBcr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1C78C4CEE3;
	Tue, 17 Jun 2025 16:38:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178285;
	bh=3QN4AatPJPqQAJgULRkfooIwGmTkS9kNNNeiGQVjS7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g/nRbBcrJS9SR6YHvH6kKjuR8GRruvtGaGRq9CEhreGbrwIfPWzlqo/N0f2wgu8kF
	 a9nFwWIUJweWR7Mmq6InJT3R6S/jCf9SL0ceyDPxXtdyqfWOwViPiROVMGW1iZ2q13
	 2GB3DqROZd59E4Wj+yi5wvuCWDlwwGawFjNb5WJg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 438/780] dm: fix dm_blk_report_zones
Date: Tue, 17 Jun 2025 17:22:26 +0200
Message-ID: <20250617152509.298477480@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Benjamin Marzinski <bmarzins@redhat.com>

[ Upstream commit 37f53a2c60d03743e0eacf7a0c01c279776fef4e ]

If dm_get_live_table() returned NULL, dm_put_live_table() was never
called. Also, it is possible that md->zone_revalidate_map will change
while calling this function. Only read it once, so that we are always
using the same value. Otherwise we might miss a call to
dm_put_live_table().

Finally, while md->zone_revalidate_map is set and a process is calling
blk_revalidate_disk_zones() to set up the zone append emulation
resources, it is possible that another process, perhaps triggered by
blkdev_report_zones_ioctl(), will call dm_blk_report_zones(). If
blk_revalidate_disk_zones() fails, these resources can be freed while
the other process is still using them, causing a use-after-free error.

blk_revalidate_disk_zones() will only ever be called when initially
setting up the zone append emulation resources, such as when setting up
a zoned dm-crypt table for the first time. Further table swaps will not
set md->zone_revalidate_map or call blk_revalidate_disk_zones().
However it must be called using the new table (referenced by
md->zone_revalidate_map) and the new queue limits while the DM device is
suspended. dm_blk_report_zones() needs some way to distinguish between a
call from blk_revalidate_disk_zones(), which must be allowed to use
md->zone_revalidate_map to access this not yet activated table, and all
other calls to dm_blk_report_zones(), which should not be allowed while
the device is suspended and cannot use md->zone_revalidate_map, since
the zone resources might be freed by the process currently calling
blk_revalidate_disk_zones().

Solve this by tracking the process that sets md->zone_revalidate_map in
dm_revalidate_zones() and only allowing that process to make use of it
in dm_blk_report_zones().

Fixes: f211268ed1f9b ("dm: Use the block layer zone append emulation")
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Tested-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-core.h |  1 +
 drivers/md/dm-zone.c | 25 +++++++++++++++++--------
 2 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/drivers/md/dm-core.h b/drivers/md/dm-core.h
index 3637761f35853..f3a3f2ef63226 100644
--- a/drivers/md/dm-core.h
+++ b/drivers/md/dm-core.h
@@ -141,6 +141,7 @@ struct mapped_device {
 #ifdef CONFIG_BLK_DEV_ZONED
 	unsigned int nr_zones;
 	void *zone_revalidate_map;
+	struct task_struct *revalidate_map_task;
 #endif
 
 #ifdef CONFIG_IMA
diff --git a/drivers/md/dm-zone.c b/drivers/md/dm-zone.c
index 681058feb63b5..ff9a1a94eea96 100644
--- a/drivers/md/dm-zone.c
+++ b/drivers/md/dm-zone.c
@@ -56,24 +56,31 @@ int dm_blk_report_zones(struct gendisk *disk, sector_t sector,
 {
 	struct mapped_device *md = disk->private_data;
 	struct dm_table *map;
-	int srcu_idx, ret;
+	struct dm_table *zone_revalidate_map = md->zone_revalidate_map;
+	int srcu_idx, ret = -EIO;
+	bool put_table = false;
 
-	if (!md->zone_revalidate_map) {
-		/* Regular user context */
+	if (!zone_revalidate_map || md->revalidate_map_task != current) {
+		/*
+		 * Regular user context or
+		 * Zone revalidation during __bind() is in progress, but this
+		 * call is from a different process
+		 */
 		if (dm_suspended_md(md))
 			return -EAGAIN;
 
 		map = dm_get_live_table(md, &srcu_idx);
-		if (!map)
-			return -EIO;
+		put_table = true;
 	} else {
 		/* Zone revalidation during __bind() */
-		map = md->zone_revalidate_map;
+		map = zone_revalidate_map;
 	}
 
-	ret = dm_blk_do_report_zones(md, map, sector, nr_zones, cb, data);
+	if (map)
+		ret = dm_blk_do_report_zones(md, map, sector, nr_zones, cb,
+					     data);
 
-	if (!md->zone_revalidate_map)
+	if (put_table)
 		dm_put_live_table(md, srcu_idx);
 
 	return ret;
@@ -175,7 +182,9 @@ int dm_revalidate_zones(struct dm_table *t, struct request_queue *q)
 	 * our table for dm_blk_report_zones() to use directly.
 	 */
 	md->zone_revalidate_map = t;
+	md->revalidate_map_task = current;
 	ret = blk_revalidate_disk_zones(disk);
+	md->revalidate_map_task = NULL;
 	md->zone_revalidate_map = NULL;
 
 	if (ret) {
-- 
2.39.5



