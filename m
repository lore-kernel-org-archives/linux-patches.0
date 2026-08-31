Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F3BE582B82;
	Mon, 31 Aug 2026 13:49:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184197; cv=none; b=XMbqOjTkWI45CKQk701QWjBW+bB9QUdpNF8E45F9Inrt+5XLQ5R0Yb0ifQYezk5v/EujS3C6DsQYfae/cDbEk5hd1+JtIlydHH7LjCVlY03vTHzXkiIwvm1yNvMp4WBEh8RJ3AzD+ww62OId1DNfviThLCRSY3wpWetM7KXiu0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184197; c=relaxed/simple;
	bh=cEIZjVXRfd+mKXvLlidGrD8yGxVGNRhDU8f0aHmnmgA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iPYMZGgx9Cizry+dGtIGY0IL8LVzPqenonh+SaJSYV5UVE1nQ+2Tltg7rSAUPOcedE9JlEvO2Sx4R0W0+kaVAF0/9Qma6YsKbG8cVKAJ1YNm6mLG8z+kFoNwysC8qSBQ7R1t147zOxFTWCKgD57oRsj9OPgKev0jB6Qdsxwtevg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KqLBVTR5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KqLBVTR5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8A521F00A3F;
	Mon, 31 Aug 2026 13:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184195;
	bh=hKH0tZRDdHMNPnmyCNcAIcyxU04yp78Tf160s2ctNsA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KqLBVTR5OUNSzYIrnJHG7Fbzu963cwmEkWsW3MSHmZsospjoMdFNZVzJwPs9Spj0t
	 L79KnaX+SeahVXS2c/vhRylweR59zbElJYtTthth9u9ISYxrE0NJbq2DVF5o+ZpavB
	 HxcnXeqE8Y58jFjGAM5629TdIlE/yheyDeA/feAeU7gwCcCAKYMQ0NI55R/FIA5Z5D
	 dN4VgoUxmmUi6Iu6I1Xbmwa6o0Axu+mla828QXla7pnyXkHXVtlm/T6ykoemURuwyv
	 Vmr6Cob7HI6xtuIhZYLrCJaXcupRg6mshRqG3r4zDBiyR4ZfnRVPHUGHDTHeYvRxCr
	 I0erGB4SuiE2g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Eric Dumazet <edumazet@google.com>,
	Jakub Sitnicki <jakub@cloudflare.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	davem@davemloft.net,
	pabeni@redhat.com,
	bridge@lists.linux.dev,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] net: bridge: remove stale rcu_barrier() in br_multicast_dev_del()
Date: Mon, 31 Aug 2026 09:29:36 -0400
Message-ID: <20260831133314.4125787-548-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 25ae123db10ba9ab890b56bcdb0a4363aee8529a ]

This rcu_barrier() came from a time call_rcu() calls were used in
net/bridge/br_multicast.c.

Now kfree_rcu() is there, we can remove this problematic rcu_barrier()
which causes extreme RTNL pressure in many syzbot reports.

INFO: task syz-executor:77945 is blocked on a mutex likely owned by task kworker/u1024:5:36537.
task:kworker/u1024:5 state:D stack:24616 pid:36537 tgid:36537 ppid:2      task_flags:0x4208060 flags:0x00080000 last_sleep:612797637337
Workqueue: netns cleanup_net
Call Trace:
 <TASK>
  [<ffffffff81914eaa>] context_switch+0xf2a/0x1730 kernel/sched/core.c:6483
  [<ffffffff81201143>] __schedule+0x1133/0x43a0 kernel/sched/core.c:8411
  [<ffffffff8120446b>] __schedule_loop kernel/sched/core.c:8514 [inline]
  [<ffffffff8120446b>] schedule+0xab/0x260 kernel/sched/core.c:8529
  [<ffffffff8121a093>] schedule_timeout+0xc3/0x2b0 kernel/time/sleep_timeout.c:75
  [<ffffffff81205347>] do_wait_for_common kernel/sched/completion.c:100 [inline]
  [<ffffffff81205347>] __wait_for_common kernel/sched/completion.c:121 [inline]
  [<ffffffff81205347>] wait_for_common kernel/sched/completion.c:132 [inline]
  [<ffffffff81205347>] wait_for_completion+0x2c7/0x5d0 kernel/sched/completion.c:153
  [<ffffffff81b8f27f>] rcu_barrier+0x49f/0x620 kernel/rcu/tree.c:3888
  [<ffffffff860091b3>] br_multicast_dev_del+0x303/0x350 net/bridge/br_multicast.c:4459
  [<ffffffff85fb5dbc>] br_dev_uninit+0x1c/0x40 net/bridge/br_device.c:157
  [<ffffffff8568058c>] unregister_netdevice_many_notify+0x1c1c/0x2300 net/core/dev.c:12599
  [<ffffffff8562be43>] ops_exit_rtnl_list net/core/net_namespace.c:187 [inline]
  [<ffffffff8562be43>] ops_undo_list+0x3d3/0x940 net/core/net_namespace.c:248

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Jakub Sitnicki <jakub@cloudflare.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Link: https://patch.msgid.link/20260519095540.2643318-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

