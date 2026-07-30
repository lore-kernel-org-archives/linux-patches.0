Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 612BE43E48C;
	Thu, 30 Jul 2026 15:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424234; cv=none; b=j7bNnZyW/NUs0g3MKopPrmaEstWtpMn/Qq28oOpLTJZAQZdEWFwuwL+fDqjNmlfVEpWEk2EH07m6FE3b2VXE1DHml2b5F5A0WK0T5qLdHwTNr7rjYX1kd9Eg7c+4NN4E3QlpQNNbMZnyIjxvEXkNIkMcxJc6b+6hxG3pU6HhtDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424234; c=relaxed/simple;
	bh=6NFO0ZNoo2tnkObzsaJrC964rRqdY16n316oT4hUzdk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d7g2JNgvYTb9X7QiwjWCH7R8XpuG2nW191uKoU5NSxIZ3itG3umwzO50c7oQTiHclAPnNhuwL4x7uHJA+regYfIGS1IxNQTDkWD0nUEWbluMGk1NN3QNEWP7Qc30wtFYvv1QVosnd/8ouApx0W96cm1ZRSG+BRoaZc92nZdK04A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zrc/WXgG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zrc/WXgG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF8E71F000E9;
	Thu, 30 Jul 2026 15:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424233;
	bh=B4tz2jBDmw5RLMERy8M6rmQtgV1Dtu1pZ8NcQwB9lXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zrc/WXgG72vUrzqSSXlGR9IQqblkx5yt3sWlJrMcORcf3965+fIW9RDkOOCQVmL3t
	 dCXQ8ir1xmiPL94tgQc5sa/YNTqq9caTSHwFuf4PDBQjHE+Xlh7y3RC1oYxLBwQxzd
	 4/70KyiicGX2aycBVkSWqSLCn7kHl5wARf96v6iA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alessio Belle <alessio.belle@imgtec.com>,
	Brajesh Gupta <brajesh.gupta@imgtec.com>,
	Matt Coster <matt.coster@imgtec.com>
Subject: [PATCH 6.18 323/675] drm/imagination: Count paired job fence as dependency in prepare_job()
Date: Thu, 30 Jul 2026 16:10:53 +0200
Message-ID: <20260730141451.990965019@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alessio Belle <alessio.belle@imgtec.com>

commit 9cd74f935306cd857f46686975c43383e1d95f94 upstream.

The DRM scheduler's prepare_job() callback counts the remaining
non-signaled native dependencies for a job, preventing job submission
until those (plus job data and fence update) can fit in the job queue's
CCCB.

This means checking which dependencies can be waited upon in the
firmware, i.e. whether they are backed by a UFO object, i.e. whether
their drm_sched_fence::parent has been assigned to a
pvr_queue_fence::base fence. That happens when the job owning the fence
is submitted to the firmware.

Paired geometry and fragment jobs are submitted at the same time, which
means the dependency between them can't be checked this way before
submission.

Update job_count_remaining_native_deps() to take into account the
dependency between paired jobs.

This fixes cases where prepare_job() underestimated the space left in
an almost full fragment CCCB, wrongly unblocking run_job(), which then
returned early without writing the full sequence of commands to the
CCCB.

