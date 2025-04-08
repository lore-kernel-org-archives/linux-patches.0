Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61DC5265CAF;
	Tue,  8 Apr 2025 11:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110525; cv=none; b=AadFINpWe3LTco6achdCP9UqB7qBcXfz1d7rC++RNGm3WVWg7vCPckM9x9EVD0evM8R7e0hvYvAPcjr3oGGoi/RgbvtcPsITPHRiC+KiN3cIVrI2LU5nqEQ1BeI8gQaCukYC+QmWNUY1GAMjX2CmcaGpCDniCtHY16qW7ow7kWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110525; c=relaxed/simple;
	bh=TKaSnZSCmT1164KHBFi6XmJ5NPCTGAiVAs0Pmw40iWs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pkUTTcVdtUqWuub1Z4jIhH0122zsghpGFOt05+y1ryV1e3j/knYlBcAXnTDtzQuwcu5n7rA8oLsP/hp3JeaSNtUASEzApQfrqQFMHAIvN+TWEVB5AkKCGSeGeqeseNqBk7BhOQNm3td6piKznMPI+OX4t0oyL2w4gJsSMWPs0W0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZG4VnTSI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZG4VnTSI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F702C4CEE5;
	Tue,  8 Apr 2025 11:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110524;
	bh=TKaSnZSCmT1164KHBFi6XmJ5NPCTGAiVAs0Pmw40iWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZG4VnTSIEqwpJL4s2P9mCad6LprflpHjn+CFtGKh7vHMLEL41NuwrhXsQ3EwFC5rT
	 U0lG/90h00ufTK5CSkahTTqT3mfHEX1PwRv1sU+NCy3ryDwLszFnMBlht4l/uTCZKb
	 981jjlei+hggTw/pr6JcxvCeFOnHdYUfYJY71ElY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Kellermann <max.kellermann@ionos.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 097/731] io_uring/io-wq: cache work->flags in variable
Date: Tue,  8 Apr 2025 12:39:54 +0200
Message-ID: <20250408104916.526097409@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Max Kellermann <max.kellermann@ionos.com>

[ Upstream commit 6ee78354eaa602002448f098b34678396d99043d ]

This eliminates several redundant atomic reads and therefore reduces
the duration the surrounding spinlocks are held.

In several io_uring benchmarks, this reduced the CPU time spent in
queued_spin_lock_slowpath() considerably:

io_uring benchmark with a flood of `IORING_OP_NOP` and `IOSQE_ASYNC`:

    38.86%     -1.49%  [kernel.kallsyms]  [k] queued_spin_lock_slowpath
     6.75%     +0.36%  [kernel.kallsyms]  [k] io_worker_handle_work
     2.60%     +0.19%  [kernel.kallsyms]  [k] io_nop
     3.92%     +0.18%  [kernel.kallsyms]  [k] io_req_task_complete
     6.34%     -0.18%  [kernel.kallsyms]  [k] io_wq_submit_work

HTTP server, static file:

    42.79%     -2.77%  [kernel.kallsyms]     [k] queued_spin_lock_slowpath
     2.08%     +0.23%  [kernel.kallsyms]     [k] io_wq_submit_work
     1.19%     +0.20%  [kernel.kallsyms]     [k] amd_iommu_iotlb_sync_map
     1.46%     +0.15%  [kernel.kallsyms]     [k] ep_poll_callback
     1.80%     +0.15%  [kernel.kallsyms]     [k] io_worker_handle_work

HTTP server, PHP:

    35.03%     -1.80%  [kernel.kallsyms]     [k] queued_spin_lock_slowpath
     0.84%     +0.21%  [kernel.kallsyms]     [k] amd_iommu_iotlb_sync_map
     1.39%     +0.12%  [kernel.kallsyms]     [k] _copy_to_iter
     0.21%     +0.10%  [kernel.kallsyms]     [k] update_sd_lb_stats

Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
Link: https://lore.kernel.org/r/20250128133927.3989681-5-max.kellermann@ionos.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 486ba4d84d62 ("io_uring/io-wq: do not use bogus hash value")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io-wq.c | 33 +++++++++++++++++++++------------
 io_uring/io-wq.h |  7 ++++++-
 2 files changed, 27 insertions(+), 13 deletions(-)

diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index f7d09698e43ce..d1eaa3e39cd5f 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -160,9 +160,9 @@ static inline struct io_wq_acct *io_get_acct(struct io_wq *wq, bool bound)
 }
 
 static inline struct io_wq_acct *io_work_get_acct(struct io_wq *wq,
-						  struct io_wq_work *work)
+						  unsigned int work_flags)
 {
-	return io_get_acct(wq, !(atomic_read(&work->flags) & IO_WQ_WORK_UNBOUND));
+	return io_get_acct(wq, !(work_flags & IO_WQ_WORK_UNBOUND));
 }
 
 static inline struct io_wq_acct *io_wq_get_acct(struct io_worker *worker)
@@ -452,9 +452,14 @@ static void __io_worker_idle(struct io_wq *wq, struct io_worker *worker)
 	}
 }
 
