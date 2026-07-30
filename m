Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CD2419CD1D;
	Thu, 30 Jul 2026 15:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425976; cv=none; b=fb5ZCnsFtQvnwvALQhzHaO/NYAU0HxM/4LhnPpFSuL7EKeRf/unCQI9mS4uYY6GqAnO5HCVSXiVmYxKUWU82940OWQiGK6gA0Lcb6mAidgHIL7MKiD7D6r+ghPuXLSDlNQY16K4L0mtfisvTwmp+PzT6nu71KsBxmbtk6gehR4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425976; c=relaxed/simple;
	bh=2Ybw8VWw6k5cNDnlhm6N9eFQNdSl07r7CxNJXBqAWPQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lZK5v9c7M33gWR5wd+MvEzcNLtJCCpOs+KQl8YGviO4VSYfcTs7G1+SEQ2VHyLlBxJ2gzimS7WiNRze2fYGzzM3yxASBLD/suaBKezODXE8cBPPPqo37e4OMxsyS2DGwr5fqQo/4GPkDl/484MFaMSrccxd0euXifAm9HfI2Juc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ps8l7IGY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ps8l7IGY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CD641F000E9;
	Thu, 30 Jul 2026 15:39:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425975;
	bh=jTrXBRWyAGV5T5PmTRdiqBlXuP4FZrShMPxozsLBxIg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ps8l7IGYc0fKIxbQgeOYRHk1GiHsUf/jPdEHrY3UaUCndgsdEG8pnsDTxa+JAKYRb
	 yUnV+agldzBCb+/siqiA5OY5C2hIBCUKg09+YF5kT8eZDE8yelq1IsbT/RZaZOue5u
	 TBWzpJHFsoRcANvBD2Pe3dnOOG23xMJJMY1rWJkM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alessio Belle <alessio.belle@imgtec.com>,
	Brajesh Gupta <brajesh.gupta@imgtec.com>,
	Matt Coster <matt.coster@imgtec.com>
Subject: [PATCH 6.12 257/602] drm/imagination: Fit paired fragment job in the correct CCCB
Date: Thu, 30 Jul 2026 16:10:49 +0200
Message-ID: <20260730141441.371336578@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

From: Alessio Belle <alessio.belle@imgtec.com>

commit 4baf9e70cb756d78dd56419f8baee2978a72d0c3 upstream.

For geometry jobs with a paired fragment job, at the moment, the
DRM scheduler's prepare_job() callback:

- checks for internal (driver) dependencies for the geometry job;
- calls into pvr_queue_get_paired_frag_job_dep() to check for external
  dependencies for the fragment job (the two jobs are submitted together
  but the common scheduler code doesn't know about it, so this needs to
  be done at this point in time);
- calls into the prepare_job() callback again, but for the fragment job,
  to check its internal dependencies as well, passing the fragment job's
  drm_sched_job and the geometry job's drm_sched_entity / pvr_queue.

The problem with the last step is that pvr_queue_prepare_job() doesn't
always take the mismatched fragment job and geometry queue into account,
in particular when checking whether there is space for the fragment
command to be submitted, so the code ends up checking for space in the
geometry (i.e. wrong) CCCB.
The rest of the nested prepare_job() callback happens to work fine at
the moment as the other internal dependencies are not relevant for a
paired fragment job.

Move the initialisation of a paired fragment job's done fence and CCCB
fence to pvr_queue_get_paired_frag_job_dep(), inferring the correct
queue from the fragment job itself.

This fixes cases where prepare_job() wrongly assumed that there was
enough space for a paired fragment job in its own CCCB, unblocking
run_job(), which then returned early without writing the full sequence
of commands to the CCCB.

