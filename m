Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9274C2E62C;
	Mon,  8 Apr 2024 13:09:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581788; cv=none; b=rtGKBohoC30XLA6YrJTt7cntjU9kHx7HEOAPKgnP0chlLZ+GQQdJ50cbja+8L/Gd8PkaLpoCI4QbPuK55OewnRNH8QaHnKtQZtvcm3w+C8nIzOX1UJnZWSWSYMjUkn3wS3gg/f/aX861/J29ArRFjk6NwpjRsiCl6nvgIaNYU4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581788; c=relaxed/simple;
	bh=SKA4slfBrqhpjfvO+HF5fEaRAdjQhG83Oe3IJN/LBUM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BsmPMEE5Lm0z4TFkFokpQtqPLlWCY2A9r7Pt2ym+HmvYKS05jGvkqFHOgU4uLnP8nbsQF2bQlKpwFnarmpeH74Hw5n4HNiSFZY7NV/aaiVumeXH3HvpYesyqGc7fNHZQi1rn0xbP+tXBMbzIPV2/nbT8kSM5+T0yHuuqVi5bs0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R+rjJ3kE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R+rjJ3kE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19864C433F1;
	Mon,  8 Apr 2024 13:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581788;
	bh=SKA4slfBrqhpjfvO+HF5fEaRAdjQhG83Oe3IJN/LBUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R+rjJ3kEhFO5Wyx7vw4P0mfPkTw7QXnSrXbAGTGwvvlAAGEoY+hqZQmHU/qjlWTqL
	 9LJRyL3EkaOymBgWCx9o98KvgLJt3X7VOSCdds+Jv7CCpvLFli3VSZg2UU9lCqd7IY
	 Gs+yMpD9syMnY1qceJUuZFmNBaPMFAJl3FuKz2Bk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Welty <brian.welty@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 020/273] drm/xe: Add exec_queue.sched_props.job_timeout_ms
Date: Mon,  8 Apr 2024 14:54:55 +0200
Message-ID: <20240408125309.922551811@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brian Welty <brian.welty@intel.com>

[ Upstream commit 6ae24344e2e3e12e06f7b382af4bba2fd417b2ff ]

The purpose here is to allow to optimize exec_queue_set_job_timeout()
in follow-on patch.  Currently it does q->ops->set_job_timeout(...).
But we'd like to apply exec_queue_user_extensions much earlier and
q->ops cannot be called before __xe_exec_queue_init().

It will be much more efficient to instead only have to set
q->sched_props.job_timeout_ms when applying user extensions. That value
will then be used during q->ops->init().

Signed-off-by: Brian Welty <brian.welty@intel.com>
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Stable-dep-of: 9c1256369c10 ("drm/xe/guc_submit: use jiffies for job timeout")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_exec_queue.c       | 2 ++
 drivers/gpu/drm/xe/xe_exec_queue_types.h | 2 ++
 drivers/gpu/drm/xe/xe_guc_submit.c       | 2 +-
 3 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/xe/xe_exec_queue.c b/drivers/gpu/drm/xe/xe_exec_queue.c
index 49223026c89fd..a176d9ad6d1b8 100644
--- a/drivers/gpu/drm/xe/xe_exec_queue.c
+++ b/drivers/gpu/drm/xe/xe_exec_queue.c
@@ -66,6 +66,8 @@ static struct xe_exec_queue *__xe_exec_queue_create(struct xe_device *xe,
 	q->sched_props.timeslice_us = hwe->eclass->sched_props.timeslice_us;
 	q->sched_props.preempt_timeout_us =
 				hwe->eclass->sched_props.preempt_timeout_us;
+	q->sched_props.job_timeout_ms =
+				hwe->eclass->sched_props.job_timeout_ms;
 	if (q->flags & EXEC_QUEUE_FLAG_KERNEL &&
 	    q->flags & EXEC_QUEUE_FLAG_HIGH_PRIORITY)
 		q->sched_props.priority = XE_EXEC_QUEUE_PRIORITY_KERNEL;
diff --git a/drivers/gpu/drm/xe/xe_exec_queue_types.h b/drivers/gpu/drm/xe/xe_exec_queue_types.h
index 36f4901d8d7ee..747106584f752 100644
--- a/drivers/gpu/drm/xe/xe_exec_queue_types.h
+++ b/drivers/gpu/drm/xe/xe_exec_queue_types.h
@@ -132,6 +132,8 @@ struct xe_exec_queue {
 		u32 timeslice_us;
 		/** @preempt_timeout_us: preemption timeout in micro-seconds */
 		u32 preempt_timeout_us;
+		/** @job_timeout_ms: job timeout in milliseconds */
+		u32 job_timeout_ms;
 		/** @priority: priority of this exec queue */
 		enum xe_exec_queue_priority priority;
 	} sched_props;
diff --git a/drivers/gpu/drm/xe/xe_guc_submit.c b/drivers/gpu/drm/xe/xe_guc_submit.c
index f22ae717b0b2d..9d5e3afef5057 100644
--- a/drivers/gpu/drm/xe/xe_guc_submit.c
+++ b/drivers/gpu/drm/xe/xe_guc_submit.c
@@ -1216,7 +1216,7 @@ static int guc_exec_queue_init(struct xe_exec_queue *q)
 	init_waitqueue_head(&ge->suspend_wait);
 
 	timeout = (q->vm && xe_vm_in_lr_mode(q->vm)) ? MAX_SCHEDULE_TIMEOUT :
-		  q->hwe->eclass->sched_props.job_timeout_ms;
+		  q->sched_props.job_timeout_ms;
 	err = xe_sched_init(&ge->sched, &drm_sched_ops, &xe_sched_ops,
 			    get_submit_wq(guc),
 			    q->lrc[0].ring.size / MAX_JOB_SIZE_BYTES, 64,
-- 
2.43.0



