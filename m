Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8304173466;
	Tue, 27 Aug 2024 15:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771522; cv=none; b=FlVIbaia2qizpu47j2QGFk/wbJUpJy17GgrHDm782hGrqsA+SA8Ygph22g9uZzsxgjXtpe1k9o2fY96sm4Hp5Lf+CjnqtsNk8zlPT0GiE+VoeEhrt/uOvyt/Fo80W4v+bwAx3HshXdzteEADjr0eyiCMpj0B23r2mKCO440BMKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771522; c=relaxed/simple;
	bh=JKGRwf4/cbGtPF/ogDqdPu1ERpJzTMHlTAaB4GM5Mcg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lPRKBRjafjhDMn+a8xNB3U7bTz6h7NYnlF41GuDmCIRASnjxvHUJCPQRGYtPNTNG3slj33TN+l1rAZVniL47bMFHwqCIfmu0XbMQEMDmDAoSIUiKAGrvEAqx2xSGqCKVckGoT5VUq55Ps79rchR5mEWj0vKZVTUwzcKya/l4ikM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PW+hq+KN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PW+hq+KN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6FAEC4DDFA;
	Tue, 27 Aug 2024 15:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771522;
	bh=JKGRwf4/cbGtPF/ogDqdPu1ERpJzTMHlTAaB4GM5Mcg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PW+hq+KNgpHpkh4EDLuW5M4H9TpZCT00ybbSP0pktkYxknQlk2PpIZo6Xy/Se6IyH
	 rcyUl9tSzpBE7uWeAIwNzZf/tVNAnEIGB3ZyjE2mY4yR2TXEQjpztcQGlwSYAnJsoJ
	 +GMABDeknlDdX/68rKk/UJnPpUDCMadkOh8lGBLI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 214/273] drm/xe: Decouple job seqno and lrc seqno
Date: Tue, 27 Aug 2024 16:38:58 +0200
Message-ID: <20240827143841.552239435@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Brost <matthew.brost@intel.com>

[ Upstream commit 08f7200899ca72dec550af092ae424b7db099abd ]

Tightly coupling these seqno presents problems if alternative fences for
jobs are used. Decouple these for correctness.

v2:
- Slightly reword commit message (Thomas)
- Make sure the lrc fence ops are used in comparison (Thomas)
- Assume seqno is unsigned rather than signed in format string (Thomas)

Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Reviewed-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240527135912.152156-2-thomas.hellstrom@linux.intel.com
Stable-dep-of: 9e7f30563677 ("drm/xe: Free job before xe_exec_queue_put")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_exec_queue.c      |  2 +-
 drivers/gpu/drm/xe/xe_guc_submit.c      |  5 +++--
 drivers/gpu/drm/xe/xe_ring_ops.c        | 12 ++++++------
 drivers/gpu/drm/xe/xe_sched_job.c       | 16 ++++++++--------
 drivers/gpu/drm/xe/xe_sched_job.h       |  5 +++++
 drivers/gpu/drm/xe/xe_sched_job_types.h |  2 ++
 drivers/gpu/drm/xe/xe_trace.h           |  7 +++++--
 7 files changed, 30 insertions(+), 19 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_exec_queue.c b/drivers/gpu/drm/xe/xe_exec_queue.c
index 33b03605a1d15..79d099e054916 100644
--- a/drivers/gpu/drm/xe/xe_exec_queue.c
+++ b/drivers/gpu/drm/xe/xe_exec_queue.c
@@ -98,7 +98,7 @@ static struct xe_exec_queue *__xe_exec_queue_alloc(struct xe_device *xe,
 
 	if (xe_exec_queue_is_parallel(q)) {
 		q->parallel.composite_fence_ctx = dma_fence_context_alloc(1);
-		q->parallel.composite_fence_seqno = XE_FENCE_INITIAL_SEQNO;
+		q->parallel.composite_fence_seqno = 0;
 	}
 
 	return q;
diff --git a/drivers/gpu/drm/xe/xe_guc_submit.c b/drivers/gpu/drm/xe/xe_guc_submit.c
index 8c75791cbc4fb..e48285c81bf57 100644
--- a/drivers/gpu/drm/xe/xe_guc_submit.c
+++ b/drivers/gpu/drm/xe/xe_guc_submit.c
@@ -917,8 +917,9 @@ guc_exec_queue_timedout_job(struct drm_sched_job *drm_job)
 		return DRM_GPU_SCHED_STAT_NOMINAL;
 	}
 
