Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61FBF5AEC79;
	Mon, 19 Oct 2026 14:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418457; cv=none; b=d4032LI6x0Q1oTkvAu+S3+ZXPW6BDKcKT3wdxRYDhro75rsxUHu2/LifW+CrA9UrCcFhARVFcqIm/XwN9jxHgQndfVnaAiActnrcGfj2UKHpt6kUSdQxUdxbqyeSbWNM7kyoTnv7muZAeyp2hs1KmcHauYTgC5UhrEWMoh9Zf9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418457; c=relaxed/simple;
	bh=+HQeo2Wj+tGg0yqkEuzBgtJ4EBzzRxjoV278JzON4nc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RMe5bdZpVin7qb7ZUAnqHmup50RMGvdVNR4ijZBrdZWgJT3F6Qit7zLmCn4rFoycmZJ449Zkx6LCJVpaFkGXVhXxPQwVafB4G0kVTbQzWVWr6faRVAUQD9JqVN8OGc89y/SFa3B+rtLvLkxrck9bd4wssvoDArltg4Qq7HsxtQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=frMMErwh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="frMMErwh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 776581F000C9;
	Mon, 19 Oct 2026 14:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418454;
	bh=BpqSg4adGgIWWG8l/Oz8X9cwJFs7zfPsrOGuBBF/Gok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=frMMErwhZvZQiOV4PwV2xTMh0vLk5GFGcsDoICi1GZrppnPYqHIYYpUIEd4WiSx1n
	 uz9eSIHxq8nH5ZH4oXS5hzM4Z7oMixftXzhN3Ij2550Be/gnttiN938RdgTTMzof2s
	 N3WQiZm2FL2eMPey+hZM8FR6vwuiiGJIwBo+nORSy5e4sL7m6ESk1LywquavQB3SYo
	 2MM9m4SxZUbUEV4Y30k47EA+TdiZPTqTMzVWQY1HIGHMNIWuzb+aiITCIEX8EPcBBr
	 2veiLXG/qL5hsQmLdfN680q4cmdWNn1F9VvKB0GHU0uP73kEHZycvwMkNXO1lLR3Nv
	 DuruUT3GFi4RA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ian Abbott <abbotti@mev.co.uk>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	hsweeten@visionengravers.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] comedi: dt2811: Fix sanity check in interrupt handler
Date: Mon, 19 Oct 2026 09:49:11 -0400
Message-ID: <20261019135441.1420968-260-sashal@kernel.org>
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

From: Ian Abbott <abbotti@mev.co.uk>

[ Upstream commit 8dda63825752ab19fcbc2a19ecab91d128112415 ]

The driver requests an interrupt handler for the device, after setting
device registers to disable interrupt generation.  The interrupt handler
should not be called prematurely unless the user-configured I/O port
base address and/or IRQ number are incorrect or the hardware is bad.

For safety, the interrupt handler checks the dev->attached flag to
ensure the device is fully set up, but it currently does that after
dereferencing dev->read_subdev, which may be NULL if dev->attached is
false.  Move the check to avoid the possible null pointer dereference.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Link: https://patch.msgid.link/20260618102949.26607-4-abbotti@mev.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

I have enough to decide: this is a real IRQ-time NULL deref in dt2811,
the local 7.3-rc4 tree already contains the surgical fix, and it is a
strong stable candidate.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

Step 1.1: PARSE THE SUBJECT LINE
Record: **[comedi/dt2811] [Fix] sanity check in interrupt handler**
- Subsystem: `comedi:` (COMEDI data-acquisition drivers), driver
  `dt2811`
- Verb: **Fix** — explicit bug-fix language
- Claimed intent: the `dev->attached` guard in `dt2811_interrupt()` is
  in the wrong place and can run after a NULL dereference

Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
Record:
- **Fixes:** none (expected for this review pipeline)
- **Reported-by:** none on *this* commit (but the series cover letter
  and sibling patches cite reporters; see Phase 4)
- **Tested-by:** none
- **Reviewed-by / Acked-by:** none on the commit
- **Link:**
  `https://patch.msgid.link/20260618102949.26607-4-abbotti@mev.co.uk`
  (series patch 3/11; msgid `-4` because `-1` is the cover letter)
- **Cc: stable:** none (expected)
- **Signed-off-by:** Ian Abbott `<abbotti@mev.co.uk>` (COMEDI
  maintainer); Greg Kroah-Hartman (char-misc / staging tree, applied the
  patch)
- Ignore pipeline SOBs; none of Sasha Levin’s markers are on the real
  commit `8dda63825752ab19fcbc2a19ecab91d128112415`

