Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 760335E215C;
	Mon, 19 Oct 2026 14:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418549; cv=none; b=gZzFJYJr0E72p5rlArC4lT/PZouZhx0JvJPyI854h0U74bIUfG9G0lLaACibK+SvCtIRBSJ76r4UhZYPGCkLemf4IwmuSk82MhGHLiA3ZhrOeCluyozILMxQhaE9lhhsZqipl57Wvbyxxqdhl6D0rSeuOLALQ9A80nQZ3KZ4K4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418549; c=relaxed/simple;
	bh=vKtA7JRfO70+rdfogeVXY2fLuLw5H3B9c4LIWICzq5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WIDFCQ+hM7MdUQ/0LU31F98PGhBgD2XMZNFiJ1ZuEph8OdCtL3zbPrsNHbBcBuj9a2qJhiiBgB74061WRcdnuBlWTqQafexNOUzkTSVfJCWZk3x0gMH3NwSaIOHv5Sjad5OZZC98yl75evh0Jl8Yb2L5K6WWRpKgSepoXfEY8Sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Bu5ppNYx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Bu5ppNYx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EFC71F000C7;
	Mon, 19 Oct 2026 14:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418546;
	bh=2Yx0E8RRn1cWZ8BEo/BfdquUwBZonkPGH7EBNzQe+3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bu5ppNYxaPrOn1juxuqzMmeSqr9139wHh3FM2FajtVrqMm9p+stSmWZAC69E2+HyQ
	 pFsNcahAQ92BPqnm+8Q1e+PeOyRgfFHZHJS9/TDyimUbN+1Ro71QiPOvlfZh9EmUYy
	 i5OF56Q8k9/sunOsp/MrEJV60I+eWSeLp0rcYDFfT/gjqGG6wEtuu+dtfl9UfXQPRI
	 P77iRcPNH6YyJ3E8c5eD53ggXL8BEkgjdQtrP9OvwPVWUVGvHkUjuOtNaRIHH6BBhB
	 8QhvwrjfF7wXIRmVtgOlUNO8I/cNJAFe9HlvJDBBrDZcmpxGR3vSUMhABi9gYjgUL5
	 V65MkBZX9swaA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Andreas Kemnade <andreas@kemnade.info>,
	sashiko-bot@kernel.org,
	Helge Deller <deller@gmx.de>,
	Sasha Levin <sashal@kernel.org>,
	linux-omap@vger.kernel.org,
	linux-fbdev@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] fbdev: omap2: dsi: do not copy isr table
Date: Mon, 19 Oct 2026 09:50:16 -0400
Message-ID: <20261019135441.1420968-325-sashal@kernel.org>
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

From: Andreas Kemnade <andreas@kemnade.info>

[ Upstream commit 31875c51c31edec57b3620f278680c23a823763b ]

To te able to unregister stuff from isrs, the corresponding table was
copied.  Nobody seems to unregister stuff that way, so it does not help.
But there are stack-allocated objects passed to these isrs giving chances
of UAF of these objects if irqs are unregistered while they are handled,
so better do not copy that table.

Suggested-by: sashiko-bot@kernel.org
Signed-off-by: Andreas Kemnade <andreas@kemnade.info>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This is a UAF fix in the OMAP2 fbdev DSI IRQ path. The same change is
already in this 6.12 tree for the DRM copy of the driver; the fbdev copy
of the bug is still present.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**
Record: `[fbdev/omap2/dsi] [do not copy] [stop copying the DSI ISR table
before invoking handlers]`

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- `Suggested-by: sashiko-bot@kernel.org` (static-analysis bot; this is
  the original trigger, not a user crash report)
- `Signed-off-by: Andreas Kemnade <andreas@kemnade.info>` (author)
- `Signed-off-by: Helge Deller <deller@gmx.de>` (fbdev maintainer)
- No `Fixes:` tag (expected for this review queue)
- No `Cc: stable@vger.kernel.org`
- No `Reported-by:`, `Tested-by:`, `Reviewed-by:`, or `Link:`
- Ignore `Signed-off-by: Sasha Levin` / `[Upstream commit ...]` if
  present in candidate packaging; they are not part of the technical
  decision

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- Bug: ISR table was memcpy’d so handlers could unregister themselves,
  then the copy was walked after dropping `irq_lock`.
