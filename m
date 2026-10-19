Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85FEA533D1E;
	Mon, 19 Oct 2026 13:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418172; cv=none; b=gV2fnj7Tt1gnLP5F/wtaIue/fdzkl/5o22OcwI7ZKOtafFYEtgmjoJk5oSFCPnoOqfpB643/AjsKR6JaLRipuI6vsEI5Q427vxo4SqUsYflCv+AigX8qyOcZ8FZUVhcXnpJEQzM/QCfHMnlqPXfy0efcb4ovJ0NptPjYevNONf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418172; c=relaxed/simple;
	bh=LkQNGb/gF/AMAymAiYwSMVzJa/Dr+oE5vkKelPezV4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uxWIcA0ndW99EelxZhZjBxY3zbBEWQliKnK2bMDbXb3epEotl4+MyURinzbLE140WUEDaWBlQ2NgNWt/igUrKq58gUza6ATC+Mxooiswbc78+Ksf0YPKji2E5pXMlH61C1cYOTRqAFiqO2tHnSjUSccvlFg2i25H0JFQAg8jr20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lucBs15F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lucBs15F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B63B1F000C5;
	Mon, 19 Oct 2026 13:56:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418169;
	bh=yS1cXJUZ6MiwhUPWcwMLDFOnLoS8irSvjD9Yc+fW79A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lucBs15F258srCLlUdUjdtcM+/sk5x7HNZXWtcOHdf43WUxky0VrPpFb6zMtbSa21
	 mLL9LhJna8UpKkJZNpiH9szWd/0SC/lMWPl0zqOpZ2veJsIHzy/n72Zrc24jFFYOf2
	 SwjNCruMQYA6iqNkkKx0G7RpodkfC1wCgBSKKnDTrPxLnjKWyTBIIfmStUS/TnrWn5
	 vE+0H/gn3VT2TPluvmxY0mETL2lgXEGTtUqTCA1HWrDyybU/ZAi1F33HyMb+TXVZt6
	 wHCeALpWKCGz86eKv+NRuLS7pRaXpajvk97MVANohc27LVMXilVX83rbfB1iD77vek
	 bQ1qfm0PG+sbQ==
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
Subject: [PATCH AUTOSEL 6.18-5.10] comedi: das6402: Add sanity check to interrupt handler
Date: Mon, 19 Oct 2026 09:45:52 -0400
Message-ID: <20261019135441.1420968-61-sashal@kernel.org>
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

[ Upstream commit e90d0550c5b3056c8821f5cd714f80902de0fca6 ]

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
Link: https://patch.msgid.link/20260618102949.26607-3-abbotti@mev.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit message forensics

**Step 1.1: Subject line**
Record: **[comedi/das6402] [Add] sanity check in the IRQ handler to
avoid a NULL deref of `dev->read_subdev` before attach completes**

**Step 1.2: Tags**
Record:
- `Reported-by: Jaeyoung Chung <jjy600901@snu.ac.kr>`
- `Reported-by: Sangyun Kim <sangyun.kim@snu.ac.kr>`
- `Reported-by: Kyungwook Boo <bookyungwook@gmail.com>`
- `Link: https://lore.kernel.org/lkml/20260610115912.780131-1-
  jjy600901@snu.ac.kr/` (original bug report)
- `Signed-off-by: Ian Abbott <abbotti@mev.co.uk>` (author; comedi
  maintainer)
- `Link:
  https://patch.msgid.link/20260618102949.26607-3-abbotti@mev.co.uk`
- `Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>`
- No `Fixes:` tag (expected for this review)
- No `Cc: stable` (expected; not a negative signal)
- No `Reviewed-by` / `Tested-by` / `Acked-by`
- Three independent reporters (SNU) is a strong real-world signal

**Step 1.3: Body**
Record:
- **Bug:** IRQ handler is registered in `das6402_attach()` before
  subdevices (and `dev->read_subdev`) are set up. `dev->attached` is
  only set later in core postconfig.
