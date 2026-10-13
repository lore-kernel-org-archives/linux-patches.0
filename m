Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 329C44FE2D1;
	Tue, 13 Oct 2026 11:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892739; cv=none; b=FFhtHztYwjm8d06nT9dunvTDgyvUINtwztZO54ijWgH8DQc2g9AO8q3373JcWQuocMYmb6Y6Dg1fSCZyz/KHY4Uf7cVZTOYNOgpf0Jr6mo6PBjVNyXrOx0kppMQ76GuJxzYokZhORQTeiNTHXRtJUcmgsVZ1UKbmRri142+RYd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892739; c=relaxed/simple;
	bh=AMb3HYHvkpi+FvFoE8peVijomfkxwqordeNAuoLQ5Y8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jjizymVDbbo8izoG48Eybm2fCd92lNeMz7J4TgLaW8mtZiBR66WRyWVaVk6WrwwG0P82hiShwL1TbCUsPAm+WxsU6h0yB7K7ksZeerBamugkmANm97sCr8hoLXS/1wDaEePbQLrOYjUhGzf1G8cPUd0AUYNCBA14eThuQ4PcpK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CdXIj5/b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CdXIj5/b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D9791F000FF;
	Tue, 13 Oct 2026 11:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892737;
	bh=oHmUmVm5nIhdZdZFaNlhTCEip6Jo+OH25kLhKBL+eM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CdXIj5/bFyLjVglTY7l38keT/WPCfkKH2JTsZlSA/ah0H6YYmUogWvNdGFqpYJlql
	 4Q6aiUUppIiGtctp5pxT22yvgPR5E+iMszXBrm60sJYxhONXBB9mzTW0+rD3jyc0uI
	 fgAvV7p0d5uXLhBA3EwW8umV+F2k1V2r14+0Y/D8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Iago Toral Quiroga <itoral@igalia.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 274/281] drm/vc4: Fix binner slot allocation failing on an idle GPU
Date: Tue, 13 Oct 2026 13:39:50 +0200
Message-ID: <20261013112901.787643028@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
User-Agent: quilt/0.69
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maíra Canal <mcanal@igalia.com>

[ Upstream commit cca01232d94adcb10f7c8c5bb8ce072b045fcb58 ]

A job's binner slots are returned to bin_alloc_used by vc4_complete_exec(),
which runs from the job_done workqueue, but the seqno
vc4_v3d_get_bin_slot() waits on is incremented earlier, in the function
vc4_irq_finish_render_job(). Therefore, a waiter can wake, retry, and still
find the pool full because the worker has not run. By then, the job might
have left the render_job_list, so no seqno remains to wait on and the
allocation fails returning -ENOMEM.

