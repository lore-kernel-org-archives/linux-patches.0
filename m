Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 946C55B91F8;
	Mon, 19 Oct 2026 14:00:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418450; cv=none; b=ILWnPi4edNdW0lFTkuzVh7vZMlSMSARe/jICQMzTCeUpz0iVMye+1ZFKc99EM6phswDYncUj1a1D9FQlQ+euQMDvy0ixu4BQzpocSCRbeyYALvtKMd2f9Bm/PhZlR0gViDSrcOrY7JLLCvWhseIwZsPSx4SrW9p9hYuvHGcsX9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418450; c=relaxed/simple;
	bh=nnfIhw/ClOLIzlQMnJWBoueQ/yCK19dDoH+Vrn6+1VM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NbgYtlzHh3rejBEPsgITh7KHTLFAxtTSg+I1GXXy+Vh7PUNtCalddAagZMqZNcyeV8Jkqp+9C+0brchpUYVPDo2Ru0wgl4IMYW0gCeWnBoNxRzsbCxAvAcvN2NS+2E8KISmglu6PL9izXtZfi6ruK0xxYAoUqmYwiCyGm99CxcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=j4z6c/Bh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="j4z6c/Bh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 971651F000C6;
	Mon, 19 Oct 2026 14:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418448;
	bh=4I6ZgoMsk5iPjJsNFRyZkStNIjgABZQ+EeZACWA0tqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j4z6c/BhRg0ThGhpfBAKbSvi6BNJ03iknUhtIizl63Fja1kMtzle1nroGuwFM0coA
	 WIC/4nJvaocgsFcUg6Ox2IOJmpX/6AcH/BAPODF07M7J9dV0fxryGeLoe38BmVv20I
	 n564nUGvh3Fv6lnlzkEQ7yxmA+HZJoq0f9SXIUm9bOr0UZ4aEQ8ni4/yaPhdH4qAnn
	 jLFV2gjYqjxJNGDh00mGFWh0pM6E1Z3aXTp+TpKrnDHenMoGXvFagndgBKm6Nu8dBY
	 l1bLW4fb64KjhDACauQSFyHqGcIXd+jmREz/ej0F+lUKFWj2iRkVRdmbMGS91Z5WTU
	 zgI47XXIhsaKA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Chen Changcheng <chenchangcheng@kylinos.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	mchehab@kernel.org,
	linux-media@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] media: cx88: fix memory leak in cx8802_register_driver() error path
Date: Mon, 19 Oct 2026 09:49:07 -0400
Message-ID: <20261019135441.1420968-256-sashal@kernel.org>
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

From: Chen Changcheng <chenchangcheng@kylinos.cn>

[ Upstream commit e228b8b1a5b47a72b265671dc6d864c0da5528d0 ]

In cx8802_register_driver(), when drv->probe(driver) fails (non-zero),
the allocated cx8802_driver struct is freed neither in the else branch
nor later in cx8802_unregister_driver() (which only frees entries that
were added to dev->drvlist on success). Each failed probe leaks the
driver struct.

Add kfree(driver) in the else branch to fix the leak.

Signed-off-by: Chen Changcheng <chenchangcheng@kylinos.cn>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This is a one-line leak fix in a long-standing cx88 error path. Local
tree is **7.3.0-rc4** (`v7.3-rc4-27-gf0100363d8c37`). The buggy code has
been in this lineage since 2006, and the patch is self-contained.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

Step 1.1: PARSE THE SUBJECT LINE
Record: **[media/cx88] [fix] [free leaked `cx8802_driver` when
`drv->probe()` fails in `cx8802_register_driver()`]**

Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
Record:
- **Signed-off-by:** Chen Changcheng `<chenchangcheng@kylinos.cn>`
  (author)
- **Signed-off-by:** Hans Verkuil `<hverkuil+cisco@kernel.org>` (media
  maintainer; applied the patch)
- **No Fixes:** tag (expected for this review pipeline)
- **No Cc: stable@vger.kernel.org** (expected; not a negative signal)
- **No Reported-by / Tested-by / Reviewed-by / Acked-by / Link**
- Ignore any pipeline “Upstream commit” / Sasha Levin SOB (none on this
  commit object itself)

