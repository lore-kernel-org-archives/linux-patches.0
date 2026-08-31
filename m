Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FBF35AA69B;
	Mon, 31 Aug 2026 13:52:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184362; cv=none; b=JM25OHd9pHVO+DQ37Cfma8+FvNkh4wyCCArinW8XLQAgjjn0fMKix8n0nVbdXx/rZkf3cJJcfY/ZfrOdFkpk50lzTkv3HEFCAxW9wcRiJ3ILp0wHo3/vajqmeY7lsz/t4+3Xnz1jlZEO24xkd6FIMz3LbjwHgGXG0b+PocLO+20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184362; c=relaxed/simple;
	bh=P7GWI4QqTyfKeMIcOp/wfgw+pvLSHaZ81/lMOGaRcoM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=huuquR7aE0e7+/8yv1GeKmjoTR1n9SapF5VET/KdljP1k8JY3RMlM2LR+cAKdNBs0YpcBzEd8w6qcpWZZN+VJSLsLXyW1Wy53CfdXY16jbBeuYY7Z5ohU8eK6cIyWpVaWrsl66LExf6UzoO1edW0FvBwi3BxRXeyg8Y4j7fY56U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZdCuWFCX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZdCuWFCX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D30FB1F00ADF;
	Mon, 31 Aug 2026 13:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184360;
	bh=gn/x46AcCcCqDneJy+pgdlKQ+Wml9FPVINTnDu7omW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZdCuWFCXLnum0OR0fxNVjjU2gh6h/TxZPIDTrrpmNdNblnDOWIbVP7xilAGhLejAS
	 6GPNrYs6O9oEoqc1i7BT5UANw6vFeiPlM2Eawt7uvA69xNfhTIuChevbbhAPrdDHVy
	 V044cOkuWct+HL1cSHLVTu4RNBootywF/FPdP8RMItZPbkacH8Y4QTUDuT0t0nlY5f
	 zj7i34ZpwWQzYzsqW4wruSnUlBJCvqZFJiOqMgxD2r9IXv9s8ZNm/hT51+zkCs9EBI
	 jbOHhYV7WbobXL3S6swoUvygQWAVRTYmML3TC3UYJlvrSCRpU4Fc8J57AkAukeH7J2
	 AwbW+5gHfbuIQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Stanley Chu <yschu@nuvoton.com>,
	Frank Li <Frank.Li@nxp.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>,
	miquel.raynal@bootlin.com,
	linux-i3c@lists.infradead.org,
	imx@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] i3c: master: svc: Prevent IRQ storm from false SLVSTART on NPCM845
Date: Mon, 31 Aug 2026 09:31:15 -0400
Message-ID: <20260831133314.4125787-647-sashal@kernel.org>
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

From: Stanley Chu <yschu@nuvoton.com>

[ Upstream commit 1effa3adfe53cb2bb28bf5640a676b791d5ab405 ]

On NPCM845, when a target on the I3C bus gets stuck holding SDA low,
the controller reports a false Master Request (MR) in-band interrupt
event. The driver handles this by emitting a STOP condition to restore
the bus.

However, the hardware quirk SVC_I3C_QUIRK_FALSE_SLVSTART indicates that
emitting a STOP condition may spuriously set the SLVSTART interrupt
status bit. In the Master Request case, this creates a feedback loop:
the STOP triggers a new SLVSTART event, the IRQ handler fires again,
the controller still reports an MR type, another STOP is emitted, and
the cycle repeats indefinitely, resulting in an IRQ storm that can lock
up the CPU.

Clear the SLVSTART status bit explicitly after emitting the STOP in the
Master Request IBI handler when the SVC_I3C_QUIRK_FALSE_SLVSTART quirk
is set. This breaks the feedback loop without affecting normal SLVSTART
processing, which is already guarded in the top-level IRQ handler by
checking that MSTATUS is in SLVREQ state.

Signed-off-by: Stanley Chu <yschu@nuvoton.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260413005040.1211107-3-yschu@nuvoton.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: i3c: master: svc: Prevent IRQ storm from
false SLVSTART on NPCM845

