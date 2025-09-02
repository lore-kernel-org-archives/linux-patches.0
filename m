Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07649314A8B;
	Tue,  2 Sep 2025 13:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820050; cv=none; b=OjKbXfwsTUsqC+Fa/XhrSfk2p0D40Qxx+jHQv+1JnJtNtVHQ1nCVp8hi/+DLBHNFNx4wDJHY2J9aX5I/NhrF8fjWrqM1G6U33PJlJcCpHB3+8ENEPR56t6OpcZEQJdorUPhD1mT7E+LB1QlGZ9xzEE3A0YiGeUL63JMPI6sE/rQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820050; c=relaxed/simple;
	bh=tpi/8GSFQlH/cjECq13gUF8DSgnCzlNSMKcSqySm+tI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IBDoTL8wzg2cdy7dz/oxXid+tvbLVmJTIWSJBXFyDPTUaE5y/9AwPANWBkmqt081ynzq9UFBsfpGgZL6IrjTQ4nTUWd287ddol/zK1U3sroafWohnx8qoOT+paWxcyGGVodBBLQfB1G948fSSvjS418y5AH2vnJqVrbyY/NfrCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j/jgyg1S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j/jgyg1S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 860E2C4CEED;
	Tue,  2 Sep 2025 13:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820049;
	bh=tpi/8GSFQlH/cjECq13gUF8DSgnCzlNSMKcSqySm+tI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j/jgyg1SgWGCUq8Nr6rJXf9JAdug/iFjyRDeq4hBN3fnxU6E+/WybLKu2/UlEmuOP
	 4XAAfywEjRlEXZg22vpaIw8tIX9VvB8Hf+MKQLTTPJjzJ72f1yJvpd/9OtY93uBMba
	 b2bl4Tb4p76mhqDQF48sbnULqks4yZMWk8uD8Kq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Bart Van Assche <bvanassche@acm.org>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 78/95] blk-zoned: Fix a lockdep complaint about recursive locking
Date: Tue,  2 Sep 2025 15:20:54 +0200
Message-ID: <20250902131942.603456062@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131939.601201881@linuxfoundation.org>
References: <20250902131939.601201881@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

commit 198f36f902ec7e99b645382505f74b87a4523ed9 upstream.

If preparing a write bio fails then blk_zone_wplug_bio_work() calls
bio_endio() with zwplug->lock held. If a device mapper driver is stacked
on top of the zoned block device then this results in nested locking of
zwplug->lock. The resulting lockdep complaint is a false positive
because this is nested locking and not recursive locking. Suppress this
false positive by calling blk_zone_wplug_bio_io_error() without holding
zwplug->lock. This is safe because no code in
blk_zone_wplug_bio_io_error() depends on zwplug->lock being held. This
patch suppresses the following lockdep complaint:

WARNING: possible recursive locking detected
--------------------------------------------
kworker/3:0H/46 is trying to acquire lock:
ffffff882968b830 (&zwplug->lock){-...}-{2:2}, at: blk_zone_write_plug_bio_endio+0x64/0x1f0

but task is already holding lock:
ffffff88315bc230 (&zwplug->lock){-...}-{2:2}, at: blk_zone_wplug_bio_work+0x8c/0x48c

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&zwplug->lock);
  lock(&zwplug->lock);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

3 locks held by kworker/3:0H/46:
 #0: ffffff8809486758 ((wq_completion)sdd_zwplugs){+.+.}-{0:0}, at: process_one_work+0x1bc/0x65c
 #1: ffffffc085de3d70 ((work_completion)(&zwplug->bio_work)){+.+.}-{0:0}, at: process_one_work+0x1e4/0x65c
 #2: ffffff88315bc230 (&zwplug->lock){-...}-{2:2}, at: blk_zone_wplug_bio_work+0x8c/0x48c

stack backtrace:
CPU: 3 UID: 0 PID: 46 Comm: kworker/3:0H Tainted: G        W  OE      6.12.38-android16-5-maybe-dirty-4k #1 8b362b6f76e3645a58cd27d86982bce10d150025
Tainted: [W]=WARN, [O]=OOT_MODULE, [E]=UNSIGNED_MODULE
Hardware name: Spacecraft board based on MALIBU (DT)
Workqueue: sdd_zwplugs blk_zone_wplug_bio_work
Call trace:
 dump_backtrace+0xfc/0x17c
 show_stack+0x18/0x28
 dump_stack_lvl+0x40/0xa0
 dump_stack+0x18/0x24
 print_deadlock_bug+0x38c/0x398
 __lock_acquire+0x13e8/0x2e1c
 lock_acquire+0x134/0x2b4
 _raw_spin_lock_irqsave+0x5c/0x80
 blk_zone_write_plug_bio_endio+0x64/0x1f0
 bio_endio+0x9c/0x240
 __dm_io_complete+0x214/0x260
 clone_endio+0xe8/0x214
 bio_endio+0x218/0x240
 blk_zone_wplug_bio_work+0x204/0x48c
 process_one_work+0x26c/0x65c
 worker_thread+0x33c/0x498
 kthread+0x110/0x134
 ret_from_fork+0x10/0x20

Cc: stable@vger.kernel.org
Cc: Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Fixes: dd291d77cc90 ("block: Introduce zone write plugging")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Link: https://lore.kernel.org/r/20250825182720.1697203-1-bvanassche@acm.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-zoned.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -1281,14 +1281,14 @@ static void blk_zone_wplug_bio_work(stru
 	struct block_device *bdev;
 	unsigned long flags;
 	struct bio *bio;
+	bool prepared;
 
 	/*
 	 * Submit the next plugged BIO. If we do not have any, clear
 	 * the plugged flag.
 	 */
-	spin_lock_irqsave(&zwplug->lock, flags);
-
 again:
+	spin_lock_irqsave(&zwplug->lock, flags);
 	bio = bio_list_pop(&zwplug->bio_list);
 	if (!bio) {
 		zwplug->flags &= ~BLK_ZONE_WPLUG_PLUGGED;
@@ -1296,13 +1296,14 @@ again:
 		goto put_zwplug;
 	}
 
-	if (!blk_zone_wplug_prepare_bio(zwplug, bio)) {
+	prepared = blk_zone_wplug_prepare_bio(zwplug, bio);
+	spin_unlock_irqrestore(&zwplug->lock, flags);
+
+	if (!prepared) {
 		blk_zone_wplug_bio_io_error(zwplug, bio);
 		goto again;
 	}
 
-	spin_unlock_irqrestore(&zwplug->lock, flags);
-
 	bdev = bio->bi_bdev;
 
 	/*


