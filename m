Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE5EA4A3F03;
	Mon, 31 Aug 2026 13:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183767; cv=none; b=VLzSXVZ4Pqu8hHWJ5+PY/ruvVQSNE0SOaU/rK8zYQX89Q7OeTEUMfSZIxeWT4UcSS/+EtW1JMAQMBPRIbZ1cL7neh4O5r0gbgkc07HkAns7XeCP4SkV+j3rStn93FuTABG7iOWoA5NVKZHPKEmNiCQymHC/he0GBPPkmvHuUovU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183767; c=relaxed/simple;
	bh=J4Xhgnk7uH1euYXAu1QuNCuWIvlkjr+YzWefMeUp820=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RqyRyX6dJajsh5e+HAGYpAfIhJJn2sl9Pt133VJBWfs60d1ZBPmOsN8dpsCo10bFhR9JwdHNaA2irYpzt53H3dUsj4mrLEngvUUe8RalyJs/nVi6IuKnYf1i+UfInYxRozV84WyQKx5MGIoNDeSjhfyMzNlSs7IIhhb0eFGtIJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ol6mF5bU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ol6mF5bU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 721461F00ADF;
	Mon, 31 Aug 2026 13:42:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183763;
	bh=HHaoNKZh61Flys8MH23Dn7jmp00f8l16zIqdzj69wwU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ol6mF5bUCs4vLeMsKfjMutPX4RITGPMiMPPinLfZVf8u1qnTTEp4r/91f8g04PGcY
	 +kAnlYjArO0lMcyD1ejn9hVvhBGXrE6eb0bX940/W2xf+1eC/OtnfvHJCjVAh2kYje
	 CSSRK6KmtS/d/cpYHIy2mABKjo0skGdlsExIrg6aR5sb24gOUsTsZh8ANaH0DzmFEm
	 Ojkjbugfm+pWi3GT3xfrsKwGgoSMQ0TIdojRMr0T7UF0HcRanLmF7IGGJxjlgLUkvW
	 ZRtk/zLodtKsdLkSTERnDxEKfjLbPJYxMoxeucTATMssaiaSIlLCBCLQdod6p7o9J0
	 0FHlaG5jI10/A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Adrian Ng Ho Yin <adrianhoyin.ng@altera.com>,
	Tze Yee Ng <tze.yee.ng@altera.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	adrian.ho.yin.ng@altera.com,
	dmaengine@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] dmaengine: altera-msgdma: Use memcpy_toio for descriptor FIFO writes
Date: Mon, 31 Aug 2026 09:25:18 -0400
Message-ID: <20260831133314.4125787-290-sashal@kernel.org>
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

From: Adrian Ng Ho Yin <adrianhoyin.ng@altera.com>

[ Upstream commit 94963138cce29f85605d76c94fa1d43a0335ead9 ]

The descriptor FIFO requires that all words of a descriptor are written
in order, with the control word written last to flush it into the DMA
engine. Using memcpy() with __force to __iomem is not the correct API
and does not guarantee appropriate MMIO access on all architectures.

Replace the descriptor body copy with memcpy_toio(), using
offsetof(struct msgdma_extended_desc, control) to exclude the control
word. This matches the previous sizeof(desc->hw_desc) - sizeof(u32)
length only when control is the last struct member; add a static_assert
to enforce that layout so a future field after control cannot silently
break FIFO ordering.

Keep writing the control word separately with write barriers, so it
remains the final word pushed into the FIFO.

Signed-off-by: Adrian Ng Ho Yin <adrianhoyin.ng@altera.com>
Signed-off-by: Tze Yee Ng <tze.yee.ng@altera.com>
Link: https://patch.msgid.link/f6f3b4a2e2eb0eb1a51976de3f5d1ef5bab9bd76.1779697226.git.tze.yee.ng@altera.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit Message Forensics

**Step 1.1 – Subject line**

Record: `[dmaengine: altera-msgdma] [Use] Use memcpy_toio for descriptor
FIFO writes` — subsystem is Altera mSGDMA DMAengine driver; action is
replacing incorrect MMIO copy API.

