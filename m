Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E09B54A7CD;
	Mon, 19 Oct 2026 13:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418349; cv=none; b=NyO73vMpmkVW2QMdeA0JVnG22U11WXrZapUs8aiC3vx6UzbLFySxcu38MjU8V7yJeYNoTch/VKDZZNVtfiwE5xFU+wlnA9vvIENxkewRAsWgtGUZD4Jqmva0VNIHV5AZucl1X7/DpqBexKHNPaO1YBy1aT+fO5TD9e+WMmf13+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418349; c=relaxed/simple;
	bh=K2RiwUF1eNc+cDvv2jRsI15bb8kyWj12rXnxwKJqLPI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y8eN4paqE2XgSklu+dBokkAP81LLEc1CWDDJhbmdK1D/XeaeiQblccqJTbeUWvF/deHK+JKGbxl/Fy+Q8TYjAMAZBxGF/v1hqHa6pGZIQ/dSRx/9YzvRO0hJAo6ymRZc9l2MAvQuvjEpCWj1DBTYGh+XwViyLpwxZzslQTCe6Ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fOBBtFtw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fOBBtFtw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 966481F000C8;
	Mon, 19 Oct 2026 13:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418346;
	bh=KA6JCDuNsm8NO4SKgFBTKWfceVaeNt4AGqZZ8ySWaXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fOBBtFtwPXFGa/GSQoDPldBoAxhrxeGH6386vhAsUqW37Jwy3UwO8H1RTPBm7p5IM
	 hf258HOJQhvYUhawzZ8hA08fODwC6+X6uUIjf7kNc2sWS8PmMLme0nmlLsyBVP37fj
	 f3n81fGZDZ2TFOXwsMbOCbC85R4NdYwmmy0FEtgJVU86XnykkFXELNrp8C83k1NlEd
	 GJjJf8oejpg8xLudyTGS+aOospFACNlMeLKF4962a83UTrCpbUU3jzLJWwvh5aLPM4
	 40dXF9hBZZeb3iaKYtc0twUtn6YufzylhHTh8BoLmt1miVsUwx9dG3DLeHLaHRpVpl
	 veh8vuSWgKeMg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Richard Weinberger <richard@nod.at>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	cassel@kernel.org,
	linux-ide@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] ata: libata-sff: don't busy-wait for PIO data-in command completion
Date: Mon, 19 Oct 2026 09:47:53 -0400
Message-ID: <20261019135441.1420968-182-sashal@kernel.org>
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

From: Richard Weinberger <richard@nod.at>

[ Upstream commit 4a2e5409472e8a0e3e2817e149c55c1d5f803742 ]

Unlike PIO data-out, the PIO data-in protocol raises no completion
interrupt, the last interrupt announces the final data block, and once
the host has drained it from the data register the ending status must
be obtained synchronously.  ata_sff_hsm_move() does this by spinning
in ata_wait_idle() for up to 10ms.

Usually this is not a big deal unless the device is slow.  In my case
it's a CF card which keeps BSY asserted for multiple milliseconds(!)
after the final data block.  Since the waiting happens in the
interrupt handler, under the port lock with interrupts disabled, the
CPU is hogged for milliseconds on every read command.

To improve the situation, bound the inline wait to ~100us.  If the
device is still busy after that, mark the command ATA_TFLAG_POLLING,
so the interrupt handler won't race for it, and obtain the ending
status via ata_sff_pio_task(), which sleeps between status checks
instead of spinning with the lock held.

Since ata_sff_pio_task() may now finish a data-in command, it must
wait for both BSY and DRQ to clear at HSM_ST_LAST, matching what
ata_wait_idle() enforced.

Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable backport analysis: `ata: libata-sff: don't busy-wait for PIO
data-in command completion`

Local tree: **v7.3-rc4** (`7.3.0-rc4`, HEAD `f0100363d8c37`). Candidate:
`4a2e5409472e8` (Damien Le Moal, 2026-07-21). The buggy PIO completion
wait has been in `drivers/ata/libata-sff.c` since 2008; this change is a
small HSM latency fix for that path.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: PARSE THE SUBJECT LINE**
- Subsystem: `ata: libata-sff`
- Action verb: **don't busy-wait** (prevent / stop incorrect spinning)
- Intent: stop spinning in the SFF interrupt handler for PIO data-in
  completion

