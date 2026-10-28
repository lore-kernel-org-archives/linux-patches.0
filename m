Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207218;
	b=QD2xxOTICGEyHk0QPP3VEyn1M5pSvtI5GaTxqj53YzPOMDKMyfi5ZcU3ANF2PMB4j/zk
	 rzKa/piWPsC9ZG5UWrdDkSmzmTLwsqLtFMFvpstoTE638Shbkxcsq7Od+W81cnr7KGSeP
	 u67f+VzTp95hK0B25RZCQu3f3pd1NoFvHemqZXb2F7hDNf1TTVXQtuaVZDttC3sncF60L
	 FQzQHrduNVKYPUGncRN3sWxxeeKtLuM6fk2pkkhCPZE4Gm0/n9JAkJLhkIFunjxtEJ7b4
	 ug3+vQ7X+aksrMRWz2xTFeLWQdUaP/FvV+yyXP4CGrJcpwMWPCyPItwNrpTQlVDYIAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207218;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=C4dkT1Gr5bsWEbbOmMB1rN+sWnUnjD7tTUZQAXbrfho=;
	b=33s1KbTrdhkFNYqShVB8jdu2QBBuE9xR3rLu+7U4Mzb2mkt6HAfYvGFIzVb52i2unwt4
	 9FWwnEFa691L9jKKD7KGFxdakbtUOZHbAS0c/EPtQIHADKrFGnKxxDHsB2pJGmuupOSbc
	 rDM1KzBdIsdKP90p/j5Ju7dbs01l8uZ5GIxIMeBVOXQNu0IH0Nfzs+Gg51xWMiyZ2pSVb
	 n4mdnZElTFE0TO++Bt5uAPW44M9YxxPQGDpwg7Ntq+hmIKTlc/23Z8ONC8A5wVejDvpEj
	 0cTU1Ef5aYigK56nbRlsMKu/gbIxql5aB4/qHDTX9TTLRB/zaof052SCPxCTVdQIAIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="qY/IE0UZ";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74E41606A31A;
	Wed, 28 Oct 2026 17:06:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qY/IE0UZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C67DA1F01825;
	Wed, 28 Oct 2026 17:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207218;
	bh=C4dkT1Gr5bsWEbbOmMB1rN+sWnUnjD7tTUZQAXbrfho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qY/IE0UZdGS9UI9RRqouzXp2IlSgFj91yI6/nABl9UneSgnffIF+IviBZVrwpKxXw
	 uCo4q4LpVOypdKZZuyfsJKGaEBZYE41H6uCAwwjmS1pqbDaH8i2B4D/wYTrocNdC6v
	 QgXibwZlQTIv6O8as/ezbhKXvf12ZbI8atUavkpY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.2 29/88] io_uring/io-wq: let cancel find picked up hashed work
Date: Wed, 28 Oct 2026 17:59:37 +0100
Message-ID: <20261028165942.801421510@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165942.107695352@linuxfoundation.org>
References: <20261028165942.107695352@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

Commit e9efeb4fc97b0879512a3c3b995ed448f2487e12 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io-wq.c |   35 +++++++++++++++++++++++++++++------
 1 file changed, 29 insertions(+), 6 deletions(-)

--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -55,6 +55,8 @@ struct io_worker {
 	struct io_wq_acct *acct;
 
 	struct io_wq_work *cur_work;
+	/* rest of the hashed chain ->cur_work was taken off the list with */
+	struct io_wq_work *next_work;
 	raw_spinlock_t lock;
 
 	struct completion ref_done;
@@ -580,6 +582,17 @@ static struct io_wq_work *io_get_next_wo
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
@@ -588,9 +601,7 @@ static void io_assign_current_work(struc
 		cond_resched();
 	}
 
-	raw_spin_lock(&worker->lock);
-	worker->cur_work = work;
-	raw_spin_unlock(&worker->lock);
+	__io_assign_current_work(worker, work);
 }
 
 /*
@@ -621,9 +632,7 @@ static void io_worker_handle_work(struct
 			 * work list, but isn't yet discoverable as the
 			 * current work item for this worker.
 			 */
-			raw_spin_lock(&worker->lock);
-			worker->cur_work = work;
-			raw_spin_unlock(&worker->lock);
+			__io_assign_current_work(worker, work);
 		}
 
 		raw_spin_unlock(&acct->lock);
@@ -1170,6 +1179,7 @@ static bool __io_wq_worker_cancel(struct
 static bool io_wq_worker_cancel(struct io_worker *worker, void *data)
 {
 	struct io_cb_cancel_data *match = data;
+	struct io_wq_work *work;
 
 	/*
 	 * Hold the lock to avoid ->cur_work going out of scope, caller
@@ -1178,6 +1188,19 @@ static bool io_wq_worker_cancel(struct i
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


