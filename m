Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 899A8357D11;
	Wed, 30 Sep 2026 16:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786085; cv=none; b=DNvvK93aWAoFaLrwkZ6tXRK3Bgm2wi2r1caGZ+57tOuOoexdQuvBf5qopiksn9+ujc2kDuvcwSYprNf8ovIApql6fAPNd3XTSXNAGaGe5hdWc46nW6lUBt7jTPyC27UeWQn59dc1E5paEJSS4/758TjdE1mcjraxJyQ+VTp7kDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786085; c=relaxed/simple;
	bh=Mk1iI6z5lTxZvfrSO6ItKNsCMwOZSFBz4X1qiZmY86w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xmou2B5llclCdvQQQvi3+vdsGPs2YDzL/hot69xxKuIlvAPcK/mEJBeE4MUWA09P+0dN8hlczwpnbGwEH8IRqTTpvkyAsWQFI55dP+1capmyurJ+ifopUzi3MBdPvn8gp6pj3gmRk2pRuqJfCmYQ37H7Uwfv5Nv0YrgVF1BdLxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f92JAn9y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f92JAn9y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E564E1F00893;
	Wed, 30 Sep 2026 16:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786084;
	bh=RKIjmOl/rgH01CNfbziwYuJkrnhP/+WI9YrvWu9uv6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f92JAn9yA1ThpPVoJYILkBhdycMMK3gDWeBsMID3WQVEQ/5zt1qJusx9byl6sFLuc
	 du7LqbkwFfhFER7WUU72kXIjisNm/flWNhujhRDoji3aylm4guSnywl5sjpHgbKyz+
	 hy2UDMdR+KlkTKuQM7uCN0xMWf9YtLQLN/cScDtA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Abecassis <fabecassis@nvidia.com>,
	Andrea Righi <arighi@nvidia.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 692/982] sched/fair: Reject misfit pulls onto busy SMT siblings on asym-capacity
Date: Wed, 30 Sep 2026 17:23:48 +0200
Message-ID: <20260930152431.624626073@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

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
 kernel/sched/fair.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 879843e807fc6..325e7542fbb4b 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -8181,6 +8181,7 @@ struct lb_env {
 
 	int			dst_cpu;
 	struct rq		*dst_rq;
+	bool			dst_core_idle;
 
 	struct cpumask		*dst_grpmask;
 	int			new_dst_cpu;
@@ -9361,10 +9362,16 @@ static bool update_sd_pick_busiest(struct lb_env *env,
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
 
@@ -9902,6 +9909,8 @@ static inline void update_sd_lb_stats(struct lb_env *env, struct sd_lb_stats *sd
 	unsigned long sum_util = 0;
 	int sg_status = 0;
 
+	env->dst_core_idle = !sched_smt_active() || is_core_idle(env->dst_cpu);
+
 	do {
 		struct sg_lb_stats *sgs = &tmp_sgs;
 		int local_group;
-- 
2.53.0



