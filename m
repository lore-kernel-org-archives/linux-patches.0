Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD06D6453
	for <patches@lists.linux.dev>; Tue, 22 Mar 2022 21:40:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74014C340F2;
	Tue, 22 Mar 2022 21:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1647985223;
	bh=YOlOXimAS2pZdwcnwOmgXOf4GoqCQNwjVOt5ANWwj6M=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=tukPY7UL197MQ013zoWppMKTlT98ULllWAeY17RP6KNV3l3z49/VKBtcvjjCp76kH
	 weCnMkE1kngfpf/bVxmz8qvZ0vmwV3xaoB9e0DPinuI1pghtbfHFele6LcE1HdvETL
	 pCPUh4BfHWusqFyIOYyBiz1m/PwDxJpfez1FneSA=
Date: Tue, 22 Mar 2022 14:40:22 -0700
To: roman.gushchin@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,guro@fb.com,chris@chrisdown.name,shakeelb@google.com,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 037/227] memcg: unify force charging conditions
Message-Id: <20220322214023.74014C340F2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Shakeel Butt <shakeelb@google.com>
Subject: memcg: unify force charging conditions

Currently the kernel force charges the allocations which have __GFP_HIGH
flag without triggering the memory reclaim.  __GFP_HIGH indicates that the
caller is high priority and since commit 869712fd3de5 ("mm: memcontrol:
fix network errors from failing __GFP_ATOMIC charges") the kernel lets
such allocations do force charging.  Please note that __GFP_ATOMIC has
been replaced by __GFP_HIGH.

__GFP_HIGH does not tell if the caller can block or can trigger reclaim. 
There are separate checks to determine that.  So, there is no need to skip
reclaiming for __GFP_HIGH allocations.  So, handle __GFP_HIGH together
with __GFP_NOFAIL which also does force charging.

Please note that this is a noop change as there are no __GFP_HIGH
allocators in the kernel which also have __GFP_ACCOUNT (or SLAB_ACCOUNT)
and does not allow reclaim for now.

Link: https://lkml.kernel.org/r/20220211064917.2028469-3-shakeelb@google.com
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Reviewed-by: Roman Gushchin <guro@fb.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Chris Down <chris@chrisdown.name>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |   17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

--- a/mm/memcontrol.c~memcg-unify-force-charging-conditions
+++ a/mm/memcontrol.c
@@ -2566,15 +2566,6 @@ retry:
 	}
 
 	/*
-	 * Memcg doesn't have a dedicated reserve for atomic
-	 * allocations. But like the global atomic pool, we need to
-	 * put the burden of reclaim on regular allocation requests
-	 * and let these go through as privileged allocations.
-	 */
-	if (gfp_mask & __GFP_ATOMIC)
-		goto force;
-
-	/*
 	 * Prevent unbounded recursion when reclaim operations need to
 	 * allocate memory. This might exceed the limits temporarily,
 	 * but we prefer facilitating memory reclaim and getting back
@@ -2647,7 +2638,13 @@ retry:
 		goto retry;
 	}
 nomem:
-	if (!(gfp_mask & __GFP_NOFAIL))
+	/*
+	 * Memcg doesn't have a dedicated reserve for atomic
+	 * allocations. But like the global atomic pool, we need to
+	 * put the burden of reclaim on regular allocation requests
+	 * and let these go through as privileged allocations.
+	 */
+	if (!(gfp_mask & (__GFP_NOFAIL | __GFP_HIGH)))
 		return -ENOMEM;
 force:
 	/*
_
