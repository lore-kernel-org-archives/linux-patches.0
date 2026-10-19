Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B552B57DF56;
	Mon, 19 Oct 2026 13:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418318; cv=none; b=FtB9s/1G5AWISae9FaCsYg/HoYRcf9aa0d4DRca+6zeSE+G+g9Dt+er8Cwu8Ob348SME5S2QmvumfzJ5gn2RpdDLleuOdRIfNdFrNgucnrNdsOuA0FJhTZg51DhvrAM0gXw8RqWn08C7EZtEU73TFQ1idv6uwLg3IuyufMWpoyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418318; c=relaxed/simple;
	bh=TByxiAa87WS+0dfP+PTPC56jYerIQi/Vl0JP/+iO7Q8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sBT5sycsG/ywQAPts898othtfomvaIoTOH/R5kDrT68MmwiV4nkPfnSyKuGpzJUo6remHQ3vpmfIIBM1m4qepJksWINScWzSXzSOfEk5nCf0dRriRmj7OE4MO8E2oF2TIHiPUSepUBhAHygh4rBFotHv/dyUj3QjkYhL1S4Tdgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RDpzZOoE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RDpzZOoE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A24F61F000C7;
	Mon, 19 Oct 2026 13:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418314;
	bh=KRme9n4h5hg79JHHCTeZvcrZGH9RVtyMTsRB4ixU1CU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RDpzZOoEiEg5UpIcJYyJkc3nrFP8G80fs3fwW709N7RM2ikjFSF/P0CYcCYflqp1V
	 Fizs6amBwHIMsMynUKg144eiN9cH9qq6CbNZ33AzFivkkq1KX1rpiSEMWBeMYH0yRd
	 ihPOtmj9dz+eZRW/+UOJTCYHm165SAux9SKt8h/wEp31mQfHq7B8xVQMryPhZIKxlG
	 aO4NbcuXLmvX/iUvIvSDA8FZcEKAXTw1UCA8WUzv7jI1RSqMi8fLA9Uja+K4vZ84oj
	 iv4lrXOYbcdzizGHZAqBp+yKdlMLIT8Et7HxjyP6VnVAdKDKGY5eaC7G4Nq8j1LeTX
	 knZM4G9QH/twg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Qingtao Cao <qingtao.cao.au@gmail.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Krishna Chaitanya Chundru <krishna.chundru@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>,
	mhi@lists.linux.dev,
	linux-arm-msm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] bus: mhi: core: Fix sys error transition latency
Date: Mon, 19 Oct 2026 09:47:31 -0400
Message-ID: <20261019135441.1420968-160-sashal@kernel.org>
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

From: Qingtao Cao <qingtao.cao.au@gmail.com>

[ Upstream commit 22568e8f13a42ab69b7d624741768cbf15dded74 ]

Bring forward the idea to fix the power down latency in
mhi_pm_disable_transition() further to mhi_pm_sys_error_transition()
so that the transition into system error (triggered by AT!RESET) in the
modems won't have to return only after the timeout of up to 24 seconds.

Once the device gets reset, there is no guarantee that it will send an
interrupt to indicate the state transition. So polling is the sensible
option here.

Signed-off-by: Qingtao Cao <qingtao.cao.au@gmail.com>
[mani: commit log]
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Reviewed-by: Krishna Chaitanya Chundru <krishna.chundru@oss.qualcomm.com>
Link: https://patch.msgid.link/20260603011333.3306102-2-qingtao.cao.au@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

I have the mailing-list thread, the 2021 sibling fix, and the local
7.3-rc4 code. Next I’ll write the full nine-phase verdict.

## Phase 1: Commit message forensics

**Step 1.1: PARSE THE SUBJECT LINE**

Record: `[bus: mhi: core:]` `[Fix]` `[sys error transition latency]` —
MHI host power-management: after a device SYSERR/RESET, the host was
waiting on an interrupt-driven event that may never arrive, so recovery
sat until `timeout_ms` (up to 24s).

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**

Record:
- `Signed-off-by: Qingtao Cao <qingtao.cao.au@gmail.com>` (author)
- `[mani: commit log]` then `Signed-off-by: Manivannan Sadhasivam
  <mani@kernel.org>` (MHI maintainer applied it and rewrote the log)
- `Reviewed-by: Krishna Chaitanya Chundru
  <krishna.chundru@oss.qualcomm.com>` (Qualcomm MHI reviewer)
- `Link: https://patch.msgid.link/20260603011333.3306102-2-
  qingtao.cao.au@gmail.com`