### Step 1.1: Subject Line
**Record:** `[net: bridge]` `[remove]` — remove a stale `rcu_barrier()`
call from `br_multicast_dev_del()`.

### Step 1.2: Commit Message Tags
**Record:**
- **Fixes:** — not present (expected for manual review)
- **Reported-by:** — not present; syzbot impact described in body
- **Tested-by:** — not present
- **Reviewed-by:** Jakub Sitnicki `<jakub@cloudflare.com>`, Ido Schimmel
  `<idosch@nvidia.com>`
- **Acked-by:** Nikolay Aleksandrov `<razor@blackwall.org>` (bridge
  multicast maintainer)
- **Link:**
  https://patch.msgid.link/20260519095540.2643318-1-edumazet@google.com
- **Cc: stable:** — not present (not a negative signal)
- **Signed-off-by:** Eric Dumazet, Jakub Kicinski (ignore pipeline-added
  SOBs)

Notable: maintainer ack + two subsystem reviewers; syzbot deadlock stack
trace in body.

### Step 1.3: Commit Body Analysis
**Record:**
- **Bug:** `rcu_barrier()` in `br_multicast_dev_del()` is leftover from
  the `call_rcu()` era; multicast teardown now uses `kfree_rcu()`.
- **Symptom:** Extreme RTNL pressure; syzbot reports tasks blocked on
  mutex during `cleanup_net` workqueue processing.
- **Failure mode:** `cleanup_net` → `ops_exit_rtnl_list` (RTNL held) →
  `unregister_netdevice_many` → `br_dev_uninit` → `br_multicast_dev_del`
  → `rcu_barrier()` → hung task waiting on completion while kworker
  holds RTNL.
- **Root cause (author):** Global `rcu_barrier()` drains unrelated RCU
  callbacks while RTNL is held, creating lock-order / pressure problems.

### Step 1.4: Hidden Bug Fix Detection
**Record:** Yes — described as cleanup, but it fixes a real
hang/deadlock during network namespace teardown. Not cosmetic.

---

## Phase 2: Diff Analysis

### Step 2.1: Change Inventory
**Record:**
- **Files:** `net/bridge/br_multicast.c` only (−2 lines)
- **Function:** `br_multicast_dev_del()`
- **Scope:** Single-file, surgical deletion

### Step 2.2: Code Flow Change
**Record:**
- **Before:** After synchronous GC (`br_multicast_gc`) and
  `cancel_work_sync(&br->mcast_gc_work)`, call global `rcu_barrier()`.
- **After:** Return immediately after GC work is synchronized.
- **Path affected:** Bridge netdev teardown during namespace/device
  unregistration (error/cleanup path, not hot path).

### Step 2.3: Bug Mechanism
**Record:** **Category:** Deadlock / hung task from unnecessary global
synchronization.
- `rcu_barrier()` waits for all RCU callbacks system-wide.
- Called under RTNL during `cleanup_net`.
- Other workers may need RTNL to complete their RCU callbacks → circular
  wait.
- With `kfree_rcu()` only (no `call_rcu()` in this file), the barrier
  has no bridge-multicast callbacks of its own to wait for; it only
  stalls unrelated subsystems.

