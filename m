Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65B073451AF;
	Fri, 21 Nov 2025 14:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733636; cv=none; b=PKy4r+2lB0pk4SOg44C5yvc5sw/uo/qpMxn2yLdzXg49X1V7zvIUaNgUVjs0c5gnFpwnLRiUCOjP3cILVE1yHxONyY//4TTkcx9EdHLD2BgDAHA+BItjeL9A3luZf90oT+fWxe2qXMe16dJ0e//7Rsc2aaUGJYYJnupS3FNJMeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733636; c=relaxed/simple;
	bh=fG8ipLzV/JjHbr4jdO6x+c8TygufmZyCdn0zQkAOiiQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sKRi5OLOmMMBXz405bx+vcAEoyVnvc8LvyAQ13hNCt3JhRQTNjRBBXehtAlQmSDZokO/dyvIBlo1HWEnFnd2QjiFBsm9qKwyPaZWwoApQnmDzEoeWsi5kvNZckE1TGc1xne6DT4V5h5c65F7cX6DPqtjAHkuZU0gl4fPCzesDyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wz47j9Yo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wz47j9Yo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC78FC4CEF1;
	Fri, 21 Nov 2025 14:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733636;
	bh=fG8ipLzV/JjHbr4jdO6x+c8TygufmZyCdn0zQkAOiiQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wz47j9YocgHd8pnwQQaLw67uRui3YIem4QP97MY1rSLQS+rusrKb1MPoVA6pdwlCR
	 WunQw23b+xXtRgtKXqMl5Pl3elqdRaara+D11z/l+AJ2HQ6PPAu1p1xzwOaTSB3voa
	 oRsyswtA2M34T0EDLC43NArh9c4rkUUqW+iWtpF8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosryahmed@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <songmuchun@bytedance.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 529/529] memcg: fix data-race KCSAN bug in rstats
Date: Fri, 21 Nov 2025 14:13:48 +0100
Message-ID: <20251121130249.867274873@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

commit 78ec6f9df6642418411c534683da6133e0962ec7 upstream.

A data-race issue in memcg rstat occurs when two distinct code paths
access the same 4-byte region concurrently.  KCSAN detection triggers the
following BUG as a result.

	BUG: KCSAN: data-race in __count_memcg_events / mem_cgroup_css_rstat_flush

	write to 0xffffe8ffff98e300 of 4 bytes by task 5274 on cpu 17:
	mem_cgroup_css_rstat_flush (mm/memcontrol.c:5850)
	cgroup_rstat_flush_locked (kernel/cgroup/rstat.c:243 (discriminator 7))
	cgroup_rstat_flush (./include/linux/spinlock.h:401 kernel/cgroup/rstat.c:278)
	mem_cgroup_flush_stats.part.0 (mm/memcontrol.c:767)
	memory_numa_stat_show (mm/memcontrol.c:6911)
<snip>

	read to 0xffffe8ffff98e300 of 4 bytes by task 410848 on cpu 27:
	__count_memcg_events (mm/memcontrol.c:725 mm/memcontrol.c:962)
	count_memcg_event_mm.part.0 (./include/linux/memcontrol.h:1097 ./include/linux/memcontrol.h:1120)
	handle_mm_fault (mm/memory.c:5483 mm/memory.c:5622)
<snip>

	value changed: 0x00000029 -> 0x00000000

The race occurs because two code paths access the same "stats_updates"
location.  Although "stats_updates" is a per-CPU variable, it is remotely
accessed by another CPU at
cgroup_rstat_flush_locked()->mem_cgroup_css_rstat_flush(), leading to the
data race mentioned.

Considering that memcg_rstat_updated() is in the hot code path, adding a
lock to protect it may not be desirable, especially since this variable
pertains solely to statistics.

Therefore, annotating accesses to stats_updates with READ/WRITE_ONCE() can
prevent KCSAN splats and potential partial reads/writes.

Link: https://lkml.kernel.org/r/20240424125940.2410718-1-leitao@debian.org
Fixes: 9cee7e8ef3e3 ("mm: memcg: optimize parent iteration in memcg_rstat_updated()")
Signed-off-by: Breno Leitao <leitao@debian.org>
Suggested-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Yosry Ahmed <yosryahmed@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memcontrol.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -710,6 +710,7 @@ static inline void memcg_rstat_updated(s
 {
 	struct memcg_vmstats_percpu *statc;
 	int cpu = smp_processor_id();
+	unsigned int stats_updates;
 
 	if (!val)
 		return;
@@ -717,8 +718,9 @@ static inline void memcg_rstat_updated(s
 	cgroup_rstat_updated(memcg->css.cgroup, cpu);
 	statc = this_cpu_ptr(memcg->vmstats_percpu);
 	for (; statc; statc = statc->parent) {
-		statc->stats_updates += abs(val);
-		if (statc->stats_updates < MEMCG_CHARGE_BATCH)
+		stats_updates = READ_ONCE(statc->stats_updates) + abs(val);
+		WRITE_ONCE(statc->stats_updates, stats_updates);
+		if (stats_updates < MEMCG_CHARGE_BATCH)
 			continue;
 
 		/*
@@ -726,9 +728,9 @@ static inline void memcg_rstat_updated(s
 		 * redundant. Avoid the overhead of the atomic update.
 		 */
 		if (!memcg_vmstats_needs_flush(statc->vmstats))
-			atomic64_add(statc->stats_updates,
+			atomic64_add(stats_updates,
 				     &statc->vmstats->stats_updates);
-		statc->stats_updates = 0;
+		WRITE_ONCE(statc->stats_updates, 0);
 	}
 }
 
@@ -5690,7 +5692,7 @@ static void mem_cgroup_css_rstat_flush(s
 			}
 		}
 	}
-	statc->stats_updates = 0;
+	WRITE_ONCE(statc->stats_updates, 0);
 	/* We are in a per-cpu loop here, only do the atomic write once */
 	if (atomic64_read(&memcg->vmstats->stats_updates))
 		atomic64_set(&memcg->vmstats->stats_updates, 0);