The above lead to kernel warnings such as the following and potentially
job timeouts (depending on waiters on the missing commands):

  [  552.421075] WARNING: drivers/gpu/drm/imagination/pvr_cccb.c:178 at pvr_cccb_write_command_with_header+0x2c4/0x330 [powervr], CPU#2: kworker/u16:5/63
  [  552.421230] Modules linked in:
  [  552.421592] CPU: 2 UID: 0 PID: 63 Comm: kworker/u16:5 Tainted: G        W           7.0.0-rc2-gc5d053e4dccb #39 PREEMPT
  [  552.421625] Tainted: [W]=WARN
  [  552.421637] Hardware name: Texas Instruments AM625 SK (DT)
  [  552.421655] Workqueue: powervr-sched drm_sched_run_job_work [gpu_sched]
  [  552.421744] pstate: 80000005 (Nzcv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
  [  552.421766] pc : pvr_cccb_write_command_with_header+0x2c4/0x330 [powervr]
  [  552.421850] lr : pvr_queue_submit_job_to_cccb+0x57c/0xa74 [powervr]
  [  552.421923] sp : ffff800084c47650
  [  552.421936] x29: ffff800084c47740 x28: 0000000000000df8 x27: ffff800088a77000
  [  552.421979] x26: 0000000000000030 x25: ffff800084c47680 x24: 0000000000001000
  [  552.422017] x23: ffff800084c47820 x22: 1ffff00010988ecc x21: 0000000000000008
  [  552.422055] x20: 0000000000000208 x19: ffff000006ad5a88 x18: 0000000000000000
  [  552.422093] x17: 0000000020020000 x16: 0000000000020000 x15: 0000000000000000
  [  552.422130] x14: 0000000000000000 x13: 0000000000000000 x12: 0000000000000000
  [  552.422167] x11: 000000000000f2f2 x10: 00000000f3000000 x9 : 00000000f3f3f3f3
  [  552.422204] x8 : 00000000f2f2f200 x7 : ffff700010988ecc x6 : 0000000000000008
  [  552.422241] x5 : 0000000000000000 x4 : 1ffff0001114ee00 x3 : 0000000000000000
  [  552.422278] x2 : 0000000000000007 x1 : 0000000000000fff x0 : 000000000000002f
  [  552.422316] Call trace:
  [  552.422330]  pvr_cccb_write_command_with_header+0x2c4/0x330 [powervr] (P)
  [  552.422411]  pvr_queue_submit_job_to_cccb+0x57c/0xa74 [powervr]
  [  552.422486]  pvr_queue_run_job+0x3a4/0x990 [powervr]
  [  552.422562]  drm_sched_run_job_work+0x580/0xd48 [gpu_sched]
  [  552.422623]  process_one_work+0x520/0x1288
  [  552.422657]  worker_thread+0x3f0/0xb3c
  [  552.422679]  kthread+0x334/0x3d8
  [  552.422706]  ret_from_fork+0x10/0x20

Fixes: eaf01ee5ba28 ("drm/imagination: Implement job submission and scheduling")
Cc: stable@vger.kernel.org
Signed-off-by: Alessio Belle <alessio.belle@imgtec.com>
Reviewed-by: Brajesh Gupta <brajesh.gupta@imgtec.com>
Link: https://patch.msgid.link/20260330-job-submission-fixes-cleanup-v1-2-7de8c09cef8c@imgtec.com
Signed-off-by: Matt Coster <matt.coster@imgtec.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/imagination/pvr_queue.c |   32 ++++++++++++++------------------
 1 file changed, 14 insertions(+), 18 deletions(-)

--- a/drivers/gpu/drm/imagination/pvr_queue.c
+++ b/drivers/gpu/drm/imagination/pvr_queue.c
@@ -488,10 +488,11 @@ pvr_queue_get_job_kccb_fence(struct pvr_
 }
 
 static struct dma_fence *
-pvr_queue_get_paired_frag_job_dep(struct pvr_queue *queue, struct pvr_job *job)
+pvr_queue_get_paired_frag_job_dep(struct pvr_job *job)
 {
 	struct pvr_job *frag_job = job->type == DRM_PVR_JOB_TYPE_GEOMETRY ?
 				   job->paired_job : NULL;
+	struct pvr_queue *frag_queue = frag_job ? frag_job->ctx->queues.fragment : NULL;
 	struct dma_fence *f;
 	unsigned long index;
 
@@ -510,7 +511,10 @@ pvr_queue_get_paired_frag_job_dep(struct
 		return dma_fence_get(f);
 	}
 
-	return frag_job->base.sched->ops->prepare_job(&frag_job->base, &queue->entity);
+	/* Initialize the paired fragment job's done_fence, so we can signal it. */
+	pvr_queue_job_fence_init(frag_job->done_fence, frag_queue);
+
+	return pvr_queue_get_job_cccb_fence(frag_queue, frag_job);
 }
 
 /**
@@ -529,11 +533,6 @@ pvr_queue_prepare_job(struct drm_sched_j
 	struct pvr_queue *queue = container_of(s_entity, struct pvr_queue, entity);
 	struct dma_fence *internal_dep = NULL;
 
-	/*
-	 * Initialize the done_fence, so we can signal it. This must be done
-	 * here because otherwise by the time of run_job() the job will end up
-	 * in the pending list without a valid fence.
-	 */
 	if (job->type == DRM_PVR_JOB_TYPE_FRAGMENT && job->paired_job) {
 		/*
 		 * This will be called on a paired fragment job after being
@@ -543,18 +542,15 @@ pvr_queue_prepare_job(struct drm_sched_j
 		 */
 		if (job->paired_job->has_pm_ref)
 			return NULL;
-
-		/*
-		 * In this case we need to use the job's own ctx to initialise
-		 * the done_fence.  The other steps are done in the ctx of the
-		 * paired geometry job.
-		 */
-		pvr_queue_job_fence_init(job->done_fence,
-					 job->ctx->queues.fragment);
-	} else {
-		pvr_queue_job_fence_init(job->done_fence, queue);
 	}
 
+	/*
+	 * Initialize the done_fence, so we can signal it. This must be done
+	 * here because otherwise by the time of run_job() the job will end up
+	 * in the pending list without a valid fence.
+	 */
+	pvr_queue_job_fence_init(job->done_fence, queue);
+
 	/* CCCB fence is used to make sure we have enough space in the CCCB to
 	 * submit our commands.
 	 */
@@ -575,7 +571,7 @@ pvr_queue_prepare_job(struct drm_sched_j
 
 	/* The paired job fence should come last, when everything else is ready. */
 	if (!internal_dep)
-		internal_dep = pvr_queue_get_paired_frag_job_dep(queue, job);
+		internal_dep = pvr_queue_get_paired_frag_job_dep(job);
 
 	return internal_dep;
 }


