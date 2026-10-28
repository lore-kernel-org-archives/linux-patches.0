Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210455;
	b=LGjXbIEZV3OvEuIYu/B6H7tEJmdUaodEI3Z1Z7WKe8REQHRReB06sRjHPU4gPHLJT67a
	 +AEf2c15kXf5FKbhXnJfd//mY6n4tSliJVpVYrndqm2D56Geg10x9HgxuFAKosl9Yls/0
	 1goMxj3aTRMHl82pgq4oW3+JXHfRW2Q8x73TbGH2MIgaBQH/pV2HdoP3doLSxHl6Xa73m
	 WYD7TjvG5wYT5/GzdgTu09sL1lYmCKzx4KzGSHlHJtGMT+mbihvpbe6D5d9qCBUbnaWHM
	 rHINY5ft4p2MONmVkQxYTsGTPHqO6UTcO0paCq9C++/ED+GB7KVkS7clqGkbRDxh3vQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210455;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=CvQLetR2AS9uPHtx//nt/ffC/QH04pAv1gaMExR31lg=;
	b=dRa4UQwSCOCzcfx5gH0otkbrDtRH5RtCo3BVemQEC/jPMiG2/Rkh5gQaV6lBdI+2GAp5
	 r5R+E7MgFp+0CZtZ5pST3x40sA4TiuV7yaGBO1oE0Yx06ybUv3jIEEIo6+2u4UI21q5uS
	 6ipASdnpJSqXTc1+ql0/mPrHJBSmnMQSR1EkwkTpoLrDIlIUHT5J8bRTP5zCnVj5vM3Zw
	 xahrxNKqZAEqrEvfP6RPOH5g3aspXYF1bu3P+RwwP0LFV9YThAy5nXKWJum7b4ZIhewhc
	 u+ldljl0h+k+zydo3jRlRYsHOPXX+Qzn87bgMXTqzvNJATdHXY88fLP/2xAA/kEm3bQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fmmx09yL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E677606A32D;
	Wed, 28 Oct 2026 18:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fmmx09yL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F5DC1F01825;
	Wed, 28 Oct 2026 18:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210455;
	bh=CvQLetR2AS9uPHtx//nt/ffC/QH04pAv1gaMExR31lg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fmmx09yL57k7Sj7HvGkbjnz/rhFvdHHf97VzbNmjJW4QQAB3GPQlchYQfYVr/xXt8
	 xWgu8hHBaz1e6sYT+yc3omgFwGoOwV2cRUh1l+lSUgHK91/b+P0P6+1zoFg87O7cp7
	 8U9Vz7L9hPLqTMuVutYaT9kV1ZQOeS/CxRGUEZOA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+2eb3d983669d3e49d4fa@syzkaller.appspotmail.com,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 031/571] io_uring/rw: end write accounting from ->ki_complete
Date: Wed, 28 Oct 2026 17:52:58 +0100
Message-ID: <20261028170008.761945530@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 8747c585a0770..8d5791d8f4031 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2797,7 +2797,10 @@ static void io_req_task_complete(struct io_kiocb *req, bool *locked)
 
 static void io_req_rw_complete(struct io_kiocb *req, bool *locked)
 {
-	io_req_io_end(req);
+	if (req->rw.kiocb.ki_flags & IOCB_WRITE)
+		fsnotify_modify(req->file);
+	else
+		fsnotify_access(req->file);
 	io_req_task_complete(req, locked);
 }
 
@@ -2807,6 +2810,10 @@ static void io_complete_rw(struct kiocb *kiocb, long res, long res2)
 
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