- No `Fixes:`, `Reported-by:`, `Tested-by:`, `Cc:
  stable@vger.kernel.org`, or syzbot tags (absence of Fixes/Cc:stable is
  expected here)

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**

Record:
- **Bug:** `mhi_pm_sys_error_transition()` waits with
  `wait_event_timeout()` for the MHI RESET bit to clear. After RESET,
  the device is not guaranteed to raise an interrupt, so the wait often
  runs to the full controller timeout.
- **Symptom:** SYSERR handling triggered by modem `AT!RESET` does not
  finish until timeout (commit text: up to 24 seconds).
- **Root cause:** interrupt-driven wait is the wrong primitive after
  RESET; polling the RESET bit is the correct approach (already used in
  `mhi_pm_disable_transition()`).
- **Version info in the message:** none. Thread later names a 5.17 test
  kernel and Sierra EM9291; the same wait lives in this tree.

**Step 1.4: DETECT HIDDEN BUG FIXES**

Record: Not a disguised cleanup. Subject and body both say “Fix”. It is
a real timeout/hang-style bug, the same class as `44b1eba44dc53` (“Fix
power down latency”), which had `Cc: stable`.

## Phase 2: Diff analysis

**Step 2.1: INVENTORY THE CHANGES**

Record:
- File: `drivers/bus/mhi/host/pm.c` — 3 insertions, 11 deletions (net
  −8)
- Function: `mhi_pm_sys_error_transition()`
- Scope: single-file surgical wait-primitive swap; error-path structure
  (`MHI_PM_SYS_ERR_FAIL`, `BHI_INTVEC` reprogram) unchanged

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**

Record: Inside `if (reset_device)` after `mhi_set_mhi_state(...,
MHI_STATE_RESET)`:

- **Before:** `wait_event_timeout(state_event, mhi_read_reg_field(...)
  || !in_reset, timeout)`. `wait_event_timeout()` only rechecks on
  wakeup or timeout. After RESET, MSI is not expected, so the wait
  typically sleeps the full `timeout_ms`.
- **After:** `mhi_poll_reg_field(..., MHICTRL_RESET_MASK, 0, 25000,
  mhi_cntrl->timeout_ms)` — poll every 25ms until RESET clears or
  timeout. Failure still uses `if (ret)` → `MHI_PM_SYS_ERR_FAIL`.

Path: SYSERR recovery / RESET, not probe init.

**Step 2.3: IDENTIFY THE BUG MECHANISM**

Record: **Logic / correctness (wrong wait primitive after hardware
RESET)** — not UAF/leak/race.

Mechanism: RESET drops device interrupt context; host waited for
`state_event`. Nobody wakes it, so SYSERR recovery is delayed by the
full timeout even though the device already cleared RESET. Polling
matches power-down and power-up.

**Step 2.4: ASSESS THE FIX QUALITY**

Record:
- Obviously correct: same helper/interval already used in
  `mhi_pm_disable_transition()` and `mhi_ready_state_transition()` in
  this tree.
- Minimal: only the wait is replaced.
- Regression risk: low. Polling `fsleep(25000)` on a workqueue is the
  established pattern. Worst case is still `timeout_ms`, same as before.
  Does not change APIs or PM state machine.

## Phase 3: Git history

**Step 3.1: BLAME THE CHANGED LINES**

Record: Pre-fix `wait_event_timeout` block blamed to `556bbb442bbb44`
(“Separate system error and power down handling”, 2020-11-18, first in
**v5.11-rc1**). That split copied the wait into the new
`mhi_pm_sys_error_transition()`. Surrounding reset-decision code later
touched by `4d92e7c5ccadc` (2025) and `bce3f770684cc`
(`MHI_PM_SYS_ERR_FAIL`, 2024); those are not required for this hunk.

**Step 3.2: FOLLOW THE FIXES: TAG**

Record: No `Fixes:` tag. The incomplete sibling is `44b1eba44dc53`
(2021-06-24, “Fix power down latency”) with `Cc: stable` and `Fixes:
a6e2e3522f29`. That commit converted **disable/power-down** to
`mhi_poll_reg_field` and left **sys_error** on `wait_event_timeout`.
This commit finishes that leftover.

**Step 3.3: CHECK FILE HISTORY**

Record: Recent `pm.c` commits (`753aa72545ce0` no-M3, `aa1a0e93ed21a`
SYS_ERR power-up, `4d92e7c5ccadc` power_up vs SYSERR) are unrelated.
Standalone; not patch 2/N of a functional series.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**

Record: Qingtao Cao has this single MHI commit in this tree. Applied by
maintainer Manivannan Sadhasivam; reviewed by Krishna Chaitanya Chundru
(Qualcomm).

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**

