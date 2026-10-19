Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07B865AA66D;
	Mon, 19 Oct 2026 13:55:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418146; cv=none; b=ry1Mp4l2WqtRUu1PRQtMcaMcFXK7k8w5sexbu8sutj3mJvaGrYBshFkUwfqpP+hR9OrRvTUaXgJdLKgQgQ9ql+W9RhtgZkAR4wkgUudz9fwg0fdw59e0aoV5/OGvVKHQtCNWPb4XYsutcjzn77rMjYodV11h7l8Bl/7Rs1debtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418146; c=relaxed/simple;
	bh=gbk/+8ZvngxK2FY2q/j6180/hh0yY7VYGT2agXx8PXM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=t//k7sIwtskI4/eK6oD1Tjc49eygssRJeAk0V0DGMz7xn6JTSm3M7LFCmxLcklApKtjGG3bTvSSX5AaPVHf0UIX1yx/2ld/0VHl+qSIYNCAef9cNCZn1Djx2ZrSxYXKb+68g3f1rzdS2jz0sWCS7/kbMemNg67dh1ybF6LzlxLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o1Zaubbv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o1Zaubbv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C75EB1F000C5;
	Mon, 19 Oct 2026 13:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418143;
	bh=+4QqVSq5EJGOolgMlm1wGlt1n7CtvHBteLbcpkGvwb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o1ZaubbvhE+AZE71qzPW3E+qpe9NZzJoK/1I5dmDcm2QNYrRfylZuX2A1+aPtGkxf
	 wlXs78zb5y4YYM9eBn15wW6R2CwQQ33rqaa+8+bOsKbZVNUa1iX4LjP7tdqnzIO2Ho
	 Lc1pDymNDRjzrMdKLxgHn/6J43g9AtuB3CxtwtxcQ5gv9IROrocvBD85CLSUWMP88v
	 GlGf7/P3rRkiKvK1rNtKla7WbkePKr6GMbQiZ3Lg1ptZxfSn9+juMbnZrrQLU7+3C8
	 1o7/DjVkNx+TA3Pd/B1wJqVOce2wJt5lAF1/nV12xcHtrboCIpXz++lCEK//DlELCx
	 SLOx8lFfVwfrw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Mark Brown <broonie@kernel.org>,
	Farhad Alemi <farhad.alemi@berkeley.edu>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	linux-kernel@vger.kernel.org,
	driver-core@lists.linux.dev
Subject: [PATCH AUTOSEL 6.18] regmap: irq: Free the irqdomain we create
Date: Mon, 19 Oct 2026 09:45:34 -0400
Message-ID: <20261019135441.1420968-43-sashal@kernel.org>
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

From: Mark Brown <broonie@kernel.org>

[ Upstream commit 2e42cade8ff1ff579e77976d9869db4df1feaf74 ]

When domain support was added to regmap-irq it was not possible to
remove domains, this was added later by 8ee99ada293b (irqdomain: Support
removal of IRQ domains.).  We did update the main removal path to free
the domain but forgot the error unwinding case during creation that is
now in regmap_add_irq_chip_fwnode() after some code motion, meaning that
errors during instantiation result in an unused irqchip being left
hanging around.  Add the missing irq_remove_domain() call where the
comment says it should be.

Reported-by: Farhad Alemi <farhad.alemi@berkeley.edu>
Reported-by: Thomas Gleixner <tglx@kernel.org>
Link: https://patch.msgid.link/20260901-regmap-irq-deallocate-domain-v1-1-4bfed4aff559@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **6.18.57**. At that base,
`regmap_add_irq_chip_fwnode()` still has the “Should really dispose of
the domain but...” stub, so the leak exists here and the one-line
`irq_domain_remove()` change applies cleanly.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**
Record: `[regmap: irq:] [Free] [Release the irqdomain created during
chip setup]`

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- `Reported-by: Farhad Alemi <farhad.alemi@berkeley.edu>` (researcher
  report)
- `Reported-by: Thomas Gleixner <tglx@kernel.org>` (irq subsystem
  maintainer)
