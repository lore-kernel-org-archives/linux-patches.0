Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 662451C9B99;
	Tue,  8 Oct 2024 12:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728392136; cv=none; b=p4IX3mIa+vTuf/Du1QwN4WbwqnmUYlf6vWU3diQTY6HI3o+eqF49JDLJSf4mlwq7vUE6Bg0HXyWeWKoohO9GA6NthJrfOgBE1w9JUuF9BDYer0LSSqDaZwLxj0Y82orqMgnS2S5KjbvKAHXd9/oOYvtZ7b6/WCK6+4HJjC6wVOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728392136; c=relaxed/simple;
	bh=hJ7JURUiqp+ib7cFNsnXZkekfkFOIJhhyIXlEA2qONI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PqUg7bKtfyLMVUKuvFQ2ZDo8SFQYS6G0gEspyuhudCjirPlfq5xjPvXZF+o3q3JbmeEy/D2+LF4GbihKzd1Zul3CQskAnUXEwUECtuUQwK152cadbrA/+7knlcMgTLejbVHmn1cayADlo4ig8umjM27F/Bmcw16SrgbZ3e79gvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x7AkKCOx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x7AkKCOx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8CD4C4CEC7;
	Tue,  8 Oct 2024 12:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728392136;
	bh=hJ7JURUiqp+ib7cFNsnXZkekfkFOIJhhyIXlEA2qONI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x7AkKCOxf29G0yCgz0GsBxTIssnpdNrRt3sI5G9YPcx4be4ZAZIXJwA31v5T+u1ZA
	 qw0r8Haf0LyRlHK6mSpPDUrbEC42n2o5O3V2BsLsYbQEUg7Oe67o6eWxv1jFcJlU8u
	 ah+vtwonwTTri4va+bJXU4cV1ekcl0GOeLRDNHD0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengfei Xu <pengfei.xu@intel.com>,
	Naresh Kamboju <naresh.kamboju@linaro.org>,
	Namhyung Kim <namhyung@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 326/558] perf: Really fix event_function_call() locking
Date: Tue,  8 Oct 2024 14:05:56 +0200
Message-ID: <20241008115715.134080127@linuxfoundation.org>
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

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit fe826cc2654e8561b64246325e6a51b62bf2488c ]

Commit 558abc7e3f89 ("perf: Fix event_function_call() locking") lost
IRQ disabling by mistake.

Fixes: 558abc7e3f89 ("perf: Fix event_function_call() locking")
Reported-by: Pengfei Xu <pengfei.xu@intel.com>
Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
Tested-by: Pengfei Xu <pengfei.xu@intel.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 4339df585d42d..62a5d50b850ed 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -263,8 +263,8 @@ static int event_function(void *info)
 static void event_function_call(struct perf_event *event, event_f func, void *data)
 {
 	struct perf_event_context *ctx = event->ctx;
-	struct perf_cpu_context *cpuctx = this_cpu_ptr(&perf_cpu_context);
 	struct task_struct *task = READ_ONCE(ctx->task); /* verified in event_function */
+	struct perf_cpu_context *cpuctx;
 	struct event_function_struct efs = {
 		.event = event,
 		.func = func,
@@ -292,22 +292,25 @@ static void event_function_call(struct perf_event *event, event_f func, void *da
 	if (!task_function_call(task, event_function, &efs))
 		return;
 
+	local_irq_disable();
+	cpuctx = this_cpu_ptr(&perf_cpu_context);
 	perf_ctx_lock(cpuctx, ctx);
 	/*
 	 * Reload the task pointer, it might have been changed by
 	 * a concurrent perf_event_context_sched_out().
 	 */
 	task = ctx->task;
-	if (task == TASK_TOMBSTONE) {
-		perf_ctx_unlock(cpuctx, ctx);
-		return;
-	}
+	if (task == TASK_TOMBSTONE)
+		goto unlock;
 	if (ctx->is_active) {
 		perf_ctx_unlock(cpuctx, ctx);
+		local_irq_enable();
 		goto again;
 	}
 	func(event, NULL, ctx, data);
+unlock:
 	perf_ctx_unlock(cpuctx, ctx);
+	local_irq_enable();
 }
 
 /*
-- 
2.43.0



