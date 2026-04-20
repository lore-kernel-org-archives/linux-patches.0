Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B6203D9DA2;
	Mon, 20 Apr 2026 13:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691437; cv=none; b=LhP80wi0cz/HUGUjeoiuSpNW5j7dpjUGCTkAmLMwcE/jWd6ATX0x0OyqBkAUUZwq/PzCwElELiJ1Xe6b4GHzleFe5vIPkxqDgmbhu5BaqQ08ZiwIOGo8frCNuILbXynUgQ0A8TcOo9S6cPG/m3e1U+gVgUzbTgJne6A30sXDWbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691437; c=relaxed/simple;
	bh=gpLyfcRUS6YltClfoV8yeRPjJWUULeCofAV8fIvORqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tk5Eqnc9YyH9kYHzzxRIQ2mC3EZ3aP7JtiSivAFw/4lO4jOfVONfcwrHM5TQNbLfE94nL+J4fZJMVHHQgA3odx8tnsmWQaTrcz7nWFEmcO05x/YFgR1npHrksuVfRymMfWmGoWPcGiWVeKtbHlVQZr3ZDqM2BRuwxKhNsa4ai+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lSLkWFRq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lSLkWFRq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6879C19425;
	Mon, 20 Apr 2026 13:23:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691437;
	bh=gpLyfcRUS6YltClfoV8yeRPjJWUULeCofAV8fIvORqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lSLkWFRq6NUEAzOS+3GJ+tjIm+BBlPmx9X5d5wapkFdFNYKp8bdoV0CbVuKZGKtcw
	 eHdIScU2O26qNlRGa+eYI6ipk3rJODhyUpSyIwD2eIepPe/Uilf+Qf6OenNubM5AyL
	 wbnCyPMLxpd7HgPGJgnvK0zJEsS37O3y8+2hMQCk98yWz7vh1e578zD4t1745DT/jj
	 Ej1mp8pUERLBRafh5ytdsNyitxmmhdMH2tAqhjUQfdPF0j5HYfIx1LCEbVxHTYcnY9
	 BTze5YoPoaYD/yNGv32gvrt8FWxkNSyHBKHSQoskLWESFf+Ua3sL/935ijrZ3V+K5T
	 D9AavnSI3J7Sw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Magnus Kalland <magnus@dolphinics.com>,
	"Lars B. Kristiansen" <larsk@dolphinics.com>,
	Jonas Markussen <jonas@dolphinics.com>,
	"Tore H. Larsen" <torel@simula.no>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	joro@8bytes.org,
	will@kernel.org,
	iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-6.18] iommu/amd: Invalidate IRT cache for DMA aliases
Date: Mon, 20 Apr 2026 09:17:00 -0400
Message-ID: <20260420132314.1023554-26-sashal@kernel.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Magnus Kalland <magnus@dolphinics.com>

[ Upstream commit 5aac28784dca6819e96e5f93e644cdee59e50f6e ]

DMA aliasing causes interrupt remapping table entries (IRTEs) to be shared
between multiple device IDs. See commit 3c124435e8dd
("iommu/amd: Support multiple PCI DMA aliases in IRQ Remapping") for more
information on this. However, the AMD IOMMU driver currently invalidates
IRTE cache entries on a per-device basis whenever an IRTE is updated, not
for each alias.

This approach leaves stale IRTE cache entries when an IRTE is cached under
one DMA alias but later updated and invalidated through a different alias.
In such cases, the original device ID is never invalidated, since it is
programmed via aliasing.

This incoherency bug has been observed when IRTEs are cached for one
Non-Transparent Bridge (NTB) DMA alias, later updated via another.

Fix this by invalidating the interrupt remapping table cache for all DMA
aliases when updating an IRTE.

Co-developed-by: Lars B. Kristiansen <larsk@dolphinics.com>
Signed-off-by: Lars B. Kristiansen <larsk@dolphinics.com>
Co-developed-by: Jonas Markussen <jonas@dolphinics.com>
Signed-off-by: Jonas Markussen <jonas@dolphinics.com>
Co-developed-by: Tore H. Larsen <torel@simula.no>
Signed-off-by: Tore H. Larsen <torel@simula.no>
Signed-off-by: Magnus Kalland <magnus@dolphinics.com>
Link: https://lore.kernel.org/linux-iommu/9204da81-f821-4034-b8ad-501e43383b56@amd.com/
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have a complete picture. Let me compile the analysis.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: PARSE THE SUBJECT LINE
Record: [iommu/amd] [Invalidate/Fix] Fix stale IRTE cache entries when
DMA aliases are used by invalidating all aliases instead of just one
devid.

### Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
- **Co-developed-by:** Lars B. Kristiansen, Jonas Markussen, Tore H.
  Larsen — multiple developers from Dolphin ICS and Simula, indicating
  collaborative work on NTB hardware
- **Signed-off-by:** Magnus Kalland (author), Lars B. Kristiansen, Jonas
  Markussen, Tore H. Larsen, Joerg Roedel (AMD IOMMU maintainer)
- **Link:** `https://lore.kernel.org/linux-
  iommu/9204da81-f821-4034-b8ad-501e43383b56@amd.com/` — AMD mailing
  list discussion
- No Fixes: tag (expected for autosel candidates)
- No Cc: stable (expected)
- No Reported-by (the co-developers ARE the reporters — Dolphin ICS
  makes NTB hardware)

Record: Signed off by the IOMMU subsystem maintainer Joerg Roedel.
Multi-developer collaborative effort from NTB hardware company.

### Step 1.3: ANALYZE THE COMMIT BODY TEXT
The commit describes:
- **Bug:** DMA aliasing shares IRTEs between multiple device IDs. When
  the IRTE cache is invalidated, only one device ID is invalidated,
  leaving stale cache entries for other aliases.
- **Symptom:** "Incoherency bug has been observed when IRTEs are cached
  for one Non-Transparent Bridge (NTB) DMA alias, later updated via
  another" — interrupt delivery failures for NTB devices.
- **Root cause:** `iommu_flush_irt_and_complete()` only calls
  `build_inv_irt()` for a single devid, not all aliases.
- **Fix:** Use `pci_for_each_dma_alias()` to invalidate all aliases.

Record: Real hardware bug observed on NTB devices. Stale IRTE cache
entries cause interrupt failures. Bug exists since v5.5 when DMA alias
support was added to IRQ remapping.

### Step 1.4: DETECT HIDDEN BUG FIXES
Not hidden — this is explicitly described as fixing an "incoherency bug"
with clear hardware symptoms.

Record: This is an explicit bug fix, not hidden.

## PHASE 2: DIFF ANALYSIS

### Step 2.1: INVENTORY THE CHANGES
- **File:** `drivers/iommu/amd/iommu.c`
- **Lines:** +23 / -5 (net +18)
- **Functions modified:** `iommu_flush_irt_and_complete()` (modified),
  `iommu_flush_dev_irt()` (added helper)

Record: Single file, 28 lines changed. Small, contained fix. Scope:
single-file surgical fix.

### Step 2.2: CODE FLOW CHANGE
**New helper `iommu_flush_dev_irt()`:** Takes a devid and issues a
`build_inv_irt()` + `__iommu_queue_command_sync()` for that specific
devid. This is the callback for `pci_for_each_dma_alias()`.

**Modified `iommu_flush_irt_and_complete()`:**
- BEFORE: Called `build_inv_irt(&cmd, devid)` for the single passed
  devid only
- AFTER: Looks up the PCI device via `search_dev_data()`, then uses
  `pci_for_each_dma_alias()` to invalidate all DMA aliases. Falls back
  to single devid for non-PCI devices.

### Step 2.3: BUG MECHANISM
Category: **Logic/correctness fix** — the invalidation was incomplete,
missing aliases.

The bug pattern: When commit 3c124435e8dd added DMA alias support for
IRQ remapping table allocation, it used `pci_for_each_dma_alias()` to
set up the remap table for all aliases. But the corresponding cache
invalidation in `iommu_flush_irt_and_complete()` was never updated to
invalidate all aliases — it only invalidated the single devid passed in.

### Step 2.4: FIX QUALITY
- The fix is logically correct: if IRTEs are shared across aliases via
  `pci_for_each_dma_alias()`, invalidation must also cover all aliases
