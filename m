Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E99184EC671;
	Mon, 31 Aug 2026 13:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183633; cv=none; b=HgUggIlA4G/YDtUHaCOIRi0aF9MMx35OTIQN6J6Zrrssvix45lA36iro/6qqSX6UwgBhNWo0/AwsAMGFZD2MejaUflwHluFLQo6BGz2aawEr0cm8lXHe1rvcha26bKd8dqlYvTWV+LdHje5Slsd9QABg0NKhs2VpAQ/3pzXa72A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183633; c=relaxed/simple;
	bh=f7ARD/JSgRRn0qndMM9M2KzYQj3p3zyUQpk6bmX4PCE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l3bVbxzqYwiIlBsu0hxaLDX7+8v5ieH3m+o2q+Dj6XW0EJ6Scf1FjUL3smi72y6gFbryZTtutl8HXMihECICdpEekHGJ1ItPcVfS7aXYqmkZiaVkPKIFsP9xvxQQUSpADespJeuWLnxCnD+Zbb6v2YUwnAWECmXKtEHBHV8fT3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XTDV5hJT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XTDV5hJT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5DC11F00A3F;
	Mon, 31 Aug 2026 13:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183630;
	bh=YO/xuJqUcR0pEeTfiWPZjVxw0FykHPSMfwSXJ6Qd2uw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XTDV5hJT7Su+1FTKRnhP4ZWnTqpUPFK7Nr52zDwvuWrtR+MdgfqbMmKnubHXbEJFG
	 JXwk2MGYHLHQOc0FuYEwWMrrmmjhuUcQwFwMDb9nUrq5R9I0ONjGJvGKzW2K8TchWH
	 FvilU3Puc1mEnEf9yCwLfjBX0prB+v8qcYWyD2Zg5VmyL34QaeaFHWJUwuD1hlnPE8
	 KIXC7myjjagH0b+XXUaLDG52daK4vRa6q1kpcIBgDMiu0mNRhmKJorJi+VqNLAwg2h
	 6CpaMsn11rGmN07yRF5CulgmMeum+ozQdPikYDcfybRMN/XhSh5dc+g8FLgS4JLhPV
	 9T0GtFlAHqqlA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Tze Yee Ng <tze.yee.ng@altera.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	Eugeniy.Paltsev@synopsys.com,
	dmaengine@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.15] dmaengine: dw-axi-dmac: fix PM for system sleep and channel alloc
Date: Mon, 31 Aug 2026 09:23:57 -0400
Message-ID: <20260831133314.4125787-209-sashal@kernel.org>
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

From: Tze Yee Ng <tze.yee.ng@altera.com>

[ Upstream commit df0c2dc68770cf43f15df40b184df030b850ea05 ]

The driver only had runtime PM callbacks. If a channel stayed allocated
across system suspend/resume, the runtime usage count could remain
non-zero while hardware state (DMAC_CFG, clocks) was lost, and
axi_dma_runtime_resume() would not run to restore it.

Add system-sleep PM ops that use pm_runtime_force_suspend() and
pm_runtime_force_resume() so suspend/resume reuses the existing
axi_dma_suspend() and axi_dma_resume() paths.

Replace pm_runtime_get() with pm_runtime_resume_and_get() in
dma_chan_alloc_chan_resources() so clocks are enabled before a client
can immediately submit a transfer and touch MMIO.

Signed-off-by: Tze Yee Ng <tze.yee.ng@altera.com>
Link: https://patch.msgid.link/18bf778a3a1cc2f377ef8eb0d1508d8ac6371896.1779688569.git.tze.yee.ng@altera.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

