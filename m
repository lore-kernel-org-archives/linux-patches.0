Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AEDE6BB29;
	Thu, 11 Apr 2024 10:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832287; cv=none; b=q+OD95PN6Amk+6ls+Lh52kNqGCVHWrYlfs3gTnbh1pcZbPK/SB26BzTrl9AZtqaIM+4CnRuQ43KAmwEmTumYK6viV6lyqBjSk3kBRm7YZfaMpyqMO5mEpVT7HDTlh1uJA9ZuOCW8g63XlDrgIedW4Am9HXovNEbQjTmxk8pNEvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832287; c=relaxed/simple;
	bh=1zXkG6RLLdPzFWfDM8CrVR0ZwcQQYdksAe7sbArpQe8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t4+H02uC6J7Y6ytsk9VHb/nne0O/9Gs6euPoF4AE7VbfG/H5lYSJSpWe2dE+wh3JcYbctOJlsIsiXjuh/BLqgjax8WK5cvgzyZJSwd0wKDK6UbkVPzhyYvUPscTGsEo0SRM/vSOd8PWkJHTLUAM+PUXL5wywEQBxjolRS7UHoUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RbKnMlhP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RbKnMlhP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 397E7C433C7;
	Thu, 11 Apr 2024 10:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832286;
	bh=1zXkG6RLLdPzFWfDM8CrVR0ZwcQQYdksAe7sbArpQe8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RbKnMlhPFGK8iOuO9nc97S7NijAb4eXV2KyDcYcmTeEjDYfF4fgKH8+SROPm5TJJM
	 F55kDHHpPUkQksmQPVvzWZn4M+S/ev/TUYpvAyD3APSAYBdEvFHrD26El1jZqpg41Q
	 fPUXrhYsFihjEvWugRYmIHgpdafOXXI/8o95ryYc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Damien Le Moal <damien.lemoal@opensource.wdc.com>,
	Johannes Thumshirn <johannes.thumshirn@wdc.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.10 292/294] scsi: sd: Fix wrong zone_write_granularity value during revalidate
Date: Thu, 11 Apr 2024 11:57:35 +0200
Message-ID: <20240411095444.325864607@linuxfoundation.org>
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

From: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

commit 288b3271d920c9ba949c3bab0f749f4cecc70e09 upstream.

When the sd driver revalidates host-managed SMR disks, it calls
disk_set_zoned() which changes the zone_write_granularity attribute value
to the logical block size regardless of the device type. After that, the sd
driver overwrites the value in sd_zbc_read_zone() with the physical block
size, since ZBC/ZAC requires this for host-managed disks. Between the calls
to disk_set_zoned() and sd_zbc_read_zone(), there exists a window where the
attribute shows the logical block size as the zone_write_granularity value,
which is wrong for host-managed disks. The duration of the window is from
20ms to 200ms, depending on report zone command execution time.

To avoid the wrong zone_write_granularity value between disk_set_zoned()
and sd_zbc_read_zone(), modify the value not in sd_zbc_read_zone() but
just after disk_set_zoned() call.

Fixes: a805a4fa4fa3 ("block: introduce zone_write_granularity limit")
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Link: https://lore.kernel.org/r/20230306063024.3376959-1-shinichiro.kawasaki@wdc.com
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/sd.c     |    7 ++++++-
 drivers/scsi/sd_zbc.c |    8 --------
 2 files changed, 6 insertions(+), 9 deletions(-)

--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3026,8 +3026,13 @@ static void sd_read_block_characteristic
 	}
 
 	if (sdkp->device->type == TYPE_ZBC) {
-		/* Host-managed */
+		/*
+		 * Host-managed: Per ZBC and ZAC specifications, writes in
+		 * sequential write required zones of host-managed devices must
+		 * be aligned to the device physical block size.
+		 */
 		blk_queue_set_zoned(sdkp->disk, BLK_ZONED_HM);
+		blk_queue_zone_write_granularity(q, sdkp->physical_block_size);
 	} else {
 		sdkp->zoned = (buffer[8] >> 4) & 3;
 		if (sdkp->zoned == 1) {
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -793,14 +793,6 @@ int sd_zbc_read_zones(struct scsi_disk *
 	blk_queue_max_active_zones(q, 0);
 	nr_zones = round_up(sdkp->capacity, zone_blocks) >> ilog2(zone_blocks);
 
-	/*
-	 * Per ZBC and ZAC specifications, writes in sequential write required
-	 * zones of host-managed devices must be aligned to the device physical
-	 * block size.
-	 */
-	if (blk_queue_zoned_model(q) == BLK_ZONED_HM)
-		blk_queue_zone_write_granularity(q, sdkp->physical_block_size);
-
 	/* READ16/WRITE16 is mandatory for ZBC disks */
 	sdkp->device->use_16_for_rw = 1;
 	sdkp->device->use_10_for_rw = 0;