+static inline unsigned int __io_get_work_hash(unsigned int work_flags)
+{
+	return work_flags >> IO_WQ_HASH_SHIFT;
+}
+
 static inline unsigned int io_get_work_hash(struct io_wq_work *work)
 {
-	return atomic_read(&work->flags) >> IO_WQ_HASH_SHIFT;
+	return __io_get_work_hash(atomic_read(&work->flags));
 }
 
 static bool io_wait_on_hash(struct io_wq *wq, unsigned int hash)
@@ -484,17 +489,19 @@ static struct io_wq_work *io_get_next_work(struct io_wq_acct *acct,
 	struct io_wq *wq = worker->wq;
 
 	wq_list_for_each(node, prev, &acct->work_list) {
+		unsigned int work_flags;
 		unsigned int hash;
 
 		work = container_of(node, struct io_wq_work, list);
 
 		/* not hashed, can run anytime */
-		if (!io_wq_is_hashed(work)) {
+		work_flags = atomic_read(&work->flags);
+		if (!__io_wq_is_hashed(work_flags)) {
 			wq_list_del(&acct->work_list, node, prev);
 			return work;
 		}
 
-		hash = io_get_work_hash(work);
+		hash = __io_get_work_hash(work_flags);
 		/* all items with this hash lie in [work, tail] */
 		tail = wq->hash_tail[hash];
 
@@ -591,12 +598,13 @@ static void io_worker_handle_work(struct io_wq_acct *acct,
 		/* handle a whole dependent link */
 		do {
 			struct io_wq_work *next_hashed, *linked;
-			unsigned int hash = io_get_work_hash(work);
+			unsigned int work_flags = atomic_read(&work->flags);
+			unsigned int hash = __io_get_work_hash(work_flags);
 
 			next_hashed = wq_next_work(work);
 
 			if (do_kill &&
-			    (atomic_read(&work->flags) & IO_WQ_WORK_UNBOUND))
+			    (work_flags & IO_WQ_WORK_UNBOUND))
 				atomic_or(IO_WQ_WORK_CANCEL, &work->flags);
 			wq->do_work(work);
 			io_assign_current_work(worker, NULL);
@@ -916,18 +924,19 @@ static void io_run_cancel(struct io_wq_work *work, struct io_wq *wq)
 	} while (work);
 }
 
-static void io_wq_insert_work(struct io_wq *wq, struct io_wq_acct *acct, struct io_wq_work *work)
+static void io_wq_insert_work(struct io_wq *wq, struct io_wq_acct *acct,
+			      struct io_wq_work *work, unsigned int work_flags)
 {
 	unsigned int hash;
 	struct io_wq_work *tail;
 
-	if (!io_wq_is_hashed(work)) {
+	if (!__io_wq_is_hashed(work_flags)) {
 append:
 		wq_list_add_tail(&work->list, &acct->work_list);
 		return;
 	}
 
-	hash = io_get_work_hash(work);
+	hash = __io_get_work_hash(work_flags);
 	tail = wq->hash_tail[hash];
 	wq->hash_tail[hash] = work;
 	if (!tail)
@@ -943,8 +952,8 @@ static bool io_wq_work_match_item(struct io_wq_work *work, void *data)
 
 void io_wq_enqueue(struct io_wq *wq, struct io_wq_work *work)
 {
-	struct io_wq_acct *acct = io_work_get_acct(wq, work);
 	unsigned int work_flags = atomic_read(&work->flags);
+	struct io_wq_acct *acct = io_work_get_acct(wq, work_flags);
 	struct io_cb_cancel_data match = {
 		.fn		= io_wq_work_match_item,
 		.data		= work,
@@ -963,7 +972,7 @@ void io_wq_enqueue(struct io_wq *wq, struct io_wq_work *work)
 	}
 
 	raw_spin_lock(&acct->lock);
-	io_wq_insert_work(wq, acct, work);
+	io_wq_insert_work(wq, acct, work, work_flags);
 	clear_bit(IO_ACCT_STALLED_BIT, &acct->flags);
 	raw_spin_unlock(&acct->lock);
 
diff --git a/io_uring/io-wq.h b/io_uring/io-wq.h
index b3b004a7b6252..d4fb2940e435f 100644
--- a/io_uring/io-wq.h
+++ b/io_uring/io-wq.h
@@ -54,9 +54,14 @@ int io_wq_cpu_affinity(struct io_uring_task *tctx, cpumask_var_t mask);
 int io_wq_max_workers(struct io_wq *wq, int *new_count);
 bool io_wq_worker_stopped(void);
 
+static inline bool __io_wq_is_hashed(unsigned int work_flags)
+{
+	return work_flags & IO_WQ_WORK_HASHED;
+}
+
 static inline bool io_wq_is_hashed(struct io_wq_work *work)
 {
-	return atomic_read(&work->flags) & IO_WQ_WORK_HASHED;
+	return __io_wq_is_hashed(atomic_read(&work->flags));
 }
 
 typedef bool (work_cancel_fn)(struct io_wq_work *, void *);
-- 
2.39.5



