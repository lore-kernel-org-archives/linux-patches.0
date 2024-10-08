Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C66E1DED4E;
	Tue,  8 Oct 2024 13:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393692; cv=none; b=a6FWL2xHMe+h5OsYC06KfZeZTTs9K3hMefBR1VJSXpM73hZwCR6KVvqT71BAfy0mkVHuTVZWlcFw9ZdeXxtEebTLHnaFP0shvqSErAEmaXyK5P9ZqzF4hVfg2ABat6VlK58Br8Dr30AKDSvTx9gNXDKl410m3vwotw2uebHt9FQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393692; c=relaxed/simple;
	bh=42FEqSaFp6AYmmP74VC3ZJYQqwYA7XQOWl0mTDjaKV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DJ1HhjWqXhx+n6k/crbmuDFFNfVPMrSnc+eB0Z9DJDUSXv6Bl4LvXx/0dIn7k4fNL0DoyiGzTvXIyBCWB+gcBlpg76nRsEt1534z3S3rTOcfqYx9zD/LQOniyW2U/93qhRfSux+EuorS7fCiFZzcl3EKZ+hqe/JBmW0VeBeTArw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cz9eJOR5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cz9eJOR5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 038D7C4CEC7;
	Tue,  8 Oct 2024 13:21:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393692;
	bh=42FEqSaFp6AYmmP74VC3ZJYQqwYA7XQOWl0mTDjaKV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cz9eJOR58uJYrHKmt5HSkKNsdD5azy7ukd/bR4N48Ahma+X3tE6Yzmscg7v0f2qJV
	 w9lPCV4N8SRncOo/I2g1kl7ghD0WczimMw6w4YPuDfFsBTmst0HCQsuGqB5M6M2ksF
	 KFT5jvmUJdbmKsDQCzwZpCwqZMx+n5odBYvx3CQc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengfei Xu <pengfei.xu@intel.com>,
	Naresh Kamboju <naresh.kamboju@linaro.org>,
	Namhyung Kim <namhyung@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 196/386] perf: Really fix event_function_call() locking
Date: Tue,  8 Oct 2024 14:07:21 +0200
Message-ID: <20241008115637.119920158@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 18eab7f50ecce..0ff381fa2f588 100644
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



