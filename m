Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0E266453
	for <patches@lists.linux.dev>; Tue, 22 Mar 2022 21:40:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B700C340F2;
	Tue, 22 Mar 2022 21:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1647985229;
	bh=q+Rxyd8FiWtWfSb4FllBbKO/RZXn17P9B+CTV10QsCs=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=B2sWeZSQ9z7hq1jQg+bmH1SIebIe9UVpbmkRuUuz2bIIGfs/0a+aM9spMPOwax2Pn
	 XPYmRWStWga3Oumce8MvYbvD0WdGrnGr9tlgHCgN7XFU0n6IxxBXV3oCXwcB+NGXyZ
	 PinUKX7Mo9x0OOhHdjwc9IFp/LtyaBy6M65d9Y8s=
Date: Tue, 22 Mar 2022 14:40:28 -0700
To: roman.gushchin@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,guro@fb.com,chris@chrisdown.name,shakeelb@google.com,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 039/227] memcg: synchronously enforce memory.high for large overcharges
Message-Id: <20220322214029.6B700C340F2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Shakeel Butt <shakeelb@google.com>
Subject: memcg: synchronously enforce memory.high for large overcharges

The high limit is used to throttle the workload without invoking the
oom-killer.  Recently we tried to use the high limit to right size our
internal workloads.  More specifically dynamically adjusting the limits of
the workload without letting the workload get oom-killed.  However due to
the limitation of the implementation of high limit enforcement, we
observed the mechanism fails for some real workloads.

The high limit is enforced on return-to-userspace i.e.  the kernel let the
usage goes over the limit and when the execution returns to userspace, the
high reclaim is triggered and the process can get throttled as well. 
However this mechanism fails for workloads which do large allocations in a
single kernel entry e.g.  applications that mlock() a large chunk of
memory in a single syscall.  Such applications bypass the high limit and
can trigger the oom-killer.

To make high limit enforcement more robust, this patch makes the limit
enforcement synchronous only if the accumulated overcharge becomes larger
than MEMCG_CHARGE_BATCH.  So, most of the allocations would still be
throttled on the return-to-userspace path but only the extreme allocations
which accumulates large amount of overcharge without returning to the
userspace will be throttled synchronously.  The value MEMCG_CHARGE_BATCH
is a bit arbitrary but most of other places in the memcg codebase uses
this constant therefore for now uses the same one.

Link: https://lkml.kernel.org/r/20220211064917.2028469-5-shakeelb@google.com
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Reviewed-by: Roman Gushchin <guro@fb.com>
Acked-by: Chris Down <chris@chrisdown.name>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/mm/memcontrol.c~memcg-synchronously-enforce-memoryhigh-for-large-overcharges
+++ a/mm/memcontrol.c
@@ -2704,6 +2704,11 @@ done_restock:
 		}
 	} while ((memcg = parent_mem_cgroup(memcg)));
 
+	if (current->memcg_nr_pages_over_high > MEMCG_CHARGE_BATCH &&
+	    !(current->flags & PF_MEMALLOC) &&
+	    gfpflags_allow_blocking(gfp_mask)) {
+		mem_cgroup_handle_over_high();
+	}
 	return 0;
 }
 
_
