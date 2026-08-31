Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F95955C1A0;
	Mon, 31 Aug 2026 13:47:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184051; cv=none; b=nFxB7c6rCb7/ugvwlvSOF3fZPnJh6G01wfnG2CYQo+bZIq3gZlX2v9IaSJLp4LVWJTHAm6pNqSPasb580MGf9rqpP/FOwWNaLOVDJ92VmMx6nWyBRyzsLt87EQrCanvRLXuhf4RQPIQDaWk8//xtltOI4qwnDU8A5A1GuNm7jUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184051; c=relaxed/simple;
	bh=mV18t6ELgMLXsalCqmI+zu8/goJMDSo8aqyAV02qWT8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QFp7FjSAApAXrWJ09KdI5TfD5XVXePAAKDqXIMT99U3T1IbHDrb8yxv19zpyJMIG8QpBNy/BFyongxMsqfraZnaTtuZ2sfvOwUsrEuDx/d+urK1dd0lJz+l0MY6nG21mcaYjv9+QzSToPSTDgPU19R6rcqQVKBDdRKVKynlXkXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M6gSFNbd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M6gSFNbd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ABB11F00A3E;
	Mon, 31 Aug 2026 13:47:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184047;
	bh=LR3FJalAOkDVXBsPwsmAdrRm5CiLBIDVgmfUO68Pyho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M6gSFNbd9in64hN2iVcu2HX0nbFiTt6mKbbuBSv4DTyRH8iKOQPnZ8m6HOSrp+tNV
	 DTLq4uBX6yDZlN3Cvv6oX9EvHpxiiXHztaAaKG8eJ5l7B2t1HzlRXw2dP1F4RlEDRe
	 wqGVl67zsoCSl5/AMfn+NFMR0pPDIw6HV/3SCjKS/D/+DL34pV9e0wRtYv/s5ZrzIU
	 kui83K/jY5AmOLaVPDywq6D76M5t25UL2UwffBifbzm+9dTpHfHWsGD1T7aTh/1pAM
	 Ral9i923XOb4b1jcywogFD2XrXTGA3EvvB751qrge7zA4WvwAl06AHPOOCkZvlPE3d
	 85ewfDXFW9jiQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	chandrashekar.devegowda@intel.com,
	ryazanov.s.a@gmail.com,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] net: wwan: t7xx: Add delay between MD and SAP suspend
Date: Mon, 31 Aug 2026 09:28:08 -0400
Message-ID: <20260831133314.4125787-460-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>

[ Upstream commit ae733795e593272f67d607c09d2a00637ac13ed0 ]

SAP (Service Access Point) suspend occasionally times out with error
-110 (ETIMEDOUT), followed by modem port errors and complete modem
failure requiring a system reboot to recover.

Error symptoms:
  mtk_t7xx 0000:72:00.0: [PM] SAP suspend error: -110
  mtk_t7xx 0000:72:00.0: can't suspend (...returned -110)
  mtk_t7xx 0000:07:00.0: Failed to send skb: -22
  mtk_t7xx 0000:07:00.0: Write error on MBIM port, -22

The modem firmware needs time after receiving the MD (modem) suspend
request to complete internal operations before it is ready to accept
the SAP suspend request. Without this delay, if runtime PM attempts
to suspend while the firmware is busy, the SAP suspend command times
out, leaving the modem in an unrecoverable state.

Root cause and userspace interaction:
ModemManager 1.24+ includes changes that reduce the likelihood of this
issue by ensuring the modem is in a low-power state before the kernel
attempts runtime suspend. However, the kernel driver should not depend
on specific userspace behavior or ModemManager versions. Older versions
(1.20-1.22) are still widely deployed, and the kernel should be robust
regardless of userspace implementation details.

There appears to be no hardware status register or other mechanism
available to query whether the firmware is ready for SAP suspend.
A delay between the two suspend requests is the most reliable solution
found through testing.

Add a 50ms delay between MD suspend and SAP suspend. This gives the
firmware adequate time to complete internal operations without adding
significant latency to the suspend path. This makes the driver robust
across all ModemManager versions and system conditions.

Testing: 96+ hours of continuous operation with ModemManager 1.20.2
and Fibocom FM350-GL modem. Zero SAP suspend timeouts observed across
2000+ successful suspend/resume cycles. Previously failed within
24 hours with 100% reproducibility.

