Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB2582EF9CD;
	Thu,  3 Jul 2025 15:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555318; cv=none; b=F9CW/YLE6wk15S//V86aWFr5lHq0PvxNLVHvQk1jWNE8IrnisbJXrJvvCPApuLoaT9fYX9l6Tyv/FvyuItY4KEvxHn1PJeo0ZEG9DtGXyaYdNVxjbtYMHUGYchiEDQcorLLIOJxwJfyRiLyXU68wBqP0In3tXq3AGQ6FerTf360=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555318; c=relaxed/simple;
	bh=L9pdv8tBhkiaCY/O7L6U8vqU2kp0QLWQ58Cv9ijMMnU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FPlPVGRf4nPUOiKSCxeNHrqB1fLLAWUgUFszd5GxebWSIbFGejP5HPkcF2iFS9LlM3hnRCK71yRwcdgaIBLBVgRGma6mja1TtBkOkmURX5vU3yZAuwMDo+qpYN8AED+/+FzX1boehuAdR/n+03CpGtFmJbYqxBM3Y5kYBpR6FjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L2ehCtCj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L2ehCtCj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A2CEC4CEED;
	Thu,  3 Jul 2025 15:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555318;
	bh=L9pdv8tBhkiaCY/O7L6U8vqU2kp0QLWQ58Cv9ijMMnU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L2ehCtCjkvbrhJ45v3TdBHA6p5FCsFQbstJwu9x0GzrwXc6MW/c/KiKCugwGisAPX
	 89b0nam6hcv6DLNReTTYAO49GpqHwvA8WhZ/QpWxP604ARtZlKWVQENS2qpiPa8hHu
	 3jEkCPNjhlM2TAle7myg1LdmOKFqY65Gwmje5ZRc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Auld <matthew.auld@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	William Tseng <william.tseng@intel.com>,
	Tejas Upadhyay <tejas.upadhyay@intel.com>
Subject: [PATCH 6.15 224/263] drm/xe/sched: stop re-submitting signalled jobs
Date: Thu,  3 Jul 2025 16:42:24 +0200
Message-ID: <20250703144013.361509215@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Auld <matthew.auld@intel.com>

commit 0ee54d5cacc0276ec631ac149825a24b59c51c38 upstream.

Customer is reporting a really subtle issue where we get random DMAR
faults, hangs and other nasties for kernel migration jobs when stressing
stuff like s2idle/s3/s4. The explosions seems to happen somewhere
after resuming the system with splats looking something like:

PM: suspend exit
rfkill: input handler disabled
xe 0000:00:02.0: [drm] GT0: Engine reset: engine_class=bcs, logical_mask: 0x2, guc_id=0
xe 0000:00:02.0: [drm] GT0: Timedout job: seqno=24496, lrc_seqno=24496, guc_id=0, flags=0x13 in no process [-1]
xe 0000:00:02.0: [drm] GT0: Kernel-submitted job timed out

The likely cause appears to be a race between suspend cancelling the
worker that processes the free_job()'s, such that we still have pending
jobs to be freed after the cancel. Following from this, on resume the
pending_list will now contain at least one already complete job, but it
looks like we call drm_sched_resubmit_jobs(), which will then call
run_job() on everything still on the pending_list. But if the job was
already complete, then all the resources tied to the job, like the bb
itself, any memory that is being accessed, the iommu mappings etc. might
be long gone since those are usually tied to the fence signalling.

This scenario can be seen in ftrace when running a slightly modified
xe_pm IGT (kernel was only modified to inject artificial latency into
free_job to make the race easier to hit):

xe_sched_job_run: dev=0000:00:02.0, fence=0xffff888276cc8540, seqno=0, lrc_seqno=0, gt=0, guc_id=0, batch_addr=0x000000146910 ...
xe_exec_queue_stop:   dev=0000:00:02.0, 3:0x2, gt=0, width=1, guc_id=0, guc_state=0x0, flags=0x13
xe_exec_queue_stop:   dev=0000:00:02.0, 3:0x2, gt=0, width=1, guc_id=1, guc_state=0x0, flags=0x4
xe_exec_queue_stop:   dev=0000:00:02.0, 4:0x1, gt=1, width=1, guc_id=0, guc_state=0x0, flags=0x3
xe_exec_queue_stop:   dev=0000:00:02.0, 1:0x1, gt=1, width=1, guc_id=1, guc_state=0x0, flags=0x3
xe_exec_queue_stop:   dev=0000:00:02.0, 4:0x1, gt=1, width=1, guc_id=2, guc_state=0x0, flags=0x3
xe_exec_queue_resubmit: dev=0000:00:02.0, 3:0x2, gt=0, width=1, guc_id=0, guc_state=0x0, flags=0x13
xe_sched_job_run: dev=0000:00:02.0, fence=0xffff888276cc8540, seqno=0, lrc_seqno=0, gt=0, guc_id=0, batch_addr=0x000000146910 ...
.....
xe_exec_queue_memory_cat_error: dev=0000:00:02.0, 3:0x2, gt=0, width=1, guc_id=0, guc_state=0x3, flags=0x13

So the job_run() is clearly triggered twice for the same job, even
though the first must have already signalled to completion during
suspend. We can also see a CAT error after the re-submit.

To prevent this only resubmit jobs on the pending_list that have not yet
signalled.

v2:
  - Make sure to re-arm the fence callbacks with sched_start().
v3 (Matt B):
  - Stop using drm_sched_resubmit_jobs(), which appears to be deprecated
    and just open-code a simple loop such that we skip calling run_job()
    on anything already signalled.

Link: https://gitlab.freedesktop.org/drm/xe/kernel/-/issues/4856
Fixes: dd08ebf6c352 ("drm/xe: Introduce a new DRM driver for Intel GPUs")
Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: William Tseng <william.tseng@intel.com>
Cc: <stable@vger.kernel.org> # v6.8+
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Tejas Upadhyay <tejas.upadhyay@intel.com>
Link: https://lore.kernel.org/r/20250528113328.289392-2-matthew.auld@intel.com
(cherry picked from commit 38fafa9f392f3110d2de431432d43f4eef99cd1b)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_gpu_scheduler.h |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/xe/xe_gpu_scheduler.h
+++ b/drivers/gpu/drm/xe/xe_gpu_scheduler.h
@@ -51,7 +51,15 @@ static inline void xe_sched_tdr_queue_im
 
 static inline void xe_sched_resubmit_jobs(struct xe_gpu_scheduler *sched)
 {
-	drm_sched_resubmit_jobs(&sched->base);
+	struct drm_sched_job *s_job;
+
+	list_for_each_entry(s_job, &sched->base.pending_list, list) {
+		struct drm_sched_fence *s_fence = s_job->s_fence;
+		struct dma_fence *hw_fence = s_fence->parent;
+
+		if (hw_fence && !dma_fence_is_signaled(hw_fence))
+			sched->base.ops->run_job(s_job);
+	}
 }
 
 static inline bool