Record: `[ata/libata-sff] [don't busy-wait] [cap IRQ-context wait for
PIO data-in; defer remaining wait to sleeping pio task]`

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
- `Signed-off-by: Richard Weinberger <richard@nod.at>` (author)
- `Signed-off-by: Damien Le Moal <dlemoal@kernel.org>` (libata
  maintainer; applied to for-7.3)
- No `Fixes:`
- No `Reported-by:` / `Tested-by:` / `Reviewed-by:` / `Acked-by:`
- No `Link:` / `Cc: stable`
- No syzbot / sanitizer tags

Absence of `Fixes:` / `Cc: stable` is expected for this review and is
not a negative signal.

Record: `[tags: two SOBs (author + ATA maintainer); no Fixes/Reported-
by/Link/stable Cc]`

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
PIO data-in does not raise a completion IRQ. The last IRQ means “final
data block”; after the host drains it, ending status must be read
synchronously. `ata_sff_hsm_move()` used `ata_wait_idle()`, spinning up
to **10ms**.

On a CompactFlash card that keeps BSY asserted for several milliseconds
after the last block, that wait runs in the **interrupt handler**, under
the **port lock**, with **IRQs disabled**, on **every read**.

Fix: bound the inline wait to ~100µs (`ata_sff_busy_wait(..., 10)`). If
still busy, set `ATA_TFLAG_POLLING` and finish via `ata_sff_pio_task()`,
which sleeps between checks. That task must wait for both BSY and DRQ at
`HSM_ST_LAST`, matching `ata_wait_idle()`.

Record: `[Bug: IRQ-context 10ms busy-wait on PIO data-in] [Symptom: CPU
hogged for ms per read, lock held, IRQs off] [Root cause:
ata_wait_idle() in hsm_move after last PIO-in block] [Trigger: slow
CF/PATA that holds BSY after last DRQ]`

**Step 1.4: DETECT HIDDEN BUG FIXES**
Wording is “improve the situation,” but the failure is a real IRQ-
context stall, not a cleanup. That matches the “oh, that's not good”
class in `Documentation/process/stable-kernel-rules.rst`, and the
hardware-quirk / interactivity class for slow CF.

Record: `[Hidden bug fix: yes — IRQ busy-wait / latency stall, not style
cleanup]`

---

## PHASE 2: DIFF ANALYSIS

**Step 2.1: INVENTORY THE CHANGES**
- File: `drivers/ata/libata-sff.c` only
- Stat: **17 insertions, 7 deletions** (24 lines)
- Functions: `ata_sff_hsm_move()`, `ata_sff_pio_task()`
- Scope: single-file surgical HSM change

Record: `[1 file, +17/-7] [ata_sff_hsm_move, ata_sff_pio_task]
[surgical]`

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**

Hunk 1 (`ata_sff_hsm_move`, `HSM_ST`, PIO data-in last block):
- Before: `status = ata_wait_idle(ap)` (up to 1000×10µs = 10ms), then
  `goto fsm_start`.
- After: `ata_sff_busy_wait(ap, ATA_BUSY|ATA_DRQ, 10)` (~100µs). If
  still busy and status ≠ 0xff: set `ATA_TFLAG_POLLING`,
  `ata_sff_queue_pio_task(link, 0)`, return 0. Else same `goto
  fsm_start`.

Hunk 2 (`ata_sff_pio_task`):
- Before: always wait only for `ATA_BUSY`.
- After: `wait_mask = ATA_BUSY`, and at `HSM_ST_LAST` also `ATA_DRQ`.
  Both short spins and the “still busy → requeue” test use `wait_mask`.

Record: `[IRQ path: 10ms spin → 100µs then optional poll work] [wq path:
wait BSY, or BSY|DRQ at LAST]`

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Category: **logic/latency in IRQ** (busy-wait with IRQs disabled), plus
**hardware delay on slow CF**.