Step 1.3: ANALYZE THE COMMIT BODY TEXT
Record:
- **Bug:** In `cx8802_register_driver()`, `kzalloc`/`kzalloc_obj` of a
  `cx8802_driver` is not freed when `drv->probe(driver)` returns non-
  zero. `cx8802_unregister_driver()` only `kfree`s entries that were
  `list_add_tail`’d onto `dev->drvlist` after a successful probe.
- **Symptom:** Each failed probe leaks one `cx8802_driver` object until
  reboot (or forever across module reload).
- **Version info:** none in the message. History shows the
  allocation+else-without-free pattern dates to 2006.
- **Root cause (author):** failed probes never join `drvlist`, so
  unregister cannot reclaim them; the else branch must `kfree(driver)`.

Step 1.4: DETECT HIDDEN BUG FIXES
Record: **Not hidden.** Subject and body say “fix memory leak”. The diff
is exactly that: add `kfree(driver)` on the probe-failure path.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

Step 2.1: INVENTORY THE CHANGES
Record:
- **File:** `drivers/media/pci/cx88/cx88-mpeg.c` — **+1 / -0**
- **Function:** `cx8802_register_driver()`
- **Scope:** single-file, single-line, surgical error-path fix

Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
Record: Before (verified at `e228b8b1a5b47^`):

```
err = drv->probe(driver);
if (err == 0) {
    i++;
    list_add_tail(&driver->drvlist, &dev->drvlist);
} else {
    pr_err("cx8802 probe failed, err = %d\n", err);
}
```

After: same, plus `kfree(driver)` in the else branch. Only the **probe-
failure path** changes. Success path, ENOMEM `goto out`, and unregister
of successful entries are unchanged.

Step 2.3: IDENTIFY THE BUG MECHANISM
Record: **[Error path / resource leak]** Mechanism: per-device snapshot
of `struct cx8802_driver` is allocated, probe fails, pointer is dropped.
Unregister walks `dev->drvlist` only, so the object is unreachable. Fix:
free it immediately on failure. This is **adding a put/free (leak
fix)**, not removing one.

Step 2.4: ASSESS THE FIX QUALITY
Record:
- **Obviously correct:** allocation is `kzalloc_obj(*drv)` (historically
  `kzalloc(sizeof(*drv), GFP_KERNEL)`); matching `kfree(driver)` on the
  only path that neither lists it nor returns it.
- **Minimal:** one statement; no unrelated edits.
- **Regression risk: very low.** Probe callbacks (`cx8802_dvb_probe`,
  `cx8802_blackbird_probe`) return errors without stashing `drv` on a
  list. `kfree` under `core->lock` is safe. No API/locking/refcount
  changes.
- **No red flags.**

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

Step 3.1: BLAME THE CHANGED LINES
Record:
- Loop, alloc, memcpy, probe, else-`pr_err` introduced by
  **`6c5be74c86f102`** (“V4L/DVB (4676): Dynamic cx88 mpeg port
  management…”, Steven Toth, **2006-12-10**).
- `pr_err` conversion: `65bc2fe86e6670` (2016).
- Alloc API later became `kzalloc_obj` via **`69050f8d6d075`** (Kees
  Cook, 2026) then **`bf4afc53b77ae`**.
- The **missing free is original**, not a recent regression. Present
  since ~v2.6.20-era, so it exists in every current stable series.

Step 3.2: FOLLOW THE FIXES: TAG
Record: **No Fixes: tag.** Introducer is `6c5be74c86f102`, confirmed by
blame of the alloc/`probe`/else block. `git merge-base --is-ancestor
e228b8b1a5b47 HEAD` → **IS_ANCESTOR** (commit is in this checkout). No
intermediate “same leak” fixes on this file besides this one.

Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Record: Recent `cx88-mpeg.c` commits are PCI_DEVICE macros, kmalloc_obj
conversion, IRQ status clear, dma_ API switch — not prerequisites of
this `kfree`. Older related leak: **`96df988bb9359`** “[media] cx88: Fix
possible leak in `cx8802_probe()`” (different function: PCI probe of the
mpeg manager, not this subdriver register path). **Standalone; not part
of a series.**

Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Record: Chen Changcheng has **only this commit** under
`drivers/media/pci/cx88/`. Applied by **Hans Verkuil**, linux-media
maintainer. Subsystem listed as **“Odd fixes”** in MAINTAINERS (`CX88
VIDEO4LINUX DRIVER`, Mauro Chehab).

Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
Record: **None.** The hunk only needs the existing `else {
pr_err("cx8802 probe failed..."); }` block. Allocation style (`kzalloc`
vs `kzalloc_obj`) is **outside** the hunk, so the one-line add applies
on older trees. **Can apply standalone.**

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
Record:
- **`b4 dig -c e228b8b1a5b47…`:** https://patch.msgid.link/2026072402521
  8.32318-1-chenchangcheng@kylinos.cn
