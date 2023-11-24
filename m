Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8988439FC2;
	Fri, 24 Nov 2023 18:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UNIgJOSh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 165BDC433C8;
	Fri, 24 Nov 2023 18:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700849576;
	bh=hRopyKMJ0giuZsG3Jg4GwK52LnqHW4w5i5xHNZuMknI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UNIgJOSh6CcFC1S4fcNK9135vMPs8kJLj3kq/bEgFlNWFQ1Q43tP3bUkglwhHDH9i
	 G0lhSR4qiuwUx3z0zBSM4YOOfO0JEJF7j3C2FRGRF3qhYZoP4CJCtKReCso8EqDG0p
	 Ui3PghJrt37fFLf9SIhGu8eVR5lorqQ0t/KVgsYo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 6.6 236/530] perf/core: Fix cpuctx refcounting
Date: Fri, 24 Nov 2023 17:46:42 +0000
Message-ID: <20231124172035.237752763@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172028.107505484@linuxfoundation.org>
References: <20231124172028.107505484@linuxfoundation.org>
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

From: Peter Zijlstra <peterz@infradead.org>

commit 889c58b3155ff4c8e8671c95daef63d6fabbb6b1 upstream.

Audit of the refcounting turned up that perf_pmu_migrate_context()
fails to migrate the ctx refcount.

Fixes: bd2756811766 ("perf: Rewrite core context handling")
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Link: https://lkml.kernel.org/r/20230612093539.085862001@infradead.org
Cc: <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/perf_event.h |   13 ++++++++-----
 kernel/events/core.c       |   17 +++++++++++++++++
 2 files changed, 25 insertions(+), 5 deletions(-)

--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -843,11 +843,11 @@ struct perf_event {
 };
 
 /*
- *           ,-----------------------[1:n]----------------------.
- *           V                                                  V
- * perf_event_context <-[1:n]-> perf_event_pmu_context <--- perf_event
- *           ^                      ^     |                     |
- *           `--------[1:n]---------'     `-[n:1]-> pmu <-[1:n]-'
+ *           ,-----------------------[1:n]------------------------.
+ *           V                                                    V
+ * perf_event_context <-[1:n]-> perf_event_pmu_context <-[1:n]- perf_event
+ *                                        |                       |
+ *                                        `--[n:1]-> pmu <-[1:n]--'
  *
  *
  * struct perf_event_pmu_context  lifetime is refcount based and RCU freed
@@ -865,6 +865,9 @@ struct perf_event {
  * ctx->mutex pinning the configuration. Since we hold a reference on
  * group_leader (through the filedesc) it can't go away, therefore it's
  * associated pmu_ctx must exist and cannot change due to ctx->mutex.
+ *
+ * perf_event holds a refcount on perf_event_context
+ * perf_event holds a refcount on perf_event_pmu_context
  */
 struct perf_event_pmu_context {
 	struct pmu			*pmu;
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -4816,6 +4816,11 @@ find_get_pmu_context(struct pmu *pmu, st
 	void *task_ctx_data = NULL;
 
 	if (!ctx->task) {
+		/*
+		 * perf_pmu_migrate_context() / __perf_pmu_install_event()
+		 * relies on the fact that find_get_pmu_context() cannot fail
+		 * for CPU contexts.
+		 */
 		struct perf_cpu_pmu_context *cpc;
 
 		cpc = per_cpu_ptr(pmu->cpu_pmu_context, event->cpu);
@@ -12877,6 +12882,9 @@ static void __perf_pmu_install_event(str
 				     int cpu, struct perf_event *event)
 {
 	struct perf_event_pmu_context *epc;
+	struct perf_event_context *old_ctx = event->ctx;
+
+	get_ctx(ctx); /* normally find_get_context() */
 
 	event->cpu = cpu;
 	epc = find_get_pmu_context(pmu, ctx, event);
@@ -12885,6 +12893,11 @@ static void __perf_pmu_install_event(str
 	if (event->state >= PERF_EVENT_STATE_OFF)
 		event->state = PERF_EVENT_STATE_INACTIVE;
 	perf_install_in_context(ctx, event, cpu);
+
+	/*
+	 * Now that event->ctx is updated and visible, put the old ctx.
+	 */
+	put_ctx(old_ctx);
 }
 
 static void __perf_pmu_install(struct perf_event_context *ctx,
@@ -12923,6 +12936,10 @@ void perf_pmu_migrate_context(struct pmu
 	struct perf_event_context *src_ctx, *dst_ctx;
 	LIST_HEAD(events);
 
+	/*
+	 * Since per-cpu context is persistent, no need to grab an extra
+	 * reference.
+	 */
 	src_ctx = &per_cpu_ptr(&perf_cpu_context, src_cpu)->ctx;
 	dst_ctx = &per_cpu_ptr(&perf_cpu_context, dst_cpu)->ctx;
 