- Minimal and surgical
- The fallback to single devid for non-PCI is safe
- No regression risk: adding more invalidations is safe (at worst,
  slightly more overhead for flush operations)

Record: Fix is obviously correct, minimal, and safe. Low regression
risk.

## PHASE 3: GIT HISTORY

### Step 3.1: BLAME
The function `iommu_flush_irt_and_complete()` was created in commit
98aeb4ea5599c (v6.5, 2023-05-30) which extracted the flush+complete
logic. The actual single-devid invalidation pattern dates back to the
original IRT code.

The buggy code pattern (only invalidating one devid) has existed since
commit 3c124435e8dd (v5.5, 2019-10-22) added DMA alias support without
updating invalidation.

### Step 3.2: FIXES TAG
No Fixes: tag present. The logical "Fixes:" would be 3c124435e8dd, which
introduced DMA alias support in IRQ remapping without updating the cache
invalidation path.

Record: Bug has existed since v5.5 (commit 3c124435e8dd). The buggy code
exists in all active stable trees (6.1.y, 6.6.y, 6.12.y, etc.).

### Step 3.3: FILE HISTORY
Recent changes to the file include:
- `d2a0cac105970` (v7.0) — moved `wait_on_sem()` out of spinlock
- `9e249c4841282` (v7.0) — serialized cmd_sem_val under lock

These two v7.0-only commits changed the internal structure of
`iommu_flush_irt_and_complete()` significantly, affecting
backportability.

### Step 3.4: AUTHOR
Magnus Kalland and co-developers are from Dolphin ICS (dolphinics.com),
a company that makes NTB products. They have direct access to the
affected hardware and observed the bug firsthand.

### Step 3.5: DEPENDENCIES
**Critical dependency issue:** The patch under review targets the v7.0
version of `iommu_flush_irt_and_complete()` which uses:
- `get_cmdsem_val()` (from 9e249c4841282, v7.0 only)
- `wait_on_sem()` outside lock (from d2a0cac105970, v7.0 only)

In stable trees (6.6.y, 6.12.y), the function uses
`atomic64_add_return()` and `wait_on_sem()` inside the lock. **This
patch does NOT apply cleanly to any stable tree.**

## PHASE 4: MAILING LIST RESEARCH

### Step 4.1: PATCH DISCUSSION
The patch went through 5 revisions (RFC v1 → v2 → v3 (3 patches) → v4 →
v5 (single patch)), showing extensive review. The v5 consolidated to a
single patch, with the change note "Add missing error code check after
invalidating."

Joerg Roedel (AMD IOMMU maintainer) reviewed the RFC v1 and asked for
review from Vasant and/or Suravee (AMD developers).

### Step 4.2: REVIEWERS
Joerg Roedel signed off as maintainer. The Link: points to an AMD-
internal discussion thread.

### Step 4.3-4.5: BUG REPORT / RELATED / STABLE
No separate bug report — the developers who make NTB hardware found and
fixed it themselves. No stable mailing list discussion found.

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1-5.4: FUNCTION ANALYSIS
`iommu_flush_irt_and_complete()` is called from 3 sites:
1. `modify_irte_ga()` — modifying GA-mode IRTEs
2. `modify_irte()` — modifying standard IRTEs
3. `free_irte()` — freeing IRTEs

These are called during interrupt setup/teardown for devices using AMD
IOMMU interrupt remapping. For NTB devices with DMA aliases, missing
alias invalidation means interrupts can be misrouted or blocked.

### Step 5.5: SIMILAR PATTERNS
The `pci_for_each_dma_alias()` pattern is already used in the same file
for:
- `clone_alias()` — IOMMU device setup
- `set_remap_table_entry_alias()` — setting remap table entries for
  aliases
- `alloc_irq_table()` — allocating IRQ table for aliases

The fix brings cache invalidation in line with what already exists for
table allocation.

## PHASE 6: STABLE TREE ANALYSIS

### Step 6.1: BUGGY CODE IN STABLE
Yes — the buggy pattern (single-devid invalidation) exists in all stable
trees since v5.5. Verified:
- v6.6: `iommu_flush_irt_and_complete()` exists at line 2844, calls
  `build_inv_irt(&cmd, devid)` for single devid