- **`b4 dig -a`:** **v1 only** (2026-07-24). Applied 2026-07-28. No
  v2/v3.
- **`b4 dig -m`:** thread is **the patch itself only** — no replies,
  NAKs, or reviewer `Cc: stable` in the saved mbox.
- Lore HTML via WebFetch: **403 Forbidden** (could not read the web UI).
  Content recovered from the mbox; it matches the committed message and
  diff.

Step 4.2: CHECK WHO REVIEWED THE PATCH
Record (`b4 dig -w`): To **mchehab@kernel.org**, **kees@kernel.org**; Cc
**linux-media**, **linux-kernel**. Appropriate lists. No on-list
Reviewed-by; **Hans Verkuil committed it** (implicit maintainer
acceptance). Kees was CC’d (likely due to recent allocator work); no
recorded reply.

Step 4.3: SEARCH FOR THE BUG REPORT
Record: **No Reported-by / Link / syzbot / bugzilla.** Bug is from
**code inspection**, not a user crash report. Still a real leak (see
Phase 5/8).

Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
Record: Standalone `[PATCH]`, not `n/m`. No sibling cx88 leak patches in
file history besides the old `cx8802_probe()` leak.

Step 4.5: CHECK STABLE MAILING LIST HISTORY
Record: WebFetch of
`https://lore.kernel.org/stable/?q=cx8802_register_driver` returned
**403**. **UNVERIFIED** whether stable@ already discussed this. Not used
to drive the verdict.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
Record: **`cx8802_register_driver()`** only. (semcode MCP not available;
used hunk headers + grep.)

Step 5.2: TRACE CALLERS
Record:
- `cx88-dvb.c` `dvb_init()` →
  `cx8802_register_driver(&cx8802_dvb_driver)` (`module_init`)
- `cx88-blackbird.c` `blackbird_init()` →
  `cx8802_register_driver(&cx8802_blackbird_driver)` (`module_init`)
- Autoload from PCI probe: `cx8802_probe()` → `request_modules()` →
  `request_module("cx88-dvb")` / `"cx88-blackbird"` when `board.mpeg`
  has the corresponding bit.

Context: **module init / device probe**, not IRQ/hot path.

Step 5.3: TRACE CALLEES
Record: `cx8802_check_driver()`, `kzalloc_obj`, `memcpy`,
`mutex_lock(&drv->core->lock)`, **`drv->probe(driver)`**,
`list_add_tail` on success, `pr_err` + (now) `kfree` on failure.

Probe implementations:
- `cx8802_dvb_probe`: **returns `-ENODEV` immediately** if
  `!(core->board.mpeg & CX88_MPEG_DVB)`; also fails on
  `vp3054_i2c_probe`, `cx8802_alloc_frontends`, `vb2_queue_init`,
  `dvb_register`.
- `cx8802_blackbird_probe`: same **`-ENODEV` if not BLACKBIRD**; also
  `cx2341x_handler_init` / `vb2_queue_init`.

Step 5.4: FOLLOW THE CALL CHAIN
Record: Userspace/module load of `cx88-dvb` or `cx88-blackbird` (or udev
via `cx8802_probe`) → register walks **`cx8802_devlist` (every MPEG
function-2 device)** → alloc + probe. **Reachable from normal driver
load, not an obscure config.** Type-mismatch `-ENODEV` is a **designed,
common** failure: register does not filter by `type_id` first.