Mechanism: last PIO-in IRQ still needs BSY/DRQ to drop. Spinning in
hardirq with the port lock held stalls the CPU. The fix uses the
existing polling workqueue, which already drops the lock and
`ata_msleep()`s.

`ATA_TFLAG_POLLING` is the existing “IRQ must not complete this qc”
flag. `__ata_sff_interrupt()` skips `port_intr()` when it is set.

Record: `[category: IRQ busy-wait / latency] [fix: short wait + existing
pio_task polling; LAST waits BSY|DRQ]`

**Step 2.4: ASSESS THE FIX QUALITY**
Verified against current code:

- `ata_wait_idle()` is `ata_sff_busy_wait(..., ATA_BUSY|ATA_DRQ, 1000)`
  with a debug print. New max=10 is the same bits, 100× shorter.
- Status 0xff (no device) is **not** deferred; it still goes to
  `fsm_start`, same as a disconnected `ata_wait_idle()` result.
- `ata_hsm_ok_in_wq()` returns 1 when `ATA_TFLAG_POLLING` is set, so the
  `WARN_ON_ONCE(in_wq != ata_hsm_ok_in_wq())` stays consistent when the
  workqueue later calls `ata_sff_hsm_move(..., 1)`.
- `pio_task` clears `sff_pio_task_link` **before** `hsm_move`. If the
  IRQ path queued work and the wq path hits the new wait, requeue via
  `ata_sff_queue_pio_task` is the existing delayed-work pattern.
- Fast devices that drop BSY/DRQ within ~100µs still complete in IRQ;
  only slow devices take the workqueue.

Regression risk is real but contained: HSM is sensitive, and the patch
does not call `ata_qc_set_polling()` (no nIEN). For PIO data-in that is
acceptable: the protocol does not raise a completion IRQ after the last
block, which is why the synchronous wait existed.

Record: `[quality: small, uses existing polling HSM] [risk: low-medium
HSM timing; nIEN not set, which matches this protocol]`

---

## PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: BLAME THE CHANGED LINES**
- Surrounding `if (hsm_task_state == HSM_ST_LAST && !WRITE)` /
  `ata_wait_idle()`: **`624d5c514eed18`** (Tejun Heo, 2008-03-25),
  “libata: reorganize SFF related stuff” — move-only; the wait was
  already the SFF HSM.
- `git describe 624d5c514eed18`: **v2.6.25-18**; contained in
  **v2.6.26-rc1**.
- New lines blamed on `4a2e5409472e8` (this commit).

Record: `[buggy wait present since ~v2.6.26 (2008)] [long-lived, all
LTS-class trees have it]`

**Step 3.2: FOLLOW THE FIXES: TAG**
No `Fixes:` tag. Not applicable beyond that. The wait itself was not
introduced by a recent buggy commit.

Record: `[no Fixes tag; bug is decades-old HSM behavior]`

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Recent `libata-sff.c` (path-limited): this commit is the latest on the
file. No later follow-up on this wait. Older related HSM work
(`ce7514526742c`, `8eee1d3ed5b6f`) is already in this tree. Not part of
a numbered series.

Record: `[standalone] [no post-commit fix on this file] [no missing HSM
locking prereq]`

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Path-limited `git log --author="Richard Weinberger" -- drivers/ata/`:
only this commit. Author is a long-time embedded/UML maintainer (sigma
star); CF is typical for that hardware. Damien Le Moal is the libata
maintainer and applied it.

Record: `[author: one-off ATA contributor, real CF user] [applied by
subsystem maintainer]`

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Uses existing `ata_sff_busy_wait`, `ATA_TFLAG_POLLING`,
`ata_sff_queue_pio_task`, `ata_sff_pio_task`, `ATA_SHORT_PAUSE`. No new
helpers. Parent hunks match 2008-era HSM structure.

Record: `[no extra dependencies; standalone apply]`

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
`b4 dig -c 4a2e5409472e8`:
- https://patch.msgid.link/20260717090404.857078-1-richard@nod.at
- Single revision: `[PATCH] [RFC] libata: Don't busy-wait...`
- Damien: “Looks OK to me, but the patch title should be: ata: libata-
  sff: …”
