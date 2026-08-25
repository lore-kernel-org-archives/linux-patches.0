Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7099394470;
	Tue, 25 Aug 2026 13:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787664597; cv=none; b=R0mCPwbkbJTufeLz/VqE+aOAV6qmfBuGC9sGn5nlN9WXDJX5nBsXXeCGZeYF0hRsM3Btt92kzXfI0oOqWKyhaXi6+5CzFnQ90OPegLI7VIDtruEiraGT+jaUKIF6OwGT9ZAANr5UDTGCu0H3dJmMaQiZPvnxyD/tv7Row2inNtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787664597; c=relaxed/simple;
	bh=ttEipSOH35C2JqdR96CAOJinXMuaNodOLjXILYMXp3U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YiF0BvWpi/gLXFaCsMKp+TMKJml4Zii/c2hf1p+gPy0tWgPzY06jraEaMn8RepymNyxkt3MDcfV++iMk/1aup/4fwNCjFMjriwz97iNbiZ4zOnAQictEUQytxzDv/Gj23IRa88B3xmqUrkPuwhP0PVqcamU91L+EonNDhGSL85E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Gncgxcj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Gncgxcj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 051011F000E9;
	Tue, 25 Aug 2026 13:29:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787664596;
	bh=ltDdSMjStT7tUSDgjl388NOOQPkR37vxtHu6CQquVKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2GncgxcjVFk0KzecjnZQX4WR8EhwoLlQB5NpKt/5ZP+D/fHvuQwBKVJac04FQZ+IO
	 oxuRhuXPIA1Tqsz1yJi+NpGPAtjr7f7ymN4U79yigfKtljOCyeypJFN9ZjI0OrIOLt
	 tspGCdt5KlyoNMpFWXYj+VVk7pZNgU0I9Yi5VLpU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+abd6a8dca0f2b7726060@syzkaller.appspotmail.com,
	Rik van Riel <riel@surriel.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.2 23/82] null_blk: fix UBSAN shift-out-of-bounds when zone_size is 0 or overflows
Date: Tue, 25 Aug 2026 15:25:10 +0200
Message-ID: <20260825132542.425593659@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.560541185@linuxfoundation.org>
References: <20260825132541.560541185@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rik van Riel <riel@surriel.com>

commit 95491fb05105b61050cb623a5e0227eb26aa3525 upstream.

null_zone_no() does sect >> ilog2(dev->zone_size_sects). When
zone_size_sects is 0, ilog2(0) returns -1, producing shift exponent -1
which UBSAN reports as shift-out-of-bounds.

  UBSAN: shift-out-of-bounds in drivers/block/null_blk/zoned.c:21:14
  shift exponent -1 is negative
  Call Trace:
   null_zone_no drivers/block/null_blk/zoned.c:21 [inline]
   null_process_zoned_cmd+0xf76/0xf80 drivers/block/null_blk/zoned.c:728
   null_handle_cmd drivers/block/null_blk/main.c:1455 [inline]
   null_queue_rq+0x8bc/0xe70 drivers/block/null_blk/main.c:1703
   __blk_mq_issue_directly block/blk-mq.c:2694 [inline]
   blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2754
   blk_mq_submit_bio+0x20c0/0x2a40 block/blk-mq.c:3208
   submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
   block_read_full_folio+0x7a6/0x810 fs/buffer.c:2463
   filemap_read_folio+0x12c/0x3a0 mm/filemap.c:2510
   read_part_sector+0xb6/0x2b0 block/partitions/core.c:724
   adfspart_check_ICS+0xb1/0x960 block/partitions/acorn.c:357
   check_partition block/partitions/core.c:143 [inline]
   blk_add_partitions block/partitions/core.c:591 [inline]
   bdev_disk_changed+0x851/0x17a0 block/partitions/core.c:695
   blkdev_get_whole+0x372/0x510 block/bdev.c:751
   add_disk_final block/genhd.c:412 [inline]
   add_disk_fwnode+0x24b/0x3a0 block/genhd.c:606
   null_add_dev+0x130b/0x1d70 drivers/block/null_blk/main.c:2052
   nullb_device_power_store+0x240/0x380 drivers/block/null_blk/main.c:501
   configfs_write_iter+0x337/0x430 fs/configfs/file.c:229

