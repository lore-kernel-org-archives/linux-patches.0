Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDA6F27F4CB;
	Tue, 27 May 2025 16:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365010; cv=none; b=AGPf7ZdU3mMiiFDKQ9ugEiea8ENn8VocPK0laD+DibcaSxdf3NsGJ9y0hr8BnBFiXY24Va7OjfOZA5Jq4nD+NZiyQ2tbEEnuVuf/Rq0EKC/a9MAvpZFgIwVaVMHlJpz0Zo3W4gfsqpev2FLcTSvirr8zU3XM8BLHUvodp90dQRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365010; c=relaxed/simple;
	bh=ODZ12rp8NkDF3mnDrpyCI+N6n8ZX5Eu60XtPxc2zFBY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eZuZkS87DtJjvWZtkHZRdsyeW+mEgs1WT+O/JjZhoQt05ZFF+2tpUGLjxaQ/ozpGBTIdFnHt0Jrf7SZVgtoIKbiqqbQSyg84Sj7YhKLfjreqRrnvWyfiSU2BxobTbiuGNNFoDc16W/LGVaqZdbZFnUO1svplVl1LKwzaA87BTG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rfw5weud; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rfw5weud"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 636FBC4CEE9;
	Tue, 27 May 2025 16:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365009;
	bh=ODZ12rp8NkDF3mnDrpyCI+N6n8ZX5Eu60XtPxc2zFBY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rfw5weudXaCigyR3hS2dWSdCVHV0trG1RJbKgOtHZ9YHscAa8HUdbk+mGF+xPXiD8
	 SUYD6EDe1qg1R3YL+KGrRy1pidyDk8QBU3YwDdGaRb3xvegtRPyqMKuOn4Wmp0dE97
	 9BeltF8pPnBmm8e5GAwgDgDdM0B2CdY/K4L0JXos=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	Ravi Bangoria <ravi.bangoria@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 238/626] perf/core: Clean up perf_try_init_event()
Date: Tue, 27 May 2025 18:22:11 +0200
Message-ID: <20250527162454.683967810@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
User-Agent: quilt/0.68
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

[ Upstream commit da02f54e81db2f7bf6af9d1d0cfc5b41ec6d0dcb ]

Make sure that perf_try_init_event() doesn't leave event->pmu nor
event->destroy set on failure.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Ravi Bangoria <ravi.bangoria@amd.com>
Link: https://lore.kernel.org/r/20250205102449.110145835@infradead.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 65 ++++++++++++++++++++++++++------------------
 1 file changed, 38 insertions(+), 27 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index edafe9fc4bdd0..19dde12f23b83 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -11978,40 +11978,51 @@ static int perf_try_init_event(struct pmu *pmu, struct perf_event *event)
 	if (ctx)
 		perf_event_ctx_unlock(event->group_leader, ctx);
 
-	if (!ret) {
-		if (!(pmu->capabilities & PERF_PMU_CAP_EXTENDED_REGS) &&
-		    has_extended_regs(event))
-			ret = -EOPNOTSUPP;
+	if (ret)
+		goto err_pmu;
 
-		if (pmu->capabilities & PERF_PMU_CAP_NO_EXCLUDE &&
-		    event_has_any_exclude_flag(event))
-			ret = -EINVAL;
+	if (!(pmu->capabilities & PERF_PMU_CAP_EXTENDED_REGS) &&
+	    has_extended_regs(event)) {
+		ret = -EOPNOTSUPP;
+		goto err_destroy;
+	}
 
-		if (pmu->scope != PERF_PMU_SCOPE_NONE && event->cpu >= 0) {
-			const struct cpumask *cpumask = perf_scope_cpu_topology_cpumask(pmu->scope, event->cpu);
-			struct cpumask *pmu_cpumask = perf_scope_cpumask(pmu->scope);
-			int cpu;
-
-			if (pmu_cpumask && cpumask) {
-				cpu = cpumask_any_and(pmu_cpumask, cpumask);
-				if (cpu >= nr_cpu_ids)
-					ret = -ENODEV;
-				else
-					event->event_caps |= PERF_EV_CAP_READ_SCOPE;
-			} else {
-				ret = -ENODEV;
-			}
-		}
+	if (pmu->capabilities & PERF_PMU_CAP_NO_EXCLUDE &&
+	    event_has_any_exclude_flag(event)) {
+		ret = -EINVAL;
+		goto err_destroy;
+	}
 
-		if (ret && event->destroy)
-			event->destroy(event);
+	if (pmu->scope != PERF_PMU_SCOPE_NONE && event->cpu >= 0) {
+		const struct cpumask *cpumask;
+		struct cpumask *pmu_cpumask;
+		int cpu;
+
+		cpumask = perf_scope_cpu_topology_cpumask(pmu->scope, event->cpu);
+		pmu_cpumask = perf_scope_cpumask(pmu->scope);
+
+		ret = -ENODEV;
+		if (!pmu_cpumask || !cpumask)
+			goto err_destroy;
+
+		cpu = cpumask_any_and(pmu_cpumask, cpumask);
+		if (cpu >= nr_cpu_ids)
+			goto err_destroy;
+
+		event->event_caps |= PERF_EV_CAP_READ_SCOPE;
 	}
 
-	if (ret) {
-		event->pmu = NULL;
-		module_put(pmu->module);
+	return 0;
+
+err_destroy:
+	if (event->destroy) {
+		event->destroy(event);
+		event->destroy = NULL;
 	}
 
+err_pmu:
+	event->pmu = NULL;
+	module_put(pmu->module);
 	return ret;
 }
 
-- 
2.39.5



