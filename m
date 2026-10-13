Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E75E50254F;
	Tue, 13 Oct 2026 12:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893414; cv=none; b=m74VrNWJqsJoI2T0mLXDCjPwUHsEAX8Se0QKvHLbVj0QnrJXRcksIWc5yfrQbst1j0SLyC9JBZCepVogVDYqmpzwHXZboDzPf//US8ejV3ocEO089wFrWov+3+Ub2LWmbyioB79Pl8YI/IV91jjJDwSAvVJXlgvahia6Mt031yU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893414; c=relaxed/simple;
	bh=tYLismnAIzQ6O6AAAJyTQh8VEFVgo9AJjr5ZQtNguTo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eGJVQ2Hx6ApFVI4YAk5TpaUjk25qPbGd/RtqAeDNBG3hgF8ka/g7SXcoSGipQ7v5JOJoX+L6Ozh4w88GU9QjSGNIzlLQGmUPYEzaIffHTFdFIjXIiBoAjuGZoqaRLWap3Yf/RpxWNObo111rb/YudHV5TgGAZkRQJ8ZKFn+QrhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MTvf9o+L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MTvf9o+L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80A781F00899;
	Tue, 13 Oct 2026 12:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893412;
	bh=eFiS8Hw1hXK5DdGAVzFQprYHWy0ux981MqqXiYm6CCg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MTvf9o+L589A9cSjwTHzWXGRl8ATSaCxRUBXbl5TOLDpWTfgiI4g/WLulJ+L6sD7g
	 UmtaOwNDHZjypsdVtc8CFWKz0QnF/textwbhSf4DCqabFYbbJuwt0W4LN0HYFKibKM
	 KHvJzyj2lNryKOsExJJyF31JYzNiymXMJkJ7GLkU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Uday Shankar <ushankar@purestorage.com>,
	Ming Lei <ming.lei@redhat.com>,
	"zhang, the-essence-of-life" <zhangweize9@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 218/621] ublk: reset per-IO canceled flag on each fetch
Date: Tue, 13 Oct 2026 13:33:33 +0200
Message-ID: <20261013112926.034474545@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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
 drivers/block/ublk_drv.c | 28 +++++++++++++---------------
 1 file changed, 13 insertions(+), 15 deletions(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index a11805b29b630..d1959b4445710 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -2141,30 +2141,28 @@ static void ublk_stop_dev(struct ublk_device *ub)
 /* reset ublk io_uring queue & io flags */
 static void ublk_reset_io_flags(struct ublk_device *ub)
 {
-	int i, j;
-
-	for (i = 0; i < ub->dev_info.nr_hw_queues; i++) {
-		struct ublk_queue *ubq = ublk_get_queue(ub, i);
+	int i;
 
-		/* UBLK_IO_FLAG_CANCELED can be cleared now */
-		spin_lock(&ubq->cancel_lock);
-		for (j = 0; j < ubq->q_depth; j++)
-			ubq->ios[j].flags &= ~UBLK_IO_FLAG_CANCELED;
-		spin_unlock(&ubq->cancel_lock);
-		ubq->fail_io = false;
-	}
+	for (i = 0; i < ub->dev_info.nr_hw_queues; i++)
+		ublk_get_queue(ub, i)->fail_io = false;
 	mutex_lock(&ub->cancel_mutex);
 	ublk_set_canceling(ub, false);
 	mutex_unlock(&ub->cancel_mutex);
 }
 
 /* device can only be started after all IOs are ready */
-static void ublk_mark_io_ready(struct ublk_device *ub)
+static void ublk_mark_io_ready(struct ublk_device *ub, struct ublk_queue *ubq,
+			       struct ublk_io *io)
 	__must_hold(&ub->mutex)
 {
 	if (!ub->unprivileged_daemons && !capable(CAP_SYS_ADMIN))
 		ub->unprivileged_daemons = true;
 
+	/* UBLK_IO_FLAG_CANCELED can be cleared now */
+	spin_lock(&ubq->cancel_lock);
+	io->flags &= ~UBLK_IO_FLAG_CANCELED;
+	spin_unlock(&ubq->cancel_lock);
+
 	ub->nr_io_ready++;
 	if (ublk_dev_ready(ub)) {
 		/*
@@ -2370,7 +2368,7 @@ static int ublk_check_fetch_buf(const struct ublk_device *ub, __u64 buf_addr)
 }
 
 static int ublk_fetch(struct io_uring_cmd *cmd, struct ublk_device *ub,
-		      struct ublk_io *io, __u64 buf_addr)
+		      struct ublk_queue *ubq, struct ublk_io *io, __u64 buf_addr)
 {
 	int ret = 0;
 
@@ -2400,7 +2398,7 @@ static int ublk_fetch(struct io_uring_cmd *cmd, struct ublk_device *ub,
 		goto out;
 
 	WRITE_ONCE(io->task, get_task_struct(current));
-	ublk_mark_io_ready(ub);
+	ublk_mark_io_ready(ub, ubq, io);
 out:
 	mutex_unlock(&ub->mutex);
 	return ret;
@@ -2505,7 +2503,7 @@ static int ublk_ch_uring_cmd_local(struct io_uring_cmd *cmd,
 		ret = ublk_check_fetch_buf(ub, addr);
 		if (ret)
 			goto out;
-		ret = ublk_fetch(cmd, ub, io, addr);
+		ret = ublk_fetch(cmd, ub, ubq, io, addr);
 		if (ret)
 			goto out;
 
-- 
2.53.0



