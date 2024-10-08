Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E606C1DEFD6;
	Tue,  8 Oct 2024 12:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390372; cv=none; b=uuZ0dJL5hTMDzoXx96Ni4mIvqOzDJEZ8T7SVai6dirV2sqDxkAVUpIFKrkTO0ENh5gg3acMfnmNIoux+m94OKbV/6dGEX32E+ATaufkFYUvERaNadEWDnUJkPEaVDeCqz+XOvIgexhsjh2zPAtTWAZ2Wdbp4eKKim6Qx1y9BG9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390372; c=relaxed/simple;
	bh=Dw3qzdsBYRnzfOcBWtfh91FYTCpbuCavPo6KBDPhkXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eV2xWoJLpXyRkFKdS5nEH3k9fgVSeQ68n6ARZTPvwPUm9ghQKK/H13Spz2Pwj8P33lkGThDS8jondjhz+Z9jTysUPjQKKiwT1NEV/4BpAz0MO4cZZGHfKlkRX5GBh+Nd1Gl4oyceqzjQNtZaAf7OZAVrOOwBLp4KKIDr67sGeVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JyCLVdiD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JyCLVdiD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CED1C4CEC7;
	Tue,  8 Oct 2024 12:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390371;
	bh=Dw3qzdsBYRnzfOcBWtfh91FYTCpbuCavPo6KBDPhkXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JyCLVdiDhfyWC2g9S75YVMDS+8kni/rVmY98LfHAyapLmB0xuXBm9yDIeYCcS42g1
	 1mCR9Nt4eaTDAgptStsumcCO4h8log2ZpiAPcQezOUlGPQYSvJpVWbe8Tc4z/D3kvo
	 ZKdtKwoQA3ZXFI4mq1Cn+45hisyrpTc0jGNQTTFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengfei Xu <pengfei.xu@intel.com>,
	Naresh Kamboju <naresh.kamboju@linaro.org>,
	Namhyung Kim <namhyung@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 270/482] perf: Really fix event_function_call() locking
Date: Tue,  8 Oct 2024 14:05:33 +0200
Message-ID: <20241008115658.906945403@linuxfoundation.org>
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
index e18a07de9920a..e5188b0899b63 100644
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