**Local tree:** Linux 6.18.43 (`v6.18.43-1-gc7f0dac02d232`)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
**Record:** `[i3c: master: svc]` `[Prevent]` — Prevent IRQ storm from
false SLVSTART on NPCM845 (Nuvoton BMC I3C master driver hardware quirk
workaround).

### Step 1.2: Tags
**Record:**
- **Signed-off-by:** Stanley Chu `<yschu@nuvoton.com>` (author)
- **Reviewed-by:** Frank Li `<Frank.Li@nxp.com>` (NXP I3C reviewer)
- **Link:**
  https://patch.msgid.link/20260413005040.1211107-3-yschu@nuvoton.com
- **Signed-off-by:** Alexandre Belloni `<alexandre.belloni@bootlin.com>`
  (I3C maintainer)
- No Fixes:, Reported-by:, Tested-by:, Cc: stable@vger.kernel.org
- Notable: Reviewed by subsystem reviewer; maintainer applied the
  series. No syzbot report (hardware-specific quirk).

### Step 1.3: Body Analysis
**Record:**
- **Bug:** On NPCM845, when an I3C target holds SDA low (bus stuck), the
  controller reports a false Master Request (MR) IBI. The driver emits
  STOP to recover the bus, but STOP spuriously sets the SLVSTART status
  bit (known `SVC_I3C_QUIRK_FALSE_SLVSTART` behavior).
- **Symptom:** Feedback loop — STOP → spurious SLVSTART → IRQ handler →
  MR again → STOP → … → **IRQ storm that can lock up the CPU**.
- **Root cause:** MR handler emits STOP without clearing the spurious
  SLVSTART bit afterward; top-level quirk guard (SLVREQ state check)
  does not break this specific MR+stuck-SDA loop.
- **Fix:** After STOP in the `MASTER_REQUEST` IBI path, explicitly clear
  SLVSTART when the quirk is set.
- **Version info:** NPCM845-specific; no kernel version range stated.

### Step 1.4: Hidden Bug Fix Detection
**Record:** Not disguised — explicitly a bug fix for IRQ storm / CPU
lockup. Falls under hardware quirk/workaround exception category.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
**Record:**
- **File:** `drivers/i3c/master/svc-i3c-master.c` (+9 lines, 0 removed)
- **Function modified:** `svc_i3c_master_ibi_isr()`
- **Scope:** Single-file, surgical fix in one `switch` case
  (`SVC_I3C_MSTATUS_IBITYPE_MASTER_REQUEST`)

### Step 2.2: Code Flow Change
**Record:**
- **Hunk (MASTER_REQUEST case):**
  - **Before:** `svc_i3c_master_emit_stop(master); break;`
  - **After:** Same STOP, then if `SVC_I3C_QUIRK_FALSE_SLVSTART` quirk
    is set, `writel(SVC_I3C_MINT_SLVSTART, master->regs +
    SVC_I3C_MSTATUS)` to clear spurious SLVSTART.
- **Path affected:** IRQ-driven IBI handler, non-critical task section,
  MR event only, only when quirk bit is set (NPCM845).

### Step 2.3: Bug Mechanism
**Record:** **Category:** Hardware quirk workaround / IRQ storm
prevention (synchronization with hardware interrupt status).
- STOP on NPCM845 spuriously sets SLVSTART interrupt status.
- In MR+stuck-SDA scenario, top-level handler's SLVREQ guard does not
  prevent re-entry into MR handling.
- Explicit status clear after STOP breaks the feedback loop.

### Step 2.4: Fix Quality
**Record:**
- **Obviously correct:** Uses the same `writel(SVC_I3C_MINT_SLVSTART,
  ...)` pattern already used in `svc_i3c_master_irq_handler()` at line
  626.
- **Minimal:** Quirk-gated, only in MR path.
- **Regression risk:** Very low — only affects NPCM845
  (`npcm845_drvdata` sets `SVC_I3C_QUIRK_FALSE_SLVSTART`). Normal
  SLVSTART processing remains guarded by SLVREQ check in the top-level
  IRQ handler.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
**Record:** Lines 609–611 (`MASTER_REQUEST` STOP without clear) blamed
to `19eef1d98eeda` (kernel import). The MR+STOP path predates this
series; the missing clear is a gap in the original
`SVC_I3C_QUIRK_FALSE_SLVSTART` handling from March 2025.

