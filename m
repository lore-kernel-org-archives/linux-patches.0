Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFD1853874F;
	Mon, 19 Oct 2026 14:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418680; cv=none; b=hieDDk7VYHqZESHBCrbKrFrtKbryiHpXLJdjquC9pXK6VovaRDDnF0eCmX9XzdgPcQrgBor5nVNzo+uXhj9WZm2rrctdMWDRpEXHhNONehcq3rZT96XLSfBBIjn6EhBLiGAwxHZxHWq9W2IAuSoQSzYJikOcxQdQA8jtPfaTkYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418680; c=relaxed/simple;
	bh=92yfff09+yvs9metrWfc5YQuesSJJbtmG40b2V84F6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Kcx/8zqX6x9i8PHo02rzPj38a+Cq2CM0LElMeXREmmiLX27fxHP9bclfUv0fOLTRXcV74kOccEbDjKmVCSXZu//0C3EoWil+pwCUq/OGPyH0eimE7IULiRm26Vf/+nD66nX3qjFnw2CF9lsxXyDOo5PL/UbSdNAPXLXK8maWhDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RtRFL7nA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RtRFL7nA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A63A21F000C6;
	Mon, 19 Oct 2026 14:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418673;
	bh=qip7GubNeeIoI+UNFFiRLzIhcMV2s1Sly8t3a9nUNLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RtRFL7nAFJOXPd+wJJ9Z55NeU9GwoytbCXrpJzB6RySfzWY7v8KxRmsLn6/e4Dd5Y
	 hwLYd1GmFZrJJRaJE/RZmRVgLc+N69xL/ribkonSc9ncNQUsv+8np8xs1RRfYTv12K
	 y901jXdCwzQkyt1dPl7eP813GlGgpPjj7VHFN9gsOZ9exEBmIwNaDVdDTmoQgqLjxB
	 KeOQFr3SaDuKiqn5xCh7UEDlkI7OrOWd6fjU67qS6+IfTjc/bui98hHf9gJpi3HIfg
	 tD4iCJr2h23ZD0+Z2rtaRtpHfeW1UZKMLZUjW5TdQu8MfblZuGwt/Sq9GlJG6pIeJj
	 ESrHLoUHnRchQ==
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
Subject: [PATCH AUTOSEL 6.18-5.10] comedi: pcmmio: Add sanity check to interrupt handler
Date: Mon, 19 Oct 2026 09:51:47 -0400
Message-ID: <20261019135441.1420968-416-sashal@kernel.org>
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

[ Upstream commit ea72e2fc9026f375314421ddfa4dbdc49432a899 ]

The driver requests an interrupt handler for the device, after setting
device registers to disable interrupt generation.  The interrupt handler
should not be called prematurely unless the user-configured I/O port
base address and/or IRQ number are incorrect or the hardware is bad.

For safety, check the dev->attached flag in the interrupt handler to
ensure the device has been fully set up, avoiding a possible null
pointer dereference of dev->read_subdev.

Reported-by: Jaeyoung Chung <jjy600901@snu.ac.kr>
Link: https://lore.kernel.org/lkml/20260610115912.780131-1-jjy600901@snu.ac.kr/
Reported-by: Sangyun Kim <sangyun.kim@snu.ac.kr>
Reported-by: Kyungwook Boo <bookyungwook@gmail.com>
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Link: https://patch.msgid.link/20260618102949.26607-10-abbotti@mev.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This is a 3-line IRQ-handler guard against a KASAN NULL deref in an
existing COMEDI driver. The local tree is **Linux 7.3.0-rc4**
(`v7.3-rc4-27-gf0100363d8c37`). The driver and the buggy attach/IRQ
ordering are present here; the patch is self-contained.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**
Record: **[comedi: pcmmio:] [Add] [sanity check in `interrupt_pcmmio()`
so a premature IRQ cannot dereference a NULL `dev->read_subdev`]**

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- **Fixes:** none (expected for this review)
- **Cc: stable:** none (expected; not a negative signal)
- **Reported-by:** Jaeyoung Chung `<jjy600901@snu.ac.kr>`; Sangyun Kim
  `<sangyun.kim@snu.ac.kr>`; Kyungwook Boo `<bookyungwook@gmail.com>`
  (three reporters)