**Step 1.2 – Tags**

Record:
- **Fixes:** none
- **Reported-by:** none
- **Tested-by:** none
- **Reviewed-by / Acked-by:** none
- **Link:** https://patch.msgid.link/f6f3b4a2e2eb0eb1a51976de3f5d1ef5bab
  9bd76.1779697226.git.tze.yee.ng@altera.com
- **Signed-off-by:** Adrian Ng Ho Yin, Tze Yee Ng, Vinod Koul
  (maintainer)
- **Cc: stable@vger.kernel.org:** absent (expected for manual review)
- Notable: no syzbot, no user bug report, no crash trace

**Step 1.3 – Body analysis**

Record:
- **Bug:** Descriptor FIFO hardware requires ordered 32-bit word writes;
  control word must be written last to flush the descriptor. Using
  `memcpy()` with `__force` cast to `__iomem` is not the correct MMIO
  API and does not guarantee proper access on all architectures.
- **Symptom:** Malformed or partially written descriptors can cause DMA
  to wrong addresses, transfer failures, or silent data corruption.
- **Root cause:** Body of descriptor copied via plain `memcpy()` to MMIO
  instead of `memcpy_toio()`.
- **Version info:** none in message

**Step 1.4 – Hidden bug fix?**

Record: **Yes.** Although framed as an API correction, it fixes a real
hardware-interaction bug. The pre-existing comment in the driver already
acknowledged uncertainty about `memcpy()` write ordering; this commit
completes that fix by using the proper MMIO helper.

---

## Phase 2: Diff Analysis

**Step 2.1 – Inventory**

Record:
- **File:** `drivers/dma/altera-msgdma.c` (+15 / −9, 24 lines touched)
- **Function modified:** `msgdma_copy_one()` only
- **Scope:** single-file, surgical fix

**Step 2.2 – Code flow change**

Record:
- **Hunk 1 (before FIFO wait):** adds duplicate `static_assert`
  verifying `control` is the last struct member.
- **Hunk 2 (before body copy):** adds second identical `static_assert`
  (copy-paste error acknowledged by author on list).
- **Hunk 3 (body copy):** `memcpy((void __force *)hw_desc, ...)` →
  `memcpy_toio(hw_desc, ..., offsetof(..., control))`; control word
  still written separately via `iowrite32()` + `wmb()`.
- **Path affected:** every descriptor submission to hardware FIFO
  (normal DMA operation path).

**Step 2.3 – Bug mechanism**

Record: **Memory safety / MMIO correctness fix.** Category: incorrect
MMIO access pattern. Plain `memcpy()` to `__iomem` may use CPU memory
copy optimizations (reordering, non-MMIO stores) that do not satisfy
hardware FIFO ordering requirements. `memcpy_toio()` uses architecture-
appropriate MMIO store sequences.

**Step 2.4 – Fix quality**

Record: Fix is logically correct and minimal. Regression risk is very
low — it replaces one copy primitive with the documented equivalent.
Minor quality blemish: duplicate `static_assert` blocks (author agreed
to fix in v3, but v2 was merged as-is). Pre-existing concerns (BE
endianness mix of `memcpy_toio` + `iowrite32`, `mdelay()` while holding
spinlock) are unchanged by this patch.

---

## Phase 3: Git History Investigation

**Step 3.1 – Blame**

Record: Buggy `memcpy()` path introduced in `6084fc2ec478d` (Aug 2017,
Stefan Roese, "Use macros instead of structs..."). Original driver added
in `a85c6f1b2921c` (Jul 2017). Bug has been present ~9 years.

**Step 3.2 – Fixes: tag**

Record: N/A — no Fixes: tag present.

**Step 3.3 – Related file history**

Record: Recent stable-tree changes to this file include descriptor
free/cleanup fixes (`54e4ada1a4206`, `d3ddfab0969b1`), spinlock IRQ
variant fix (`261d3a85d9598`). No related fix for MMIO copy already
present. Standalone patch (v2 of 1-patch series).

**Step 3.4 – Author context**

