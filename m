Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB9196FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:37:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50E73C433F2;
	Mon, 16 Jan 2023 16:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673887042;
	bh=PNyLoEtsp9Yk9Aokln5PUM6DjkVHmkJTr5YmwbEREzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CdOvOnhn3fWa6PaxdhofNauijkY8zL3/qSmpSlIqftf9zudFvrCnu+NIYU3nlPCCK
	 QEFaOoAvOLGrrefoJVlcOvObFBW8VH87jRc+5IWy0Uc/TK+ZWQzHTjxC6bGtEC7JCV
	 iel3mDqGPvq5aX4hgc/1UiEOjJockkdxq6L3n1HU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Morse <james.morse@arm.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	Borislav Petkov <bp@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 644/658] x86/resctrl: Use task_curr() instead of task_struct->on_cpu to prevent unnecessary IPI
Date: Mon, 16 Jan 2023 16:52:12 +0100
Message-Id: <20230116154938.954992749@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Reinette Chatre <reinette.chatre@intel.com>

[ Upstream commit e0ad6dc8969f790f14bddcfd7ea284b7e5f88a16 ]

James reported in [1] that there could be two tasks running on the same CPU
with task_struct->on_cpu set. Using task_struct->on_cpu as a test if a task
is running on a CPU may thus match the old task for a CPU while the
scheduler is running and IPI it unnecessarily.

task_curr() is the correct helper to use. While doing so move the #ifdef
check of the CONFIG_SMP symbol to be a C conditional used to determine
if this helper should be used to ensure the code is always checked for
correctness by the compiler.

[1] https://lore.kernel.org/lkml/a782d2f3-d2f6-795f-f4b1-9462205fd581@arm.com

Reported-by: James Morse <james.morse@arm.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lkml.kernel.org/r/e9e68ce1441a73401e08b641cc3b9a3cf13fe6d4.1608243147.git.reinette.chatre@intel.com
Stable-dep-of: fe1f0714385f ("x86/resctrl: Fix task CLOSID/RMID update race")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/resctrl/rdtgroup.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/cpu/resctrl/rdtgroup.c b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
index 28f786289fce..2c19f2ecfa03 100644
--- a/arch/x86/kernel/cpu/resctrl/rdtgroup.c
+++ b/arch/x86/kernel/cpu/resctrl/rdtgroup.c
@@ -2178,19 +2178,15 @@ static void rdt_move_group_tasks(struct rdtgroup *from, struct rdtgroup *to,
 			t->closid = to->closid;
 			t->rmid = to->mon.rmid;
 
-#ifdef CONFIG_SMP
 			/*
-			 * This is safe on x86 w/o barriers as the ordering
-			 * of writing to task_cpu() and t->on_cpu is
-			 * reverse to the reading here. The detection is
-			 * inaccurate as tasks might move or schedule
-			 * before the smp function call takes place. In
-			 * such a case the function call is pointless, but
+			 * If the task is on a CPU, set the CPU in the mask.
+			 * The detection is inaccurate as tasks might move or
+			 * schedule before the smp function call takes place.
+			 * In such a case the function call is pointless, but
 			 * there is no other side effect.
 			 */
-			if (mask && t->on_cpu)
+			if (IS_ENABLED(CONFIG_SMP) && mask && task_curr(t))
 				cpumask_set_cpu(task_cpu(t), mask);
-#endif
 		}
 	}
 	read_unlock(&tasklist_lock);
-- 
2.35.1



