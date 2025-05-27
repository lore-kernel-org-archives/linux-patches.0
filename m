Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8447B3C01;
	Tue, 27 May 2025 17:33:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367225; cv=none; b=iXqaNZy1gAgfo3ElcflGZlvav3YOaaqRxJxVA48xzdsK6dJHBMOE7ApZCqvTkCV3UDGtSm+hyiDrZ3BZnQdSioIcGkGw4faouDBcsgCDxHS4Ja9AxTyfqWRp6v8J6uLUBHnamlmU9FKY36iRZGvQ8uhVQbHgX63KItQ+xlefSq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367225; c=relaxed/simple;
	bh=3LAh/BjL2Ue9IlRQobdyoFoEhe8P9TBE1VdMIS2ipJQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nAcs+iKPu9Li+UsnjvqsIfpjgCTbE+S0OGk+PVlQPJ1cfCbmYgM4iRe9krvgPoVdsZ74lpap9/AarEL+nmLdeUJ5+dUZxaB36vEC5c1BQpDNmxXTMvqR8d0w233LOvY6De37ipv5FgEe5yom+IKHdRx8BxVP4xF3igte7E7aTXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zpUWnMUU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zpUWnMUU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E63B7C4CEE9;
	Tue, 27 May 2025 17:33:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367225;
	bh=3LAh/BjL2Ue9IlRQobdyoFoEhe8P9TBE1VdMIS2ipJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zpUWnMUUbmZhW7ycwvfHTF/Mgkffb1Nt4QGYOagMvH97Ow7SzDKqQdJpFrTLpc60d
	 2gveXMUwL7JseEGoigM31RyQ8oH+xdBTyTm50BmPNksVE3y2qomwgUiDH8MCrv0XX8
	 MVA8xpf59bAEvjuTe8dktRabwTEy58guym76IX68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ingo Molnar <mingo@kernel.org>,
	Ravi Bangoria <ravi.bangoria@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 288/783] perf/core: Clean up perf_try_init_event()
Date: Tue, 27 May 2025 18:21:25 +0200
Message-ID: <20250527162524.818779021@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 93ce810384c92..de838d3819ca7 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -12020,40 +12020,51 @@ static int perf_try_init_event(struct pmu *pmu, struct perf_event *event)
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