-	drm_notice(&xe->drm, "Timedout job: seqno=%u, guc_id=%d, flags=0x%lx",
-		   xe_sched_job_seqno(job), q->guc->id, q->flags);
+	drm_notice(&xe->drm, "Timedout job: seqno=%u, lrc_seqno=%u, guc_id=%d, flags=0x%lx",
+		   xe_sched_job_seqno(job), xe_sched_job_lrc_seqno(job),
+		   q->guc->id, q->flags);
 	xe_gt_WARN(q->gt, q->flags & EXEC_QUEUE_FLAG_KERNEL,
 		   "Kernel-submitted job timed out\n");
 	xe_gt_WARN(q->gt, q->flags & EXEC_QUEUE_FLAG_VM && !exec_queue_killed(q),
diff --git a/drivers/gpu/drm/xe/xe_ring_ops.c b/drivers/gpu/drm/xe/xe_ring_ops.c
index aca7a9af6e846..3b6aad8dea99a 100644
--- a/drivers/gpu/drm/xe/xe_ring_ops.c
+++ b/drivers/gpu/drm/xe/xe_ring_ops.c
@@ -412,7 +412,7 @@ static void emit_job_gen12_gsc(struct xe_sched_job *job)
 
 	__emit_job_gen12_simple(job, job->q->lrc,
 				job->batch_addr[0],
-				xe_sched_job_seqno(job));
+				xe_sched_job_lrc_seqno(job));
 }
 
 static void emit_job_gen12_copy(struct xe_sched_job *job)
@@ -421,14 +421,14 @@ static void emit_job_gen12_copy(struct xe_sched_job *job)
 
 	if (xe_sched_job_is_migration(job->q)) {
 		emit_migration_job_gen12(job, job->q->lrc,
-					 xe_sched_job_seqno(job));
+					 xe_sched_job_lrc_seqno(job));
 		return;
 	}
 
 	for (i = 0; i < job->q->width; ++i)
 		__emit_job_gen12_simple(job, job->q->lrc + i,
-				        job->batch_addr[i],
-				        xe_sched_job_seqno(job));
+					job->batch_addr[i],
+					xe_sched_job_lrc_seqno(job));
 }
 
 static void emit_job_gen12_video(struct xe_sched_job *job)
@@ -439,7 +439,7 @@ static void emit_job_gen12_video(struct xe_sched_job *job)
 	for (i = 0; i < job->q->width; ++i)
 		__emit_job_gen12_video(job, job->q->lrc + i,
 				       job->batch_addr[i],
-				       xe_sched_job_seqno(job));
+				       xe_sched_job_lrc_seqno(job));
 }
 
 static void emit_job_gen12_render_compute(struct xe_sched_job *job)
@@ -449,7 +449,7 @@ static void emit_job_gen12_render_compute(struct xe_sched_job *job)
 	for (i = 0; i < job->q->width; ++i)
 		__emit_job_gen12_render_compute(job, job->q->lrc + i,
 						job->batch_addr[i],
-						xe_sched_job_seqno(job));
+						xe_sched_job_lrc_seqno(job));
 }
 
 static const struct xe_ring_ops ring_ops_gen12_gsc = {
diff --git a/drivers/gpu/drm/xe/xe_sched_job.c b/drivers/gpu/drm/xe/xe_sched_job.c
index a4e030f5e019a..874450be327ec 100644
--- a/drivers/gpu/drm/xe/xe_sched_job.c
+++ b/drivers/gpu/drm/xe/xe_sched_job.c
@@ -117,6 +117,7 @@ struct xe_sched_job *xe_sched_job_create(struct xe_exec_queue *q,
 			err = PTR_ERR(job->fence);
 			goto err_sched_job;
 		}
+		job->lrc_seqno = job->fence->seqno;
 	} else {
 		struct dma_fence_array *cf;
 
@@ -132,6 +133,8 @@ struct xe_sched_job *xe_sched_job_create(struct xe_exec_queue *q,
 				err = PTR_ERR(fences[j]);
 				goto err_fences;
 			}
+			if (!j)
+				job->lrc_seqno = fences[0]->seqno;
 		}
 
 		cf = dma_fence_array_create(q->width, fences,
@@ -144,10 +147,6 @@ struct xe_sched_job *xe_sched_job_create(struct xe_exec_queue *q,
 			goto err_fences;
 		}
 
-		/* Sanity check */
-		for (j = 0; j < q->width; ++j)
-			xe_assert(job_to_xe(job), cf->base.seqno == fences[j]->seqno);
-
 		job->fence = &cf->base;
 	}
 