- **Link:** https://lore.kernel.org/lkml/20260610115912.780131-1-
  jjy600901@snu.ac.kr/ (original KASAN/NULL-deref report)
- **Link:**
  https://patch.msgid.link/20260618102949.26607-10-abbotti@mev.co.uk
  (patch 09/11 of Ian Abbott’s series; msgid `-10` is 0-based git-send-
  email numbering)
- **Signed-off-by:** Ian Abbott (author, COMEDI maintainer); Greg Kroah-
  Hartman (COMEDI co-maintainer / applied the patch)
- Ignore pipeline SOBs/upstream markers if present.

Notable: three reporters and an explicit KASAN NULL-deref report that
names `pcmmio.c`.

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** `pcmmio_attach()` calls `request_irq()` after disabling board
  interrupt generation, but **before** subdevices are allocated and
  before `dev->read_subdev` is set. `dev->attached` is only set later in
  `comedi_device_postconfig()`.
- **Symptom:** premature IRQ → `interrupt_pcmmio()` uses a NULL
  `read_subdev` → NULL deref in `pcmmio_handle_dio_intr()`.
- **Trigger (author):** should not happen on good hardware with a
  correct I/O base and IRQ; can happen if the user-configured I/O
  base/IRQ is wrong or the hardware is bad.
- **Root cause:** IRQ handler registered before the comedi device is
  fully set up.
- **Version info:** none in the message. Driver dates to 2009.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: **Not a disguised cleanup.** Subject says “Add sanity check”;
body describes a NULL deref. Cover letter: “Add/fix sanity check in ISA
drivers to avoid null-ptr-deref.”

===============================================================
PHASE 2: DIFF ANALYSIS
===============================================================

**Step 2.1: INVENTORY THE CHANGES**
Record:
- **File:** `drivers/comedi/drivers/pcmmio.c` — **+3 / −0**
- **Function:** `interrupt_pcmmio()`
- **Scope:** single-file, surgical

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:
- **Before:** handler always copies `s = dev->read_subdev`, then `inb()`
  of the pending register; if any pending bits are set, calls
  `pcmmio_handle_dio_intr(dev, s, triggered)`.
- **After:** if `!dev->attached`, return `IRQ_NONE` before touching the
  pending register or `s`.
- **Path:** IRQ during attach (and any other time `attached` is false).
  Not a new userspace API.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record: **[NULL pointer dereference / memory safety]**
- `pcmmio_handle_dio_intr()` does `struct comedi_cmd *cmd =
  &s->async->cmd;` as its first real use of `s`. If `s` is NULL, that is
  a kernel oops.
- `s = dev->read_subdev` is only a pointer copy; the crash is the later
  use. The attached check sits before that use.
- `pcmmio_attach()` order (verified in this tree): `pcmmio_reset()` →
  `request_irq(..., interrupt_pcmmio, ...)` →
  `comedi_alloc_subdevices()` → `dev->read_subdev = s`.
  `comedi_device_attach()` then calls `comedi_device_postconfig()`,
  which sets `dev->attached = true` last.

**Step 2.4: ASSESS THE FIX QUALITY**
Record:
- **Quality:** matches the long-standing COMEDI pattern (`if
  (!dev->attached) return IRQ_NONE;`) used in many drivers (`das800`,
  `comedi_parport`, `ni_660x`, etc.).
- **Minimal:** three lines, no API/data-structure change.
- **Regression risk:** very low. Returning `IRQ_NONE` for an unattached
  device is correct (this IRQ is requested with flags `0`, not shared).
- **Not a follow-up candidate:** sibling “Fix sanity check” patches
  moved an *existing* attached test *before* a real dereference
  (`s->async->cmd`). Here the new test is before `s` is used. No later
  pcmmio follow-up exists on this file.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**
Record:
- Handler introduced with the driver: `6baef150380d5` (“Staging: comedi:
  add pcmmio and pcmuio drivers”, 2009-04-03, contained in v2.6.30-rc1).
- `s = dev->read_subdev` from `19e0bf12358e59` (2013).
- Driver left staging in `8ffdff6a8cfbd` (2021-04-15, v5.13).
- Buggy ordering (IRQ before `read_subdev`) has been in this code for
  many years, including this 7.3 tree.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: **No Fixes: tag.** Bug is the original attach/IRQ ordering, not
