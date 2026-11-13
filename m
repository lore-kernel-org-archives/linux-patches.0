Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591460;
	b=Wo+0Lrwn6pKOGZoSmkBf9B+r7qoqCcllIfflm0cPi6iXi28VDwJBbgMN0QOJ8XunDXz/
	 mhVXY1D0FaWuojozsBX6Di64UcbvF2dqLJPjH6rp8F2JybjNFReFcKCLZY3cLcGc0jSRu
	 ig13780a960Ts0T+2iT5H6etzlyAEhes9XlnYsHhk8sf+52yzE5t78gqZnSGWk5e2WIoj
	 TNhpjcXNhwSnmQbgWbfXnWNgkQ8fdVcHJQV1whh6vX4MpMDXmJNZ8lUq1Mj0U/1srh2rk
	 USCOwRo5m7IK9bFSZJ7J4B7kCCOckMOIxc9v0XADkZBlWowZQg36PstH2J3S0I6Eskg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591460;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+RR011xAOyEhMkn0uAwuUCkuUvQiPkxsUG+m0xsuNNw=;
	b=LvDITCPyDNZEJpy+RfYhHMp451AwpNIRhpjpIw78jFoREOoMGW60D5y2cicOid9uHJTv
	 ZeQmPsNi3xltjhfQUz8HcIb03EGNJiN84bOPvvgx6DuG6fhvaISjdJd05EUupIKCIVEEb
	 6AeVvrpNauHRprbGL8QqHEf9fNOMCvizUSvghPZMNW60HhKX1aB+pkBojgLzGM/OWWVXv
	 BiK5Lkf29QplxxooKMkObfwD4u/i5XgSMNGBDtPm18eDxiO/4rynPV97AvUcBjRV9UZh7
	 YmxxEwZqH3m+0OFm0VPLZhCrkVUv8ErShBbUVPRsm7W13truJnmq94KR8cqty8Nu5SQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oGQQjg+3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7572606E211;
	Fri, 13 Nov 2026 17:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oGQQjg+3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9946C1F000C4;
	Fri, 13 Nov 2026 17:37:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591459;
	bh=+RR011xAOyEhMkn0uAwuUCkuUvQiPkxsUG+m0xsuNNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oGQQjg+3av36SeM0wPPOzF6b7T0HZgdMvYL0h7cCRnCDszzT9JiHddEa/QE5ZmiJw
	 AoBgaDkRHuo4rVeQbSF0GREdmUnjs8nkQlKsDiaS3VK71HgVDy5PK7OIwK/0Ikatji
	 t4f9qv086FM1xIqbLcO5Y5H+S5brQEHZZRtokZS8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Damato <joe@dama.to>,
	Andrew Morton <akpm@linux-foundation.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 545/670] mm: memcontrol: raise MEMCG_MAX for charges that fail without reclaiming
Date: Fri, 13 Nov 2026 10:51:49 -0500
Message-ID: <20261113153830.359403061@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Damato <joe@dama.to>

[ Upstream commit 374f65b1481992eb6b9c6bffd53f3afa5c2e94cf ]

Charges that exceed memory.max and return through the nomem label can
raise no event and simply return -ENOMEM.

A non-blocking charge can hit the limit, get rejected, but is not visible
in memory.events.

This was noticed in a production setting where bpf_mem_alloc() attempted
to refill its per-cpu freelists, which triggered a non-blocking charge
while at the limit.

Commit d6e103a757fa ("mm: memcontrol: do not miss MEMCG_MAX events for
enforced allocations") added raised_max_event to cover charges that are
force charged without ever reaching reclaim, but charges that are rejected
outright were left out.  Getting an allocation failure without the
corresponding MEMCG_MAX event is unexpected and makes debugging and
monitoring harder.

Raise the event on the way out for rejected charges as well, by routing
the -ENOMEM return through the same exit path that already covers forced
charges.  The existing behavior of raising a MEMCG_MAX event on every
charge/reclaim/retry iteration is left unchanged.

Tested with a module that performs accounted GFP_NOWAIT page allocations
from a task in a cgroup at its memory.max, and measures the resulting
memory.events:max delta.  Without this patch the rejected charges raise no
event at all; with it the delta matches the number of rejected charges
exactly.  A GFP_KERNEL|__GFP_NORETRY control, which reaches reclaim,
raises the same two events per failed charge before and after, confirming
the existing charge/reclaim/retry accounting is unchanged.

Link: https://lore.kernel.org/20260831174836.3102406-1-joe@dama.to
Fixes: d6e103a757fa ("mm: memcontrol: do not miss MEMCG_MAX events for enforced allocations")
Signed-off-by: Joe Damato <joe@dama.to>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: <stable@vger.kernel.org>
[ sashal: Replaced __memcg_memory_event(..., allow_spinning) with the existing memcg_memory_event() helper. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/memcontrol.c | 28 ++++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index b713cda2628a8..2aae088c86082 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2182,10 +2182,11 @@ int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	bool drained = false;
 	bool raised_max_event = false;
 	unsigned long pflags;
+	int ret = 0;
 
 retry:
 	if (consume_stock(memcg, nr_pages))
-		return 0;
+		return ret;
 
 	if (!do_memsw_account() ||
 	    page_counter_try_charge(&memcg->memsw, batch, &counter)) {
@@ -2297,16 +2298,11 @@ int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	 * put the burden of reclaim on regular allocation requests
 	 * and let these go through as privileged allocations.
 	 */
-	if (!(gfp_mask & (__GFP_NOFAIL | __GFP_HIGH)))
-		return -ENOMEM;
+	if (!(gfp_mask & (__GFP_NOFAIL | __GFP_HIGH))) {
+		ret = -ENOMEM;
+		goto out;
+	}
 force:
-	/*
-	 * If the allocation has to be enforced, don't forget to raise
-	 * a MEMCG_MAX event.
-	 */
-	if (!raised_max_event)
-		memcg_memory_event(mem_over_limit, MEMCG_MAX);
-
 	/*
 	 * The allocation either can't fail or will lead to more memory
 	 * being freed very soon.  Allow memory usage go over the limit
@@ -2316,7 +2312,15 @@ int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	if (do_memsw_account())
 		page_counter_charge(&memcg->memsw, nr_pages);
 
-	return 0;
+out:
+	/*
+	 * Don't forget to raise a MEMCG_MAX event for forced or rejected
+	 * requests.
+	 */
+	if (!raised_max_event)
+		memcg_memory_event(mem_over_limit, MEMCG_MAX);
+
+	return ret;
 
 done_restock:
 	if (batch > nr_pages)
@@ -2375,7 +2379,7 @@ int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	    !(current->flags & PF_MEMALLOC) &&
 	    gfpflags_allow_blocking(gfp_mask))
 		mem_cgroup_handle_over_high(gfp_mask);
-	return 0;
+	return ret;
 }
 
 /**
-- 
2.53.0



