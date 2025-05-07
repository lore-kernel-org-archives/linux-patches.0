Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A57141E1DF6;
	Wed,  7 May 2025 19:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644753; cv=none; b=pYEjl4LNxZPA0ZJF6Kd895O0YtEfIcgdB9d6fZDqZM0ZrJZKbAIGtDfgekM07UUaOSZGvlXYpHAC1wlIlEI1NpEFI3B2dg6jiYarF9vqx1gSEvlSs4Z1ZbhVlSEzGK7iOjoOkLOkXxSztkT1/LoBluYCMPdTKewO3ZOhDp/g9Dw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644753; c=relaxed/simple;
	bh=rnBiFYLtN0v2z7nBrlzNtwIKFgWLaW1hn7td4eKpaHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m4eBXjxLhJhxQCJTjalT1hBixENvRmcr/EhqbD0muXH547lGUm+3QKioTD3z7Wk43aejJFUkubPDhDbcjV8PqwPE4PcaBUCBJAjw+26pmDfI/0vFrD5YeftgF8gdDsOapyl25eskQdb79qySfrF0Wp1TnkVq4TxSMAI33AG/Ozg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c7uKh9V6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c7uKh9V6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1630FC4CEE2;
	Wed,  7 May 2025 19:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644753;
	bh=rnBiFYLtN0v2z7nBrlzNtwIKFgWLaW1hn7td4eKpaHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c7uKh9V6WgWjblhksV9Yv9WnRoH5SofQjAO8XjjU+RvPWKKDM0dftpBnAbmdKcz6t
	 yfBV24UT74y79APLDrwSf3GSOchTwF0BBPML7Qfa6JkI9gJfiNjidUgGyw9R7jMm3d
	 tmUX2SQX9DM7HEN4aL4FPyMMcWPTDFCi+T7NbCHw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karol Wachowski <karol.wachowski@intel.com>,
	Maciej Falkowski <maciej.falkowski@linux.intel.com>,
	Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Subject: [PATCH 6.12 145/164] accel/ivpu: Fix locking order in ivpu_job_submit
Date: Wed,  7 May 2025 20:40:30 +0200
Message-ID: <20250507183826.839521546@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183820.781599563@linuxfoundation.org>
References: <20250507183820.781599563@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karol Wachowski <karol.wachowski@intel.com>

commit ab680dc6c78aa035e944ecc8c48a1caab9f39924 upstream.

Fix deadlock in job submission and abort handling.
When a thread aborts currently executing jobs due to a fault,
it first locks the global lock protecting submitted_jobs (#1).

After the last job is destroyed, it proceeds to release the related context
and locks file_priv (#2). Meanwhile, in the job submission thread,
the file_priv lock (#2) is taken first, and then the submitted_jobs
lock (#1) is obtained when a job is added to the submitted jobs list.

       CPU0                            CPU1
       ----                    	       ----
  (for example due to a fault)         (jobs submissions keep coming)

  lock(&vdev->submitted_jobs_lock) #1
  ivpu_jobs_abort_all()
  job_destroy()
                                      lock(&file_priv->lock)           #2
                                      lock(&vdev->submitted_jobs_lock) #1
  file_priv_release()
  lock(&vdev->context_list_lock)
  lock(&file_priv->lock)           #2

This order of locking causes a deadlock. To resolve this issue,
change the order of locking in ivpu_job_submit().

Signed-off-by: Karol Wachowski <karol.wachowski@intel.com>
Signed-off-by: Maciej Falkowski <maciej.falkowski@linux.intel.com>
Reviewed-by: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Signed-off-by: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20250107173238.381120-12-maciej.falkowski@linux.intel.com
[ This backport required small adjustments to ivpu_job_submit(), which
  lacks support for explicit command queue creation added in 6.15. ]
Signed-off-by: Jacek Lawrynowicz <jacek.lawrynowicz@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/accel/ivpu/ivpu_job.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

--- a/drivers/accel/ivpu/ivpu_job.c
+++ b/drivers/accel/ivpu/ivpu_job.c
@@ -535,6 +535,7 @@ static int ivpu_job_submit(struct ivpu_j
 	if (ret < 0)
 		return ret;
 
+	mutex_lock(&vdev->submitted_jobs_lock);
 	mutex_lock(&file_priv->lock);
 
 	cmdq = ivpu_cmdq_acquire(file_priv, job->engine_idx, priority);
@@ -542,11 +543,9 @@ static int ivpu_job_submit(struct ivpu_j
 		ivpu_warn_ratelimited(vdev, "Failed to get job queue, ctx %d engine %d prio %d\n",
 				      file_priv->ctx.id, job->engine_idx, priority);
 		ret = -EINVAL;
-		goto err_unlock_file_priv;
+		goto err_unlock;
 	}
 
-	mutex_lock(&vdev->submitted_jobs_lock);
-
 	is_first_job = xa_empty(&vdev->submitted_jobs_xa);
 	ret = xa_alloc_cyclic(&vdev->submitted_jobs_xa, &job->job_id, job, file_priv->job_limit,
 			      &file_priv->job_id_next, GFP_KERNEL);
@@ -554,7 +553,7 @@ static int ivpu_job_submit(struct ivpu_j
 		ivpu_dbg(vdev, JOB, "Too many active jobs in ctx %d\n",
 			 file_priv->ctx.id);
 		ret = -EBUSY;
-		goto err_unlock_submitted_jobs;
+		goto err_unlock;
 	}
 
 	ret = ivpu_cmdq_push_job(cmdq, job);
@@ -576,22 +575,20 @@ static int ivpu_job_submit(struct ivpu_j
 		 job->job_id, file_priv->ctx.id, job->engine_idx, priority,
 		 job->cmd_buf_vpu_addr, cmdq->jobq->header.tail);
 
-	mutex_unlock(&vdev->submitted_jobs_lock);
 	mutex_unlock(&file_priv->lock);
 
 	if (unlikely(ivpu_test_mode & IVPU_TEST_MODE_NULL_HW)) {
-		mutex_lock(&vdev->submitted_jobs_lock);
 		ivpu_job_signal_and_destroy(vdev, job->job_id, VPU_JSM_STATUS_SUCCESS);
-		mutex_unlock(&vdev->submitted_jobs_lock);
 	}
 
+	mutex_unlock(&vdev->submitted_jobs_lock);
+
 	return 0;
 
 err_erase_xa:
 	xa_erase(&vdev->submitted_jobs_xa, job->job_id);
-err_unlock_submitted_jobs:
+err_unlock:
 	mutex_unlock(&vdev->submitted_jobs_lock);
-err_unlock_file_priv:
 	mutex_unlock(&file_priv->lock);
 	ivpu_rpm_put(vdev);
 	return ret;


