Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB7A86453
	for <patches@lists.linux.dev>; Tue, 22 Mar 2022 21:40:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D046C340F2;
	Tue, 22 Mar 2022 21:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1647985208;
	bh=zQUgG65EKYS6D0TPC8dtYrqq7kbaZkukOw4swICrN0E=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=AUsQfmHNf2WqHk+2zAP4qmzCTXmb1D8dQvfwk98kjYUobePW3ZcbKO05I9yMsD4mF
	 9p4H5aW3rsDTG7H/76dxrn2lqCryZXQXz/FCz8czEy5tekAYcC/hjl2+h33dygaiy/
	 lwOYe5BIqMf2plH9yrchDzR0/oC4T6LosQATBwvE=
Date: Tue, 22 Mar 2022 14:40:07 -0700
To: vvs@virtuozzo.com,roman.gushchin@linux.dev,mhocko@suse.com,hannes@cmpxchg.org,shakeelb@google.com,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 032/227] memcg: replace in_interrupt() with !in_task()
Message-Id: <20220322214008.6D046C340F2@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Shakeel Butt <shakeelb@google.com>
Subject: memcg: replace in_interrupt() with !in_task()

Replace the deprecated in_interrupt() with !in_task() because
in_interrupt() returns true for BH disabled even if the call happens in
the task context.  in_task() is the right interface to differentiate task
context from NMI, hard IRQ and softirq contexts.

Link: https://lkml.kernel.org/r/20220127162636.3461256-1-shakeelb@google.com
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Michal Hocko <mhocko@suse.com>
Cc: Vasily Averin <vvs@virtuozzo.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/memcontrol.c~memcg-replace-in_interrupt-with-in_task
+++ a/mm/memcontrol.c
@@ -2688,7 +2688,7 @@ done_restock:
 			READ_ONCE(memcg->swap.high);
 
 		/* Don't bother a random interrupted task */
-		if (in_interrupt()) {
+		if (!in_task()) {
 			if (mem_high) {
 				schedule_work(&memcg->high_work);
 				break;
@@ -6968,7 +6968,7 @@ void mem_cgroup_sk_alloc(struct sock *sk
 		return;
 
 	/* Do not associate the sock with unrelated interrupted task's memcg. */
-	if (in_interrupt())
+	if (!in_task())
 		return;
 
 	rcu_read_lock();
_
