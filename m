Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12634881F
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:44:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 689C3C4339E;
	Fri, 10 Mar 2023 14:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678459449;
	bh=51J+DjP2V28KQkpv+0RnHKAwsuKzvMf0gOMfTNDOJzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xlmot18N8czmUbsViD1jQPVxJAHRTQu5t2Ps7fYhAEUb+2WyzoMPpZE/vN4w9m+EX
	 SW39L79VmRGjGCmRswhgyUTNesrq5uOVjBtX/5YkAQAxcFgkF9+JUUNC++gnIUeB8o
	 Cp7NnQlOb+7TozC6sp/K1uyL2YQvX5ZyFOGcb15o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Valentin Schneider <valentin.schneider@arm.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Borislav Petkov <bp@suse.de>
Subject: [PATCH 5.4 350/357] x86/resctrl: Apply READ_ONCE/WRITE_ONCE to task_struct.{rmid,closid}
Date: Fri, 10 Mar 2023 14:40:39 +0100
Message-Id: <20230310133750.112162762@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Valentin Schneider <valentin.schneider@arm.com>

commit 6d3b47ddffed70006cf4ba360eef61e9ce097d8f upstream.

A CPU's current task can have its {closid, rmid} fields read locally
while they are being concurrently written to from another CPU.
This can happen anytime __resctrl_sched_in() races with either
__rdtgroup_move_task() or rdt_move_group_tasks().

Prevent load / store tearing for those accesses by giving them the
READ_ONCE() / WRITE_ONCE() treatment.

Signed-off-by: Valentin Schneider <valentin.schneider@arm.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lkml.kernel.org/r/9921fda88ad81afb9885b517fbe864a2bc7c35a9.1608243147.git.reinette.chatre@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/resctrl_sched.h   |   11 +++++++----
 arch/x86/kernel/cpu/resctrl/rdtgroup.c |   10 +++++-----
 2 files changed, 12 insertions(+), 9 deletions(-)

--- a/arch/x86/include/asm/resctrl_sched.h
+++ b/arch/x86/include/asm/resctrl_sched.h
@@ -56,19 +56,22 @@ static void __resctrl_sched_in(void)
 	struct resctrl_pqr_state *state = this_cpu_ptr(&pqr_state);
 	u32 closid = state->default_closid;
 	u32 rmid = state->default_rmid;
+	u32 tmp;
 
 	/*
 	 * If this task has a closid/rmid assigned, use it.
 	 * Else use the closid/rmid assigned to this cpu.
 	 */
 	if (static_branch_likely(&rdt_alloc_enable_key)) {
-		if (current->closid)
-			closid = current->closid;
+		tmp = READ_ONCE(current->closid);
+		if (tmp)
+			closid = tmp;
 	}
 
 	if (static_branch_likely(&rdt_mon_enable_key)) {
-		if (current->rmid)
-			rmid = current->rmid;
+		tmp = READ_ONCE(current->rmid);
+		if (tmp)
+			rmid = tmp;
 	}
 
 	if (closid != state->cur_closid || rmid != state->cur_rmid) {
--- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
+++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
@@ -563,11 +563,11 @@ static int __rdtgroup_move_task(struct t
 	 */
 
 	if (rdtgrp->type == RDTCTRL_GROUP) {
-		tsk->closid = rdtgrp->closid;
-		tsk->rmid = rdtgrp->mon.rmid;
+		WRITE_ONCE(tsk->closid, rdtgrp->closid);
+		WRITE_ONCE(tsk->rmid, rdtgrp->mon.rmid);
 	} else if (rdtgrp->type == RDTMON_GROUP) {
 		if (rdtgrp->mon.parent->closid == tsk->closid) {
-			tsk->rmid = rdtgrp->mon.rmid;
+			WRITE_ONCE(tsk->rmid, rdtgrp->mon.rmid);
 		} else {
 			rdt_last_cmd_puts("Can't move task to different control group\n");
 			return -EINVAL;
@@ -2177,8 +2177,8 @@ static void rdt_move_group_tasks(struct
 	for_each_process_thread(p, t) {
 		if (!from || is_closid_match(t, from) ||
 		    is_rmid_match(t, from)) {
-			t->closid = to->closid;
-			t->rmid = to->mon.rmid;
+			WRITE_ONCE(t->closid, to->closid);
+			WRITE_ONCE(t->rmid, to->mon.rmid);
 
 			/*
 			 * Order the closid/rmid stores above before the loads