@@ -229,9 +228,9 @@ bool xe_sched_job_started(struct xe_sched_job *job)
 {
 	struct xe_lrc *lrc = job->q->lrc;
 
-	return !__dma_fence_is_later(xe_sched_job_seqno(job),
+	return !__dma_fence_is_later(xe_sched_job_lrc_seqno(job),
 				     xe_lrc_start_seqno(lrc),
-				     job->fence->ops);
+				     dma_fence_array_first(job->fence)->ops);
 }
 
 bool xe_sched_job_completed(struct xe_sched_job *job)
@@ -243,8 +242,9 @@ bool xe_sched_job_completed(struct xe_sched_job *job)
 	 * parallel handshake is done.
 	 */
 
-	return !__dma_fence_is_later(xe_sched_job_seqno(job), xe_lrc_seqno(lrc),
-				     job->fence->ops);
+	return !__dma_fence_is_later(xe_sched_job_lrc_seqno(job),
+				     xe_lrc_seqno(lrc),
+				     dma_fence_array_first(job->fence)->ops);
 }
 
 void xe_sched_job_arm(struct xe_sched_job *job)
diff --git a/drivers/gpu/drm/xe/xe_sched_job.h b/drivers/gpu/drm/xe/xe_sched_job.h
index c75018f4660dc..002c3b5c0a5cb 100644
--- a/drivers/gpu/drm/xe/xe_sched_job.h
+++ b/drivers/gpu/drm/xe/xe_sched_job.h
@@ -73,6 +73,11 @@ static inline u32 xe_sched_job_seqno(struct xe_sched_job *job)
 	return job->fence->seqno;
 }
 
+static inline u32 xe_sched_job_lrc_seqno(struct xe_sched_job *job)
+{
+	return job->lrc_seqno;
+}
+
 static inline void
 xe_sched_job_add_migrate_flush(struct xe_sched_job *job, u32 flags)
 {
diff --git a/drivers/gpu/drm/xe/xe_sched_job_types.h b/drivers/gpu/drm/xe/xe_sched_job_types.h
index 5e12724219fdd..990ddac55ed62 100644
--- a/drivers/gpu/drm/xe/xe_sched_job_types.h
+++ b/drivers/gpu/drm/xe/xe_sched_job_types.h
@@ -37,6 +37,8 @@ struct xe_sched_job {
 		/** @user_fence.value: write back value */
 		u64 value;
 	} user_fence;
+	/** @lrc_seqno: LRC seqno */
+	u32 lrc_seqno;
 	/** @migrate_flush_flags: Additional flush flags for migration jobs */
 	u32 migrate_flush_flags;
 	/** @ring_ops_flush_tlb: The ring ops need to flush TLB before payload. */
diff --git a/drivers/gpu/drm/xe/xe_trace.h b/drivers/gpu/drm/xe/xe_trace.h
index 2d56cfc09e421..6c6cecc58f63b 100644
--- a/drivers/gpu/drm/xe/xe_trace.h
+++ b/drivers/gpu/drm/xe/xe_trace.h
@@ -254,6 +254,7 @@ DECLARE_EVENT_CLASS(xe_sched_job,
 
 		    TP_STRUCT__entry(
 			     __field(u32, seqno)
+			     __field(u32, lrc_seqno)
 			     __field(u16, guc_id)
 			     __field(u32, guc_state)
 			     __field(u32, flags)
@@ -264,6 +265,7 @@ DECLARE_EVENT_CLASS(xe_sched_job,
 
 		    TP_fast_assign(
 			   __entry->seqno = xe_sched_job_seqno(job);
+			   __entry->lrc_seqno = xe_sched_job_lrc_seqno(job);
 			   __entry->guc_id = job->q->guc->id;
 			   __entry->guc_state =
 			   atomic_read(&job->q->guc->state);
@@ -273,8 +275,9 @@ DECLARE_EVENT_CLASS(xe_sched_job,
 			   __entry->batch_addr = (u64)job->batch_addr[0];
 			   ),
 
-		    TP_printk("fence=%p, seqno=%u, guc_id=%d, batch_addr=0x%012llx, guc_state=0x%x, flags=0x%x, error=%d",
-			      __entry->fence, __entry->seqno, __entry->guc_id,
+		    TP_printk("fence=%p, seqno=%u, lrc_seqno=%u, guc_id=%d, batch_addr=0x%012llx, guc_state=0x%x, flags=0x%x, error=%d",
+			      __entry->fence, __entry->seqno,
+			      __entry->lrc_seqno, __entry->guc_id,
 			      __entry->batch_addr, __entry->guc_state,
 			      __entry->flags, __entry->error)
 );
-- 
2.43.0



