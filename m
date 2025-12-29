Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 364F62222CB;
	Mon, 29 Dec 2025 16:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025310; cv=none; b=rWg52AfbSEni+HF7SNbSuX/gc9fcDM6c8iDhKLh9fqvVqBrhweeoGraWuEAAOQhVzCN4F6h1RLm51/NUDApMvmCSh4aPdFhgQ1/pcqnNp7xMkLGV6s0iKW4J3rWj9QcRGg8NRWT6o36CyPj2j78JrBQVTWtwQEU1cPEk+ocACmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025310; c=relaxed/simple;
	bh=R3rXsuR3Z/31DrSwhQmJdpnvwz+nABNdxMdFoDPcc3g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o1C403+z6CJlb7X8p5agwjul+zskyyqh2z3g1nx5sK24G9fWNN5SLCjgrKGyoFZ4oCE/E8JuBTNxcII7yX7K6bmu0V/PML+sF9U1y4gFv4TUJm1MgH5FJiYBTyhD/HSP+k/tDJjgZvDeyEs7mGpnoyqhgJtvamvzF5vdhs2G41w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NaWF+FGv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NaWF+FGv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B37C1C4CEF7;
	Mon, 29 Dec 2025 16:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025310;
	bh=R3rXsuR3Z/31DrSwhQmJdpnvwz+nABNdxMdFoDPcc3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NaWF+FGv+XQYYp9EO94fooeOstKGEVZGyY/qHhTe202Y+c/a36AlrIDoWKaOkV7m+
	 Tj3qvD+nfNDsUAeT/iAvY4FnhU/cT/lcPg6xlsLWEtrgA+M6FiX1zQeprRvmfxll4j
	 tlgf9t3rVUBpiK/IJ4B1H34MTc3IPEn/epUj3O8Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Lei <ming.lei@redhat.com>,
	Caleb Sander Mateos <csander@purestorage.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 135/430] ublk: fix deadlock when reading partition table
Date: Mon, 29 Dec 2025 17:08:57 +0100
Message-ID: <20251229160729.332133836@linuxfoundation.org>
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

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit c258f5c4502c9667bccf5d76fa731ab9c96687c1 ]

When one process(such as udev) opens ublk block device (e.g., to read
the partition table via bdev_open()), a deadlock[1] can occur:

1. bdev_open() grabs disk->open_mutex
2. The process issues read I/O to ublk backend to read partition table
3. In __ublk_complete_rq(), blk_update_request() or blk_mq_end_request()
   runs bio->bi_end_io() callbacks
4. If this triggers fput() on file descriptor of ublk block device, the
   work may be deferred to current task's task work (see fput() implementation)
5. This eventually calls blkdev_release() from the same context
6. blkdev_release() tries to grab disk->open_mutex again
7. Deadlock: same task waiting for a mutex it already holds

The fix is to run blk_update_request() and blk_mq_end_request() with bottom
halves disabled. This forces blkdev_release() to run in kernel work-queue
context instead of current task work context, and allows ublk server to make
forward progress, and avoids the deadlock.

Fixes: 71f28f3136af ("ublk_drv: add io_uring based userspace block driver")
Link: https://github.com/ublk-org/ublksrv/issues/170 [1]
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Caleb Sander Mateos <csander@purestorage.com>
[axboe: rewrite comment in ublk]
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/ublk_drv.c | 32 ++++++++++++++++++++++++++++----
 1 file changed, 28 insertions(+), 4 deletions(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index bdb897d44089..fa7b0481ea04 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -1146,12 +1146,20 @@ static inline struct ublk_uring_cmd_pdu *ublk_get_uring_cmd_pdu(
 	return io_uring_cmd_to_pdu(ioucmd, struct ublk_uring_cmd_pdu);
 }
 
+static void ublk_end_request(struct request *req, blk_status_t error)
+{
+	local_bh_disable();
+	blk_mq_end_request(req, error);
+	local_bh_enable();
+}
+
 /* todo: handle partial completion */
 static inline void __ublk_complete_rq(struct request *req, struct ublk_io *io,
 				      bool need_map)
 {
 	unsigned int unmapped_bytes;
 	blk_status_t res = BLK_STS_OK;
+	bool requeue;
 
 	/* failed read IO if nothing is read */
 	if (!io->res && req_op(req) == REQ_OP_READ)
@@ -1183,14 +1191,30 @@ static inline void __ublk_complete_rq(struct request *req, struct ublk_io *io,
 	if (unlikely(unmapped_bytes < io->res))
 		io->res = unmapped_bytes;
 
-	if (blk_update_request(req, BLK_STS_OK, io->res))
+	/*
+	 * Run bio->bi_end_io() with softirqs disabled. If the final fput
+	 * happens off this path, then that will prevent ublk's blkdev_release()
+	 * from being called on current's task work, see fput() implementation.
+	 *
+	 * Otherwise, ublk server may not provide forward progress in case of
+	 * reading the partition table from bdev_open() with disk->open_mutex
+	 * held, and causes dead lock as we could already be holding
+	 * disk->open_mutex here.
+	 *
+	 * Preferably we would not be doing IO with a mutex held that is also
+	 * used for release, but this work-around will suffice for now.
+	 */
+	local_bh_disable();
+	requeue = blk_update_request(req, BLK_STS_OK, io->res);
+	local_bh_enable();
+	if (requeue)
 		blk_mq_requeue_request(req, true);
 	else if (likely(!blk_should_fake_timeout(req->q)))
 		__blk_mq_end_request(req, BLK_STS_OK);
 
 	return;
 exit:
-	blk_mq_end_request(req, res);
+	ublk_end_request(req, res);
 }
 
 static struct io_uring_cmd *__ublk_prep_compl_io_cmd(struct ublk_io *io,
@@ -1230,7 +1254,7 @@ static inline void __ublk_abort_rq(struct ublk_queue *ubq,
 	if (ublk_nosrv_dev_should_queue_io(ubq->dev))
 		blk_mq_requeue_request(rq, false);
 	else
-		blk_mq_end_request(rq, BLK_STS_IOERR);
+		ublk_end_request(rq, BLK_STS_IOERR);
 }
 
 static void
@@ -1275,7 +1299,7 @@ __ublk_do_auto_buf_reg(const struct ublk_queue *ubq, struct request *req,
 			ublk_auto_buf_reg_fallback(ubq, req->tag);
 			return AUTO_BUF_REG_FALLBACK;
 		}
-		blk_mq_end_request(req, BLK_STS_IOERR);
+		ublk_end_request(req, BLK_STS_IOERR);
 		return AUTO_BUF_REG_FAIL;
 	}
 
-- 
2.51.0