Step 5.5: SEARCH FOR SIMILAR PATTERNS
Record: Unregister already `kfree(d)` after successful `remove`. Success
path is balanced; **only the failure path was missing the free.** No
duplicate of this bug in sibling functions beyond the historical
`cx8802_probe()` leak that was already fixed.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
Record: **Yes, in this lineage.** Pre-fix source at `e228b8b1a5b47^`
still has the else branch **without** `kfree`. HEAD already contains the
fix (`e228b8b1a5b47` is an ancestor). Bug introduced **2006**
(`6c5be74c86f102`), long before 7.3. The `pr_err` else block and leak
exist on all current LTS kernels.

Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
Record: **Clean apply / trivial.** Context line `pr_err("cx8802 probe
failed, err = %d\n", err);` has been stable since 2016. Adjacent
`kzalloc_obj` vs older `kzalloc(sizeof(*drv), GFP_KERNEL)` is **not in
this hunk**.

Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
Record: This exact `kfree` **is** already in HEAD. That is the candidate
commit, not a different prior fix. No competing rewrite of the error
path. (`96df988bb9359` is a different leak.)

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
Record: **`drivers/media/pci/cx88`** — Conexant CX2388x analog/DVB TV
capture. **PERIPHERAL** (specific PCI TV cards). Maintainer status:
**Odd fixes**. Still in-tree and used on remaining hardware.

Step 7.2: ASSESS SUBSYSTEM ACTIVITY
Record: Low churn; mostly treewide/API conversions plus occasional
bugfixes. **Mature.** A 20-year leak in a quiet driver is still a leak
for those cards.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

Step 8.1: DETERMINE WHO IS AFFECTED
Record: **Driver-specific / config-specific:** `CONFIG_VIDEO_CX88` plus
`VIDEO_CX88_DVB` and/or `VIDEO_CX88_BLACKBIRD`. Not universal. Distros
that ship these modules (common in desktop kernels) can hit it on CX88
MPEG hardware.

Step 8.2: DETERMINE THE TRIGGER CONDITIONS
Record:
- **Primary realistic trigger:** subdriver init probes **every**
  `cx8802_dev`. A DVB-only card + `cx88-blackbird` load (or mixed cards
  in one machine) takes the `-ENODEV` path **every boot / every module
  load**.
- **Also:** genuine probe errors (`vb2_queue_init`, frontend alloc,
  etc.).
- **Module reload** leaks again (unregister never sees the object).
- Unprivileged users cannot typically trigger it unless they can load
  modules; **not a UAF/security primitive**, a leak.

Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
Record: **Memory leak of one `struct cx8802_driver` (~pointers + enums,
small) per failed probe.** Not a panic/UAF. **Severity: MEDIUM**
(init/error path, small object, can repeat on reload / multi-device
mismatch). Still a real, permanent leak of kernel memory for affected
users.

Step 8.4: CALCULATE RISK-BENEFIT RATIO
Record:
- **Benefit:** stops a real leak on a path that is not purely
  theoretical (type-mismatch `-ENODEV` is intentional). Helps CX88 users
  and anyone who reloads these modules.
- **Risk:** **very low** (1 line, `kfree` of an unlisted object,
  maintainer-applied).
- **Ratio:** strongly favors backport.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

Step 9.1: COMPILE THE EVIDENCE

**FOR backporting:**
- Real leak: alloc without free when probe fails; unregister cannot
  recover it (verified in both functions).
- Failure path includes **common `-ENODEV` type mismatch**, not only
  rare ENOMEM.
- One-line, obviously correct `kfree`; maintainer (Hans Verkuil) applied
  it.
- Bug present since 2006 — all stable trees that have cx88 have the bug.
- Applies cleanly; no new API, no locking change, no series dependency.
- Matches the stable “error-path leak / missing kfree” pattern.

**AGAINST:**
- Peripheral old TV capture driver; small object; not a
  crash/security/data-corruption bug.
- No user/syzbot report; no Fixes/Cc: stable (expected here).
- Not a hot-path unbounded leak unless modules are reloaded or many
  devices mismatch.

**UNRESOLVED:**
- Lore web UI and stable@ search returned HTTP 403; on-list review
  comments beyond the patch email could not be read (mbox had no
  replies).

Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. Obviously correct and tested? **PASS** — code inspection; applied by
   media maintainer (no extra Tested-by).
2. Fixes a real bug that affects users? **PASS** — leaked `kzalloc` on
   failed/mismatched probe.
