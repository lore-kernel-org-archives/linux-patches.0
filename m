Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48C6A32D0F7;
	Mon, 27 Oct 2025 19:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592994; cv=none; b=kirCjFHcnmhs7ySWq9RPXWURHsIxZMV6zNlY+SU3K2JesYFkMdkEFsSfLZMKZ/mn7pj9vgSn3q3iL8EyoHnJCj9qSoK5fEIMBU+Jzvllobc7HGB6VVYJUJ26h4lqvUxMdnVYElEtp1WKh9lZ/XaL/hkpzIvRoYDeP6wqg+6wsXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592994; c=relaxed/simple;
	bh=Y8fdf9uwZgoOJjFBsX7IM97N3K+71wiw+F0PM9Ig5Pc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iRClSh7X+agYd/K6NL0lze2GkzbDa9LkNOSxlhOE7zg+PdjNl/JtIi2cvzgjee0K8/ex3L3DnLa2tEJDpHGxgDIRWnZJTr3ZhAkLcJF+OcOyLbLUo51O6DH7WY+0tNxPIPWrtXkkXp0TP5D0sJGUrTZyJo4GdflXsTgYf6ng7io=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mNcCYJSa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mNcCYJSa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CCEEC4CEF1;
	Mon, 27 Oct 2025 19:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592993;
	bh=Y8fdf9uwZgoOJjFBsX7IM97N3K+71wiw+F0PM9Ig5Pc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mNcCYJSa0FXkcfqhtPLSxc+bl5cQMDMs8ooysoz5FniviJ3kKmMDh+3VLiWmgGc5Y
	 pRuwXFubFff7j1a/+CnO+xoyLz6EbgZjC/RUygiDwtJFph2XQOC+meVNwCf5NwZ77F
	 WkYQ9hMbkefCTrnjXVsytLrHhoOD0buHGxYetcgU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gabriel Krisman Bertazi <krisman@suse.de>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 090/117] io_uring/sqpoll: switch away from getrusage() for CPU accounting
Date: Mon, 27 Oct 2025 19:36:56 +0100
Message-ID: <20251027183456.457453898@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183453.919157109@linuxfoundation.org>
References: <20251027183453.919157109@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jens Axboe <axboe@kernel.dk>

Commit 8ac9b0d33e5c0a995338ee5f25fe1b6ff7d97f65 upstream.

getrusage() does a lot more than what the SQPOLL accounting needs, the
latter only cares about (and uses) the stime. Rather than do a full
RUSAGE_SELF summation, just query the used stime instead.

Cc: stable@vger.kernel.org
Fixes: 3fcb9d17206e ("io_uring/sqpoll: statistics of the true utilization of sq threads")
Reviewed-by: Gabriel Krisman Bertazi <krisman@suse.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/fdinfo.c |    8 ++++----
 io_uring/sqpoll.c |   32 ++++++++++++++++++--------------
 io_uring/sqpoll.h |    1 +
 3 files changed, 23 insertions(+), 18 deletions(-)

