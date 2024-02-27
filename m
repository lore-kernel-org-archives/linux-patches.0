Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E470354BFE;
	Tue, 27 Feb 2024 14:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709044259; cv=none; b=sNj63VfMKMKhxZJR0XsSsg03pYwHMA9o2zkiSDPbuPs2Azoh9BD44V1DU0ONKYavR/Ktf6cJaPcowKYIG3n7RNML068J0rt/QlbWqT7hUFMUg9tbrx5Ys37yew7Wk/RiOZNtlVqT8RnVUiNG+mgE4N/r6uMXVJDNqWOPCBbD/cA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709044259; c=relaxed/simple;
	bh=IXU+C2HYYbGoByBfIJgk2OJXnY6DmJHr62I+lm03uE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KQB3U/QQ44CuzPPqZQ9xm4N1pnNXVDig4F12ZiGc8v8GTAjJpWbMdTqFSbiHpcy+M800UJjyd4VZouyPYHnmoaR0uS7y1TskkEkfUx7U9uVh71/XdYjsLXrl2zLlJkNBSG25iTi00TbLLAA6FH5o3TIs6mNZUNuv8l/Z3PXbIOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F763d9yL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F763d9yL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3408FC433F1;
	Tue, 27 Feb 2024 14:30:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709044258;
	bh=IXU+C2HYYbGoByBfIJgk2OJXnY6DmJHr62I+lm03uE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F763d9yLuQmdVBKzQhfmNlUhSFhbYmghu/DEVHu+gK52UdqpmvsQP73VPIvJpgGth
	 Ymks/iuketFo1giNj+wluWQlLQusE1ATFKybuMjwGO/pSUqpVljd8F3lQXHjcYmx3K
	 b5Xb4ITHT9CqcUpsW3/GmL3pTBYm+b0OYXneV1nQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Schmitz <schmitzmic@gmail.com>,
	linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 119/122] block: ataflop: more blk-mq refactoring fixes
Date: Tue, 27 Feb 2024 14:28:00 +0100
Message-ID: <20240227131602.596661200@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131558.694096204@linuxfoundation.org>
References: <20240227131558.694096204@linuxfoundation.org>
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

From: Michael Schmitz <schmitzmic@gmail.com>

commit d28e4dff085c5a87025c9a0a85fb798bd8e9ca17 upstream.

As it turns out, my earlier patch in commit 86d46fdaa12a (block:
ataflop: fix breakage introduced at blk-mq refactoring) was
incomplete. This patch fixes any remaining issues found during
more testing and code review.

Requests exceeding 4 k are handled in 4k segments but
__blk_mq_end_request() is never called on these (still
sectors outstanding on the request). With redo_fd_request()
removed, there is no provision to kick off processing of the
next segment, causing requests exceeding 4k to hang. (By
setting /sys/block/fd0/queue/max_sectors_k <= 4 as workaround,
this behaviour can be avoided).

Instead of reintroducing redo_fd_request(), requeue the remainder
of the request by calling blk_mq_requeue_request() on incomplete
requests (i.e. when blk_update_request() still returns true), and
rely on the block layer to queue the residual as new request.

Both error handling and formatting needs to release the
ST-DMA lock, so call finish_fdc() on these (this was previously
handled by redo_fd_request()). finish_fdc() may be called
legitimately without the ST-DMA lock held - make sure we only
release the lock if we actually held it. In a similar way,
early exit due to errors in ataflop_queue_rq() must release
the lock.

After minor errors, fd_error sets up to recalibrate the drive
but never re-runs the current operation (another task handled by
redo_fd_request() before). Call do_fd_action() to get the next
steps (seek, retry read/write) underway.

Signed-off-by: Michael Schmitz <schmitzmic@gmail.com>
Fixes: 6ec3938cff95f (ataflop: convert to blk-mq)
CC: linux-block@vger.kernel.org
Link: https://lore.kernel.org/r/20211024002013.9332-1-schmitzmic@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[MSch: v5.10 backport merge conflict fix]
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/ataflop.c |   42 +++++++++++++++++++++++++++++++++++++-----
 1 file changed, 37 insertions(+), 5 deletions(-)

--- a/drivers/block/ataflop.c
+++ b/drivers/block/ataflop.c
@@ -456,10 +456,20 @@ static DEFINE_TIMER(fd_timer, check_chan
 	
 static void fd_end_request_cur(blk_status_t err)
 {
+	DPRINT(("fd_end_request_cur(), bytes %d of %d\n",
+		blk_rq_cur_bytes(fd_request),
+		blk_rq_bytes(fd_request)));
+
 	if (!blk_update_request(fd_request, err,
 				blk_rq_cur_bytes(fd_request))) {
+		DPRINT(("calling __blk_mq_end_request()\n"));
 		__blk_mq_end_request(fd_request, err);
 		fd_request = NULL;
+	} else {
+		/* requeue rest of request */
+		DPRINT(("calling blk_mq_requeue_request()\n"));
+		blk_mq_requeue_request(fd_request, true);
+		fd_request = NULL;
 	}
 }
 
@@ -697,12 +707,21 @@ static void fd_error( void )
 	if (fd_request->error_count >= MAX_ERRORS) {
 		printk(KERN_ERR "fd%d: too many errors.\n", SelectedDrive );
 		fd_end_request_cur(BLK_STS_IOERR);
+		finish_fdc();
+		return;
 	}
 	else if (fd_request->error_count == RECALIBRATE_ERRORS) {
 		printk(KERN_WARNING "fd%d: recalibrating\n", SelectedDrive );
 		if (SelectedDrive != -1)
 			SUD.track = -1;
 	}
+	/* need to re-run request to recalibrate */
+	atari_disable_irq( IRQ_MFP_FDC );
+
+	setup_req_params( SelectedDrive );
+	do_fd_action( SelectedDrive );
+
+	atari_enable_irq( IRQ_MFP_FDC );
 }
 
 
