Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F339F3BED6A;
	Sat, 12 Sep 2026 07:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197175; cv=none; b=DybU57kb6GNMMPd8rHc2baPxEelvjYlXRFv1Q3+Ca1BGlgf4vsTvcRSGKYA8U8HZcBTobrOEWpRgMlIp3Il/+RaF42ZoSaANnnoxHKw5FTbGGp6tHJvWbKpWfq1gmvJgSLEtQxuPAAcwvjhk00jTIJ73CYRY4PDEQnFCvBrd39M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197175; c=relaxed/simple;
	bh=9UmEWKtgdVEzNztCYIAlvFgEDR6nQg+ZQinDDnGPiGU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ki+hsqXI1SQE8EaKeXiVglpH6BgLBAsTUiyQB45YsBIe/pQW6aadgAIrf55wnUg1SuUXGr1NKk14t+zYi1hgVN6DWs2eee0xDyA+GnNn/ftaE0k8WOCdVHjWWVjg13xRT3JVaD0RQRJBTEXUfd/Fxp2CkYx3FQCjxf4MyEQcfBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t/8Q+VGy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t/8Q+VGy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA4B51F000FF;
	Sat, 12 Sep 2026 07:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197173;
	bh=5tiDbeOGEpLX3tKoVocJVp25YAXF0FzsBtOcAVE4a5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t/8Q+VGyTNGy+R7h16YnllIK/s3OGuA39NLI0zHmZ5jdOPcWI/pIbokhzBsv7psvf
	 solt/FgtGdb7aUywlDBHjGlNwgdoyLWVBRK3tTgSFQONMfz9u7Uh03ThX8GOrJ8G4G
	 PZC6QWZibYOaHDKmCbipoWyPX7o+A+KL0y1C3YxI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petr Mladek <pmladek@suse.com>,
	Breno Leitao <leitao@debian.org>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0116/1815] workqueue: only show running workers in stall diagnostics
Date: Sat, 12 Sep 2026 08:31:06 +0200
Message-ID: <20260912065651.731251427@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

[ Upstream commit 7ddfa24d3f12ab9f3ac0e0b4e8e573ff45574d86 ]

show_cpu_pool_busy_workers() dumps every in-flight worker in the pool's
busy_hash, including workers that are not currently running on the CPU.
Restore the task_is_running() filter so only running workers are dumped.

When no running worker is found the pool may be stuck, unable to wake an
idle worker to process pending work, and the watchdog would otherwise
give no feedback.  Add show_pool_no_running_worker() to report the pool
id, CPU, idle state, and worker counts in that case.

The pool info message is printed inside pool->lock using
printk_deferred_enter/exit, the same pattern used by the existing
busy-worker loop, to avoid deadlocks with console drivers that queue
work while holding locks also taken in their write paths.

This has been running on the Meta fleet for a while and caught some real
issues, for instance EFI stalls stalling the workqueue [1].

Link: https://lore.kernel.org/all/20260616-efi_timeout-v3-0-76dd1d26657b@debian.org/ [1]
Suggested-by: Petr Mladek <pmladek@suse.com>
Fixes: 8823eaef45da7 ("workqueue: Show all busy workers in stall diagnostics")
Reviewed-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Breno Leitao <leitao@debian.org>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/workqueue.c | 38 ++++++++++++++++++++++++++++++++++----
 1 file changed, 34 insertions(+), 4 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 78068ae8f28a6..929c04a9581bd 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -7689,13 +7689,31 @@ module_param_named(panic_on_stall_time, wq_panic_on_stall_time, uint, 0644);
 MODULE_PARM_DESC(panic_on_stall_time, "Panic if stall exceeds this many seconds (0=disabled)");
 
 /*
- * Show workers that might prevent the processing of pending work items.
- * A busy worker that is not running on the CPU (e.g. sleeping in
- * wait_event_idle() with PF_WQ_WORKER cleared) can stall the pool just as
- * effectively as a CPU-bound one, so dump every in-flight worker.
+ * Report that a pool has no worker in running state, which is a sign that the
+ * pool may be stuck. Print pool info. Must be called with pool->lock held and
+ * inside a printk_deferred_enter/exit region.
+ */
+static void show_pool_no_running_worker(struct worker_pool *pool)
+{
+	lockdep_assert_held(&pool->lock);
+
+	printk_deferred_enter();
+	pr_info("pool %d: no worker in running state, cpu=%d is %s (nr_workers=%d nr_idle=%d)\n",
+		pool->id, pool->cpu,
+		idle_cpu(pool->cpu) ? "idle" : "busy",
+		pool->nr_workers, pool->nr_idle);
+	pr_info("The pool might have trouble waking an idle worker.\n");
+	printk_deferred_exit();
+}
+
+/*
+ * Show running workers that might prevent the processing of pending work items.
+ * If no running worker is found, the pool may be stuck waiting for an idle
+ * worker to be woken, so report the pool state.
  */
 static void show_cpu_pool_busy_workers(struct worker_pool *pool)
 {
+	bool found_running = false;
 	struct worker *worker;
 	unsigned long irq_flags;
 	int bkt;
@@ -7703,6 +7721,11 @@ static void show_cpu_pool_busy_workers(struct worker_pool *pool)
 	raw_spin_lock_irqsave(&pool->lock, irq_flags);
 
 	hash_for_each(pool->busy_hash, bkt, worker, hentry) {
+		/* Skip workers that are not actively running on the CPU. */
+		if (!task_is_running(worker->task))
+			continue;
+
+		found_running = true;
 		/*
 		 * Defer printing to avoid deadlocks in console
 		 * drivers that queue work while holding locks
@@ -7716,6 +7739,13 @@ static void show_cpu_pool_busy_workers(struct worker_pool *pool)
 		printk_deferred_exit();
 	}
 
+	/*
+	 * If no running worker was found, the pool is likely stuck. Print pool
+	 * state.
+	 */
+	if (!found_running)
+		show_pool_no_running_worker(pool);
+
 	raw_spin_unlock_irqrestore(&pool->lock, irq_flags);
 }
 
-- 
2.53.0



