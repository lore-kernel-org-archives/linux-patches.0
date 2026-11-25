Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624650;
	b=dH5nQeCTko95Fmotdsqzm+OWdRkU7JsX5uURaHRV0Jp7aEqMcVYuz0Bp2kb9n8K5YTsJ
	 fgruuqs6MOwDTaErRgOo7a0ftebRTNwo96j1LKXS1/KcEYgg2nS4WkBnUNJtinETlA0wz
	 pm24uW9B0eoGWn4crFDnSA2YAefJg+qB97yoSd08HbQ3Zppq6FzIkHwkdLJ/dQD2qXzLG
	 eQDoGBHL4P8T9CXcXYRVbgAQcKw4k/Y5BZOn5uN3fczbqy9DqIndmj3Iv4Ib3yswUKxrH
	 v1I3+LHHFzrTZgNbyWkgqcRCglQ+j7dAt6l1B7r4M2cvloNQHkq3/BZjyO88QGA2JSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624650;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nsf7xyJeUNQORCxSrpI0EqlT9GtFyHQGxfKWrw0FQ+A=;
	b=oCHjkCWfiv2AZ47gpCplnFSCzEn0svlnIjfT1ImtVt8gb1rnaUwdExEneZNndSdnYmy8
	 QA2WTrQ/GXpFzG79Flr8rfgGtvZhr27FxmDrKp9ukPBlgpumoFgnGIFdqsPuanOAlUFCN
	 NuzNd7iIwldqUBDN2OITSJQWwXKLJTBsoJo0TUAAIDSlLCLVtggNwovIfS32G34JYi8Dl
	 V1D0zlfD7vH4yJNPGPbsBbKIGlxcbVJDv2Xh+dNjAOZwIBDDT+7znnQQfViqjuv7FbA4M
	 14Vf1SAV8aTxaIStVAzT32Tn7rtmaOsbAOmc9Z+uhAaeqZwZFsWO9/UWhzQutQF6kjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=USsUocKi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBDF3606A333;
	Wed, 25 Nov 2026 16:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=USsUocKi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95F2B1F000D4;
	Wed, 25 Nov 2026 16:37:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624650;
	bh=nsf7xyJeUNQORCxSrpI0EqlT9GtFyHQGxfKWrw0FQ+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=USsUocKix6m4oQ4XbRFQjrhlC0H826Aqa/d1p7Mre64pDM/2ws1VhjZFM/uBMfQLE
	 wg0ejvM2GGPXN+N3pi5/WNwr2aRozvj3bK8NccaYBoexy5Ggu7rm20mqp4DaoaeMV0
	 aZm80VoMV/EJx+zAs+MobGTotGZ5ETNLKU9QSQ58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	Ravi Bangoria <ravi.bangoria@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 261/816] perf/core: Detach struct perf_cpu_pmu_context and struct pmu lifetimes
Date: Wed, 25 Nov 2026 15:30:09 +0100
Message-ID: <20261125143855.249548054@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit 4eabf533fb1886089ef57e0c8ec52048b1741e39 ]

In prepration for being able to unregister a PMU with existing events,
it becomes important to detach struct perf_cpu_pmu_context lifetimes
from that of struct pmu.

Notably struct perf_cpu_pmu_context embeds a struct perf_event_pmu_context
that can stay referenced until the last event goes.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Ravi Bangoria <ravi.bangoria@amd.com>
Link: https://lore.kernel.org/r/20241104135518.760214287@infradead.org
Stable-dep-of: 3bbd85b2f67a ("perf: Fix racy update of cpc->hrtimer_interval")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/perf_event.h |  4 +--
 kernel/events/core.c       | 56 ++++++++++++++++++++++++++++++++------
 2 files changed, 49 insertions(+), 11 deletions(-)

diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
index 58f7d4fe72819..d88c0091e57dd 100644
--- a/include/linux/perf_event.h
+++ b/include/linux/perf_event.h
@@ -344,7 +344,7 @@ struct pmu {
 	 */
 	unsigned int			scope;
 
-	struct perf_cpu_pmu_context __percpu *cpu_pmu_context;
+	struct perf_cpu_pmu_context __percpu **cpu_pmu_context;
 	atomic_t			exclusive_cnt; /* < 0: cpu; > 0: tsk */
 	int				task_ctx_nr;
 	int				hrtimer_interval_ms;
@@ -922,7 +922,7 @@ struct perf_event_pmu_context {
 	struct list_head		pinned_active;
 	struct list_head		flexible_active;
 
-	/* Used to avoid freeing per-cpu perf_event_pmu_context */
+	/* Used to identify the per-cpu perf_event_pmu_context */
 	unsigned int			embedded : 1;
 
 	unsigned int			nr_events;
diff --git a/kernel/events/core.c b/kernel/events/core.c
index ba6603bd03428..45b7a1fdc964d 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -1192,7 +1192,7 @@ static int perf_mux_hrtimer_restart_ipi(void *arg)
 
 static __always_inline struct perf_cpu_pmu_context *this_cpc(struct pmu *pmu)
 {
-	return this_cpu_ptr(pmu->cpu_pmu_context);
+	return *this_cpu_ptr(pmu->cpu_pmu_context);
 }
 
 void perf_pmu_disable(struct pmu *pmu)
@@ -5006,11 +5006,14 @@ find_get_pmu_context(struct pmu *pmu, struct perf_event_context *ctx,
 		 */
 		struct perf_cpu_pmu_context *cpc;
 
-		cpc = per_cpu_ptr(pmu->cpu_pmu_context, event->cpu);
+		cpc = *per_cpu_ptr(pmu->cpu_pmu_context, event->cpu);
 		epc = &cpc->epc;
 		raw_spin_lock_irq(&ctx->lock);
 		if (!epc->ctx) {
-			atomic_set(&epc->refcount, 1);
+			/*
+			 * One extra reference for the pmu; see perf_pmu_free().
+			 */
+			atomic_set(&epc->refcount, 2);
 			epc->embedded = 1;
 			list_add(&epc->pmu_ctx_entry, &ctx->pmu_ctx_list);
 			epc->ctx = ctx;
@@ -5086,6 +5089,15 @@ static void get_pmu_ctx(struct perf_event_pmu_context *epc)
 	WARN_ON_ONCE(!atomic_inc_not_zero(&epc->refcount));
 }
 
+static void free_cpc_rcu(struct rcu_head *head)
+{
+	struct perf_cpu_pmu_context *cpc =
+		container_of(head, typeof(*cpc), epc.rcu_head);
+
+	kfree(cpc->epc.task_ctx_data);
+	kfree(cpc);
+}
+
 static void free_epc_rcu(struct rcu_head *head)
 {
 	struct perf_event_pmu_context *epc = container_of(head, typeof(*epc), rcu_head);
@@ -5120,8 +5132,10 @@ static void put_pmu_ctx(struct perf_event_pmu_context *epc)
 
 	raw_spin_unlock_irqrestore(&ctx->lock, flags);
 
-	if (epc->embedded)
+	if (epc->embedded) {
+		call_rcu(&epc->rcu_head, free_cpc_rcu);
 		return;
+	}
 
 	call_rcu(&epc->rcu_head, free_epc_rcu);
 }
@@ -11716,7 +11730,7 @@ perf_event_mux_interval_ms_store(struct device *dev,
 	cpus_read_lock();
 	for_each_online_cpu(cpu) {
 		struct perf_cpu_pmu_context *cpc;
-		cpc = per_cpu_ptr(pmu->cpu_pmu_context, cpu);
+		cpc = *per_cpu_ptr(pmu->cpu_pmu_context, cpu);
 		cpc->hrtimer_interval = ns_to_ktime(NSEC_PER_MSEC * timer);
 
 		cpu_function_call(cpu, perf_mux_hrtimer_restart_ipi, cpc);
@@ -11889,7 +11903,25 @@ static void perf_pmu_free(struct pmu *pmu)
 		device_del(pmu->dev);
 		put_device(pmu->dev);
 	}
-	free_percpu(pmu->cpu_pmu_context);
+
+	if (pmu->cpu_pmu_context) {
+		int cpu;
+
+		for_each_possible_cpu(cpu) {
+			struct perf_cpu_pmu_context *cpc;
+
+			cpc = *per_cpu_ptr(pmu->cpu_pmu_context, cpu);
+			if (!cpc)
+				continue;
+			if (cpc->epc.embedded) {
+				/* refcount managed */
+				put_pmu_ctx(&cpc->epc);
+				continue;
+			}
+			kfree(cpc);
+		}
+		free_percpu(pmu->cpu_pmu_context);
+	}
 }
 
 DEFINE_FREE(pmu_unregister, struct pmu *, if (_T) perf_pmu_free(_T))
@@ -11928,14 +11960,20 @@ int perf_pmu_register(struct pmu *_pmu, const char *name, int type)
 			return ret;
 	}
 
-	pmu->cpu_pmu_context = alloc_percpu(struct perf_cpu_pmu_context);
+	pmu->cpu_pmu_context = alloc_percpu(struct perf_cpu_pmu_context *);
 	if (!pmu->cpu_pmu_context)
 		return -ENOMEM;
 
 	for_each_possible_cpu(cpu) {
-		struct perf_cpu_pmu_context *cpc;
+		struct perf_cpu_pmu_context *cpc =
+			kmalloc_node(sizeof(struct perf_cpu_pmu_context),
+				     GFP_KERNEL | __GFP_ZERO,
+				     cpu_to_node(cpu));
+
+		if (!cpc)
+			return -ENOMEM;
 
-		cpc = per_cpu_ptr(pmu->cpu_pmu_context, cpu);
+		*per_cpu_ptr(pmu->cpu_pmu_context, cpu) = cpc;
 		__perf_init_event_pmu_context(&cpc->epc, pmu);
 		__perf_mux_hrtimer_init(cpc, cpu);
 	}
-- 
2.53.0