Notable pattern: this is patch 3 of an 11-patch maintainer series titled
“Add/fix sanity check in ISA drivers to avoid null-ptr-deref”. Sibling
patches carry `Reported-by:` from SNU researchers; this patch was
included as the same class of bug.

Step 1.3: ANALYZE THE COMMIT BODY TEXT
Record:
- **Bug:** IRQ handler checks `dev->attached` *after* using
  `dev->read_subdev` (`s->async`, `async->cmd`). If `attached` is false,
  `read_subdev` may still be NULL.
- **Symptom:** kernel NULL pointer dereference in interrupt context
  (oops).
- **Trigger described by author:** premature IRQ after `request_irq()` —
  wrong user-configured I/O base and/or IRQ, bad hardware, or the attach
  window before the device is marked attached.
- **Root cause:** `request_irq()` is issued in `dt2811_attach()` after
  registers are programmed to disable IRQs, but *before* subdevices /
  `read_subdev` / `attached` are set up. The existing safety check is
  too late.
- **Version info in message:** none.

Step 1.4: DETECT HIDDEN BUG FIXES
Record: **Not a hidden fix.** Subject and body state a NULL deref. The
“sanity check” wording is the existing attached-flag guard; the change
is reordering it so it actually works.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

Step 2.1: INVENTORY THE CHANGES
Record:
- File: `drivers/comedi/drivers/dt2811.c` — **+5 / −2** (7 lines)
- Function: `dt2811_interrupt()`
- Scope: **single-file surgical fix**, one function, no API/data-
  structure change

Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
Record (verified against `8dda63825752a^` vs current tree):

**Before:**
```c
s = dev->read_subdev;
async = s->async;          /* deref s — crash if s == NULL */
cmd = &async->cmd;         /* deref async — crash if async == NULL */
if (!dev->attached)
    return IRQ_NONE;
```

**After:**
```c
s = dev->read_subdev;      /* pointer copy only; not a deref of s */
if (!dev->attached)
    return IRQ_NONE;
async = s->async;
cmd = &async->cmd;
```

Affected path: IRQ handler, **premature/spurious interrupt during
attach** (and theoretically a shared/wrong IRQ). Normal post-attach
acquisition is unchanged.

Step 2.3: IDENTIFY THE BUG MECHANISM
Record: **[NULL pointer dereference] in IRQ context**
- `s = dev->read_subdev` is assigned in `dt2811_attach()` only after
  `request_irq()` and `comedi_alloc_subdevices()`.
- `s->async` is allocated even later, in
  `__comedi_device_postconfig_async()`.
- `dev->attached = true` is set last, in `comedi_device_postconfig()`.
- Window after `request_irq()` and before `attached`: `read_subdev`
  and/or `async` can be NULL. Old code dereferences them anyway.

Step 2.4: ASSESS THE FIX QUALITY
Record:
- **Obviously correct:** same `attached` check already used across
  COMEDI; this only moves it before the first use of `s`.
- **Minimal:** no unrelated edits.
- **Regression risk: very low.** If `attached` is true,
  attach+postconfig have already set `read_subdev` and allocated `async`
  (barriers from `attach_lock` in postconfig). If `attached` is false,
  we now return `IRQ_NONE` instead of oopsing — correct for a
  shared/spurious IRQ.
- No public API, locking, or hot-path behavior change for a fully
  attached device.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

Step 3.1: BLAME THE CHANGED LINES
Record:
- Buggy handler introduced by **`f2975a9b2ab9a9`** (“staging: comedi:
  dt2811: add async command support for AI subdevice”), H Hartley
  Sweeten, **2016-06-17**.
- Contained in **v4.8-rc1**. Present for ~10 years.
- `if (!dev->attached)` was already there from that commit; it was
  simply **after** the NULL deref.

Step 3.2: FOLLOW THE FIXES: TAG
Record: **No Fixes: tag.** Introducer is `f2975a9b2ab9a9` (v4.8),
confirmed via blame + `git show`. That commit exists in this tree’s
history. No intermediate dt2811 interrupt-handler fix between 2016 and
this commit.

Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Record:
- `408bece94e7bd` — I/O-base sanity checks (unrelated)
- `df0e68c1e9945` — header move
- `8ffdff6a8cfbd` (2021-04-15) — comedi left staging
- This patch is **standalone**. Series 11/11 are independent per-driver
  one-liners; no shared helper or prerequisite refactor. Nothing after
  `8dda63825752a` on this file.

Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Record: **Ian Abbott is a listed COMEDI maintainer** (`MAINTAINERS`:
COMEDI DRIVERS, status **Odd Fixes**). Same-day series of 11 analogous
IRQ-guard fixes. Weight: high — subsystem maintainer fixing a class of
bugs reported by researchers.

Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
Record: **None.** Uses `dev->attached` / `dev->read_subdev` that have
existed for years. Applies standalone. Path in this tree is
`drivers/comedi/drivers/dt2811.c` (post-staging). On pre-2021 trees the
same hunk would apply under `drivers/staging/comedi/drivers/dt2811.c`.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
Record:
- `b4 dig -c 8dda63825752a` →
  https://patch.msgid.link/20260618102949.26607-4-abbotti@mev.co.uk