Signed-off-by: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>
Reviewed-by: Loic Poulain <loic.poulain@oss.qualcomm.com>
Link: https://patch.msgid.link/20260527061451.12710-1-jtornosm@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `net: wwan: t7xx: Add delay between MD and
SAP suspend`

**Local tree:** Linux **6.18.44** (`stable/linux-6.18.y`, `v6.18.44`)
**Commit under review:** `ae733795e5932` (present on `net-next`, **not**
in this 6.18.y tree)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject line
**Record:** `[net: wwan: t7xx]` `[Add]` — add a timing delay between MD
(modem) suspend and SAP (Service Access Point) suspend to prevent
firmware timeout.

### Step 1.2: Tags
**Record:**
- **Signed-off-by:** Jose Ignacio Tornos Martinez
  `<jtornosm@redhat.com>` (author)
- **Reviewed-by:** Loic Poulain `<loic.poulain@oss.qualcomm.com>`
  (Qualcomm/t7xx contributor)
- **Link:**
  https://patch.msgid.link/20260527061451.12710-1-jtornosm@redhat.com
- **Signed-off-by:** Jakub Kicinski `<kuba@kernel.org>` (netdev
  maintainer merge)
- **No** Fixes:, Reported-by:, Tested-by:, Acked-by:, Cc: stable@
- Notable: Reviewed-by from a Qualcomm engineer familiar with this
  driver; extensive testing described in commit body.

### Step 1.3: Body analysis
**Record:**
- **Bug:** SAP suspend intermittently times out with `-110` (ETIMEDOUT);
  subsequent MBIM/port errors; modem enters unrecoverable state
  requiring reboot.
- **Symptom:** `mtk_t7xx ... [PM] SAP suspend error: -110`, `can't
  suspend`, `Failed to send skb: -22`, `Write error on MBIM port, -22`.
- **Root cause:** Firmware needs processing time after MD suspend before
  accepting SAP suspend; no status register to poll readiness.
- **Trigger:** Runtime PM autosuspend (especially with older
  ModemManager 1.20–1.22); made worse by more frequent autosuspend (5s
  interval).
- **Testing:** 96+ hours, 2000+ suspend/resume cycles on Fibocom
  FM350-GL with MM 1.20.2; 100% failure within 24h before fix, zero
  failures after.

### Step 1.4: Hidden bug fix?
**Record:** No — this is an explicit bug fix disguised as a timing
workaround. Classic firmware-timing quirk fix.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **Files:** `drivers/net/wwan/t7xx/t7xx_pci.c` (+3 lines)
- **Function:** `__t7xx_pci_pm_suspend()`
- **Scope:** Single-file, surgical fix

### Step 2.2: Code flow change
**Record:**
- **Before:** Immediately after successful `H2D_CH_SUSPEND_REQ` (MD
  suspend), driver sends `H2D_CH_SUSPEND_REQ_AP` (SAP suspend).
- **After:** 50ms `msleep()` inserted between the two PM requests.
- **Path affected:** System suspend, freeze, poweroff, shutdown, and
  runtime suspend — all funnel through `__t7xx_pci_pm_suspend()`.

### Step 2.3: Bug mechanism
**Record:**
- **Category:** Hardware/firmware quirk — timing/workaround
- **Mechanism:** `t7xx_send_pm_request()` waits up to
  `PM_ACK_TIMEOUT_MS` (1500ms) for firmware ACK. If SAP suspend is sent
  while firmware is still busy handling MD suspend, ACK never arrives →
  `-ETIMEDOUT` → modem left in broken state.

### Step 2.4: Fix quality
**Record:**
- Obviously correct given firmware behavior and test results.
- Minimal change; no API/struct changes.
- **Regression risk:** Low — adds 50ms to suspend path only (not hot
  path). `msleep()` is valid in PM callbacks (process context).
- Same author previously documented identical SAP suspend `-110` errors
  in commit `ba2274dcfda85` (2023, "Add AP CLDMA").

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** Suspend sequence without delay introduced in `46e8f49ed7b30`
("Introduce power management", 2022-05-06, Haijun Liu). SAP suspend
request (`H2D_CH_SUSPEND_REQ_AP`) added via `ba2274dcfda85`
(2023-07-12). Both are ancestors of 6.18.44.

### Step 3.2: Fixes: tag
**Record:** Not applicable — no Fixes: tag present.

### Step 3.3: Related file history
**Record:**
- `a0c80d5108ab3` (2024-11-18): Changed `PM_AUTOSUSPEND_MS` from 20s to
  5s — increases suspend frequency, likely exacerbating the race.
  Present in 6.18.y.
- Recent stable t7xx fixes (RX overflow, skb_clone, etc.) show active
  maintenance of this driver in 6.18.y.
- Standalone single-patch series (v1 only per `b4 dig -a`).

### Step 3.4: Author context
**Record:** Jose Ignacio Tornos Martinez authored `ba2274dcfda85` (AP
CLDMA, which exposed SAP suspend path) and has direct experience with
this exact failure mode. Loic Poulain (Qualcomm) reviewed.

### Step 3.5: Dependencies
**Record:** None. Self-contained; cherry-picks cleanly onto 6.18.44.
Requires only existing `H2D_CH_SUSPEND_REQ` / `H2D_CH_SUSPEND_REQ_AP`
code (both present).

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original discussion
**Record:**
- **URL:**
  https://patch.msgid.link/20260527061451.12710-1-jtornosm@redhat.com
- **Series:** v1 only (no revisions)
- **Review:** Loic Poulain Reviewed-by on list (May 29, 2026)
- **Merged:** netdev/net-next by Jakub Kicinski (Jun 2, 2026)
- **No NAKs** in thread; no explicit stable nomination found

### Step 4.2: Reviewers
**Record:** CC'd to driver authors (Devegowda, Liu, Martinez), Loic
Poulain, netdev maintainers (Miller, Kicinski, Abeni, Dumazet), netdev@
and linux-kernel@.

### Step 4.3: Bug report
**Record:** Detailed reproduction in commit body and original patch.
Real hardware (Fibocom FM350-GL), real userspace (ModemManager). 100%
reproducibility within 24h without fix.

### Step 4.4: Related patches
**Record:** Not part of a series. Independent fix.

### Step 4.5: Stable list
**Record:** No stable@ discussion found in downloaded thread. Not a
negative signal per instructions.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `__t7xx_pci_pm_suspend()`, `t7xx_send_pm_request()`,
callers: `t7xx_pci_pm_suspend`, `t7xx_pci_pm_runtime_suspend`,
`t7xx_pci_shutdown`.

### Step 5.2: Callers
**Record:**
- `t7xx_pci_pm_runtime_suspend` — runtime PM (autosuspend every 5s when
  idle)
- `t7xx_pci_pm_suspend` — system sleep (S3/S4)
- `t7xx_pci_shutdown` — shutdown path
- All are `dev_pm_ops` callbacks in process context

### Step 5.3: Callees
**Record:** `t7xx_send_pm_request()` → `t7xx_mhccif_h2d_swint_trigger()`
+ `wait_for_completion_timeout()` (1500ms timeout). `msleep(50)` added
between two such calls.

### Step 5.4: Reachability
**Record:** Triggered during normal laptop idle (runtime autosuspend)
and system suspend. Common path for any system with `CONFIG_MTK_T7XX`
modem. No special privileges needed — kernel PM initiates suspend
automatically.

### Step 5.5: Similar patterns
**Record:** Other t7xx files already use `msleep()` for firmware timing
(`t7xx_modem_ops.c`: `FASTBOOT_RESET_DELAY_MS`, `RGU_RESET_DELAY_MS`;
`t7xx_state_monitor.c`: FSM delays). Consistent with driver conventions.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE (6.18.44)

### Step 6.1: Buggy code exists?
**Record:** **YES.** `drivers/net/wwan/t7xx/t7xx_pci.c` lines 444–450
send MD then SAP suspend with no delay. Bug present since PM
introduction (2022); SAP path since AP CLDMA (2023).

### Step 6.2: Backport complications
**Record:** **Clean apply** — verified via `git cherry-pick --no-commit
ae733795e5932` on 6.18.44 (exit 0, 3-line diff matches). No conflicts.

### Step 6.3: Related fixes already present?
**Record:** **NO.** `git log stable/linux-6.18.y..net-next --grep="delay
between MD"` shows only `ae733795e5932`, not yet in 6.18.y.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem criticality
**Record:** `drivers/net/wwan/t7xx` — **IMPORTANT/PERIPHERAL**. WWAN
driver for MediaTek PCIe 5G modems (Fibocom FM350-GL, Dell DW5933e, HP
DRMR-H01, etc.). Critical for affected laptop users; config-gated
(`CONFIG_MTK_T7XX`).