--- a/io_uring/fdinfo.c
+++ b/io_uring/fdinfo.c
@@ -55,7 +55,6 @@ __cold void io_uring_show_fdinfo(struct
 	struct io_ring_ctx *ctx = file->private_data;
 	struct io_overflow_cqe *ocqe;
 	struct io_rings *r = ctx->rings;
-	struct rusage sq_usage;
 	unsigned int sq_mask = ctx->sq_entries - 1, cq_mask = ctx->cq_entries - 1;
 	unsigned int sq_head = READ_ONCE(r->sq.head);
 	unsigned int sq_tail = READ_ONCE(r->sq.tail);
@@ -155,14 +154,15 @@ __cold void io_uring_show_fdinfo(struct
 		 * thread termination.
 		 */
 		if (tsk) {
+			u64 usec;
+
 			get_task_struct(tsk);
 			rcu_read_unlock();
-			getrusage(tsk, RUSAGE_SELF, &sq_usage);
+			usec = io_sq_cpu_usec(tsk);
 			put_task_struct(tsk);
 			sq_pid = sq->task_pid;
 			sq_cpu = sq->sq_cpu;
-			sq_total_time = (sq_usage.ru_stime.tv_sec * 1000000
-					 + sq_usage.ru_stime.tv_usec);
+			sq_total_time = usec;
 			sq_work_time = sq->work_time;
 		} else {
 			rcu_read_unlock();
--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -11,6 +11,7 @@
 #include <linux/audit.h>
 #include <linux/security.h>
 #include <linux/cpuset.h>
+#include <linux/sched/cputime.h>
 #include <linux/io_uring.h>
 
 #include <uapi/linux/io_uring.h>
@@ -175,6 +176,20 @@ static inline bool io_sqd_events_pending
 	return READ_ONCE(sqd->state);
 }
 
+u64 io_sq_cpu_usec(struct task_struct *tsk)
+{
+	u64 utime, stime;
+
+	task_cputime_adjusted(tsk, &utime, &stime);
+	do_div(stime, 1000);
+	return stime;
+}
+
+static void io_sq_update_worktime(struct io_sq_data *sqd, u64 usec)
+{
+	sqd->work_time += io_sq_cpu_usec(current) - usec;
+}
+
 static int __io_sq_thread(struct io_ring_ctx *ctx, bool cap_entries)
 {
 	unsigned int to_submit;
@@ -261,26 +276,15 @@ static bool io_sq_tw_pending(struct llis
 	return retry_list || !llist_empty(&tctx->task_list);
 }
 
-static void io_sq_update_worktime(struct io_sq_data *sqd, struct rusage *start)
-{
-	struct rusage end;
-
-	getrusage(current, RUSAGE_SELF, &end);
-	end.ru_stime.tv_sec -= start->ru_stime.tv_sec;
-	end.ru_stime.tv_usec -= start->ru_stime.tv_usec;
-
-	sqd->work_time += end.ru_stime.tv_usec + end.ru_stime.tv_sec * 1000000;
-}
-
 static int io_sq_thread(void *data)
 {
 	struct llist_node *retry_list = NULL;
 	struct io_sq_data *sqd = data;
 	struct io_ring_ctx *ctx;
-	struct rusage start;
 	unsigned long timeout = 0;
 	char buf[TASK_COMM_LEN];
 	DEFINE_WAIT(wait);
+	u64 start;
 
 	/* offload context creation failed, just exit */
 	if (!current->io_uring) {
@@ -323,7 +327,7 @@ static int io_sq_thread(void *data)
 		}
 
 		cap_entries = !list_is_singular(&sqd->ctx_list);
-		getrusage(current, RUSAGE_SELF, &start);
+		start = io_sq_cpu_usec(current);
 		list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
 			int ret = __io_sq_thread(ctx, cap_entries);
 
@@ -339,7 +343,7 @@ static int io_sq_thread(void *data)
 
 		if (sqt_spin || !time_after(jiffies, timeout)) {
 			if (sqt_spin) {
-				io_sq_update_worktime(sqd, &start);
+				io_sq_update_worktime(sqd, start);
 				timeout = jiffies + sqd->sq_thread_idle;
 			}
 			if (unlikely(need_resched())) {
--- a/io_uring/sqpoll.h
+++ b/io_uring/sqpoll.h
@@ -29,6 +29,7 @@ void io_sq_thread_unpark(struct io_sq_da
 void io_put_sq_data(struct io_sq_data *sqd);
 void io_sqpoll_wait_sq(struct io_ring_ctx *ctx);
 int io_sqpoll_wq_cpu_affinity(struct io_ring_ctx *ctx, cpumask_var_t mask);
+u64 io_sq_cpu_usec(struct task_struct *tsk);
 
 static inline struct task_struct *sqpoll_task_locked(struct io_sq_data *sqd)
 {


