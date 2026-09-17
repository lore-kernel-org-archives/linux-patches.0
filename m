Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F07665187FE;
	Thu, 17 Sep 2026 17:43:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667010; cv=none; b=kOQTFiwdPeATiUvNORJknbiOCS+74xy6UCKaZJESwYQbTelTqmAWa0OE2qdPkuFWKC0+EGbLgEYlNBv/PvNSs38eCtuJ0CiOjWjX2xe0wPY8WAKrcWumZUD3tu3/NqXwxwnczHUgZWhcXp1AlOoHCF6ZLuZ7B/sNER8rUbs1rpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667010; c=relaxed/simple;
	bh=gHVdO2nio2DevnutYQy0J7HuycXucqGdosqaWIsVSWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mGkEEsvcR6l788Q9L22mph5fG0SC5Iju+XpivM3lrQIM9h8OeJF3ZtQfpDTOiyWJI8MV5Bt6ECGa/8jJIrNDUPAlXe9KkSkKJlrMmusjS8pT5cidjwJax76XY4c7sqZZj3F+nG6u6tzF69HQBdgYza0YPCKO/dg4DavmdcMqdI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vstqg1Co; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vstqg1Co"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4384C1F000FF;
	Thu, 17 Sep 2026 17:43:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667008;
	bh=gOyidrX2zvZtXgtmsADwMdsmMtjkmWnJsa6PYSoEWMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vstqg1CoQ48tnFkmUvMavKfNzqqxJ+KhhyvIOSr2Pp4FSI4gyZnANkjhmxLZHRX9t
	 F4nEUixCdJyUI7l0A0nzjms3i0TrpBOMYeB66aLUZFWDcrniJkdoltV/nNuHV4QcfY
	 3fiT9wxLF0SZkar37/nLQKj+n+c+L0hBZFxlrpcM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+2eb3d983669d3e49d4fa@syzkaller.appspotmail.com,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1199/1250] io_uring/rw: end write accounting from ->ki_complete
Date: Thu, 17 Sep 2026 16:16:34 +0100
Message-ID: <20260917151624.782039149@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
[ adjusted io_complete_rw() context to preserve the existing IOCB_DIO_CALLER_COMP guard ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/rw.c |   25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -532,20 +532,15 @@ static void io_req_end_write(struct io_k
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
 
 static void __io_complete_rw_common(struct io_kiocb *req, long res)
@@ -586,7 +581,7 @@ void io_req_rw_complete(struct io_tw_req
 		io_req_set_res(req, io_fixup_rw_res(req, res), 0);
 	}
 
-	io_req_io_end(req);
+	io_req_io_notify(req);
 
 	if (req->flags & (REQ_F_BUFFER_SELECTED|REQ_F_BUFFER_RING))
 		req->cqe.flags |= io_put_kbuf(req, req->cqe.res, NULL);
@@ -600,6 +595,10 @@ static void io_complete_rw(struct kiocb
 	struct io_rw *rw = container_of(kiocb, struct io_rw, kiocb);
 	struct io_kiocb *req = cmd_to_io_kiocb(rw);
 
+	/* ring owner may block in freeze_super() before task_work runs */
+	if (kiocb->ki_flags & IOCB_WRITE)
+		io_req_end_write(req);
+
 	if (!kiocb->dio_complete || !(kiocb->ki_flags & IOCB_DIO_CALLER_COMP)) {
 		__io_complete_rw_common(req, res);
 		io_req_set_res(req, io_fixup_rw_res(req, res), 0);
@@ -675,10 +674,12 @@ static int kiocb_done(struct io_kiocb *r
 
 		__io_complete_rw_common(req, ret);
 		/*
-		 * Safe to call io_end from here as we're inline
+		 * Safe to notify from here as we're inline
 		 * from the submission path.
 		 */
-		io_req_io_end(req);
+		if (rw->kiocb.ki_flags & IOCB_WRITE)
+			io_req_end_write(req);
+		io_req_io_notify(req);
 		if (sel)
 			cflags = io_put_kbuf(req, ret, sel->buf_list);
 		io_req_set_res(req, final_ret, cflags);


