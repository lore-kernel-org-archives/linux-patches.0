Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826823;
	b=TytlhVifQdb3WsylONXAw4mlKv1VoY0dCyJzQKXVwJ+5ZBX2yb6PCa2V5TQtC5yDPjaD
	 qLLpuL+UNjBfBeq7r7qZMND4uArBeuYT9jnKPzn9TeDeSN6Y663cbsNlyqtc66FCmDTxJ
	 T4hGKU5Zjg2tvmwmYrPRLb2pS1/+lrZfCDNIYc1ZyeXvyrCBYF9IZQICB4XX7k3DKO/8g
	 VDe5hHCf9ZDdUht60egrNHBXnIgnZIW/LZlOIOI2Hju+IDyu6PiSnBFHqrSnnVKpnEENj
	 ni1F+zlHmYZR0jWoeuMKbafPySbOTezJRElw+ARyIUPgQTRKQ57pISzb0YEzHJhEH6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826823;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2AR71Kee82nr/v1BgtCIuekWvRUnTkQSP+bfQZ4pfAk=;
	b=UnkvbrGd2sG5PadkPr6uuZVnXiwcWFhMTxsiUwo38f0svAubLmypBZ18XCec0DlP3JuJ
	 ztmHqS18RucGKBkFKzhomHK0HMXcJtXXSVaZTW91A5zFzrWXga6JDn6eS5VhHA1q3Qryc
	 Rjq788MYYu0vEx1FieBfSbl99L3kB0Cu6zYjGx7GbgWIpl+fCotwiD+jQ8Uqx8ygKnRxV
	 qDFnLXsrNCxPpK2x5UoQ2+V50b39B8WaWClPMTVsNCLE4eSpOeMNndTvfpRnpZT0F0PwD
	 BNBTX4LNUTUU5W6oHW0y/p00mGWrOEan7R4idyl8I3itv2pF1P6EwXRDbrPommhnH7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=njE4cLem;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC7446071AE0;
	Wed,  4 Nov 2026 21:13:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=njE4cLem
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40FDA1F00A16;
	Wed,  4 Nov 2026 21:13:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793826822;
	bh=2AR71Kee82nr/v1BgtCIuekWvRUnTkQSP+bfQZ4pfAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=njE4cLemGhgBvuI9r7ZhLJQs53vDQBP94XzyX3FJGBeL45h9MI2XEuTzaA4DYVqDQ
	 VWQyZxGVBcmxQ7iF4mqcUmTUGwoFXcyNLKKmbz/odcGz/dq/XTuvfX149MrypSp2or
	 MdTooezXplWjq64LEk7ormQ2Wl2ubdjxekgCfxxY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 029/547] io_uring/io-wq: let cancel find picked up hashed work
Date: Wed,  4 Nov 2026 16:03:33 -0500
Message-ID: <20261104211039.177903098@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit e9efeb4fc97b0879512a3c3b995ed448f2487e12 ]

io_get_next_work() takes all the work items that share a hash off the
work list in one go, and the worker runs them one after the other. Only
the one it is working on is visible as ->cur_work. The others are neither
on the list nor current, so io_wq_cancel_cb() can't find them.

IORING_OP_ASYNC_CANCEL and IORING_REGISTER_SYNC_CANCEL return -ENOENT for
a request that has not even been started, e.g. a buffered write queued
behind another write to the same file that is blocked, and the request is
carried out. The cancellation done for a task or ring that goes away gets
there in the end, as it keeps trying, but it has to wait for each item to
become current.

Keep a pointer to the remainder of the chain next to ->cur_work, and have
io_wq_worker_cancel() look at it. The items on it belong to the worker,
which needs ->lock to move on to the next one. Matching work is flagged
with IO_WQ_WORK_CANCEL and fails with -ECANCELED when its turn comes. The
worker isn't signalled for it, that would interrupt the unrelated work it
is busy with. As the request isn't gone yet, it is reported like running
work, with -EALREADY.

Fixes: 86f3cd1b589a ("io-wq: handle hashed writes in chains")
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261015-b4-io-uring-fixes-v1-13-c1556f5d7bf5@toxicpanda.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io-wq.c | 35 +++++++++++++++++++++++++++++------
 1 file changed, 29 insertions(+), 6 deletions(-)

diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index 0120ec40effad..32c830d33a4da 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -56,6 +56,8 @@ struct io_worker {
 	struct io_wq_acct *acct;
 
 	struct io_wq_work *cur_work;
+	/* rest of the hashed chain ->cur_work was taken off the list with */
+	struct io_wq_work *next_work;
 	raw_spinlock_t lock;
 
 	struct completion ref_done;
@@ -581,6 +583,17 @@ static struct io_wq_work *io_get_next_work(struct io_wq_acct *acct,
 	return NULL;
 }
 
+static void __io_assign_current_work(struct io_worker *worker,
+				     struct io_wq_work *work)
+{
+	raw_spin_lock(&worker->lock);
+	worker->cur_work = work;
+	/* stays valid while in between two items of a chain */
+	if (work)
+		worker->next_work = wq_next_work(work);
+	raw_spin_unlock(&worker->lock);
+}
+
 static void io_assign_current_work(struct io_worker *worker,
 				   struct io_wq_work *work)
 {
@@ -589,9 +602,7 @@ static void io_assign_current_work(struct io_worker *worker,
 		cond_resched();
 	}
 
-	raw_spin_lock(&worker->lock);
-	worker->cur_work = work;
-	raw_spin_unlock(&worker->lock);
+	__io_assign_current_work(worker, work);
 }
 
 /*
@@ -622,9 +633,7 @@ static void io_worker_handle_work(struct io_wq_acct *acct,
 			 * work list, but isn't yet discoverable as the
 			 * current work item for this worker.
 			 */
-			raw_spin_lock(&worker->lock);
-			worker->cur_work = work;
-			raw_spin_unlock(&worker->lock);
+			__io_assign_current_work(worker, work);
 		}
 
 		raw_spin_unlock(&acct->lock);
@@ -1175,6 +1184,7 @@ static bool __io_wq_worker_cancel(struct io_worker *worker,
 static bool io_wq_worker_cancel(struct io_worker *worker, void *data)
 {
 	struct io_cb_cancel_data *match = data;
+	struct io_wq_work *work;
 
 	/*
 	 * Hold the lock to avoid ->cur_work going out of scope, caller
@@ -1183,6 +1193,19 @@ static bool io_wq_worker_cancel(struct io_worker *worker, void *data)
 	raw_spin_lock(&worker->lock);
 	if (__io_wq_worker_cancel(worker, match, worker->cur_work))
 		match->nr_running++;
+	/*
+	 * Hashed work is taken off the work list a chain at a time, what the
+	 * worker hasn't started yet can only be found here. It doesn't move on
+	 * without the lock. Just mark the work, it fails once it is its turn.
+	 */
+	for (work = worker->next_work; work; work = wq_next_work(work)) {
+		if (match->nr_running && !match->cancel_all)
+			break;
+		if (match->fn(work, match->data)) {
+			atomic_or(IO_WQ_WORK_CANCEL, &work->flags);
+			match->nr_running++;
+		}
+	}
 	raw_spin_unlock(&worker->lock);
 
 	return match->nr_running && !match->cancel_all;
-- 
2.53.0