Record: Authors are Altera/Intel engineers (hardware vendor). Vinod Koul
(dmaengine maintainer) applied the patch. Authors are not regular
altera-msgdma maintainers but submitted from hardware expertise.

**Step 3.5 – Dependencies**

Record: No prerequisites. Uses `memcpy_toio()` and `static_assert`, both
available in Linux 6.18. Applies cleanly (`git apply --check` passed).

---

## Phase 4: Mailing List and External Research

**Step 4.1 – Original discussion**

Record:
- **URL:** https://patch.msgid.link/f6f3b4a2e2eb0eb1a51976de3f5d1ef5bab9
  bd76.1779697226.git.tze.yee.ng@altera.com
- **Series:** v2 only (v1 not in thread); committed version matches v2
- **Maintainer response:** Vinod Koul — "Applied, thanks!"
- **No stable nomination** from reviewers
- **No NAKs** from human reviewers

**Step 4.2 – Reviewers**

Record: CC'd: Olivier Dautricourt, Stefan Roese (original driver
author), Vinod Koul, Frank Li, dmaengine@, linux-kernel@. Appropriate
maintainers included.

**Step 4.3 – Bug report**

Record: No external bug report. Sashiko AI review flagged duplicate
static_assert (Low) and pre-existing MMIO/endianness/spinlock+mdelay
issues (High, pre-existing). Author Tze Yee Ng agreed duplicate assert
was copy-paste error; offered v3 with single assert and optional
`iowrite32()` loop if Frank Li preferred. Frank Li asked author to
review Sashiko comments; no further human NAK before merge.

**Step 4.4 – Related patches**

Record: Standalone. Author indicated FIFO polling and stricter MMIO
access could be separate follow-ups.

**Step 4.5 – Stable list history**

Record: Not searched separately; no stable nomination found in patch
thread.

---

## Phase 5: Code Semantic Analysis

**Step 5.1 – Key functions**

Record: `msgdma_copy_one()` modified; callers unchanged.

**Step 5.2 – Callers**

Record:
- `msgdma_copy_desc_to_fifo()` → called from `msgdma_start_transfer()`
- `msgdma_start_transfer()` called from:
  - `msgdma_issue_pending()` (under `spin_lock_irqsave`)
  - `msgdma_irq_handler()` (under `spin_lock`)
- Reachable on every DMA transfer submission and from IRQ when
  controller becomes idle.

**Step 5.3 – Callees**

Record: `ioread32()` (FIFO full check), `mdelay(1)` (wait loop),
`memcpy_toio()` (new), `wmb()`, `iowrite32()` (control word flush).

**Step 5.4 – Reachability**

Record: Triggered whenever userspace/kernel submits DMA operations
through the dmaengine API on Altera mSGDMA hardware
(`CONFIG_ALTERA_MSGDMA`). Common operational path, not init-only or
error-only.

**Step 5.5 – Similar patterns**

Record: Other dma drivers use `memcpy_toio()` for MMIO (e.g., edma). The
forced `memcpy()` to `__iomem` pattern is explicitly discouraged in
kernel MMIO documentation.

---

## Phase 6: Cross-Reference Against Local Tree

**Step 6.1 – Buggy code in this tree?**

Record: **Yes.** Local tree is **Linux 6.18.44** (`git describe HEAD` →
v6.18.44). Buggy `memcpy((void __force *)hw_desc, ...)` present at lines
518–519 of `drivers/dma/altera-msgdma.c`. Bug present since driver
introduction (2017).

**Step 6.2 – Backport complications**

Record: **Clean apply** confirmed via `git format-patch -1 94963138cce29
| git apply --check`. No conflicting recent changes to this function in
6.18.y.

**Step 6.3 – Related fixes already present?**

Record: Commit `94963138cce29` is **not** in `stable/linux-6.18.y` (`git
merge-base --is-ancestor` returned exit 1). No equivalent fix found via
grep for `memcpy_toio` in this file.

---

## Phase 7: Subsystem and Maintainer Context

**Step 7.1 – Subsystem criticality**

