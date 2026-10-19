Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D8C4606118;
	Mon, 19 Oct 2026 14:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418601; cv=none; b=MTkxTvOr+LRnPSHb64dmPaJeSsoD6qp12QHPUyNtxSpnOpsjDnR9ihsV1/mnYvVU5HNxogvcHuGO9wBTKpnBwxZdPth1UbI1+KOAXDAw9tNTGK1JYCeWtnnUFIe6i7eiwetHk3HtXNqplltiM3CSFXmWYtuTziCvX7bti80yB94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418601; c=relaxed/simple;
	bh=nQVuP7B0iOJ6a22Oh/YZ8UFWOuGhpE6HymMl0hnF6Ms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IMgMG/TeMl0XkfLaI0sDQbX83dYHXj3w/a1zM7N7Xu6VKdW9YDoiKkHDFAuLfaiV+Mj+N1qGsprih4g5Pa1JKopXMsbRvg4Me+Eju0/clb7JkuANXHwS9+x7B0zcgBxYfepKAnkry02kKoj2nZta6YY0UMYVWjdLWctDqR7Y3GU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WByqMUmt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WByqMUmt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D0521F000C4;
	Mon, 19 Oct 2026 14:03:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418597;
	bh=paOQPqKpLelHXuUgFni47NEMAW4wi6DzQzhrIRE0ayI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WByqMUmt3/xkH8Gc/3lCkmF/t7LmGxYrLCmSaeli+r/GzdSaIdHhjxIQVsmzbSPpg
	 aDyphRSePrwTtAfc1APJ5lKy/cLBgJp5xtPyIIewYkqIW4jac/DyOaxynwfR0AZIoS
	 5d3OI6FcAvoE63KRnfx4P386eSb4pAk/Jqc0yQ9KNbU3UdhsWE6Wj51WQ4+OQR+t3/
	 HsttmUrN6PIOGuK6wgJDPcjBmfVijhGKVDFSzxzPXwegekbIIb78uWqixWeG6EFDQZ
	 /4ELyGD0BXK5EdcuqVZgBINiJH0DSTWj/mHakaTPrcSM3YcBQ+IkdztDIUcsHb2fFu
	 AwXS6sE3BDcUw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ian Abbott <abbotti@mev.co.uk>,
	Jaeyoung Chung <jjy600901@snu.ac.kr>,
	Sangyun Kim <sangyun.kim@snu.ac.kr>,
	Kyungwook Boo <bookyungwook@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	hsweeten@visionengravers.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] comedi: pcm711: Fix sanity check in interrupt handler
Date: Mon, 19 Oct 2026 09:50:52 -0400
Message-ID: <20261019135441.1420968-361-sashal@kernel.org>
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

[ Upstream commit f876cbfe3e066bc9e3f3210907bd534be82946c8 ]

The driver requests an interrupt handler for the device before it is
fully set up.

For safety, the interrupt handler checks the dev->attached flag to
ensure the device is fully set up, but it currently does that after
dereferencing the dev->read_dev pointer which may be NULL if
dev->attached is false.  Move the check to avoid the possible null
pointer dereference.

Reported-by: Jaeyoung Chung <jjy600901@snu.ac.kr>
Link: https://lore.kernel.org/lkml/20260610115912.780131-1-jjy600901@snu.ac.kr/
Reported-by: Sangyun Kim <sangyun.kim@snu.ac.kr>
Reported-by: Kyungwook Boo <bookyungwook@gmail.com>
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Link: https://patch.msgid.link/20260618102949.26607-7-abbotti@mev.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local tree is **7.3.0-rc4** (`v7.3-rc4-27-gf0100363d8c37`). This is
a 3-line interrupt-handler reorder that stops a NULL dereference of
`dev->read_subdev` / `s->async` if an IRQ fires during
`pcl711_attach()`, before `dev->attached` is set.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**
Record: `[comedi/pcl711] [Fix] sanity check in interrupt handler`
- Subsystem: `comedi` (COMEDI data-acquisition), driver `pcl711`
  (Advantech PCL-711 / ADLink ACL-8112). Subject says `pcm711`; the file
  is `pcl711.c` (typo, same as other patches in the series).