- Richard: agreed; Damien applied with the title change.
- No NAK, no stable nomination, no race objections in the retrieved
  thread (openwall/lkml/patchew). lore.kernel.org fetch returned 403;
  discussion recovered from patchew, openwall, and lkml.

Record: `[lore/msgid: 20260717090404.857078-1-richard@nod.at] [v1 RFC
only] [maintainer OK, title-only change] [no NAK]`

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
`b4 dig -w` recipients: Richard Weinberger, linux-ide, linux-kernel,
`upstream+linux@sigma-star.at`, `cassel@kernel.org` (Niklas Cassel),
`dlemoal@kernel.org`.

Visible review: Damien only (“Looks OK” / Applied). No Niklas reply
found. No `Reviewed-by`.

Record: `[CC: linux-ide + Cassel + Le Moal] [reviewer: Damien Le Moal
applied]`

**Step 4.3: SEARCH FOR THE BUG REPORT**
No bugzilla/syzbot. Author is the reporter: CF card, BSY held for
milliseconds after last data block, IRQ busy-wait on every read.

Record: `[one real-hardware report (author, CF)] [no distro bugzilla]`

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Standalone RFC, not `m/n`. No sibling patches required.

Record: `[standalone series]`

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Web search of lore.kernel.org/stable for this subject found **no**
stable-list discussion.

Record: `[no stable@ discussion found]`

---

## PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1: IDENTIFY KEY FUNCTIONS**
`ata_sff_hsm_move`, `ata_sff_pio_task`. Helpers used:
`ata_sff_busy_wait`, `ata_sff_queue_pio_task`, `ata_pio_sectors`.

Record: `[modified: ata_sff_hsm_move, ata_sff_pio_task]`

**Step 5.2: TRACE CALLERS**
`ata_sff_hsm_move`:
- `ata_sff_pio_task` (workqueue, `in_wq=1`)
- `__ata_sff_port_intr` → `ata_sff_port_intr` / `ata_sff_interrupt`
  (hardirq, `in_wq=0`) — **this is the spinning path**
- `sata_sil.c`, `sata_dwc_460ex.c`, `pata_octeon_cf.c` (CF)

`ata_sff_pio_task`: delayed work on `ata_sff_wq`, queued from
`ata_sff_qc_issue` (PIO polling / writes) and now from the new data-in
completion path.

Record: `[IRQ HSM is the hot path for interrupt-driven PIO-in] [also
used by octeon CF]`

**Step 5.3: TRACE CALLEES**
`ata_pio_sectors` → `ata_pio_sector` sets `HSM_ST_LAST` on last sector.
Then the wait. `ata_sff_queue_pio_task` queues delayed work (delay 0).
`ata_hsm_qc_complete` from wq calls `ata_sff_irq_on` +
`ata_qc_complete`.

Record: `[callees: existing PIO xfer + pio_task + qc complete]`

**Step 5.4: FOLLOW THE CALL CHAIN**
Userspace read on PATA/CF/PIO → SCSI/libata → `ata_sff_qc_issue` (PIO-
in, `HSM_ST`) → device IRQ → `ata_sff_interrupt` → `ata_sff_hsm_move` →
last `ata_pio_sectors` → **old: 10ms `ata_wait_idle` in hardirq**.

Reachable from ordinary block reads on PIO ATA. Unprivileged if the
device is mounted/readable.

Record: `[reachable from userspace I/O on PIO/CF] [common on embedded,
rare on AHCI DMA desktops]`

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Error path at lines 1083–1086 still uses `ata_wait_idle(ap)` for PIO-in
+ ERR/DF. Unchanged. Other drivers (`pata_octeon_cf`, `pata_via`, …)
still use `ata_wait_idle` in tf_load / issue, not this HSM completion
wait.