Record: Needs `mhi_poll_reg_field(..., delayus, timeout_ms)` as in
`drivers/bus/mhi/host/main.c` (this tree). Signature came from
`1a42aef258805` plus later bitfield/timeout updates (`d28cab4d4aa06`,
`6ab3d50b106c9`). All present here. Applies standalone.

## Phase 4: Mailing list and external research

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**

Record:
- `b4 dig -c 22568e8f13a42`: https://patch.msgid.link/20260603011333.330
  6102-2-qingtao.cao.au@gmail.com
- `b4 dig -a`: single **v1**, subject `[v1 PATCH 1/1] bus: mhi: core:
  fix sys error handling latency` (msgid `-2` is numbering, not a
  2-patch series)
- Thread (5 messages via `b4 mbox`):
  1. Qingtao: 24s SYSERR wait on `AT!RESET`
  2. Krishna: initially “we should not see this delay”
  3. Qingtao: Sierra Wireless EM9291, reused EM919x config (`timeout_ms
     = 24000`); without patch ~24s, with patch ~11s; 5.17 test kernel
  4. Krishna: device **does** clear RESET; **MSI is not expected after
     MHI RESET**; `Reviewed-by`
  5. Qingtao: same issue as `44b1eba44dc53`
  6. Mani: applied as `22568e8f13a42`
- No NAK. No reviewer `Cc: stable`. Maintainer improved the commit log
  (polling rationale).

**Step 4.2: CHECK WHO REVIEWED THE PATCH**

Record: `b4 dig -w`: To/Cc included `mani@kernel.org` (maintainer),
`mhi@lists.linux.dev`, `linux-arm-msm@vger.kernel.org`, `linux-
kernel@vger.kernel.org`, Krishna (review), Vivek Pernamitta. Right lists
and maintainer.

**Step 4.3: SEARCH FOR THE BUG REPORT**

Record: No bugzilla/syzbot. Report is the patch author on real hardware
(EM9291 / `AT!RESET`). Krishna confirmed it is generic MHI RESET
behavior, not one broken device.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**

Record: Standalone 1/1. Related historical fix `44b1eba44dc53` already
in this tree.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**

Record: **UNVERIFIED** — lore.kernel.org WebFetch returned 403; no
stable@ discussion in the mbox. No evidence it was NAK’d for stable.

## Phase 5: Code semantic analysis

**Step 5.1: IDENTIFY KEY FUNCTIONS**

Record: `mhi_pm_sys_error_transition()`; helper `mhi_poll_reg_field()`.

**Step 5.2: TRACE CALLERS**

Record:
- `mhi_pm_st_worker()` → `DEV_ST_TRANSITION_SYS_ERR` →
  `mhi_pm_sys_error_transition()`
- `mhi_pm_sys_err_handler()` queues that transition
- `mhi_pm_sys_err_handler()` from `drivers/bus/mhi/host/main.c`: SYSERR
  in intvec, ctrl event ring `MHI_STATE_SYS_ERR`, IRQ with no events

Call path: device SYSERR / host RESET processing on the MHI high-prio
workqueue. Reachable when a WWAN modem hits SYSERR or `AT!RESET`.

**Step 5.3: TRACE CALLEES**

Record: `mhi_set_mhi_state(RESET)`, `mhi_poll_reg_field` →
`mhi_read_reg_field` + `fsleep`, `mhi_tryset_pm_state`,
`mhi_write_reg(BHI_INTVEC)`. No new locks or allocations.

**Step 5.4: FOLLOW THE CALL CHAIN**

Record: Userspace (`AT!RESET` or modem crash) → device SYSERR → host
IRQ/event → workqueue → this function. Unprivileged users typically
cannot issue `AT!RESET` without modem access; operators and WWAN stacks
can. Not a theoretical path.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**

Record: Same poll already in `mhi_pm_disable_transition()`,
`mhi_ready_state_transition()`, and `mhi_async_power_up()` SYS_ERR
reset. Remaining `wait_event_timeout()` uses are M0/M2/M3-style waits
that still get IRQs — correctly left alone.

## Phase 6: Cross-referencing against the local tree

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**

Record:
- Local tree: **v7.3-rc4** (`VERSION=7 PATCHLEVEL=3 SUBLEVEL=0
  EXTRAVERSION=-rc4`, `HEAD` `f0100363d8c37`)
- File `drivers/bus/mhi/host/pm.c` exists;
  `mhi_pm_sys_error_transition()` exists