- `Link: https://patch.msgid.link/20260901-regmap-irq-deallocate-
  domain-v1-1-4bfed4aff559@kernel.org`
- `Signed-off-by: Mark Brown <broonie@kernel.org>` (regmap maintainer;
  author)
- No `Fixes:` tag (expected)
- No `Cc: stable` (expected)
- Pipeline-added `[Upstream commit 2e42cade8ff1...]` and Sasha Levin SOB
  ignored per instructions
- Notable: two reporters, one of them tglx

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- Bug: when irqdomain support was added to regmap-irq, domains could not
  be removed. `irq_domain_remove()` was added later (`58ee99ada293b`;
  the message cites `8ee99ada293b`, missing the leading `5`). The
  success teardown path was updated; the **creation error-unwind** path
  was not.
- Symptom: failed instantiation leaves an unused irqchip/domain hanging
  around.
- Failure mode: resource leak of a published irq domain on
  `request_threaded_irq()` failure after `regmap_irq_create_domain()`.
- Root cause (author): missing `irq_domain_remove()` at the
  `err_domain:` label (the comment already said it should be there). The
  message says `irq_remove_domain()`; the actual API is
  `irq_domain_remove()`.
- Version info: none beyond the historical API gap.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not hidden. This is an explicit error-path resource-leak fix.
External reporting (KASAN during CPU hotplug) shows the leaked objects
can become a use-after-free, not only a leak.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**
Record:
- File: `drivers/base/regmap/regmap-irq.c` (`1` insertion, `1` deletion)
- Function: `regmap_add_irq_chip_fwnode()`
- Scope: single-file surgical fix

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:
- Before: domain created → `request_threaded_irq()` fails → `goto
  err_domain` → comment only → mutex/key teardown → `kfree(d)` while
  `d->domain` stays published with `host_data = d`.
- After: same path calls `irq_domain_remove(d->domain)` before freeing
  `d`.
- Path affected: probe error path only, after successful domain
  creation.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record:
- Category: error-path resource leak; can escalate to UAF because the
  domain is published (`irq_domain_list` / fwnode) with `host_data`
  pointing at memory that is then freed.
- Mechanism: missing counterpart to the existing `irq_domain_remove()`
  in `regmap_del_irq_chip()`.

**Step 2.4: ASSESS THE FIX QUALITY**
Record:
- For `irq_base == 0` (most DT callers): obviously correct. Domain has
  no mappings yet; `irq_domain_remove()` is the right unwind and matches
  the del path.
- For `irq_base != 0` (legacy/`irq_alloc_descs()` path, including
  callers passing `-1`): incomplete. Domain creation associates IRQs up
  front. `irq_domain_remove()` does not dispose those mappings. tglx
  said the descriptor chip/domain pointers remain and the UAF remains.
- Regression risk: low for `irq_base == 0`. For `irq_base > 0`, the
  domain object is freed while descriptors still reference it (already a
  UAF on `desc->chip` before this patch). The change is still a subset
  of the correct unwind, not a new feature.
- Red flags: none on APIs/scope. Completeness gap is real but does not
  make the one-line change wrong for the common path.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**
Record:
- Comment/label introduced by `4af8be67fd9989` (“regmap: Convert
  regmap_irq to use irq_domain”, 2012).
- Domain remove on the **del** path: `b5ab3e5cae097` (“regmap: irq:
  Remove domain on exit”, 2014).
- `err_domain:` still only had the comment at **v6.18.57**.
- This is long-lived error-path debt, not a brand-new 6.18-only bug.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No `Fixes:` tag. Historical introducer is `4af8be67fd9989`; that
commit **is** an ancestor of this tree.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record:
- Nearby: `1da33858af625` (mutex destroy on error), `76b6e14aa7b08`
  (lockdep key). Both already in v6.18.57; this patch’s context matches.
- Domain creation helper: `dde286ee57704` / `regmap_irq_create_domain()`
  already in this tree.
- Standalone 1-line fix, not patch X/Y.
- No follow-up in this tree adding `irq_dispose_mapping()` on
  `err_domain`.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Author is Mark Brown, **regmap maintainer**. He applied his own
