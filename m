Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01D9C27A12D;
	Wed, 23 Apr 2025 14:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420108; cv=none; b=ePfJ8wWsEQ4oYCsTdBLjdiTnIjKtOdX9cdiTN0qsWiaNY4zXh1CbcLtcQGzD9Q5Snstp4vxmURvV/qAvkXLnLE3TMU4Oi8v3MMpzf7J2GT2QVwXEfFdbGosKkCGv10P4LOqe6r+tcfSlZSPKvk4O5eWOp9sz4tOeSW+niUYwHIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420108; c=relaxed/simple;
	bh=VyJeN127bCwjCck4YkkOmjPpjljSHLDCjtLrVdCp100=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HnFU2RfdcelMc2Jud2Xr9Uphs/W+WOEwu0G2Itm1jbwhqlmHZxx31HriWFj78uGFTsOT1Sidy5h/QSC/wSNnOiCGT4H5lKj8q4aqndMervz8ztJGYLdda10y+e5WyKsGn7K5aubz4tqvSSWSBlKfI5xVmMYWmJSuSoQhJK2JN60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vnaFwRi/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vnaFwRi/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B205C4CEE2;
	Wed, 23 Apr 2025 14:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420107;
	bh=VyJeN127bCwjCck4YkkOmjPpjljSHLDCjtLrVdCp100=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vnaFwRi/kl2EZRmXk4UOqgSj2xbQ8tBveQzu8mn9ITTJZppT5Ub63eqXzVLrcvt2/
	 atVMPUoEwjpj6akN3LrT8IwUTGLbZgzNpVa6uwv1QOZHrUgVQC4pdVfFToOJOAvtMa
	 XrtzQRP4EhHMg7bx8o8/KrWeSDcJpJXCNnozyung=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Darrick J. Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 060/241] loop: stop using vfs_iter_{read,write} for buffered I/O
Date: Wed, 23 Apr 2025 16:42:04 +0200
Message-ID: <20250423142623.057337056@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit f2fed441c69b9237760840a45a004730ff324faf ]

vfs_iter_{read,write} always perform direct I/O when the file has the
O_DIRECT flag set, which breaks disabling direct I/O using the
LOOP_SET_STATUS / LOOP_SET_STATUS64 ioctls.

This was recenly reported as a regression, but as far as I can tell
was only uncovered by better checking for block sizes and has been
around since the direct I/O support was added.

Fix this by using the existing aio code that calls the raw read/write
iter methods instead.  Note that despite the comments there is no need
for block drivers to ever call flush_dcache_page themselves, and the
call is a left-over from prehistoric times.

Fixes: ab1cb278bc70 ("block: loop: introduce ioctl command of LOOP_SET_DIRECT_IO")
Reported-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Tested-by: Darrick J. Wong <djwong@kernel.org>
Link: https://lore.kernel.org/r/20250409130940.3685677-1-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/loop.c | 112 +++++++------------------------------------
 1 file changed, 17 insertions(+), 95 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 1a4dbd4116069..08ba8f0c5ba12 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -235,72 +235,6 @@ static void loop_set_size(struct loop_device *lo, loff_t size)
 		kobject_uevent(&disk_to_dev(lo->lo_disk)->kobj, KOBJ_CHANGE);
 }
 
