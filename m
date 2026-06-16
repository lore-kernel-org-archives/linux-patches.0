Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34A5F44BCB8;
	Tue, 16 Jun 2026 16:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781626372; cv=none; b=TW4ACjdx/QuKJQYdKNLWUqWhLUaSzs4XV5pQpg7cfB2qsSR7pft8QxflTyk+OhISxqeMD4LXRPxLLMp3VkV7Zwq6Oi94UxMqBC+VSSQYNEuj0d6lbMLhHrQ6NsotgQrWuU/RyrhoeUc2Yr30nJSl6DtMuel5S2gmRgUYYHUyEek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781626372; c=relaxed/simple;
	bh=334CMkdeOz5Wv6CngRxIOn5va7hFczmOJEa9RMvCh/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jVawS0sF9JgZEuZJr2S/jd2jW6KuFjd0uoaBNakRRb4E9tbauxGo7UxlXtNudF2Pb9eWO6qpqfoceedj0ZMaTf5CNBab6PvcTwItaJvPUrVAo0tW8dzZFtgvB15WHDPGmm+RKsgu1MhPODqpO73epLddIbN0ffy2Zxo3QdWjSBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OuXaGOKl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OuXaGOKl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3758D1F000E9;
	Tue, 16 Jun 2026 16:12:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781626371;
	bh=ybCEnGGIfpG5BApttri1QzaHY3Ypl1NbAoVX4H8HFnc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OuXaGOKlBlxIC5WolSfw6HBuX5P6xYWDGTHGpKA/Cdj2Tdsfg67+qOIFDUEgZWbFv
	 /xX1kb8fxwB16jWHUmXvjhyo2tDmWFf9UNcMWB6he1tDs3OkBuMcCAU2xNvDH0j68Y
	 z2zU+q473i12mlDannVV3vJIxhEDmBuF9p0XmcfI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Fleming <mfleming@cloudflare.com>,
	Tejun Heo <tj@kernel.org>,
	Andrea Righi <arighi@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 308/325] sched_ext: Dont warn on NULL cgrp_moving_from in scx_cgroup_move_task()
Date: Tue, 16 Jun 2026 20:31:44 +0530
Message-ID: <20260616145114.353125941@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

commit 02e545c4297a26dbbc41df81b831e7f605bcd306 upstream.

A WARN fires when systemd's user manager writes "+cpu +memory +pids" to
its own subtree_control while a sched_ext scheduler is loaded:

  WARNING: at kernel/sched/ext.c:3227 scx_cgroup_move_task+0xa8/0xb0
   scx_cgroup_move_task+0xa8/0xb0
   sched_move_task+0x134/0x290
   cpu_cgroup_attach+0x39/0x70
   cgroup_migrate_execute+0x37d/0x450
   cgroup_update_dfl_csses+0x1e3/0x270
   cgroup_subtree_control_write+0x3e7/0x440

scx_cgroup_can_attach() arms cgrp_moving_from only when a task's cpu
cgroup changes. It can still be NULL when scx_cgroup_move_task() runs,
through this sequence:

  Step                               Result
  ---------------------------------  ----------------------------------
  1. cpu enabled on cgroup G         cpu css = A
  2. cpu toggled off then on for G   A killed, B created (same cgroup)
  3. an exiting task keeps A alive   migration skips it, A now stale
  4. +memory migrates G              stale A vs current B pulls cpu in
  5. cpu attach runs for all tasks   hits a live, cpu-unchanged task
  6. scx_cgroup_move_task() on it    cgrp_moving_from NULL -> WARN

The mismatch is that scx_cgroup_can_attach() keys on cgroup identity
while migration drives the move on css identity, so a NULL cgrp_moving_from
here is a legitimate css-only migration, not a missing prep.

The call is already gated on cgrp_moving_from, so just drop the warning.
ops.cgroup_prep_move() and ops.cgroup_move() stay paired.

Fixes: 819513666966 ("sched_ext: Add cgroup support")
Cc: stable@vger.kernel.org # v6.12+
Reported-by: Matt Fleming <mfleming@cloudflare.com>
Closes: https://lore.kernel.org/all/20260601124156.2205704-1-mfleming@cloudflare.com/
Signed-off-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Andrea Righi <arighi@nvidia.com>
[ mfleming: keep the 6.18.y SCX_KF_REST argument in the
  SCX_CALL_OP_TASK() call. ]
Signed-off-by: Matt Fleming <mfleming@cloudflare.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/ext.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/ext.c b/kernel/sched/ext.c
index 7b750bf42698cc..d8280f87443310 100644
--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -3221,11 +3221,13 @@ void scx_cgroup_move_task(struct task_struct *p)
 		return;
 
 	/*
-	 * @p must have ops.cgroup_prep_move() called on it and thus
-	 * cgrp_moving_from set.
+	 * scx_cgroup_can_attach() sets cgrp_moving_from only when the task's
+	 * cgroup changes. Migration keys off css rather than cgroup identity,
+	 * so it can hand an unchanged-cgroup task here with cgrp_moving_from
+	 * NULL. Nothing to report to the BPF scheduler then, so skip it and
+	 * keep prep_move and move paired.
 	 */
-	if (SCX_HAS_OP(sch, cgroup_move) &&
-	    !WARN_ON_ONCE(!p->scx.cgrp_moving_from))
+	if (SCX_HAS_OP(sch, cgroup_move) && p->scx.cgrp_moving_from)
 		SCX_CALL_OP_TASK(sch, SCX_KF_REST, cgroup_move, task_rq(p),
 				 p, p->scx.cgrp_moving_from,
 				 tg_cgrp(task_group(p)));
-- 
2.53.0



