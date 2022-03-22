Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 301B16453
	for <patches@lists.linux.dev>; Tue, 22 Mar 2022 21:40:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E99DFC340F2;
	Tue, 22 Mar 2022 21:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1647985251;
	bh=NU1VSnI1iWmG1jYFEAa+FvjnPN15ib16sIz1RW1jo5M=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=dDSntCKGoEcn46fN1WVD19tij1XD8O0XMxW9ZIXgiwt8wdmfNBB7hafBKf/WrCzAp
	 0vouDlpAHLvTEk3bdlSbaITcyH5WY6BkvUrX8h7z08pX/IwfjCTPP9A5DDMabCkLvy
	 6Q9RZxHeVyvi43r7fGc4/QXwt6yBoCurfjQ/PE3s=
Date: Tue, 22 Mar 2022 14:40:50 -0700
To: vdavydov.dev@gmail.com,tglx@linutronix.de,shakeelb@google.com,roman.gushchin@linux.dev,peterz@infradead.org,oliver.sang@intel.com,mkoutny@suse.com,mhocko@suse.com,mhocko@kernel.org,longman@redhat.com,hannes@cmpxchg.org,bigeasy@linutronix.de,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 046/227] mm/memcg: disable migration instead of preemption in drain_all_stock().
Message-Id: <20220322214050.E99DFC340F2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: mm/memcg: disable migration instead of preemption in drain_all_stock().

Before the for-each-CPU loop, preemption is disabled so that so that
drain_local_stock() can be invoked directly instead of scheduling a
worker.  Ensuring that drain_local_stock() completed on the local CPU is
not correctness problem.  It _could_ be that the charging path will be
forced to reclaim memory because cached charges are still waiting for
their draining.

Disabling preemption before invoking drain_local_stock() is problematic on
PREEMPT_RT due to the sleeping locks involved.  To ensure that no CPU
migrations happens across for_each_online_cpu() it is enouhg to use
migrate_disable() which disables migration and keeps context preemptible
to a sleeping lock can be acquired.  A race with CPU hotplug is not a
problem because pcp data is not going away.  In the worst case we just
schedule draining of an empty stock.

Use migrate_disable() instead of get_cpu() around the
for_each_online_cpu() loop.

Link: https://lkml.kernel.org/r/20220226204144.1008339-7-bigeasy@linutronix.de
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: kernel test robot <oliver.sang@intel.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Cc: Waiman Long <longman@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/mm/memcontrol.c~mm-memcg-disable-migration-instead-of-preemption-in-drain_all_stock
+++ a/mm/memcontrol.c
@@ -2300,7 +2300,8 @@ static void drain_all_stock(struct mem_c
 	 * as well as workers from this path always operate on the local
 	 * per-cpu data. CPU up doesn't touch memcg_stock at all.
 	 */
-	curcpu = get_cpu();
+	migrate_disable();
+	curcpu = smp_processor_id();
 	for_each_online_cpu(cpu) {
 		struct memcg_stock_pcp *stock = &per_cpu(memcg_stock, cpu);
 		struct mem_cgroup *memcg;
@@ -2323,7 +2324,7 @@ static void drain_all_stock(struct mem_c
 				schedule_work_on(cpu, &stock->work);
 		}
 	}
-	put_cpu();
+	migrate_enable();
 	mutex_unlock(&percpu_charge_mutex);
 }
 
_