### Step 3.2: Fixes: Tag
**Record:** No Fixes: tag. N/A.

### Step 3.3: Related File History
**Record:** Related commits in this tree on `svc-i3c-master.c`:
- `466c7f87de52d` — Fix missed IBI after false SLVSTART (series patch
  1/2, **present**)
- `98ddff8a90f82` — Initialize `dev` to NULL in
  `svc_i3c_master_ibi_isr()`
- `8ddff9989f06a` — Prevent incomplete IBI transaction
- Quirk introduced via code present since kernel import;
  `SVC_I3C_QUIRK_FALSE_SLVSTART` and `npcm845_drvdata` confirmed in
  tree.

### Step 3.4: Author Context
**Record:** Stanley Chu (Nuvoton) authored NPCM845 I3C fixes. Frank Li
(NXP) reviewed. Alexandre Belloni (I3C maintainer) committed. Author has
multiple related svc-i3c-master fixes in this tree.

### Step 3.5: Dependencies
**Record:**
- **Prerequisite:** Patch 1/2 (`466c7f87de52d` — re-read MSTATUS in IRQ
  handler) is **already in this tree**.
- **Required infrastructure:** `SVC_I3C_QUIRK_FALSE_SLVSTART`,
  `svc_has_quirk()`, `npcm845_drvdata` — all **present**.
- **Standalone:** This patch (2/2) is self-contained; applies cleanly on
  top of current tree (`git apply --check` passed).
- Upstream commit: `1effa3adfe53c`; **not yet in this 6.18.43 tree**.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original Discussion
**Record:**
- **b4 dig -c 1effa3adfe53c:**
  https://patch.msgid.link/20260413005040.1211107-3-yschu@nuvoton.com
- **Series:** v1, 2 patches: (1) Fix missed IBI, (2) Prevent IRQ storm
- **Maintainer response:** Alexandre Belloni: "Applied, thanks!" — both
  patches applied to i3c tree.
- **Stable nomination:** None found in thread.
- **NAKs/concerns:** None found.

### Step 4.2: Reviewers
**Record:** CC'd: frank.li@nxp.com, miquel.raynal@bootlin.com,
alexandre.belloni@bootlin.com, linux-i3c@lists.infradead.org, Nuvoton
engineers. Reviewed-by: Frank Li.

### Step 4.3: Bug Report
**Record:** No external bug report or syzbot link. Hardware quirk
described by Nuvoton driver author; credible for embedded BMC platform.

### Step 4.4: Series Context
**Record:** 2-patch series addressing false SLVSTART quirk. Patch 1
fixes missed IBI (race); patch 2 fixes IRQ storm (feedback loop). Both
are complementary; patch 1 already in this tree; patch 2 is still
missing.

### Step 4.5: Stable List History
**Record:** Not searched on lore stable list; no stable nomination found
in patch thread. Absence is not a negative signal per instructions.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key Functions
**Record:** `svc_i3c_master_ibi_isr()` (modified),
`svc_i3c_master_irq_handler()` (caller, unmodified).

### Step 5.2: Callers
**Record:**
- `svc_i3c_master_irq_handler()` → `svc_i3c_master_ibi_isr()` (line 646)
- IRQ registered via `devm_request_irq()` at line 1944
- **Context:** Hard IRQ context on I3C SLVSTART interrupt — hot path for
  all IBI events on NPCM845.

### Step 5.3: Callees
**Record:** `svc_i3c_master_emit_stop()`, `svc_has_quirk()`, `writel()`
to hardware MSTATUS register.

### Step 5.4: Reachability
**Record:**
- Triggered when I3C bus target holds SDA low (hardware fault or
  misbehaving device).
- IRQ-driven, runs on every spurious SLVSTART in the MR feedback loop.
- Not directly userspace-triggerable, but bus faults on BMC/server
  platforms are realistic production scenarios.
- **Impact when triggered:** Continuous IRQ processing → CPU lockup.

### Step 5.5: Similar Patterns
**Record:** Top-level IRQ handler already clears SLVSTART and has quirk
guard. IBI and HOT_JOIN cases also emit STOP but do not need this extra
clear (commit explains MR-specific loop). Same
`writel(SVC_I3C_MINT_SLVSTART, ...)` idiom used elsewhere in file.