- `b4 dig -a`: **v1 only** (single revision, 11-patch series). Applied
  version is that v1.
- Cover letter (`20260618102949.26607-1`): “Add/fix sanity check in ISA
  drivers to avoid **null-ptr-deref**”. Explains IRQ registered before
  subdevice init; some drivers already checked `attached` too late
  (dt2811 is in that set).
- Original report: https://lore.kernel.org/lkml/20260610115912.780131-1-
  jjy600901@snu.ac.kr/ (Jaeyoung Chung et al.). dt2811 was **not** in
  the reporter’s list; Abbott added it after spotting the same pattern.
- **No replies/NAKs** in the saved thread (12 messages, all from Abbott
  — patches + cover only).
- **No explicit Cc: stable** in the thread. Greg KH applied it to char-
  misc.

Step 4.2: CHECK WHO REVIEWED THE PATCH
Record (`b4 dig -w`):
- Recipients: linux-kernel, Greg Kroah-Hartman, H Hartley Sweeten (other
  COMEDI maintainer), Jaeyoung Chung, Sangyun Kim, Kyungwook Boo
- Appropriate maintainers were on CC. No external Reviewed-by; author
  *is* the maintainer.

Step 4.3: SEARCH FOR THE BUG REPORT
Record:
- Sibling patch 01/11 has `Reported-by: Jaeyoung Chung`, Sangyun Kim,
  Kyungwook Boo (SNU) and the lore link above.
- Cover letter: several ISA drivers can NULL-deref if the device
  interrupts before setup.
- Direct fetch of lore.kernel.org returned **403** in this environment;
  content is taken from the b4-saved mbox, not from WebFetch.
- Severity from reporter’s framing: **null-ptr-deref** (crash).
  Academic/security-style report of a real CWE-class bug, not a
  theoretical nit.

Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
Record: 11 independent driver patches. This one does **not** depend on
01/02 or later patches. Related: `17221216ae8ce` comedi_parport (sent ~3
weeks earlier, mentioned in the cover letter).

Step 4.5: CHECK STABLE MAILING LIST HISTORY
Record: lore.kernel.org/stable search also **403**. No evidence in the
commit or series mbox of a stable NAK or of an existing reason to skip
it. **UNVERIFIED:** whether anyone already queued this on stable@ (does
not change the technical verdict).

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
Record: **`dt2811_interrupt()`** only.

Step 5.2: TRACE CALLERS
Record:
- Registered in `dt2811_attach()` via `request_irq(it->options[1],
  dt2811_interrupt, 0, ...)` when the user-supplied IRQ is in {2,3,5,7}.
- Calling context: **hard IRQ**. Crash is an oops in interrupt context.

Step 5.3: TRACE CALLEES
Record (after the guard): `inb`/`outb` on `dev->iobase`,
`dt2811_ai_read_sample()`, `comedi_buf_write_samples()`,
`comedi_handle_events()`. Unchanged. The fix only avoids entering that
path when the device is not attached.

Step 5.4: FOLLOW THE CALL CHAIN
Record:
- Userspace: COMEDI `COMEDI_DEVCONFIG` attach (`comedi_device_attach()`
  → `dt2811_attach()` → `request_irq()`).
- Attach typically needs privilege (raw I/O / admin), not an
  unprivileged syscall smash.
- Still reachable: load `dt2811`, configure I/O+IRQ, race during attach,
  or share/wrong IRQ.
- **Reachable from device attach**, not purely theoretical.

Step 5.5: SEARCH FOR SIMILAR PATTERNS
Record: Same class fixed in aio_iiro_16, das6402, ni_at_a2150,
ni_atmio16d, pcl711/816/818, pcmmio, pcmuio, quatech_daqp_cs. Canonical
comment in `ni_660x.c`: “make sure `dev->attached` is checked before
doing anything else”. Systematic COMEDI IRQ-init bug, not a one-off.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
Record:
- Local tree: **`git describe HEAD` = `v7.3-rc4-27-gf0100363d8c37`**,
  `make kernelversion` = **7.3.0-rc4** (mainline, not a 6.x.y stable
  branch).
