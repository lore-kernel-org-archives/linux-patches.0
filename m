Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1A593A3E90;
	Wed, 20 May 2026 16:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294375; cv=none; b=tdnQPp9aG3nL/a8D2vr/B6YXwYiyVlVAtuG8XrbtQ8EpGxhNbmtLF4I/wu7Fwmxp02tdkPS1U51C1dZcb7YsxPKr9US4lUDJHgUCxLfyD3uq1eydTHbSJQCGIo0D1I8AkkbxGZ9Xb/9l8aSKOySfqEeInHUSIxJQ8EnLASnjnMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294375; c=relaxed/simple;
	bh=kRmpE5eIcUhtCAZ5V/1hZ7Y2yQxepfEuAfu6Bm4ysWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kezGWSzjZus4ZOr8dXD4ueiFBctg7nz13a+JGFVSgTPnFLB/XnFRcttM225+o5DMSoQYMGa0RH+jdF+linL9cSPGfrsmpKVFQM3gNQAUGvGnnRwZ9mA+WMbZXLsZdXrHbk1SxlNRwu28llJr1pp1bMjyaqbg541HOm28ziYN43s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rME8Bj/9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rME8Bj/9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 594601F00893;
	Wed, 20 May 2026 16:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294373;
	bh=09A6KdfA2D6TwdIJypEFJ5ChzE3fEGMQsu0caCq7BUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rME8Bj/9PZcNM/nMVtuZMMn9c73XevGOPhw25jkAMIrUoBviUl9zu+R6L+4uuXPVL
	 5kTW4FXnBu/NnF3XAA3ToHL0te1ZrH4IcuiuiXARWItCglQK75OwXlF0Ziuyg2t1gk
	 C7C3TvYbDr7yHFyR8gB20HJ8GVk5kRap7EkwemwY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Uday Shankar <ushankar@purestorage.com>,
	Ming Lei <ming.lei@redhat.com>,
	"zhang, the-essence-of-life" <zhangweize9@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0016/1146] ublk: reset per-IO canceled flag on each fetch
Date: Wed, 20 May 2026 18:04:26 +0200
Message-ID: <20260520162148.756883867@linuxfoundation.org>
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

From: Uday Shankar <ushankar@purestorage.com>

[ Upstream commit 0842186d2c4e67d2f8c8c2d1d779e8acffd41b5b ]

If a ublk server starts recovering devices but dies before issuing fetch
commands for all IOs, cancellation of the fetch commands that were
successfully issued may never complete. This is because the per-IO
canceled flag can remain set even after the fetch for that IO has been
submitted - the per-IO canceled flags for all IOs in a queue are reset
together only once all IOs for that queue have been fetched. So if a
nonempty proper subset of the IOs for a queue are fetched when the ublk
server dies, the IOs in that subset will never successfully be canceled,
as their canceled flags remain set, and this prevents ublk_cancel_cmd
from actually calling io_uring_cmd_done on the commands, despite the
fact that they are outstanding.

Fix this by resetting the per-IO cancel flags immediately when each IO
is fetched instead of waiting for all IOs for the queue (which may never
happen).

Signed-off-by: Uday Shankar <ushankar@purestorage.com>
Fixes: 728cbac5fe21 ("ublk: move device reset into ublk_ch_release()")
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: zhang, the-essence-of-life <zhangweize9@gmail.com>
Link: https://patch.msgid.link/20260405-cancel-v2-1-02d711e643c2@purestorage.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/ublk_drv.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index 63aeb7a76a8c9..0bdb804fca839 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -2910,22 +2910,26 @@ static void ublk_stop_dev(struct ublk_device *ub)
 	ublk_cancel_dev(ub);
 }
 
+static void ublk_reset_io_flags(struct ublk_queue *ubq, struct ublk_io *io)
+{
+	/* UBLK_IO_FLAG_CANCELED can be cleared now */
+	spin_lock(&ubq->cancel_lock);
+	io->flags &= ~UBLK_IO_FLAG_CANCELED;
+	spin_unlock(&ubq->cancel_lock);
+}
+
 /* reset per-queue io flags */
 static void ublk_queue_reset_io_flags(struct ublk_queue *ubq)
 {
-	int j;
-
-	/* UBLK_IO_FLAG_CANCELED can be cleared now */
 	spin_lock(&ubq->cancel_lock);
-	for (j = 0; j < ubq->q_depth; j++)
-		ubq->ios[j].flags &= ~UBLK_IO_FLAG_CANCELED;
 	ubq->canceling = false;
 	spin_unlock(&ubq->cancel_lock);
 	ubq->fail_io = false;
 }
 
 /* device can only be started after all IOs are ready */
-static void ublk_mark_io_ready(struct ublk_device *ub, u16 q_id)
+static void ublk_mark_io_ready(struct ublk_device *ub, u16 q_id,
+	struct ublk_io *io)
 	__must_hold(&ub->mutex)
 {
 	struct ublk_queue *ubq = ublk_get_queue(ub, q_id);
@@ -2934,6 +2938,7 @@ static void ublk_mark_io_ready(struct ublk_device *ub, u16 q_id)
 		ub->unprivileged_daemons = true;
 
 	ubq->nr_io_ready++;
+	ublk_reset_io_flags(ubq, io);
 
 	/* Check if this specific queue is now fully ready */
 	if (ublk_queue_ready(ubq)) {
@@ -3196,7 +3201,7 @@ static int ublk_fetch(struct io_uring_cmd *cmd, struct ublk_device *ub,
 	if (!ret)
 		ret = ublk_config_io_buf(ub, io, cmd, buf_addr, NULL);
 	if (!ret)
-		ublk_mark_io_ready(ub, q_id);
+		ublk_mark_io_ready(ub, q_id, io);
 	mutex_unlock(&ub->mutex);
 	return ret;
 }
@@ -3604,7 +3609,7 @@ static int ublk_batch_prep_io(struct ublk_queue *ubq,
 	ublk_io_unlock(io);
 
 	if (!ret)
-		ublk_mark_io_ready(data->ub, ubq->q_id);
+		ublk_mark_io_ready(data->ub, ubq->q_id, io);
 
 	return ret;
 }
-- 
2.53.0