- **Symptom:** NULL pointer dereference of `dev->read_subdev` /
  `s->async` if an IRQ arrives early.
- **Trigger (author):** user-configured I/O base and/or IRQ wrong, or
  bad hardware. The original report also frames it as any IRQ between
  `request_irq()` and `read_subdev` assignment.
- **Root cause:** handler immediately does `s = dev->read_subdev; async
  = s->async;` with no attached/NULL check.
- **Version info:** none in the message. Blame shows the deref pattern
  since 2014.

**Step 1.4: Hidden bug fix?**
Record: **Not hidden.** It is an explicit NULL-deref guard. Cover
letter: “Add/fix sanity check in ISA drivers to avoid null-ptr-deref.”
Original report title: **KASAN null-ptr-deref**.

---

## Phase 2: Diff analysis

**Step 2.1: Inventory**
Record:
- File: `drivers/comedi/drivers/das6402.c` (+8 / −2)
- Function: `das6402_interrupt()`
- Scope: **single-file surgical fix**

**Step 2.2: Code flow**
Record: **Before:** on every IRQ, immediately dereference
`dev->read_subdev` and `s->async`. **After:** if `!dev->attached`,
return `IRQ_NONE`; only then load `async`/`cmd`. Assigning `s =
dev->read_subdev` before the check is a pointer copy, not a deref.

**Step 2.3: Bug mechanism**
Record: **[NULL pointer dereference / memory safety]** in IRQ context.
`request_irq()` runs in `das6402_attach()` before
`comedi_alloc_subdevices()` and `dev->read_subdev = s`. Core sets
`dev->attached = true` only in `comedi_device_postconfig()` after attach
returns. On a premature IRQ, `read_subdev` is still NULL → `s->async`
oops.

Detach also sets `attached = false` **before** `comedi_legacy_detach()`
→ `free_irq()`, so the same check covers the teardown window.

**Step 2.4: Fix quality**
Record: **Obviously correct** and the established comedi pattern
(`comedi_parport`, `ni_660x`, many ISA drivers). Minimal. Regression
risk is low: returning `IRQ_NONE` before attach is the intended “not
ours yet” behavior. `DAS6402_CTRL_INTE` is only set in
`das6402_ai_cmd()`, which cannot run until the device is attached, so
legitimate acquisition IRQs are unaffected.

This is patch 02/11 of a per-driver series; das6402 did not already have
a misplaced `attached` check (unlike pcl818/dt2811 “Fix sanity check”
patches). No follow-up was needed for this file.

---

## Phase 3: Git history

**Step 3.1: Blame**
Record:
- Handler exists since `48f16b6aeafdfb` (2009).
- NULL deref of `read_subdev` introduced by `d1d24cb65ee360` (“staging:
  comedi: das6402: read analog input samples in interrupt handler”,
  Hartley Sweeten, 2014-11-13) → **v3.19-rc1**.
- Driver rewrite: `79e5e6addbb18b` (v3.15-rc1).
- Comedi left staging: `8ffdff6a8cfbd` (around v5.13).
- Long-lived bug, not recent new code.

**Step 3.2: Fixes: tag**
Record: **None.** Introducing commit `d1d24cb65ee360` **is** an ancestor
of this tree.

**Step 3.3: File history**
Record (recent on this file):
- `e90d0550c5b30` this fix
- `2ddb4c5699129` I/O base sanity (independent; not a prerequisite)
- `70f2b28b5243d` bit-shift OOB fix

Standalone. Series is 11 independent per-driver IRQ guards.

**Step 3.4: Author**
Record: Ian Abbott is **the comedi maintainer** (118 comedi commits in
this tree). Sibling `comedi_parport` fix `17221216ae8ce` is the same
class and was explicitly `Cc: stable` + syzbot.

**Step 3.5: Dependencies**
Record: **None.** Uses existing `dev->attached` and `IRQ_NONE`. Applies
standalone.

`git merge-base --is-ancestor e90d0550c5b30 HEAD` → already in this
checkout (v7.3-rc4). That is not treated as “already selected for
stable.”

---