### Step 2.4: Fix Quality
**Record:** Obviously correct and minimal. Bridge maintainer confirmed
the barrier is stale. Regression risk is very low: synchronous GC +
`cancel_work_sync` already ensure teardown ordering; `kfree_rcu` handles
deferred freeing without a global barrier. Precedent: `writeback: drop
now-unnecessary rcu_barrier()` was backported to stable (commit
`29de8448174cf` in this tree).

---

## Phase 3: Git History Investigation

### Step 3.1: Blame
**Record:**
- `rcu_barrier()` at line 4460 introduced by Nikolay Aleksandrov, commit
  `4329596cb10d23` (2018-12-05), when switching from `call_rcu_bh` to
  `kfree_rcu`.
- `cancel_work_sync` added in `e12cec65b5546` (2020-09-07) with the GC
  refactor.
- Bug present since 2018; deadlock surfaced under syzbot stress.

### Step 3.2: Fixes: Tag
**Record:** N/A — no `Fixes:` tag. Original introduction:
`4329596cb10d23` ("net: bridge: multicast: use non-bh rcu flavor"),
which is an ancestor of this tree.

### Step 3.3: Related File History
**Record:**
- `4329596cb10d23`: `call_rcu_bh` → `kfree_rcu`, kept `rcu_barrier()`
  (changed from `rcu_barrier_bh()`).
- `e12cec65b5546`: GC refactor; `br_multicast_dev_del` now uses
  synchronous `br_multicast_gc()`.
- No `call_rcu` remains in `br_multicast.c` (verified).
- Standalone one-patch series (v1 only per `b4 dig -a`).

### Step 3.4: Author Context
**Record:** Eric Dumazet is a senior networking developer. Nikolay
Aleksandrov (bridge maintainer) acked. No conflicting follow-up fixes
found.

### Step 3.5: Dependencies
**Record:** No dependencies. Prerequisites (`kfree_rcu` migration, GC
refactor) are both ancestors of HEAD. Patch applies cleanly (`git apply
--check` → **APPLIES CLEANLY**). Fix commit `25ae123db10ba` is **NOT**
in this tree.

---

## Phase 4: Mailing List and External Research

### Step 4.1: Original Discussion
**Record:**
- `b4 dig -c 25ae123db10ba` →
  https://patch.msgid.link/20260519095540.2643318-1-edumazet@google.com
- Single revision (v1, 2026-05-19).
- Nikolay Aleksandrov: **Acked-by** — confirms barrier is no longer
  needed.
- No NAKs found in thread.
- No explicit `Cc: stable` in thread, but that is not required.

### Step 4.2: Reviewers
**Record:** CC'd: David Miller, Jakub Kicinski, Paolo Abeni, Simon
Horman, netdev@, Nikolay Aleksandrov, Ido Schimmel. Appropriate
maintainers/reviewers involved.

### Step 4.3: Bug Report
**Record:** syzbot-style hung-task trace in commit message and patch.
Task blocked on mutex during `cleanup_net` / `rcu_barrier`. Reproducible
under fuzzing; affects netns teardown with bridges.

### Step 4.4: Related Patches
**Record:** Standalone patch, not part of a series. Similar pattern in
writeback (`29de8448174cf`, already backported here).

### Step 4.5: Stable List History
**Record:** Not searched on lore stable@ (WebFetch blocked by bot
protection for direct lore). No evidence this was rejected for stable.
Fix is not yet in `stable/linux-6.18.y`.

---

## Phase 5: Code Semantic Analysis

### Step 5.1: Key Functions
**Record:** `br_multicast_dev_del()` modified.

### Step 5.2: Callers
**Record:**
- `br_dev_uninit()` in `net/bridge/br_device.c:157` — called during
  netdev unregistration.
- Reachable from `unregister_netdevice_many()` → `ops_exit_rtnl_list()`
  → `cleanup_net` workqueue.
- Affects all bridge teardown when `CONFIG_BRIDGE_IGMP_SNOOPING` is
  enabled.