- Action verb: **Fix** — explicit bug fix.

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- `Fixes:` — none (expected for this review)
- `Reported-by: Jaeyoung Chung <jjy600901@snu.ac.kr>`
- `Reported-by: Sangyun Kim <sangyun.kim@snu.ac.kr>`
- `Reported-by: Kyungwook Boo <bookyungwook@gmail.com>`
- `Link: https://lore.kernel.org/lkml/20260610115912.780131-1-
  jjy600901@snu.ac.kr/` (original report)
- `Link:
  https://patch.msgid.link/20260618102949.26607-7-abbotti@mev.co.uk`
  (patch 06/11)
- `Signed-off-by: Ian Abbott <abbotti@mev.co.uk>` (COMEDI maintainer)
- `Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>`
- No `Cc: stable`, no `Tested-by`, no `Reviewed-by`, no `Acked-by`
- Notable: **three reporters**; original mail describes a **KASAN null-
  ptr-deref / kernel panic**.

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** IRQ handler is registered in `pcl711_attach()` before the
  device is fully set up. The handler already checks `dev->attached`,
  but only **after** `cmd = &s->async->cmd`, which dereferences
  `dev->read_subdev` (commit text says `read_dev`; code is
  `read_subdev`).
- **Symptom:** NULL pointer dereference in interrupt context →
  oops/panic. Original report: “triggering a KASAN null-ptr-deref”.
- **Root cause:** `request_irq()` runs before `dev->read_subdev` is
  assigned and before core postconfig sets `dev->attached` and allocates
  `s->async`.
- **Version info:** none in the message. The buggy deref has been in
  this handler since the 3.13/3.16-era staging rework.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not hidden. Subject and body both say this is a null-ptr-deref
fix. Cover letter: “Add/fix sanity check in ISA drivers to avoid null-
ptr-deref”.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**
Record:
- File: `drivers/comedi/drivers/pcl711.c` (+2 / −1)
- Function: `pcl711_interrupt()`
- Scope: single-file surgical fix, 3 lines

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:
- **Before:** `s = dev->read_subdev;` then immediately `cmd =
  &s->async->cmd;` then `if (!dev->attached) return;`. If `s` is NULL,
  that second line oopses. If `s` is set but `s->async` is not yet
  allocated (postconfig), same oops.
- **After:** declare `cmd` uninitialized; check `dev->attached` first;
  only then `cmd = &s->async->cmd`.
- Path: interrupt / attach-time error path, not the steady-state sample
  path.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record:
- **Category:** NULL pointer dereference (memory safety)
- **Mechanism:** `pcl711_attach()` calls `request_irq()` at line 431,
  then later sets `dev->read_subdev` at line 457. Core sets
  `dev->attached = true` only in `comedi_device_postconfig()` after
  `__comedi_device_postconfig_async()` allocates `s->async`. A premature
  IRQ (pending line, wrong ISA IRQ/I/O config, leftover hardware state)
  hits the handler with `read_subdev` and/or `s->async` still NULL.

**Step 2.4: ASSESS THE FIX QUALITY**
Record:
- Obviously correct: the existing guard is just moved before the first
  dereference of `s`.
- Minimal; no API, locking, or data-structure change.
- Regression risk: very low. After `attached` is true, attach has
  assigned `read_subdev` (when IRQ was requested) and postconfig has
  allocated `s->async`.
- Residual: `s = dev->read_subdev` still runs before the check, but that
  is a pointer load, not a dereference. Same unlocked `dev->attached`
  read as the rest of COMEDI; this patch does not make that worse.
- Typos in subject/body (`pcm711`, `read_dev`) do not affect the code.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**
Record:
- `if (!dev->attached)`: original handler, David Schleef, 2009
  (`456af2011ce33e`).
- `s = dev->read_subdev`: `8f494fe626b473` (2013-09-25), first in
  **v3.13-rc1**.
