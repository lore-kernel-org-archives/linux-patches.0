Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D032572660;
	Mon, 19 Oct 2026 13:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418375; cv=none; b=kAbw9aWtyCdRl7ksKgia69v48zHIIowiTnv0CfSrxLd8tOPFCf2Gt7iVCEK7/llNYbIuXs/xH66FGZrIZnNFVr7YsjzeGFqS6ZosV2GgUSwTg2Ypeq+BA5+Ul3UIw9TLNiBA9ZxY39TqB5+MK5NAXBzIGD9dhK98ELGP6s6Kqo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418375; c=relaxed/simple;
	bh=7fOGAx/Tg/jYcpfn+BboBDM5m3UlT4OV4GNAjWvkG1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VF4yfN2FNmR7nDz8mFVB0XfwFqi8OtBWqxeUYeV5ngSvGBLKIBiLWsDUqa8eoksspMHrjEuPw0j6MPFsGtOyZTrpLX8i08U+I/jDY7iHgw3KkOf4R4pwtI1QDDlrMcIRHz212aQQmPDHDd5sZR2LfK6De/KA/btWQ7CPLR5vtQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dJbFAI27; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dJbFAI27"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A5EC1F000CB;
	Mon, 19 Oct 2026 13:59:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418373;
	bh=HW6Xp/j1e07UOty9M9psgcYYtqz/Wuq9HNxVQFuKvv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dJbFAI27d9Co9FBGmKJWPplXzTWvIgc+ABTD+Y9I9Q7KGumC7N5BARvlMfv+rxXMq
	 DABh0M0oJUI7jdCeQMgjZuX6imevpGalEzTCdoCkBXzo3WcJ3J5KYrqUinAQIwL8hG
	 4h5hZenz3HuQ8kerlw+Z4zAgaIDqr4P+ygWSvyEDMoesZ0srm8/6fISx6p7i1i7T3C
	 yagXzn0zOVr4rV9WcJUIW4gRP5H1XI23khvGnJCL0m6ygnka4fYj+GkwDze4RzKz62
	 MGigd1PLW0Ks3lnauavZzVcISnD07wQ4ihVwFLeA1TKa7HwOsALQbaaKE1UKN1s296
	 p2M7XzKqdeXjQ==
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
Subject: [PATCH AUTOSEL 6.18-5.10] comedi: ni_atmio16d: Add sanity check to interrupt handler
Date: Mon, 19 Oct 2026 09:48:13 -0400
Message-ID: <20261019135441.1420968-202-sashal@kernel.org>
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

[ Upstream commit 13f4796223489a5349b466ce54bb868f46c9fefd ]

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
Link: https://patch.msgid.link/20260618102949.26607-6-abbotti@mev.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

I have the attach-vs-IRQ ordering, the KASAN report, and the mailing-
list series. Compiling the full nine-phase verdict next.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**
Record: **[comedi / ni_atmio16d] [Add] [sanity check in IRQ handler to
avoid using `dev->read_subdev` before attach completes]**

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- Reported-by: Jaeyoung Chung `<jjy600901@snu.ac.kr>`
- Reported-by: Sangyun Kim `<sangyun.kim@snu.ac.kr>`
- Reported-by: Kyungwook Boo `<bookyungwook@gmail.com>`
- Link: `https://lore.kernel.org/lkml/20260610115912.780131-1-
  jjy600901@snu.ac.kr/` (original bug report)
- Link:
  `https://patch.msgid.link/20260618102949.26607-6-abbotti@mev.co.uk`
  (applied patch)
- Signed-off-by: Ian Abbott `<abbotti@mev.co.uk>` (COMEDI maintainer)
- Signed-off-by: Greg Kroah-Hartman `<gregkh@linuxfoundation.org>`
- No Fixes: tag (expected)
- No Cc: stable (expected; not a negative)
- Three independent reporters (SNU) — real-world/analysis report, not a
  drive-by cleanup

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** IRQ handler is registered in `atmio16d_attach()` before the
  device is fully set up (`dev->attached` still false,
  `dev->read_subdev` still NULL).
- **Symptom:** NULL deref of `dev->read_subdev` if an IRQ arrives early.
- **Author’s root cause:** `request_irq()` runs after the driver writes
  registers to disable interrupt generation, so a premature IRQ should
  only happen with a wrong I/O base/IRQ or bad hardware — still treated
  as a crash to guard against.
- **Version info:** none in the message. Git shows the commit is in this
  tree (`v7.3-rc1` onward).
- Original report subject: `comedi: KASAN null-ptr-deref in ISA driver
  IRQ handlers on early IRQ`. It names `ni_atmio16d.c` /
  `atmio16d_interrupt` explicitly.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not hidden. It is an explicit NULL-deref guard. Cover letter