patch to `broonie/regmap.git for-7.3` the same day.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record:
- Needs `irq_domain_remove()`: present (`58ee99ada293b`, exported in
  this tree).
- Needs `d->domain` and `err_domain:`: present.
- Can apply standalone to v6.18.57. No missing helpers.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- Lore/msgid: https://patch.msgid.link/20260901-regmap-irq-deallocate-
  domain-v1-1-4bfed4aff559@kernel.org
- Only v1 (`b4 dig -a`); no v2 in that thread.
- Thread:
  1. Mark posts the 1-line patch (1 Sep 2026).
  2. Mark applies it to for-7.3 ~1 hour later.
  3. tglx (4 Sep): “That won’t work” for the `irq_alloc_descs()` /
     `virq_base > 0` case; descriptors keep chip/domain pointers; UAF
     remains. First suggestion: `irq_domain_free_irqs()`.
  4. tglx follow-up: `irq_domain_free_irqs()` only works with
     hierarchical domains; use `irq_dispose_mapping(irq_base + i)` then
     remove the domain.
  5. Mark: “Ah, thanks - I’d expected removing the domain to clean
     everything up.”
- No NAK of calling `irq_domain_remove()` itself; the request is
  additional dispose before remove.
- No reviewer `Cc: stable` in the thread.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record: Recipients were linux-kernel, Farhad Alemi, tglx, Mark Brown.
tglx reviewed after apply. No Acked-by/Reviewed-by on the committed
patch.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record:
- Public write-up (31 Aug 2026): KASAN invalid read in
  `irq_migrate_all_off_this_cpu` during CPU offline. tglx traced it to
  this failed-setup path: descriptors remain mapped to a caller-owned
  `irq_chip` after that chip/`regmap_irq_chip_data` is freed.
- Trigger: device IRQ setup fails, then CPU hotplug walks descriptors.
- Radu Rendec mentioned a similar syzbot hotplug stack; tglx criticized
  allocation info in that report. Overlap is suggestive, not proven
  identical.
- Unprivileged exploit/CVE: not established.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: Standalone v1. tglx’s dispose-mapping addition was not in this
series and is not in this tree. GitHub `master` snapshot still showed
the old comment, consistent with this being a 7.3-era fix not yet
universal.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: No useful stable-list hit that this was previously rejected or
requested. UNVERIFIED beyond search noise.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF**
Record: `regmap_add_irq_chip_fwnode()` only. Callees of interest:
`regmap_irq_create_domain()`, `request_threaded_irq()`,
`irq_domain_remove()`.

**Step 5.2: TRACE CALLERS**
Record:
- `regmap_add_irq_chip()` → `regmap_add_irq_chip_fwnode()`
- `devm_regmap_add_irq_chip_fwnode()` → same
- `git grep -l "regmap_add_irq_chip"` → **87** `.c` files
- Call context: driver probe (MFD/PMIC, ASoC codecs, power, GPIO, RTC,
  DSA). Not a syscall hot path; boot/enumeration and probe-retry.
- `irq_base != 0` callers exist, including popular PMICs: `rk8xx-core.c`
  (`-1`), `retu-mfd.c`, `88pm800.c`, `88pm805.c`, `mt6370.c`, plus board
  `irq_base` in tps65910/wm8994/tps65090.

**Step 5.3: TRACE CALLEES**
Record:
- `regmap_irq_create_domain()` → `irq_domain_instantiate()` with
  `virq_base = irq_base`, `host_data = d`. If `virq_base > 0`,
  `__irq_domain_instantiate()` runs `irq_domain_associate_many()`.
- `if (irq_base)` also calls `irq_alloc_descs()` first (`-1` is truthy).
- `irq_domain_remove()` unpublishes and `kfree`s the domain; comment
  requires mappings already disposed.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record:
- Reachable from device probe of many PMICs/codecs.
- Userspace does not call this directly. Probe failure + later CPU
  offline is the documented KASAN path.