- `git merge-base --is-ancestor 8dda63825752a HEAD` → **yes** (exit 0).
  The **fix is already in this checkout**.
- The **bug existed here until that commit**. Introduced v4.8
  (`f2975a9b2ab9a9`). File and function exist at
  `drivers/comedi/drivers/dt2811.c`.
- Current `dt2811_interrupt()` already has the reordered check (lines
  192–204).

This evaluation is whether that mainline fix **should be selected for
stable**, not whether to re-apply it on 7.3-rc4. The touched code is
present and the bug is old enough for every current LTS that still has
the pre-fix handler.

Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
Record: **Clean apply** on this code (hunk is tiny; handler body has
been stable since 2016 aside from this reorder). Older stables with
comedi still in staging need only a path rename. No conflicting local
changes.

Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
Record: This *is* the fix. No earlier dt2811 interrupt-guard substitute.
No later revert or follow-up.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
Record:
- **Subsystem:** `drivers/comedi/` — COMEDI ISA DAQ
  (`CONFIG_COMEDI_DT2811`, Data Translation DT2811).
- **Criticality: PERIPHERAL.** Niche 1980s-era ISA ADC/DAC. Not
  mm/net/fs. Still an in-tree, non-staging driver since 2021.

Step 7.2: ASSESS SUBSYSTEM ACTIVITY
Record: Status **Odd Fixes**. Low churn; Ian Abbott still sending real
bugfixes (this series, I/O-base checks). Mature driver, long-lived bug.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

Step 8.1: DETERMINE WHO IS AFFECTED
Record: **Driver-specific / config-specific** — only
`CONFIG_COMEDI_DT2811` users with this ISA board (or anyone attaching
the driver with an IRQ). Small population, including lab/industrial
leftover hardware and distros that ship comedi modules.

Step 8.2: DETERMINE THE TRIGGER CONDITIONS
Record:
- **Attach race:** `request_irq` at `dt2811_attach()` ~line 571, then
  reset already done, then alloc subdevices, then `read_subdev = s`,
  then return; core then `comedi_device_postconfig()` sets `attached`.
  Any IRQ in that window hits the bug.
- **Misconfigured IRQ/I/O:** author explicitly calls this out; ISA IRQ
  2/3/5/7 are often shared.
- **How common:** uncommon (old ISA + attach/misconfig), but the window
  is real and does not need exotic timing beyond “IRQ fires while
  attaching”.
- **Unprivileged:** attach is privileged; this is **not** a guest DoS
  from an unprivileged syscall. Still a host oops for a legitimate (or
  root) attach.

Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
Record:
- **Failure mode:** NULL deref of `s` or `s->async` in
  `dt2811_interrupt()` → **kernel oops in IRQ context**.
- **Severity: HIGH** (crash). Not a silent corruption or universal
  panic, but an oops is an important stable-class issue.

Step 8.4: CALCULATE RISK-BENEFIT RATIO
Record:
- **Benefit:** medium for affected users (prevents oops on attach/wrong
  IRQ); low globally (tiny user base).
- **Risk:** **very low** — 7-line reorder, no locking/API change,
  behavior for attached devices identical.
- **Ratio:** **favor backport.** Near-zero regression risk vs a real
  crash fix. Obscure hardware is not a NO when the patch is this small
  and correct.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

Step 9.1: COMPILE THE EVIDENCE
**FOR:**
- Real NULL deref in IRQ handler (verified in pre-image of
  `8dda63825752a` and in attach/postconfig ordering).
- Bug since v4.8; still the same handler shape.
- Maintainer-authored, merged by Greg KH; part of a documented null-ptr-
  deref series from an external report.
- 5 insertions / 2 deletions, obviously correct, no new API.
- Standalone; no prerequisites.
- Matches stable rule “NULL pointer dereference” and “driver probe/IRQ
  UAF/NPD”.

**AGAINST:**
- Peripheral ISA driver, few users.
- Trigger needs COMEDI attach + IRQ; not a core-path bug.
- This patch itself had no Reported-by (dt2811 was maintainer-found, not
  in the SNU list).
- No syzbot/KASAN splat in the commit message (hard to fuzz ISA I/O).

**UNRESOLVED:**
- Full text of the SNU report (lore 403).
- Whether stable@ already discussed this series.