## Phase 4: Mailing list / external research

**Step 4.1: Original discussion**
Record:
- `b4 dig -c e90d0550c5b30` →
  https://patch.msgid.link/20260618102949.26607-3-abbotti@mev.co.uk
- Series: **v1 only**, `[PATCH 02/11]`, cover `comedi: Add/fix sanity
  check in ISA drivers to avoid null-ptr-deref`
- Bug report (lkml.iu.edu / lore): Jaeyoung Chung, 2026-06-10,
  **“comedi: KASAN null-ptr-deref in ISA driver IRQ handlers on early
  IRQ”**. Names `das6402_attach` / `das6402_interrupt` first. Failure:
  kernel panic / KASAN when IRQ fires after `request_irq()` and before
  `read_subdev` is set.
- Suggested fix matches this patch (guard handler or move
  `request_irq`).
- Mbox: cover + 11 patches, **no NAKs, no reviewer objections**. Greg KH
  applied it.

**Step 4.2: Recipients (`b4 dig -w`)**
Record: `linux-kernel@vger.kernel.org`, Greg Kroah-Hartman, H Hartley
Sweeten, the three reporters. Comedi maintainers were on the patch.

**Step 4.3: Bug report**
Record: Static/code-path KASAN NULL deref in several ISA comedi IRQ
handlers. Three reporters. `das6402` is the exemplar. Sibling parport
case was syzbot-reproduced GPF.

**Step 4.4: Series**
Record: 11 independent driver patches. This one does not need the rest.

**Step 4.5: Stable list**
Record: lore.kernel.org/stable fetch returned 403. Unverified whether
someone already nominated it on the stable list. The related parport
patch **was** `Cc: stable`.

---

## Phase 5: Code semantic analysis

**Step 5.1: Functions**
Record: `das6402_interrupt()` only.

**Step 5.2: Callers**
Record: only `request_irq(..., das6402_interrupt, ...)` in
`das6402_attach()` (`drivers/comedi/drivers/das6402.c:579`). **Hard IRQ
context.**

**Step 5.3: Callees**
Record: `inb`, `das6402_ai_read_sample`, `comedi_buf_write_samples`,
`das6402_clear_all_interrupts`, `comedi_handle_events`. After the guard,
those only run once attached.

**Step 5.4: Reachability**
Record: Yes, from userspace: Comedi `COMEDI_DEVCONFIG` attach with I/O
base + IRQ (`it->options[0]` / `[1]`). Typically privileged.
Misconfigured port/IRQ or a spurious IRQ during attach/detach oopses the
kernel. `das6402_reset()` runs before `request_irq` and leaves
`CTRL_SOFT_TRIG` (no `DAS6402_CTRL_INTE`); device IRQs are enabled later
in `das6402_ai_cmd()`. So a **correct** board is unlikely to interrupt
early; wrong I/O/IRQ, leftover IRQ line, or teardown still can.

**Step 5.5: Similar patterns**
Record: Same `if (!dev->attached)` guard across many comedi ISA drivers.
This series adds/fixes it in 11 of them. Established, not experimental.

---

## Phase 6: Local tree

**Step 6.1: Does the buggy code exist here?**
Record:
- Tree: **`v7.3-rc4-27-gf0100363d8c37`**, `VERSION=7 PATCHLEVEL=3
  SUBLEVEL=0 EXTRAVERSION=-rc4` (mainline 7.3-rc, not an LTS branch).
- File and handler exist. Pre-fix handler (parent of `e90d0550c5b30`)
  dereferenced `s->async` unconditionally. Bug introduced **v3.19**
  (`d1d24cb65ee360`), long before 7.3.
- Current tree already contains the fix (`e90d0550c5b30` is an ancestor
  of HEAD).

**Step 6.2: Backport difficulty**
Record: **Clean apply** to any tree with this `das6402_interrupt()`
shape (stable since 2014). No structural prerequisites.

**Step 6.3: Related fixes already here**
Record: This exact fix is already in HEAD. No alternate das6402 IRQ
NULL-deref fix. `2ddb4c5699129` only restricts I/O base; it does not
close the IRQ window.

