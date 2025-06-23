Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 686BB2248B5;
	Mon, 23 Jun 2025 22:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716701; cv=none; b=AoVPrBXYgnUPITCiNucNVl63J8KiU6ldDRHIgd4UwQucUeBwksdvIldPy3IABR6tZB/S9/3/uufBvAyFzkCKxi9sIOr4Dcxwbnk5SunZScniqANWYW0L3W0tbRX+AYsOXYImqVON3h92ycR4WB8dLzwc7kehKmuyIVDVGo6tZtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716701; c=relaxed/simple;
	bh=R5IsFHtTKyBpg5g1Yf640heol9+h3xl1ZiHstqDpSAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IvZT0fr1hvZ+FFUNFnbYZv9KejUgL0N2hR4lsnwsKfXlRNz0gpVnADpA1C2j2uY+UvxqBeVYSTr3WCKpIaSLzVHE/+3PY3G1FSMJgRUb6k6NDs82LkBM1GZd9c6hAXM/mRPddLVFNg/vmNQFwie64HDllHPvNu4kIyDq2XtcZmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dM4JltMa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dM4JltMa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DFCCC4CEEA;
	Mon, 23 Jun 2025 22:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716700;
	bh=R5IsFHtTKyBpg5g1Yf640heol9+h3xl1ZiHstqDpSAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dM4JltMai+dnUcgc/ywJkzGAArsZqFzUaq8o9F/U2TS1kedasWqsb5H5JsE2DLmkx
	 t8JmkgqHaa/2ls7OYIXxzLtQNxdGmqF6gfh7lz3Zmb4g3bMwfKEpLgpAhT6d4fuYDo
	 9Q1TmYS7Wyvrp/4aaYfznUWqYJmzWyT7BAIXH+X4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luo Gengkun <luogengkun@huaweicloud.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 283/290] perf/core: Fix WARN in perf_cgroup_switch()
Date: Mon, 23 Jun 2025 15:09:04 +0200
Message-ID: <20250623130635.432438537@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luo Gengkun <luogengkun@huaweicloud.com>

[ Upstream commit 3172fb986666dfb71bf483b6d3539e1e587fa197 ]

There may be concurrency between perf_cgroup_switch and
perf_cgroup_event_disable. Consider the following scenario: after a new
perf cgroup event is created on CPU0, the new event may not trigger
a reprogramming, causing ctx->is_active to be 0. In this case, when CPU1
disables this perf event, it executes __perf_remove_from_context->
list _del_event->perf_cgroup_event_disable on CPU1, which causes a race
with perf_cgroup_switch running on CPU0.

The following describes the details of this concurrency scenario:

CPU0						CPU1

perf_cgroup_switch:
   ...
   # cpuctx->cgrp is not NULL here
   if (READ_ONCE(cpuctx->cgrp) == NULL)
   	return;

						perf_remove_from_context:
						   ...
						   raw_spin_lock_irq(&ctx->lock);
						   ...
						   # ctx->is_active == 0 because reprogramm is not
						   # tigger, so CPU1 can do __perf_remove_from_context
						   # for CPU0
						   __perf_remove_from_context:
						         perf_cgroup_event_disable:
							    ...
							    if (--ctx->nr_cgroups)
							    ...

   # this warning will happened because CPU1 changed
   # ctx.nr_cgroups to 0.
   WARN_ON_ONCE(cpuctx->ctx.nr_cgroups == 0);

[peterz: use guard instead of goto unlock]
Fixes: db4a835601b7 ("perf/core: Set cgroup in CPU contexts for new cgroup events")
Signed-off-by: Luo Gengkun <luogengkun@huaweicloud.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20250604033924.3914647-3-luogengkun@huaweicloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index e9e785542b9f4..873b17545717c 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -171,6 +171,19 @@ static void perf_ctx_unlock(struct perf_cpu_context *cpuctx,
 	raw_spin_unlock(&cpuctx->ctx.lock);
 }
 
+typedef struct {
+	struct perf_cpu_context *cpuctx;
+	struct perf_event_context *ctx;
+} class_perf_ctx_lock_t;
+
+static inline void class_perf_ctx_lock_destructor(class_perf_ctx_lock_t *_T)
+{ perf_ctx_unlock(_T->cpuctx, _T->ctx); }
+
+static inline class_perf_ctx_lock_t
+class_perf_ctx_lock_constructor(struct perf_cpu_context *cpuctx,
+				struct perf_event_context *ctx)
+{ perf_ctx_lock(cpuctx, ctx); return (class_perf_ctx_lock_t){ cpuctx, ctx }; }
+
 #define TASK_TOMBSTONE ((void *)-1L)
 
 static bool is_kernel_event(struct perf_event *event)
@@ -866,7 +879,13 @@ static void perf_cgroup_switch(struct task_struct *task)
 	if (READ_ONCE(cpuctx->cgrp) == cgrp)
 		return;
 
-	perf_ctx_lock(cpuctx, cpuctx->task_ctx);
+	guard(perf_ctx_lock)(cpuctx, cpuctx->task_ctx);
+	/*
+	 * Re-check, could've raced vs perf_remove_from_context().
+	 */
+	if (READ_ONCE(cpuctx->cgrp) == NULL)
+		return;
+
 	perf_ctx_disable(&cpuctx->ctx, true);
 
 	ctx_sched_out(&cpuctx->ctx, EVENT_ALL|EVENT_CGROUP);
@@ -884,7 +903,6 @@ static void perf_cgroup_switch(struct task_struct *task)
 	ctx_sched_in(&cpuctx->ctx, EVENT_ALL|EVENT_CGROUP);
 
 	perf_ctx_enable(&cpuctx->ctx, true);
-	perf_ctx_unlock(cpuctx, cpuctx->task_ctx);
 }
 
 static int perf_cgroup_ensure_storage(struct perf_event *event,
-- 
2.39.5



