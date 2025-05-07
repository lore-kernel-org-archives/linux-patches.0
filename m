Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AC1B1482F5;
	Wed,  7 May 2025 18:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644294; cv=none; b=UnpDnm63/M9gqaYimILkICXZD/RMdo6VqpAoKBmBZdQXJZ6BVoFnykVZOlhiuaTXX0g2t6KVaxkTpIuKx2bxrxxqFtYilCdd8O4t1GfxJjohzJP0hy4CxLvm7r/lr7BGGygapQGeWSksI1bhTmhZXUja6RQeCZNlHGvQqw2B2FU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644294; c=relaxed/simple;
	bh=LsXJ1DezliJSE9OrabQBu+RvpgfmQW4iJIt0+uhZIwY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uZ1QyIp2XXuoTrM9bQPqczIVKtUFMEk009MyRPlMomY/nyqloBABKD2GoG8lqmdgRwPx3lEfCuXC/Ol0CB4Y6C0WUmg+WcOHKpK+yZci8VFEv90rdbq4wWrm3GB8nAzEgWxyINfwsh7/tCcNBiTL6c9o57fuDxoiU8wDDnrZ8zg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZTtaR6pG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZTtaR6pG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6321C4CEE2;
	Wed,  7 May 2025 18:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644294;
	bh=LsXJ1DezliJSE9OrabQBu+RvpgfmQW4iJIt0+uhZIwY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZTtaR6pGfxJ+2VLiaaE2SWvG2xrfogJCve3A9EeKnENjfHEW8PG5vnXFbeyPqLOcw
	 bGWsZ8FiSLKAYRSv4NQaV7eWKWi9P7EyDtvM14jWR0yjjX9nSLw9dPYsP3mULQwxc6
	 rXtB6kscrZmuAWP0dsjTzVq1mf6RviUfEJcH47mk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karol Wachowski <karol.wachowski@intel.com>,
	Maciej Falkowski <maciej.falkowski@linux.intel.com>,
	Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Subject: [PATCH 6.14 151/183] accel/ivpu: Add handling of VPU_JSM_STATUS_MVNCI_CONTEXT_VIOLATION_HW
Date: Wed,  7 May 2025 20:39:56 +0200
Message-ID: <20250507183830.980109086@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183824.682671926@linuxfoundation.org>
References: <20250507183824.682671926@linuxfoundation.org>
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

From: Karol Wachowski <karol.wachowski@intel.com>

commit dad945c27a42dfadddff1049cf5ae417209a8996 upstream.

Mark as invalid context of a job that returned HW context violation
error and queue work that aborts jobs from faulty context.
Add engine reset to the context abort thread handler to not only abort
currently executing jobs but also to ensure NPU invalid state recovery.

Signed-off-by: Karol Wachowski <karol.wachowski@intel.com>
Signed-off-by: Maciej Falkowski <maciej.falkowski@linux.intel.com>
Reviewed-by: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Signed-off-by: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250107173238.381120-13-maciej.falkowski@linux.intel.com
Signed-off-by: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/accel/ivpu/ivpu_job.c |   25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

--- a/drivers/accel/ivpu/ivpu_job.c
+++ b/drivers/accel/ivpu/ivpu_job.c
@@ -482,6 +482,26 @@ static int ivpu_job_signal_and_destroy(s
 
 	lockdep_assert_held(&vdev->submitted_jobs_lock);
 
+	job = xa_load(&vdev->submitted_jobs_xa, job_id);
+	if (!job)
+		return -ENOENT;
+
+	if (job_status == VPU_JSM_STATUS_MVNCI_CONTEXT_VIOLATION_HW) {
+		guard(mutex)(&job->file_priv->lock);
+
+		if (job->file_priv->has_mmu_faults)
+			return 0;
+
+		/*
+		 * Mark context as faulty and defer destruction of the job to jobs abort thread
+		 * handler to synchronize between both faults and jobs returning context violation
+		 * status and ensure both are handled in the same way
+		 */
+		job->file_priv->has_mmu_faults = true;
+		queue_work(system_wq, &vdev->context_abort_work);
+		return 0;
+	}
+
 	job = ivpu_job_remove_from_submitted_jobs(vdev, job_id);
 	if (!job)
 		return -ENOENT;
@@ -793,6 +813,9 @@ void ivpu_context_abort_thread_handler(s
 	struct ivpu_job *job;
 	unsigned long id;
 
+	if (vdev->fw->sched_mode == VPU_SCHEDULING_MODE_HW)
+		ivpu_jsm_reset_engine(vdev, 0);
+
 	mutex_lock(&vdev->context_list_lock);
 	xa_for_each(&vdev->context_xa, ctx_id, file_priv) {
 		if (!file_priv->has_mmu_faults || file_priv->aborted)
@@ -806,6 +829,8 @@ void ivpu_context_abort_thread_handler(s
 
 	if (vdev->fw->sched_mode != VPU_SCHEDULING_MODE_HW)
 		return;
+
+	ivpu_jsm_hws_resume_engine(vdev, 0);
 	/*
 	 * In hardware scheduling mode NPU already has stopped processing jobs
 	 * and won't send us any further notifications, thus we have to free job related resources