None of the unresolved items are required to decide: the local code
proves the NPD.

Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. Obviously correct and tested? **PASS** — reorder of an existing
   guard; applied to char-misc; v1 with no NAK.
2. Fixes a real bug that affects users? **PASS** — NPD if IRQ fires
   before `attached`.
3. Important issue? **PASS** — oops in IRQ context (HIGH, not data-
   corruption/security-universal).
4. Small and contained? **PASS** — one function, +5/−2.
5. No new features or APIs? **PASS**.
6. Can apply to the local tree? **PASS** — code exists; hunk matches
   this tree. (Fix is already merged here; that is the *source* of the
   backport, not a reason to skip stables that still have the old
   order.)

Step 9.3: CHECK FOR EXCEPTION CATEGORIES
Record: **Not an exception category** (not a device
ID/quirk/DT/build/doc patch). It is a ordinary small crash fix.

Step 9.4: MAKE YOUR DECISION
This is a textbook stable backport: a long-standing, small, obviously
correct NULL-deref fix in an IRQ handler. Niche hardware lowers
population, not severity-for-those-users, and the regression risk is
negligible.

**What it solves for stable users:** loading/configuring the dt2811
COMEDI driver can oops if an interrupt arrives after `request_irq()` and
before `dev->attached` / `read_subdev` / `s->async` are valid. The patch
returns `IRQ_NONE` until attach is complete.

**Risk vs benefit:** benefit is preventing an oops; risk is a 7-line
reorder with identical post-attach behavior.

**Concerns:** none that block a backport. Series membership does not
imply a prerequisite. Staging path adjustment only matters on pre-2021
trees, not this 7.3 checkout.

Verification:
- [Phase 1] Parsed subject/tags/body of
  `8dda63825752ab19fcbc2a19ecab91d128112415`; no
  Fixes/Cc:stable/Reported-by on this commit; Link msgid `26607-4`
- [Phase 2] `git show 8dda63825752a^:drivers/comedi/drivers/dt2811.c` —
  confirmed `s->async` / `async->cmd` before `if (!dev->attached)`
- [Phase 2] Current file lines 192–204 — fix present
- [Phase 3] `git blame` — buggy pattern from `f2975a9b2ab9a9` (2016);
  `git describe --contains` → v4.8-rc1
- [Phase 3] `git log --oneline -- drivers/comedi/drivers/dt2811.c` — no
  later dt2811 IRQ follow-up
- [Phase 3] Author is MAINTAINERS COMEDI contact
- [Phase 4] `b4 dig -c` / `-a` / `-w` / `-m` — v1 series, cover letter
  null-ptr-deref, SNU CCs, no NAK in mbox
- [Phase 4] lore WebFetch/curl → 403; used b4 mbox instead
- [Phase 5] Grep: only `dt2811_attach` `request_irq`s this handler;
  `comedi_device_attach` → attach → `comedi_device_postconfig` sets
  `attached` after `s->async` alloc
- [Phase 6] `git describe HEAD` = v7.3-rc4-27-gf0100363d8c37; `make
  kernelversion` = 7.3.0-rc4; `git merge-base --is-ancestor
  8dda63825752a HEAD` succeeds
- [Phase 7] Kconfig `COMEDI_DT2811` “Data Translation DT2811 ISA card
  support”
- [Phase 8] Failure mode: NULL deref in IRQ → oops; trigger: attach
  window / bad IRQ
- UNVERIFIED: full SNU report HTML; stable@ archive search (lore 403)

The fix is small, surgical, and meets all stable kernel criteria.

**YES**

 drivers/comedi/drivers/dt2811.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/comedi/drivers/dt2811.c b/drivers/comedi/drivers/dt2811.c
index dbb9f38da2898..c2ec5e4fb689f 100644
--- a/drivers/comedi/drivers/dt2811.c
+++ b/drivers/comedi/drivers/dt2811.c
@@ -193,13 +193,16 @@ static irqreturn_t dt2811_interrupt(int irq, void *d)
 {
 	struct comedi_device *dev = d;
 	struct comedi_subdevice *s = dev->read_subdev;
-	struct comedi_async *async = s->async;
-	struct comedi_cmd *cmd = &async->cmd;
+	struct comedi_async *async;
+	struct comedi_cmd *cmd;
 	unsigned int status;
 
 	if (!dev->attached)
 		return IRQ_NONE;
 
+	async = s->async;
+	cmd = &async->cmd;
+
 	status = inb(dev->iobase + DT2811_ADCSR_REG);
 
 	if (status & DT2811_ADCSR_ADERROR) {
-- 
2.53.0

