Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D422551C348;
	Wed, 30 Sep 2026 17:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790166; cv=none; b=ge6xzNJOXD+Vg1QS9kuMDuRYFQbAQNcvCxaR/Ukeg6/ViSXveia6j/elbstfwnCk2NgmKdgId8DXdJBEvDPDOVjHI2d3eYeb1g/Llw+xhvm4jXSagl4+oiACcGHF2y4Ac5QqL+DodIs+rMTsMVoXaBfkBwvT2A2b9HHgylc3EW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790166; c=relaxed/simple;
	bh=RmOukN3F2secX38Mgb23BHUTSJReBIrYmMtEEbBWQZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iU6O7LgUL8oQ1Rt9qAL+SfuSFGexStECF0qzQBHfYb4UjwtFnxobGi76x1OfWvBmM/6bYAPN9Y88kFB3JO3dIC1B1AEyZlvJ0glTcgjr3EyK/y1A/H427uz9E6RRJOa0dngwA8aaYqZM5BBpFKjrA/oMY3oWUtqVpPxrIdsGyzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u857zzDl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u857zzDl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39A811F000FF;
	Wed, 30 Sep 2026 17:42:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790164;
	bh=P575HQlhrMahnyDzN7pvKv9Jplm93EckTAA/f9fa2ag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u857zzDlQGNWKTF4bPCQ8GZbItGscsUC9YWFxHhhBiYPLmaKzPHKS6gVhkaMGRrGh
	 NrZ3oEz/yivFL458RI2Vg8UM9VU58+5fWo11IlVN6sobgzXXaiaAx71vvwSNP1+PkU
	 +ryNqR8BMSFsCIfzqmHdfQp34C7QPjMeUlLcvzdI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+2eb3d983669d3e49d4fa@syzkaller.appspotmail.com,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 731/877] io_uring/rw: end write accounting from ->ki_complete
Date: Wed, 30 Sep 2026 17:27:22 +0200
Message-ID: <20260930152430.461586350@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 796aa0547557e63338657ed1c487906f9fac4c73 ]

Commit b000145e9907 moved both the fsnotify calls and the write
accounting out of the kiocb completion handler and into the
io_req_rw_complete() task_work. However, only the fsnotify part actually
needed to move as it may sleep. Ending the write accounting is just a
percpu_up_read() on the superblock writers sem.

Deferring it is a problem, because it makes dropping SB_FREEZE_WRITE
protection depend on the ring owner getting to running task_work. But
the task may be blocked in freeze_super(), causing it to never get to
that:

  task                             io-wq worker
  --------------------------------------------------------------
  io_write()
    io_kiocb_start_write()         (takes sb_writers, hidden from
                                    lockdep by __sb_writers_release)
    write_iter() -> -EIOCBQUEUED
  ioctl(FS_IOC_SHUTDOWN)
    bdev_freeze()
      freeze_super()
        percpu_down_write()        <- waits for the reader above
                                   io_write()
                                     kiocb_start_write()
                                       percpu_down_read()  <- queued
                                                              behind the
                                                              writer
  <bio completes>
    io_complete_rw()
      queues io_req_rw_complete()  <- never runs, task is in D state

End the write from io_complete_rw() instead, and leave only the fsnotify
calls in task_work.

Reported-by: syzbot+2eb3d983669d3e49d4fa@syzkaller.appspotmail.com
Cc: stable@vger.kernel.org
Fixes: b000145e9907 ("io_uring/rw: defer fsnotify calls to task context")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[ adapted accounting cleanup to the older completion helper’s retry early return. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/rw.c |   32 +++++++++++++++-----------------
 1 file changed, 15 insertions(+), 17 deletions(-)

--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -460,31 +460,23 @@ static void io_req_end_write(struct io_k
 	}
 }
 
-/*
- * Trigger the notifications after having done some IO, and finish the write
- * accounting, if any.
- */
-static void io_req_io_end(struct io_kiocb *req)
+/* Trigger the notifications after having done some IO. */
+static void io_req_io_notify(struct io_kiocb *req)
 {
 	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
 
-	if (rw->kiocb.ki_flags & IOCB_WRITE) {
-		io_req_end_write(req);
+	if (rw->kiocb.ki_flags & IOCB_WRITE)
 		fsnotify_modify(req->file);
-	} else {
+	else
 		fsnotify_access(req->file);
-	}
 }
 
 static bool __io_complete_rw_common(struct io_kiocb *req, long res)
 {
 	if (unlikely(res != req->cqe.res)) {
 		if ((res == -EOPNOTSUPP || res == -EAGAIN) && io_rw_should_reissue(req)) {
-			/*
-			 * Reissue will start accounting again, finish the
-			 * current cycle.
-			 */
-			io_req_io_end(req);
+			/* Reissue bypasses task_work, so notify here. */
+			io_req_io_notify(req);
 			req->flags |= REQ_F_REISSUE | REQ_F_BL_NO_RECYCLE;
 			return true;
 		}
@@ -519,7 +511,7 @@ void io_req_rw_complete(struct io_kiocb
 		io_req_set_res(req, io_fixup_rw_res(req, res), 0);
 	}
 
-	io_req_io_end(req);
+	io_req_io_notify(req);
 
 	if (req->flags & (REQ_F_BUFFER_SELECTED|REQ_F_BUFFER_RING))
 		req->cqe.flags |= io_put_kbuf(req, req->cqe.res, NULL);
@@ -533,6 +525,10 @@ static void io_complete_rw(struct kiocb
 	struct io_rw *rw = container_of(kiocb, struct io_rw, kiocb);
 	struct io_kiocb *req = cmd_to_io_kiocb(rw);
 
+	/* ring owner may block in freeze_super() before task_work runs */
+	if (kiocb->ki_flags & IOCB_WRITE)
+		io_req_end_write(req);
+
 	if (!kiocb->dio_complete || !(kiocb->ki_flags & IOCB_DIO_CALLER_COMP)) {
 		if (__io_complete_rw_common(req, res))
 			return;
@@ -604,11 +600,13 @@ static int kiocb_done(struct io_kiocb *r
 		if (!__io_complete_rw_common(req, ret)) {
 			u32 cflags = 0;
 
+			if (rw->kiocb.ki_flags & IOCB_WRITE)
+				io_req_end_write(req);
 			/*
-			 * Safe to call io_end from here as we're inline
+			 * Safe to notify from here as we're inline
 			 * from the submission path.
 			 */
-			io_req_io_end(req);
+			io_req_io_notify(req);
 			if (sel)
 				cflags = io_put_kbuf(req, ret, sel->buf_list);
 			io_req_set_res(req, final_ret, cflags);


