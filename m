Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FC1929DB8F;
	Tue, 31 Mar 2026 16:57:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976259; cv=none; b=plVUK653M16GfM4eKsSeNmHi2DaSiiQks18yjcDOsjpl6S4w4rG3xuEuTPVNM8Ezk8I6b1QPYnLWn77l9rUTSB6ZRQ7ns/0SLiISJmJP8sP9/pnnzACdUUiMpiu7XXOlqNv/TZBlUf4grnMr3zn6MnRS7bgUw5lNLwyyJukqmVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976259; c=relaxed/simple;
	bh=BOnfZCw2DaVjebRsQEAshGR/uildvpOZAyZ3fpWBRjo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nryH919zQvkg3/xD7jtlL4jrkmv6RAliAEQOyIswSbw5+aXr1TqtDbgLwmkOKssTadZzZ3Hm7keE89H0zCTSUqnv8+sxbkmCdkTC3hsj1LXrJkBG+iA+pARjD+Wmr4AFq9fJlmdlbpj68eaAkjEPdsyrhRa97ahdBC6/wqIjmZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cmoDyfrP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cmoDyfrP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 988B4C19423;
	Tue, 31 Mar 2026 16:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976258;
	bh=BOnfZCw2DaVjebRsQEAshGR/uildvpOZAyZ3fpWBRjo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cmoDyfrPxfMkGLUVpCEgibj/+HcPoKBtwTpAqkfFDBacOLiYwTDXxGrzw1nIf0Jhd
	 QF46Q0ewhvST6UNMn8ijOJTWTnwL5DqkvzgWDimOWj54GnguFQtuCYpkxOyAmCW5Nn
	 CX6GN/cD5prAxcSl0JbJnN9lq0aECzCtdRlx6yDc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Rosenberg <olrose55@gmail.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ian Rogers <irogers@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 005/309] perf: Make sure to use pmu_ctx->pmu for groups
Date: Tue, 31 Mar 2026 18:18:28 +0200
Message-ID: <20260331161753.674185793@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index b7e73ac3e512f..6b6fea8d33e04 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -4671,7 +4671,7 @@ static void __perf_event_read(void *info)
 	struct perf_event *sub, *event = data->event;
 	struct perf_event_context *ctx = event->ctx;
 	struct perf_cpu_context *cpuctx = this_cpu_ptr(&perf_cpu_context);
-	struct pmu *pmu = event->pmu;
+	struct pmu *pmu;
 
 	/*
 	 * If this is a task context, we need to check whether it is
@@ -4683,7 +4683,7 @@ static void __perf_event_read(void *info)
 	if (ctx->task && cpuctx->task_ctx != ctx)
 		return;
 
-	raw_spin_lock(&ctx->lock);
+	guard(raw_spinlock)(&ctx->lock);
 	ctx_time_update_event(ctx, event);
 
 	perf_event_update_time(event);
@@ -4691,25 +4691,22 @@ static void __perf_event_read(void *info)
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
@@ -14390,7 +14387,7 @@ inherit_event(struct perf_event *parent_event,
 	get_ctx(child_ctx);
 	child_event->ctx = child_ctx;
 
-	pmu_ctx = find_get_pmu_context(child_event->pmu, child_ctx, child_event);
+	pmu_ctx = find_get_pmu_context(parent_event->pmu_ctx->pmu, child_ctx, child_event);
 	if (IS_ERR(pmu_ctx)) {
 		free_event(child_event);
 		return ERR_CAST(pmu_ctx);
-- 
2.51.0