- Deferred probe retry can also leave a stale fwnode domain if the
  domain is not removed.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: `regmap_del_irq_chip()` already disposes mappings then calls
`irq_domain_remove()`. That is the model tglx wants on `err_domain` when
`irq_base > 0`. This patch only adds the remove.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: Yes, at v6.18.57 `drivers/base/regmap/regmap-irq.c`
`err_domain:` still has `/* Should really dispose of the domain but...
*/`. Introduced 2012; never unwound on this error path here.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: Expected **clean apply** to v6.18.57. Surrounding
`mutex_destroy` / `lockdep_unregister_key` already match.
`irq_domain_remove()` already used in the same file’s del path.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: Del-path domain remove is here (`b5ab3e5cae097`). No other fix
of this `err_domain` leak. No `irq_dispose_mapping` follow-up on that
label.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: `drivers/base/regmap` IRQ helper. **IMPORTANT** (shared by many
PMICs/MFDs, not core mm/sched, but widely used on ARM/embedded and
laptops).

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: Mature (2011+). Recent work is lockdep nesting, mutex free,
domain suffix. This is leftover unwind, not churn from a new subsystem.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: Driver-specific / config-specific (`CONFIG_REGMAP_IRQ`), but
that config is selected by many common PMICs. Affects anyone whose
regmap-irq probe fails after domain create.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record:
- Trigger: `regmap_irq_create_domain()` succeeds, then
  `request_threaded_irq()` fails (bad/missing IRQ, busy IRQ, probe
  deferral, etc.).
- Not every boot. Realistic on flaky firmware, wrong DT IRQ, deferred
  probe.
- Unprivileged trigger: not verified. CPU hotplug typically needs
  privilege. KASAN still shows a real kernel UAF.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record:
- Always: leaked published irq domain; `d` freed while domain
  `host_data` dangles.
- With `irq_base != 0`: leaked associated IRQ descriptors; `desc->chip`
  can UAF on CPU offline (`irq_migrate_all_off_this_cpu`). **HIGH** (UAF
  / KASAN).
- This patch fully fixes the domain leak; it does **not** fully fix the
  descriptor UAF when `irq_base > 0`.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record:
- Benefit: high for a 1-line unwind of a published irq domain used by
  dozens of drivers; needed for probe retry and to stop leaking domain
  objects.
- Risk: very low for `irq_base == 0`. For `irq_base > 0`, incomplete;
  not a new feature; same class of UAF already existed.
- Ratio: benefit > risk. Follow-up dispose-mapping should also be
  backported when it exists; that is not a reason to keep the domain
  leak.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Real error-path leak of a published irq domain; comment admitted the
  gap since 2012.
- Reported by tglx; KASAN UAF on CPU hotplug is a serious failure mode.
- 1 line, same API already used in `regmap_del_irq_chip()`.
- Buggy code is in v6.18.57; `irq_domain_remove()` is in this tree;
  applies cleanly.
- Author is the regmap maintainer; 87 in-tree callers.
- Probe-path resource leaks are standard stable material.

AGAINST:
- Incomplete vs the reported `irq_base > 0` UAF; tglx asked for
  `irq_dispose_mapping()` first; Mark agreed the remove-alone assumption
  was wrong.
- No `Fixes:`/`Cc: stable` (not a negative by itself).
- Applied to for-7.3 before tglx’s review; no v2 in that thread.

UNRESOLVED:
- Whether a later mainline follow-up with `irq_dispose_mapping()` landed
  after this tree’s branch.
- Whether the KASAN report was reproduced on 6.18.y specifically (code
  path is present).
- No stable-list discussion found.

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** for the domain leak (`irq_base
   == 0` and domain object itself). Incomplete for preassociated
   descriptors, but the added call is the correct API and is already
   used on the del path.
2. Fixes a real bug that affects users? **PASS** — leaked irq domain on
   failed probe; KASAN UAF documented on related leftover mappings.
3. Important issue? **PASS** — UAF / resource leak of irq core objects,
   not cosmetic.