@@ -737,6 +756,7 @@ static int do_format(int drive, int type
 	if (type) {
 		if (--type >= NUM_DISK_MINORS ||
 		    minor2disktype[type].drive_types > DriveType) {
+			finish_fdc();
 			ret = -EINVAL;
 			goto out;
 		}
@@ -745,6 +765,7 @@ static int do_format(int drive, int type
 	}
 
 	if (!UDT || desc->track >= UDT->blocks/UDT->spt/2 || desc->head >= 2) {
+		finish_fdc();
 		ret = -EINVAL;
 		goto out;
 	}
@@ -785,6 +806,7 @@ static int do_format(int drive, int type
 
 	wait_for_completion(&format_wait);
 
+	finish_fdc();
 	ret = FormatError ? -EIO : 0;
 out:
 	blk_mq_unquiesce_queue(q);
@@ -819,6 +841,7 @@ static void do_fd_action( int drive )
 		    else {
 			/* all sectors finished */
 			fd_end_request_cur(BLK_STS_OK);
+			finish_fdc();
 			return;
 		    }
 		}
@@ -1222,8 +1245,8 @@ static void fd_rwsec_done1(int status)
 	}
 	else {
 		/* all sectors finished */
-		finish_fdc();
 		fd_end_request_cur(BLK_STS_OK);
+		finish_fdc();
 	}
 	return;
   
@@ -1345,7 +1368,7 @@ static void fd_times_out(struct timer_li
 
 static void finish_fdc( void )
 {
-	if (!NeedSeek) {
+	if (!NeedSeek || !stdma_is_locked_by(floppy_irq)) {
 		finish_fdc_done( 0 );
 	}
 	else {
@@ -1380,7 +1403,8 @@ static void finish_fdc_done( int dummy )
 	start_motor_off_timer();
 
 	local_irq_save(flags);
-	stdma_release();
+	if (stdma_is_locked_by(floppy_irq))
+		stdma_release();
 	local_irq_restore(flags);
 
 	DPRINT(("finish_fdc() finished\n"));
@@ -1477,7 +1501,9 @@ static blk_status_t ataflop_queue_rq(str
 	int drive = floppy - unit;
 	int type = floppy->type;
 
-	DPRINT(("Queue request: drive %d type %d last %d\n", drive, type, bd->last));
+	DPRINT(("Queue request: drive %d type %d sectors %d of %d last %d\n",
+		drive, type, blk_rq_cur_sectors(bd->rq),
+		blk_rq_sectors(bd->rq), bd->last));
 
 	spin_lock_irq(&ataflop_lock);
 	if (fd_request) {
@@ -1499,6 +1525,7 @@ static blk_status_t ataflop_queue_rq(str
 		/* drive not connected */
 		printk(KERN_ERR "Unknown Device: fd%d\n", drive );
 		fd_end_request_cur(BLK_STS_IOERR);
+		stdma_release();
 		goto out;
 	}
 		
@@ -1515,11 +1542,13 @@ static blk_status_t ataflop_queue_rq(str
 		if (--type >= NUM_DISK_MINORS) {
 			printk(KERN_WARNING "fd%d: invalid disk format", drive );
 			fd_end_request_cur(BLK_STS_IOERR);
+			stdma_release();
 			goto out;
 		}
 		if (minor2disktype[type].drive_types > DriveType)  {
 			printk(KERN_WARNING "fd%d: unsupported disk format", drive );
 			fd_end_request_cur(BLK_STS_IOERR);
+			stdma_release();
 			goto out;
 		}
 		type = minor2disktype[type].index;
@@ -1620,6 +1649,7 @@ static int fd_locked_ioctl(struct block_
 		/* what if type > 0 here? Overwrite specified entry ? */
 		if (type) {
 		        /* refuse to re-set a predefined type for now */
+			finish_fdc();
 			return -EINVAL;
 		}
 
@@ -1687,8 +1717,10 @@ static int fd_locked_ioctl(struct block_
 
 		/* sanity check */
 		if (setprm.track != dtp->blocks/dtp->spt/2 ||
-		    setprm.head != 2)
+		    setprm.head != 2) {
+			finish_fdc();
 			return -EINVAL;
+		}
 
 		UDT = dtp;
 		set_capacity(floppy->disk, UDT->blocks);


