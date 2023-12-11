Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7D75FC06;
	Mon, 11 Dec 2023 18:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VcY0XWHc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6924FC433CB;
	Mon, 11 Dec 2023 18:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319629;
	bh=pNhvH8vJMgJulFZJZ67BbfdzSeXbNRzdv14WaYFt6LE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VcY0XWHc76XSY8LEGA245aY7AG+uWRE40NOwbl/O6uG+hXnbLtW49TdmpZpn+nKxH
	 bXgxW2U+cJsW+SDa0e3g6dP7HiDbyiBdJQ4rwcWlW2y58/gR2boP3sLwld1BYiErzC
	 yjtWpPYJmO9sMSP/KxsWw80mZGFMR5yN7zmCWbvQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 136/244] io_uring: fix mutex_unlock with unreferenced ctx
Date: Mon, 11 Dec 2023 19:20:29 +0100
Message-ID: <20231211182051.884896098@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182045.784881756@linuxfoundation.org>
References: <20231211182045.784881756@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Begunkov <asml.silence@gmail.com>

commit f7b32e785042d2357c5abc23ca6db1b92c91a070 upstream.

Callers of mutex_unlock() have to make sure that the mutex stays alive
for the whole duration of the function call. For io_uring that means
that the following pattern is not valid unless we ensure that the
context outlives the mutex_unlock() call.

mutex_lock(&ctx->uring_lock);
req_put(req); // typically via io_req_task_submit()
mutex_unlock(&ctx->uring_lock);

Most contexts are fine: io-wq pins requests, syscalls hold the file,
task works are taking ctx references and so on. However, the task work
fallback path doesn't follow the rule.

Cc:  <stable@vger.kernel.org>
Fixes: 04fc6c802d ("io_uring: save ctx put/get for task_work submit")
Reported-by: Jann Horn <jannh@google.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/io-uring/CAG48ez3xSoYb+45f1RLtktROJrpiDQ1otNvdR+YLQf7m+Krj5Q@mail.gmail.com/
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -269,6 +269,7 @@ static __cold void io_fallback_req_func(
 	struct io_kiocb *req, *tmp;
 	struct io_tw_state ts = { .locked = true, };
 
+	percpu_ref_get(&ctx->refs);
 	mutex_lock(&ctx->uring_lock);
 	llist_for_each_entry_safe(req, tmp, node, io_task_work.node)
 		req->io_task_work.func(req, &ts);
@@ -276,6 +277,7 @@ static __cold void io_fallback_req_func(
 		return;
 	io_submit_flush_completions(ctx);
 	mutex_unlock(&ctx->uring_lock);
+	percpu_ref_put(&ctx->refs);
 }
 
 static int io_alloc_hash_table(struct io_hash_table *table, unsigned bits)
@@ -3138,12 +3140,7 @@ static __cold void io_ring_exit_work(str
 	init_completion(&exit.completion);
 	init_task_work(&exit.task_work, io_tctx_exit_cb);
 	exit.ctx = ctx;
-	/*
-	 * Some may use context even when all refs and requests have been put,
-	 * and they are free to do so while still holding uring_lock or
-	 * completion_lock, see io_req_task_submit(). Apart from other work,
-	 * this lock/unlock section also waits them to finish.
-	 */
+
 	mutex_lock(&ctx->uring_lock);
 	while (!list_empty(&ctx->tctx_list)) {
 		WARN_ON_ONCE(time_after(jiffies, timeout));