title: “Add/fix sanity check in ISA drivers to avoid null-ptr-deref”.

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1: INVENTORY THE CHANGES**
Record:
- File: `drivers/comedi/drivers/ni_atmio16d.c` — **+3 / −0**
- Function: `atmio16d_interrupt()`
- Scope: single-file surgical fix

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record: Before, the handler always did `s = dev->read_subdev`,
`inw(AD_FIFO_REG)`, `comedi_buf_write_samples(s, ...)`,
`comedi_handle_events(dev, s)`. After, if `!dev->attached` it returns
`IRQ_NONE` before those uses of `s`. Assigning `s` before the check is
only a pointer copy, not a dereference (unlike sibling “Fix sanity
check” patches that moved `s->async` loads).

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record: **NULL pointer dereference (memory safety)** in IRQ context.
`comedi_buf_write_samples()` calls `comedi_get_is_subdevice_running(s)`,
which does `spin_lock_irqsave(&s->spin_lock, ...)`. If `s` is NULL, that
is a KASAN null-ptr-deref / oops.

Mechanism: `atmio16d_attach()` calls `request_irq()` at line 597, then
sets `dev->read_subdev` at line 634. Core sets `dev->attached = true`
only later in `comedi_device_postconfig()`. Window: handler live,
`read_subdev` still NULL.

**Step 2.4: ASSESS THE FIX QUALITY**
Record: Obviously correct and matches the existing comedi pattern (`if
(!dev->attached) return IRQ_NONE` in many drivers). Minimal. Regression
risk is very low: at worst a premature IRQ during attach is ignored. No
API/data-structure change. The check is the same idiom already used in
`ni_mio_common.c`, `das800.c`, `adv_pci1710.c`, etc.

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**
Record:
- Handler dates to 2009 (`2323b276308a5d`, Chris R. Baugher).
- `s = dev->read_subdev` since `bea70d0b2dc07` (2013).
- `comedi_buf_write_samples()` since `67fdc3073b785` (2014).
- Driver left staging in `8ffdff6a8cfbd` (2021).
- Bug is long-standing, not new 7.x code.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No Fixes: tag. Not applicable. Introduced by the historical IRQ-
before-setup design, not a recent regression commit.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record: This is **patch 5/11** of Ian Abbott’s series (standalone per
driver). Related in this tree:
- `1ca4475191513` aio_iiro_16 Add sanity check
- `e90d0550c5b30` das6402 Add sanity check
- `8dda63825752a` dt2811 Fix sanity check (moves deref after attached
  check)
- `e7356cdc7077a` ni_at_a2150 Fix sanity check
- this commit
- `f876cbfe3e066` pcm711 Fix sanity check
- others for pcl816/pcl818/pcmmio/pcmuio/quatech
- Earlier: `17221216ae8ce` comedi_parport: deal with premature interrupt

No extra refactor is required for this 3-line change. Sibling “Fix
sanity check” commits are for drivers that already had the flag test in
the wrong place; this driver had no check.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Ian Abbott is listed as COMEDI maintainer in MAINTAINERS. This
is a maintainer series fixing the reported drivers plus similar ones.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: None. Uses existing `dev->attached` and
`request_irq`/`read_subdev`. Can apply standalone. `df05bcfcbd326` (I/O
base sanity checks) is unrelated.

