Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD9D81DF745;
	Tue,  8 Oct 2024 12:25:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390339; cv=none; b=MiUcvIpFG0HQmRk/0xt25gzlOPmVtpaoMz0sOXRa6uJGdWzttzJkTfHkvq0diDxAsZyuqvB89kzv2bcHdQ/a6ADmoaNUqkNTf+LwdOumub9gA+ZBzvoghIgDuKAyc5exF48XgIa2n5M5/a+N9WrciQdWxFxpM//ZK+E7Dca+bgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390339; c=relaxed/simple;
	bh=MAFc7y06iMBNPGfnTyr41TgqjNPtWowu9d57SDgUoHs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H2oqoVN6Ru7HieCVVx+0mNomWIbx+kstO7b6ZYbH2E+F7fhr+UIoRvldHP5GvFiB7+VynnwwHzQehnCSh+OVgysMevT1NdR9UkrKFaT5vNg/n/XhAiPH1sW+HDscgjigsQrOzr2ZW7njyOkSgl57XuSpz0w89La9exNYBwaFQ6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w1d4XTH4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w1d4XTH4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29A73C4CED5;
	Tue,  8 Oct 2024 12:25:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390339;
	bh=MAFc7y06iMBNPGfnTyr41TgqjNPtWowu9d57SDgUoHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w1d4XTH45mfUf6GjUfDOnGdNMYbfujYPzFdGzEy4cTl0sbMRFo8Pb3MA7hNHF94ad
	 Y2x00exI+cBKDsbjB48BDFywosSKb6YyPZgtOzyV7HWsVn5wzqmN/IRgfjj20tPmJI
	 lT4QW0Uh60712XCygXGMNowoNIrgMTa/P82omzRc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 228/482] perf: Fix event_function_call() locking
Date: Tue,  8 Oct 2024 14:04:51 +0200
Message-ID: <20241008115657.277972013@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 081d9692ce747..e18a07de9920a 100644
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