a recent regression.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record:
- Same-file recent commit: `78ba300a99917` “comedi: pcmmio: Add sanity
  checks for I/O base address” — **independent**; this IRQ patch does
  not use that helper.
- This commit is standalone. Cover letter lists it as **9/11**; each
  patch is a different driver. No shared helper, no data-structure
  prerequisite.
- No later pcmmio commits after `ea72e2fc9026f` on this file.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Ian Abbott is **the COMEDI maintainer**. Same-day series
adds/fixes the same attached check in aio_iiro_16, das6402, dt2811,
ni_at_a2150, ni_atmio16d, pcl711, pcl816, pcl818, pcmmio, pcmuio,
quatech_daqp_cs. Earlier `17221216ae8ce` (“comedi: comedi_parport: deal
with premature interrupt”) is the same class, and that one had syzbot +
`Cc: stable`.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: **None required.** `dev->attached` and `interrupt_pcmmio()`
exist in this tree. Patch applies as a 3-line insertion.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- **b4 dig:**
  https://patch.msgid.link/20260618102949.26607-10-abbotti@mev.co.uk
- **Series:** v1 only (`[PATCH 01/11]` … `11/11`), 2026-06-18. No v2/v3.
- **Cover letter:** “comedi: Add/fix sanity check in ISA drivers to
  avoid null-ptr-deref”. Names pcmmio among the reported drivers.
- **Mbox:** 12 messages, all from the author (cover + 11 patches). **No
  replies, no NAK, no reviewer Cc: stable.** Greg applied the series.
- Lore HTML fetch returned **403**; discussion recovered via `b4 dig -m`
  and `b4 mbox`.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record (**b4 dig -w**): To/Cc were Ian Abbott, linux-kernel, Greg Kroah-
Hartman, H Hartley Sweeten, and the three reporters. Maintainers were on
the original mail. No extra Reviewed-by/Acked-by.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record (original mail, msgid
`20260610115912.780131-1-jjy600901@snu.ac.kr`):
- Subject: **“comedi: KASAN null-ptr-deref in ISA driver IRQ handlers on
  early IRQ”**
- Explicitly lists **pcmmio.c / `interrupt_pcmmio()` /
  `pcmmio_attach()`**
- Mechanism: `request_irq()` before `dev->read_subdev = s`; handler then
  uses a NULL subdevice
- Suggested fix: move `request_irq()` later **or** guard the handler
- Ian chose the established attached-flag guard (same as many other
  COMEDI drivers)

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: 11 independent per-driver patches. This one does not need the
others. The parport sibling (`17221216ae8ce`) already has `Cc: stable`
because syzbot hit `comedi_parport`. Same bug class.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: **UNVERIFIED** for lore.kernel.org/stable (HTTP 403). The
submission mbox has no stable-list discussion.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

**Step 5.1: IDENTIFY KEY FUNCTIONS**
Record: `interrupt_pcmmio()` modified; callees of interest:
`pcmmio_handle_dio_intr()`, `pcmmio_attach()`.

**Step 5.2: TRACE CALLERS**
Record:
- `interrupt_pcmmio` is registered only from `pcmmio_attach()` via
  `request_irq(it->options[1], interrupt_pcmmio, 0, ...)`.
- Attach is reached from `comedi_device_attach()` ←
  `do_devconfig_ioctl()` (COMEDI_DEVCONFIG). That ioctl requires
  **`CAP_SYS_ADMIN`**.
- Context: hard IRQ. Not a hot syscall path for unprivileged users.

**Step 5.3: TRACE CALLEES**
Record: `inb()` of `PCMMIO_INT_PENDING_REG`; `pcmmio_dio_read/write`;
`pcmmio_handle_dio_intr()` which immediately does `&s->async->cmd`.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record:
- Reachable from userspace **with CAP_SYS_ADMIN**: load `pcmmio`,
  `COMEDI_DEVCONFIG` with an IRQ in `options[1]`.
- Crash window: IRQ between `request_irq()` and `dev->attached = true`.
- If the pending register reads as zero, the old handler returned
  `IRQ_NONE` without using `s`. The NULL deref needs a premature IRQ
  **and** a non-zero pending read (wrong I/O base returning garbage, or
  bad/mis-routed hardware). That is exactly the ISA comedi_config model,
  and it is how syzbot hit parport.
