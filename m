Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DB0C45BD6F;
	Tue, 16 Jun 2026 16:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781627819; cv=none; b=aRP2rNKEkvT2VC1V1IqeTN6eVJKfbnj91cwoMf/EcIP7mCU0m4c9qE1W2xBy7y1DAa2nB3tUKfYlewk3gAXM24t2xRVOHbxxfUWjMxuclcd6wUittZvcJxqJ0F61BnbULgucHqTXcu/NPy0nBoMSOVQHQuhoGP2ernWnK4Izs8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781627819; c=relaxed/simple;
	bh=zsMPzBeimjk0LRBxZcdKTuyFy1Z2KCrVNmjDHUag5/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fNTpBxV/MEfDv+cgjdp53QkvcpOAK7AbXQg3+TsKbXwhuQ5esMZiVsHIrdyljnOb2LR897/1GFT3vE8v4QaK6rZhdtG+3uGDXwdo1QLGrf+AUu5RhHJ4zVLGjpe85g1D55W+lxfD//GBZJmO+QNf+01m66Q6nEZv357pEmo56EU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ecH+hYPA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ecH+hYPA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E0B61F000E9;
	Tue, 16 Jun 2026 16:36:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781627818;
	bh=0IwPab4tN4Z/R7Qsehp6lLoJfbjFyLy77z0olP+aJ9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ecH+hYPAW7gWaHHBzLtvbercwg68VPyiGZ0IgAXvQpp7z+TP3zVP3PGRnju5EJru3
	 VtuAU3j3Qs3hkCplkA7y/s6E9Z91RDdcdNurUtmWrEpECSxsXxvjCmvPC5lkJPBykh
	 H/GwHd0aBHESx5Kw03j7B82LoKzTeAdSL/FmykoI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Fleming <mfleming@cloudflare.com>,
	Tejun Heo <tj@kernel.org>,
	Andrea Righi <arighi@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 233/261] sched_ext: Dont warn on NULL cgrp_moving_from in scx_cgroup_move_task()
Date: Tue, 16 Jun 2026 20:31:11 +0530
Message-ID: <20260616145055.846440038@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

[ Upstream commit 02e545c4297a26dbbc41df81b831e7f605bcd306 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/ext.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/kernel/sched/ext.c
+++ b/kernel/sched/ext.c
@@ -4069,10 +4069,13 @@ void scx_cgroup_move_task(struct task_st
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
-	if (SCX_HAS_OP(cgroup_move) && !WARN_ON_ONCE(!p->scx.cgrp_moving_from))
+	if (SCX_HAS_OP(cgroup_move) && p->scx.cgrp_moving_from)
 		SCX_CALL_OP_TASK(SCX_KF_UNLOCKED, cgroup_move, p,
 			p->scx.cgrp_moving_from, tg_cgrp(task_group(p)));
 	p->scx.cgrp_moving_from = NULL;


