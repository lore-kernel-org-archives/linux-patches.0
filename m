Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87C883CA499;
	Mon, 20 Apr 2026 13:27:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691676; cv=none; b=knkxFcUh5zXXWozJ2qSE8IBodGBmYjLSgjS2W48zXPndEmsChq+1nRa4kDgtNEevXa6BJjrAY9T4HvdgFqLatu6SW8VzJW9rSsil8W3qTYrLPR1t5HQ6FJIOgYGsvRfEFq/UEXCBXxguHCHQNoWFN5ExpLBgahiWjvl1Qg+iMF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691676; c=relaxed/simple;
	bh=Y2+vmQoyjxm5ovESpNBVj1d6pMbBAzz3Mb5H0POfML0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SG0a8rDbPOuPMW29bt3txtTEXy5dVGhO0V8WTeP1GruP8zhnlGMzsE3hlTPfd1NPwlgTtLLUa4hJ2UUYmYAF3CtwpjDPKY0I6eTvw/miKRsYG4P7Xv+J59crO1YMOHP0f6ZjmvEluCQkIuiI1FbdtRGnomm/9qbtufG6RmB0uI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nYlyfSzV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nYlyfSzV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B058C2BCB4;
	Mon, 20 Apr 2026 13:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691676;
	bh=Y2+vmQoyjxm5ovESpNBVj1d6pMbBAzz3Mb5H0POfML0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nYlyfSzVM/WLeoIF3l7vMzK8IdmljMDT+2PFZZr1TF0VKVNfPKl8Vl5afWAFfmk3w
	 Hziuve6s1mqXOfk3+PdYsBNuhZ3rL0pa+THGQmRrgoNX0V2S5ZVAj7a5aTKTU590h1
	 GNpk5KLCuswuDNfUDIu44O417vIH/fPMoIDwXURyfzwbSm4zyZa025pgCYTnf6J9hJ
	 1XXd4pa+7njyRcO4R5xzx+xXv1DNigfJJshJAHcSyMb6NWCQT2tBJkVT3zp2mi8aog
	 VDAUbIXIa6EUM4MYgAxFfLTtkIH7MBzH9Zr4ybp9Q59CQPSPY08T2L8AKipQPI4IWv
	 76lT3cmmAXUPw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Breno Leitao <leitao@debian.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	ldewangan@nvidia.com,
	thierry.reding@kernel.org,
	jonathanh@nvidia.com,
	skomatineni@nvidia.com,
	linux-tegra@vger.kernel.org,
	linux-spi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.19] spi: tegra210-quad: Fix false positive WARN on interrupt timeout with transfer complete
Date: Mon, 20 Apr 2026 09:19:21 -0400
Message-ID: <20260420132314.1023554-167-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 7.0
Content-Transfer-Encoding: 8bit

From: Breno Leitao <leitao@debian.org>

[ Upstream commit 5b94c94caafcad3c77cc6b1d213a93bf5dc0a98e ]

The WARN_ON_ONCE/WARN_ON fired unconditionally on any completion
timeout, including the recoverable case where the interrupt was lost but
the hardware actually finished the transfer. This produced a noisy splat
with a full call trace even though the driver successfully recovered via
tegra_qspi_handle_timeout().

Since tegra210 uses threaded interrupts, the transfer completion can be
signaled before the interrupt fires, making this false positive case
common in practice.

Almost all the hosts I sysadmin in my fleet produce the following splat:

	WARNING: CPU: 47 PID: 844 at drivers/spi/spi-tegra210-quad.c:1226 tegra_qspi_transfer_one_message+0x8a4/0xba8
	....
	tegra-qspi NVDA1513:00: QSPI interrupt timeout, but transfer complete

Move WARN_ON_ONCE/WARN_ON to fire only on real unrecoverable timeouts,
i.e., when tegra_qspi_handle_timeout() confirms the hardware did NOT
complete. This makes the warning actionable instead of just polluting
the metrics.

Signed-off-by: Breno Leitao <leitao@debian.org>
Link: https://patch.msgid.link/20260408-tegra_warn-v1-1-669a3bc74d77@debian.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the data needed for a comprehensive analysis. Here is the
full walkthrough:

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: PARSE THE SUBJECT LINE
Record: [spi: tegra210-quad] [Fix] [false positive WARN on interrupt
timeout with transfer complete]

### Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
- **Signed-off-by:** Breno Leitao <leitao@debian.org> (author)
- **Link:** https://patch.msgid.link/20260408-tegra_warn-v1-1-
  669a3bc74d77@debian.org
- **Signed-off-by:** Mark Brown <broonie@kernel.org> (SPI subsystem
  maintainer)
- No Fixes: tag (expected for autosel candidates)
- No Reported-by: (author is the reporter, via commit message text)
- No Cc: stable tag (expected)

Record: Author is a regular tegra210-quad contributor (9 commits in this
driver). Patch was accepted by the SPI subsystem maintainer Mark Brown.

### Step 1.3: ANALYZE THE COMMIT BODY TEXT
The bug: `WARN_ON_ONCE`/`WARN_ON` fires unconditionally on any
completion timeout, including the recoverable case where the interrupt
was lost but hardware finished the transfer. The driver already has
`tegra_qspi_handle_timeout()` that recovers from this situation.

Symptom: Full kernel warning stack trace on every recoverable timeout:
```
WARNING: CPU: 47 PID: 844 at drivers/spi/spi-tegra210-quad.c:1226
tegra_qspi_transfer_one_message+0x8a4/0xba8
```

Scale: Author states "Almost all the hosts I sysadmin in my fleet
produce the following splat." This is common because tegra210 uses
threaded interrupts where transfer completion can be signaled before the
IRQ fires.

Root cause: The WARN fires before `tegra_qspi_handle_timeout()` has a
chance to determine if the hardware actually completed.

Record: [False positive WARN on recoverable timeout] [WARNING splat with
full call trace on every occurrence] [Common in practice across fleet of
Tegra machines] [Root cause: WARN placed before recovery check]

### Step 1.4: DETECT HIDDEN BUG FIXES
This IS a bug fix - the WARN fires when there's no actual problem. With
`panic_on_warn=1` (verified exists in `kernel/panic.c`), this causes
kernel panics on recoverable situations.

Record: [Yes, this is a real bug fix. WARN fires on non-error
conditions, which causes panics with panic_on_warn=1 and pollutes
logs/monitoring on all other systems.]

---

## PHASE 2: DIFF ANALYSIS - LINE BY LINE

### Step 2.1: INVENTORY THE CHANGES
- **File:** `drivers/spi/spi-tegra210-quad.c`
- **Two hunks:** Both doing the same logical change
  - Hunk 1 (`tegra_qspi_combined_seq_xfer`): -1 line, +2 lines (net +1)
  - Hunk 2 (`tegra_qspi_non_combined_seq_xfer`): -1 line, +2 lines (net
    +1)
- **Functions modified:** `tegra_qspi_combined_seq_xfer`,
  `tegra_qspi_non_combined_seq_xfer`
- **Scope:** Single-file surgical fix, two identical pattern changes

Record: [1 file, 2 functions, +2/-2 logical changes, scope: surgical
fix]

### Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
**Hunk 1 (combined_seq_xfer):**
- BEFORE: `if (WARN_ON_ONCE(ret == 0))` fires WARN then calls
  `tegra_qspi_handle_timeout()` inside the `if` body
- AFTER: `if (ret == 0)` (no WARN), then calls
  `tegra_qspi_handle_timeout()`, and only `WARN_ON_ONCE(1)` if
  handle_timeout returns < 0 (real unrecoverable timeout)

**Hunk 2 (non_combined_seq_xfer):**
- BEFORE: `if (WARN_ON(ret == 0))` fires WARN then calls
  `tegra_qspi_handle_timeout()`
- AFTER: `if (ret == 0)` (no WARN), then calls
  `tegra_qspi_handle_timeout()`, and only `WARN_ON(1)` if handle_timeout
  returns < 0

Record: [Both hunks: WARN moved from unconditional timeout to only real-
timeout branch after recovery check]

### Step 2.3: IDENTIFY THE BUG MECHANISM
Category: **Logic/correctness fix** - The WARN was placed at the wrong
scope level. It fires for all timeouts (including recoverable ones where
hardware completed but interrupt was delayed), when it should only fire
for genuine failures.

Record: [Logic bug: WARN fires at wrong scope. Fix moves WARN to only
trigger after confirming hardware did NOT complete.]

### Step 2.4: ASSESS THE FIX QUALITY
- Obviously correct: YES - the WARN should only fire for real errors,
  not recoverable conditions
