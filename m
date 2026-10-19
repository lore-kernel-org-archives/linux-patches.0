Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38883597F3A;
	Mon, 19 Oct 2026 13:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418351; cv=none; b=WoI1p9AI0N/s4YklKGlWsTZWRghziNJuHOTUMe2NYCR01yPM73Vtp7rb7KLBMaxrRAb3lM1MkMySxsoT5wl30Os4/PXnf9BZztfyBJDsUdh8IvVgyhVpaxZ6qMdGWK1+bJvf1JkLybJdGo8PFLxebSa1U4nvg7Q43eoZ3WML1pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418351; c=relaxed/simple;
	bh=ZmFqn/SlAhc3v+Rc1ip2hLKtM3P6jisQx7T+4rsX0Os=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hYTHnSJWpFcAm2qMc48BQnPw4076g+EFqOENUaB9LZiYTXOXOQqRK6GwHj/+ZcOuFvlCKTqHbGYbu2tsZBoyNDKXoKgA+E2jpazYK6Ra2EUP8dCPNoHboAMuk7L/rXSXw36ozbb206QwrHAQ7x40UiFJ0wP50sZ9pIIKAewGhJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V3mrAqjx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V3mrAqjx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24E7F1F000CA;
	Mon, 19 Oct 2026 13:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418349;
	bh=+6bWQl08vPlK9YvTDXELQKN70ZC2RyYIL3pE6RXTwm0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V3mrAqjxNg79QaAFhEnSuwOkgPLNCGlzlyez8UmBhINIirU+4j6MG2QUhuStTy0Il
	 pteG3/xnkt5PbvmAO2wNajmVqQWwrBJAA1VKGf0pWYDRFvnVC2L8UWBJz8/eLuLfcp
	 KiJXqSKpQUYUrNxGB+Uqo8tnbUYwd/Ivw2VwnB//0hAKYDJE4+VwOgr+6karwNEzeP
	 2Ey9b0d85FYy0ndOioZHO5T7VxS2K0Vm7XMsS7japQSZqcn0B1gGtYNeJdspmQi+4i
	 CfS63KSZfPcDWBpsw/EGWcJtpYmOgh3a2d3CVDU1eKrQLnzz9emVSusGKI10xMPxTu
	 jEnZtEXMf5AFw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Breno Leitao <leitao@debian.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	davem@davemloft.net,
	edumazet@kernel.org,
	pabeni@redhat.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] netpoll: do not warn when the best-effort pool refill fails
Date: Mon, 19 Oct 2026 09:47:55 -0400
Message-ID: <20261019135441.1420968-184-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261019135441.1420968-1-sashal@kernel.org>
References: <20261019135441.1420968-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.57
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Breno Leitao <leitao@debian.org>

[ Upstream commit 84c0ff1efb62b0053aa265b8deb13842f68f1a74 ]

refill_skbs() tops up the per-netpoll skb pool with GFP_ATOMIC and
simply stops on the first allocation failure, leaving the pool partially
filled; a later refill tops it up once memory frees up. The allocation
failing is therefore an expected and fully handled condition, but
without __GFP_NOWARN the page allocator emits a warn_alloc() splat with
a full stack trace on every miss.

Pass __GFP_NOWARN so the best-effort refill stays quiet, mirroring the
same change in netconsole's find_skb().

Signed-off-by: Breno Leitao <leitao@debian.org>
Link: https://patch.msgid.link/20260629-netpoll_no_warn-v1-2-f380f0b2cd0c@debian.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **6.18.y** (`v6.18.53`). At that tag, `refill_skbs()`
still allocates with plain `GFP_ATOMIC`, so the bug exists here. This is
a one-line `__GFP_NOWARN` change on a best-effort refill that already
treats allocation failure as success-with-partial-fill.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

Step 1.1: PARSE THE SUBJECT LINE
Record: **[netpoll] [do not warn] [silence warn_alloc on expected
GFP_ATOMIC skb-pool refill failure]**

Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
Record:
- **Fixes:** none (expected for this review pipeline)
- **Reported-by / Tested-by / Reviewed-by / Acked-by / Cc: stable:**
  none
- **Link:** https://patch.msgid.link/20260629-netpoll_no_warn-v1-2-
  f380f0b2cd0c@debian.org (netdev series, patch 2/2)
- **Signed-off-by:** Breno Leitao (author; NETCONSOLE maintainer); Jakub
  Kicinski (netdev maintainer)
