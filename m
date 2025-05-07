Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B09501482F5;
	Wed,  7 May 2025 18:57:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644226; cv=none; b=sSy1UrDaxIToTeBIgdM4VBiAeUdq5pG54X8zA1L5MIXeh+2VrUYZaWtJ7SSV6HrWTQMyL+VqsVgIdbhY4wauZAzz3O1uIeJQBaySZCsuDMfn0zq89saAR1ad0rJmNMDiRtrSWm3kRp69H1+HY/4EmpzmpVf+p/IEkgxHcdWHkxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644226; c=relaxed/simple;
	bh=Z27d1yylSn+tfjrPkKOAofiF0bQpC6jWHaDAxZrVhQ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XKaKiHOExbHGTxcdHTXNtDvvW1JWtGyMVV/nJhBegPAeDZk+FsYt0WyDn0PrPv59vp075D1ZtIuFi1NSEYP+y0CrijhPG43U8JaaIXvjEnGMMujpY/yrfyI6R2IOfc2xRr09ANseIsvRzDP+Pt3r/7wY2NnsZZKz+s+txuML+gY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QnsJC0Dc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QnsJC0Dc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20A19C4CEE2;
	Wed,  7 May 2025 18:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644226;
	bh=Z27d1yylSn+tfjrPkKOAofiF0bQpC6jWHaDAxZrVhQ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QnsJC0DcIIt6UOlZH+5St8mIuv/sAte3EYs3dJtlAUb9N9hl8lHA/j6rtds1A51Za
	 Nha+lOd5g7HJGo61lOJeNW9taytYqrWNrvhnM+ERd9g7FgycHj0Dvsdf4b2esBY4Oc
	 0198Axh0GTbAJ/xAWXxm7zrGPwnngB0BTMpWU3yU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jared Holzman <jholzman@nvidia.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.14 160/183] ublk: fix race between io_uring_cmd_complete_in_task and ublk_cancel_cmd
Date: Wed,  7 May 2025 20:40:05 +0200
Message-ID: <20250507183831.348839901@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183824.682671926@linuxfoundation.org>
References: <20250507183824.682671926@linuxfoundation.org>
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

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit f40139fde5278d81af3227444fd6e76a76b9506d ]

ublk_cancel_cmd() calls io_uring_cmd_done() to complete uring_cmd, but
we may have scheduled task work via io_uring_cmd_complete_in_task() for
dispatching request, then kernel crash can be triggered.

Fix it by not trying to canceling the command if ublk block request is
started.

Fixes: 216c8f5ef0f2 ("ublk: replace monitor with cancelable uring_cmd")
Reported-by: Jared Holzman <jholzman@nvidia.com>
Tested-by: Jared Holzman <jholzman@nvidia.com>
Closes: https://lore.kernel.org/linux-block/d2179120-171b-47ba-b664-23242981ef19@nvidia.com/
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20250425013742.1079549-3-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/ublk_drv.c |   27 +++++++++++++++++++++------
 1 file changed, 21 insertions(+), 6 deletions(-)

--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -1655,14 +1655,31 @@ static void ublk_start_cancel(struct ubl
 	ublk_put_disk(disk);
 }
 
-static void ublk_cancel_cmd(struct ublk_queue *ubq, struct ublk_io *io,
+static void ublk_cancel_cmd(struct ublk_queue *ubq, unsigned tag,
 		unsigned int issue_flags)
 {
+	struct ublk_io *io = &ubq->ios[tag];
+	struct ublk_device *ub = ubq->dev;
+	struct request *req;
 	bool done;
 
 	if (!(io->flags & UBLK_IO_FLAG_ACTIVE))
 		return;
 
+	/*
+	 * Don't try to cancel this command if the request is started for
+	 * avoiding race between io_uring_cmd_done() and
+	 * io_uring_cmd_complete_in_task().
+	 *
+	 * Either the started request will be aborted via __ublk_abort_rq(),
+	 * then this uring_cmd is canceled next time, or it will be done in
+	 * task work function ublk_dispatch_req() because io_uring guarantees
+	 * that ublk_dispatch_req() is always called
+	 */
+	req = blk_mq_tag_to_rq(ub->tag_set.tags[ubq->q_id], tag);
+	if (req && blk_mq_request_started(req))
+		return;
+
 	spin_lock(&ubq->cancel_lock);
 	done = !!(io->flags & UBLK_IO_FLAG_CANCELED);
 	if (!done)
@@ -1694,7 +1711,6 @@ static void ublk_uring_cmd_cancel_fn(str
 	struct ublk_uring_cmd_pdu *pdu = ublk_get_uring_cmd_pdu(cmd);
 	struct ublk_queue *ubq = pdu->ubq;
 	struct task_struct *task;
-	struct ublk_io *io;
 
 	if (WARN_ON_ONCE(!ubq))
 		return;
@@ -1709,9 +1725,8 @@ static void ublk_uring_cmd_cancel_fn(str
 	if (!ubq->canceling)
 		ublk_start_cancel(ubq);
 
-	io = &ubq->ios[pdu->tag];
-	WARN_ON_ONCE(io->cmd != cmd);
-	ublk_cancel_cmd(ubq, io, issue_flags);
+	WARN_ON_ONCE(ubq->ios[pdu->tag].cmd != cmd);
+	ublk_cancel_cmd(ubq, pdu->tag, issue_flags);
 }
 
 static inline bool ublk_queue_ready(struct ublk_queue *ubq)
@@ -1724,7 +1739,7 @@ static void ublk_cancel_queue(struct ubl
 	int i;
 
 	for (i = 0; i < ubq->q_depth; i++)
-		ublk_cancel_cmd(ubq, &ubq->ios[i], IO_URING_F_UNLOCKED);
+		ublk_cancel_cmd(ubq, i, IO_URING_F_UNLOCKED);
 }
 
 /* Cancel all pending commands, must be called after del_gendisk() returns */