`git merge-base --is-ancestor 13f4796223489 HEAD` → yes (already in this
7.3-rc4 checkout). That is origin history, not a reason to reject on
technical merit.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 dig -c 13f4796223489` →
  https://patch.msgid.link/20260618102949.26607-6-abbotti@mev.co.uk
- Subject on list: `[PATCH 05/11] comedi: ni_atmio16d: Add sanity check
  to interrupt handler`
- `b4 dig -a`: single series revision **v1** (11 patches), dated
  2026-06-18. No v2/v3.
- Cover letter: “comedi: Add/fix sanity check in ISA drivers to avoid
  null-ptr-deref”
- Thread mbox: patch series only; no NAK, no reviewer risk flags in the
  saved thread.
- Greg KH committed the series into char-misc (2026-07-17).

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record (`b4 dig -w`): To/Cc were Ian Abbott, linux-kernel, Greg Kroah-
Hartman, H Hartley Sweeten (other COMEDI maintainer), and the three
reporters. Appropriate maintainers were on the patch. No Reviewed-by in
the commit; Greg applied it.

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: Report from Jaeyoung Chung et al., 2026-06-10, lore msgid
`20260610115912.780131-1-jjy600901@snu.ac.kr`. KASAN null-ptr-deref. It
lists `ni_atmio16d.c` / `atmio16d_interrupt` and explains: `request_irq`
then later `dev->read_subdev = s`; handler passes NULL into
`comedi_buf_write_samples()` → `comedi_get_is_subdevice_running(s)` →
`&s->spin_lock`. Suggested fix: move `request_irq` or guard the handler.
Maintainer chose the established `dev->attached` guard.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: 11 independent per-driver patches. This one does not need the
others. `comedi_parport` was fixed earlier (`17221216ae8ce`).

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: lore.kernel.org/stable search for these terms did not surface a
dedicated discussion of this patch (hits were unrelated stable release
mails). No evidence it was rejected for stable. Absence of Cc: stable is
expected for this review pipeline.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: IDENTIFY KEY FUNCTIONS**
Record: `atmio16d_interrupt()` modified. Callers/setup:
`atmio16d_attach()` via `request_irq(..., atmio16d_interrupt, ...)`.
Core: `comedi_device_postconfig()` sets `attached`. Crash site:
`comedi_buf_write_samples()` → `comedi_get_is_subdevice_running()`.

**Step 5.2: TRACE CALLERS**
Record: Registered only from `atmio16d_attach()` when `it->options[1]`
(IRQ) is non-zero. IRQ context. Attach is `COMEDI_DEVCONFIG`
(`do_devconfig_ioctl`), which requires `CAP_SYS_ADMIN`.

**Step 5.3: TRACE CALLEES**
Record: `inw()`, `comedi_buf_write_samples()`, `comedi_handle_events()`.
First of those that uses `s` is `comedi_buf_write_samples` → `spin_lock`
on `s->spin_lock`.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: Userspace (admin) configures the ISA card with I/O base + IRQ →
attach → `request_irq` → possible IRQ before `read_subdev`/`attached`.
Reachable. Not a hot syscall path for unprivileged users, but a real
attach-time oops.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: Same class of bug across the 11-driver series; many other comedi
IRQ handlers already had `if (!dev->attached)`. Systematic ISA attach-
vs-IRQ issue.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record: Local tree is **v7.3-rc4** (`VERSION=7 PATCHLEVEL=3 SUBLEVEL=0
EXTRAVERSION=-rc4`, `git describe HEAD` = `v7.3-rc4-27-gf0100363d8c37`).
File `drivers/comedi/drivers/ni_atmio16d.c` is present. Attach still
does `request_irq` before `read_subdev` / `attached`. The 3-line guard
is already in this checkout because the commit landed in **v7.3-rc1**
(not in v7.2). The buggy pattern (IRQ registered before setup) is still
the attach design; the handler is what this patch hardens. Driver exists
here; patch applies conceptually with no missing APIs.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: Clean apply. Surrounding handler is the same as the parent of
`13f4796223489`. No refactor blocking a 3-line insert.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: This commit and the rest of the 11-patch series are already
ancestors of HEAD (char-misc → 7.3). No alternate fix for
`atmio16d_interrupt` besides this guard. That does not change technical
merit; it is origin history, not a “already selected for stable” marker.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: **comedi** (`drivers/comedi/drivers/ni_atmio16d.c`), National
Instruments AT-MIO-16/16D ISA DAQ. **PERIPHERAL** (legacy ISA,
`CONFIG_COMEDI_NI_ATMIO16D`, MAINTAINERS status “Odd Fixes”). Still a
real in-tree driver with users who need it not to oops.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: Mature/low-churn. Recent work is this sanity-check series plus
I/O-base checks. Long-lived bug, not a rebase artifact.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: **Driver-specific / config-specific** —
`CONFIG_COMEDI_NI_ATMIO16D` and an AT-MIO-16(D) with an IRQ configured.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record: IRQ between `request_irq()` and full attach (`attached` /
`read_subdev`). Author: wrong I/O port or IRQ, or bad hardware;
reporters: any early IRQ after `request_irq`. Needs `CAP_SYS_ADMIN` to
attach. Not an unprivileged local DoS, still a kernel oops on a
documented misconfig/race window.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record: **KASAN null-ptr-deref / oops in IRQ handler**. Severity
**HIGH** (crash). Not silent corruption.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record:
- **Benefit:** Prevents oops on a real, reported path. High for users of
  this driver; limited population.
- **Risk:** Very low (3 lines, established pattern).
- **Ratio:** Favorable. Crash-prevention on existing driver code is what
  stable is for.

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Real KASAN null-ptr-deref, named for this driver
- Three reporters
- Maintainer-authored, applied by Greg KH
- 3-line, obviously correct, existing comedi idiom
- Bug present since ~2013 in this handler
- No new API/feature
- Applies cleanly; no prerequisites
- Failure mode is oops, not cosmetics

AGAINST:
- Niche ISA DAQ; “Odd Fixes”
- Trigger is attach-time / misconfig, not a hot unprivileged path
- No Cc: stable (not a valid negative here)
- 11-patch series, but this patch is self-contained

UNRESOLVED:
- No reviewer replies in the saved lore mbox (Greg still applied it)
- WebFetch to lore returned 403; report/thread recovered via `b4` + curl
  `/raw`

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — 3-line attached check;
   maintainer series; Greg applied it.
2. Fixes a real bug that affects users? **PASS** — KASAN null-ptr-deref
   report listing this handler.
3. Important issue? **PASS** — oops in IRQ context (HIGH).
4. Small and contained? **PASS** — +3 lines, one function.
5. No new features or APIs? **PASS**.
6. Can apply to the local tree? **PASS** — driver and handler match; no
   missing helpers.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: Not a device-ID/quirk/DT/build/docs exception. Ordinary crash
fix.

**Step 9.4: DECISION**

This tree is **Linux 7.3-rc4**. The driver and attach/IRQ ordering are
here. The patch stops a confirmed NULL deref in `atmio16d_interrupt()`
when an IRQ fires after `request_irq()` and before `dev->attached` /
`dev->read_subdev` are valid. That is a small, contained, real crash fix
with no new ABI and negligible regression risk. It belongs in this
tree’s comedi ISA driver.

---

## What the commit solves (for this tree)

`atmio16d_attach()` registers `atmio16d_interrupt` before
`dev->read_subdev` is set and before core sets `dev->attached`. An early
IRQ calls `comedi_buf_write_samples(NULL, ...)`, which takes
`&s->spin_lock` and oopses. The patch returns `IRQ_NONE` until attach
has finished. That matches other comedi handlers and the KASAN report.

Stable rules: real oops, tiny diff, no features, applies here. Benefit
(no IRQ oops) outweighs risk.

---

## Verification
- [Phase 1] Tags: 3× Reported-by (SNU), two Link: URLs, Ian Abbott +
  Greg KH SOB; no Fixes:/Cc: stable
- [Phase 1] Cover letter: “avoid null-ptr-deref”; ni_atmio16d listed
- [Phase 2] Diff: +3 in `atmio16d_interrupt()` only
- [Phase 2] `comedi_get_is_subdevice_running()` does
  `spin_lock_irqsave(&s->spin_lock)` — NULL `s` is a deref
- [Phase 2] Attach order in this tree: `request_irq` ~597, `read_subdev`
  ~634; `attached` set in `comedi_device_postconfig()`
- [Phase 3] Blame: handler 2009, `read_subdev` 2013,
  `comedi_buf_write_samples` 2014
- [Phase 3] No Fixes: tag; `git merge-base --is-ancestor 13f4796223489
  HEAD` succeeded (in v7.3-rc1, not v7.2)
- [Phase 3] Series 5/11, standalone; sibling “Fix sanity check” patches
  are other files
- [Phase 4] `b4 dig -c 13f4796223489`:
  patch.msgid.link/20260618102949.26607-6; v1 only
- [Phase 4] `b4 dig -w`: Greg KH + Hartley Sweeten + reporters CC’d
- [Phase 4] `b4 dig -a`: one revision, 11 patches
- [Phase 4] Bug report `/raw`: KASAN null-ptr-deref; names
  `atmio16d_interrupt`
- [Phase 4] Stable lore search: no dedicated discussion of this patch
- [Phase 5] `COMEDI_DEVCONFIG` requires `CAP_SYS_ADMIN`
  (`do_devconfig_ioctl`)
- [Phase 5] Same `dev->attached` pattern in many
  `drivers/comedi/drivers/*.c`
- [Phase 6] `git describe HEAD` = v7.3-rc4-27-gf0100363d8c37; `make
  kernelversion` = 7.3.0-rc4
- [Phase 6] File present; pre-fix parent handler has no attached check
- [Phase 7] MAINTAINERS: Ian Abbott; status Odd Fixes;
  `CONFIG_COMEDI_NI_ATMIO16D`
- [Phase 8] Failure mode: IRQ-time NULL deref / oops, HIGH
- UNVERIFIED: full lore HTML (WebFetch 403); no on-list Reviewed-by
  found in mbox

**YES**

 drivers/comedi/drivers/ni_atmio16d.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/comedi/drivers/ni_atmio16d.c b/drivers/comedi/drivers/ni_atmio16d.c
index b057b3b3582e1..bf7fb6704710f 100644
--- a/drivers/comedi/drivers/ni_atmio16d.c
+++ b/drivers/comedi/drivers/ni_atmio16d.c
@@ -223,6 +223,9 @@ static irqreturn_t atmio16d_interrupt(int irq, void *d)
 	struct comedi_subdevice *s = dev->read_subdev;
 	unsigned short val;
 
+	if (!dev->attached)
+		return IRQ_NONE;
+
 	val = inw(dev->iobase + AD_FIFO_REG);
 	comedi_buf_write_samples(s, &val, 1);
 	comedi_handle_events(dev, s);
-- 
2.53.0