- `cmd = &s->async->cmd` before the attached check: `ae2348e2282452`
  (2014-05-27), first in **v3.16-rc1**.
- Long-standing bug, not recent code.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No `Fixes:` tag. Not applicable. Introducers above are in this
tree’s history.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record:
- `f876cbfe3e066` — this fix
- `7e33ddd6d0282` — I/O-base sanity checks (unrelated)
- No later commits on `pcl711.c` after this fix
- Sibling series (same author, same day): dt2811, ni_at_a2150, pcl816,
  pcl818, pcmmio, pcmuio, quatech_daqp_cs, aio_iiro_16, das6402,
  ni_atmio16d
- Standalone for this file: patch 06/11, no dependency on the other
  patches

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Ian Abbott is **COMEDI maintainer** (`MAINTAINERS`: COMEDI
DRIVERS, status Odd Fixes). He wrote this series and the earlier
`17221216ae8ce` (`comedi_parport: deal with premature interrupt`) for
the same report.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: None. Uses `dev->attached`, `read_subdev`, `s->async->cmd` — all
present for years. Applies standalone.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 dig -c f876cbfe3e066`:
  https://patch.msgid.link/20260618102949.26607-7-abbotti@mev.co.uk
- `b4 dig -a`: **v1 only** (11-patch series, 2026-06-18)
- Cover: “several comedi ISA drivers register their interrupt handler
  before initializing the subdevice … null pointer dereferences if the
  device raises an interrupt prematurely.”
- No NAKs, no review comments, no explicit `Cc: stable` in the thread
  (mbox is patches only, no replies)
- Applied as submitted by Greg KH (char-misc), 2026-07-17

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record (`b4 dig -w`):
- To: linux-kernel
- Cc: Greg Kroah-Hartman, H Hartley Sweeten (co-maintainer), the three
  reporters
- No Reviewed-by. Quality signal is that the **subsystem maintainer
  authored it** and Greg applied it.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: Fetched https://lore.kernel.org/lkml/20260610115912.780131-1-
jjy600901@snu.ac.kr/raw
- Jaeyoung Chung (SNU): several ISA drivers register the IRQ before
  `read_subdev` is set.
- “If the device raises an interrupt before the subdevice is
  initialized, the handler runs against an uninitialized subdevice,
  causing a **kernel panic**.”
- Names `pcl711_interrupt()` / `pcl711_attach()` explicitly; KASAN null-
  ptr-deref.
- Suggested fix: move `request_irq()` later **or** guard NULL
  `read_subdev`. Maintainer chose the existing `dev->attached` pattern.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: 11 independent per-driver patches. This one only needs
`pcl711.c`. `comedi_parport` was already fixed separately
(`17221216ae8ce`).

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: lore.kernel.org/stable searches for “pcm711”, “Fix sanity check
in interrupt handler”, and “comedi null-ptr-deref” found **no discussion
of this 2026 fix**. (Older “pcl711 sanity” hits are unrelated 2021
stable reviews.)

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS**
Record: `pcl711_interrupt()` (handler); setup in `pcl711_attach()`.

**Step 5.2: TRACE CALLERS**
Record:
- Registered via `request_irq(..., pcl711_interrupt, 0, ...)` in
  `pcl711_attach()` (non-shared).
- Invoked from IRQ context when the configured ISA IRQ fires.
- `pcl711_interrupt` has no other callers.

**Step 5.3: TRACE CALLEES**
Record: `pcl711_ai_get_sample()` (port I/O),
`comedi_buf_write_samples()`, `comedi_handle_events()`, `outb()` to
clear IRQ status. After the fix, those run only if `dev->attached`.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: Userspace `COMEDI_DEVCONFIG` → `pcl711_attach()` →
`request_irq()`. Reachable from the comedi ioctl path when
`CONFIG_COMEDI_PCL711` is enabled and an IRQ is in the config options.
Wrong ISA IRQ/I/O (the report’s realistic case) can fire the handler
during that window. Unprivileged trigger: only if the user can configure
the comedi device (typically privileged). Failure is still a kernel
oops.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: Same bug class across the 11-driver series. `ni_660x.c` even
comments “make sure `dev->attached` is checked before doing anything
else.” This is a systematic COMEDI ISR pattern, not a one-off.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record:
- Tree: **7.3.0-rc4** (`git describe HEAD` =
  `v7.3-rc4-27-gf0100363d8c37`).
- `git merge-base --is-ancestor f876cbfe3e066 HEAD` → yes. Fix landed in
  **v7.3-rc1** (not in v7.2).
- Driver and handler exist: `drivers/comedi/drivers/pcl711.c`. Pre-fix
  form (deref then attached check) is in `f876cbfe3e066^`.
- Bug introduced ~v3.13/v3.16; present in every current stable lineage
  that has this driver.
- HEAD already has the fixed handler (lines 183–209). That does not make
  the fix unsuitable for older trees of this lineage.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: Clean apply. The function body has been stable since 2014 aside
from this reorder. No conflicting local changes. `CONFIG_COMEDI_PCL711`
exists.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: This commit is the fix; no later pcl711 ISR change.
`comedi_parport` premature-IRQ fix is a sibling, not a substitute.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: `drivers/comedi/` — ISA/PC-104 DAQ. **PERIPHERAL / config-
specific** (`CONFIG_COMEDI_PCL711`, depends on ISA/PC104 +
`HAS_IOPORT`). Not core mm/net/fs, but a real in-tree driver with users.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: “Odd Fixes”; Ian Abbott still sends targeted fixes. Mature
driver, old bug, small patch.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: Users of Advantech PCL-711/711B and ADLink ACL-8112 with IRQ
enabled. Config- and hardware-specific, not universal.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record:
- Window: after `request_irq()` in `pcl711_attach()`, before
  `read_subdev` assignment and before `dev->attached = true` in
  postconfig.
- How common: not every boot; ISA leftover IRQ, wrong IRQ/I/O in comedi
  config, or a pending line. Cover letter/report treat that as the
  failure mode.
- Unprivileged: generally no (device config is privileged). Still a
  kernel oops if it fires.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record: NULL deref in IRQ context → **oops/panic**. Original report:
kernel panic / KASAN null-ptr-deref. **Severity: HIGH** (crash; not a
hot-path UAF, but a hard crash).

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record:
- **Benefit:** HIGH for affected hardware — prevents attach-time oops.
  Medium globally (small user base).
- **Risk:** VERY LOW — 3-line reorder of an existing check; no lock/API
  change.
- **Ratio:** benefit outweighs risk. Stable rules favor small crash
  fixes even in niche drivers.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

FOR backporting:
- Real NULL deref in IRQ handler → kernel panic (KASAN report).
- Three reporters; maintainer-authored; Greg applied it.
- 3-line, obviously correct reorder of an existing guard.
- Bug present since ~2013/2014; driver exists in this tree.
- Standalone; no prerequisites; applies cleanly.
- Same pattern already used elsewhere in COMEDI (`dev->attached` first).

AGAINST:
- Niche ISA DAQ (`CONFIG_COMEDI_PCL711`); not a universal path.
- Trigger is attach-time premature IRQ, not every sample.
- No `Fixes:` / `Cc: stable` (not a negative under these rules).
- No mailing-list review beyond the maintainer.

UNRESOLVED:
- No on-list replies in the saved mbox (Greg applied v1). Does not
  change correctness.
- lore WebFetch returned 403; report body was retrieved via raw URL
  instead.

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — reorder of an existing
   check; maintainer + three reporters.
2. Fixes a real bug that affects users? **PASS** — NULL deref / panic on
   premature IRQ during attach.
3. Important issue? **PASS** — kernel oops in interrupt context (HIGH).
4. Small and contained? **PASS** — +2/−1 in one function.
5. No new features or APIs? **PASS**.
6. Can apply to the local tree? **PASS** — same `pcl711_interrupt()`
   structure; this tree already contains equivalent code.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: Not a device-ID/quirk/DT/build/docs exception. Ordinary small
crash fix.

**Step 9.4: MAKE YOUR DECISION**
This is a surgical NULL-deref fix in an interrupt handler. The buggy
code has been in this driver for over a decade, the failure is a kernel
oops, and the patch only moves a check that was already there. It meets
stable-kernel rules for this tree.

===============================================================
Why it matters to stable users
===============================================================
COMEDI attach registers `pcl711_interrupt` before `read_subdev` and
`s->async` exist and before `dev->attached` is set. A premature IRQ then
executes `cmd = &s->async->cmd` on a NULL pointer and panics. Moving the
attached check first closes that window without changing normal
sampling.

Risk vs benefit: three lines, no semantic change on the success path,
crash avoided on the attach/error path. Safe to backport.

Verification:
- [Phase 1] Parsed tags: three Reported-by (SNU); lore link to original
  report; maintainer + Greg SOBs; no Fixes/Cc-stable
- [Phase 1] Cover letter: explicit null-ptr-deref if IRQ fires before
  subdevice init
- [Phase 2] Diff: +2/−1 in `pcl711_interrupt()`; delay `cmd =
  &s->async->cmd` until after `dev->attached`
- [Phase 2] Confirmed pre-fix parent still dereferenced `s->async`
  before the attached check
- [Phase 3] Blame: attached check 2009; `read_subdev` in ISR v3.13
  (`8f494fe626b473`); `cmd = &s->async->cmd` v3.16 (`ae2348e2282452`)
- [Phase 3] No Fixes tag; `git merge-base --is-ancestor f876cbfe3e066
  HEAD` succeeded
- [Phase 3] Author is COMEDI maintainer; series of 11 independent per-
  driver patches
- [Phase 4] `b4 dig -c`:
  https://patch.msgid.link/20260618102949.26607-7-abbotti@mev.co.uk
- [Phase 4] `b4 dig -a`: v1 only, no later revision
- [Phase 4] `b4 dig -w`: Greg KH, Hartley Sweeten, reporters on Cc
- [Phase 4] Original report raw: names `pcl711_interrupt`, KASAN null-
  ptr-deref, kernel panic
- [Phase 4] stable list: no discussion of this 2026 fix
- [Phase 5] Only caller is `request_irq` in `pcl711_attach()` (line
  431); `read_subdev` assigned at line 457; `attached` set in
  `comedi_device_postconfig()` after async alloc
- [Phase 5] No semcode MCP; used grep/read
- [Phase 6] `git describe HEAD`: v7.3-rc4-27-gf0100363d8c37; `make
  kernelversion`: 7.3.0-rc4
- [Phase 6] Commit in v7.3-rc1, not v7.2; driver present; no post-fix
  pcl711 churn
- [Phase 8] Failure mode: IRQ-context NULL deref → oops/panic, severity
  HIGH
- UNVERIFIED: live hardware reproduction (code-path analysis + reporter
  KASAN writeup only)
- UNVERIFIED: lore HTML (403); raw mbox succeeded

**YES**

 drivers/comedi/drivers/pcl711.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/comedi/drivers/pcl711.c b/drivers/comedi/drivers/pcl711.c
index 0cf3917defe79..33407da84ef45 100644
--- a/drivers/comedi/drivers/pcl711.c
+++ b/drivers/comedi/drivers/pcl711.c
@@ -181,7 +181,7 @@ static irqreturn_t pcl711_interrupt(int irq, void *d)
 {
 	struct comedi_device *dev = d;
 	struct comedi_subdevice *s = dev->read_subdev;
-	struct comedi_cmd *cmd = &s->async->cmd;
+	struct comedi_cmd *cmd;
 	unsigned short data;
 
 	if (!dev->attached) {
@@ -189,6 +189,7 @@ static irqreturn_t pcl711_interrupt(int irq, void *d)
 		return IRQ_HANDLED;
 	}
 
+	cmd = &s->async->cmd;
 	data = pcl711_ai_get_sample(dev, s);
 
 	outb(PCL711_INT_STAT_CLR, dev->iobase + PCL711_INT_STAT_REG);
-- 
2.53.0