---

## Phase 7: Subsystem context

**Step 7.1**
Record: **comedi / DAS6402 ISA DAQ driver**. Criticality: **PERIPHERAL**
(legacy ISA, `CONFIG_COMEDI_DAS6402`), but the failure is a **kernel
oops in IRQ context**, not a cosmetic driver glitch. Comedi is out of
staging.

**Step 7.2**
Record: Mature driver (1999/2014). Recent activity is this class of
IRQ/I/O sanity fixes, not a rewrite.

---

## Phase 8: Impact and risk

**Step 8.1: Who is affected**
Record: **Driver-specific / config-specific** (`CONFIG_COMEDI_DAS6402`).
Keithley/Computerboards DAS6402-12/16 and compatibles. Small population,
but a crash is still a crash for those users and for anyone attaching
with a bad IRQ/port.

**Step 8.2: Trigger**
Record: Attach with IRQ configured, then an IRQ before `attached` (bad
I/O/IRQ, spurious line, or the `attached=false`…`free_irq` detach
window). Not every boot on healthy hardware. Privileged attach, not
unprivileged syscall spray like a VFS bug; still a real oops and KASAN-
class memory-safety issue.

**Step 8.3: Failure mode**
Record: **NULL deref in hardirq → KASAN / oops / panic**. Severity:
**CRITICAL** (crash), limited blast radius (this driver).

**Step 8.4: Risk-benefit**
Record:
- **Benefit:** prevents IRQ-time oops on a real, reported path; same
  pattern already used for stable on `comedi_parport`.
- **Risk:** very low (8 lines, early return, no locking/API change).
- **Ratio:** favorable.

---

## Phase 9: Synthesis

**Step 9.1: Evidence**

FOR:
- KASAN-reported NULL deref in an interrupt handler (oops/panic)
- Three reporters; das6402 is the primary example in the report
- 8-line, obviously correct guard used across comedi
- Maintainer-authored; applied by Greg KH
- Bug present since ~v3.19; no missing prerequisites in this tree
- Sibling parport fix of the same class was `Cc: stable`

AGAINST:
- Niche ISA DAQ hardware
- Healthy boards with correct I/O/IRQ are unlikely to interrupt before
  `DAS6402_CTRL_INTE` is set
- No `Fixes:` / `Cc: stable` on this commit (expected; not used as a NO)
- No extra `Reviewed-by` besides maintainer + Greg

UNRESOLVED:
- Could not search lore.kernel.org/stable (403)
- No C reproducer in the SNU mail (code-path / KASAN analysis, not
  syzbot)

**Step 9.2: Stable rules**
1. Obviously correct and tested? **PASS** (standard `dev->attached`
   guard; applied upstream)
2. Real user-affecting bug? **PASS** (KASAN NULL deref / panic on early
   IRQ)
3. Important (crash/security/corruption/deadlock)? **PASS** — crash in
   IRQ handler
4. Small and contained? **PASS** — one function, +8/−2
5. No new features/APIs? **PASS**
6. Can apply to this tree? **PASS** — file and handler exist; patch is
   already the current code

**Step 9.3: Exception category**
Record: None needed (not a device-ID/quirk/DT/build/doc exception). It
is a straightforward crash fix.

**Step 9.4: Decision**
This tree is **Linux 7.3-rc4**. The DAS6402 IRQ handler and the
`read_subdev` deref have been in this lineage since v3.19. The change is
a small, standard NULL-deref guard for a KASAN-confirmed oops. It meets
stable criteria on technical merit. Niche hardware lowers breadth of
impact, not the fact that the failure is a kernel crash.

---

### What it solves for stable users
If `das6402` is loaded and attached with an IRQ, the handler can run
after `request_irq()` but before `dev->read_subdev` is set (and while
`dev->attached` is still false). The old handler immediately did
`s->async` and oopsed. The patch returns `IRQ_NONE` until attach is
complete.