Record: **dmaengine / Altera mSGDMA driver** — **PERIPHERAL** (niche
FPGA/embedded hardware, `CONFIG_ALTERA_MSGDMA`). However, DMA descriptor
corruption affects memory integrity for users of that hardware.

**Step 7.2 – Subsystem activity**

Record: Driver receives occasional maintenance (descriptor lifecycle,
spinlock fixes in 2024–2025). Mature, low-churn code.

---

## Phase 8: Impact and Risk Assessment

**Step 8.1 – Who is affected**

Record: Users with `CONFIG_ALTERA_MSGDMA` on Altera/Intel FPGA platforms
(PCIe-connected Cyclone and similar, ARM and x86 per original driver
testing). Config-specific, platform-specific.

**Step 8.2 – Trigger conditions**

Record: Every DMA descriptor submission. Not timing-dependent race;
architecture-dependent MMIO behavior. Unprivileged users can trigger via
dmaengine consumers using this controller.

**Step 8.3 – Failure mode severity**

Record: Corrupted descriptor fields → DMA to/from wrong physical
addresses → **data corruption** (CRITICAL for affected users). Could
also cause transfer failure or hardware stall. No crash/oops required
for impact.

**Step 8.4 – Risk-benefit**

Record:
- **Benefit:** Prevents potential silent memory corruption on non-x86 or
  strict MMIO architectures; uses correct kernel API; hardware vendor
  fix.
- **Risk:** Very low — 1-line functional change plus compile-time
  assert; applies cleanly.
- **Ratio:** Favorable for affected hardware users; limited broader
  impact due to niche driver.

---

## Phase 9: Final Synthesis

**Step 9.1 – Evidence summary**

**FOR backport:**
- Real MMIO correctness bug present since 2017 in this tree
- Potential DMA data corruption (critical for affected users)
- Small, obviously correct, clean-apply fix
- Hardware vendor submitted with maintainer acceptance
- Original driver comment acknowledged memcpy ordering uncertainty
- Commit not yet in 6.18.y

**AGAINST backport:**
- No user bug report, crash, or syzbot finding
- Very niche driver (FPGA embedded)
- Driver has functioned with workaround since 2017 without reported
  failures
- Duplicate `static_assert` in merged code (cosmetic)
- Does not address all MMIO concerns raised in AI review (pre-existing)
- No explicit stable nomination

**Unresolved:** No verified report of the bug manifesting in production;
impact inferred from API semantics and hardware requirements.

**Step 9.2 – Stable rules checklist**

1. Obviously correct and tested? **PASS** — API fix is standard; no
   runtime Tested-by, but logically sound.
2. Fixes a real bug affecting users? **PASS** — incorrect MMIO access on
   descriptor submission path.
3. Important issue? **PASS** — potential DMA data corruption.
4. Small and contained? **PASS** — 1 file, ~24 lines.
5. No new features/APIs? **PASS** — behavior correction only.
6. Can apply to local tree? **PASS** — clean apply verified.

**Step 9.3 – Exception categories**

Record: Not a device ID, quirk, DT, build, or docs fix. Standard driver
correctness bug fix.

**Step 9.4 – Decision rationale**

For Linux 6.18.y, the buggy code exists, the fix applies cleanly, and
the failure mode (DMA writing to wrong memory) is serious for the Altera
mSGDMA users this driver serves. While the driver is niche and lacks a
field bug report, the original code explicitly doubted `memcpy()`
ordering, the hardware vendor corrected the MMIO access pattern, and the
patch is minimal with negligible regression risk. Stable trees routinely
accept such hardware-interaction fixes when data corruption is the
consequence.

---

## Verification

- [Phase 1] Parsed commit `94963138cce29` on master; tags: Link, SOBs
  only; no Reported-by/syzbot
- [Phase 2] Diff: 1 file, `msgdma_copy_one()` only; `memcpy` →
  `memcpy_toio`; duplicate static_assert confirmed in `git show
  94963138cce29`
- [Phase 3] `git blame`: buggy memcpy from `6084fc2ec478d` (2017);
  driver from `a85c6f1b2921c` (2017)