---

## PHASE 6: CROSS-REFERENCING AGAINST LOCAL TREE

### Step 6.1: Buggy Code Exists?
**Record:** **YES.** Current tree at lines 609–611:

```609:611:drivers/i3c/master/svc-i3c-master.c
        case SVC_I3C_MSTATUS_IBITYPE_MASTER_REQUEST:
                svc_i3c_master_emit_stop(master);
                break;
```

No SLVSTART clear after STOP. `SVC_I3C_QUIRK_FALSE_SLVSTART` and
`npcm845_drvdata` are present (lines 154, 2056–2059). Prerequisite patch
`466c7f87de52d` is present. Upstream fix `1effa3adfe53c` is **not** in
this tree.

### Step 6.2: Backport Complications
**Record:** **Clean apply** — `git apply --check` against upstream diff
succeeded with no conflicts. No rework needed.

### Step 6.3: Related Fixes Already Present?
**Record:** Patch 1/2 (`466c7f87de52d`) present. IRQ storm fix
(`1effa3adfe53c`) absent. No alternate fix for this issue found.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem Criticality
**Record:** **Subsystem:** `drivers/i3c/master/` — I3C bus master driver
(Silvaco/Vayavya Labs SVC IP, Nuvoton NPCM845). **Criticality:**
IMPORTANT/PERIPHERAL — affects NPCM845 BMC platforms specifically, but
IRQ storm is a system-wide CPU lockup.

### Step 7.2: Subsystem Activity
**Record:** I3C subsystem actively maintained in 6.18.y with recent svc
and mipi-i3c-hci fixes. NPCM845 support and quirk infrastructure are
established in this tree.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who Is Affected
**Record:** Users of Nuvoton NPCM845 I3C controller
(`"nuvoton,npcm845-i3c"` DT compatible). Primarily embedded BMC/server
platforms. Config-specific (driver + hardware present).

### Step 8.2: Trigger Conditions
**Record:** I3C target stuck holding SDA low → false MR IBI → STOP
recovery loop. Requires bus fault or misbehaving device — uncommon but
realistic. Not unprivileged-userspace-direct, but can freeze the system
when it occurs.

### Step 8.3: Failure Mode Severity
**Record:** **IRQ storm → CPU lockup.** Severity: **CRITICAL** (system
becomes unresponsive).

### Step 8.4: Risk-Benefit
**Record:**
- **Benefit:** HIGH for NPCM845 users — prevents system lockup on bus
  fault.
- **Risk:** VERY LOW — 9 lines, quirk-gated, same register write pattern
  as existing code, zero impact on non-NPCM845 platforms.
- **Ratio:** Strongly favors backport.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Summary

**FOR backporting:**
- Fixes real IRQ storm causing CPU lockup (CRITICAL severity)
- Small, surgical, quirk-gated hardware workaround
- Reviewed by NXP reviewer; applied by I3C maintainer
- Prerequisites present in 6.18.43 tree; applies cleanly
- Complements already-backported patch 1/2 in the series
- Matches stable exception category: hardware quirk/workaround

**AGAINST backporting:**
- NPCM845-specific (limited audience) — but stable routinely takes
  hardware quirk fixes
- Requires bus fault to trigger — but consequence is system lockup
- No syzbot/user bug report — but hardware quirk from silicon vendor is
  credible

**Unresolved:** None affecting the decision.

### Step 9.2: Stable Rules Checklist
1. Obviously correct and tested? **PASS** — minimal register clear,
   reviewed, maintainer-applied
2. Fixes a real bug? **PASS** — IRQ storm on NPCM845
3. Important issue? **PASS** — CPU lockup (CRITICAL)
4. Small and contained? **PASS** — 9 lines, one case branch
5. No new features/APIs? **PASS** — quirk workaround only
6. Can apply to local tree? **PASS** — clean apply, prerequisites
   present

### Step 9.3: Exception Category
**Record:** Hardware quirk/workaround for NPCM845 I3C controller.

### Step 9.4: Decision Rationale
This commit closes a gap in the existing `SVC_I3C_QUIRK_FALSE_SLVSTART`
handling. The 6.18.43 tree already has NPCM845 support, the quirk flag,
and series patch 1/2, but lacks this IRQ storm fix. When an I3C bus
fault causes a target to hold SDA low, the driver can enter an infinite
IRQ loop that locks the CPU. The fix is minimal, quirk-gated, reviewed,
and applies cleanly. This is appropriate stable material.

