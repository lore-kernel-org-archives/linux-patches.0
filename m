Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8803130596A;
	Sat, 25 Oct 2025 16:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761408839; cv=none; b=oQUxzKYDZQ5plwr2ueOXk1FnXZZdVjL+0HuLJlOyrTbV7xpV6cZH4NxrxsMAgW2dGHAB9QgkfLZa768LkgbJbZFRM4MrDh5y8ZvDLpjZ8W9335UcwJKyGtjcKOwrO7nVyIg42yyycruw5D/yzaOquJcbpveZCkTpDakChdoYn2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761408839; c=relaxed/simple;
	bh=TB5Z+F1tILjc2GPJwMgpGIeudcSpbtWIlR6TLGmC/Fg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pGGl5P+Yw4ux56eQGwS+6hoPIoQpvVIf4GQCRZsjw8kpG2lVNNCKjfZsBttRNFQbcW4JkCo/Dci5nhhTI6Ky1V6Hb5YDyugSgqeYUo67ZlXbVmreQBSkyJboML1WscVhvTmiw9VM55tTXKA4aX98dG7f8OkMpe3MSjPaOKgFTKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=au0INgSA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="au0INgSA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 377E6C4CEF5;
	Sat, 25 Oct 2025 16:13:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761408839;
	bh=TB5Z+F1tILjc2GPJwMgpGIeudcSpbtWIlR6TLGmC/Fg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=au0INgSAeZ6/UnXj5AxdTu+ZbfRVQuA05x6tvgzyTXkTTet77d+H27fav1TvyYqCK
	 kis+XJrgvnjuZUmK/dnURkGU/UposFqQvt8jVc7meqXWNW3nCkfns4zNDR1LFopA+N
	 2htR+NGv0f/iq7KMRumLd5TojEF4fyYY3yxaPHbi2ystDkbDwlX4JblYp3IOSnGv2c
	 mYTHiVjErQxrVW9HgQCNHkYsDSr9SbsHR2eBYetrEZWWTEMJPeMMeo/7hDvt+BdQqN
	 qN/FuKuzmWxUDbwb6AwbTqo8qgU7Ps1lyylMEOxzEmArpsRwBpDYv8doGNZQGxnPN/
	 KxbUA0AgP7Qdw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Christoph Paasch <cpaasch@openai.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Eric Dumazet <edumazet@google.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	davem@davemloft.net,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.17-5.4] net: When removing nexthops, don't call synchronize_net if it is not necessary
Date: Sat, 25 Oct 2025 11:55:25 -0400
Message-ID: <20251025160905.3857885-94-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christoph Paasch <cpaasch@openai.com>

[ Upstream commit b0ac6d3b56a2384db151696cfda2836a8a961b6d ]

When removing a nexthop, commit
90f33bffa382 ("nexthops: don't modify published nexthop groups") added a
call to synchronize_rcu() (later changed to _net()) to make sure
everyone sees the new nexthop-group before the rtnl-lock is released.

When one wants to delete a large number of groups and nexthops, it is
fastest to first flush the groups (ip nexthop flush groups) and then
flush the nexthops themselves (ip -6 nexthop flush). As that way the
groups don't need to be rebalanced.

However, `ip -6 nexthop flush` will still take a long time if there is
a very large number of nexthops because of the call to
synchronize_net(). Now, if there are no more groups, there is no point
in calling synchronize_net(). So, let's skip that entirely by checking
if nh->grp_list is empty.

This gives us a nice speedup:

BEFORE:
=======

$ time sudo ip -6 nexthop flush
Dump was interrupted and may be inconsistent.
Flushed 2097152 nexthops

real	1m45.345s
user	0m0.001s
sys	0m0.005s

$ time sudo ip -6 nexthop flush
Dump was interrupted and may be inconsistent.
Flushed 4194304 nexthops

real	3m10.430s
user	0m0.002s
sys	0m0.004s

AFTER:
======

$ time sudo ip -6 nexthop flush
Dump was interrupted and may be inconsistent.
Flushed 2097152 nexthops

real	0m17.545s
user	0m0.003s
sys	0m0.003s

$ time sudo ip -6 nexthop flush
Dump was interrupted and may be inconsistent.
Flushed 4194304 nexthops

real	0m35.823s
user	0m0.002s
sys	0m0.004s

Signed-off-by: Christoph Paasch <cpaasch@openai.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://patch.msgid.link/20250816-nexthop_dump-v2-2-491da3462118@openai.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

