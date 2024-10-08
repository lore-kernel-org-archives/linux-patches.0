Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85B8D1CCB32;
	Tue,  8 Oct 2024 12:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392073; cv=none; b=igiBnRK5vghWTFo6HwtFHCejgg8Ud53S96JYqXKAIF2hYqlTulbJbyjO5d0No8CqjO4n0MwnItd2NK1cBCq9E/jwHuu6yQxjLawmvuM63mcPIC5WQZ3u7gjkzzgB/aPfbVdbmJzGdpwPbBoJzamFxEDzRvpJe5NXkh6b+SZcInI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392073; c=relaxed/simple;
	bh=Zhuptf/IQLTJ6+C/WqFgwZBMOLQv40FALk46AFguEhA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z+TKrr2/e5vwBwd3uVLaGCunCoVNuihJxx3tFNWcdYgC+z7hZFzls+NSsUnG5e4x5rZ0lqrn0wfV9IlAK2HAEIW6rWHfi7eWTW+Td+uWnXqqC58UoQ9gHDsN4NmabyRr2D3yvJXcwVydTBLT/Zp9ExzpJwKu3TIga6MzpsAYNB0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xxid14ib; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xxid14ib"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83015C4CEC7;
	Tue,  8 Oct 2024 12:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392073;
	bh=Zhuptf/IQLTJ6+C/WqFgwZBMOLQv40FALk46AFguEhA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xxid14ibPAyDpH9yxlYFBXe3qNU77lSGPAFy/cE9usFE13jDqBNMl0rdEmMafvgCI
	 m6RaSQcinP10us4becIP4Iw21ZosOGTJF3K0n2QrlTEhGo8JzoW18r0CIc2ELohPQd
	 4JThP3vku6DR4vVIG//5cvM1aMfPxZ44R4nxWgu4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 277/558] perf: Fix event_function_call() locking
Date: Tue,  8 Oct 2024 14:05:07 +0200
Message-ID: <20241008115713.229414317@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 558abc7e3f895049faa46b08656be4c60dc6e9fd ]

All the event_function/@func call context already uses perf_ctx_lock()
except for the !ctx->is_active case. Make it all consistent.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Kan Liang <kan.liang@linux.intel.com>
Reviewed-by: Namhyung Kim <namhyung@kernel.org>
Link: https://lore.kernel.org/r/20240807115550.138301094@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index b21c8f24a9876..4339df585d42d 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -263,6 +263,7 @@ static int event_function(void *info)
 static void event_function_call(struct perf_event *event, event_f func, void *data)
 {
 	struct perf_event_context *ctx = event->ctx;
+	struct perf_cpu_context *cpuctx = this_cpu_ptr(&perf_cpu_context);
 	struct task_struct *task = READ_ONCE(ctx->task); /* verified in event_function */
 	struct event_function_struct efs = {
 		.event = event,
@@ -291,22 +292,22 @@ static void event_function_call(struct perf_event *event, event_f func, void *da
 	if (!task_function_call(task, event_function, &efs))
 		return;
 
-	raw_spin_lock_irq(&ctx->lock);
+	perf_ctx_lock(cpuctx, ctx);
 	/*
 	 * Reload the task pointer, it might have been changed by
 	 * a concurrent perf_event_context_sched_out().
 	 */
 	task = ctx->task;
 	if (task == TASK_TOMBSTONE) {
-		raw_spin_unlock_irq(&ctx->lock);
+		perf_ctx_unlock(cpuctx, ctx);
 		return;
 	}
 	if (ctx->is_active) {
-		raw_spin_unlock_irq(&ctx->lock);
+		perf_ctx_unlock(cpuctx, ctx);
 		goto again;
 	}
 	func(event, NULL, ctx, data);
-	raw_spin_unlock_irq(&ctx->lock);
+	perf_ctx_unlock(cpuctx, ctx);
 }
 
 /*
-- 
2.43.0