This scenario can be reproduced on a Raspberry Pi 3 by using a burst of
small jobs (e.g. Piglit's `quick_gl` suite), with userspace seeing a
rejected submit for a pool about to become free.

Note that the slots are held from validation until the render completes,
so the pool can also be exhausted by jobs still queued on bin_job_list,
leaving render_job_list empty and nothing to wait on.

Release the slots from the FRDONE handler and wait on the pool instead of
on one job's seqno. This bounds the wait to the actual resource. Also, by
claiming the slot inside the wait condition, another submit is unable to
take the slot between the wakeup and the retry. vc4_complete_exec() keeps
clearing the slots for jobs that never completed, and now wakes the
waiters too.

Note that the wait takes a deadline, since the two callers need different
ones. The submit path is a user task and can be interrupted, so it waits
without one. On the other hand, vc4_overflow_mem_work() runs on a worker
and never sees a signal, so it needs a deadline. During a reset,
vc4_irq_disable() masks V3D_DRIVER_IRQS before draining the worker, and
with those masked nothing can release a slot. This deadlocks: the worker
would wait for slots that only the reset can free, while the reset waits
in cancel_work_sync() for the worker.

Fixes: 553c942f8b2c ("drm/vc4: Allow using more than 256MB of CMA memory.")
Reviewed-by: Iago Toral Quiroga <itoral@igalia.com>
Link: https://patch.msgid.link/20260930182204.1877361-1-mcanal@igalia.com
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_drv.h      |  2 +-
 drivers/gpu/drm/vc4/vc4_gem.c      |  8 +++++-
 drivers/gpu/drm/vc4/vc4_irq.c      |  6 +++-
 drivers/gpu/drm/vc4/vc4_v3d.c      | 44 ++++++++++++++----------------
 drivers/gpu/drm/vc4/vc4_validate.c |  2 +-
 5 files changed, 34 insertions(+), 28 deletions(-)

diff --git a/drivers/gpu/drm/vc4/vc4_drv.h b/drivers/gpu/drm/vc4/vc4_drv.h
index 0f5958c1e6b60..b0e82c2dc1bae 100644
--- a/drivers/gpu/drm/vc4/vc4_drv.h
+++ b/drivers/gpu/drm/vc4/vc4_drv.h
@@ -1051,7 +1051,7 @@ void vc4_plane_async_set_fb(struct drm_plane *plane,
 /* vc4_v3d.c */
 extern struct platform_driver vc4_v3d_driver;
 extern const struct of_device_id vc4_v3d_dt_match[];
-int vc4_v3d_get_bin_slot(struct vc4_dev *vc4);
+int vc4_v3d_get_bin_slot(struct vc4_dev *vc4, long timeout);
 int vc4_v3d_bin_bo_get(struct vc4_dev *vc4, bool *used);
 void vc4_v3d_bin_bo_put(struct vc4_dev *vc4);
 int vc4_v3d_pm_get(struct vc4_dev *vc4);
diff --git a/drivers/gpu/drm/vc4/vc4_gem.c b/drivers/gpu/drm/vc4/vc4_gem.c
index e231c906709c1..6ee4bd77d4331 100644
--- a/drivers/gpu/drm/vc4/vc4_gem.c
+++ b/drivers/gpu/drm/vc4/vc4_gem.c
@@ -877,11 +877,17 @@ vc4_complete_exec(struct drm_device *dev, struct vc4_exec_info *exec)
 		drm_gem_object_put(&bo->base.base);
 	}
 
-	/* Free up the allocation of any bin slots we used. */
+	/* Free up the allocation of any bin slots we used. Jobs that ran to
+	 * completion had their slots released in vc4_irq_finish_render_job().
+	 * Only jobs that never completed still have slots to be released here.
+	 */
 	spin_lock_irqsave(&vc4->job_lock, irqflags);
 	vc4->bin_alloc_used &= ~exec->bin_slots;
 	spin_unlock_irqrestore(&vc4->job_lock, irqflags);
 
+	/* Let anyone waiting on the binner pool retry. */
+	wake_up_all(&vc4->job_wait_queue);
+
 	/* Release the reference on the binner BO if needed. */
 	if (exec->bin_bo_used)
 		vc4_v3d_bin_bo_put(vc4);
diff --git a/drivers/gpu/drm/vc4/vc4_irq.c b/drivers/gpu/drm/vc4/vc4_irq.c
index 98a8db7200917..dc10d3a4d90f2 100644
--- a/drivers/gpu/drm/vc4/vc4_irq.c
+++ b/drivers/gpu/drm/vc4/vc4_irq.c
@@ -74,7 +74,7 @@ vc4_overflow_mem_work(struct work_struct *work)
 
 	bo = vc4->bin_bo;
 
-	bin_bo_slot = vc4_v3d_get_bin_slot(vc4);
+	bin_bo_slot = vc4_v3d_get_bin_slot(vc4, msecs_to_jiffies(500));
 	if (bin_bo_slot < 0) {
 		drm_err(&vc4->base, "Couldn't allocate binner overflow mem\n");
 		goto complete;
@@ -165,6 +165,10 @@ vc4_irq_finish_render_job(struct drm_device *dev)
 	trace_vc4_rcl_end_irq(dev, exec->seqno);
 
 	vc4->finished_seqno++;
+
+	vc4->bin_alloc_used &= ~exec->bin_slots;
+	exec->bin_slots = 0;
+
 	list_move_tail(&exec->head, &vc4->job_done_list);
 
 	nextbin = vc4_first_bin_job(vc4);
diff --git a/drivers/gpu/drm/vc4/vc4_v3d.c b/drivers/gpu/drm/vc4/vc4_v3d.c
index 8ca0f4dde04bd..6844e8f3948cf 100644
--- a/drivers/gpu/drm/vc4/vc4_v3d.c
+++ b/drivers/gpu/drm/vc4/vc4_v3d.c
@@ -173,46 +173,42 @@ static void vc4_v3d_init_hw(struct drm_device *dev)
 	V3D_WRITE(V3D_VPMBASE, 0);
 }
 
-int vc4_v3d_get_bin_slot(struct vc4_dev *vc4)
+static int bin_slot_try_alloc(struct vc4_dev *vc4)
 {
-	struct drm_device *dev = &vc4->base;
-	unsigned long irqflags;
 	int slot;
-	uint64_t seqno = 0;
-	struct vc4_exec_info *exec;
 
-	if (WARN_ON_ONCE(vc4->gen > VC4_GEN_4))
-		return -ENODEV;
+	guard(spinlock_irqsave)(&vc4->job_lock);
 
-try_again:
-	spin_lock_irqsave(&vc4->job_lock, irqflags);
 	slot = ffs(~vc4->bin_alloc_used);
 	if (slot != 0) {
 		/* Switch from ffs() bit index to a 0-based index. */
 		slot--;
 		vc4->bin_alloc_used |= BIT(slot);
-		spin_unlock_irqrestore(&vc4->job_lock, irqflags);
-		return slot;
+	} else {
+		slot = -ENOMEM;
 	}
 
-	/* Couldn't find an open slot.  Wait for render to complete
-	 * and try again.
-	 */
-	exec = vc4_last_render_job(vc4);
-	if (exec)
-		seqno = exec->seqno;
-	spin_unlock_irqrestore(&vc4->job_lock, irqflags);
+	return slot;
+}
 
-	if (seqno) {
-		int ret = vc4_wait_for_seqno(dev, seqno, ~0ull, true);
+int vc4_v3d_get_bin_slot(struct vc4_dev *vc4, long timeout)
+{
+	int slot;
+	long ret;
 
-		if (ret == 0)
-			goto try_again;
+	if (WARN_ON_ONCE(vc4->gen > VC4_GEN_4))
+		return -ENODEV;
 
+	/* If the pool is full, wait for a job to release its slots. */
+	ret = wait_event_interruptible_timeout(vc4->job_wait_queue,
+					       (slot = bin_slot_try_alloc(vc4)) >= 0,
+					       timeout);
+	if (ret < 0)
 		return ret;
-	}
+	if (ret == 0)
+		return -ENOMEM;
 
-	return -ENOMEM;
+	return slot;
 }
 
 /*
diff --git a/drivers/gpu/drm/vc4/vc4_validate.c b/drivers/gpu/drm/vc4/vc4_validate.c
index d2a65c968b1f9..565227657b43b 100644
--- a/drivers/gpu/drm/vc4/vc4_validate.c
+++ b/drivers/gpu/drm/vc4/vc4_validate.c
@@ -402,7 +402,7 @@ validate_tile_binning_config(VALIDATE_ARGS)
 		return -EINVAL;
 	}
 
-	bin_slot = vc4_v3d_get_bin_slot(vc4);
+	bin_slot = vc4_v3d_get_bin_slot(vc4, MAX_SCHEDULE_TIMEOUT);
 	if (bin_slot < 0) {
 		if (bin_slot != -EINTR && bin_slot != -ERESTARTSYS) {
 			drm_err(dev, "Failed to allocate binner memory: %d\n",
-- 
2.53.0



