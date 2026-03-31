Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E17203D75D9;
	Tue, 31 Mar 2026 16:23:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974240; cv=none; b=EtUXwiHNp1VurfY0GC7yV3Sc0s+42GIF8HmnJeDViLCJxEeN9hO35mDXCnIrKvAYj6YqRS5W2ofOmwHHM9OW5Cn5hperi8bpFq//8GtPENyeqgZm4KG4iLYgscTwuUfaZdUGlW/+sa6/7EnsXfUdMtdifcP3e2Ga1JTRkf1Au54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974240; c=relaxed/simple;
	bh=BluBn50t5prR4UgpK+tt8bE+oXcbb3TKK/PJOLK+p6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sCCImS0EqB+4HRqW8UXlFgCssyIrqqHIhkna5ITdaP8OqfysyW8w76kfy6vfW836bPa/f6oWuVthVeBp5BpXeMbJVi+TiNkej5FYW8hztWr5R4Kp4ap+WFVEgAvfdEcvMyi8NNbJ0kQXEwu99GGYBejeH1tkSUiUK7R9jpmkyZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P1Fj8jPc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P1Fj8jPc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 021DEC19423;
	Tue, 31 Mar 2026 16:23:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974239;
	bh=BluBn50t5prR4UgpK+tt8bE+oXcbb3TKK/PJOLK+p6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P1Fj8jPc1o2qFiMwamJmtN0W//AtVCkI2NoErNqRQIJr4Nfz/b3jdsgXPC0aGMdbO
	 gD40ZURfJYMra5dwd0L9/uths8zFDUk3G2/3RE58K/SNOPwutLiokii6ctaQEUf6us
	 E/xsydavM19EHqDbmgpacRQUCBKp3/WHsbVbLfs0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 001/175] perf: Extract a few helpers
Date: Tue, 31 Mar 2026 18:19:45 +0200
Message-ID: <20260331161729.837275842@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161729.779738837@linuxfoundation.org>
References: <20260331161729.779738837@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 9a32bd9901fe5b1dcf544389dbf04f3b0a2fbab4 ]

The context time update code is repeated verbatim a few times.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Kan Liang <kan.liang@linux.intel.com>
Reviewed-by: Namhyung Kim <namhyung@kernel.org>
Link: https://lore.kernel.org/r/20240807115550.031212518@infradead.org
Stable-dep-of: 4b9ce6719606 ("perf: Make sure to use pmu_ctx->pmu for groups")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 39 ++++++++++++++++++++++-----------------
 1 file changed, 22 insertions(+), 17 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 652baf91c629e..53cb9ee145746 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -2349,6 +2349,24 @@ group_sched_out(struct perf_event *group_event, struct perf_event_context *ctx)
 		event_sched_out(event, ctx);
 }
 
+static inline void
+ctx_time_update(struct perf_cpu_context *cpuctx, struct perf_event_context *ctx)
+{
+	if (ctx->is_active & EVENT_TIME) {
+		update_context_time(ctx);
+		update_cgrp_time_from_cpuctx(cpuctx, false);
+	}
+}
+
+static inline void
+ctx_time_update_event(struct perf_event_context *ctx, struct perf_event *event)
+{
+	if (ctx->is_active & EVENT_TIME) {
+		update_context_time(ctx);
+		update_cgrp_time_from_event(event);
+	}
+}
+
 #define DETACH_GROUP	0x01UL
 #define DETACH_CHILD	0x02UL
 #define DETACH_DEAD	0x04UL
@@ -2370,10 +2388,7 @@ __perf_remove_from_context(struct perf_event *event,
 	enum perf_event_state state = PERF_EVENT_STATE_OFF;
 	unsigned long flags = (unsigned long)info;
 
-	if (ctx->is_active & EVENT_TIME) {
-		update_context_time(ctx);
-		update_cgrp_time_from_cpuctx(cpuctx, false);
-	}
+	ctx_time_update(cpuctx, ctx);
 
 	/*
 	 * Ensure event_sched_out() switches to OFF, at the very least
@@ -2470,12 +2485,8 @@ static void __perf_event_disable(struct perf_event *event,
 	if (event->state < PERF_EVENT_STATE_INACTIVE)
 		return;
 
-	if (ctx->is_active & EVENT_TIME) {
-		update_context_time(ctx);
-		update_cgrp_time_from_event(event);
-	}
-
 	perf_pmu_disable(event->pmu_ctx->pmu);
+	ctx_time_update_event(ctx, event);
 
 	/*
 	 * When disabling a group leader, the whole group becomes ineligible
@@ -4534,10 +4545,7 @@ static void __perf_event_read(void *info)
 		return;
 
 	raw_spin_lock(&ctx->lock);
-	if (ctx->is_active & EVENT_TIME) {
-		update_context_time(ctx);
-		update_cgrp_time_from_event(event);
-	}
+	ctx_time_update_event(ctx, event);
 
 	perf_event_update_time(event);
 	if (data->group)
@@ -4718,10 +4726,7 @@ static int perf_event_read(struct perf_event *event, bool group)
 		 * May read while context is not active (e.g., thread is
 		 * blocked), in that case we cannot update context time
 		 */
-		if (ctx->is_active & EVENT_TIME) {
-			update_context_time(ctx);
-			update_cgrp_time_from_event(event);
-		}
+		ctx_time_update_event(ctx, event);
 
 		perf_event_update_time(event);
 		if (group)
-- 
2.51.0