-static int lo_write_bvec(struct file *file, struct bio_vec *bvec, loff_t *ppos)
-{
-	struct iov_iter i;
-	ssize_t bw;
-
-	iov_iter_bvec(&i, ITER_SOURCE, bvec, 1, bvec->bv_len);
-
-	bw = vfs_iter_write(file, &i, ppos, 0);
-
-	if (likely(bw ==  bvec->bv_len))
-		return 0;
-
-	printk_ratelimited(KERN_ERR
-		"loop: Write error at byte offset %llu, length %i.\n",
-		(unsigned long long)*ppos, bvec->bv_len);
-	if (bw >= 0)
-		bw = -EIO;
-	return bw;
-}
-
-static int lo_write_simple(struct loop_device *lo, struct request *rq,
-		loff_t pos)
-{
-	struct bio_vec bvec;
-	struct req_iterator iter;
-	int ret = 0;
-
-	rq_for_each_segment(bvec, rq, iter) {
-		ret = lo_write_bvec(lo->lo_backing_file, &bvec, &pos);
-		if (ret < 0)
-			break;
-		cond_resched();
-	}
-
-	return ret;
-}
-
-static int lo_read_simple(struct loop_device *lo, struct request *rq,
-		loff_t pos)
-{
-	struct bio_vec bvec;
-	struct req_iterator iter;
-	struct iov_iter i;
-	ssize_t len;
-
-	rq_for_each_segment(bvec, rq, iter) {
-		iov_iter_bvec(&i, ITER_DEST, &bvec, 1, bvec.bv_len);
-		len = vfs_iter_read(lo->lo_backing_file, &i, &pos, 0);
-		if (len < 0)
-			return len;
-
-		flush_dcache_page(bvec.bv_page);
-
-		if (len != bvec.bv_len) {
-			struct bio *bio;
-
-			__rq_for_each_bio(bio, rq)
-				zero_fill_bio(bio);
-			break;
-		}
-		cond_resched();
-	}
-
-	return 0;
-}
-
 static void loop_clear_limits(struct loop_device *lo, int mode)
 {
 	struct queue_limits lim = queue_limits_start_update(lo->lo_queue);
@@ -366,7 +300,7 @@ static void lo_complete_rq(struct request *rq)
 	struct loop_cmd *cmd = blk_mq_rq_to_pdu(rq);
 	blk_status_t ret = BLK_STS_OK;
 
-	if (!cmd->use_aio || cmd->ret < 0 || cmd->ret == blk_rq_bytes(rq) ||
+	if (cmd->ret < 0 || cmd->ret == blk_rq_bytes(rq) ||
 	    req_op(rq) != REQ_OP_READ) {
 		if (cmd->ret < 0)
 			ret = errno_to_blk_status(cmd->ret);
@@ -382,14 +316,13 @@ static void lo_complete_rq(struct request *rq)
 		cmd->ret = 0;
 		blk_mq_requeue_request(rq, true);
 	} else {
-		if (cmd->use_aio) {
-			struct bio *bio = rq->bio;
+		struct bio *bio = rq->bio;
 
-			while (bio) {
-				zero_fill_bio(bio);
-				bio = bio->bi_next;
-			}
+		while (bio) {
+			zero_fill_bio(bio);
+			bio = bio->bi_next;
 		}
+
 		ret = BLK_STS_IOERR;
 end_io:
 		blk_mq_end_request(rq, ret);
@@ -469,9 +402,14 @@ static int lo_rw_aio(struct loop_device *lo, struct loop_cmd *cmd,
 
 	cmd->iocb.ki_pos = pos;
 	cmd->iocb.ki_filp = file;
-	cmd->iocb.ki_complete = lo_rw_aio_complete;
-	cmd->iocb.ki_flags = IOCB_DIRECT;
 	cmd->iocb.ki_ioprio = req_get_ioprio(rq);
+	if (cmd->use_aio) {
+		cmd->iocb.ki_complete = lo_rw_aio_complete;
+		cmd->iocb.ki_flags = IOCB_DIRECT;
+	} else {
+		cmd->iocb.ki_complete = NULL;
+		cmd->iocb.ki_flags = 0;
+	}
 
 	if (rw == ITER_SOURCE)
 		ret = file->f_op->write_iter(&cmd->iocb, &iter);
@@ -482,7 +420,7 @@ static int lo_rw_aio(struct loop_device *lo, struct loop_cmd *cmd,
 
 	if (ret != -EIOCBQUEUED)
 		lo_rw_aio_complete(&cmd->iocb, ret);
-	return 0;
+	return -EIOCBQUEUED;
 }
 
 static int do_req_filebacked(struct loop_device *lo, struct request *rq)
@@ -490,15 +428,6 @@ static int do_req_filebacked(struct loop_device *lo, struct request *rq)
 	struct loop_cmd *cmd = blk_mq_rq_to_pdu(rq);
 	loff_t pos = ((loff_t) blk_rq_pos(rq) << 9) + lo->lo_offset;
 
-	/*
-	 * lo_write_simple and lo_read_simple should have been covered
-	 * by io submit style function like lo_rw_aio(), one blocker
-	 * is that lo_read_simple() need to call flush_dcache_page after
-	 * the page is written from kernel, and it isn't easy to handle
-	 * this in io submit style function which submits all segments
-	 * of the req at one time. And direct read IO doesn't need to
-	 * run flush_dcache_page().
-	 */
 	switch (req_op(rq)) {
 	case REQ_OP_FLUSH:
 		return lo_req_flush(lo, rq);
@@ -514,15 +443,9 @@ static int do_req_filebacked(struct loop_device *lo, struct request *rq)
 	case REQ_OP_DISCARD:
 		return lo_fallocate(lo, rq, pos, FALLOC_FL_PUNCH_HOLE);
 	case REQ_OP_WRITE:
-		if (cmd->use_aio)
-			return lo_rw_aio(lo, cmd, pos, ITER_SOURCE);
-		else
-			return lo_write_simple(lo, rq, pos);
+		return lo_rw_aio(lo, cmd, pos, ITER_SOURCE);
 	case REQ_OP_READ:
-		if (cmd->use_aio)
-			return lo_rw_aio(lo, cmd, pos, ITER_DEST);
-		else
-			return lo_read_simple(lo, rq, pos);
+		return lo_rw_aio(lo, cmd, pos, ITER_DEST);
 	default:
 		WARN_ON_ONCE(1);
 		return -EIO;
@@ -1907,7 +1830,6 @@ static void loop_handle_cmd(struct loop_cmd *cmd)
 	struct loop_device *lo = rq->q->queuedata;
 	int ret = 0;
 	struct mem_cgroup *old_memcg = NULL;
-	const bool use_aio = cmd->use_aio;
 
 	if (write && (lo->lo_flags & LO_FLAGS_READ_ONLY)) {
 		ret = -EIO;
@@ -1937,7 +1859,7 @@ static void loop_handle_cmd(struct loop_cmd *cmd)
 	}
  failed:
 	/* complete non-aio request */
-	if (!use_aio || ret) {
+	if (ret != -EIOCBQUEUED) {
 		if (ret == -EOPNOTSUPP)
 			cmd->ret = ret;
 		else
-- 
2.39.5