### Step 7.2: Subsystem activity
**Record:** Actively maintained in 6.18.y (multiple recent t7xx fixes
backported). Driver present since v5.19 era, mature PM infrastructure.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** Users with MediaTek T7xx PCIe 5G WWAN modems on
laptops/workstations. Growing install base as these modems ship in
enterprise laptops.

### Step 8.2: Trigger conditions
**Record:** Runtime PM autosuspend (every 5s when idle) or system
suspend. Common on battery-powered laptops. Timing-dependent but **100%
reproducible within 24h** per author testing. Does not require malicious
userspace.

### Step 8.3: Failure mode severity
**Record:** SAP suspend timeout → modem stuck → complete loss of
cellular connectivity → **requires reboot**. Severity: **HIGH**
(functional failure, service disruption; not a kernel oops but
unrecoverable without reboot).

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** HIGH for affected hardware — prevents modem bricking on
  routine PM
- **Risk:** VERY LOW — 3 lines, 50ms added latency on suspend only
- **Ratio:** Strongly favors backport

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Fixes real, reproducible bug (100% within 24h)
- Causes complete modem failure requiring reboot
- Extensively tested (96h+, 2000+ cycles)
- Reviewed by Qualcomm engineer
- Tiny, surgical change (hardware quirk/workaround)
- Applies cleanly to 6.18.44
- Buggy code confirmed present in this tree
- Same failure mode documented since 2023 by same author
- 5s autosuspend change in tree likely increases trigger frequency