### Risk vs benefit
Benefit is avoiding an IRQ-context oops; risk is an 8-line early return
that does not change the post-attach command path (`CTRL_INTE` only in
`das6402_ai_cmd()`).

### Concerns
No backport rework, no series dependency. Apply is clean on this
`das6402.c`.

---

Verification:
- [Phase 1] Parsed tags: 3× Reported-by (SNU), lore bug Link, Ian Abbott
  + Greg KH SOBs; no Fixes/Cc:stable
- [Phase 2] Diff: +8/−2 in `das6402_interrupt()`; defer `s->async` until
  `dev->attached`
- [Phase 2] Confirmed `DAS6402_CTRL_INTE` only in `das6402_ai_cmd()`;
  reset uses `CTRL_SOFT_TRIG` before `request_irq`
- [Phase 2] Confirmed detach sets `attached = false` then
  `comedi_legacy_detach()` → `free_irq()`
- [Phase 3] `git describe HEAD` → `v7.3-rc4-27-gf0100363d8c37`; Makefile
  7.3.0-rc4
- [Phase 3] `git blame`: deref from `d1d24cb65ee360` (v3.19-rc1);
  handler from 2009/2014
- [Phase 3] `git merge-base --is-ancestor d1d24cb65ee360 HEAD` →
  introducing commit in this tree
- [Phase 3] `git merge-base --is-ancestor e90d0550c5b30 HEAD` → this
  commit already in HEAD (ignored as “already selected”)
- [Phase 3] Pre-fix handler via `git show
  e90d0550c5b30^:drivers/comedi/drivers/das6402.c` matches the candidate
  diff
- [Phase 3] Ian Abbott: 118 comedi commits; sibling `17221216ae8ce` had
  `Cc: stable` + syzbot
- [Phase 4] `b4 dig -c e90d0550c5b30` → msgid `20260618102949.26607-3`;
  series v1 02/11
- [Phase 4] `b4 dig -a`: v1 only; `b4 dig -w`: Greg KH + Hartley Sweeten
  + reporters
- [Phase 4] Mbox: cover letter “null-ptr-deref”; no NAK/review
  objections
- [Phase 4] Original report fetched from lkml.iu.edu: KASAN null-ptr-
  deref, das6402 listed first
- [Phase 4] lore.kernel.org WebFetch 403; stable-list search UNVERIFIED
- [Phase 5] `das6402_interrupt` callers: only `request_irq` in
  `das6402_attach`
- [Phase 6] Current `das6402.c` already has `if (!dev->attached)`; buggy
  form exists at parent of this commit
- [Phase 7] `CONFIG_COMEDI_DAS6402` in `drivers/comedi/Kconfig`;
  peripheral ISA driver, not staging
- [Phase 8] Failure mode: NULL deref in hardirq → oops/panic, severity
  CRITICAL, population driver-specific
- UNVERIFIED: whether this SHA was discussed on stable@ (lore 403)

The fix is small, surgical, and meets all stable kernel criteria.

**YES**

 drivers/comedi/drivers/das6402.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/comedi/drivers/das6402.c b/drivers/comedi/drivers/das6402.c
index 7660487e563c5..f9a778390ac93 100644
--- a/drivers/comedi/drivers/das6402.c
+++ b/drivers/comedi/drivers/das6402.c
@@ -173,10 +173,16 @@ static irqreturn_t das6402_interrupt(int irq, void *d)
 {
 	struct comedi_device *dev = d;
 	struct comedi_subdevice *s = dev->read_subdev;
-	struct comedi_async *async = s->async;
-	struct comedi_cmd *cmd = &async->cmd;
+	struct comedi_async *async;
+	struct comedi_cmd *cmd;
 	unsigned int status;
 
+	if (!dev->attached)
+		return IRQ_NONE;
+
+	async = s->async;
+	cmd = &async->cmd;
+
 	status = inb(dev->iobase + DAS6402_STATUS_REG);
 	if ((status & DAS6402_STATUS_INT) == 0)
 		return IRQ_NONE;
-- 
2.53.0

