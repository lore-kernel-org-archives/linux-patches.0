Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBF792517B1;
	Mon, 12 May 2025 18:09:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073353; cv=none; b=ZGQqzSDwQBoI3as15cBujWlGkxXvhb38lpOgRLLVDrv9ZH6ZoB1Lu9aUW4RcMXLOUl51MpCaa/nqaCWn92jrY0FffxmLHtWt4YZ9WyWmcIydMux+EYl3f8JQ0xlv+4nxNeawW264U9p+cAj3rQ+tS2haej8Qk1PzkWQAnsTiqUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073353; c=relaxed/simple;
	bh=hpFpeZOdsoGz7Yd4qq7R7QvXBF0gkjO7eIONr3ySjIo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ElBFY1v4MAP2RmyI2mpjGp2p2lO2gSdjZd/2y0OAaLlkS6jjt2WWd6J5m7qTHkxQVcUSTPr8qzSAAIxcnvtvBzjXqSQ81usgsNzIehHq4CE4wLdh7AMxcxZA3mTcxpJ4jt6ngBy8f4uBjdCIDQQIzZ5Dp+upPy1BHF18v/4ny4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f+eBb/uY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f+eBb/uY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30807C4CEE7;
	Mon, 12 May 2025 18:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747073353;
	bh=hpFpeZOdsoGz7Yd4qq7R7QvXBF0gkjO7eIONr3ySjIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f+eBb/uY1H+jFgR7dk04wfQPHMKKB4vnkS+999xlFhIjC/km5OrZXqkjYkP0hBbNT
	 RyMNFlGwiJjsjf14ryFv9jAESAiQoGLERok+ygOBJRQZn0rlLbvkbfUegsvHRntqoZ
	 x+lYrwgNdDDk5vjrVxD/b1ESyyQLW0TCNZK+Wwg8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daivik Bhatia <dtgs1208@gmail.com>,
	Iago Toral Quiroga <itoral@igalia.com>,
	Tvrtko Ursulin <tvrtko.ursulin@igalia.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>
Subject: [PATCH 6.6 047/113] drm/v3d: Add job to pending list if the reset was skipped
Date: Mon, 12 May 2025 19:45:36 +0200
Message-ID: <20250512172029.583275696@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172027.691520737@linuxfoundation.org>
References: <20250512172027.691520737@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maíra Canal <mcanal@igalia.com>

commit 35e4079bf1a2570abffce6ababa631afcf8ea0e5 upstream.

When a CL/CSD job times out, we check if the GPU has made any progress
since the last timeout. If so, instead of resetting the hardware, we skip
the reset and let the timer get rearmed. This gives long-running jobs a
chance to complete.

However, when `timedout_job()` is called, the job in question is removed
from the pending list, which means it won't be automatically freed through
`free_job()`. Consequently, when we skip the reset and keep the job
running, the job won't be freed when it finally completes.

This situation leads to a memory leak, as exposed in [1] and [2].

Similarly to commit 704d3d60fec4 ("drm/etnaviv: don't block scheduler when
GPU is still active"), this patch ensures the job is put back on the
pending list when extending the timeout.

Cc: stable@vger.kernel.org # 6.0
Reported-by: Daivik Bhatia <dtgs1208@gmail.com>
Closes: https://gitlab.freedesktop.org/mesa/mesa/-/issues/12227 [1]
Closes: https://github.com/raspberrypi/linux/issues/6817 [2]
Reviewed-by: Iago Toral Quiroga <itoral@igalia.com>
Acked-by: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Link: https://lore.kernel.org/r/20250430210643.57924-1-mcanal@igalia.com
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/v3d/v3d_sched.c |   28 +++++++++++++++++++++-------
 1 file changed, 21 insertions(+), 7 deletions(-)

--- a/drivers/gpu/drm/v3d/v3d_sched.c
+++ b/drivers/gpu/drm/v3d/v3d_sched.c
@@ -289,11 +289,16 @@ v3d_gpu_reset_for_timeout(struct v3d_dev
 	return DRM_GPU_SCHED_STAT_NOMINAL;
 }
 
-/* If the current address or return address have changed, then the GPU
- * has probably made progress and we should delay the reset.  This
- * could fail if the GPU got in an infinite loop in the CL, but that
- * is pretty unlikely outside of an i-g-t testcase.
- */
+static void
+v3d_sched_skip_reset(struct drm_sched_job *sched_job)
+{
+	struct drm_gpu_scheduler *sched = sched_job->sched;
+
+	spin_lock(&sched->job_list_lock);
+	list_add(&sched_job->list, &sched->pending_list);
+	spin_unlock(&sched->job_list_lock);
+}
+
 static enum drm_gpu_sched_stat
 v3d_cl_job_timedout(struct drm_sched_job *sched_job, enum v3d_queue q,
 		    u32 *timedout_ctca, u32 *timedout_ctra)
@@ -303,9 +308,16 @@ v3d_cl_job_timedout(struct drm_sched_job
 	u32 ctca = V3D_CORE_READ(0, V3D_CLE_CTNCA(q));
 	u32 ctra = V3D_CORE_READ(0, V3D_CLE_CTNRA(q));
 
+	/* If the current address or return address have changed, then the GPU
+	 * has probably made progress and we should delay the reset. This
+	 * could fail if the GPU got in an infinite loop in the CL, but that
+	 * is pretty unlikely outside of an i-g-t testcase.
+	 */
 	if (*timedout_ctca != ctca || *timedout_ctra != ctra) {
 		*timedout_ctca = ctca;
 		*timedout_ctra = ctra;
+
+		v3d_sched_skip_reset(sched_job);
 		return DRM_GPU_SCHED_STAT_NOMINAL;
 	}
 
@@ -345,11 +357,13 @@ v3d_csd_job_timedout(struct drm_sched_jo
 	struct v3d_dev *v3d = job->base.v3d;
 	u32 batches = V3D_CORE_READ(0, V3D_CSD_CURRENT_CFG4);
 
-	/* If we've made progress, skip reset and let the timer get
-	 * rearmed.
+	/* If we've made progress, skip reset, add the job to the pending
+	 * list, and let the timer get rearmed.
 	 */
 	if (job->timedout_batches != batches) {
 		job->timedout_batches = batches;
+
+		v3d_sched_skip_reset(sched_job);
 		return DRM_GPU_SCHED_STAT_NOMINAL;
 	}
 