- **Not** unprivileged-triggerable. Still a real kernel oops on a
  supported ioctl.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: dozens of COMEDI IRQ handlers already check `dev->attached`.
This is aligning pcmmio with that pattern, not inventing a new one.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: **Yes.**
- Tree: **7.3.0-rc4** (mainline-like checkout, detached HEAD).
- `drivers/comedi/drivers/pcmmio.c` exists; `pcmmio_attach()` still
  requests the IRQ before `read_subdev` and before postconfig sets
  `attached`.
- Commit `ea72e2fc9026f` **is** an ancestor of HEAD (`git merge-base
  --is-ancestor` exit 0). That is expected for a mainline candidate; it
  is **not** used as “already selected for stable.”
- Bug introduced ~2009, not after this tree branched.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: **Clean apply.** Hunk is a 3-line insert into a handler whose
shape has been stable since 2013. No refactor of this function in this
tree beyond this commit.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: This is the fix. No alternate pcmmio IRQ NULL-deref fix. The
I/O-base check (`78ba300a99917`) is a different issue and is not
required for this hunk.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: **[drivers/comedi — COMEDI DAQ]** **[PERIPHERAL]**
Winsystems PCM-MIO PC/104 board (`CONFIG_COMEDI_PCMMIO`). Niche
industrial hardware, but a real in-tree driver (out of staging since
v5.13).

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: Mature. Ian Abbott still actively fixing ISA attach/IRQ races in
2026. Not staging.

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: **driver-specific / config-specific** — users who load `pcmmio`
and attach it with an IRQ via comedi_config.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record:
- Trigger: attach with `options[1]` (IRQ) set; IRQ fires before
  `attached`; pending register reads non-zero.
- Likelihood on correctly jumpered good hardware: low (driver disables
  interrupt generation before `request_irq()`).
- Likelihood with wrong I/O base/IRQ (admin ioctl, fuzzer, bad card):
  realistic. Original report treated it as a KASAN NULL deref across
  several ISA drivers, including this one.
- Unprivileged: **no** (CAP_SYS_ADMIN for COMEDI_DEVCONFIG).

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record: **Kernel oops / KASAN null-ptr-deref** → **HIGH** (crash of the
machine or at least the IRQ path; not data corruption on a mounted fs,
but a serious crash).

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record:
- **Benefit:** prevents a documented NULL deref oops on a long-lived
  driver. High for anyone who hits it; population is small.
- **Risk:** very low (3 lines, established pattern, IRQ_NONE on
  unattached device).
- **Ratio:** favorable. Small crash fixes in obscure drivers are
  standard stable material.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

**FOR backporting:**
- Real NULL deref in an IRQ handler; original report is titled as KASAN
  null-ptr-deref and names this file.
- Three reporters; maintainer-authored; applied by Greg KH.
- 3-line, obviously correct, same pattern as many other COMEDI drivers.
- Buggy ordering has been in the driver since 2009; present in this
  tree.
- Standalone; no prerequisites; clean apply.
- Sibling parport fix of the same class was nominated for stable
  (syzbot).
- Sanitizer-class crash; stable rules treat serious crashes as in-scope
  even for niche drivers.

**AGAINST:**
- Niche PC/104 board; interrupt support in the driver comments is
  “untested.”
- Author frames it as “for safety” and says a premature IRQ needs bad
  config/hardware.
- Needs CAP_SYS_ADMIN to attach.
- No Fixes:/Cc: stable on this specific commit (absence is expected
  here; still a weaker signal than parport).
- No mailing-list review replies.

**UNRESOLVED:**
- Could not search lore.kernel.org/stable (403).
- Original report has no pcmmio-specific reproducer/stack in the mail
  body (code analysis + KASAN class).

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — 3-line attached check,
   established COMEDI idiom; applied by subsystem maintainers.
2. Fixes a real bug that affects users? **PASS** — NULL deref if IRQ
   runs before attach completes; reported against this driver.
3. Important issue? **PASS** — kernel oops / KASAN null-ptr-deref (HIGH,
   not a core-mm panic, but a serious crash).
