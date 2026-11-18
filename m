Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044164;
	b=mTRuZLDMgQD14FaPfeEXeFT6M8E8NMzeiIZdblH0G1FvNnNey2IvcKQ9JrNYiM8XuZOM
	 mxtNbrpYaFF5BreRKxisVgdk77WnrLL74U+LWvl8sY+vwKs+soxMh6aarSj0fMLUiOiY7
	 CinioiCrE4jYmiF1e/KN9P+WXCh5xS1JEIhhAOXSzzc14gyGnDElP8kGlpXb2yDnfps0u
	 t6JkBpBazXodeqrRjG1DAu+p7mdHeqnl6CeacDGm0dFaqSpl6eKykI++1LSUagq9bWBEb
	 zVDl66F13Dn+qCrkw0IAy21obNYeUFbf9UMwjo6FOPd+6T4IqZdYGKb/qQFpmwiSZSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044164;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tH6ZX1cR2xz9L2zw8Y/gU11H0yewGZYj46maagK2Ci8=;
	b=aT7hU940rO84mpu4UeMV3UqsuWblFNvs70nr/VcY8+1jpa6YIJKRht9wf3JUzcEx4GSd
	 +eulF7WJP1n80H0d/2NBWcU632vgyENn2SrWyOmSEydxf5cDXJ2lS54ZSUetYOvaG707j
	 hQu2h4M4VLqxCLgnG4qwLBCLbmEthVn4qWPSm6CiB6mjImph4+9RqFKdn+rWm6hHT/SJy
	 n0aGPE4m1CZpdlY6XVPLmuYpWtjmblFxVEoww0rNYJYhV09W4NeyNgluLQSpojlPsvU0m
	 tbP6jIc9AgWawCRVV6YsU6LWcp+RImsGCs6V3hQAJa8+HXyrmTOSp6oXE2LMmimQ4QQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EH39nXr0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A2F4606A31C;
	Wed, 18 Nov 2026 23:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EH39nXr0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E86F1F000C4;
	Wed, 18 Nov 2026 23:22:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044164;
	bh=tH6ZX1cR2xz9L2zw8Y/gU11H0yewGZYj46maagK2Ci8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EH39nXr0fzlHwyIQodvA/1jUj2ptFhOKRhRUorInup4kKlBQKQGRL/wqFR2cOXyQR
	 XT1R965TkeXz4hjrOh6VUngF6TMpoTucI49BJGP4qJKWME8q+DqQ7um5DjQ29RtuKw
	 h1KsJLupDa2iPbZkHvk7AqUos8R9lCetlvjWueio=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+2eb3d983669d3e49d4fa@syzkaller.appspotmail.com,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0411/2857] io_uring/rw: end write accounting from ->ki_complete
Date: Wed, 18 Nov 2026 15:24:05 +0100
Message-ID: <20261118150216.186665388@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adapted context for the older io_rw helpers and placed io_req_end_write() after the __io_complete_rw_common() early return to avoid a double write-end on the reissue path. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/rw.c | 30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

diff --git a/io_uring/rw.c b/io_uring/rw.c
index 8be0d4fd33eae..8c38449dd7da0 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -215,20 +215,25 @@ static void io_req_end_write(struct io_kiocb *req)
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
 
 static bool __io_complete_rw_common(struct io_kiocb *req, long res)
@@ -266,7 +271,7 @@ static inline int io_fixup_rw_res(struct io_kiocb *req, long res)
 
 static void io_req_rw_complete(struct io_kiocb *req, bool *locked)
 {
-	io_req_io_end(req);
+	io_req_io_notify(req);
 	io_req_task_complete(req, locked);
 }
 
@@ -277,6 +282,11 @@ static void io_complete_rw(struct kiocb *kiocb, long res)
 
 	if (__io_complete_rw_common(req, res))
 		return;
+
+	/* ring owner may block in freeze_super() before task_work runs */
+	if (kiocb->ki_flags & IOCB_WRITE)
+		io_req_end_write(req);
+
 	io_req_set_res(req, io_fixup_rw_res(req, res), 0);
 	req->io_task_work.func = io_req_rw_complete;
 	io_req_task_work_add(req);
-- 
2.53.0



