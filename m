Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0FFD246BB7;
	Mon, 27 Oct 2025 19:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593382; cv=none; b=srgK8ChlO3joRwN89M/BCWJymMO/r25KfEE54JpA+ZVuHRos1JNt5WziCOSlHmk0+rQzhD14T5/6f15HigWi+YhJFtASQAk45K4Gc6y9+4M0t+GBoz56kUpgnv/gimRxTMc0stHSfPyBcRYOWZc3A27qhk8Asg8TLdzd992Xvzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593382; c=relaxed/simple;
	bh=jAB3PGpaqrQ6MwHTVOuC1VCpg+YIttKFlMimoXGvvB4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=izDuxe168iOME9vNilWDH5XD2dSwApL20YRUWejV4EYW/swGRqht2bjcAbfSes1kObbuep+L4sEB4y/DyBLUBb7hR+/B5w6fd7EVTYtnJUskschtpiDxWSP5kNupKGJ2Ss0BfFdlp95tq/J7xHFVHpaSV/2t43VGWYibaMkLVeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YU+TOZDp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YU+TOZDp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3259EC4CEF1;
	Mon, 27 Oct 2025 19:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593382;
	bh=jAB3PGpaqrQ6MwHTVOuC1VCpg+YIttKFlMimoXGvvB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YU+TOZDp/k/w4wx9Fg7ZGlC/BLrkmmHlvEAvUxWsHdfwTky7pf3bQpnupEDApyMUa
	 zKLSOei8Qi/53yYYIcuqkcHwhX+eCWHUZRitR+3yMiRJ1gWztEGVltY79T5HgdimCK
	 yZxeMG7fe/3VRnkKvP1lQWAyvKNgVrwYebokbIKI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fengnan Chang <changfengnan@bytedance.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.17 070/184] io_uring/sqpoll: be smarter on when to update the stime usage
Date: Mon, 27 Oct 2025 19:35:52 +0100
Message-ID: <20251027183516.777035744@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

commit a94e0657269c5b8e1a90b17aa2c048b3d276e16d upstream.

The current approach is a bit naive, and hence calls the time querying
way too often. Only start the "doing work" timer when there's actual
work to do, and then use that information to terminate (and account) the
work time once done. This greatly reduces the frequency of these calls,
when they cannot have changed anyway.

Running a basic random reader that is setup to use SQPOLL, a profile
before this change shows these as the top cycle consumers:

+   32.60%  iou-sqp-1074  [kernel.kallsyms]  [k] thread_group_cputime_adjusted
+   19.97%  iou-sqp-1074  [kernel.kallsyms]  [k] thread_group_cputime
+   12.20%  io_uring      io_uring           [.] submitter_uring_fn
+    4.13%  iou-sqp-1074  [kernel.kallsyms]  [k] getrusage
+    2.45%  iou-sqp-1074  [kernel.kallsyms]  [k] io_submit_sqes
+    2.18%  iou-sqp-1074  [kernel.kallsyms]  [k] __pi_memset_generic
+    2.09%  iou-sqp-1074  [kernel.kallsyms]  [k] cputime_adjust

and after this change, top of profile looks as follows:

+   36.23%  io_uring     io_uring           [.] submitter_uring_fn
+   23.26%  iou-sqp-819  [kernel.kallsyms]  [k] io_sq_thread
+   10.14%  iou-sqp-819  [kernel.kallsyms]  [k] io_sq_tw
+    6.52%  iou-sqp-819  [kernel.kallsyms]  [k] tctx_task_work_run
+    4.82%  iou-sqp-819  [kernel.kallsyms]  [k] nvme_submit_cmds.part.0
+    2.91%  iou-sqp-819  [kernel.kallsyms]  [k] io_submit_sqes
[...]
     0.02%  iou-sqp-819  [kernel.kallsyms]  [k] cputime_adjust

where it's spending the cycles on things that actually matter.

