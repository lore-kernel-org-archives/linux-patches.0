Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DC7C1DFFB;
	Thu, 15 Aug 2024 14:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732561; cv=none; b=QZcqKlqWOeNQCByQcOpPi8qT3mmeAZp486Y4l+2Xu//xOd+044SX7ayjpcHLqvfTpvMmrI1igW/MLu9OZ2qcf8ZiQ54mjmFgO5L7QGb3T4u9kgqEhLv0seDDdoLkdllOXUjHEu/gD9BSCKCBFDyvvhNMyqtnd6xpAgpmRGvbdtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732561; c=relaxed/simple;
	bh=G/VehMVDKo3+r3JCitmYOqtBlhi1kPj6jTk61mE7SrY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ljDiJsdAOAAX9O0GT9P62xA32yYIBwI4scZ7WVcrVIvbmLv3WkavuVBc0moVtwscaSMIib3NQzfHfPP4wvF0izEFGCJxQcGCDqzoW8sqxVS2cZWd10+aQGrr/VHWcW7mGi1rUL0++ZX9xRiaO5HqAfFkTsaDyFLVy/rGg6Vkibo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tN0QV2h0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tN0QV2h0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4A83C32786;
	Thu, 15 Aug 2024 14:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732561;
	bh=G/VehMVDKo3+r3JCitmYOqtBlhi1kPj6jTk61mE7SrY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tN0QV2h0vLX25z8V7/lo1609QHmfCnf59BcuraiGQS6+DXcn9tmK+Q2Svnu0mzDlY
	 lP5qXS27zedMLYBso6IkbcqSM/+RI/0yPbYNzK/1U+s0dLSwJZOL9JyFnE3uFuMf1C
	 bBfZ05Gd/J6nutr0bPtQyLWXmwAKggKecgTXIR1k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Orth <ju.orth@gmail.com>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 186/352] io_uring/io-wq: limit retrying worker initialisation
Date: Thu, 15 Aug 2024 15:24:12 +0200
Message-ID: <20240815131926.467774043@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Begunkov <asml.silence@gmail.com>

commit 0453aad676ff99787124b9b3af4a5f59fbe808e2 upstream.

If io-wq worker creation fails, we retry it by queueing up a task_work.
tasK_work is needed because it should be done from the user process
context. The problem is that retries are not limited, and if queueing a
task_work is the reason for the failure, we might get into an infinite
loop.

It doesn't seem to happen now but it would with the following patch
executing task_work in the freezer's loop. For now, arbitrarily limit the
number of attempts to create a worker.

Cc: stable@vger.kernel.org
Fixes: 3146cba99aa28 ("io-wq: make worker creation resilient against signals")
Reported-by: Julian Orth <ju.orth@gmail.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/8280436925db88448c7c85c6656edee1a43029ea.1720634146.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io-wq.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -19,6 +19,7 @@
 #include "io-wq.h"
 
 #define WORKER_IDLE_TIMEOUT	(5 * HZ)
+#define WORKER_INIT_LIMIT	3
 
 enum {
 	IO_WORKER_F_UP		= 1,	/* up and active */
@@ -54,6 +55,7 @@ struct io_worker {
 	unsigned long create_state;
 	struct callback_head create_work;
 	int create_index;
+	int init_retries;
 
 	union {
 		struct rcu_head rcu;
@@ -732,7 +734,7 @@ static bool io_wq_work_match_all(struct
 	return true;
 }
 
-static inline bool io_should_retry_thread(long err)
+static inline bool io_should_retry_thread(struct io_worker *worker, long err)
 {
 	/*
 	 * Prevent perpetual task_work retry, if the task (or its group) is
@@ -740,6 +742,8 @@ static inline bool io_should_retry_threa
 	 */
 	if (fatal_signal_pending(current))
 		return false;
+	if (worker->init_retries++ >= WORKER_INIT_LIMIT)
+		return false;
 
 	switch (err) {
 	case -EAGAIN:
@@ -766,7 +770,7 @@ static void create_worker_cont(struct ca
 		io_init_new_worker(wqe, worker, tsk);
 		io_worker_release(worker);
 		return;
-	} else if (!io_should_retry_thread(PTR_ERR(tsk))) {
+	} else if (!io_should_retry_thread(worker, PTR_ERR(tsk))) {
 		struct io_wqe_acct *acct = io_wqe_get_acct(worker);
 
 		atomic_dec(&acct->nr_running);
@@ -831,7 +835,7 @@ fail:
 	tsk = create_io_thread(io_wqe_worker, worker, wqe->node);
 	if (!IS_ERR(tsk)) {
 		io_init_new_worker(wqe, worker, tsk);
-	} else if (!io_should_retry_thread(PTR_ERR(tsk))) {
+	} else if (!io_should_retry_thread(worker, PTR_ERR(tsk))) {
 		kfree(worker);
 		goto fail;
 	} else {