Record: `[no sibling copy of this exact last-block wait; error-path
wait_idle left as-is]`

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Yes in this lineage. Pre-commit parent still has `status =
ata_wait_idle(ap)` after last PIO-in. Current HEAD already contains
`4a2e5409472e8` (`git merge-base --is-ancestor` succeeded).
`ata_sff_hsm_move` / `ata_sff_pio_task` / `ata_wait_idle` all exist.

Record: `[bug introduced ~v2.6.26; this 7.3-rc4 tree has the fix; pre-
fix code is the long-standing HSM wait]`

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
The HSM last-block `ata_wait_idle` hunk is unchanged from 2008 until
this commit. No conflicting refactor in this file after the candidate.
Expected apply on older trees that still have that hunk: **clean**.

Record: `[clean apply on trees that still have ata_wait_idle in that HSM
branch]`

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
This exact commit is already an ancestor of HEAD. That is not used as a
reason to reject: the pipeline forbids “already selected” circular
reasoning. No *different* fix for the same IRQ wait.

Record: `[no alternate fix; this is the fix]`

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
`drivers/ata/libata-sff.c` — libata SFF (legacy IDE/PATA/BMDMA/CF PIO).

Record: `[libata SFF] [IMPORTANT for PATA/CF/PIO; not core mm/net;
unused on typical AHCI-only machines]`

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Mature. HSM wait logic sat still for ~18 years. Recent ATA work is
EH/SCSI, not this completion wait.

Record: `[mature/stable HSM; bug is old, not a new-subsystem issue]`

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: DETERMINE WHO IS AFFECTED**
PIO data-in on SFF: CompactFlash, PATA in PIO, some embedded `pata_*` /
`pata_octeon_cf`, fallback PIO. Not AHCI DMA.

Record: `[driver/hardware-specific: SFF PIO-in, especially slow CF]`

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Every PIO read whose device holds BSY/DRQ > ~100µs after the last block.
Author: multiple milliseconds, every read. Unprivileged I/O on that
device is enough. Not a race.

Record: `[trigger: PIO read on slow SFF/CF] [per-command] [userspace
I/O]`

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Hardirq + port lock + IRQs off for up to 10ms **per command**.
Sequential 512-byte reads can stall the CPU for long stretches (lost
IRQs, timer/network/audio latency; possible watchdog on a very slow
device). Not a documented oops/UAF/corruption.

Official stable text also allows an **“oh, that's not good”** issue and
notable interactivity problems. This is IRQ stall, not a micro-
optimization.

Record: `[failure: IRQ/CPU stall and latency] [severity: HIGH for
CF/PATA PIO; LOW for AHCI-only]`

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
- Benefit: stops multi-ms IRQ spin on every slow PIO-in read; real CF
  report; embedded LTS users still have this hardware.
- Risk: ~17 lines, existing polling flag + workqueue; fast devices
  unchanged (~100µs still in IRQ); ~2 months in mainline with no follow-
  up revert/fix on this file.

Record: `[benefit: high for CF/PATA] [risk: low-medium] [ratio:
favorable]`

---

## PHASE 9: FINAL SYNTHESIS

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Real hardware: CF holds BSY for milliseconds; author hit it.
- Busy-wait is in hardirq, port lock held, IRQs disabled — system-wide
  latency, not a comment-only cleanup.
- Small (+17/-7), one file, existing `ATA_TFLAG_POLLING` +
  `ata_sff_pio_task`.
- Maintainer applied after review (“Looks OK”).
- Bug present since v2.6.26; no extra prereqs.
- Fast path unchanged if the device idles within ~100µs.

AGAINST:
- Worded as an improvement, not a crash/CVE.
- One reporter; no syzbot/bugzilla; no `Cc: stable`.
- Performance/interactivity bar in stable-rules prefers distro
  maintainers + bugzilla; this did not go that route.
- HSM changes can regress odd controllers (residual IRQs because nIEN is
  not set).
- Affects a shrinking hardware set (PATA/CF), not all machines.

UNRESOLVED:
- lore.kernel.org HTTP 403; thread reconstructed from b4 + mirrors.
- No public confirmation from a second user.
- No lockup-detector trace in the message (severity inferred from 10ms×N
  in hardirq, not from a posted stack).

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — matches `ata_wait_idle`
   bits; author tested on CF; maintainer applied.