- Ignored pipeline tags: `[Upstream commit 84c0ff1efb62…]`, `Signed-off-
  by: Sasha Levin`

Step 1.3: ANALYZE THE COMMIT BODY TEXT
Record:
- **Bug:** `refill_skbs()` tops up a per-netpoll pool of 32 skbs with
  `GFP_ATOMIC`. Failure is expected: the loop `break`s, leaving a
  partial pool, and a later refill tries again.
- **Symptom:** without `__GFP_NOWARN`, the page allocator still fires
  `warn_alloc()` (`pr_warn` + `dump_stack()` + `__show_mem()`), a large
  splat on every miss.
- **Root cause:** best-effort allocation used a GFP mask that still
  warns.
- **Version info:** none in the commit text. Author date 2026-06-29;
  merged to net-next 2026-06-30.
- Cover letter (series 0/2, verified in the mbox): this class of splat
  was seen on the **Meta fleet**. `warn_alloc` emits 100+ printk lines
  which then go out through netconsole, **consuming the scarce skb
  pool** and crowding out the real diagnostic. Stack in the cover letter
  is the send path (`__alloc_skb` → `send_udp` → `netconsole_write` →
  `nbcon_kthread_func`), i.e. the sibling `find_skb()` site; this commit
  is the matching refill-path silence.

Step 1.4: DETECT HIDDEN BUG FIXES
Record: Not a disguised cleanup. It is explicitly a warning-suppression
for an expected, already-handled allocation failure. The functional
extra is that those warnings themselves eat the emergency pool they
exist to protect.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

Step 2.1: INVENTORY THE CHANGES
Record:
- **File:** `net/core/netpoll.c` — 1 insertion, 1 deletion
- **Function:** `refill_skbs()`
- **Scope:** single-file surgical one-liner

Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
Record:
- **Before:** `alloc_skb(MAX_SKB_SIZE, GFP_ATOMIC)`; on NULL, `break`
  (partial fill).
- **After:** same, with `GFP_ATOMIC | __GFP_NOWARN`.
- Path: best-effort refill from `__netpoll_setup()` and from
  `refill_skbs_work_handler()` (workqueue scheduled when `find_skb()`
  dequeues from the pool). Not a new error path; allocation behavior is
  unchanged.

Step 2.3: IDENTIFY THE BUG MECHANISM
Record:
- **Category:** logic/correctness of GFP flags (expected GFP_ATOMIC
  failure must not warn). Secondary effect: resource starvation of the
  32-skb emergency pool via printk/netconsole.
- **Mechanism:** `warn_alloc()` in `mm/page_alloc.c` returns immediately
  if `__GFP_NOWARN` is set; otherwise it rate-limits to 1/10s but still
  dumps stack + meminfo. Those printks are exactly what the pool is
  supposed to carry under OOM.

Step 2.4: ASSESS THE FIX QUALITY
Record:
- Obviously correct: `__GFP_NOWARN` is the established pattern for best-
  effort `GFP_ATOMIC` (many net/ core users already do this).
- Minimal: one GFP flag bit.
- **Regression risk: very low.** Allocation success/failure, pool
  length, locking, and refill scheduling are unchanged. `warn_alloc`
  does **not** use `WARN_ON` / `panic_on_warn` (verified: it is
  `pr_warn` + `dump_stack` + `warn_alloc_show_mem`).
- Red flags: none on this hunk. Series was `[PATCH net-next 2/2]` (not
  `net`), which is a process signal, not a code risk.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

Step 3.1: BLAME THE CHANGED LINES
Record:
- `alloc_skb(..., GFP_ATOMIC)` in this refill loop dates to
  **`1da177e4c3f41` (Linux-2.6.12-rc2)** — present for the entire git
  history.
- Per-target pool: `221a9c1df790fa` (“Individualize the skb pool”,
  2024-11-14) — **in v6.18.53**.
- Refill moved off the spinlock: `327c20c21d80e0` (“Fix deadlock in
  memory allocation under spinlock”, 2025-11-03, Fixes:
  `248f6571fd4c51`) — **in v6.18.53**. That commit even notes `printk`
  from OOM-in-refill can re-enter netpoll; after it, allocation is
  outside the lock, so this NOWARN change does not fight a deadlock, it
  only stops the splat.