# Stable Backport Analysis: `dmaengine: dw-axi-dmac: fix PM for system
sleep and channel alloc`

**Local tree:** `v6.18.44` (`stable/linux-6.18.y`, detached HEAD)
**Mainline commit:** `df0c2dc68770c` (merged by Vinod Koul, 2026-06-11)
**Status in this tree:** Buggy code is present; fix is **not** yet
applied (`NOT_IN_TREE`)

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Parse the subject line
**Record:** `[dmaengine: dw-axi-dmac]` `[fix]` — Correct power-
management handling for system sleep and DMA channel allocation.

### Step 1.2: Parse all commit message tags
**Record:**
- **Fixes:** — absent (expected for manual review)
- **Reported-by:** — absent
- **Tested-by:** — absent
- **Reviewed-by / Acked-by:** — absent in commit message
- **Link:** https://patch.msgid.link/18bf778a3a1cc2f377ef8eb0d1508d8ac63
  71896.1779688569.git.tze.yee.ng@altera.com
- **Cc: stable:** — absent (not a negative signal)
- **Signed-off-by:** Tze Yee Ng (author), Vinod Koul (subsystem
  maintainer, committer)
- **Notable:** Merged by dmaengine maintainer; patch 2/2 in a reviewed
  series

### Step 1.3: Analyze commit body
**Record:**
- **Bug:** Driver registered only runtime PM callbacks. With a channel
  allocated across system suspend/resume, runtime usage count can stay
  non-zero while hardware state (DMAC_CFG, clocks) is lost;
  `axi_dma_runtime_resume()` is then skipped.
- **Symptom:** DMA controller left with clocks off and/or DMAC_CFG not
  restored after resume; subsequent DMA/MMIO can fail or hang.
- **Second bug:** `pm_runtime_get()` in
  `dma_chan_alloc_chan_resources()` bumps the usage counter without
  resuming; a client can submit a transfer immediately and touch MMIO
  before clocks are enabled.
- **Root cause:** Missing system-sleep PM ops; incorrect runtime PM API
  usage on channel allocation.
- **Version info:** None stated; driver has had this pattern since 2018.

### Step 1.4: Detect hidden bug fixes
**Record:** Not disguised — explicitly described as a PM bug fix. The
`pm_runtime_resume_and_get()` change also adds missing
`pm_runtime_put()` on error paths (refcount balance), which is proper
error-path cleanup tied to the fix.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory the changes
**Record:**
- **File:** `drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c` (+9 / -2)
- **Functions modified:** `dma_chan_alloc_chan_resources()`,
  `dw_axi_dma_pm_ops`
- **Scope:** Single-file, surgical fix

### Step 2.2: Code flow change per hunk

**Hunk 1 — `dma_chan_alloc_chan_resources()`:**
- **Before:** Check idle → allocate descriptor pool → `pm_runtime_get()`
  (counter only, no resume) → return 0. Error paths did not balance
  runtime PM.
- **After:** `pm_runtime_resume_and_get()` first (resume + increment);
  on `-EBUSY` / `-ENOMEM`, `pm_runtime_put()` before return.
- **Path affected:** Normal DMA client channel allocation (common
  client-driver path).

**Hunk 2 — `dw_axi_dma_pm_ops`:**
- **Before:** Only `SET_RUNTIME_PM_OPS(axi_dma_runtime_suspend,
  axi_dma_runtime_resume, NULL)`.
- **After:** Adds `SET_SYSTEM_SLEEP_PM_OPS(pm_runtime_force_suspend,
  pm_runtime_force_resume)`.
- **Path affected:** System suspend/resume (S3/hibernate on affected
  SoCs).

### Step 2.3: Bug mechanism
**Record:**
- **Category (a):** Error-path refcount fix — `pm_runtime_put()` on
  allocation failure after `resume_and_get`.
- **Category (b):** PM / suspend-resume correctness — system sleep now
  forces runtime suspend/resume regardless of usage count.
- **Category (c):** Reference-counting / PM API misuse —
  `pm_runtime_get()` does not resume; `pm_runtime_resume_and_get()`
  does.
- **Specific mechanism:** After system sleep, hardware is reset but
  software refcount says device is "active," so runtime resume is
  skipped and `axi_dma_resume()` (clocks + DMAC enable) never runs.

### Step 2.4: Fix quality
**Record:**
- **Quality:** High. Uses the standard kernel pattern documented in
  `DEFINE_RUNTIME_DEV_PM_OPS()` / `pm_runtime.h` comments.
- **Minimal:** 9 lines, no API changes.
- **Regression risk:** Very low. `pm_runtime_force_suspend/resume` are
  well-tested core PM helpers; error-path `pm_runtime_put()` is correct
  pairing.
- **Red flags:** None.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame changed lines
**Record:**
- `dma_chan_alloc_chan_resources()` and `pm_runtime_get()`: introduced
  in `1fe20f1b84548` (2018-03-06, "Introduce DW AXI DMAC driver").
- `dw_axi_dma_pm_ops` with runtime-only ops: same commit, 2018.
- Bug has been present since driver introduction in this tree.

### Step 3.2: Follow Fixes: tag
**Record:** No `Fixes:` tag. N/A.

### Step 3.3: File history for related changes
**Record:**
- Recent stable-tree changes: StarFive JH8100/JH7110 support, per-
  channel IRQ, array overrun fix.
- Patch 1 of series (`dc6d681e1571c` — "drop redundant DMAC enable in
  block start") is **not** in this tree (`PATCH1_NOT_IN_TREE`).
- This commit (patch 2) is **standalone**; it does not depend on patch
  1. Patch 1 without patch 2 would expose the PM gap more; patch 2 alone
  is sufficient and correct for 6.18.y.

### Step 3.4: Author's other commits
**Record:** Tze Yee Ng — Altera/Intel contributor; author of
stratix10-svc fixes. Vinod Koul committed and is dmaengine maintainer.

### Step 3.5: Prerequisites
**Record:** No prerequisites. `pm_runtime_force_suspend`,
`pm_runtime_force_resume`, and `pm_runtime_resume_and_get` all exist in
this tree's `include/linux/pm_runtime.h`. Patch applies cleanly (`git
apply --check` exit 0).

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: Original patch discussion
**Record:**
- **b4 dig URL:** https://patch.msgid.link/18bf778a3a1cc2f377ef8eb0d1508
  d8ac6371896.1779688569.git.tze.yee.ng@altera.com
- **Series:** v2 0/2 "clean up DMAC enable and PM" (2026-05-25)
- **Revisions:** v2 only found by b4 dig `-a`
- **Key feedback:** Patch 2 added per review feedback from Sashiko
  Watanabe (AI review bot flagged issues; patch 2 addresses PM gap
  identified in review)
- **Maintainer:** Vinod Koul replied "Applied, thanks!" applying both
  patches
- **Stable nomination in thread:** None found
- **NAKs:** None found

### Step 4.2: Reviewers from b4 dig -w
**Record:** CC'd: Eugeniy Paltsev (Synopsys, original driver author),
Vinod Koul, Frank Li, dmaengine@vger.kernel.org, linux-
kernel@vger.kernel.org.

### Step 4.3: Bug report
**Record:** No external bug report or syzbot link. Bug identified
through code review / PM analysis during series review.

### Step 4.4: Related patches / series
**Record:** 2-patch series. Only patch 2 is needed for this backport
decision. Patch 1 is optional cleanup not present in 6.18.y.

### Step 4.5: Stable mailing list
**Record:** Not searched separately; no stable discussion found in
downloaded thread.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Key functions
**Record:** `dma_chan_alloc_chan_resources()`,
`dma_chan_free_chan_resources()` (unchanged, has matching
`pm_runtime_put`), `axi_dma_suspend()`, `axi_dma_resume()`,
`axi_dma_runtime_suspend/resume()`, `dw_axi_dma_pm_ops`.

### Step 5.2: Callers
**Record:** `dma_chan_alloc_chan_resources` is registered as
`device_alloc_chan_resources` in the dmaengine device ops (line 1565).
Called by any DMA client requesting a channel — SDHCI, SPI, audio, etc.
on affected SoCs.

### Step 5.3: Callees
**Record:** `pm_runtime_resume_and_get()` → `pm_runtime_get_active()` →
`__pm_runtime_resume()`; system sleep uses
`pm_runtime_force_suspend/resume` → existing `axi_dma_suspend/resume`
(clock disable/enable, `axi_dma_disable/enable`).

### Step 5.4: Call chain / reachability
**Record:**
1. **Suspend/resume:** Platform system sleep → driver
   `.suspend`/`.resume` → force runtime suspend/resume → restore clocks
   and DMAC.
2. **Channel alloc:** Userspace/driver → `dma_request_channel()` →
   `alloc_chan_resources()` → must have clocks before any transfer.
- **Userspace reachable:** Yes, indirectly via drivers using DMA on
  StarFive, Intel KMB, Altera/Intel FPGA platforms.

### Step 5.5: Similar patterns
**Record:** Other DMA drivers in this tree already use
`pm_runtime_resume_and_get()` in alloc paths (e.g. `zynqmp_dma.c`,
`tegra20-apb-dma.c`, `stm32-dma.c`) and/or
`SET_SYSTEM_SLEEP_PM_OPS(pm_runtime_force_suspend,
pm_runtime_force_resume)` (e.g. `dw_mmc-pltfm.c`, `idma64.c`). This fix
aligns dw-axi-dmac with established practice.

---

## PHASE 6: CROSS-REFERENCE AGAINST LOCAL TREE

### Step 6.1: Does buggy code exist?
**Record:** **Yes.** Current tree at `v6.18.44` has:
- `pm_runtime_get()` at line 538 in `dma_chan_alloc_chan_resources()`
- Runtime-only `dw_axi_dma_pm_ops` at lines 1654–1656
- Affected platforms in OF table: `snps,axi-dma-1.01a`, `intel,kmb-axi-
  dma`, `starfive,jh7110-axi-dma`, `starfive,jh8100-axi-dma`

### Step 6.2: Backport complications
**Record:** Clean apply expected. `git apply --check` on mainline patch
succeeded. No structural divergence in the changed regions.

### Step 6.3: Related fixes already present?
**Record:** No equivalent fix found. `git merge-base --is-ancestor
df0c2dc68770c HEAD` → `NOT_IN_TREE`.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem criticality
**Record:** `drivers/dma/dw-axi-dmac` — **IMPORTANT** (DMA engine for
multiple embedded SoC platforms; suspend/resume and DMA are core to I/O
on those systems).

### Step 7.2: Subsystem activity
**Record:** Actively maintained in 6.18.y (StarFive JH8100, per-channel
IRQ, overrun fix in recent history).

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who is affected
**Record:** Users of dw-axi-dmac on Intel KMB, StarFive JH7110/JH8100,
and Synopsys/Altera AXI DMA platforms — embedded boards, FPGA SoCs.
Config: `CONFIG_DW_AXI_DMAC` (or built-in on those platforms).

### Step 8.2: Trigger conditions
**Record:**
1. DMA channel allocated, system enters suspend (S3/hibernate), then
   resumes — **common** on laptops/embedded devices.
2. Device runtime-suspended, client allocates channel and immediately
   submits transfer — **plausible** under autosuspend.
- **Unprivileged trigger:** Indirectly yes (e.g., triggering suspend or
  I/O that uses DMA).

### Step 8.3: Failure mode severity
**Record:**
- DMA failures after resume (broken I/O: storage, network, audio)
- MMIO with clocks disabled → bus hang, timeout, or oops
- **Severity: HIGH** (system-level I/O breakage; potential hang)

### Step 8.4: Risk-benefit
**Record:**
- **Benefit:** HIGH — fixes real suspend/resume breakage on shipping
  hardware
- **Risk:** LOW — 9-line, standard PM pattern, maintainer-merged
- **Ratio:** Strongly favors backport

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence summary

**FOR backport:**
- Fixes real PM bug present since driver introduction (2018)
- Affects multiple platforms in this stable tree
- Can break DMA and cause hangs after suspend/resume
- Small, obviously correct, maintainer-merged fix
- Applies cleanly to v6.18.44
- Uses established kernel PM APIs/patterns
- Standalone — does not require patch 1 of the series

**AGAINST backport:**
- No syzbot/user crash report (review-found bug)
- Driver-specific, not core kernel (but suspend/resume is critical for
  affected users)

**Unresolved:** No explicit `Tested-by` on hardware; no `Cc: stable`
nomination in thread.

### Step 9.2: Stable rules checklist
1. Obviously correct and tested? **PASS** — standard PM pattern; merged
   by maintainer after review
2. Fixes a real bug? **PASS** — suspend/resume state desync and alloc-
   without-resume
3. Important issue? **PASS** — HIGH: post-resume DMA failure / potential
   hang
4. Small and contained? **PASS** — 9 lines, one file
5. No new features/APIs? **PASS** — only PM ops wiring and correct API
   usage
6. Can apply to local tree? **PASS** — verified clean apply

### Step 9.3: Exception categories
**Record:** None (not a quirk/ID/DT/docs fix) — qualifies on straight
bug-fix merits.

### Step 9.4: Decision rationale

For **linux-6.18.y (v6.18.44)**, the buggy code is present and the fix
is absent. The commit addresses a longstanding power-management defect:
without system-sleep PM ops, suspend/resume can leave the DMAC with
clocks off and hardware unconfigured while the runtime PM counter
indicates the device is still active. The `pm_runtime_resume_and_get()`
change fixes a second, independently valid bug where channel allocation
does not ensure the device is resumed before clients can use it. The
change is minimal, follows patterns already used elsewhere in
`drivers/dma/`, and applies cleanly. This is appropriate stable
material.

---

## Verification

- **[Phase 1]** `git describe HEAD` → `v6.18.44`; parsed commit message
  from user query and `git show df0c2dc68770c`
- **[Phase 2]** Read current `dw-axi-dmac-platform.c` lines 516–564,
  1315–1356, 1654–1656; confirmed diff matches missing fix
- **[Phase 3]** `git blame` lines 516–540, 1654–1656 → `1fe20f1b84548`
  (2018); `git merge-base --is-ancestor df0c2dc68770c HEAD` →
  `NOT_IN_TREE`; patch 1 also `NOT_IN_TREE`
- **[Phase 3]** `git apply --check` on `df0c2dc68770c` patch → exit 0
  (clean apply)
- **[Phase 4]** `b4 dig -c df0c2dc68770c` → lore URL; `b4 dig -a` → v2
  series; `b4 dig -w` → maintainers CC'd; mbox → Vinod "Applied,
  thanks!"
- **[Phase 4]** WebFetch lkml.iu.edu cover letter → patch 2 addresses
  Sashiko Watanabe review feedback
- **[Phase 5]** `grep pm_runtime_resume_and_get drivers/dma/` → pattern
  used in peer drivers; read `axi_dma_enable/suspend/resume` code
- **[Phase 6]** Confirmed buggy `pm_runtime_get` and runtime-only PM ops
  in tree; OF compatibles present
- **[Phase 7]** `git log --oneline -20 -- drivers/dma/dw-axi-dmac/` →
  active maintenance
- **[Phase 8]** Failure mode derived from verified code paths
  (`axi_dma_suspend` disables clocks; `pm_runtime_get` does not resume
  per `pm_runtime.h` docs)

**YES**

 drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c b/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
index b0e689f48bb67..ea4e47ee0d710 100644
--- a/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
+++ b/drivers/dma/dw-axi-dmac/dw-axi-dmac-platform.c
@@ -516,11 +516,17 @@ static void dw_axi_dma_synchronize(struct dma_chan *dchan)
 static int dma_chan_alloc_chan_resources(struct dma_chan *dchan)
 {
 	struct axi_dma_chan *chan = dchan_to_axi_dma_chan(dchan);
+	int ret;
+
+	ret = pm_runtime_resume_and_get(chan->chip->dev);
+	if (ret < 0)
+		return ret;
 
 	/* ASSERT: channel is idle */
 	if (axi_chan_is_hw_enable(chan)) {
 		dev_err(chan2dev(chan), "%s is non-idle!\n",
 			axi_chan_name(chan));
+		pm_runtime_put(chan->chip->dev);
 		return -EBUSY;
 	}
 
@@ -531,12 +537,11 @@ static int dma_chan_alloc_chan_resources(struct dma_chan *dchan)
 					  64, 0);
 	if (!chan->desc_pool) {
 		dev_err(chan2dev(chan), "No memory for descriptors\n");
+		pm_runtime_put(chan->chip->dev);
 		return -ENOMEM;
 	}
 	dev_vdbg(dchan2dev(dchan), "%s: allocating\n", axi_chan_name(chan));
 
-	pm_runtime_get(chan->chip->dev);
-
 	return 0;
 }
 
@@ -1652,6 +1657,8 @@ static void dw_remove(struct platform_device *pdev)
 }
 
 static const struct dev_pm_ops dw_axi_dma_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(pm_runtime_force_suspend,
+				pm_runtime_force_resume)
 	SET_RUNTIME_PM_OPS(axi_dma_runtime_suspend, axi_dma_runtime_resume, NULL)
 };
 
-- 
2.53.0