2. Fixes a real bug that affects users? **PASS** — IRQ CPU hog on real
   CF reads.
3. Important issue? **PASS** — “oh, that's not good” / interactivity:
   multi-ms hardirq spin per read is a stall, not a cosmetic tweak. Not
   a UAF/panic.
4. Small and contained? **PASS** — 24 lines, one file.
5. No new features or APIs? **PASS**.
6. Can apply to the local tree? **PASS** — same HSM functions and flags;
   pre-fix hunk is the classic `ata_wait_idle` sequence.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Not a device ID, DT, build, or doc patch. Closest: **hardware
workaround** for slow CF BSY, implemented as a bounded IRQ wait +
existing polling.

Record: `[quasi-quirk: slow device BSY after last PIO-in block]`

**Step 9.4: MAKE YOUR DECISION**
This tree’s libata-sff HSM still has (and had for ~18 years) the 10ms
IRQ wait. The patch is a small, maintainer-acked correction that stops
hogging the CPU with IRQs off on every slow PIO-in completion. That is
in-scope for stable: real user-visible stall, surgical, no new API, no
missing prereqs.

---

### What the commit solves for stable users
On interrupt-driven SFF PIO reads, after the last data block the host
must wait for BSY/DRQ to clear with no completion IRQ. The kernel spun
in `ata_wait_idle()` for up to 10ms in hardirq under the port lock. Slow
CF (and similar) keeps BSY for milliseconds, so **every read** stalls
the CPU. The fix waits ~100µs in IRQ, then uses the existing PIO polling
workqueue, which sleeps instead of spinning.

### Stable rules
Meets “obviously correct,” real user-visible bug, small scope, no new
API, applies to this codebase. Importance is IRQ stall / interactivity,
which stable-rules explicitly allow as “oh, that's not good,” not only
oops/corruption.

### Risk vs benefit
Benefit is high for CF/PATA PIO (embedded, industrial, some laptops).
Risk is a modest HSM timing change, mitigated by reusing
`ATA_TFLAG_POLLING` (IRQ handler already ignores those commands) and by
leaving fast devices on the old complete-in-IRQ path.

### Concerns
No `Fixes:`/second reporter; nIEN not set when flipping to polling
(acceptable for this protocol); HSM always has some controller risk.
None of those outweigh the stall fix.

---

Verification:
- [Phase 1] Subject/body/tags from `git log -1 --format=fuller
  4a2e5409472e8`: two SOBs, no Fixes/Reported-by/Link/stable.
- [Phase 1] Body describes CF + multi-ms BSY + IRQ/`ata_wait_idle` 10ms
  spin.
- [Phase 2] `git show --stat`: `drivers/ata/libata-sff.c` +17/-7; hunks
  in `ata_sff_hsm_move` and `ata_sff_pio_task`.
- [Phase 2] `ata_wait_idle` in `include/linux/libata.h`:
  `ata_sff_busy_wait(..., ATA_BUSY|ATA_DRQ, 1000)` = 10ms; new wait uses
  max=10 (~100µs).
- [Phase 2] `__ata_sff_interrupt` skips `port_intr` when
  `ATA_TFLAG_POLLING` is set (verified in `libata-sff.c`).
- [Phase 2] `ata_hsm_ok_in_wq()` returns 1 if `ATA_TFLAG_POLLING` — WARN
  consistency checked.
- [Phase 3] `git blame` on wait site: Tejun `624d5c514eed18` (2008);
  `git describe` → v2.6.25-18 / contained in v2.6.26-rc1.
- [Phase 3] `git log HEAD -- drivers/ata/libata-sff.c`: no later commit
  on this file after 4a2e5409472e8.
- [Phase 3] Path-limited author log: only this ATA commit.
- [Phase 4] `b4 dig -c 4a2e5409472e8`: msgid
  20260717090404.857078-1-richard@nod.at.