Step 3.2: FOLLOW THE FIXES: TAG
Record: No `Fixes:` tag. Not applicable. The GFP_ATOMIC refill is
original netpoll behavior, not a recent regression.

Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Record (on `v6.18.53`, `-- net/core/netpoll.c`):
- Recent real fixes already in this tree: UAF on shutdown, IPv6 local-
  address corruption, MAC truncation, workqueue init order, refcount
  cleanup, the refill deadlock fix.
- **This NOWARN change is not in v6.18.53.**
- Standalone vs series: **patch 2/2**. Sibling 1/2 is `09f7a613a14fd`
  “netconsole: do not warn when the best-effort skb allocation fails”
  (touches `drivers/net/netconsole.c` `find_skb()` **after** that
  function was moved out of netpoll). No code dependency between the two
  hunks.

Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Record: Breno Leitao is listed as **NETCONSOLE** maintainer in
`MAINTAINERS`. He authored the per-target pool and the refill-deadlock
fix. High-confidence author for this code.

Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
Record:
- Needs the existing `refill_skbs()` + `skb_pool` (present since 2.6 /
  individualized in 6.18).
- Does **not** need patch 1/2 to compile or run.
- Cover letter mentioned “reschedule the workqueue to try later”; **that
  was not in either committed patch**. Current code already
  `schedule_work(&np->refill_wq)` from `find_skb()` on pool dequeue. No
  missing follow-up required for this hunk.
- **Standalone; can apply on this tree.**

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
Record:
- `b4 dig -c 84c0ff1efb62b`: https://patch.msgid.link/20260629-
  netpoll_no_warn-v1-2-f380f0b2cd0c@debian.org
- `b4 dig -a`: **v1 only** (no v2/v3).
- Mbox (`/tmp/netpoll-nowarn.mbox`): cover letter + 1/2 + 2/2 +
  patchwork “applied to netdev/net-next.git” by Jakub Kicinski. **No
  NAK, no reviewer comments, no Cc: stable in the thread.**
- Submitted as **`[PATCH net-next]`**, not `net`. Merged immediately (29
  Jun → applied 1 Jul 2026).

Step 4.2: CHECK WHO REVIEWED THE PATCH
Record (`b4 dig -w`): To/Cc netdev maintainers (Kicinski, Dumazet,
Miller, Abeni, Horman, Lunn), `netdev@`, `linux-kernel@`, `kernel-
team@meta.com`. No extra Reviewed-by on the git commit; maintainer merge
is the review signal.

Step 4.3: SEARCH FOR THE BUG REPORT
Record: No bugzilla/syzbot. Evidence is the cover letter: Meta fleet,
`page allocation failure: order:0, mode:0x40820(GFP_ATOMIC|__GFP_COMP)`,
stack through netconsole send. That stack is the **`find_skb`/send_udp**
site, not `refill_skbs` itself.

Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
Record: Two independent one-liners. In **this** 6.18 tree, `find_skb()`
is still in `net/core/netpoll.c:279` (`alloc_skb(len, GFP_ATOMIC)`
without NOWARN). Patch 1/2 would not apply as written (wrong file). This
2/2 patch does not fix that hot path; it only silences the async refill.

Step 4.5: CHECK STABLE MAILING LIST HISTORY
Record: **UNVERIFIED** — `lore.kernel.org/stable/` and WebFetch both
returned 403.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
Record: `refill_skbs()` only.

Step 5.2: TRACE CALLERS
Record (verified in this tree):
- `refill_skbs_work_handler()` → process-context workqueue, scheduled
  from `find_skb()` after `skb_dequeue(&np->skb_pool)`.
- `__netpoll_setup()` → setup/open path (netconsole `netpoll_setup()`,
  plus bond/team/macvlan/vlan/bridge/dsa netpoll setup).

Step 5.3: TRACE CALLEES
Record: `alloc_skb()` → `skb_queue_tail()`. On failure, `break`. No new
locks, frees, or I/O.

Step 5.4: FOLLOW THE CALL CHAIN
Record:
- User-reachable via **netconsole** (module/`netconsole=`), kgdb-style
  netpoll users, and stacked devices’ `ndo_netpoll_setup`.
- Typical trigger: memory pressure while netconsole is logging →
  `find_skb()` falls back to the pool → `schedule_work(refill_wq)` →
  `refill_skbs()` `GFP_ATOMIC` fails → `warn_alloc` splat → those lines
  go through netconsole again.
- Unprivileged userspace cannot generally fire this unless netconsole is
  enabled; operators enable it for crash/OOM debugging — exactly when
  GFP_ATOMIC fails.

