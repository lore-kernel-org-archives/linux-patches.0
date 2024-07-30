Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2A241A76BB;
	Tue, 30 Jul 2024 17:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360038; cv=none; b=kADoHV+4RzKEGQsWSiLBfo5pKDqthXXFtvwtvc80Ie7Xn3NkNcEBH76Wg7uPkuea/QyJ1kVMBpRRL9oChZ6jP2O1Hyrnvi8WpN60WJvth5TsQn+CN+ZKvYQqVJHWTYLUp9o/85O4vKCqebAo31JMUTJvlexZrJom4al2+t/Cotk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360038; c=relaxed/simple;
	bh=4rdTHbBjOVWDsbJVZ2IgQJkusxRq3BSqbYYnEHkqMK0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ngjiC8cp/+QJL/fMD7thtI0Bs0SicVDCm5qB2bmLsdAmPY5OjI3k27e6IvWXBHqv0pM6Jgj1OAAKpHVG/XcB2R147jWFgQMdrvyntAcNUhHbQafN/u0N4oSiDIxR00t4JVEeZWHdMH4WZ3LHJS2H5j7sIcSQx42+JBP9S+VdzB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Boi0H7l6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Boi0H7l6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55CEFC32782;
	Tue, 30 Jul 2024 17:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360038;
	bh=4rdTHbBjOVWDsbJVZ2IgQJkusxRq3BSqbYYnEHkqMK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Boi0H7l6Z9a/bDqFybWyou8ltPAG1E1JTOTE3Zd5wggoxT63Mq16DlHih8XZjShKU
	 naowexNuyEdjMZtzoODNwUfmuZJ4Sm5+z6PAczDnA6bGbD1a8GKmLDDiBlbHdOH6LQ
	 F/AgmMW2JHaM4QrseoiwRtOz+m7WpG+BMHBpZGBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Orth <ju.orth@gmail.com>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.10 577/809] io_uring/io-wq: limit retrying worker initialisation
Date: Tue, 30 Jul 2024 17:47:33 +0200
Message-ID: <20240730151747.567991294@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -23,6 +23,7 @@
 #include "io_uring.h"
 
 #define WORKER_IDLE_TIMEOUT	(5 * HZ)
+#define WORKER_INIT_LIMIT	3
 
 enum {
 	IO_WORKER_F_UP		= 0,	/* up and active */
@@ -58,6 +59,7 @@ struct io_worker {
 
 	unsigned long create_state;
 	struct callback_head create_work;
+	int init_retries;
 
 	union {
 		struct rcu_head rcu;
@@ -744,7 +746,7 @@ static bool io_wq_work_match_all(struct
 	return true;
 }
 
-static inline bool io_should_retry_thread(long err)
+static inline bool io_should_retry_thread(struct io_worker *worker, long err)
 {
 	/*
 	 * Prevent perpetual task_work retry, if the task (or its group) is
@@ -752,6 +754,8 @@ static inline bool io_should_retry_threa
 	 */
 	if (fatal_signal_pending(current))
 		return false;
+	if (worker->init_retries++ >= WORKER_INIT_LIMIT)
+		return false;
 
 	switch (err) {
 	case -EAGAIN:
@@ -778,7 +782,7 @@ static void create_worker_cont(struct ca
 		io_init_new_worker(wq, worker, tsk);
 		io_worker_release(worker);
 		return;
-	} else if (!io_should_retry_thread(PTR_ERR(tsk))) {
+	} else if (!io_should_retry_thread(worker, PTR_ERR(tsk))) {
 		struct io_wq_acct *acct = io_wq_get_acct(worker);
 
 		atomic_dec(&acct->nr_running);
@@ -845,7 +849,7 @@ fail:
 	tsk = create_io_thread(io_wq_worker, worker, NUMA_NO_NODE);
 	if (!IS_ERR(tsk)) {
 		io_init_new_worker(wq, worker, tsk);
-	} else if (!io_should_retry_thread(PTR_ERR(tsk))) {
+	} else if (!io_should_retry_thread(worker, PTR_ERR(tsk))) {
 		kfree(worker);
 		goto fail;
 	} else {