3. Important issue? **PASS** (medium: resource leak on driver load; not
   panic-level, but a genuine leak stable regularly takes).
4. Small and contained? **PASS** — +1 line, one function.
5. No new features or APIs? **PASS**.
6. Can apply to the local tree? **PASS** — same else-branch context; no
   missing helpers.

Step 9.3: CHECK FOR EXCEPTION CATEGORIES
Record: **Not an exception category** (not a device
ID/quirk/DT/build/doc). It is a normal **error-path leak fix**.

Step 9.4: MAKE YOUR DECISION
The leak is real, old, and fixed with a single obviously-correct
`kfree`. Risk is negligible. It belongs in this tree’s stable backports:
CX88 still probes every MPEG device, and failed probes (including
designed `-ENODEV`) drop the allocation on the floor.

**What it solves for stable users:** loading `cx88-dvb`/`cx88-blackbird`
(or mixed CX88 cards) no longer leaks a `cx8802_driver` per failed
probe, including across module reload.

**Risk vs benefit:** one-line free on an object that is not on any list
— benefit clearly wins.

**Concerns:** none for apply/prereqs. Severity is “leak” not “oops”;
still within stable practice for missing `kfree` on error paths.

Verification:
- [Phase 1] Subject/tags: leak fix; SOBs Chen Changcheng + Hans Verkuil;
  no Fixes/Reported-by/Cc:stable
- [Phase 1] Body matches the mechanism verified in source
- [Phase 2] `git show e228b8b1a5b47`: +1 line `kfree(driver)` in else of
  `cx8802_register_driver()`
- [Phase 2] `git show e228b8b1a5b47^`: else branch logs error and does
  not free
- [Phase 2] `cx8802_unregister_driver()` only `kfree`s `dev->drvlist`
  entries after successful `remove`
- [Phase 3] `git describe HEAD` / `make kernelversion`:
  v7.3-rc4-27-gf0100363d8c37, 7.3.0-rc4
- [Phase 3] `git merge-base --is-ancestor e228b8b1a5b47 HEAD`:
  IS_ANCESTOR
- [Phase 3] `git blame`: leaky alloc/probe/else from `6c5be74c86f102`
  (2006-12-10)
- [Phase 3] Author log: only this cx88 commit; file not a series
- [Phase 4] `b4 dig -c/-a/-w/-m`: lore msgid 20260724025218.32318-1; v1
  only; To mchehab+kees; mbox has no replies
- [Phase 4] WebFetch lore.kernel.org: 403 — UNVERIFIED web
  thread/stable@ discussion
- [Phase 5] grep callers: only `cx88-dvb.c` and `cx88-blackbird.c`
  module_init
- [Phase 5] Read `cx8802_dvb_probe` / `cx8802_blackbird_probe`:
  `-ENODEV` if MPEG type bit unset
- [Phase 5] `cx8802_probe` → `request_modules()` autoloads matching
  subdrivers
- [Phase 6] Pre-fix function present; hunk independent of `kzalloc_obj`
  (`69050f8d6d075`)
- [Phase 7] MAINTAINERS: CX88 VIDEO4LINUX DRIVER, Odd fixes, Mauro
  Chehab
- [Phase 8] Failure mode: kernel memory leak, MEDIUM, driver-specific
- UNVERIFIED: on-list reviewer comments (mbox empty of replies; lore
  HTTP 403)
- UNVERIFIED: whether stable@ already queued this elsewhere (not used
  for the verdict)

**YES**

 drivers/media/pci/cx88/cx88-mpeg.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/pci/cx88/cx88-mpeg.c b/drivers/media/pci/cx88/cx88-mpeg.c
index 2c1d5137ac470..bc08b35e247e0 100644
--- a/drivers/media/pci/cx88/cx88-mpeg.c
+++ b/drivers/media/pci/cx88/cx88-mpeg.c
@@ -640,6 +640,7 @@ int cx8802_register_driver(struct cx8802_driver *drv)
 			list_add_tail(&driver->drvlist, &dev->drvlist);
 		} else {
 			pr_err("cx8802 probe failed, err = %d\n", err);
+			kfree(driver);
 		}
 		mutex_unlock(&drv->core->lock);
 	}
-- 
2.53.0