4. Small and contained? **PASS** — +3 lines, one function.
5. No new features or APIs? **PASS**.
6. Can apply to the local tree? **PASS** — file and handler exist; hunk
   is trivial.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: none (not a device ID, quirk, DT, build, or docs exception). It
qualifies as a normal crash fix.

**Step 9.4: MAKE YOUR DECISION**
This tree has the driver, the attach/IRQ race, and the NULL deref path.
The patch is a minimal, standard guard. Privilege and niche hardware
lower the blast radius; they do not make a KASAN NULL deref in an IRQ
handler unsuitable for stable.

===============================================================
What the commit solves, and why it matters here
===============================================================

`pcmmio_attach()` registers `interrupt_pcmmio` before subdevices exist
and before `dev->attached` is set. If that handler runs in that window
and the pending register is non-zero, `pcmmio_handle_dio_intr()`
dereferences a NULL `read_subdev` (`s->async->cmd`) and oopses. The
patch returns `IRQ_NONE` until the device is fully attached.

That matches the original SNU report and the usual COMEDI IRQ-safety
pattern. For this 7.3 checkout the code exists, the fix is three lines,
and regression risk is negligible.

===============================================================
Verification
===============================================================
- **[Phase 1]** Parsed tags: three Reported-by; two Links; no Fixes:/Cc:
  stable; SOBs Ian Abbott + Greg KH.
- **[Phase 1]** Cover letter (mbox): series is explicitly “avoid null-
  ptr-deref”; pcmmio is listed.
- **[Phase 2]** Diff: +3 lines in `interrupt_pcmmio()` only.
- **[Phase 2]** Read `pcmmio_attach()`: `request_irq` at line 688,
  `read_subdev` at 749; `comedi_device_postconfig()` sets `attached`
  after `attach()` returns.
- **[Phase 2]** Read `pcmmio_handle_dio_intr()`: first use of `s` is
  `&s->async->cmd`.
- **[Phase 3]** `git blame`: handler from 2009 (`6baef150380d5`); this
  check from `ea72e2fc9026f`.
- **[Phase 3]** `git log --oneline -20 --
  drivers/comedi/drivers/pcmmio.c`: no later pcmmio follow-up.
- **[Phase 3]** No Fixes: tag to follow.
- **[Phase 4]** `b4 dig -c ea72e2fc9026f`: lore URL
  `20260618102949.26607-10-abbotti@mev.co.uk`.
- **[Phase 4]** `b4 dig -a`: v1 series only, 11 patches.
- **[Phase 4]** `b4 dig -w`: Greg KH + Hartley Sweeten + reporters on
  Cc.
- **[Phase 4]** `b4 mbox` of
  `20260610115912.780131-1-jjy600901@snu.ac.kr`: KASAN report names
  `interrupt_pcmmio`.
- **[Phase 4]** UNVERIFIED: lore.kernel.org HTML and stable@ search
  (403).
- **[Phase 5]** Callers: only `request_irq` from `pcmmio_attach`; ioctl
  path needs CAP_SYS_ADMIN (`do_devconfig_ioctl`).
- **[Phase 6]** `git describe HEAD` / `make kernelversion`:
  **7.3.0-rc4**.
- **[Phase 6]** `git merge-base --is-ancestor ea72e2fc9026f HEAD`: yes
  (candidate is in this history).
- **[Phase 8]** Failure mode: NULL deref oops in IRQ handler; severity
  HIGH.
- **UNVERIFIED:** live reproduction on PCM-MIO hardware (not available).

The fix is small, surgical, and meets the stable criteria for a real
crash.

**YES**

 drivers/comedi/drivers/pcmmio.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/comedi/drivers/pcmmio.c b/drivers/comedi/drivers/pcmmio.c
index c2402239d5513..db9cb3fedb48d 100644
--- a/drivers/comedi/drivers/pcmmio.c
+++ b/drivers/comedi/drivers/pcmmio.c
@@ -362,6 +362,9 @@ static irqreturn_t interrupt_pcmmio(int irq, void *d)
 	unsigned int triggered;
 	unsigned char int_pend;
 
+	if (!dev->attached)
+		return IRQ_NONE;
+
 	/* are there any interrupts pending */
 	int_pend = inb(dev->iobase + PCMMIO_INT_PENDING_REG) & 0x07;
 	if (!int_pend)
-- 
2.53.0

