Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208189;
	b=GSbUxrfXUHb4m8niJQyO0vljur02OXSTlaPWvrHcI973AruI9y+GJ2E5Hv+Gk145n+fh
	 j6tGAFtk6RFzWjO54rOgoUrwuQAF02fqOTxWEm3HuSyeaKkAC3D5p3ARkdclnRKVdRm3Q
	 fOR2dein8AlyHk4EuC5QNPgVNBiGugSp6mi6UPk2fY+Q1LRXmYEBo8VUYtrY2cgBiQLMC
	 xUwtck1mEwHaZiIxhUBeTs3NHcb13A9Rkimjd4sZ9TQu5xKGOfMSOBHnan5dXboH03E5S
	 xUoSjSblVKBJ++x1ceejNx0izfo67cE35f3OhN6Q5PkX06hZv9pexXe0BETYKpwZGcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208189;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Y7uzO015+PLbFU17BQeYU46cUNC8WUAAblYaV4hUYOA=;
	b=RuQo7LRqUpCzdEoiQDY+KkPVtkdsGdOeSms0uVDEcviF25U1ewljT4Vd1cmWB/JP0K41
	 w8+M/I1VHDPTxgcxOz3zdM/qwRsbmS9Kh2S0/URH2XDywLp5kvibRQqcQn1Gcut26kZ2I
	 juwLA+mN3uEF70FV3ZLnpQzPzDUKe1obqDS6YW49MAVQ8rjYq26bTUtZRAhSKY1Zvtkpn
	 jXfdWkcR3V+ImwcU8oEvqjZll/yRPTlanlGcnh5WlV9A7DUZMG8K+56QWc5VTzNI6rcpI
	 79RvoucEpe/AobL/1bPGrnN3P9lmwK1UcewJaTgmlSyQhF8he3gn1rb/CClcs8BbMAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0huUGfO6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 601C0606A31A;
	Wed, 28 Oct 2026 17:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0huUGfO6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF92E1F01825;
	Wed, 28 Oct 2026 17:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208189;
	bh=Y7uzO015+PLbFU17BQeYU46cUNC8WUAAblYaV4hUYOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0huUGfO6u4xqBmMEwOSXDKeSY9iS+aDB8ORA9NCb5OkLQf4dsST9PHDl6Nn/kWKZ6
	 PMQsIIxackXlFIL/5ObWDuI8obwfZ8cYZu3It4Ez7o2Jib2Z5uSuLynJdX7A5Glw6+
	 5ua+BDR0vo0laXLFYOvUYhfMe7+ZCeTUegPw2JtM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+2eb3d983669d3e49d4fa@syzkaller.appspotmail.com,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 032/516] io_uring/rw: end write accounting from ->ki_complete
Date: Wed, 28 Oct 2026 17:53:04 +0100
Message-ID: <20261028170004.289865995@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[ placed write-accounting release after __io_complete_rw_common() to accommodate the older retry path’s early return. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io_uring.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 01eff1694d8c6..e2e04a381315f 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2792,7 +2792,10 @@ static void io_req_task_complete(struct io_kiocb *req, bool *locked)
 
 static void io_req_rw_complete(struct io_kiocb *req, bool *locked)
 {
-	io_req_io_end(req);
+	if (req->rw.kiocb.ki_flags & IOCB_WRITE)
+		fsnotify_modify(req->file);
+	else
+		fsnotify_access(req->file);
 	io_req_task_complete(req, locked);
 }
 
@@ -2802,6 +2805,10 @@ static void io_complete_rw(struct kiocb *kiocb, long res, long res2)
 
 	if (__io_complete_rw_common(req, res))
 		return;
+	/* ring owner may block in freeze_super() before task_work runs */
+	if (kiocb->ki_flags & IOCB_WRITE)
+		io_req_end_write(req);
+
 	req->result = io_fixup_rw_res(req, res);
 	req->io_task_work.func = io_req_rw_complete;
 	io_req_task_work_add(req);
-- 
2.53.0



