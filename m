Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09EE75C8F7;
	Tue,  3 Dec 2024 15:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240633; cv=none; b=G8wuWp18ZXlZZ+KDIcRZxpBcyGt4ypxqkvLZVkKI+TcSfoQQaigi1ikR2ruz646alXpgP31BEyIb2qBQv4ZRX29fE7vfxa8awwNYRewYGe/stc9JO9H8rRyfEb5MS2K+2JRX3OMDCGscKwrRrFxyt81RbHOG9eiB2qTRT64DDNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240633; c=relaxed/simple;
	bh=QObZRz0Sdqu4XZRC819SMsuPKCblmHGgwFxFq9djUkU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=O2oM62efhu0OUsWECqY+52lbTWjlUfG7ljWuEYcoUdueyicUV+tMgADWbkKUUG1jWclYAgQFEAmK5Xw08qJbrQISD/Q8Cqz0ViT9cXzynoaWXd6oMQ1xaQSHBl5YPZg+1sy+JJa3BpAwvrP8HJlunnKxg+kyOkNqk2ywcIL6UrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y8dfEcZm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y8dfEcZm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77304C4CECF;
	Tue,  3 Dec 2024 15:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240632;
	bh=QObZRz0Sdqu4XZRC819SMsuPKCblmHGgwFxFq9djUkU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y8dfEcZmacIkG/ZXS9XLIMGE6FT+mnSeL2XR+UHdD5FmJGaFhncCXMgI9FpcBDRwk
	 rpwQBkqqclq5HqkuOIH6NbdnePEYvoSSdzBH/QwNwXsjtU/8I93TZ5bsBSzfu/BLzG
	 vf4l2IJ3NtqMUF2N0vxCBbt+iL4q0H15/xJ5I9UE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Tvrtko Ursulin <tvrtko.ursulin@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 192/826] drm/v3d: Appease lockdep while updating GPU stats
Date: Tue,  3 Dec 2024 15:38:39 +0100
Message-ID: <20241203144751.235874302@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>

[ Upstream commit 06c3c406850e5495bb56ccf624d0c9477e1ba901 ]

Lockdep thinks our seqcount_t usage is unsafe because the update path can
be both from irq and worker context:

 [ ] ================================
 [ ] WARNING: inconsistent lock state
 [ ] 6.10.3-v8-16k-numa #159 Tainted: G        WC
 [ ] --------------------------------
 [ ] inconsistent {HARDIRQ-ON-W} -> {IN-HARDIRQ-W} usage.
 [ ] swapper/0/0 [HC1[1]:SC0[0]:HE0:SE1] takes:
 [ ] ffff80003d7c08d0 (&v3d_priv->stats[i].lock){?.+.}-{0:0}, at: v3d_irq+0xc8/0x660 [v3d]
 [ ] {HARDIRQ-ON-W} state was registered at:
 [ ]   lock_acquire+0x1f8/0x328
 [ ]   v3d_job_start_stats.isra.0+0xd8/0x218 [v3d]
 [ ]   v3d_bin_job_run+0x23c/0x388 [v3d]
 [ ]   drm_sched_run_job_work+0x520/0x6d0 [gpu_sched]
 [ ]   process_one_work+0x62c/0xb48
 [ ]   worker_thread+0x468/0x5b0
 [ ]   kthread+0x1c4/0x1e0
 [ ]   ret_from_fork+0x10/0x20
 [ ] irq event stamp: 337094
 [ ] hardirqs last  enabled at (337093): [<ffffc0008144ce7c>] default_idle_call+0x11c/0x140
 [ ] hardirqs last disabled at (337094): [<ffffc0008144a354>] el1_interrupt+0x24/0x58
 [ ] softirqs last  enabled at (337082): [<ffffc00080061d90>] handle_softirqs+0x4e0/0x538
 [ ] softirqs last disabled at (337073): [<ffffc00080010364>] __do_softirq+0x1c/0x28
 [ ]
                other info that might help us debug this:
 [ ]  Possible unsafe locking scenario:

 [ ]        CPU0
 [ ]        ----
 [ ]   lock(&v3d_priv->stats[i].lock);
 [ ]   <Interrupt>
 [ ]     lock(&v3d_priv->stats[i].lock);
 [ ]
                *** DEADLOCK ***

 [ ] no locks held by swapper/0/0.
 [ ]
               stack backtrace:
 [ ] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G        WC         6.10.3-v8-16k-numa #159
 [ ] Hardware name: Raspberry Pi 5 Model B Rev 1.0 (DT)
 [ ] Call trace:
 [ ]  dump_backtrace+0x170/0x1b8
 [ ]  show_stack+0x20/0x38
 [ ]  dump_stack_lvl+0xb4/0xd0
 [ ]  dump_stack+0x18/0x28
 [ ]  print_usage_bug+0x3cc/0x3f0
 [ ]  mark_lock+0x4d0/0x968
 [ ]  __lock_acquire+0x784/0x18c8
 [ ]  lock_acquire+0x1f8/0x328
 [ ]  v3d_job_update_stats+0xec/0x2e0 [v3d]
 [ ]  v3d_irq+0xc8/0x660 [v3d]
 [ ]  __handle_irq_event_percpu+0x1f8/0x488
 [ ]  handle_irq_event+0x88/0x128
 [ ]  handle_fasteoi_irq+0x298/0x408
 [ ]  generic_handle_domain_irq+0x50/0x78

