Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1802B43E06E;
	Thu, 30 Jul 2026 14:18:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421086; cv=none; b=pprTTYpAFlYzppgFfHLKTzJ5x0Vb5+U7uJn35v543TTjQENxC0JeIcl4aZ+PuiDmmIgDu/NUeZW4Sy8MfhIDGArtlfHNuTxQT3RgSalVaI+UJuzGsPlNKxQc3QrXFCLl1fOAdVvd7tgRHpDhdsgzuMjx+2kqxFPN9tQl90QUgRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421086; c=relaxed/simple;
	bh=IaudZWshIXfyvvqvfzWv3cPI3L+THDEEVarYYNMlvjo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hL7WamucIrpyK+GQjEH7GmM/VejSurGGGuAswPTDoT5AKEun9XQ1w5w8+cggQpU0dIMu2w1QA6DQY5I80eIuclLhRGBQp71UkZBGBv5AnXN+/b0LL/ZmS+fZgiecj8B/needqocSeZ0r2dWmt8IBhhZ6i5iS23hoM7ViV3+alLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M1Achc4A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M1Achc4A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3BFD1F000E9;
	Thu, 30 Jul 2026 14:18:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421084;
	bh=vEYQG4p3MfS4iSNHjuidqBwVlRRLxIBJikXmXsxMbV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M1Achc4AiC55JyxxpJfUt+RX/zzHBTBuOUpLBNTSHk4sPzPDqplb3AmclbkoV0MZE
	 7FteeGSnvvGLX2LPSBkweu4/rkVBgxGKwnTG5kf50UklfKhyLzUJqgp2w1R+0yKfWA
	 w13MmXJtoR2mhgRnGyR8YP7mgYIr6gG8sJIBo/H4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuba Piecuch <jpiecuch@google.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 002/744] sched_ext: Skip ops.set_weight() for disabled tasks
Date: Thu, 30 Jul 2026 16:04:35 +0200
Message-ID: <20260730141444.327067208@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuba Piecuch <jpiecuch@google.com>

commit 0e2f4ab68a89fad42e0f5a9ff4b740738e7aa1d6 upstream.

When switching a task's sched_class away from sched_ext, we get the
following sequence of events in __sched_setscheduler():

sched_change_begin()
  switched_from_scx()
    scx_disable_task(p)
      ops.disable(p)
__setscheduler_params()
  set_load_weight()
    reweight_task_scx(p)
      ops.set_weight(p)
p->sched_class = next_class;
sched_change_end()
  ...

Notably, ops.set_weight() is called _after_ ops.disable().
This violates the expected semantics of the callbacks, the expectation
being that ops.disable() can only be followed by ops.exit_task() or
ops.enable().

Skipping the weight adjustment for disabled tasks should be harmless
since the weight will be recalculated in scx_enable_task() if the task
ever rejoins SCX.

Fixes: 637b0682821b ("sched: Fold sched_class::switch{ing,ed}_{to,from}() into the change pattern")
Cc: stable@vger.kernel.org # v6.19+
Signed-off-by: Kuba Piecuch <jpiecuch@google.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/ext.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/kernel/sched/ext.c b/kernel/sched/ext.c
index 5d2d19473a82e8..8429bebc21a19a 100644
--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -3904,6 +3904,17 @@ static void reweight_task_scx(struct rq *rq, struct task_struct *p,
 	if (task_dead_and_done(p))
 		return;
 
+	/*
+	 * When switching sched_class away from SCX, reweight_task_scx()
+	 * is called _after_ scx_disable_task(). Skip calling ops.set_weight()
+	 * since the BPF scheduler may have already forgotten the task in
+	 * ops.disable().
+	 * p->scx.weight will be recalculated in scx_enable_task() if the task
+	 * ever returns to SCX class.
+	 */
+	if (scx_get_task_state(p) != SCX_TASK_ENABLED)
+		return;
+
 	p->scx.weight = sched_weight_to_cgroup(scale_load_down(lw->weight));
 	if (SCX_HAS_OP(sch, set_weight))
 		SCX_CALL_OP_TASK(sch, set_weight, rq, p, p->scx.weight);
-- 
2.53.0