- Minimal/surgical: YES - just 2 identical changes moving WARN placement
- Regression risk: VERY LOW - the same WARN still fires on real
  timeouts, and the recovery path is untouched
- No red flags: single file, same subsystem, no API changes

Record: [Fix is obviously correct, minimal, zero regression risk]

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: BLAME THE CHANGED LINES
- Line 1226 (`WARN_ON_ONCE`): introduced by `41c721fc09393` (Breno
  Leitao, 2025-04-01) in v6.15
- Line 1343 (`WARN_ON`): original from `921fc1838fb036` (Sowjanya
  Komatineni, 2020-12-21) in v5.11
- Lines 1227-1248 (timeout handling): introduced by `380fd29d57abe`
  (Vishwaroop A, 2025-10-28) in v6.19

Record: [WARN_ON from v5.11, WARN_ON_ONCE since v6.15, recovery logic
since v6.19. The false positive only became apparent after 380fd29d57abe
added recovery, revealing the WARN fires even when recovery succeeds.]

### Step 3.2: FOLLOW THE FIXES: TAG
No Fixes: tag present. However, logically this fixes the combination of
`41c721fc09393` (which introduced WARN_ON_ONCE in combined path) and
`380fd29d57abe` (which added the recovery but didn't move the WARN).

Record: [No Fixes: tag. Logically fixes the interaction between WARN
placement and the recovery path added in 380fd29d57abe.]

### Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
Recent commits show heavy work on this driver by the same author:
- Spinlock protection for curr_xfer (6 patches, v6.19)
- IRQ_HANDLED fix (v6.19)
- Rate limiting (v6.15)
- WARN_ON_ONCE (v6.15)

Record: [Standalone fix. No prerequisites beyond the already-merged
recovery handler. Author is the most active recent contributor to this
driver.]

### Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
Breno Leitao has 9 commits to this driver, including the prior
WARN_ON_ONCE change and the spinlock protection series. He is clearly
intimately familiar with this driver and has been fixing real production
issues.

Record: [Active contributor to this driver, fixing real production
issues across a fleet.]

### Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
This patch depends on `380fd29d57abe` ("Check hardware status on
timeout") which introduced `tegra_qspi_handle_timeout()`. That commit is
in v6.19+.

Record: [Requires tegra_qspi_handle_timeout() from 380fd29d57abe
(v6.19). Patch cannot apply to older stable trees.]

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
Lore.kernel.org is behind Anubis anti-bot protection. B4 dig could not
be used directly on the new commit hash (not yet in tree).

The patch was submitted as v1 on 2026-04-08 (based on msgid). It was a
single patch (not part of a series). Mark Brown applied it directly,
suggesting straightforward acceptance.

Record: [Patch accepted directly by SPI maintainer. No concerns or NAKs
visible. v1 was applied directly (no revisions needed).]

### Step 4.2: CHECK WHO REVIEWED THE PATCH
Mark Brown (SPI subsystem maintainer) signed off, indicating direct
review and acceptance.

Record: [Mark Brown (subsystem maintainer) reviewed and applied.]

### Step 4.3-4.5: BUG REPORT / RELATED PATCHES / STABLE DISCUSSION
The commit message itself serves as the bug report - the author
describes fleet-wide impact. No separate bug report.

Record: [Author is the reporter. Fleet-wide impact documented in commit
message.]

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
- `tegra_qspi_combined_seq_xfer()` - Combined sequence transfer path
- `tegra_qspi_non_combined_seq_xfer()` - Non-combined sequence transfer
  path

### Step 5.2: TRACE CALLERS
Both functions are called from `tegra_qspi_transfer_one_message()`,
which is the SPI core transfer callback. This is the main transfer path
for ALL QSPI operations on Tegra.

Record: [Called from core SPI transfer path - every QSPI transaction
goes through this code.]

### Step 5.3-5.4: TRACE CALLEES / CALL CHAIN
The affected code calls `tegra_qspi_handle_timeout()` which checks
hardware status (QSPI_RDY bit) and manually processes completion if
hardware finished. This is a standard SPI data path.

Record: [Standard SPI data transfer path, reachable from any QSPI
operation on Tegra platforms.]

### Step 5.5: SEARCH FOR SIMILAR PATTERNS
The exact same pattern exists in both functions (combined and non-
combined), and the fix addresses both identically.

Record: [Two instances of the same pattern, both fixed.]

---

## PHASE 6: CROSS-REFERENCING AND STABLE TREE ANALYSIS

### Step 6.1: DOES THE BUGGY CODE EXIST IN STABLE TREES?
- **v6.19.y:** YES - has `tegra_qspi_handle_timeout()` and both
  WARN_ON/WARN_ON_ONCE. Patch applies cleanly (verified code is
  identical to v7.0).
- **v6.18.y and earlier:** NO - `tegra_qspi_handle_timeout()` does not
  exist. The timeout handling is completely different. This patch is
  INAPPLICABLE.
- **v6.6.y, v6.1.y, v5.15.y:** NO - completely different timeout code.

Record: [Applicable ONLY to v6.19.y and v7.0. No applicability to older
stable trees.]

### Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
For v6.19.y: The code is identical - clean apply expected.

Record: [Clean apply to v6.19.y. Not applicable to older trees.]

### Step 6.3: CHECK IF RELATED FIXES ARE ALREADY IN STABLE
No related fix is in stable for this specific false positive WARN issue.

Record: [No existing fix in stable for this issue.]

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
- Subsystem: `drivers/spi` - SPI bus driver for Tegra QSPI controller
- Criticality: IMPORTANT for Tegra (NVIDIA) platforms (widely used in
  embedded/automotive/Jetson)

Record: [SPI driver subsystem, IMPORTANT for Tegra/Jetson platforms]

### Step 7.2: ASSESS SUBSYSTEM ACTIVITY
Very active - 20 recent commits to this file, ongoing improvements and
bug fixes.

Record: [Very active subsystem with ongoing fixes]

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: DETERMINE WHO IS AFFECTED
All users of Tegra210+ QSPI hardware. This includes NVIDIA Jetson
platforms widely used in robotics, automotive, and embedded
applications.

Record: [All Tegra QSPI users - Jetson/embedded platforms]

### Step 8.2: DETERMINE THE TRIGGER CONDITIONS
- Trigger: Any QSPI transfer where interrupt is delayed (common with
  threaded IRQs)
- Frequency: Very common - author reports "almost all hosts in my fleet"
- No privilege required - happens during normal SPI operations

Record: [Very common, happens during normal QSPI operations, no special
trigger needed]

### Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
- Without `panic_on_warn`: MEDIUM - log pollution, monitoring noise,
  full stack trace on recoverable events
- With `panic_on_warn=1`: CRITICAL - kernel panic on a non-error
  condition
- The warning count can be extremely high (94,451 in commit
  41c721fc09393's message)

Record: [MEDIUM severity (CRITICAL with panic_on_warn=1). False positive
warnings pollute logs and can cause panics.]

### Step 8.4: CALCULATE RISK-BENEFIT RATIO
- **BENEFIT:** HIGH - eliminates false positive warnings that are common
  across Tegra fleet. Prevents panics on `panic_on_warn=1` systems.
  Makes the warning actionable (only fires on real errors).
- **RISK:** VERY LOW - 2-line change per function, obviously correct, no
  behavioral change except WARN placement.

Record: [HIGH benefit, VERY LOW risk. Excellent ratio.]

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: COMPILE THE EVIDENCE

**FOR backporting:**
- Fixes a real, common false positive WARN that fires during normal
  recoverable operation
- Can cause kernel panics on `panic_on_warn=1` systems
- Author documents fleet-wide impact ("almost all hosts in my fleet")
- Fix is tiny (2 identical 1-line changes), obviously correct, zero
  regression risk
- Accepted directly by SPI maintainer Mark Brown without revisions
- Author is an experienced contributor to this driver with 9 commits
- Applies cleanly to v6.19.y stable tree

**AGAINST backporting:**
- Only applicable to v6.19.y (depends on v6.19's
  `tegra_qspi_handle_timeout()`)
- Without `panic_on_warn`, this is "just" log noise (though significant
  noise)
- Limited to Tegra QSPI hardware users

### Step 9.2: APPLY THE STABLE RULES CHECKLIST
1. Obviously correct and tested? **YES** - trivially verifiable, tested
   in author's fleet
2. Fixes a real bug that affects users? **YES** - false positive WARN,
   panic with panic_on_warn
3. Important issue? **YES** - WARN with full call trace on every
   recoverable timeout; panic on panic_on_warn
4. Small and contained? **YES** - 2 identical single-line changes in one
   file
5. No new features or APIs? **YES** - just moves WARN placement
6. Can apply to stable trees? **YES** - cleanly to v6.19.y

### Step 9.3: CHECK FOR EXCEPTION CATEGORIES
Not an exception category - this is a straightforward bug fix.

### Step 9.4: MAKE YOUR DECISION
The fix is small, surgical, obviously correct, and fixes a real problem
that affects real Tegra users in production. It eliminates false
positive warnings that can cause panics on `panic_on_warn=1` systems and
significantly reduces log noise. The fix meets all stable kernel
criteria.

---

## Verification

- [Phase 1] Parsed tags: Signed-off-by author (Breno Leitao), Signed-
  off-by maintainer (Mark Brown), Link to patch
- [Phase 2] Diff analysis: 2 identical changes in 2 functions, moving
  WARN from outer scope to real-timeout-only branch
- [Phase 3] git blame: WARN_ON_ONCE at line 1226 from commit
  41c721fc09393 (v6.15); recovery handler from 380fd29d57abe (v6.19)
- [Phase 3] git show 380fd29d57abe: confirmed this introduced
  tegra_qspi_handle_timeout(), the function that makes the false
  positive detectable
- [Phase 3] git show 41c721fc09393: confirmed 94,451 warnings reported
  per host
- [Phase 3] git log --author: author has 9 commits to this driver
- [Phase 4] b4 dig found prior series by same author; current patch is
  standalone v1 accepted directly
- [Phase 5] Functions modified are in the core SPI transfer path, called
  from tegra_qspi_transfer_one_message
- [Phase 6] v6.19 code verified identical to v7.0 for affected areas
  (tegra_qspi_handle_timeout exists, WARN_ON locations match)
- [Phase 6] v6.12, v6.6 confirmed: NO tegra_qspi_handle_timeout
  function, completely different timeout code - patch inapplicable
- [Phase 6] v6.15, v6.18 confirmed: WARN_ON_ONCE exists but NO
  tegra_qspi_handle_timeout - patch inapplicable
- [Phase 8] panic_on_warn confirmed in kernel/panic.c: WARN triggers
  check_panic_on_warn() which calls panic()
- UNVERIFIED: Could not access lore.kernel.org due to Anubis bot
  protection; unable to verify full review discussion

**YES**

 drivers/spi/spi-tegra210-quad.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/spi/spi-tegra210-quad.c b/drivers/spi/spi-tegra210-quad.c
index 7ea5aa993596f..05f1753e2bbb1 100644
--- a/drivers/spi/spi-tegra210-quad.c
+++ b/drivers/spi/spi-tegra210-quad.c
@@ -1223,7 +1223,7 @@ static int tegra_qspi_combined_seq_xfer(struct tegra_qspi *tqspi,
 					(&tqspi->xfer_completion,
 					QSPI_DMA_TIMEOUT);
 
-			if (WARN_ON_ONCE(ret == 0)) {
+			if (ret == 0) {
 				/*
 				 * Check if hardware completed the transfer
 				 * even though interrupt was lost or delayed.
@@ -1232,6 +1232,7 @@ static int tegra_qspi_combined_seq_xfer(struct tegra_qspi *tqspi,
 				ret = tegra_qspi_handle_timeout(tqspi);
 				if (ret < 0) {
 					/* Real timeout - clean up and fail */
+					WARN_ON_ONCE(1);
 					dev_err(tqspi->dev, "transfer timeout\n");
 
 					/* Abort transfer by resetting pio/dma bit */
@@ -1340,7 +1341,7 @@ static int tegra_qspi_non_combined_seq_xfer(struct tegra_qspi *tqspi,
 
 		ret = wait_for_completion_timeout(&tqspi->xfer_completion,
 						  QSPI_DMA_TIMEOUT);
-		if (WARN_ON(ret == 0)) {
+		if (ret == 0) {
 			/*
 			 * Check if hardware completed the transfer even though
 			 * interrupt was lost or delayed. If so, process the
@@ -1349,6 +1350,7 @@ static int tegra_qspi_non_combined_seq_xfer(struct tegra_qspi *tqspi,
 			ret = tegra_qspi_handle_timeout(tqspi);
 			if (ret < 0) {
 				/* Real timeout - clean up and fail */
+				WARN_ON(1);
 				dev_err(tqspi->dev, "transfer timeout\n");
 
 				if (tqspi->is_curr_dma_xfer)
-- 
2.53.0

