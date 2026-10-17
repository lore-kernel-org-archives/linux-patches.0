Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 216F2382F1E;
	Sat, 17 Oct 2026 16:09:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253398; cv=none; b=iNR81z+APSDnQKLG9nCwMRkpMMuon3WrRIyNBMNP3TsAsbOQ142MCSRVZ4wcZ8ensFw0xPOPSWgOdZyBv3Hk3B4WEAnz6ye37zDxpEvFIk5q89ZVqut0/wVj7BTqYBEW5tgharisdsxvS4kHB+mmWGUU/m2OonE1298VJnZWKbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253398; c=relaxed/simple;
	bh=4Ucppp31Vz1aBAqrT0O04kdzOnaIXD93MEPfAO5oMOk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f0qIZ7a+D0bVi4F7I7bPo0t0rhBfvAgUNcX4itySCyMBGUyEyD5fvFhOYKe8j0D86j1X5BzCzvVjIlGlpeIRDEuST+G6I9hLqegVjoVq557CztiLTGJ1XENOWhrqetsijLfumFhfAhRtB0c0oKf8d3pAmymtoL6+eK62BzmmC9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GOigTZt4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GOigTZt4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 775C61F000C4;
	Sat, 17 Oct 2026 16:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253397;
	bh=MtfWNdmOMPITF/tvzh64C4hcmKWlsh1p4RisbbWEVPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GOigTZt4xOeFTI+7gJ1QcYF8HwoHhbNYSrZ4bZqinBt3+kbSUaHqLw8ExAkTW527H
	 ET7xfi8SSQ8V6Z238fEc6NEZTH2YRRwK5ip+QVnxZudWO2XLxwJqSv5tf2YUPorv4i
	 zDJkNgjBy3UKTZAmBivplFQyGfViiUYVUF/Dw0Q4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jared Holzman <jholzman@nvidia.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 068/869] ublk: fix race between io_uring_cmd_complete_in_task and ublk_cancel_cmd
Date: Sat, 17 Oct 2026 17:48:29 +0200
Message-ID: <20261017160038.768266474@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/ublk_drv.c | 27 +++++++++++++++++++++------
 1 file changed, 21 insertions(+), 6 deletions(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index 6d5523058bed8..bd0b2046981e4 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -1552,14 +1552,31 @@ static bool ublk_abort_requests(struct ublk_device *ub, struct ublk_queue *ubq)
 	return !was_canceled;
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
@@ -1582,7 +1599,6 @@ static void ublk_uring_cmd_cancel_fn(struct io_uring_cmd *cmd,
 	struct task_struct *task;
 	struct ublk_device *ub;
 	bool need_schedule;
-	struct ublk_io *io;
 
 	if (WARN_ON_ONCE(!ubq))
 		return;
@@ -1597,9 +1613,8 @@ static void ublk_uring_cmd_cancel_fn(struct io_uring_cmd *cmd,
 	ub = ubq->dev;
 	need_schedule = ublk_abort_requests(ub, ubq);
 
-	io = &ubq->ios[pdu->tag];
-	WARN_ON_ONCE(io->cmd != cmd);
-	ublk_cancel_cmd(ubq, io, issue_flags);
+	WARN_ON_ONCE(ubq->ios[pdu->tag].cmd != cmd);
+	ublk_cancel_cmd(ubq, pdu->tag, issue_flags);
 
 	if (need_schedule) {
 		if (ublk_nosrv_should_stop_dev(ub))
@@ -1619,7 +1634,7 @@ static void ublk_cancel_queue(struct ublk_queue *ubq)
 	int i;
 
 	for (i = 0; i < ubq->q_depth; i++)
-		ublk_cancel_cmd(ubq, &ubq->ios[i], IO_URING_F_UNLOCKED);
+		ublk_cancel_cmd(ubq, i, IO_URING_F_UNLOCKED);
 }
 
 /* Cancel all pending commands, must be called after del_gendisk() returns */
-- 
2.53.0