- Buggy `wait_event_timeout` present from v5.11 through parent of
  `22568e8f13a42`; this commit is already on `HEAD` as a mainline merge
  (`git merge-base --is-ancestor 22568e8f13a42 HEAD` succeeded)
- EM929x uses `modem_sierra_em919x_config` with `.timeout_ms = 24000` in
  `pci_generic.c` — same 24s the reporter hit

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**

Record: Clean apply on this tree. `mhi_poll_reg_field()` 6-argument form
matches. No conflicting refactor of this hunk.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**

Record: Power-down poll fix `44b1eba44dc53` is here. No other equivalent
sys_error poll fix besides this commit.

## Phase 7: Subsystem and maintainer context

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**

Record: `drivers/bus/mhi/host/` — MHI host bus for Qualcomm/Sierra/Telit
WWAN modems. **IMPORTANT** (not core mm/VFS): common on laptops,
embedded, Android with WWAN. Maintainer: Manivannan Sadhasivam.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**

Record: Actively maintained (recent no-M3, SYSERR/power_up, tracing,
pci_generic). The wait itself is old (2020); this is a long-standing
leftover, not churn in new code.

## Phase 8: Impact and risk

**Step 8.1: DETERMINE WHO IS AFFECTED**

Record: Driver-specific: MHI host users (WWAN PCI modems). EM919x/EM929x
and any controller that takes SYSERR + RESET. RDDM controllers skip
`mhi_pm_sys_err_handler()`, so they are not on this path.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**

Record: Modem SYSERR or `AT!RESET`. Not every boot; common for modem
recovery/reset. Krishna: **no MSI after RESET is expected** — so the
full-timeout wait is the normal case, not a rare race. Unprivileged
trigger only with modem AT access.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**

Record: Host sleeps in SYSERR recovery until `timeout_ms` (8s–24s
typical, 50s–120s on some `pci_generic` configs) even after RESET has
cleared. Not oops/corruption/UAF. User-visible: WWAN reset/recovery
stalled for tens of seconds. **Severity: MEDIUM-HIGH** (hang-like
timeout on a real device path). Measured: 24s → ~11s on EM9291.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**

Record:
- **Benefit:** high for MHI modem users — removes a systematic multi-
  second stall on SYSERR/RESET. Same class as the 2021 stable-bound
  power-down fix.
- **Risk:** very low — 3 lines added / 11 removed, proven helper, error
  handling unchanged.
- **Ratio:** benefit ≫ risk.

## Phase 9: Final synthesis

**Step 9.1: COMPILE THE EVIDENCE**

**FOR:**
- Real, user-reported stall (Sierra EM9291 `AT!RESET`, 24s vs ~11s)
- Qualcomm reviewer: MSI after RESET is not expected — generic protocol
  bug
- Identical 2021 power-down fix (`44b1eba44dc53`) was `Cc: stable`
- Small, obviously correct, already used on the disable path in this
  tree
- Maintainer applied; Reviewed-by from Qualcomm
- Buggy wait present since v5.11; EM929x + 24000ms timeout exist in this
  tree
- `mhi_poll_reg_field` already here; applies cleanly

**AGAINST:**
- Not oops/UAF/corruption/security
- No `Fixes:` / `Cc: stable` (not a negative per the review rules)
- Author’s measurements were on 5.17; logic is unchanged in this tree
- Krishna first questioned the delay, then agreed and reviewed

**UNRESOLVED:**
- Whether stable@ ever discussed this (lore 403)
- Cover letter `3306102-1` body not fetched; series is 1/1 from b4

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**

1. Obviously correct and tested? **PASS** — copies existing poll; author
   measured; maintainer + Qualcomm review
2. Fixes a real bug that affects users? **PASS** — 24s SYSERR recovery
   on real modem hardware
3. Important issue (crash, security, corruption, deadlock)? **PASS** —
   hang-like timeout on RESET; stable rules also cover hangs and “oh,
   that’s not good”; sibling fix was stable material
4. Small and contained? **PASS** — 14-line hunk, one function
5. No new features or APIs? **PASS**
6. Can apply to the local tree? **PASS** — code, helper, and signature
   all present

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**

Record: None (not a device ID, quirk table, DT, build, or docs patch).
Qualifies as a normal bugfix.

**Step 9.4: MAKE YOUR DECISION**

This tree is v7.3-rc4. The SYSERR path still used interrupt wait after
RESET until this change. That wait is wrong for MHI RESET, stalls
recovery for the full controller timeout, and was already fixed the same
way for power-down in 2021 (and sent to stable). The leftover in
`mhi_pm_sys_error_transition()` is a small, proven, user-visible fix and
belongs in this tree.