---

## Verification

- [Phase 1] Parsed subject, tags, body from provided commit message
- [Phase 1] Identified as explicit hardware quirk IRQ storm fix, not
  hidden cleanup
- [Phase 2] Diff: +9 lines in `svc_i3c_master_ibi_isr()`, MASTER_REQUEST
  case only
- [Phase 2] Verified `writel(SVC_I3C_MINT_SLVSTART, ...)` pattern
  matches line 626 in same file
- [Phase 3] `git describe HEAD` / `make kernelversion`: 6.18.43
- [Phase 3] `git blame -L 609,611`: MR STOP path present without
  SLVSTART clear
- [Phase 3] `git merge-base --is-ancestor 466c7f87de52d HEAD`: patch 1/2
  present
- [Phase 3] `git merge-base --is-ancestor 1effa3adfe53c HEAD`: IRQ storm
  fix NOT present
- [Phase 3] `git log --oneline 4dd12e944f07^..HEAD --
  drivers/i3c/master/svc-i3c-master.c`: related history confirmed
- [Phase 3] `git apply --check` on upstream diff: applies cleanly
- [Phase 4] `b4 dig -c 1effa3adfe53c -a`: v1 2/2 series found
- [Phase 4] `b4 dig -c 1effa3adfe53c -w`: maintainers CC'd, Frank Li
  reviewed
- [Phase 4] `b4 dig -c 1effa3adfe53c -m /tmp/i3c_irq_storm.mbox`:
  Belloni applied both patches; no stable tag, no NAKs
- [Phase 5] `grep svc_i3c_master_irq_handler`: caller at line 646; IRQ
  registered at line 1944
- [Phase 5] `grep SVC_I3C_QUIRK_FALSE_SLVSTART`: quirk defined line 154,
  used lines 628 and 2058
- [Phase 6] `grep npcm845`: `npcm845_drvdata` with quirk at lines
  2056–2065
- [Phase 6] Read current file lines 609–611, 617–648: buggy code
  confirmed, prerequisite quirk guard present
- [Phase 7] `git log --oneline -20 -- drivers/i3c/`: active subsystem
- [Phase 8] Failure mode IRQ storm → CPU lockup assessed as CRITICAL

**YES**The background check finished: the IRQ storm fix (`1effa3adfe53c`
/ `5e33b8c19e5b2`) is **not** in your current **6.18.43** tree.

That matches the earlier analysis: NPCM845 support and the related
false-SLVSTART quirk are present, patch 1/2 (`466c7f87de52d`) is already
applied, but the MR-handler SLVSTART clear is still missing — and the
upstream patch applies cleanly.

**Backport recommendation: YES** — it’s a small, quirk-gated fix for an
IRQ storm that can lock up the CPU on NPCM845 when the I3C bus gets
stuck.

 drivers/i3c/master/svc-i3c-master.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/i3c/master/svc-i3c-master.c b/drivers/i3c/master/svc-i3c-master.c
index d33f4c7654974..70365a550ad29 100644
--- a/drivers/i3c/master/svc-i3c-master.c
+++ b/drivers/i3c/master/svc-i3c-master.c
@@ -608,6 +608,15 @@ static void svc_i3c_master_ibi_isr(struct svc_i3c_master *master)
 		break;
 	case SVC_I3C_MSTATUS_IBITYPE_MASTER_REQUEST:
 		svc_i3c_master_emit_stop(master);
+
+		/*
+		 * If a target gets stuck holding SDA low, the controller reports a MR.
+		 * On NPCM845, emitting STOP may spuriously set SLVSTART, retriggering
+		 * the interrupt and re-entering MR handling, leading to an IRQ storm.
+		 * Clear SLVSTART after STOP to break the loop.
+		 */
+		if (svc_has_quirk(master, SVC_I3C_QUIRK_FALSE_SLVSTART))
+			writel(SVC_I3C_MINT_SLVSTART, master->regs + SVC_I3C_MSTATUS);
 		break;
 	default:
 		break;
-- 
2.53.0