4. Small and contained? **PASS** — 1 line, one function.
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — v6.18.57 has the exact hunk
   context.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: Not ID/quirk/DT/docs. Ordinary error-path leak fix. Build-fix
exception N/A.

**Step 9.4: MAKE YOUR DECISION**
This should be backported to **this** 6.18.y tree. The bug is here, the
helper is here, and the change is the missing unwind the code has
documented for years. Incompleteness for `irq_base > 0` means a later
dispose-mapping patch is still needed for the full KASAN UAF; it does
not make this line a net negative.

### What the commit solves, and why it matters here
`regmap_add_irq_chip_fwnode()` publishes an irq domain, then on
`request_threaded_irq()` failure frees `struct regmap_irq_chip_data`
without removing that domain. Stable 6.18.57 still does this. The
leftover domain stays on the global list with dangling `host_data`, and
on the legacy `irq_base != 0` path associated descriptors can later be
walked during CPU hotplug (KASAN UAF). Many PMICs/MFDs use this helper,
including rk8xx with `irq_base = -1`.

### Stable rules / risk
Small, obviously intended, no new API, applies cleanly. Benefit is
fixing a real leak/UAF-adjacent unwind; risk is a 1-line call that the
same file already uses on teardown.

Verification:
- [Phase 1] Tags: Farhad Alemi + tglx Reported-by; lore msgid link; Mark
  Brown SOB; no Fixes/Cc stable
- [Phase 1] Body describes creation-path domain leak after
  `8ee99ada293b`; actual SHA in this tree is `58ee99ada293b`
- [Phase 2] Diff is 1 line in `regmap_add_irq_chip_fwnode()`
  `err_domain:`: comment → `irq_domain_remove(d->domain)`
- [Phase 3] `git blame` at v6.18.57: comment from `4af8be67fd9989`
  (2012); del-path remove `b5ab3e5cae097` (2014)
- [Phase 3] `git merge-base --is-ancestor 4af8be67fd9989 HEAD` yes;
  `58ee99ada293b` is ancestor of v6.18.57
- [Phase 3] No follow-up dispose-mapping commit on this file in this
  tree
- [Phase 4] `b4 dig -c 4784831655ab5`: v1 only, applied to for-7.3 same
  day
- [Phase 4] tglx: remove-alone does not clear associated descriptors
  when `virq_base > 0`; use `irq_dispose_mapping` then remove
- [Phase 4] Mark acknowledged he expected remove to clean everything up
- [Phase 4] External write-up: KASAN in `irq_migrate_all_off_this_cpu`
  after failed regmap IRQ setup
- [Phase 5] 87 files call `regmap_add_irq_chip*`; probe of
  MFD/PMIC/codec/etc.
- [Phase 5] `if (irq_base) irq_alloc_descs()` plus `virq_base`
  associate_many confirmed in this tree
- [Phase 6] `git describe HEAD` → `v6.18.57-155-gcdf239ca885b2`; `make
  kernelversion` → 6.18.57
- [Phase 6] v6.18.57 still has the dispose comment;
  `irq_domain_remove()` already in `regmap_del_irq_chip()`
- [Phase 8] Failure mode: leaked irq domain; UAF on CPU hotplug for
  preassociated IRQs; severity HIGH
- UNVERIFIED: later mainline follow-up with `irq_dispose_mapping` on
  `err_domain`; whether syzbot report is the same bug; stable-list
  history beyond unsuccessful search

**YES**

 drivers/base/regmap/regmap-irq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/regmap/regmap-irq.c b/drivers/base/regmap/regmap-irq.c
index 6112d942499be..8c297156ea402 100644
--- a/drivers/base/regmap/regmap-irq.c
+++ b/drivers/base/regmap/regmap-irq.c
@@ -941,7 +941,7 @@ int regmap_add_irq_chip_fwnode(struct fwnode_handle *fwnode,
 	return 0;
 
 err_domain:
-	/* Should really dispose of the domain but... */
+	irq_domain_remove(d->domain);
 err_mutex:
 	mutex_destroy(&d->lock);
 	lockdep_unregister_key(&d->lock_key);
-- 
2.53.0

