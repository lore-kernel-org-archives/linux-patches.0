Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DE681519B8;
	Mon, 12 May 2025 18:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072892; cv=none; b=c9Y5lglUr1ZN2gESBj+8zvZRYs3IhyNZqbaPY3Nd5bGkAmVxRqoivQp9Uve1rV/WemTxiOwIDBRclt/taH0USwtQpjUPxITSx2/BTK1jQBcnIULbEDjli597PWmI7WTug3YyGGBr7aQO14CbZdnyDfzkSFgYN1HlwjH2ZxoFM+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072892; c=relaxed/simple;
	bh=9zk6D3wiKIPK94xbF6hv5AGHTssCF7mWw+ssJyPnSrg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BLbjTMXe6bTW1sMKBkhC8xhBTVO8ccDWpmRljPRj23amrTYa9RMuuYjq91oeE56JNxQeIRfKJOWEo2UvHSzSw5Ba0ftu7oIT4H8UOE0QKTaRWYnnbktbuCFuWNa5lJr5HUjYx/nqILCyR89lBzJlDi92UgfrTOcHj1zK1wqqQW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qr9qqtz8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qr9qqtz8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 829F2C4CEE7;
	Mon, 12 May 2025 18:01:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072892;
	bh=9zk6D3wiKIPK94xbF6hv5AGHTssCF7mWw+ssJyPnSrg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qr9qqtz8Y7PTsJP8y2TcX7lRggaQe3lyD//Yb61L99RXu1BmRYEDON78RZXUXutzL
	 mlGbPEyhiBpEahD5LJfn0aDa9dFESyZP7Qdr1mPKtkPQ5Xyc9MFaqKUyr5INxqIp2K
	 Sp0MoYaxJTTcZfY6YlJfrTQmuQlC+YSTkmS3FBwo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daivik Bhatia <dtgs1208@gmail.com>,
	Iago Toral Quiroga <itoral@igalia.com>,
	Tvrtko Ursulin <tvrtko.ursulin@igalia.com>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>
Subject: [PATCH 6.12 088/184] drm/v3d: Add job to pending list if the reset was skipped
Date: Mon, 12 May 2025 19:44:49 +0200
Message-ID: <20250512172045.406734079@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172041.624042835@linuxfoundation.org>
References: <20250512172041.624042835@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -728,11 +728,16 @@ v3d_gpu_reset_for_timeout(struct v3d_dev
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
@@ -742,9 +747,16 @@ v3d_cl_job_timedout(struct drm_sched_job
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
 
@@ -784,11 +796,13 @@ v3d_csd_job_timedout(struct drm_sched_jo
 	struct v3d_dev *v3d = job->base.v3d;
 	u32 batches = V3D_CORE_READ(0, V3D_CSD_CURRENT_CFG4(v3d->ver));
 
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
 