The above lead to kernel warnings such as the following and potentially
job timeouts (depending on waiters on the missing commands):

  [  375.702979] WARNING: drivers/gpu/drm/imagination/pvr_cccb.c:178 at pvr_cccb_write_command_with_header+0x2c4/0x330 [powervr], CPU#1: kworker/u16:3/47
  [  375.703160] Modules linked in:
  [  375.703571] CPU: 1 UID: 0 PID: 47 Comm: kworker/u16:3 Tainted: G        W           7.0.0-rc2-g817eb6b11ad5 #40 PREEMPT
  [  375.703613] Tainted: [W]=WARN
  [  375.703627] Hardware name: Texas Instruments AM625 SK (DT)
  [  375.703645] Workqueue: powervr-sched drm_sched_run_job_work [gpu_sched]
  [  375.703741] pstate: 80000005 (Nzcv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
  [  375.703764] pc : pvr_cccb_write_command_with_header+0x2c4/0x330 [powervr]
  [  375.703847] lr : pvr_queue_submit_job_to_cccb+0x578/0xa70 [powervr]
  [  375.703921] sp : ffff800084a97650
  [  375.703934] x29: ffff800084a97740 x28: 0000000000000958 x27: ffff80008565d000
  [  375.703979] x26: 0000000000000030 x25: ffff800084a97680 x24: 0000000000001000
  [  375.704017] x23: ffff800084a97820 x22: 1ffff00010952ecc x21: 0000000000000008
  [  375.704056] x20: 00000000000006a8 x19: ffff00002ff7da88 x18: 0000000000000000
  [  375.704093] x17: 0000000020020000 x16: 0000000000020000 x15: 0000000000000000
  [  375.704132] x14: 0000000000000000 x13: 0000000000000000 x12: 0000000000000000
  [  375.704168] x11: 000000000000f2f2 x10: 00000000f3000000 x9 : 00000000f3f3f3f3
  [  375.704206] x8 : 00000000f2f2f200 x7 : ffff700010952ecc x6 : 0000000000000008
  [  375.704243] x5 : 0000000000000000 x4 : 1ffff00010acba00 x3 : 0000000000000000
  [  375.704279] x2 : 0000000000000007 x1 : 0000000000000fff x0 : 000000000000002f
  [  375.704317] Call trace:
  [  375.704331]  pvr_cccb_write_command_with_header+0x2c4/0x330 [powervr] (P)
  [  375.704411]  pvr_queue_submit_job_to_cccb+0x578/0xa70 [powervr]
  [  375.704487]  pvr_queue_run_job+0x3a4/0x990 [powervr]
  [  375.704562]  drm_sched_run_job_work+0x580/0xd48 [gpu_sched]
  [  375.704623]  process_one_work+0x520/0x1288
  [  375.704658]  worker_thread+0x3f0/0xb3c
  [  375.704680]  kthread+0x334/0x3d8
  [  375.704706]  ret_from_fork+0x10/0x20
  [  375.704736] ---[ end trace 0000000000000000 ]---

Fixes: eaf01ee5ba28 ("drm/imagination: Implement job submission and scheduling")
Cc: stable@vger.kernel.org
Signed-off-by: Alessio Belle <alessio.belle@imgtec.com>
Reviewed-by: Brajesh Gupta <brajesh.gupta@imgtec.com>
Link: https://patch.msgid.link/20260330-job-submission-fixes-cleanup-v1-1-7de8c09cef8c@imgtec.com
Signed-off-by: Matt Coster <matt.coster@imgtec.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/imagination/pvr_queue.c |   27 +++++++++++++++++++++++----
 1 file changed, 23 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/imagination/pvr_queue.c
+++ b/drivers/gpu/drm/imagination/pvr_queue.c
@@ -179,7 +179,7 @@ static const struct dma_fence_ops pvr_qu
 
 /**
  * to_pvr_queue_job_fence() - Return a pvr_queue_fence object if the fence is
- * backed by a UFO.
+ * already backed by a UFO.
  * @f: The dma_fence to turn into a pvr_queue_fence.
  *
  * Return:
@@ -356,6 +356,15 @@ static u32 job_cmds_size(struct pvr_job
 	       pvr_cccb_get_size_of_cmd_with_hdr(job->cmd_len);
 }
 
+static bool
+is_paired_job_fence(struct dma_fence *fence, struct pvr_job *job)
+{
+	/* This assumes "fence" is one of "job"'s drm_sched_job::dependencies */
+	return job->type == DRM_PVR_JOB_TYPE_FRAGMENT &&
+	       job->paired_job &&
+	       &job->paired_job->base.s_fence->scheduled == fence;
+}
+
 /**
  * job_count_remaining_native_deps() - Count the number of non-signaled native dependencies.
  * @job: Job to operate on.
@@ -371,6 +380,17 @@ static unsigned long job_count_remaining
 	xa_for_each(&job->base.dependencies, index, fence) {
 		struct pvr_queue_fence *jfence;
 
+		if (is_paired_job_fence(fence, job)) {
+			/*
+			 * A fence between paired jobs won't resolve to a pvr_queue_fence (i.e.
+			 * be backed by a UFO) until the jobs have been submitted, together.
+			 * The submitting code will insert a partial render fence command for this.
+			 */
+			WARN_ON(dma_fence_is_signaled(fence));
+			remaining_count++;
+			continue;
+		}
+
 		jfence = to_pvr_queue_job_fence(fence);
 		if (!jfence)
 			continue;
@@ -630,9 +650,8 @@ static void pvr_queue_submit_job_to_cccb
 		if (!jfence)
 			continue;
 
-		/* Skip the partial render fence, we will place it at the end. */
-		if (job->type == DRM_PVR_JOB_TYPE_FRAGMENT && job->paired_job &&
-		    &job->paired_job->base.s_fence->scheduled == fence)
+		/* This fence will be placed last, as partial render fence. */
+		if (is_paired_job_fence(fence, job))
 			continue;
 
 		if (dma_fence_is_signaled(&jfence->base))