But it is a false positive because all the queue-stats pairs have their
own lock and jobs are also one at a time.

Nevertheless we can appease lockdep by disabling local interrupts to make
it see lock usage is consistent.

Cc: Maíra Canal <mcanal@igalia.com>
Fixes: 6abe93b621ab ("drm/v3d: Fix race-condition between sysfs/fdinfo and interrupt handler")
Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240813102505.80512-2-tursulin@igalia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/v3d/v3d_sched.c | 46 +++++++++++++++++++++++++++++----
 1 file changed, 41 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/v3d/v3d_sched.c b/drivers/gpu/drm/v3d/v3d_sched.c
index 08d2a27395828..4f935f1d50a94 100644
--- a/drivers/gpu/drm/v3d/v3d_sched.c
+++ b/drivers/gpu/drm/v3d/v3d_sched.c
@@ -135,8 +135,31 @@ v3d_job_start_stats(struct v3d_job *job, enum v3d_queue queue)
 	struct v3d_stats *global_stats = &v3d->queue[queue].stats;
 	struct v3d_stats *local_stats = &file->stats[queue];
 	u64 now = local_clock();
-
-	preempt_disable();
+	unsigned long flags;
+
+	/*
+	 * We only need to disable local interrupts to appease lockdep who
+	 * otherwise would think v3d_job_start_stats vs v3d_stats_update has an
+	 * unsafe in-irq vs no-irq-off usage problem. This is a false positive
+	 * because all the locks are per queue and stats type, and all jobs are
+	 * completely one at a time serialised. More specifically:
+	 *
+	 * 1. Locks for GPU queues are updated from interrupt handlers under a
+	 *    spin lock and started here with preemption disabled.
+	 *
+	 * 2. Locks for CPU queues are updated from the worker with preemption
+	 *    disabled and equally started here with preemption disabled.
+	 *
+	 * Therefore both are consistent.
+	 *
+	 * 3. Because next job can only be queued after the previous one has
+	 *    been signaled, and locks are per queue, there is also no scope for
+	 *    the start part to race with the update part.
+	 */
+	if (IS_ENABLED(CONFIG_LOCKDEP))
+		local_irq_save(flags);
+	else
+		preempt_disable();
 
 	write_seqcount_begin(&local_stats->lock);
 	local_stats->start_ns = now;
@@ -146,7 +169,10 @@ v3d_job_start_stats(struct v3d_job *job, enum v3d_queue queue)
 	global_stats->start_ns = now;
 	write_seqcount_end(&global_stats->lock);
 
-	preempt_enable();
+	if (IS_ENABLED(CONFIG_LOCKDEP))
+		local_irq_restore(flags);
+	else
+		preempt_enable();
 }
 
 static void
@@ -167,11 +193,21 @@ v3d_job_update_stats(struct v3d_job *job, enum v3d_queue queue)
 	struct v3d_stats *global_stats = &v3d->queue[queue].stats;
 	struct v3d_stats *local_stats = &file->stats[queue];
 	u64 now = local_clock();
+	unsigned long flags;
+
+	/* See comment in v3d_job_start_stats() */
+	if (IS_ENABLED(CONFIG_LOCKDEP))
+		local_irq_save(flags);
+	else
+		preempt_disable();
 
-	preempt_disable();
 	v3d_stats_update(local_stats, now);
 	v3d_stats_update(global_stats, now);
-	preempt_enable();
+
+	if (IS_ENABLED(CONFIG_LOCKDEP))
+		local_irq_restore(flags);
+	else
+		preempt_enable();
 }
 
 static struct dma_fence *v3d_bin_job_run(struct drm_sched_job *sched_job)
-- 
2.43.0