Reported-by: Fengnan Chang <changfengnan@bytedance.com>
Cc: stable@vger.kernel.org
Fixes: 3fcb9d17206e ("io_uring/sqpoll: statistics of the true utilization of sq threads")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/sqpoll.c |   43 ++++++++++++++++++++++++++++++++-----------
 1 file changed, 32 insertions(+), 11 deletions(-)

--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -170,6 +170,11 @@ static inline bool io_sqd_events_pending
 	return READ_ONCE(sqd->state);
 }
 
+struct io_sq_time {
+	bool started;
+	u64 usec;
+};
+
 u64 io_sq_cpu_usec(struct task_struct *tsk)
 {
 	u64 utime, stime;
@@ -179,12 +184,24 @@ u64 io_sq_cpu_usec(struct task_struct *t
 	return stime;
 }
 
-static void io_sq_update_worktime(struct io_sq_data *sqd, u64 usec)
+static void io_sq_update_worktime(struct io_sq_data *sqd, struct io_sq_time *ist)
 {
-	sqd->work_time += io_sq_cpu_usec(current) - usec;
+	if (!ist->started)
+		return;
+	ist->started = false;
+	sqd->work_time += io_sq_cpu_usec(current) - ist->usec;
 }
 
-static int __io_sq_thread(struct io_ring_ctx *ctx, bool cap_entries)
+static void io_sq_start_worktime(struct io_sq_time *ist)
+{
+	if (ist->started)
+		return;
+	ist->started = true;
+	ist->usec = io_sq_cpu_usec(current);
+}
+
+static int __io_sq_thread(struct io_ring_ctx *ctx, struct io_sq_data *sqd,
+			  bool cap_entries, struct io_sq_time *ist)
 {
 	unsigned int to_submit;
 	int ret = 0;
@@ -197,6 +214,8 @@ static int __io_sq_thread(struct io_ring
 	if (to_submit || !wq_list_empty(&ctx->iopoll_list)) {
 		const struct cred *creds = NULL;
 
+		io_sq_start_worktime(ist);
+
 		if (ctx->sq_creds != current_cred())
 			creds = override_creds(ctx->sq_creds);
 
@@ -278,7 +297,6 @@ static int io_sq_thread(void *data)
 	unsigned long timeout = 0;
 	char buf[TASK_COMM_LEN] = {};
 	DEFINE_WAIT(wait);
-	u64 start;
 
 	/* offload context creation failed, just exit */
 	if (!current->io_uring) {
@@ -313,6 +331,7 @@ static int io_sq_thread(void *data)
 	mutex_lock(&sqd->lock);
 	while (1) {
 		bool cap_entries, sqt_spin = false;
+		struct io_sq_time ist = { };
 
 		if (io_sqd_events_pending(sqd) || signal_pending(current)) {
 			if (io_sqd_handle_event(sqd))
@@ -321,9 +340,8 @@ static int io_sq_thread(void *data)
 		}
 
 		cap_entries = !list_is_singular(&sqd->ctx_list);
-		start = io_sq_cpu_usec(current);
 		list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
-			int ret = __io_sq_thread(ctx, cap_entries);
+			int ret = __io_sq_thread(ctx, sqd, cap_entries, &ist);
 
 			if (!sqt_spin && (ret > 0 || !wq_list_empty(&ctx->iopoll_list)))
 				sqt_spin = true;
@@ -331,15 +349,18 @@ static int io_sq_thread(void *data)
 		if (io_sq_tw(&retry_list, IORING_TW_CAP_ENTRIES_VALUE))
 			sqt_spin = true;
 
-		list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
-			if (io_napi(ctx))
+		list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
+			if (io_napi(ctx)) {
+				io_sq_start_worktime(&ist);
 				io_napi_sqpoll_busy_poll(ctx);
+			}
+		}
+
+		io_sq_update_worktime(sqd, &ist);
 
 		if (sqt_spin || !time_after(jiffies, timeout)) {
-			if (sqt_spin) {
-				io_sq_update_worktime(sqd, start);
+			if (sqt_spin)
 				timeout = jiffies + sqd->sq_thread_idle;
-			}
 			if (unlikely(need_resched())) {
 				mutex_unlock(&sqd->lock);
 				cond_resched();