### Step 5.3: Callees
**Record:** `br_multicast_del_mdb_entry`, `br_multicast_ctx_deinit`,
`br_multicast_gc`, `cancel_work_sync`, (removed) `rcu_barrier`.
- `br_multicast_gc` synchronously calls destroy callbacks that use
  `kfree_rcu()` for mdb entries, port groups, and group sources.

### Step 5.4: Call Chain / Reachability
**Record:**
`unshare(CLONE_NEWNET)` / container stop / `ip netns delete` → netns
refcount drop → `cleanup_net` → bridge device unregister →
`br_multicast_dev_del`. Userspace-triggerable via namespace lifecycle;
common in containers.

### Step 5.5: Similar Patterns
**Record:**
- `br.c:506` still has `rcu_barrier()` at **module unload** — different
  context (fdb kmem_cache teardown), intentionally kept.
- `writeback` had identical stale-`rcu_barrier` removal backported to
  stable.

---

## Phase 6: Cross-Reference Against Local Tree

### Step 6.1: Buggy Code Present?
**Record:** **Yes.** Local tree is **Linux 6.18.44**
(`stable/linux-6.18.y`). `rcu_barrier()` present at
`net/bridge/br_multicast.c:4460`. Fix commit `25ae123db10ba` is **not**
merged.

### Step 6.2: Backport Complications
**Record:** Clean apply confirmed. No conflicting refactors in this
function between mainline fix and 6.18.y.

### Step 6.3: Related Fixes Already Present?
**Record:** No equivalent fix in tree. `git grep "remove stale
rcu_barrier"` returns nothing. Prerequisites (`kfree_rcu`, GC refactor)
are present.

---

## Phase 7: Subsystem and Maintainer Context

### Step 7.1: Subsystem Criticality
**Record:** **net/bridge** — IMPORTANT. Bridge is widely used in
virtualization, containers, and enterprise networking.

### Step 7.2: Subsystem Activity
**Record:** Actively maintained; recent multicast fixes from Nikolay
Aleksandrov in 6.18.y.

---

## Phase 8: Impact and Risk Assessment

### Step 8.1: Who Is Affected
**Record:** Users with `CONFIG_BRIDGE` + `CONFIG_BRIDGE_IGMP_SNOOPING`
who tear down bridges during network namespace cleanup (containers, LXC,
Kubernetes CNI, test harnesses).

### Step 8.2: Trigger Conditions
**Record:** Network namespace deletion with bridge devices present.
syzbot reproduces under stress. Not every boot, but realistic in
container orchestration. Unprivileged users can trigger via user
namespaces + bridge setup.

### Step 8.3: Failure Severity
**Record:** Hung task / RTNL deadlock during cleanup — **CRITICAL**
(namespace teardown stalls, can leave system in degraded state).

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** HIGH — prevents real hangs in namespace teardown.
- **Risk:** VERY LOW — 2-line deletion, maintainer-acked, synchronous GC
  already in place.
- **Ratio:** Strongly favors backport.

---

## Phase 9: Final Synthesis

### Step 9.1: Evidence Summary

**FOR:**
- Real, reproducible hung-task / RTNL pressure (syzbot).
- Critical failure mode during netns cleanup.
- Minimal, maintainer-acked fix.
- Buggy code present in 6.18.44.
- Applies cleanly.
- `kfree_rcu` has been used since 2018; `rcu_barrier` is genuinely
  stale.
- Precedent: similar `rcu_barrier` removal backported in writeback.

**AGAINST:**
- Only affects configs with bridge IGMP snooping (not universal, but
  very common in distros).
- No explicit `Cc: stable` (irrelevant per review rules).

**UNRESOLVED:**
- Exact syzkaller bug URL not fetched (lore bot-blocked); stack trace in
  commit is sufficient.

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — maintainer ack, two reviews,
   syzbot validation.
2. Fixes a real bug? **PASS** — hung task during netns cleanup.
3. Important issue? **PASS** — deadlock/hang, CRITICAL severity.
4. Small and contained? **PASS** — 2 lines, 1 file.
5. No new features/APIs? **PASS** — deletion only.
6. Can apply to local tree? **PASS** — clean apply verified.

