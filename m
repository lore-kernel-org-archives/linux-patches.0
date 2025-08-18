Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0854B3375D1;
	Mon, 18 Aug 2025 13:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525418; cv=none; b=eumdnSrKegzuIBO1RWwIpVFgPIxmjd0AsPhw9rM7Crnu6ZPKU7DahURki/eX4+CgwJHSef9ksOL4EKuxVV/cdNCropnnEla22hq0txsit+5aWYTRp34bDzURcV91OHQa4Ik+OsPLmD+yFHq3naHsuCMC2/9SRs92oTI9AqOL5/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525418; c=relaxed/simple;
	bh=r851sF/IXQ6nv1XShxIeoNNXQsYjrb/Ebi9qNlT0NEM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EYamvgAXfBIcF+enwrxyMkjeU29dR7/UMslWihkdg119GbF8JUzEXowjhxg2LJq7ZcvETjDO+yRotIBCX8Pz1iI3+htUKo1QTPYjaajk55MrwD3hvc2X+8vcZCyMlLnvttSQc1/r1qQywUxNu4NnZuKhVIqEMzKUGAkRv92pd78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TKwJDTJ/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TKwJDTJ/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15B9FC113D0;
	Mon, 18 Aug 2025 13:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525417;
	bh=r851sF/IXQ6nv1XShxIeoNNXQsYjrb/Ebi9qNlT0NEM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TKwJDTJ/IFl9NE3YbGdeG+fCxDGnjlXanIZegEunA6JkYZZ/JcWhMh9HF7k0ih5py
	 a6/bbtKoxXsHEkQvfv9PNJvfst0NeeRTMvtNcYgc862+GPXkukYK831+nko8DIkPLr
	 XVy34+/GTBDv8F0njsAxeGPGGPntwFmpifhVmIgI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tvrtko Ursulin <tvrtko.ursulin@igalia.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Philipp Stanner <phasta@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 256/570] drm/sched: Avoid memory leaks with cancel_job() callback
Date: Mon, 18 Aug 2025 14:44:03 +0200
Message-ID: <20250818124515.684210604@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Philipp Stanner <phasta@kernel.org>

[ Upstream commit bf8bbaefaa6ae0a07971ea57b3208df60e8ad0a4 ]

Since its inception, the GPU scheduler can leak memory if the driver
calls drm_sched_fini() while there are still jobs in flight.

The simplest way to solve this in a backwards compatible manner is by
adding a new callback, drm_sched_backend_ops.cancel_job(), which
instructs the driver to signal the hardware fence associated with the
job. Afterwards, the scheduler can safely use the established free_job()
callback for freeing the job.

Implement the new backend_ops callback cancel_job().

Suggested-by: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Link: https://lore.kernel.org/dri-devel/20250418113211.69956-1-tvrtko.ursulin@igalia.com/
Reviewed-by: Maíra Canal <mcanal@igalia.com>
Acked-by: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Signed-off-by: Philipp Stanner <phasta@kernel.org>
Link: https://lore.kernel.org/r/20250710125412.128476-4-phasta@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/scheduler/sched_main.c | 34 ++++++++++++++++----------
 include/drm/gpu_scheduler.h            | 18 ++++++++++++++
 2 files changed, 39 insertions(+), 13 deletions(-)

diff --git a/drivers/gpu/drm/scheduler/sched_main.c b/drivers/gpu/drm/scheduler/sched_main.c
index 829579c41c6b..3ac5e6acce04 100644
--- a/drivers/gpu/drm/scheduler/sched_main.c
+++ b/drivers/gpu/drm/scheduler/sched_main.c
@@ -1348,6 +1348,18 @@ int drm_sched_init(struct drm_gpu_scheduler *sched, const struct drm_sched_init_
 }
 EXPORT_SYMBOL(drm_sched_init);
 
+static void drm_sched_cancel_remaining_jobs(struct drm_gpu_scheduler *sched)
+{
+	struct drm_sched_job *job, *tmp;
+
+	/* All other accessors are stopped. No locking necessary. */
+	list_for_each_entry_safe_reverse(job, tmp, &sched->pending_list, list) {
+		sched->ops->cancel_job(job);
+		list_del(&job->list);
+		sched->ops->free_job(job);
+	}
+}
+
 /**
  * drm_sched_fini - Destroy a gpu scheduler
  *
@@ -1355,19 +1367,11 @@ EXPORT_SYMBOL(drm_sched_init);
  *
  * Tears down and cleans up the scheduler.
  *
- * This stops submission of new jobs to the hardware through
- * drm_sched_backend_ops.run_job(). Consequently, drm_sched_backend_ops.free_job()
- * will not be called for all jobs still in drm_gpu_scheduler.pending_list.
- * There is no solution for this currently. Thus, it is up to the driver to make
- * sure that:
- *
- *  a) drm_sched_fini() is only called after for all submitted jobs
- *     drm_sched_backend_ops.free_job() has been called or that
- *  b) the jobs for which drm_sched_backend_ops.free_job() has not been called
- *     after drm_sched_fini() ran are freed manually.
- *
- * FIXME: Take care of the above problem and prevent this function from leaking
- * the jobs in drm_gpu_scheduler.pending_list under any circumstances.
+ * This stops submission of new jobs to the hardware through &struct
+ * drm_sched_backend_ops.run_job. If &struct drm_sched_backend_ops.cancel_job
+ * is implemented, all jobs will be canceled through it and afterwards cleaned
+ * up through &struct drm_sched_backend_ops.free_job. If cancel_job is not
+ * implemented, memory could leak.
  */
 void drm_sched_fini(struct drm_gpu_scheduler *sched)
 {
@@ -1397,6 +1401,10 @@ void drm_sched_fini(struct drm_gpu_scheduler *sched)
 	/* Confirm no work left behind accessing device structures */
 	cancel_delayed_work_sync(&sched->work_tdr);
 
+	/* Avoid memory leaks if supported by the driver. */
+	if (sched->ops->cancel_job)
+		drm_sched_cancel_remaining_jobs(sched);
+
 	if (sched->own_submit_wq)
 		destroy_workqueue(sched->submit_wq);
 	sched->ready = false;
diff --git a/include/drm/gpu_scheduler.h b/include/drm/gpu_scheduler.h
index 1a7e377d4cbb..1eed74c7f2f7 100644
--- a/include/drm/gpu_scheduler.h
+++ b/include/drm/gpu_scheduler.h
@@ -508,6 +508,24 @@ struct drm_sched_backend_ops {
          * and it's time to clean it up.
 	 */
 	void (*free_job)(struct drm_sched_job *sched_job);
+
+	/**
+	 * @cancel_job: Used by the scheduler to guarantee remaining jobs' fences
+	 * get signaled in drm_sched_fini().
+	 *
+	 * Used by the scheduler to cancel all jobs that have not been executed
+	 * with &struct drm_sched_backend_ops.run_job by the time
+	 * drm_sched_fini() gets invoked.
+	 *
+	 * Drivers need to signal the passed job's hardware fence with an
+	 * appropriate error code (e.g., -ECANCELED) in this callback. They
+	 * must not free the job.
+	 *
+	 * The scheduler will only call this callback once it stopped calling
+	 * all other callbacks forever, with the exception of &struct
+	 * drm_sched_backend_ops.free_job.
+	 */
+	void (*cancel_job)(struct drm_sched_job *sched_job);
 };
 
 /**
-- 
2.39.5



