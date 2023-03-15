Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C3794431
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 12:29:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0C3EC433D2;
	Wed, 15 Mar 2023 12:29:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678883387;
	bh=tYrpwRVSFQGB4hx/fIKwV3Yn6VpDvkmRrRwPxQiYFWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=inYTtw5OYTU15WCZ2CeypPto1S9KCaH5m6knMHSkYSIuKy1vjnHdaasJVvt7SIzc2
	 x3x4YT3pffdqmQKkECH+O3s/7pZHCO+1Gj+5mAmbIpoA0fzawiYJ2PMFGX6iLWEeSp
	 J63ysUn9leZqCOl4iqDalmK4i4ySxa71rtXq1LM8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	"Qais Yousef (Google)" <qyousef@layalina.io>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Vincent Guittot <vincent.guittot@linaro.org>
Subject: [PATCH 5.15 124/145] sched/fair: Fixes for capacity inversion detection
Date: Wed, 15 Mar 2023 13:13:10 +0100
Message-Id: <20230315115743.053944198@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115738.951067403@linuxfoundation.org>
References: <20230315115738.951067403@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Qais Yousef <qyousef@layalina.io>

commit da07d2f9c153e457e845d4dcfdd13568d71d18a4 upstream.

Traversing the Perf Domains requires rcu_read_lock() to be held and is
conditional on sched_energy_enabled(). Ensure right protections applied.

Also skip capacity inversion detection for our own pd; which was an
error.

Fixes: 44c7b80bffc3 ("sched/fair: Detect capacity inversion")
Reported-by: Dietmar Eggemann <dietmar.eggemann@arm.com>
Signed-off-by: Qais Yousef (Google) <qyousef@layalina.io>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Vincent Guittot <vincent.guittot@linaro.org>
Link: https://lore.kernel.org/r/20230112122708.330667-3-qyousef@layalina.io
(cherry picked from commit da07d2f9c153e457e845d4dcfdd13568d71d18a4)
Signed-off-by: Qais Yousef (Google) <qyousef@layalina.io>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/fair.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -8605,16 +8605,23 @@ static void update_cpu_capacity(struct s
 	 *   * Thermal pressure will impact all cpus in this perf domain
 	 *     equally.
 	 */
-	if (static_branch_unlikely(&sched_asym_cpucapacity)) {
+	if (sched_energy_enabled()) {
 		unsigned long inv_cap = capacity_orig - thermal_load_avg(rq);
-		struct perf_domain *pd = rcu_dereference(rq->rd->pd);
+		struct perf_domain *pd;
 
+		rcu_read_lock();
+
+		pd = rcu_dereference(rq->rd->pd);
 		rq->cpu_capacity_inverted = 0;
 
 		for (; pd; pd = pd->next) {
 			struct cpumask *pd_span = perf_domain_span(pd);
 			unsigned long pd_cap_orig, pd_cap;
 
+			/* We can't be inverted against our own pd */
+			if (cpumask_test_cpu(cpu_of(rq), pd_span))
+				continue;
+
 			cpu = cpumask_any(pd_span);
 			pd_cap_orig = arch_scale_cpu_capacity(cpu);
 
@@ -8639,6 +8646,8 @@ static void update_cpu_capacity(struct s
 				break;
 			}
 		}
+
+		rcu_read_unlock();
 	}
 
 	trace_sched_cpu_capacity_tp(rq);