Step 5.5: SEARCH FOR SIMILAR PATTERNS
Record: Hot-path twin still present here: `find_skb()` at
`net/core/netpoll.c:279`. Same GFP_ATOMIC-without-NOWARN. Many other
net/ callers already use `GFP_ATOMIC | __GFP_NOWARN`.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
Record: **Yes.** `git describe HEAD` → `v6.18.53-5049-g0f0bdc2b0dffb`;
`make kernelversion` → **6.18.53**.
At `v6.18.53:net/core/netpoll.c`:
```
skb = alloc_skb(MAX_SKB_SIZE, GFP_ATOMIC);
```
`git merge-base --is-ancestor 84c0ff1efb62b v6.18.53` → **not in
v6.18.53**.

Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
Record: `git show 84c0ff1efb62b -- net/core/netpoll.c | git apply
--check` on **v6.18.53** → **CLEAN_APPLY**. Surrounding `refill_skbs()`
matches. No refactor needed.

Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
Record: No NOWARN/`best-effort` commits on these files in `v6.18.53`
history. Deadlock fix is already here and complementary, not a
substitute.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
Record: **net/core netpoll** used by netconsole and stacked netdevs.
**IMPORTANT** (not core mm/scheduler; not obscure staging). Netconsole
is the production debug path for machines that cannot use a serial
console.

Step 7.2: ASSESS SUBSYSTEM ACTIVITY
Record: Actively maintained by Breno; several 6.18-era netpoll fixes
already in this tree. Mature mechanism (skb pool since 2.6).

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

Step 8.1: DETERMINE WHO IS AFFECTED
Record: **Config/driver-specific** — `CONFIG_NETPOLL` / netconsole /
bonding/team/vlan/macvlan/bridge/dsa netpoll. Not universal, but
netconsole is widely used in production fleets (explicit Meta report).

Step 8.2: DETERMINE THE TRIGGER CONDITIONS
Record: GFP_ATOMIC miss while the pool is not full — setup under
pressure, or workqueue refill after the pool was used. Common under
OOM/memory pressure with netconsole on. Not a userspace-exploitable
crash.

Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
Record:
- Direct: `warn_alloc` log flood (stack + `show_mem`), rate-limited
  1/10s, **not** `panic_on_warn`.
- Indirect (the reason the pool exists: “make sure the message gets out
  even in extreme OOM”): splat printks consume the 32-skb pool and can
  hide the original incident.
- **Severity: HIGH for netconsole-under-OOM (lost emergency logs);
  otherwise MEDIUM log noise.** The refill path is the lesser of the two
  sites; the cover-letter stack is `find_skb`.

Step 8.4: CALCULATE RISK-BENEFIT RATIO
Record:
- **Benefit:** medium-high for netconsole users; stops expected refill
  failures from dumping meminfo into the emergency path.
- **Risk:** very low (one GFP bit).
- **Ratio:** favorable. Incomplete vs the hot-path sibling, but this
  hunk is still a correct, self-contained fix.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

Step 9.1: COMPILE THE EVIDENCE
**FOR:**
- Buggy `GFP_ATOMIC` refill is in this 6.18.53 tree and applies cleanly.
- Failure is already handled; the splat is wrong and can starve the
  32-skb OOM pool.
- Production class of bug documented (Meta fleet cover letter).
- 1 line, established `__GFP_NOWARN` pattern, maintainer-authored,
  merged by Kicinski.
- Zero change to allocation success/locking/API.

**AGAINST:**
- Sent to **net-next**, not `net`; no `Fixes:` / `Cc: stable` /
  Reviewed-by in the thread.
- Cover-letter stack is **`find_skb`/send_udp**, not `refill_skbs`. This
  tree still warns in `find_skb()`; backporting only 2/2 does not close
  the reported hot path.
- `warn_alloc` is rate-limited and does not panic.
- Not a crash/UAF/deadlock by itself.

**UNRESOLVED:** stable@ lore search (HTTP 403). Whether 6.18 netconsole
uses the same nbcon kthread as the 2026 stack (send path still is
`netconsole → netpoll_send_udp → find_skb` here).

Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. Obviously correct and tested? **PASS** — one GFP flag; merged to net-
   next; fleet report for the series.
2. Fixes a real bug that affects users? **PASS** — expected alloc
   failure must not dump; dump can eat the emergency pool.
3. Important issue (crash, security, corruption, deadlock)? **PASS**
   (narrow) — not a panic, but it undermines netpoll’s OOM delivery
   guarantee. That is the point of this subsystem.