### What the commit solves for this tree

`mhi_pm_sys_error_transition()` issued MHI RESET then used
`wait_event_timeout()` on `state_event`. After RESET the device drops
interrupt context and does not send MSI, so the host slept until
`timeout_ms` (24s on EM919x/EM929x). Switching to `mhi_poll_reg_field()`
watches the RESET bit directly, which is what disable/power-up already
do here.

### Stable rules / risk

Meets the rules: real hang-style bug, tiny, no new API, applies cleanly.
Risk is a 25ms poll loop already used on adjacent paths. Benefit is much
shorter modem SYSERR/`AT!RESET` recovery.

### Concerns

None that block this tree: helper signature matches; no series deps. Not
a crash/CVE, but a systematic tens-of-seconds stall on a production WWAN
path.

Verification:
- [Phase 1] Tags: SOB Qingtao + Mani, R-b Krishna, Link msgid; no
  Fixes/Cc:stable/syzbot
- [Phase 2] Diff: `pm.c` `mhi_pm_sys_error_transition()`,
  `wait_event_timeout` → `mhi_poll_reg_field`, 3+/11-
- [Phase 3] blame: `556bbb442bbb44` (v5.11-rc1) introduced the wait;
  `44b1eba44dc53` (2021, Cc:stable) fixed only disable
- [Phase 3] `git merge-base --is-ancestor 22568e8f13a42 HEAD`: yes;
  `44b1eba44dc53` and `556bbb442bbb44` also ancestors
- [Phase 3] `mhi_poll_reg_field` in `main.c` takes `(mask, val, delayus,
  timeout_ms)` matching the patch
- [Phase 4] `b4 dig -c 22568e8f13a42`: lore msgid
  `20260603011333.3306102-2`; v1 only
- [Phase 4] `b4 dig -a`: 1/1 series; `b4 dig -w`: maintainer +
  mhi/linux-arm-msm lists
- [Phase 4] `b4 mbox`: Krishna confirmed no MSI after RESET; EM9291
  24s→11s; Mani applied
- [Phase 4] WebFetch lore/patch.msgid.link: 403 — thread recovered via
  b4
- [Phase 5] callers: `mhi_pm_st_worker` / `mhi_pm_sys_err_handler` from
  SYSERR IRQ/event in `main.c`
- [Phase 6] `git describe HEAD`: v7.3-rc4-27-gf0100363d8c37; `make
  kernelversion`: 7.3.0-rc4
- [Phase 6] `pci_generic.c`: EM929x shares EM919x config, `timeout_ms =
  24000`
- [Phase 8] Failure: SYSERR recovery blocked until timeout; severity
  hang-like, not oops
- UNVERIFIED: stable@ lore discussion (HTTP 403)
- UNVERIFIED: cover letter body `3306102-1`

**YES**

 drivers/bus/mhi/host/pm.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/bus/mhi/host/pm.c b/drivers/bus/mhi/host/pm.c
index b4ef115189b50..71bcb0f98ce6a 100644
--- a/drivers/bus/mhi/host/pm.c
+++ b/drivers/bus/mhi/host/pm.c
@@ -651,21 +651,13 @@ static void mhi_pm_sys_error_transition(struct mhi_controller *mhi_cntrl)
 
 	/* Trigger MHI RESET so that the device will not access host memory */
 	if (reset_device) {
-		u32 in_reset = -1;
-		unsigned long timeout = msecs_to_jiffies(mhi_cntrl->timeout_ms);
-
 		dev_dbg(dev, "Triggering MHI Reset in device\n");
 		mhi_set_mhi_state(mhi_cntrl, MHI_STATE_RESET);
 
 		/* Wait for the reset bit to be cleared by the device */
-		ret = wait_event_timeout(mhi_cntrl->state_event,
-					 mhi_read_reg_field(mhi_cntrl,
-							    mhi_cntrl->regs,
-							    MHICTRL,
-							    MHICTRL_RESET_MASK,
-							    &in_reset) ||
-					!in_reset, timeout);
-		if (!ret || in_reset) {
+		ret = mhi_poll_reg_field(mhi_cntrl, mhi_cntrl->regs, MHICTRL,
+				 MHICTRL_RESET_MASK, 0, 25000, mhi_cntrl->timeout_ms);
+		if (ret) {
 			dev_err(dev, "Device failed to exit MHI Reset state\n");
 			write_lock_irq(&mhi_cntrl->pm_lock);
 			cur_state = mhi_tryset_pm_state(mhi_cntrl,
-- 
2.53.0

