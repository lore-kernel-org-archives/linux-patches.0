Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75FAF4C10D1;
	Thu, 17 Sep 2026 15:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660355; cv=none; b=OusnIscovtt3/9BnjI6Q7chzVIPPId5B4vUDDM6PWBHRtSSQPYztE3KRiJKMpDDKzW7LhZEf8zv4DtN5ISRkTKBOniDOYl123ANmZ4c7+qQRRVludUQEDHt7qSlb1qMlheCrLraD6MoZvA9AfgVmAXhvOyus+tkWNiqLfrphKGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660355; c=relaxed/simple;
	bh=4+IR1nleLYCQv12+WVesYidWY6kWDiOP3mI715JqEgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CdtjEl+ExsDCM8HDqZ+X0Q5f1P4jRNQjLywg9jVPB7eslUzoJD+UxmA3+kWoogHoFViQhpGUI9WICtYGmykqRHGIlt0UCuFuZK+Aity6T5plUATQYgx9RPbYp0jxXVLYCmCQWDhi/sbiAydruWnXEerbCm0didSYkgshS1jv0GE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X+l1yA3c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X+l1yA3c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC1191F00893;
	Thu, 17 Sep 2026 15:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660354;
	bh=063cncR0rfzsTah+jDrwQx0s6D2fpIljfrcoxV0FUhk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X+l1yA3cUqplbC9gBW0du14s/yySImsbsZQ5DKw6tDnQNctu+7+zC/g0lavtZuBEl
	 /JMvu5jYJgqoiqEart423zz61xe40PMzu7Q2a2qJFU3VZLKh0TCM2V7Fwzay0CHYql
	 by+mFj9ZlM7WXkC4xQqGLQCBibz2zQy3SuGQ++ik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+2eb3d983669d3e49d4fa@syzkaller.appspotmail.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.2 537/733] io_uring/rw: end write accounting from ->ki_complete
Date: Thu, 17 Sep 2026 16:14:05 +0100
Message-ID: <20260917151405.600580189@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

commit 796aa0547557e63338657ed1c487906f9fac4c73 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/rw.c |   29 +++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)

--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -531,20 +531,25 @@ static void io_req_end_write(struct io_k
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
+}
+
+/* Finish write accounting and notify, for inline completions only. */
+static void io_req_io_end(struct io_kiocb *req)
+{
+	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
+
+	if (rw->kiocb.ki_flags & IOCB_WRITE)
+		io_req_end_write(req);
+	io_req_io_notify(req);
 }
 
 static void __io_complete_rw_common(struct io_kiocb *req, long res)
@@ -577,7 +582,7 @@ void io_req_rw_complete(struct io_tw_req
 {
 	struct io_kiocb *req = tw_req.req;
 
-	io_req_io_end(req);
+	io_req_io_notify(req);
 
 	if (req->flags & (REQ_F_BUFFER_SELECTED|REQ_F_BUFFER_RING))
 		req->cqe.flags |= io_put_kbuf(req, max(req->cqe.res, 0), NULL);
@@ -591,6 +596,10 @@ static void io_complete_rw(struct kiocb
 	struct io_rw *rw = container_of(kiocb, struct io_rw, kiocb);
 	struct io_kiocb *req = cmd_to_io_kiocb(rw);
 
+	/* ring owner may block in freeze_super() before task_work runs */
+	if (kiocb->ki_flags & IOCB_WRITE)
+		io_req_end_write(req);
+
 	__io_complete_rw_common(req, res);
 	io_req_set_res(req, io_fixup_rw_res(req, res), 0);
 	req->io_task_work.func = io_req_rw_complete;


