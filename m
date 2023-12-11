Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E7135102A;
	Mon, 11 Dec 2023 18:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fmy2nqjv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9A95C433C8;
	Mon, 11 Dec 2023 18:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702320556;
	bh=7uw0Z/Dw1y86q6ECovCLba/NuATNlXsPy8r5oN8Kteg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fmy2nqjvyT59WT0qjNzmc9QPFxUqb3E2L7uXIHYWQzFTFIlYfrqK6x8dWArXHzc3c
	 wFdRzr1UtFXIBQPMfBEaWk2pPfJZP5n4B4GAr+LYjhesz9+PtiKcG86rCMv6jZ0ui2
	 8gjOiuyezbz5q0NYic9gYmIFLzvU6FmM3kaU7Ol8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 104/194] io_uring: fix mutex_unlock with unreferenced ctx
Date: Mon, 11 Dec 2023 19:21:34 +0100
Message-ID: <20231211182041.083044695@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182036.606660304@linuxfoundation.org>
References: <20231211182036.606660304@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1377,6 +1377,7 @@ static __cold void io_iopoll_try_reap_ev
 	if (!(ctx->flags & IORING_SETUP_IOPOLL))
 		return;
 
+	percpu_ref_get(&ctx->refs);
 	mutex_lock(&ctx->uring_lock);
 	while (!wq_list_empty(&ctx->iopoll_list)) {
 		/* let it sleep and repeat later if can't complete a request */
@@ -1394,6 +1395,7 @@ static __cold void io_iopoll_try_reap_ev
 		}
 	}
 	mutex_unlock(&ctx->uring_lock);
+	percpu_ref_put(&ctx->refs);
 }
 
 static int io_iopoll_check(struct io_ring_ctx *ctx, long min)
@@ -2800,12 +2802,7 @@ static __cold void io_ring_exit_work(str
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


