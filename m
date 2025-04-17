Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E19C2550C2;
	Thu, 17 Apr 2025 18:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915076; cv=none; b=Hsbcwj0x0z5Q+tyv18Ylqgt+vL3PUxh69S0BlEdAePgsZQ2wsCb4VKTbOKJceN36N1BS61FI6q5lAx+gbFOcVKZ+XRnG474V63aXSHPNdRzFNDU35NbUA8KFgM/8+3PnkzyfoduS8JJTmxvfH/oiYo1it6ffDtDAMPOpX2vMpMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915076; c=relaxed/simple;
	bh=XsRMaTsUBAeIxgWOnT2y4Sacw9f992us87dMQx1FtQE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uh93SmxBEx4I+QBmWs2YWPyHoOtxVphJed4ESNIaZMD0Zq0gvUBhkUk5lC1oKce3OAtbGsUgiffH3lOkeDeBTpZlnL2kBwtJfkG+ouoQfyDpx2VmWevzvgFlvDJKcVvHeTT35fIpa6e0xqEdijLOIj+yqnr6/wvA/CbFi7Jc1Bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YXkSc1nv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YXkSc1nv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1F43C4CEE4;
	Thu, 17 Apr 2025 18:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915076;
	bh=XsRMaTsUBAeIxgWOnT2y4Sacw9f992us87dMQx1FtQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YXkSc1nv0Gx27/ZVLa1hcwfji3VqfbYcs+m9rh1jO2qiZuMN5l0WwVOF/0hIyeITk
	 6kNhIe2/xG5d+FMQ6xuI9WjV/GohcKWBkxCbgNnmWp+xEs/kb+kIPDAYHlsbvs/V4w
	 pa+Ip7yjKL6iMnPa3RAb8QEujbk/HT10whszp6OQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Caleb Sander Mateos <csander@purestorage.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 011/393] ublk: fix handling recovery & reissue in ublk_abort_queue()
Date: Thu, 17 Apr 2025 19:47:00 +0200
Message-ID: <20250417175108.032872142@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit 6ee6bd5d4fce502a5b5a2ea805e9ff16e6aa890f ]

Commit 8284066946e6 ("ublk: grab request reference when the request is handled
by userspace") doesn't grab request reference in case of recovery reissue.
Then the request can be requeued & re-dispatch & failed when canceling
uring command.

If it is one zc request, the request can be freed before io_uring
returns the zc buffer back, then cause kernel panic:

[  126.773061] BUG: kernel NULL pointer dereference, address: 00000000000000c8
[  126.773657] #PF: supervisor read access in kernel mode
[  126.774052] #PF: error_code(0x0000) - not-present page
[  126.774455] PGD 0 P4D 0
[  126.774698] Oops: Oops: 0000 [#1] SMP NOPTI
[  126.775034] CPU: 13 UID: 0 PID: 1612 Comm: kworker/u64:55 Not tainted 6.14.0_blk+ #182 PREEMPT(full)
[  126.775676] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-1.fc39 04/01/2014
[  126.776275] Workqueue: iou_exit io_ring_exit_work
[  126.776651] RIP: 0010:ublk_io_release+0x14/0x130 [ublk_drv]

Fixes it by always grabbing request reference for aborting the request.

Reported-by: Caleb Sander Mateos <csander@purestorage.com>
Closes: https://lore.kernel.org/linux-block/CADUfDZodKfOGUeWrnAxcZiLT+puaZX8jDHoj_sfHZCOZwhzz6A@mail.gmail.com/
Fixes: 8284066946e6 ("ublk: grab request reference when the request is handled by userspace")
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20250409011444.2142010-2-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/ublk_drv.c | 30 ++++++++++++++++++++++++++----
 1 file changed, 26 insertions(+), 4 deletions(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index dd328d40c7de5..38b9e485e520d 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -1081,6 +1081,25 @@ static void ublk_complete_rq(struct kref *ref)
 	__ublk_complete_rq(req);
 }
 
+static void ublk_do_fail_rq(struct request *req)
+{
+	struct ublk_queue *ubq = req->mq_hctx->driver_data;
+
+	if (ublk_nosrv_should_reissue_outstanding(ubq->dev))
+		blk_mq_requeue_request(req, false);
+	else
+		__ublk_complete_rq(req);
+}
+
+static void ublk_fail_rq_fn(struct kref *ref)
+{
+	struct ublk_rq_data *data = container_of(ref, struct ublk_rq_data,
+			ref);
+	struct request *req = blk_mq_rq_from_pdu(data);
+
+	ublk_do_fail_rq(req);
+}
+
 /*
  * Since __ublk_rq_task_work always fails requests immediately during
  * exiting, __ublk_fail_req() is only called from abort context during
@@ -1094,10 +1113,13 @@ static void __ublk_fail_req(struct ublk_queue *ubq, struct ublk_io *io,
 {
 	WARN_ON_ONCE(io->flags & UBLK_IO_FLAG_ACTIVE);
 
-	if (ublk_nosrv_should_reissue_outstanding(ubq->dev))
-		blk_mq_requeue_request(req, false);
-	else
-		ublk_put_req_ref(ubq, req);
+	if (ublk_need_req_ref(ubq)) {
+		struct ublk_rq_data *data = blk_mq_rq_to_pdu(req);
+
+		kref_put(&data->ref, ublk_fail_rq_fn);
+	} else {
+		ublk_do_fail_rq(req);
+	}
 }
 
 static void ubq_complete_io_cmd(struct ublk_io *io, int res,
-- 
2.39.5



