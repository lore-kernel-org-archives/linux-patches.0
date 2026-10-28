Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209717;
	b=2z464qQyFDW0nx1J9v5McJqlEc3b3KNZ0fLDDLy/aCVryFH9vl7Coc68JG5kwtV/Gpyp
	 qy1Ipmmq5/iNu1hK0S5/ZlBuF8zUeSf0Ftl2v2OoUsLxJ2btsihvU+jje+qPYE8sKN7/8
	 e39yLxm/uYCHyESJnizVNtWYiu7kkceErwbjuKEmu9gEmI/eDmUHESe3fXXDe9qXe59ZF
	 zh8cAL5kA28Dnjd4A6WQhyi42VQFV9ftMV2Cr3c5eCZLC5QuAcBBuHJ4WRFpbsNDA9ES+
	 nbIz/2kdNVdP6+fVbTzz4nU6dQ87GWsiwy/8NieH9YprOvAyw9n793QjHvMFmvVr1ug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209717;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZO+wZx4ESb9gAAm6DDpMxlc0Qwc+64ZT0v6eZrqHrh0=;
	b=Bvqg4Skbd0t3Vfx1j/RanB2j74m6ykY3Tgk0xElVy7BFy/Itde1yfbzCV3rFD8dvFQ8N
	 hy9X9tv4GSJCjiHjZhso8dcyzSqn7ypSOmg6v9O0CdUK8LpqnpFgPwrHso+Woi9r5BZEw
	 0IQUgQ5AXW5Yx4TMqJECxeLzmP9Eu2Kdd+3OD79a0VFQjCDR/8DIOE261laWKZTWg/Zwh
	 +sOicaWW8i/LmOAhSjM6bF+pHgWCIWeCM/LdNa7y/E+W+6Q5L8b+Z/KtlmXLSS60xzFyM
	 Wp5Z0ggdwGh1w0rGne4TmA+CHTIWgPCcLhl18+NOkm9oiWlK0mJdCUIj02zQm1Lqtog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sjgZwfj7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF45E606A31C;
	Wed, 28 Oct 2026 17:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sjgZwfj7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2974A1F01825;
	Wed, 28 Oct 2026 17:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209716;
	bh=ZO+wZx4ESb9gAAm6DDpMxlc0Qwc+64ZT0v6eZrqHrh0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sjgZwfj7r0wiL905nwUjZDFsgrKX4vK1Yu+sIwnKCLSay2W/MgWZbF3OWzSLR0FTx
	 E/JL7p+EJawdliF2gu0d3Mw/KajElZrEHtYPDSX/AS8/g2Kgjqq4AFiaj/UE9G0Mgg
	 KkFN9v4FL8Jfk1xi6xWDM/+8mktz7wjEMZZZu5rw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.18 053/109] io_uring/io-wq: let cancel find picked up hashed work
Date: Wed, 28 Oct 2026 18:00:37 +0100
Message-ID: <20261028165943.609693890@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165942.357251485@linuxfoundation.org>
References: <20261028165942.357251485@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -54,6 +54,8 @@ struct io_worker {
 	struct io_wq_acct *acct;
 
 	struct io_wq_work *cur_work;
+	/* rest of the hashed chain ->cur_work was taken off the list with */
+	struct io_wq_work *next_work;
 	raw_spinlock_t lock;
 
 	struct completion ref_done;
@@ -579,6 +581,17 @@ static struct io_wq_work *io_get_next_wo
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
@@ -587,9 +600,7 @@ static void io_assign_current_work(struc
 		cond_resched();
 	}
 
-	raw_spin_lock(&worker->lock);
-	worker->cur_work = work;
-	raw_spin_unlock(&worker->lock);
+	__io_assign_current_work(worker, work);
 }
 
 /*
@@ -620,9 +631,7 @@ static void io_worker_handle_work(struct
 			 * work list, but isn't yet discoverable as the
 			 * current work item for this worker.
 			 */
-			raw_spin_lock(&worker->lock);
-			worker->cur_work = work;
-			raw_spin_unlock(&worker->lock);
+			__io_assign_current_work(worker, work);
 		}
 
 		raw_spin_unlock(&acct->lock);
@@ -1171,6 +1180,7 @@ static bool __io_wq_worker_cancel(struct
 static bool io_wq_worker_cancel(struct io_worker *worker, void *data)
 {
 	struct io_cb_cancel_data *match = data;
+	struct io_wq_work *work;
 
 	/*
 	 * Hold the lock to avoid ->cur_work going out of scope, caller
@@ -1179,6 +1189,19 @@ static bool io_wq_worker_cancel(struct i
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