- [Phase 4] `b4 dig -a`: v1 RFC only.
- [Phase 4] `b4 dig -w`: linux-ide, Cassel, Le Moal CCd.
- [Phase 4] Damien “Looks OK” / “Applied to for-7.3” via lkml/openwall;
  no NAK.
- [Phase 4] lore.kernel.org WebFetch: 403. Thread taken from b4 +
  patchew/openwall/lkml.
- [Phase 4] No stable@ hits for this subject.
- [Phase 5] Callers of `ata_sff_hsm_move`: `ata_sff_pio_task`,
  `__ata_sff_port_intr`, `sata_sil.c`, `sata_dwc_460ex.c`,
  `pata_octeon_cf.c`.
- [Phase 6] `git describe HEAD` / `make kernelversion` / Makefile:
  **7.3.0-rc4**.
- [Phase 6] `git merge-base --is-ancestor 4a2e5409472e8 HEAD`: yes.
- [Phase 6] Parent file still has `status = ata_wait_idle(ap)` in the
  last PIO-in branch.
- [Phase 8] Failure mode: hardirq busy-wait up to 10ms per PIO-in, not
  UAF/panic.
- UNVERIFIED: second independent user report; live NMI/softlockup log
  (not in the message).

The patch is small, correct against the SFF HSM, and fixes a real IRQ-
context stall on hardware that still shows up on stable/embedded
systems.

**YES**

 drivers/ata/libata-sff.c | 24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index 1e2a2c33cdc80..416e1239ed56d 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -1114,8 +1114,14 @@ int ata_sff_hsm_move(struct ata_port *ap, struct ata_queued_cmd *qc,
 
 			if (ap->hsm_task_state == HSM_ST_LAST &&
 			    (!(qc->tf.flags & ATA_TFLAG_WRITE))) {
-				/* all data read */
-				status = ata_wait_idle(ap);
+				status = ata_sff_busy_wait(ap,
+						ATA_BUSY | ATA_DRQ, 10);
+				if (status != 0xff &&
+				    (status & (ATA_BUSY | ATA_DRQ))) {
+					qc->tf.flags |= ATA_TFLAG_POLLING;
+					ata_sff_queue_pio_task(link, 0);
+					return 0;
+				}
 				goto fsm_start;
 			}
 		}
@@ -1213,7 +1219,7 @@ static void ata_sff_pio_task(struct work_struct *work)
 		container_of(work, struct ata_port, sff_pio_task.work);
 	struct ata_link *link = ap->sff_pio_task_link;
 	struct ata_queued_cmd *qc;
-	u8 status;
+	u8 status, wait_mask;
 	int poll_next;
 
 	spin_lock_irq(ap->lock);
@@ -1229,6 +1235,10 @@ static void ata_sff_pio_task(struct work_struct *work)
 fsm_start:
 	WARN_ON_ONCE(ap->hsm_task_state == HSM_ST_IDLE);
 
+	wait_mask = ATA_BUSY;
+	if (ap->hsm_task_state == HSM_ST_LAST)
+		wait_mask |= ATA_DRQ;
+
 	/*
 	 * This is purely heuristic.  This is a fast path.
 	 * Sometimes when we enter, BSY will be cleared in
@@ -1236,14 +1246,14 @@ static void ata_sff_pio_task(struct work_struct *work)
 	 * or something.  Snooze for a couple msecs, then
 	 * chk-status again.  If still busy, queue delayed work.
 	 */
-	status = ata_sff_busy_wait(ap, ATA_BUSY, 5);
-	if (status & ATA_BUSY) {
+	status = ata_sff_busy_wait(ap, wait_mask, 5);
+	if (status & wait_mask) {
 		spin_unlock_irq(ap->lock);
 		ata_msleep(ap, 2);
 		spin_lock_irq(ap->lock);
 
-		status = ata_sff_busy_wait(ap, ATA_BUSY, 10);
-		if (status & ATA_BUSY) {
+		status = ata_sff_busy_wait(ap, wait_mask, 10);
+		if (status & wait_mask) {
 			ata_sff_queue_pio_task(link, ATA_SHORT_PAUSE);
 			goto out_unlock;
 		}
-- 
2.53.0

