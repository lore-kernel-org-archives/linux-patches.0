Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4DE0396D28;
	Sat, 17 Oct 2026 16:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255829; cv=none; b=JoSV2tdby68Qwx/7/PfwvgkPXHfQhgPF2kC83eYKf9mp3v4HZT1qPgLsB9Zn0emzW8imZ+twUaY4VXykrfI9QLEpqFp8q1Ml7XQqooB6uhOlUT4rp/6tIV9mRrg8KGt+vDujm/jxelDe7c7xJ23C7NRW9xqzsnJ5BLcw4ZK+nDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255829; c=relaxed/simple;
	bh=h2RyZBh9M559UbtkDny1EQA7tbtUMeiGOGJ0vh0lWro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=D2HxBoX0E+tPXD8ujOATu9Y7FCQ1ry3cueVONO3TaTttPnNdVfQYsZ+RB5GGfsnhbjGfj04zFHVzkBRetfesOLwFJZ2w8ygmcanqnG+ui5X0LmuQu0pTMcWFoyRZYFK1UZZFgDkI7sKCp0GKtiWLcBYl+xNxrXPqQOdoBus8O+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HLvPRqof; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HLvPRqof"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ACBC1F000C4;
	Sat, 17 Oct 2026 16:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255828;
	bh=24Y+bQNqXV9b8cdBtB4Ltpq8hI9Ux5YGIe9VPJjFOeU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HLvPRqofL2/WlbIDT+tthbdm7cm4IAXpWpreHtaX5ChNRdJtBBMIgODZVUfAvwysm
	 mbs6OoUo2Rr8yktACt7SburKHlyqm0dG9Y/S4xlMGbP8sbqMSt5LhjsNCRY+04amPW
	 zQFpq2TYSqBiSfWEfImUd3yeVspINLbhps/PqZ4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+2eb3d983669d3e49d4fa@syzkaller.appspotmail.com,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0036/1674] io_uring/rw: end write accounting from ->ki_complete
Date: Sat, 17 Oct 2026 17:38:28 +0200
Message-ID: <20261017160432.065266654@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
[ adapted completion cleanup to Linux 6.6’s existing direct-I/O and retry handling. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/rw.c | 32 +++++++++++++++-----------------
 1 file changed, 15 insertions(+), 17 deletions(-)

diff --git a/io_uring/rw.c b/io_uring/rw.c
index f2ab967b95072..9c3932302cab9 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -244,20 +244,15 @@ static void io_req_end_write(struct io_kiocb *req)
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
@@ -265,11 +260,8 @@ static bool __io_complete_rw_common(struct io_kiocb *req, long res)
 	if (unlikely(res != req->cqe.res)) {
 		if ((res == -EAGAIN || res == -EOPNOTSUPP) &&
 		    io_rw_should_reissue(req)) {
-			/*
-			 * Reissue will start accounting again, finish the
-			 * current cycle.
-			 */
-			io_req_io_end(req);
+			/* Notify for the current cycle before reissuing. */
+			io_req_io_notify(req);
 			req->flags |= REQ_F_REISSUE | REQ_F_PARTIAL_IO;
 			return true;
 		}
@@ -304,7 +296,7 @@ void io_req_rw_complete(struct io_kiocb *req, struct io_tw_state *ts)
 		io_req_set_res(req, io_fixup_rw_res(req, res), 0);
 	}
 
-	io_req_io_end(req);
+	io_req_io_notify(req);
 
 	if (req->flags & (REQ_F_BUFFER_SELECTED|REQ_F_BUFFER_RING)) {
 		unsigned issue_flags = ts->locked ? 0 : IO_URING_F_UNLOCKED;
@@ -319,6 +311,10 @@ static void io_complete_rw(struct kiocb *kiocb, long res)
 	struct io_rw *rw = container_of(kiocb, struct io_rw, kiocb);
 	struct io_kiocb *req = cmd_to_io_kiocb(rw);
 
+	/* ring owner may block in freeze_super() before task_work runs */
+	if (kiocb->ki_flags & IOCB_WRITE)
+		io_req_end_write(req);
+
 	if (!kiocb->dio_complete || !(kiocb->ki_flags & IOCB_DIO_CALLER_COMP)) {
 		if (__io_complete_rw_common(req, res))
 			return;
@@ -358,10 +354,12 @@ static int kiocb_done(struct io_kiocb *req, ssize_t ret,
 	if (ret >= 0 && (rw->kiocb.ki_complete == io_complete_rw)) {
 		if (!__io_complete_rw_common(req, ret)) {
 			/*
-			 * Safe to call io_end from here as we're inline
+			 * Safe to notify from here as we're inline
 			 * from the submission path.
 			 */
-			io_req_io_end(req);
+			if (rw->kiocb.ki_flags & IOCB_WRITE)
+				io_req_end_write(req);
+			io_req_io_notify(req);
 			io_req_set_res(req, final_ret,
 				       io_put_kbuf(req, issue_flags));
 			return IOU_OK;
-- 
2.53.0



