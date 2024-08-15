Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E85F1A7060;
	Thu, 15 Aug 2024 13:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729952; cv=none; b=PkAP+X2YUwa3R0sP1T8tzXRDpWuckcRYlumXv0bY4nTMcuDmGFhXmsqfTypPmGDOnOs4mIvyVDCCGF2KXL2T/heNO0KU+eX5b2qqcPIqlOsY3gCitQWTaenCFhnG0Evy7U3vmW30NPw5oTyNb4rlxEYteFH5X104I3Y9XhfqJiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729952; c=relaxed/simple;
	bh=DWMmLbXhL0BtzU4iPifABQLVY6weMDMIENDD/YSZBwk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LVK1iIi85ifK9lDXShxlZ9ZR5UCVXEPDTjYQcuiA4Rbn8P8F/gsLkbwgA4xyBghD4hXdwIskIjoQvdauGUpnUJTdo6AGU0XNKZFS2Bnrme9ZuIjGWhE5I8l5+/q8JLdUrAW80xRtlkPvtizyJmO4TZ+4Rvmy6x32t8mmjzqh//Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qvS1jQxT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qvS1jQxT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91CA1C4AF0D;
	Thu, 15 Aug 2024 13:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729952;
	bh=DWMmLbXhL0BtzU4iPifABQLVY6weMDMIENDD/YSZBwk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qvS1jQxTtlXyTiChPdd+YGp13qK9hqmFIwVlGXcKNVhPbrbACk2fQ+YHK7x5YdkPp
	 /TfOgjVpR2ZKVLMZ+hedrLKT/rPi8srR2QNeWR6rodaUDVMigf0MVDWEiQkIhhGHrJ
	 1lsALOSL8w8dQRkn+1O1V1sNSNdw1wahKTj5DqWM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Orth <ju.orth@gmail.com>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.15 258/484] io_uring/io-wq: limit retrying worker initialisation
Date: Thu, 15 Aug 2024 15:21:56 +0200
Message-ID: <20240815131951.367500228@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