4. Small and contained? **PASS** — 1 line, one function.
5. No new features or APIs? **PASS**.
6. Can apply to the local tree? **PASS** — clean on v6.18.53.

Step 9.3: CHECK FOR EXCEPTION CATEGORIES
Record: None (not an ID/quirk/DT/build/docs add). Ordinary small bugfix.

Step 9.4: MAKE YOUR DECISION
Backport. The local 6.18.y tree has the buggy refill; the patch is a
zero-risk one-liner that stops an expected GFP_ATOMIC miss from
generating a huge `warn_alloc` that can drain the netconsole skb pool.
The hotter sibling (`find_skb` in `net/core/netpoll.c` on this tree) is
a separate candidate and is not required for this hunk to be correct.

What it solves for stable users: under memory pressure with
netconsole/netpoll, pool refill already gives up on the first
`alloc_skb` failure. Today that still prints `warn_alloc` (stack +
meminfo). Those lines compete for the 32 preallocated skbs that exist
specifically so messages still get out in OOM. Adding `__GFP_NOWARN`
leaves refill semantics identical and keeps that path quiet.

Risk vs benefit: benefit is real for netconsole fleets; risk is
negligible. The only caveat is that this does not silence `find_skb()`
on 6.18 (still `GFP_ATOMIC` without NOWARN); that does not make this
commit wrong or unsafe.

===============================================================
Verification:
===============================================================
- [Phase 1] Parsed tags: Link to msgid `…v1-2…`; SOBs Breno + Kicinski;
  no Fixes/Reported-by/Cc:stable
- [Phase 1] Cover letter from mbox: Meta fleet, 100+ line splat
  consuming skb pool
- [Phase 2] Diff: 1 line `GFP_ATOMIC` → `GFP_ATOMIC | __GFP_NOWARN` in
  `refill_skbs()`
- [Phase 2] `warn_alloc()` confirmed: respects `__GFP_NOWARN`;
  `pr_warn`+`dump_stack`+`__show_mem`; ratelimit 1/10s; not
  `panic_on_warn`
- [Phase 3] Blame: GFP_ATOMIC refill since `1da177e4c3f41` (2.6.12-rc2);
  individualize `221a9c1df790fa` in 6.18.53; deadlock fix
  `327c20c21d80e0` in 6.18.53
- [Phase 3] `git merge-base --is-ancestor 84c0ff1efb62b v6.18.53` → not
  present
- [Phase 3] Series sibling `09f7a613a14fd` is netconsole `find_skb`
  post-move; not a compile dependency
- [Phase 4] `b4 dig -c 84c0ff1efb62b`: lore msgid; v1 only; applied to
  net-next; no NAK
- [Phase 4] Recipients: netdev maintainers + kernel-team@meta.com
- [Phase 4] UNVERIFIED: stable@ mailing list (HTTP 403)
- [Phase 5] Callers: `__netpoll_setup()` and
  `refill_skbs_work_handler()`; `find_skb()` still `GFP_ATOMIC` at line
  279 in this tree
- [Phase 5] `MAX_SKBS` is 32; comment documents OOM pool purpose
- [Phase 6] `git describe HEAD` / `make kernelversion`: 6.18.53; buggy
  line present at v6.18.53; `git apply --check` on v6.18.53: CLEAN_APPLY
- [Phase 7] Breno is NETCONSOLE maintainer
- [Phase 8] Failure mode: warn_alloc noise + emergency pool depletion
  under OOM, not a kernel oops
- UNVERIFIED: whether 6.18 netconsole uses nbcon kthread identically to
  the 2026 cover-letter stack (send path is still `netpoll_send_udp` →
  `find_skb` here)

**YES**

 net/core/netpoll.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/netpoll.c b/net/core/netpoll.c
index 9ef344a6932f9..a22de992c8024 100644
--- a/net/core/netpoll.c
+++ b/net/core/netpoll.c
@@ -232,7 +232,7 @@ static void refill_skbs(struct netpoll *np)
 	skb_pool = &np->skb_pool;
 
 	while (READ_ONCE(skb_pool->qlen) < MAX_SKBS) {
-		skb = alloc_skb(MAX_SKB_SIZE, GFP_ATOMIC);
+		skb = alloc_skb(MAX_SKB_SIZE, GFP_ATOMIC | __GFP_NOWARN);
 		if (!skb)
 			break;
 
-- 
2.53.0

