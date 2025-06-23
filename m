Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92AF52192EC;
	Mon, 23 Jun 2025 22:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717517; cv=none; b=ezGM2X0CuMQWtHKjHZ7BrqwboGUI4mT3jSW1PxY5LwcPvSU8V607u4h4/dZIDHTxsfHbUAdZa5utnQDSpxDzZb4tA8gnOTT+C8NdaYbcRDi3ZwDo8ge4uo0BCROpiqxROeeWbjSLBIdOfJgW2/+ZQIJRABlTOP9hMxd1LQjTBGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717517; c=relaxed/simple;
	bh=WxrMm/OvvnuNb7MwZM/afEptVpi1Y42iunKi3K/QmzA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U1vW/7zqygQOvY7QSuafshNyqRd8o5Tip+no8nv/vcj59CDst1n1RIencTZs26NaRxmzNYxQSJ4kKNiEAWEG1pHyQbypr3mC3ccfXC/62qk9q2F2rbXWIPZqCR+Yto6vUCrSHXoMG6Zp9Lab/M9/YG3OSN0+cRE40uzk6vbfhr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MPQVciGv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MPQVciGv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1AFBC4CEEA;
	Mon, 23 Jun 2025 22:25:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717516;
	bh=WxrMm/OvvnuNb7MwZM/afEptVpi1Y42iunKi3K/QmzA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MPQVciGv186aNLUb9lneWxUklTFbTCbX76SrDgsrllZU4vT0hui+rpywvlrQ0K/4c
	 A3UiDhHVW1D9GlmMiqi/9q5a1BhPjY7rK6rH0n4vRg4z9HJ+d2fxYDoHKFKc1MunoM
	 X+wR/GbnC/t5TxtamRBR00hBfhljrEXsXWhA1Ecs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luo Gengkun <luogengkun@huaweicloud.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 405/414] perf/core: Fix WARN in perf_cgroup_switch()
Date: Mon, 23 Jun 2025 15:09:02 +0200
Message-ID: <20250623130652.063159565@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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
index 3389a5a2724df..7210104b3345c 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -206,6 +206,19 @@ static void perf_ctx_unlock(struct perf_cpu_context *cpuctx,
 	__perf_ctx_unlock(&cpuctx->ctx);
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
@@ -898,7 +911,13 @@ static void perf_cgroup_switch(struct task_struct *task)
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
 
 	ctx_sched_out(&cpuctx->ctx, NULL, EVENT_ALL|EVENT_CGROUP);
@@ -916,7 +935,6 @@ static void perf_cgroup_switch(struct task_struct *task)
 	ctx_sched_in(&cpuctx->ctx, NULL, EVENT_ALL|EVENT_CGROUP);
 
 	perf_ctx_enable(&cpuctx->ctx, true);
-	perf_ctx_unlock(cpuctx, cpuctx->task_ctx);
 }
 
 static int perf_cgroup_ensure_storage(struct perf_event *event,
-- 
2.39.5



