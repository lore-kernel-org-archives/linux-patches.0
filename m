Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E25A2C8C8;
	Mon, 11 Dec 2023 18:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HoSXGYc8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A0A3C433C8;
	Mon, 11 Dec 2023 18:33:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319597;
	bh=Eqfgi9WX1khHc5MGFTMkuXlInAgIdO3YKx17aNnfsdI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HoSXGYc8Xnu82+2nkOWfp0Vbd39Gw8CWTSw8Q3CofeiScOuF9Wl4CmWHOOUUgndGv
	 eoIyLOBPf/22x5KOUUYmQaHHyXw2s5q8OktD80/iUFvDfUqgCOWx72HYTPFZ964/+x
	 cHoNIcL7isBqR+xHE15tIuGgNiRgF/rcEzpuoh88=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Waiman Long <longman@redhat.com>,
	Yong He <alexyonghe@tencent.com>
Subject: [PATCH 6.6 164/244] workqueue: Make sure that wq_unbound_cpumask is never empty
Date: Mon, 11 Dec 2023 19:20:57 +0100
Message-ID: <20231211182053.226058711@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182045.784881756@linuxfoundation.org>
References: <20231211182045.784881756@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

commit 4a6c5607d4502ccd1b15b57d57f17d12b6f257a7 upstream.

During boot, depending on how the housekeeping and workqueue.unbound_cpus
masks are set, wq_unbound_cpumask can end up empty. Since 8639ecebc9b1
("workqueue: Implement non-strict affinity scope for unbound workqueues"),
this may end up feeding -1 as a CPU number into scheduler leading to oopses.

  BUG: unable to handle page fault for address: ffffffff8305e9c0
  #PF: supervisor read access in kernel mode
  #PF: error_code(0x0000) - not-present page
  ...
  Call Trace:
   <TASK>
   select_idle_sibling+0x79/0xaf0
   select_task_rq_fair+0x1cb/0x7b0
   try_to_wake_up+0x29c/0x5c0
   wake_up_process+0x19/0x20
   kick_pool+0x5e/0xb0
   __queue_work+0x119/0x430
   queue_work_on+0x29/0x30
  ...

An empty wq_unbound_cpumask is a clear misconfiguration and already
disallowed once system is booted up. Let's warn on and ignore
unbound_cpumask restrictions which lead to no unbound cpus. While at it,
also remove now unncessary empty check on wq_unbound_cpumask in
wq_select_unbound_cpu().

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-and-Tested-by: Yong He <alexyonghe@tencent.com>
Link: http://lkml.kernel.org/r/20231120121623.119780-1-alexyonghe@tencent.com
Fixes: 8639ecebc9b1 ("workqueue: Implement non-strict affinity scope for unbound workqueues")
Cc: stable@vger.kernel.org # v6.6+
Reviewed-by: Waiman Long <longman@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/workqueue.c | 22 +++++++++++++++-------
 1 file changed, 15 insertions(+), 7 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 6e578f576a6f..2989b57e154a 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1684,9 +1684,6 @@ static int wq_select_unbound_cpu(int cpu)
 		pr_warn_once("workqueue: round-robin CPU selection forced, expect performance impact\n");
 	}
 
-	if (cpumask_empty(wq_unbound_cpumask))
-		return cpu;
-
 	new_cpu = __this_cpu_read(wq_rr_cpu_last);
 	new_cpu = cpumask_next_and(new_cpu, wq_unbound_cpumask, cpu_online_mask);
 	if (unlikely(new_cpu >= nr_cpu_ids)) {
@@ -6515,6 +6512,17 @@ static inline void wq_watchdog_init(void) { }
 
 #endif	/* CONFIG_WQ_WATCHDOG */
 
+static void __init restrict_unbound_cpumask(const char *name, const struct cpumask *mask)
+{
+	if (!cpumask_intersects(wq_unbound_cpumask, mask)) {
+		pr_warn("workqueue: Restricting unbound_cpumask (%*pb) with %s (%*pb) leaves no CPU, ignoring\n",
+			cpumask_pr_args(wq_unbound_cpumask), name, cpumask_pr_args(mask));
+		return;
+	}
+
+	cpumask_and(wq_unbound_cpumask, wq_unbound_cpumask, mask);
+}
+
 /**
  * workqueue_init_early - early init for workqueue subsystem
  *
@@ -6534,11 +6542,11 @@ void __init workqueue_init_early(void)
 	BUILD_BUG_ON(__alignof__(struct pool_workqueue) < __alignof__(long long));
 
 	BUG_ON(!alloc_cpumask_var(&wq_unbound_cpumask, GFP_KERNEL));
-	cpumask_copy(wq_unbound_cpumask, housekeeping_cpumask(HK_TYPE_WQ));
-	cpumask_and(wq_unbound_cpumask, wq_unbound_cpumask, housekeeping_cpumask(HK_TYPE_DOMAIN));
-
+	cpumask_copy(wq_unbound_cpumask, cpu_possible_mask);
+	restrict_unbound_cpumask("HK_TYPE_WQ", housekeeping_cpumask(HK_TYPE_WQ));
+	restrict_unbound_cpumask("HK_TYPE_DOMAIN", housekeeping_cpumask(HK_TYPE_DOMAIN));
 	if (!cpumask_empty(&wq_cmdline_cpumask))
-		cpumask_and(wq_unbound_cpumask, wq_unbound_cpumask, &wq_cmdline_cpumask);
+		restrict_unbound_cpumask("workqueue.unbound_cpus", &wq_cmdline_cpumask);
 
 	pwq_cache = KMEM_CACHE(pool_workqueue, SLAB_PANIC);
 
-- 
2.43.0