- Author claim: nothing unregisters from ISR context, so the copy is
  unused for its stated purpose.
- Failure mode: stack-allocated objects (`DECLARE_COMPLETION_ONSTACK`,
  `dsi_packet_sent_handler_data` on stack) are passed as ISR `arg`. If
  unregister/return happens while the IRQ handler still walks the copy,
  those objects are used after free.
- No kernel-version range in the message.
- Root cause: lockless copy of function+arg pointers that alias stack
  objects.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not a disguised cleanup. It is explicitly a UAF/race fix, even
though the subject does not say “fix”.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**
Record:
- File: `drivers/video/fbdev/omap2/omapfb/dss/dsi.c` (+1 / −8; 9 lines)
- Removes `struct dsi_isr_tables isr_tables_copy` from `struct dsi_data`
- In `omap_dsi_irq_handler()`: drop `memcpy`, call `dsi_handle_isrs()`
  on the live table **while `irq_lock` is held**, then unlock
- Scope: single-file surgical fix

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:
- Before: lock → read/ack IRQ status → memcpy table → unlock →
  `dsi_handle_isrs(&copy)` → error/stats
- After: lock → read/ack IRQ status → `dsi_handle_isrs(&live table)` →
  unlock → error/stats
- Affected path: hardirq handler (`devm_request_irq(...,
  omap_dsi_irq_handler, IRQF_SHARED, ...)`)
- Unregister (`dsi_unregister_isr*`) takes `irq_lock`, so it now waits
  until handlers finish

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record:
- Category: use-after-free / race (memory safety)
- Mechanism: copy of ISR `arg` pointers outlives unregister of stack-
  allocated completions
- Verified stack objects passed into ISRs in this tree:
  - `dsi_sync_vc_vp()` / `dsi_sync_vc_l4()`:
    `DECLARE_COMPLETION_ONSTACK` + stack `dsi_packet_sent_handler_data`
  - `dsi_vc_send_bta_sync()`: stack completion registered on **two**
    tables (global + VC)
  - `dsi_enter_ulps()`: stack completion registered on CIO table
- Concrete UAF in `dsi_vc_send_bta_sync()`: `dsi_handle_isrs()` walks
  global table then VC table. First handler can `complete()`; waiter
  unregisters and returns; second handler still runs against the copy
  with a dangling stack pointer.
- Fix: keep `irq_lock` across handler dispatch so unregister cannot
  destroy the objects until handlers return.

**Step 2.4: ASSESS THE FIX QUALITY**
Record:
- Obviously correct given the locking: unregister cannot proceed while
  handlers run.
- Minimal; no API change.
- Regression risk is low **if** no ISR unregisters itself (would
  deadlock on `irq_lock`). Verified all three callbacks
  (`dsi_completion_handler`, `dsi_packet_sent_handler_vp`,
  `dsi_packet_sent_handler_l4`) only `complete()` and/or read registers.
  None call `dsi_unregister_isr*`.
- `complete()` under a spinlock is valid.
- Holding the lock slightly longer in hardirq is register reads +
  `complete()`, not a sleep.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**
Record:
- Copy logic and `isr_tables_copy` blamed to `f76ee892a99e6` (“omapfb:
  copy omapdss & displays for omapfb”, 2015-12-29).
- Pattern is as old as the fbdev DSS copy in this tree; originally
  inherited from OMAP DSS ISR support.
- Long-lived bug, not recent code.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No `Fixes:` on the fbdev commit. The sibling DRM fix
`2c27a84ba8d1b` (`drm/omap: dsi: Do not copy isr table`) has `Fixes:
4ae2ddddf44cd ("OMAP: DSS2: DSI: Add ISR support")`. That original ISR
support is what fbdev copied.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record:
- Recent `dsi.c` changes in this tree are unrelated (platform remove,
  of_graph, timer, pm_runtime).