Why this is a good stable backport
- Fixes a real, user-facing regression in large-scale environments:
  deleting many nexthops pays an O(N) cost from an unnecessary RCU grace
  period per nexthop. The commit message shows dramatic runtime
  reductions (minutes → seconds) for “ip -6 nexthop flush” on millions
  of nexthops. This is an operational pain point, not a micro-
  optimization.
- Minimal, localized change with no functional/architectural impact: it
  only short-circuits a barrier when there is provably nothing to
  synchronize. No API changes, no behavior changes when cleanup is
  actually needed.
- Preserves correctness: the synchronize call was introduced to
  serialize readers after updating a published group array (commit
  90f33bffa382). Skipping it is safe when there were no group updates.

Specific code and history analysis
- Barrier origin and purpose:
  - 90f33bffa382 added a post-update grace period to “make sure all see
    the newly published array before releasing RTNL” by calling
    `synchronize_rcu()` (later became `synchronize_net()`).
  - See 90f33bffa382: net/ipv4/nexthop.c: the barrier was added after
    removing a nexthop from groups.
- Current code path (pre-patch):
  - `remove_nexthop_from_groups()` iterates `nh->grp_list`, potentially
    updating group arrays via `remove_nh_grp_entry()`, then
    unconditionally calls `synchronize_net()`; net/ipv4/nexthop.c:2085
    and net/ipv4/nexthop.c:2094.
  - This function runs for non-group nexthops during deletion; see call
    site in `__remove_nexthop()`: net/ipv4/nexthop.c:2166. The RTNL lock
    is held across deletion (rtnl lock in `rtm_del_nexthop()`);
    net/ipv4/nexthop.c:3310.
- The patch’s exact change:
  - Adds an early return when there is nothing to remove:
    - New check: `if (list_empty(&nh->grp_list)) return;`
    - This prevents the unconditional `synchronize_net()` when `nh`
      belongs to no groups.
  - The loop and the barrier still run when there are entries to remove,
    preserving the original safety guarantee.
- Why the early return is safe:
  - If `&nh->grp_list` is empty, no group arrays are modified; there is
    nothing to “publish” and thus no readers to wait out. The barrier is
    purely to serialize readers after `rcu_assign_pointer()` of a new
    group array (e.g., in `remove_nh_grp_entry()` which calls
    `rcu_assign_pointer(nhp->nh_grp, newg)`; net/ipv4/nexthop.c:around
    2020). With no modifications, the barrier is a no-op, only adding
    latency.
  - Concurrency context is correct: group membership modifications
    happen under RTNL, and `remove_nexthop_from_groups()` is called
    under RTNL; `list_empty()` on `nh->grp_list` is consistent. The list
    head is always initialized (`INIT_LIST_HEAD(&nh->grp_list)`;
    net/ipv4/nexthop.c:542).
  - Other RCU barriers in the file that protect real publications remain
    intact (e.g., in group replacement, `synchronize_net()` remains;
    net/ipv4/nexthop.c:2291).

Stable policy considerations
- Scope is tiny and self-contained (one function, one early return); no
  cross-subsystem impact.
- Not a feature; it is a performance fix for a behavior introduced by an
  earlier change (90f33bffa382) that added unconditional grace periods
  even when nothing changed.
- Risk of regression is very low: previously, the barrier was sometimes
  unnecessary. Now it remains when necessary and is skipped when
  provably unneeded. No change to notifier behavior or group update
  logic.

Practical backport notes
- Older stable trees may have `synchronize_rcu()` instead of
  `synchronize_net()` at the end of `remove_nexthop_from_groups()`. The
  early return remains valid and safe regardless; adapt the barrier name
  to the tree’s version if needed.
- The infrastructure used by the check (`nh->grp_list`) and usage
  context (RTNL held) are long-standing and present in stable kernels
  that have nexthop groups.

Conclusion
- This change is a classic stable backport candidate: important user-
  visible improvement, minimal risk, no semantics change, and tightly
  scoped to the nexthop cleanup path.

 net/ipv4/nexthop.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 34137768e7f9a..15acfb74fd238 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -2087,6 +2087,12 @@ static void remove_nexthop_from_groups(struct net *net, struct nexthop *nh,
 {
 	struct nh_grp_entry *nhge, *tmp;
 
+	/* If there is nothing to do, let's avoid the costly call to
+	 * synchronize_net()
+	 */
+	if (list_empty(&nh->grp_list))
+		return;
+
 	list_for_each_entry_safe(nhge, tmp, &nh->grp_list, nh_list)
 		remove_nh_grp_entry(net, nhge, nlinfo);
 
-- 
2.51.0