**AGAINST backport:**
- Driver-specific (only MTK_T7XX users)
- `msleep()` is a blunt instrument (no hardware ready bit available —
  acknowledged by author)
- No syzbot/security angle

**Unresolved:** None material to the decision.

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** (Reviewed-by, 96h+ testing)
2. Fixes real bug affecting users? **PASS** (modem failure, reboot
   required)
3. Important issue? **PASS** (HIGH — complete service loss on affected
   hardware)
4. Small and contained? **PASS** (3 lines, 1 file)
5. No new features/APIs? **PASS** (timing workaround only)
6. Can apply to local tree? **PASS** (clean cherry-pick verified)

### Step 9.3: Exception category
**Record:** **Hardware quirk/workaround** — firmware needs delay between
PM steps; no status register available. Classic stable material.

### Step 9.4: Decision rationale

For Linux **6.18.y**, this commit should be backported. The buggy
suspend sequence exists in this tree, the fix is minimal and well-
tested, it addresses a serious functional failure on real hardware
(Fibocom FM350-GL and similar modems), and it applies without
modification. The 50ms delay is an acceptable cost for preventing
unrecoverable modem state during routine power management.

---

## Verification

- [Phase 1] `git describe HEAD` / `make kernelversion`: tree is 6.18.44
- [Phase 1] Parsed tags: Reviewed-by Loic Poulain, Link to lore, no
  Fixes:/Cc: stable
- [Phase 2] Diff: 3 lines in `__t7xx_pci_pm_suspend()`, adds
  `msleep(50)` between MD and SAP suspend
- [Phase 3] `git blame`: suspend code from `46e8f49ed7b30` (2022); SAP
  from `ba2274dcfda85` (2023)
- [Phase 3] `git show ba2274dcfda85`: same author documented SAP suspend
  -110 errors in 2023
- [Phase 3] `git show a0c80d5108ab3`: 5s autosuspend in 6.18.y may
  increase bug frequency
- [Phase 3] `git merge-base --is-ancestor`: driver, AP CLDMA, and 5s
  autosuspend all in 6.18.y
- [Phase 4] `b4 dig -c ae733795e5932`: found thread at patch.msgid.link
- [Phase 4] `b4 dig -a`: v1 only, no revisions
- [Phase 4] `b4 dig -w`: netdev maintainers and driver authors CC'd
- [Phase 4] `b4 dig -m /tmp/t7xx_sap.mbox`: Loic Poulain Reviewed-by;
  merged by Kicinski; no NAKs
- [Phase 5] `grep` call chain: `__t7xx_pci_pm_suspend` called from
  runtime/system PM and shutdown
- [Phase 5] `PM_ACK_TIMEOUT_MS` = 1500 in t7xx_pci.c;
  `t7xx_send_pm_request` uses completion wait
- [Phase 6] Buggy code confirmed at lines 444–450 without delay
- [Phase 6] `git cherry-pick --no-commit ae733795e5932`: applies cleanly
  (exit 0)
- [Phase 6] `git log stable/linux-6.18.y..net-next --grep="delay between
  MD"`: fix not yet in 6.18.y
- [Phase 8] Failure mode: modem unrecoverable without reboot; severity
  HIGH for affected users

**YES****Verdict: YES** — backport to **6.18.y**.

The commit (`ae733795e5932`) adds a 50ms delay between MD and SAP
suspend in the MediaTek T7xx WWAN driver. Without it, SAP suspend can
time out (`-110`), leaving the modem stuck until reboot. The buggy code
is present in 6.18.44, the patch applies cleanly, and it’s a small,
well-tested firmware timing workaround for Fibocom FM350-GL and similar
modems.

 drivers/net/wwan/t7xx/t7xx_pci.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wwan/t7xx/t7xx_pci.c b/drivers/net/wwan/t7xx/t7xx_pci.c
index eb137e0784232..46613bba1f411 100644
--- a/drivers/net/wwan/t7xx/t7xx_pci.c
+++ b/drivers/net/wwan/t7xx/t7xx_pci.c
@@ -447,6 +447,9 @@ static int __t7xx_pci_pm_suspend(struct pci_dev *pdev)
 		goto abort_suspend;
 	}
 
+	/* Delay to prevent SAP suspend timeout */
+	msleep(50);
+
 	ret = t7xx_send_pm_request(t7xx_dev, H2D_CH_SUSPEND_REQ_AP);
 	if (ret) {
 		t7xx_send_pm_request(t7xx_dev, H2D_CH_RESUME_REQ);
-- 
2.53.0