- v6.12: Same pattern at line 2882

### Step 6.2: BACKPORT COMPLICATIONS
**Significant rework needed.** The function internals differ between
mainline (v7.0) and stable:
- v6.6/6.12: Uses `atomic64_add_return(1, &iommu->cmd_sem_val)` before
  lock, `wait_on_sem()` inside lock
- v7.0: Uses `get_cmdsem_val()` inside lock, `wait_on_sem()` outside
  lock

The core fix concept is portable, but the patch won't apply cleanly. The
necessary APIs (`search_dev_data()`, `pci_for_each_dma_alias()`,
`build_inv_irt()`) all exist in stable trees.

Record: Needs rework for stable. Minor-to-moderate conflicts expected.

## PHASE 7: SUBSYSTEM CONTEXT

### Step 7.1: SUBSYSTEM
- **Subsystem:** IOMMU (drivers/iommu/amd/) — specifically interrupt
  remapping
- **Criticality:** IMPORTANT — affects AMD IOMMU interrupt remapping for
  DMA-aliased devices

### Step 7.2: ACTIVITY
Active subsystem with 216 commits since v6.5.

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: AFFECTED USERS
Users with NTB (Non-Transparent Bridge) or other DMA-aliased devices on
AMD IOMMU systems. This is a niche but important use case (data center
interconnects, high-performance computing).

### Step 8.2: TRIGGER CONDITIONS
Triggered when: An IRTE is first cached under one DMA alias, then later
updated/invalidated through a different alias. This can happen during
normal interrupt reconfiguration for NTB devices. Not timing-dependent —
it's a deterministic logic bug.

### Step 8.3: SEVERITY
The stale IRTE cache entries can cause interrupt misdelivery or
blocking. For NTB devices this can mean:
- Interrupts not delivered → device hangs
- Potential for incorrect interrupt routing

Severity: **HIGH** for affected hardware.

### Step 8.4: RISK-BENEFIT
- **Benefit:** Fixes interrupt delivery for NTB/DMA-aliased devices on
  AMD IOMMU — HIGH for affected users
- **Risk:** Low — the fix only adds MORE invalidation commands. The new
  helper is simple. Extra invalidations are harmless (just slightly more
  overhead). BUT the backport needs rework.

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: EVIDENCE COMPILATION

**FOR backporting:**
1. Fixes a real, observed hardware bug (stale IRTE cache entries)
2. Bug exists since v5.5 — affects all active stable trees
3. Small, contained fix (~28 lines)
4. Accepted by subsystem maintainer (Joerg Roedel)
5. Multiple co-developers with hardware expertise
6. 5 revision iterations showing thorough review
7. Fix is logically simple and correct — add invalidation for all
   aliases
8. No regression risk — extra invalidations are safe

**AGAINST backporting:**
1. Patch does NOT apply cleanly to stable — needs rework due to
   v7.0-only prerequisites (`get_cmdsem_val()`, different lock/wait
   structure)
2. Affects a niche use case (NTB/DMA-aliased devices on AMD IOMMU)
3. No explicit Fixes: tag or Cc: stable

### Step 9.2: STABLE RULES CHECKLIST
1. Obviously correct and tested? **YES** — 5 revisions, maintainer
   signoff, hardware testing by NTB developers
2. Fixes a real bug? **YES** — stale IRTE cache entries causing
   interrupt failures on NTB hardware
3. Important issue? **YES** — interrupt delivery failures for affected
   hardware
4. Small and contained? **YES** — single function + helper, 28 lines
5. No new features? **Correct** — no new features
6. Can apply to stable? **Needs rework** — conflicts with v7.0-only
   changes to function internals

### Step 9.3: EXCEPTION CATEGORIES
Not an exception case — this is a standard bug fix.

### Step 9.4: DECISION
This is a genuine, well-understood bug fix for a real hardware issue
that has existed since v5.5. The fix is small, surgical, and obviously
correct. While it needs rework for stable trees, the concept is portable
and the necessary APIs exist in all stable versions. The affected user
population (NTB devices on AMD IOMMU) is niche but the impact for those
users is significant (broken interrupt delivery). The benefit clearly
outweighs the risk.

