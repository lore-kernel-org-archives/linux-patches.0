Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6735E2D1F40;
	Tue, 31 Mar 2026 16:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975642; cv=none; b=TOC4DcghcQkzqOCNb+yWvEcQyftF5yrlsRPFiSHSUBsukkTuwUmVkrJIcxSQcaoCGlIUgSAsCFog4DrHzJSWyysMsCSVlsNeq9H4Hpm/81+abCB+Dg3xiV1qfyOTneVhtBVv6Rx8J/vVCrh1uEPrHhxwxTw0oyOunGQpKFvLxCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975642; c=relaxed/simple;
	bh=81koxG8+RrgErkjHpSVEfgoW3hswnnll6/5i3xZilUc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eZzoBVPDp8aSgu5qHpP6ENdX9PCuGYKBf1C9Odtl/WSzjye3YTv9Gq01e5NNhxap+pVqeUKaUtdJBZavkOyO/q11aa8GZ2DKelQMYH6xep2MDyLDfLp+NfnWPiFU8/DvsKcauF2SM7PyHQWpEZUBt94FZ8A+lR3Q+8LSbWMc+dM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PjP9fhLx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PjP9fhLx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F03ACC19423;
	Tue, 31 Mar 2026 16:47:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975642;
	bh=81koxG8+RrgErkjHpSVEfgoW3hswnnll6/5i3xZilUc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PjP9fhLxtKYR/9RklNP8eBJHM7vrnBOby7s2bo6MbJNxx4zuqygevFl2bT0lEG2vC
	 Q26GZPMHW8OYyAxuhuIX4uG7091LDAZirw/k7kdDrzQVICfZVieo37H+kMzd96Dwcy
	 vTpJAqjXJD5+5+qeDVrL/Pz6y82P5t+/8KEKIy58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Rosenberg <olrose55@gmail.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ian Rogers <irogers@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 003/244] perf: Make sure to use pmu_ctx->pmu for groups
Date: Tue, 31 Mar 2026 18:19:13 +0200
Message-ID: <20260331161741.783686845@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
References: <20260331161741.651718120@linuxfoundation.org>
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

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 4b9ce671960627b2505b3f64742544ae9801df97 ]

Oliver reported that x86_pmu_del() ended up doing an out-of-bound memory access
when group_sched_in() fails and needs to roll back.

This *should* be handled by the transaction callbacks, but he found that when
the group leader is a software event, the transaction handlers of the wrong PMU
are used. Despite the move_group case in perf_event_open() and group_sched_in()
using pmu_ctx->pmu.

Turns out, inherit uses event->pmu to clone the events, effectively undoing the
move_group case for all inherited contexts. Fix this by also making inherit use
pmu_ctx->pmu, ensuring all inherited counters end up in the same pmu context.

Similarly, __perf_event_read() should use equally use pmu_ctx->pmu for the
group case.

Fixes: bd2756811766 ("perf: Rewrite core context handling")
Reported-by: Oliver Rosenberg <olrose55@gmail.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Ian Rogers <irogers@google.com>
Link: https://patch.msgid.link/20260309133713.GB606826@noisy.programming.kicks-ass.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 814b6536b09d4..bcedf9611cf4f 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -4634,7 +4634,7 @@ static void __perf_event_read(void *info)
 	struct perf_event *sub, *event = data->event;
 	struct perf_event_context *ctx = event->ctx;
 	struct perf_cpu_context *cpuctx = this_cpu_ptr(&perf_cpu_context);
-	struct pmu *pmu = event->pmu;
+	struct pmu *pmu;
 
 	/*
 	 * If this is a task context, we need to check whether it is
@@ -4646,7 +4646,7 @@ static void __perf_event_read(void *info)
 	if (ctx->task && cpuctx->task_ctx != ctx)
 		return;
 
-	raw_spin_lock(&ctx->lock);
+	guard(raw_spinlock)(&ctx->lock);
 	ctx_time_update_event(ctx, event);
 
 	perf_event_update_time(event);
@@ -4654,25 +4654,22 @@ static void __perf_event_read(void *info)
 		perf_event_update_sibling_time(event);
 
 	if (event->state != PERF_EVENT_STATE_ACTIVE)
-		goto unlock;
+		return;
 
 	if (!data->group) {
-		pmu->read(event);
+		perf_pmu_read(event);
 		data->ret = 0;
-		goto unlock;
+		return;
 	}
 
+	pmu = event->pmu_ctx->pmu;
 	pmu->start_txn(pmu, PERF_PMU_TXN_READ);
 
-	pmu->read(event);
-
+	perf_pmu_read(event);
 	for_each_sibling_event(sub, event)
 		perf_pmu_read(sub);
 
 	data->ret = pmu->commit_txn(pmu);
-
-unlock:
-	raw_spin_unlock(&ctx->lock);
 }
 
 static inline u64 perf_event_count(struct perf_event *event, bool self)
@@ -13789,7 +13786,7 @@ inherit_event(struct perf_event *parent_event,
 	get_ctx(child_ctx);
 	child_event->ctx = child_ctx;
 
-	pmu_ctx = find_get_pmu_context(child_event->pmu, child_ctx, child_event);
+	pmu_ctx = find_get_pmu_context(parent_event->pmu_ctx->pmu, child_ctx, child_event);
 	if (IS_ERR(pmu_ctx)) {
 		free_event(child_event);
 		return ERR_CAST(pmu_ctx);
-- 
2.51.0