- [Phase 3] `git log -20 -- drivers/dma/altera-msgdma.c`: no prior MMIO
  fix
- [Phase 3] `git format-patch -1 94963138cce29 | git apply --check`:
  clean apply
- [Phase 4] `b4 dig -c 94963138cce29`: lore URL found; v2 series
- [Phase 4] `b4 dig -c 94963138cce29 -w`: Vinod Koul, Frank Li, Stefan
  Roese CC'd
- [Phase 4] `b4 dig -m /tmp/altera-msgdma.mbx`: Vinod applied; author
  acknowledged duplicate assert; no stable nomination
- [Phase 5] Call chain verified in source:
  `msgdma_issue_pending`/`msgdma_irq_handler` → `msgdma_start_transfer`
  → `msgdma_copy_desc_to_fifo` → `msgdma_copy_one`
- [Phase 6] `git describe HEAD`: v6.18.44; `make kernelversion`: 6.18.44
- [Phase 6] Buggy `memcpy((void __force *)hw_desc` confirmed at line 518
  in local tree
- [Phase 6] `git merge-base --is-ancestor 94963138cce29
  stable/linux-6.18.y`: NOT ancestor (exit 1)
- [Phase 6] `grep memcpy_toio drivers/dma/altera-msgdma.c`: no match in
  local tree (fix absent)
- [Phase 7] `grep CONFIG_ALTERA_MSGDMA drivers/dma/Kconfig`: tristate,
  depends on HAS_IOMEM
- [Phase 8] Struct layout verified: `control` is last field at offset 28
  in 32-byte `msgdma_extended_desc`

**YES**

 drivers/dma/altera-msgdma.c | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/drivers/dma/altera-msgdma.c b/drivers/dma/altera-msgdma.c
index a203fdd84950e..e1811a9be0bbe 100644
--- a/drivers/dma/altera-msgdma.c
+++ b/drivers/dma/altera-msgdma.c
@@ -498,6 +498,11 @@ static void msgdma_copy_one(struct msgdma_device *mdev,
 {
 	void __iomem *hw_desc = mdev->desc;
 
+	/* Ensure control is the last field — required for correct FIFO flush ordering */
+	static_assert(offsetof(struct msgdma_extended_desc, control) ==
+		      sizeof(struct msgdma_extended_desc) - sizeof(u32),
+		      "control must be the last field in msgdma_extended_desc");
+
 	/*
 	 * Check if the DESC FIFO it not full. If its full, we need to wait
 	 * for at least one entry to become free again
@@ -506,17 +511,18 @@ static void msgdma_copy_one(struct msgdma_device *mdev,
 	       MSGDMA_CSR_STAT_DESC_BUF_FULL)
 		mdelay(1);
 
+	/* Ensure control is the last field — required for correct FIFO flush ordering */
+	static_assert(offsetof(struct msgdma_extended_desc, control) ==
+			sizeof(struct msgdma_extended_desc) - sizeof(u32),
+			"control must be the last field in msgdma_extended_desc");
+
 	/*
-	 * The descriptor needs to get copied into the descriptor FIFO
-	 * of the DMA controller. The descriptor will get flushed to the
-	 * FIFO, once the last word (control word) is written. Since we
-	 * are not 100% sure that memcpy() writes all word in the "correct"
-	 * order (address from low to high) on all architectures, we make
-	 * sure this control word is written last by single coding it and
-	 * adding some write-barriers here.
+	 * Copy the descriptor into the descriptor FIFO of the DMA controller,
+	 * excluding the control word. The FIFO is flushed and the descriptor
+	 * becomes valid once the control word is written last.
 	 */
-	memcpy((void __force *)hw_desc, &desc->hw_desc,
-	       sizeof(desc->hw_desc) - sizeof(u32));
+	memcpy_toio(hw_desc, &desc->hw_desc,
+		    offsetof(struct msgdma_extended_desc, control));
 
 	/* Write control word last to flush this descriptor into the FIFO */
 	mdev->idle = false;
-- 
2.53.0

