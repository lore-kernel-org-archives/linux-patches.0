Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CC78158215;
	Tue, 23 Jul 2024 18:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721760048; cv=none; b=jetrAYf6/VDnNSr2ivpp1r2CcpM1hZeqSoBljDwOP2/eFRHSh1d24wovfeyycCkw8jb3lEQCfNvSINj9lwG2v2UZoSUiPUyK4tkfll7z7V8MSUyBq0kMHNHwDl8ecc9YH86p9cGA5DhtC/Bcw4HYqfdP0iU/CA5bw3DlZ7aAGDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721760048; c=relaxed/simple;
	bh=87cDHmn0GemGl2ZjheRAE3D6EtsXCerFkoXfCVd1qPM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jhpkun3V30tvHoj9LR3QczR34Etd7Qt17GoSO/m0Yt3J2qbyPHORzsCqbWsfGFpdJP3sXgCvn46QhXgfuW7F24NTFw8xH8tfH3jdmraWSJ6sznh5Tw4Q95ngGU1ot9+jwXTBRIRkXvGv0LAWHlzOG5E4yF/qyF6DdHfQLxaGuVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LYM2+qeV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LYM2+qeV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AF7FC4AF0A;
	Tue, 23 Jul 2024 18:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721760047;
	bh=87cDHmn0GemGl2ZjheRAE3D6EtsXCerFkoXfCVd1qPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LYM2+qeVwGRbqe62TS7JUtcuxuNv0Q3PhP3Sb8GiwwyjnQDacBIP1/hUYlJEF4Rgv
	 gH/Ov93QU3IfQ1EbzbvljpFaOWRxhhyQ9IrUVkZCGPYLYYUC3Tcit6cUBgdkoLyQOq
	 UPgEl742n+ThqbFpmtsmFg3ItblS1LzEvKWJhkyE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>,
	Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 6.9 086/163] workqueue: Refactor worker ID formatting and make wq_worker_comm() use full ID string
Date: Tue, 23 Jul 2024 20:23:35 +0200
Message-ID: <20240723180146.799051237@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180143.461739294@linuxfoundation.org>
References: <20240723180143.461739294@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

[ Upstream commit 2a1b02bcba78f8498ab00d6142e1238d85b01591 ]

Currently, worker ID formatting is open coded in create_worker(),
init_rescuer() and worker_thread() (for %WORKER_DIE case). The formatted ID
is saved into task->comm and wq_worker_comm() uses it as the base name to
append extra information to when generating the name to be shown to
userspace.

However, TASK_COMM_LEN is only 16 leading to badly truncated names for
rescuers. For example, the rescuer for the inet_frag_wq workqueue becomes:

  $ ps -ef | grep '[k]worker/R-inet'
  root         483       2  0 Apr26 ?        00:00:00 [kworker/R-inet_]

Even for non-rescue workers, it's easy to run over 15 characters on
moderately large machines.

Fit it by consolidating worker ID formatting into a new helper
format_worker_id() and calling it from wq_worker_comm() to obtain the
untruncated worker ID string.

  $ ps -ef | grep '[k]worker/R-inet'
  root          60       2  0 12:10 ?        00:00:00 [kworker/R-inet_frag_wq]

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-and-tested-by: Jan Engelhardt <jengelh@inai.de>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/workqueue.c | 51 ++++++++++++++++++++++++++++++----------------
 1 file changed, 34 insertions(+), 17 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index d2dbe099286b9..7634fc32ee05a 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -124,6 +124,7 @@ enum wq_internal_consts {
 	HIGHPRI_NICE_LEVEL	= MIN_NICE,
 
 	WQ_NAME_LEN		= 32,
+	WORKER_ID_LEN		= 10 + WQ_NAME_LEN, /* "kworker/R-" + WQ_NAME_LEN */
 };
 
 /*
@@ -2778,6 +2779,26 @@ static void worker_detach_from_pool(struct worker *worker)
 		complete(detach_completion);
 }
 
+static int format_worker_id(char *buf, size_t size, struct worker *worker,
+			    struct worker_pool *pool)
+{
+	if (worker->rescue_wq)
+		return scnprintf(buf, size, "kworker/R-%s",
+				 worker->rescue_wq->name);
+
+	if (pool) {
+		if (pool->cpu >= 0)
+			return scnprintf(buf, size, "kworker/%d:%d%s",
+					 pool->cpu, worker->id,
+					 pool->attrs->nice < 0  ? "H" : "");
+		else
+			return scnprintf(buf, size, "kworker/u%d:%d",
+					 pool->id, worker->id);
+	} else {
+		return scnprintf(buf, size, "kworker/dying");
+	}
+}
+
 /**
  * create_worker - create a new workqueue worker
  * @pool: pool the new worker will belong to
@@ -2794,7 +2815,6 @@ static struct worker *create_worker(struct worker_pool *pool)
 {
 	struct worker *worker;
 	int id;
-	char id_buf[23];
 
 	/* ID is needed to determine kthread name */
 	id = ida_alloc(&pool->worker_ida, GFP_KERNEL);