Syzkaller triggers this by creating a zoned null_blk device via
configfs. The Call Trace shows configfs_write_iter in configfs/file.c
handling a write to power file, which calls nullb_device_power_store in
main.c, which calls null_add_dev in main.c, which calls add_disk in
genhd.c, which triggers partition scan via bdev_disk_changed in
partitions/core.c.

A zoned null_blk device with zone_size 0 should not be legal. Existing
code tries to reject it via is_power_of_2() check in zoned.c and
!zone_size check in main.c, but syzkaller can still reach
null_zone_no() with zone_size_sects 0 via two paths:

1. Direct 0 via configfs: zone_size attribute store in main.c has
NULLB_DEVICE_ATTR(zone_size, ulong, NULL) with no validation callback,
so echo 0 > zone_size succeeds before power store. If zoned is false
at power store time, the !zone_size check in main.c is skipped, and
later zoned set true leaves zone_size 0.

2. Large value overflow: mb_to_sects() in zoned.c does
(sector_t)mb * SZ_1M >> SECTOR_SHIFT which is mb * 2048. If mb is
1UL << 53 (9PB), mb * 2048 overflows 64-bit to 0. The value is
power-of-two so is_power_of_2() passes, but mb_to_sects() returns 0.

Check for zero zone_size explicitly in null_init_zoned_dev() in
zoned.c, returning -EINVAL with "must be non-zero power-of-two".
Check for zero zone_size_sects after mb_to_sects() conversion,
returning -EINVAL for overflow case. Keep defensive check in
null_zone_no() returning 0 for zero sectors to avoid shift out-of-bounds
even if  zero slips through.

This change should be safe because zone_size is set once in
null_init_zoned_dev() under device lock and never changes after, and 0
is never valid for a zoned device. Returning -EINVAL at init time fails
device creation early with clear error, while defensive return 0 in
null_zone_no() makes zoned command fail via offline zone check.
No new locking is introduced.

Reported-by: syzbot+abd6a8dca0f2b7726060@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=abd6a8dca0f2b7726060
Link: https://lore.kernel.org/all/6a75205c.01d0871a.3a0d52.0033.GAE@google.com/
Fixes: 8a3cf049af68 ("null_blk: add zoned block device emulation")
Cc: stable@vger.kernel.org
Assisted-by: Hermes:muse-spark-1.2 syzkaller
Signed-off-by: Rik van Riel <riel@surriel.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Link: https://patch.msgid.link/20260808114239.69167f68@fangorn
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/null_blk/zoned.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/block/null_blk/zoned.c
+++ b/drivers/block/null_blk/zoned.c
@@ -18,6 +18,8 @@ static inline sector_t mb_to_sects(unsig
 
 static inline unsigned int null_zone_no(struct nullb_device *dev, sector_t sect)
 {
+	if (WARN_ON_ONCE(!dev->zone_size_sects))
+		return 0;
 	return sect >> ilog2(dev->zone_size_sects);
 }
 
@@ -56,8 +58,8 @@ int null_init_zoned_dev(struct nullb_dev
 	sector_t sector = 0;
 	unsigned int i;
 
-	if (!is_power_of_2(dev->zone_size)) {
-		pr_err("zone_size must be power-of-two\n");
+	if (!dev->zone_size || !is_power_of_2(dev->zone_size)) {
+		pr_err("zone_size must be non-zero power-of-two\n");
 		return -EINVAL;
 	}
 	if (dev->zone_size > dev->size) {
@@ -88,6 +90,10 @@ int null_init_zoned_dev(struct nullb_dev
 	zone_capacity_sects = mb_to_sects(dev->zone_capacity);
 	dev_capacity_sects = mb_to_sects(dev->size);
 	dev->zone_size_sects = mb_to_sects(dev->zone_size);
+	if (!dev->zone_size_sects) {
+		pr_err("zone_size too large or too small, leads to zero sectors\n");
+		return -EINVAL;
+	}
 	dev->nr_zones = round_up(dev_capacity_sects, dev->zone_size_sects)
 		>> ilog2(dev->zone_size_sects);
 