- Standalone; not patch N/M.
- Cover letter on lore points at a DRM twin:
  `https://lore.kernel.org/lkml/20260702-dsi-
  uaf-v2-1-dbb4aa0f0b8e@kemnade.info/`
- That DRM twin **is already in this tree** as `2c27a84ba8d1b`
  (contained in `v6.12.110~477`).

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record:
- Andreas Kemnade is an OMAP/display contributor; same author wrote the
  DRM twin.
- Helge Deller (fbdev maintainer) applied the fbdev patch.
- Tomi Valkeinen applied the DRM twin.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record:
- No new functions/types.
- Applies as a logic change on existing `omap_dsi_irq_handler` / `struct
  dsi_data`.
- Context mismatch only: mainline hunk context has `timer_delete()`;
  this tree still has `del_timer()` (`8fa7292fee5c5` timer rename is not
  in 6.12). Not a functional dependency.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 dig -c 31875c51c31ed`: https://patch.msgid.link/20260702-fbomap-
  uaf-fix-v1-1-6417edf9d3e7@kemnade.info
- `b4 dig -a`: single revision **v1** only; that version was applied.
- Thread: author patch → sashiko-bot review → author reply → Helge
  Deller “applied.”
- No NAK. Deller accepted it.
- Bot comments were about **pre-existing sibling bugs** (DRM DSI, DISPC
  copy, unbind timers), not about this change being wrong.
- Author noted the DRM variant in the patch footer.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record (`b4 dig -w`):
- To: Helge Deller
- Cc: linux-omap, linux-fbdev, dri-devel, linux-kernel, sashiko-bot
- Appropriate lists; fbdev maintainer applied it.
- No human Reviewed-by besides maintainer application.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record:
- No syzbot/bugzilla user report. Trigger is sashiko-bot static
  analysis.
- Bug is still real: code in this tree matches the described UAF (stack
  completions + lockless copy).

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record:
- DRM twin already backported here (`2c27a84ba8d1b`).
- fbdev DISPC still copies a stack `registered_isr` in `dispc-compat.c`
  (`omap_dispc_irq_handler`); same pattern, **separate** file, not
  required for this DSI patch to be correct.
- No revert of either DSI fix on `origin/master`.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: UNVERIFIED. `lore.kernel.org/stable/` and lore message URLs
returned HTTP 403. Thread was recovered via `b4 dig -m` instead. No
stable-list discussion could be fetched.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**
Record: `omap_dsi_irq_handler()`; field removed from `struct dsi_data`.
Callers of `dsi_handle_isrs()` / `dsi_call_isrs()` unchanged except the
table pointer and lock scope.

**Step 5.2: TRACE CALLERS**
Record:
- `omap_dsi_irq_handler` ← `devm_request_irq` in DSI bind/probe (`dsi.c`
  ~5363). Hardirq, `IRQF_SHARED`.
- Register/unregister sites are process context, all take `irq_lock`.
- Sync/BTA/ULPS paths used during DSI frame update, command write, and
  ULPS enter (`dsi_sync_vc` from update/disable; `dsi_vc_send_bta_sync`
  as `.bta_sync`; `dsi_enter_ulps`).

**Step 5.3: TRACE CALLEES**
Record: `dsi_handle_isrs` → `dsi_call_isrs` → registered `isr(arg,
status)` → `complete()` / `REG_GET`. Then `dsi_handle_irq_errors` and
`dsi_collect_irq_stats` still after unlock.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: Reachable from normal display I/O on `CONFIG_FB_OMAP2=y` +
`CONFIG_FB_OMAP2_DSS_DSI=y` (MIPI DSI panel). Not a syscall fuzzer path,
but a real device IRQ + wait-for-completion path. Unprivileged userspace
can trigger it by updating the framebuffer on such hardware.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record:
- DRM `drivers/gpu/drm/omapdrm/dss/dsi.c` in **this tree** already calls
  `dsi_handle_isrs(&dsi->isr_tables, ...)` under `irq_lock` (the
  backported twin).
- fbdev `dispc-compat.c` still memcpy’s ISRs then drops the lock;
  leftover sibling, not a blocker for this patch.
- `isr_tables_copy` exists only in this fbdev `dsi.c` in this checkout.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record:
- `git describe HEAD`: `p-6.12-3-gc504cf0baa3d8`
- `make kernelversion` / Makefile: **6.12.111**
- `git merge-base --is-ancestor 31875c51c31ed HEAD` → not an ancestor
  (fix not in this tree)
- Buggy code present: `isr_tables_copy` at `dsi.c:330`, memcpy at
  `dsi.c:841-848`
- Introduced here via `f76ee892a99e6` (v4.5-era copy)

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record:
- `git apply --check` of `31875c51c31ed` fails only because context has
  `timer_delete` vs local `del_timer`.
- The two functional hunks (remove field; move `dsi_handle_isrs` before
  unlock) match this tree byte-for-byte aside from that nearby timer
  name.
- Expected difficulty: **minor context tweak**, not rework.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record:
- DRM equivalent already applied (`2c27a84ba8d1b`).
- No fbdev DSI equivalent. `FB_OMAP2` depends on `DRM_OMAP=n`, so omapfb
  users do **not** get the DRM fix.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: `drivers/video/fbdev/omap2` — SoC display driver. Criticality:
**PERIPHERAL** (OMAP2+ boards using legacy fbdev, not omapdrm). Still
in-tree and user-facing on that hardware.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: Mature/legacy. Low churn; bug has been present since the 2015
omapdss copy. Maintainer (Deller) still takes fixes.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: Driver-specific / config-specific: `CONFIG_FB_OMAP2` +
`CONFIG_FB_OMAP2_DSS_DSI` on OMAP2+ with MIPI DSI, and only when DRM
omap is disabled.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record:
- Trigger: DSI IRQ concurrent with unregister of a stack-backed ISR
  after `complete()` or timeout (`dsi_sync_vc_*` 10 ms, BTA 500 ms, ULPS
  1000 ms).
- Dual-ISR BTA path is the most realistic (two handlers, one stack
  object).
- Unprivileged userspace can drive framebuffer updates that hit
  `dsi_sync_vc`.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record: Use-after-free of stack completions / handler-data → kernel oops
or memory corruption in hardirq. Severity: **HIGH**.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record:
- Benefit: HIGH for omapfb+DSI users (prevents UAF in IRQ). Population
  is small, but the DRM twin was already taken into this same 6.12.y
  tree, which shows the bug class is treated as stable-worthy.
- Risk: LOW (9 lines, verified no self-unregister, `complete()` under
  spinlock is fine).
- Ratio: benefit outweighs risk.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Real UAF: lockless copy of pointers to `DECLARE_COMPLETION_ONSTACK`
  objects
- Dual-ISR BTA path makes the race practical, not only a 1-instruction
  window
- Small, obviously correct lock-scope change
- All ISR callbacks verified not to unregister (no self-deadlock)
- Code exists in this 6.12.111 tree; bug dates to 2015 copy
- fbdev maintainer applied v1 with no NAK
- Identical DRM fix already in this tree; omapfb users are the leftover
  affected set

AGAINST:
- No user `Reported-by` / syzbot (bot-found)
- Peripheral OMAP fbdev DSI, not a core path
- Vanilla patch needs a one-line context adjust (`del_timer`)
- DISPC has a similar leftover pattern (out of scope for this commit)

UNRESOLVED:
- Could not query lore.kernel.org/stable (HTTP 403)
- No runtime reproduction in this session (analysis is from code +
  thread)

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — lock documents the intent;
   maintainer applied; DRM twin already on 6.12.y
2. Fixes a real bug that affects users? **PASS** — UAF on DSI IRQ vs
   stack completions
3. Important issue? **PASS** — UAF / oops / memory corruption (HIGH)
4. Small and contained? **PASS** — 9 lines, one file
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — functional diff matches;
   trivial `del_timer` context

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: Not an ID/quirk/DT/build/docs exception. It is a normal memory-
safety bugfix.

**Step 9.4: MAKE YOUR DECISION**
This should be backported to **this** 6.12.y tree. The buggy
`isr_tables_copy` path is here; the fix is the same one already taken
for omapdrm; omapfb is a separate config and still needs it.

Verification:
- [Phase 1] Tags: Suggested-by sashiko-bot; SOB Kemnade + Deller; no
  Fixes/Cc stable/Reported-by
- [Phase 2] Diff: remove `isr_tables_copy`; call
  `dsi_handle_isrs(&dsi->isr_tables)` before `spin_unlock`
- [Phase 2] Confirmed stack completions at dsi.c:2298, 2347, 2617, 3115
- [Phase 2] Confirmed ISR callbacks only complete/read MMIO; no
  unregister
- [Phase 3] Blame: f76ee892a99e6 (2015); ancestor check of 31875c51c31ed
  vs HEAD: not present
- [Phase 3] DRM twin 2c27a84ba8d1b is in this tree (`git merge-base
  --is-ancestor` exit 0; `v6.12.110~477`)
- [Phase 4] b4 dig: lore msgid 20260702-fbomap-uaf-
  fix-v1-1-6417edf9d3e7@kemnade.info; v1 only; Deller “applied.”
- [Phase 4] UNVERIFIED: stable@ lore search (HTTP 403)
- [Phase 5] Handler installed via `devm_request_irq` + `IRQF_SHARED`;
  sync/BTA/ULPS are the users
- [Phase 6] Local tree 6.12.111; buggy memcpy still at dsi.c:841-848;
  apply --check fails only on `timer_delete` vs `del_timer`
- [Phase 7] Peripheral fbdev OMAP DSI; mutually exclusive with DRM_OMAP
- [Phase 8] Failure mode: hardirq UAF of stack object, severity HIGH

The patch is a small UAF fix that already exists for the DRM clone in
this tree, applies with a trivial context tweak, and matches stable
rules.

**YES**

 drivers/video/fbdev/omap2/omapfb/dss/dsi.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/video/fbdev/omap2/omapfb/dss/dsi.c b/drivers/video/fbdev/omap2/omapfb/dss/dsi.c
index 370e8623754ec..b1df2c014b00c 100644
--- a/drivers/video/fbdev/omap2/omapfb/dss/dsi.c
+++ b/drivers/video/fbdev/omap2/omapfb/dss/dsi.c
@@ -326,8 +326,6 @@ struct dsi_data {
 
 	spinlock_t irq_lock;
 	struct dsi_isr_tables isr_tables;
-	/* space for a copy used by the interrupt handler */
-	struct dsi_isr_tables isr_tables_copy;
 
 	int update_channel;
 #ifdef DSI_PERF_MEASURE
@@ -838,15 +836,10 @@ static irqreturn_t omap_dsi_irq_handler(int irq, void *arg)
 		timer_delete(&dsi->te_timer);
 #endif
 
-	/* make a copy and unlock, so that isrs can unregister
-	 * themselves */
-	memcpy(&dsi->isr_tables_copy, &dsi->isr_tables,
-		sizeof(dsi->isr_tables));
 
+	dsi_handle_isrs(&dsi->isr_tables, irqstatus, vcstatus, ciostatus);
 	spin_unlock(&dsi->irq_lock);
 
-	dsi_handle_isrs(&dsi->isr_tables_copy, irqstatus, vcstatus, ciostatus);
-
 	dsi_handle_irq_errors(dsidev, irqstatus, vcstatus, ciostatus);
 
 	dsi_collect_irq_stats(dsidev, irqstatus, vcstatus, ciostatus);
-- 
2.53.0