@@ -2813,17 +2833,14 @@ static struct worker *create_worker(struct worker_pool *pool)
 	worker->id = id;
 
 	if (!(pool->flags & POOL_BH)) {
-		if (pool->cpu >= 0)
-			snprintf(id_buf, sizeof(id_buf), "%d:%d%s", pool->cpu, id,
-				 pool->attrs->nice < 0  ? "H" : "");
-		else
-			snprintf(id_buf, sizeof(id_buf), "u%d:%d", pool->id, id);
+		char id_buf[WORKER_ID_LEN];
 
+		format_worker_id(id_buf, sizeof(id_buf), worker, pool);
 		worker->task = kthread_create_on_node(worker_thread, worker,
-					pool->node, "kworker/%s", id_buf);
+						      pool->node, "%s", id_buf);
 		if (IS_ERR(worker->task)) {
 			if (PTR_ERR(worker->task) == -EINTR) {
-				pr_err("workqueue: Interrupted when creating a worker thread \"kworker/%s\"\n",
+				pr_err("workqueue: Interrupted when creating a worker thread \"%s\"\n",
 				       id_buf);
 			} else {
 				pr_err_once("workqueue: Failed to create a worker thread: %pe",
@@ -3386,7 +3403,6 @@ static int worker_thread(void *__worker)
 		raw_spin_unlock_irq(&pool->lock);
 		set_pf_worker(false);
 
-		set_task_comm(worker->task, "kworker/dying");
 		ida_free(&pool->worker_ida, worker->id);
 		worker_detach_from_pool(worker);
 		WARN_ON_ONCE(!list_empty(&worker->entry));
@@ -5430,6 +5446,7 @@ static int wq_clamp_max_active(int max_active, unsigned int flags,
 static int init_rescuer(struct workqueue_struct *wq)
 {
 	struct worker *rescuer;
+	char id_buf[WORKER_ID_LEN];
 	int ret;
 
 	if (!(wq->flags & WQ_MEM_RECLAIM))
@@ -5443,7 +5460,9 @@ static int init_rescuer(struct workqueue_struct *wq)
 	}
 
 	rescuer->rescue_wq = wq;
-	rescuer->task = kthread_create(rescuer_thread, rescuer, "kworker/R-%s", wq->name);
+	format_worker_id(id_buf, sizeof(id_buf), rescuer, NULL);
+
+	rescuer->task = kthread_create(rescuer_thread, rescuer, "%s", id_buf);
 	if (IS_ERR(rescuer->task)) {
 		ret = PTR_ERR(rescuer->task);
 		pr_err("workqueue: Failed to create a rescuer kthread for wq \"%s\": %pe",
@@ -6272,19 +6291,15 @@ void show_freezable_workqueues(void)
 /* used to show worker information through /proc/PID/{comm,stat,status} */
 void wq_worker_comm(char *buf, size_t size, struct task_struct *task)
 {
-	int off;
-
-	/* always show the actual comm */
-	off = strscpy(buf, task->comm, size);
-	if (off < 0)
-		return;
-
 	/* stabilize PF_WQ_WORKER and worker pool association */
 	mutex_lock(&wq_pool_attach_mutex);
 
 	if (task->flags & PF_WQ_WORKER) {
 		struct worker *worker = kthread_data(task);
 		struct worker_pool *pool = worker->pool;
+		int off;
+
+		off = format_worker_id(buf, size, worker, pool);
 
 		if (pool) {
 			raw_spin_lock_irq(&pool->lock);
@@ -6303,6 +6318,8 @@ void wq_worker_comm(char *buf, size_t size, struct task_struct *task)
 			}
 			raw_spin_unlock_irq(&pool->lock);
 		}
+	} else {
+		strscpy(buf, task->comm, size);
 	}
 
 	mutex_unlock(&wq_pool_attach_mutex);
-- 
2.43.0



