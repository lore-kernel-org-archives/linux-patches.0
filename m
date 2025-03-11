Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CECA1CAA8F;
	Tue, 11 Mar 2025 15:35:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707325; cv=none; b=CxH+Qwi42DQgFeIdi2fmNk4XJwW+MQ+ZiSb6VugjODRMUm936t6l/NjQ7PmXqY4TZS4N66URdfSBSYJ8ig5il5DFZNlZdLahU/dqiz6ymFNwASELPlEuoeSH68sFoT7WGhcu0IsCTcInHTt1GxebxIl0yHP6W2WNdAI2mJLtsZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707325; c=relaxed/simple;
	bh=V8s2na2Jl31YlqASciN2d1Tj1RHmxon8+cHN6alBe4s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ug14yroapIUp8UbcZbtnaiKBkgBNIfVOf6GnYRTfKM12h9EstBGjqgmBHZCvlifYexGnldxklR9kYQCFMXLywDiIRZ65hEte6/hkEolfJYFupJbGctlgZhdN9psq1z1CVPSBC+UDar1/unaHYv0dbrveDZp8oCFb2Lb70z5HRy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xPbomeCJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xPbomeCJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E291C4CEE9;
	Tue, 11 Mar 2025 15:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707325;
	bh=V8s2na2Jl31YlqASciN2d1Tj1RHmxon8+cHN6alBe4s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xPbomeCJ0LUhhmAaH312SHM1qBngzzDGfqgWpzD/ep0Ky1E0lGbndLKjcgwbSijGb
	 SnHF6neX4QUjHH/62nertkeYjtjX3GDPy637MiJ483oe0eVCU9+a1iQ/jGkwpYZoRj
	 6Ei1o75T79Dz1z3OMQhjAJwCyinDMDeU1+j+d+ms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ridong <chenridong@huawei.com>,
	Michal Hocko <mhocko@suse.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Shakeel Butt <shakeelb@google.com>,
	Muchun Song <songmuchun@bytedance.com>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 319/462] memcg: fix soft lockup in the OOM process
Date: Tue, 11 Mar 2025 15:59:45 +0100
Message-ID: <20250311145810.960955108@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Ridong <chenridong@huawei.com>

[ Upstream commit ade81479c7dda1ce3eedb215c78bc615bbd04f06 ]

A soft lockup issue was found in the product with about 56,000 tasks were
in the OOM cgroup, it was traversing them when the soft lockup was
triggered.

watchdog: BUG: soft lockup - CPU#2 stuck for 23s! [VM Thread:1503066]
CPU: 2 PID: 1503066 Comm: VM Thread Kdump: loaded Tainted: G
Hardware name: Huawei Cloud OpenStack Nova, BIOS
RIP: 0010:console_unlock+0x343/0x540
RSP: 0000:ffffb751447db9a0 EFLAGS: 00000247 ORIG_RAX: ffffffffffffff13
RAX: 0000000000000001 RBX: 0000000000000000 RCX: 00000000ffffffff
RDX: 0000000000000000 RSI: 0000000000000004 RDI: 0000000000000247
RBP: ffffffffafc71f90 R08: 0000000000000000 R09: 0000000000000040
R10: 0000000000000080 R11: 0000000000000000 R12: ffffffffafc74bd0
R13: ffffffffaf60a220 R14: 0000000000000247 R15: 0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f2fe6ad91f0 CR3: 00000004b2076003 CR4: 0000000000360ee0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 vprintk_emit+0x193/0x280
 printk+0x52/0x6e
 dump_task+0x114/0x130
 mem_cgroup_scan_tasks+0x76/0x100
 dump_header+0x1fe/0x210
 oom_kill_process+0xd1/0x100
 out_of_memory+0x125/0x570
 mem_cgroup_out_of_memory+0xb5/0xd0
 try_charge+0x720/0x770
 mem_cgroup_try_charge+0x86/0x180
 mem_cgroup_try_charge_delay+0x1c/0x40
 do_anonymous_page+0xb5/0x390
 handle_mm_fault+0xc4/0x1f0

This is because thousands of processes are in the OOM cgroup, it takes a
long time to traverse all of them.  As a result, this lead to soft lockup
in the OOM process.

To fix this issue, call 'cond_resched' in the 'mem_cgroup_scan_tasks'
function per 1000 iterations.  For global OOM, call
'touch_softlockup_watchdog' per 1000 iterations to avoid this issue.

Link: https://lkml.kernel.org/r/20241224025238.3768787-1-chenridong@huaweicloud.com
Fixes: 9cbb78bb3143 ("mm, memcg: introduce own oom handler to iterate only over its own threads")
Signed-off-by: Chen Ridong <chenridong@huawei.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Muchun Song <songmuchun@bytedance.com>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/memcontrol.c | 7 ++++++-
 mm/oom_kill.c   | 8 +++++++-
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 8de7c72ae0258..14f26b3b0204c 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1312,6 +1312,7 @@ int mem_cgroup_scan_tasks(struct mem_cgroup *memcg,
 {
 	struct mem_cgroup *iter;
 	int ret = 0;
+	int i = 0;
 
 	BUG_ON(memcg == root_mem_cgroup);
 
@@ -1320,8 +1321,12 @@ int mem_cgroup_scan_tasks(struct mem_cgroup *memcg,
 		struct task_struct *task;
 
 		css_task_iter_start(&iter->css, CSS_TASK_ITER_PROCS, &it);
-		while (!ret && (task = css_task_iter_next(&it)))
+		while (!ret && (task = css_task_iter_next(&it))) {
+			/* Avoid potential softlockup warning */
+			if ((++i & 1023) == 0)
+				cond_resched();
 			ret = fn(task, arg);
+		}
 		css_task_iter_end(&it);
 		if (ret) {
 			mem_cgroup_iter_break(memcg, iter);
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 32ed968e5c2d4..94ad257eb2067 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -44,6 +44,7 @@
 #include <linux/init.h>
 #include <linux/mmu_notifier.h>
 #include <linux/cred.h>
+#include <linux/nmi.h>
 
 #include <asm/tlb.h>
 #include "internal.h"
@@ -431,10 +432,15 @@ static void dump_tasks(struct oom_control *oc)
 		mem_cgroup_scan_tasks(oc->memcg, dump_task, oc);
 	else {
 		struct task_struct *p;
+		int i = 0;
 
 		rcu_read_lock();
-		for_each_process(p)
+		for_each_process(p) {
+			/* Avoid potential softlockup warning */
+			if ((++i & 1023) == 0)
+				touch_softlockup_watchdog();
 			dump_task(p, oc);
+		}
 		rcu_read_unlock();
 	}
 }
-- 
2.39.5



