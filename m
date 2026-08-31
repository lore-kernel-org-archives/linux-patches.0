Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 147C94DA55D;
	Mon, 31 Aug 2026 13:39:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183564; cv=none; b=p1fAey1hNctsW6PSjMZzr2egauNEmiLTf98J47vdZcBCbo27XSsYGcAo5qX3nJVQ8flxqndX3JtxffXf9Y2JV7yGdnddbL69T+aixMuazrBH0cg/NucIOFnW+3gQnIz3s0Aj7ZgZlSYPjBwJD2/TsO1FsrTmWmYlf8+Q69/73oQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183564; c=relaxed/simple;
	bh=FSnRMFDuOduDoUX+A+1CFWwU8H+3h4vesh3ZjzxSr7U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=g5aVH5JXwctqSyHsYIlQONM4RgTB291QbCqR7gS70oYdUCm38HBiWD/yUOzdI4IizSbQUAH5F6tZDPwaiSRL2vjkpVm2Ga0DNGkGqMQwkWdIqXiRpEuUpE93bfPqkEySQ+cTq6KdbDQEF9rYk6R3CAGpnqC/ChWdoMuR4JBUtQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=btb/7jE7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="btb/7jE7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC88F1F000E9;
	Mon, 31 Aug 2026 13:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183563;
	bh=gSEL1yWGTqhfQjP2tZMPkuQEQVJ76cy62l71kafhDjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=btb/7jE7vgW236XRwdG/OGui5uOQ5E3m6awqcvDmYykPTVcEXJSShuHBVGIRzPpG9
	 JXb/xUQREW98NoZ4nbOZ8cGDGuDYGmrwtDlgswhjVIrkNu/WqEopjFGLQD9FHgCN/6
	 qNZkgGHhJvb6kooJOj/JBYmYbMSSYkWtDXQ4+8joUfZLXdypLABsgAKUfRtujhAw5r
	 RJwJaGmbxjZGIQsnaiVjMrrZlVUadYUv6UU+Wqms3sXar1e62QhIYhkCExozywHUt3
	 9fqj1IaXEimVUdTL13O0YE1IkjDPCzGGBKnycdJmmHXqdw3tixAX3HsyDYAYWMB2KP
	 zDw/CGZs2c95Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Andrea Righi <arighi@nvidia.com>,
	Felix Abecassis <fabecassis@nvidia.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Sasha Levin <sashal@kernel.org>,
	mingo@redhat.com,
	juri.lelli@redhat.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] sched/fair: Reject misfit pulls onto busy SMT siblings on asym-capacity
Date: Mon, 31 Aug 2026 09:23:19 -0400
Message-ID: <20260831133314.4125787-171-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Andrea Righi <arighi@nvidia.com>

[ Upstream commit bf6aa722198d3c06e4236e8c5a480f30a64e1513 ]

When SD_ASYM_CPUCAPACITY load balancing considers pulling a misfit task,
capacity_of(dst_cpu) can overstate available compute if the SMT sibling is
busy: the core does not deliver its full nominal capacity.

If SMT is active and dst_cpu is not on a fully idle core, skip this
destination so we do not migrate a misfit expecting a capacity upgrade we
cannot actually provide.

Reported-by: Felix Abecassis <fabecassis@nvidia.com>
Signed-off-by: Andrea Righi <arighi@nvidia.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Vincent Guittot <vincent.guittot@linaro.org>
Link: https://patch.msgid.link/20260509180955.1840064-5-arighi@nvidia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Connection lost, reconnecting to https://agentn.us.api5.cursor.sh
(attempt 1)...
Retry attempt 1...
The background `git log --grep` search finished without finding this
commit in the 6.18.43 tree — which matches what we saw in code
(`dst_core_idle` is absent from `kernel/sched/fair.c`).

**Verdict for 6.18.y: YES.** It's a small, maintainer-reviewed
scheduling correctness fix for misfit task migration on asymmetric-
capacity + SMT systems. The buggy logic is present in this tree and the
patch should apply cleanly.

 kernel/sched/fair.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index ac5f08cd01a83..fee58d01ae0f9 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -9395,6 +9395,7 @@ struct lb_env {
 
 	int			dst_cpu;
 	struct rq		*dst_rq;
+	bool			dst_core_idle;
 
 	struct cpumask		*dst_grpmask;
 	int			new_dst_cpu;
@@ -10636,10 +10637,16 @@ static bool update_sd_pick_busiest(struct lb_env *env,
 	 * We can use max_capacity here as reduction in capacity on some
 	 * CPUs in the group should either be possible to resolve
 	 * internally or be covered by avg_load imbalance (eventually).
+	 *
+	 * When SMT is active, only pull a misfit to dst_cpu if it is on a
+	 * fully idle core; otherwise the effective capacity of the core is
+	 * reduced and we may not actually provide more capacity than the
+	 * source.
 	 */
 	if ((env->sd->flags & SD_ASYM_CPUCAPACITY) &&
 	    (sgs->group_type == group_misfit_task) &&
-	    (!capacity_greater(capacity_of(env->dst_cpu), sg->sgc->max_capacity) ||
+	    (!env->dst_core_idle ||
+	     !capacity_greater(capacity_of(env->dst_cpu), sg->sgc->max_capacity) ||
 	     sds->local_stat.group_type != group_has_spare))
 		return false;
 
@@ -11206,6 +11213,8 @@ static inline void update_sd_lb_stats(struct lb_env *env, struct sd_lb_stats *sd
 	unsigned long sum_util = 0;
 	bool sg_overloaded = 0, sg_overutilized = 0;
 
+	env->dst_core_idle = !sched_smt_active() || is_core_idle(env->dst_cpu);
+
 	do {
 		struct sg_lb_stats *sgs = &tmp_sgs;
 		int local_group;
-- 
2.53.0