## Verification:
- [Phase 1] Parsed tags: Co-developed-by from 3 developers + author,
  maintainer SOB from Joerg Roedel, Link to AMD mailing list
- [Phase 2] Diff analysis: +23/-5 lines in single file, adds
  `iommu_flush_dev_irt()` helper and modifies
  `iommu_flush_irt_and_complete()` to iterate all DMA aliases
- [Phase 3] git blame: Function created in 1ce018df87640 (v6.5), buggy
  pattern since 3c124435e8dd (v5.5)
- [Phase 3] git show 3c124435e8dd: Confirmed original commit added DMA
  alias support for IRQ remapping but not for cache invalidation
- [Phase 3] git merge-base: 3c124435e8dd is in v5.5 (not v5.4), affects
  all active stable trees
- [Phase 3] d2a0cac105970 and 9e249c4841282 are v7.0-only, confirmed by
  `git tag --contains`
- [Phase 4] Patchew shows v5 is the applied version, evolved from
  3-patch v3 to single-patch v5
- [Phase 4] Joerg Roedel (maintainer) requested AMD team review at RFC
  v1 stage
- [Phase 5] `iommu_flush_irt_and_complete()` called from 3 sites:
  modify_irte_ga, modify_irte, free_irte
- [Phase 5] pci_for_each_dma_alias already used in same file for table
  setup — fix brings invalidation in line
- [Phase 6] v6.6 and v6.12 confirmed to have the buggy single-devid
  pattern, but function internals differ from v7.0
- [Phase 6] search_dev_data(), pci_for_each_dma_alias(), dev_is_pci()
  all exist in v6.6
- [Phase 6] Backport needs rework: different cmd_sem_val handling and
  wait_on_sem() placement
- [Phase 8] Severity: HIGH for affected NTB hardware users — interrupt
  delivery failures
- UNVERIFIED: Could not access lore.kernel.org directly (Anubis
  protection). Used patchew.org and lkml.iu.edu instead.

**YES**

 drivers/iommu/amd/iommu.c | 28 +++++++++++++++++++++++-----
 1 file changed, 23 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 760d5f4623b55..f20853d13bebb 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -3179,26 +3179,44 @@ const struct iommu_ops amd_iommu_ops = {
 static struct irq_chip amd_ir_chip;
 static DEFINE_SPINLOCK(iommu_table_lock);
 
+static int iommu_flush_dev_irt(struct pci_dev *unused, u16 devid, void *data)
+{
+	int ret;
+	struct iommu_cmd cmd;
+	struct amd_iommu *iommu = data;
+
+	build_inv_irt(&cmd, devid);
+	ret = __iommu_queue_command_sync(iommu, &cmd, true);
+	return ret;
+}
+
 static void iommu_flush_irt_and_complete(struct amd_iommu *iommu, u16 devid)
 {
 	int ret;
 	u64 data;
 	unsigned long flags;
-	struct iommu_cmd cmd, cmd2;
+	struct iommu_cmd cmd;
+	struct pci_dev *pdev = NULL;
+	struct iommu_dev_data *dev_data = search_dev_data(iommu, devid);
 
 	if (iommu->irtcachedis_enabled)
 		return;
 
-	build_inv_irt(&cmd, devid);
+	if (dev_data && dev_data->dev && dev_is_pci(dev_data->dev))
+		pdev = to_pci_dev(dev_data->dev);
 
 	raw_spin_lock_irqsave(&iommu->lock, flags);
 	data = get_cmdsem_val(iommu);
-	build_completion_wait(&cmd2, iommu, data);
+	build_completion_wait(&cmd, iommu, data);
 
-	ret = __iommu_queue_command_sync(iommu, &cmd, true);
+	if (pdev)
+		ret = pci_for_each_dma_alias(pdev, iommu_flush_dev_irt, iommu);
+	else
+		ret = iommu_flush_dev_irt(NULL, devid, iommu);
 	if (ret)
 		goto out_err;
-	ret = __iommu_queue_command_sync(iommu, &cmd2, false);
+
+	ret = __iommu_queue_command_sync(iommu, &cmd, false);
 	if (ret)
 		goto out_err;
 	raw_spin_unlock_irqrestore(&iommu->lock, flags);
-- 
2.53.0