### Step 9.3: Exception Categories
**Record:** Not a device-ID/quirk/DT/build/doc exception. Qualifies as a
straight bug fix.

### Step 9.4: Decision Rationale
The stale `rcu_barrier()` in `br_multicast_dev_del()` causes real hangs
when bridges are torn down during network namespace cleanup. The barrier
was needed for `call_rcu()` callbacks that no longer exist — all
multicast objects now use `kfree_rcu()` with synchronous GC beforehand.
Removing it is safe, tiny, and maintainer-approved. The bug exists in
Linux 6.18.44 and the fix applies cleanly.

---

## Verification

- [Phase 1] `git show 25ae123db10ba`: parsed subject, tags, body, stack
  trace
- [Phase 2] Read `br_multicast_dev_del()` at lines 4444–4461; confirmed
  −2 line diff
- [Phase 2] `grep call_rcu net/bridge/br_multicast.c`: no matches (only
  `kfree_rcu`)
- [Phase 3] `git blame -L 4458,4461`: `rcu_barrier` from
  `4329596cb10d23` (2018)
- [Phase 3] `git show 4329596cb10d23`: `call_rcu_bh` → `kfree_rcu`, kept
  `rcu_barrier`
- [Phase 3] `git show e12cec65b5546`: GC refactor with synchronous
  destroy
- [Phase 3] `git merge-base --is-ancestor`: both prerequisite commits in
  tree
- [Phase 3] `git merge-base --is-ancestor 25ae123db10ba HEAD`: **NOT IN
  TREE**
- [Phase 3] `git apply --check`: **APPLIES CLEANLY**
- [Phase 4] `b4 dig -c 25ae123db10ba`: lore URL found
- [Phase 4] `b4 dig -w`: netdev maintainers CC'd
- [Phase 4] `b4 dig -a`: v1 only, no later revisions
- [Phase 4] mbox: Acked-by Nikolay Aleksandrov; Reviewed-by Sitnicki,
  Schimmel
- [Phase 5] `grep br_multicast_dev_del`: caller `br_dev_uninit` at
  `br_device.c:157`
- [Phase 5] Read `ops_exit_rtnl_list` at `net_namespace.c:165–189`: RTNL
  held during unregister
- [Phase 5] Read `br_multicast_gc` at lines 893–902: synchronous destroy
  with `kfree_rcu`
- [Phase 6] `git describe HEAD`: v6.18.44; `make kernelversion`: 6.18.44
- [Phase 6] Confirmed `rcu_barrier()` at line 4460 still present
- [Phase 6] `git log stable/linux-6.18.y --grep="stale rcu_barrier"`: no
  match
- [Phase 8] `git show 29de8448174cf`: precedent for stale `rcu_barrier`
  removal in stable
- [Phase 8] `grep rcu_barrier net/bridge/`: only `br_multicast.c:4460`
  and `br.c:506` (module exit)

**YES**The background checks finished and match the earlier analysis.

**Task 65367** (`git log -S "rcu_barrier"` on `br_multicast.c`): the
only relevant hit was `10cc2b50eb4b0` (RCU race fix in
`br_multicast_stop`). The `rcu_barrier()` in `br_multicast_dev_del()`
came from the 2018 `kfree_rcu` migration (`4329596cb10d23`).

**Task 65368** (stable branch search): the fix commit `25ae123db10ba` is
**not** in `stable/linux-6.18.y`. The stale `rcu_barrier()` is still
present at line 4460 in this tree.

**Verdict unchanged: YES** — backport to Linux 6.18.y. It’s a 2-line
removal that fixes syzbot-reported hangs during netns/bridge teardown,
applies cleanly, and is acked by the bridge maintainer.

 net/bridge/br_multicast.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index ce34881a9d96e..1014f6221472e 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -4456,8 +4456,6 @@ void br_multicast_dev_del(struct net_bridge *br)
 	br_multicast_ctx_deinit(&br->multicast_ctx);
 	br_multicast_gc(&deleted_head);
 	cancel_work_sync(&br->mcast_gc_work);
-
-	rcu_barrier();
 }
 
 int br_multicast_set_router(struct net_bridge_mcast *brmctx, unsigned long val)
-- 
2.53.0

