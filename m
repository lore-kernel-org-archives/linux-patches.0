Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8666049483A;
	Mon, 31 Aug 2026 13:38:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183522; cv=none; b=QwDfMgs5bOw1Qk6o6NISEGA43No2PI98rPidxaIBjmD3fIqnyf/MI+4gm7v7sCwJdcmdTLFSVlqbjDdAqMrlSYQEVltZlp1EmZ3M/meJZMkGWYm1soVx89+CH59PJdrRkURuLHf1O84Pw+3L4vPnV/8w65Hx+5Ai+ohEnEnfi10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183522; c=relaxed/simple;
	bh=bvb1vYoHFhqP2VcEmDuAujeIx3RJWVaMILC+JHETH0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YN/5Y7UizgWVYwAD0ztJcj7fOcAt95sMxHrWKNcOy+njXpcR2HiTtBR5EFMUJlI1pD1xNtfwg85c+jKu/+TTqt2NNFObBH32Q2RkviQXg7mnXmzJ1O497Cuenpbm6cT6lhgOjav6wUIA2/eIbnQ+GXcKtYAuJi95qjM+jDIoi6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A4Tk7qT/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A4Tk7qT/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E40FE1F00A3E;
	Mon, 31 Aug 2026 13:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183520;
	bh=xG2t2y2lKLQXDUfdvcxJHobwIOaB1uVKJu1HoXcWyes=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A4Tk7qT/W9BYLhBZAo4JFJUDq9oD4147ZGoZ7tU3TacdSSo3qs6kTsgLTQXh6Xx9x
	 41FTjliOOiS4As+vtRtfoELJgaUmMtvhd4/0hQ+Nf2uVT8NE7u7U6R950fqXzvkz9I
	 ZaDlFJrfzqH3RA3S2uvw7NlhqrpKc+0IOypxS2/gxTgCDqmmY49+MzJe6t2E+E3FEG
	 OPbS3/u14fd1eUQQGxMk47f6+rjQ45KuGXzx+LrPFR3ecAZhvIVj9CE7BeSZO5q4CA
	 xKAyWVn3maNB/3CG3qMozpEX46xnucMr3iHb3gqf+pvR84n8z3PDywRzqZXZ+frN3B
	 5ONnXEit+3mjw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Simon Xue <xxm@rock-chips.com>,
	=?UTF-8?q?Sven=20P=C3=BCschel?= <s.pueschel@pengutronix.de>,
	Heiko Stuebner <heiko@sntech.de>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	joro@8bytes.org,
	will@kernel.org,
	iommu@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org,
	linux-rockchip@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] iommu/rockchip: disable fetch dte time limit
Date: Mon, 31 Aug 2026 09:22:53 -0400
Message-ID: <20260831133314.4125787-145-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Transfer-Encoding: 8bit

From: Simon Xue <xxm@rock-chips.com>

[ Upstream commit 8d4346ecd4950ae08cc76a6de327c264e846758c ]

Disable the Bit 31 of the AUTO_GATING iommu register, as it causes
hangups with the RGA3 (Raster Graphics Acceleration 3) peripheral.
The RGA3 register description of the TRM already states that the bit
must be set to 1. The vendor kernel sets the bit unconditionally to
1 to fix VOP (Video Output Processor) screen black issues. This patch
squashes the 2 vendor kernel commits with the following commit messages:

Master fetch data and cpu update page table may work in parallel, may
have the following procedure:

	master                  cpu
	fetch dte               update page tabl
	        |                       |
	(make dte invalid)  <-  zap iotlb entry
	        |                       |
	fetch dte again
	(make dte invalid)  <-  zap iotlb entry
	        |                       |
	fetch dte again
	(make dte invalid)  <-  zap iotlb entry
	        |                       |
	fetch dte again
	(make iommu block)  <-  zap iotlb entry

New iommu version has the above bug, if fetch dte consecutively four
times, then it will be blocked. Fortunately, we can set bit 31 of
register MMU_AUTO_GATING to 1 to make it work as old version which does
not have this issue.

This issue only appears on RV1126 so far, so make a workaround dedicated
to "rockchip,rv1126" machine type.

iommu/rockchip: fix vop blocked and screen black on RK356X and RK3588

RK3568 and RK3588 has the same issue as RV1126/RV1109 that caused by
dte fetch time limit, So we can set BIT(31) of register 0x24 default
to 1 as a workaround.

Signed-off-by: Simon Xue <xxm@rock-chips.com>
Signed-off-by: Sven Püschel <s.pueschel@pengutronix.de>
Acked-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: PARSE THE SUBJECT LINE
**Record:** `[iommu/rockchip]` `[disable]` — Disable the fetch-DTE time-
limit hardware behavior in the Rockchip IOMMU AUTO_GATING register
(BIT(31)).

### Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
**Record:**
- **Fixes:** — not present (expected for manual review)
- **Reported-by:** — none
- **Tested-by:** — none
- **Reviewed-by:** — none
- **Acked-by:** Heiko Stuebner `<heiko@sntech.de>` (Rockchip maintainer)
- **Link:** — none in commit (submission thread references vendor
  commits and RGA3 driver series)
- **Cc: stable:** — not present (expected)
- **Signed-off-by:** Simon Xue, Sven Püschel, Joerg Roedel (ignore
  pipeline-added SOBs)
- **Notable:** Ack from subsystem maintainer; no syzbot/fuzzer
  involvement

### Step 1.3: ANALYZE THE COMMIT BODY TEXT
**Record:**
- **Bug description:** Newer Rockchip IOMMU hardware has a DTE-fetch
  time limit. When a master re-fetches DTE four times while the CPU
  concurrently zaps IOTLB entries (during page-table updates), the IOMMU
  enters a blocked state.
- **Symptom/failure mode:** IOMMU hang/block → RGA3 peripheral hangups,
  VOP (display) blocked with black screen.
- **Affected hardware:** RV1126/RV1109, RK3568, RK3588 (commit message
  also mentions RK356X broadly).
- **Root cause:** BIT(31) of `RK_MMU_AUTO_GATING` (offset 0x24) defaults
  to 0 on affected silicon; TRM says it must be 1. Vendor kernel sets it
  unconditionally.
- **Version info:** Not tied to a specific kernel version; this is a
  silicon/hardware behavior issue.

### Step 1.4: DETECT HIDDEN BUG FIXES
**Record:** Not disguised — this is an explicit hardware workaround.
Despite "disable" wording in the subject, the fix **sets** BIT(31) to
disable the faulty time-limit feature. This is a classic hardware
quirk/workaround, not a cosmetic cleanup.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: INVENTORY THE CHANGES
**Record:**
- **Files:** `drivers/iommu/rockchip-iommu.c` (+8 lines, 0 removed)
- **Functions modified:** `rk_iommu_enable()` only
- **Scope:** Single-file, surgical fix

### Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
**Record:**
- **Hunk 1 (define):** Adds `#define DISABLE_FETCH_DTE_TIME_LIMIT
  BIT(31)`.
- **Hunk 2 (`rk_iommu_enable`):**
  - **Before:** After writing DTE address, ZAP cache, and IRQ mask,
    proceeds directly to enable paging.
  - **After:** Reads `RK_MMU_AUTO_GATING`, ORs in BIT(31), writes it
    back — for each MMU instance.
  - **Affected path:** IOMMU enable during device attach and
    system/runtime resume.

### Step 2.3: IDENTIFY THE BUG MECHANISM
**Record:**
- **Bug category:** Hardware workaround / logic correctness fix
- **Mechanism:** Without BIT(31)=1, concurrent DTE fetch + IOTLB zap can
  trigger a silicon bug after four consecutive DTE fetches, permanently
  blocking the IOMMU. Setting BIT(31) restores legacy (non-buggy)
  behavior.

### Step 2.4: ASSESS THE FIX QUALITY
**Record:**
- **Quality:** Obviously correct — read-modify-write preserves other
  AUTO_GATING bits; matches vendor kernel and TRM guidance.
- **Regression risk:** Very low. Vendor sets unconditionally on all
  affected platforms; bit is documented as should-be-1.
- **Red flags:** Commit message still mentions RV1126-only workaround,
  but code applies unconditionally (intentional per vendor practice and
  RK3568/RK3588 need).

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: BLAME THE CHANGED LINES
**Record:** `rk_iommu_enable()` core logic dates to 2014 (Daniel Kurtz).
`RK_MMU_AUTO_GATING` defined since original driver (2014,
`c68a292152d32`). The **missing workaround** has been present since the
driver's introduction — not a recent regression.

### Step 3.2: FOLLOW THE FIXES: TAG
**Record:** No `Fixes:` tag. Not applicable — this is a hardware silicon
bug, not a commit-introduced regression.

### Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES
**Record:**
- Recent related fix already in tree: `62e062a29ad51` — "prevent iommus
  dead loop when two masters share one IOMMU" (different bug, has `Cc:
  stable`).
- `rk3568-iommu` v2 support added in `c55356c534aa6` (2021), present in
  this tree.
- This fix is **standalone** — not part of a multi-patch series
  requiring prerequisites.
- On `master`, this commit (`8d4346ecd4950`) is ahead of
  `stable/linux-6.18.y`.

### Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS
**Record:** Simon Xue is an active Rockchip IOMMU contributor (multi-irq
support, dead-loop fix, ISP reset handling). Sven Püschel (Pengutronix)
submitted and tested on RK3588 RGA3.

### Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS
**Record:** No dependencies. Patch applies cleanly (`git apply --check`
succeeded). No new structures, APIs, or helper functions required.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION
**Record:**
- **Lore URL:** https://patch.msgid.link/20251126-spu-
  iommudtefix-v1-1-f90003dbfcc4@pengutronix.de
- **Series revisions:** v1 submitted 2025-11-26; author pinged
  2026-04-28; Heiko Stuebner suggested resend/v2 due to age; committed
  as-is on mainline 2026-06-02.
- **Reviewer feedback:** Shawn Lin (Rockchip) noted TRM offset
  clarification (RGA3-specific offset vs general IOMMU 0x24) — comment-
  only, no code objection.
- **Stable nominations:** None found in thread.
- **NAKs:** None.

### Step 4.2: CHECK WHO REVIEWED THE PATCH
**Record:** CC'd: Joerg Roedel, Will Deacon, Robin Murphy, Heiko
Stuebner, iommu@, linux-arm-kernel@, linux-rockchip@. Heiko Stuebner
Acked-by in final commit.

### Step 4.3: SEARCH FOR THE BUG REPORT
**Record:** Real-world trigger documented by Pengutronix — sporadic RGA3
hangs on RK3588 during driver development. Vendor kernel commits [2][3]
document VOP black-screen issues. No syzbot/bugzilla report.

### Step 4.4: CHECK FOR RELATED PATCHES AND SERIES
**Record:** Related but independent: RGA3 upstream driver series (v5,
2026-04-28) depends on this IOMMU fix. The IOMMU fix stands alone and is
not a "preparation" commit.

### Step 4.5: CHECK STABLE MAILING LIST HISTORY
**Record:** No stable-list discussion found for this specific fix. (Lore
direct fetch blocked by bot protection; analysis via `b4 dig -m` mbox
download.)

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: IDENTIFY KEY FUNCTIONS IN THE DIFF
**Record:** `rk_iommu_enable()` — only function modified.

### Step 5.2: TRACE CALLERS
**Record:**
- `rk_iommu_attach_device()` → `rk_iommu_enable()` (line 1043) — called
  when a device attaches to an IOMMU domain (e.g., VOP, RGA, NPU).
- `rk_iommu_resume()` → `rk_iommu_enable()` (line 1330) — called on PM
  resume.
- Both are common, user-visible paths on Rockchip boards.

### Step 5.3: TRACE CALLEES
**Record:** Uses existing `rk_iommu_read()` / `rk_iommu_write()`
register accessors, plus existing stall/reset/paging enable sequence. No
new dependencies.

### Step 5.4: FOLLOW THE CALL CHAIN
**Record:** Device probe → `iommu_attach_device` →
`rk_iommu_attach_device` → `rk_iommu_enable`. Triggered during normal
graphics/media driver initialization and suspend/resume. **Reachable
from userspace** indirectly via device usage (display, GPU, RGA
workloads causing IOTLB zaps).

### Step 5.5: SEARCH FOR SIMILAR PATTERNS
**Record:** No similar workaround elsewhere in `rockchip-iommu.c`.
Vendor kernel sets this bit unconditionally — external confirmation of
the pattern.

---

## PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE

### Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?
**Record:** **YES.** Local tree is **Linux 6.18.44** (`git describe
HEAD` → `v6.18.44-1-gef4bf62bccf3c`). `rk_iommu_enable()` at lines
928–960 lacks the BIT(31) workaround. `RK_MMU_AUTO_GATING` is defined at
line 42. `DISABLE_FETCH_DTE_TIME_LIMIT` is **not** present. Affected DT
platforms exist: `rv1126.dtsi` (v1 `rockchip,iommu`), `rk356x-base.dtsi`
and `rk3588-base.dtsi` (v2 `rockchip,rk3568-iommu`).

### Step 6.2: CHECK FOR BACKPORT COMPLICATIONS
**Record:** **Clean apply** — `git format-patch` + `git apply --check`
succeeded with no conflicts. No refactoring churn in `rk_iommu_enable()`
since 6.18 branch.

### Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE
**Record:** The dead-loop fix (`62e062a29ad51`) is present. This DTE
time-limit workaround (`8d4346ecd4950`) is **not** present on
`stable/linux-6.18.y`.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY
**Record:** `drivers/iommu/rockchip-iommu.c` — IOMMU driver for Rockchip
SoCs. **IMPORTANT** for ARM/ARM64 embedded (display, media, NPU, ISP).
`CONFIG_ROCKCHIP_IOMMU=y` in `arch/arm64/configs/defconfig`.

### Step 7.2: ASSESS SUBSYSTEM ACTIVITY
**Record:** Actively maintained — recent fixes in 6.17/6.18 merge window
(dead-loop fix, iommu-pages migration). Rockchip platforms (RK3568,
RK3588) are widely deployed.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: DETERMINE WHO IS AFFECTED
**Record:** Users of Rockchip SoCs with IOMMU-enabled peripherals —
**platform-specific** but covering popular boards (RK3568, RK3588,
RV1126). Display (VOP), graphics acceleration (RGA3), and other IOMMU-
backed masters.

### Step 8.2: DETERMINE THE TRIGGER CONDITIONS
**Record:** Concurrent IOMMU master DTE fetch + CPU IOTLB zap during
page-table updates. Realistic during graphics/media workloads and driver
activity. Not every boot, but reproducible under load (Pengutronix
observed sporadic RGA3 hangs).

### Step 8.3: DETERMINE THE FAILURE MODE SEVERITY
**Record:** IOMMU permanent block → **CRITICAL** system hang for
affected peripherals; VOP black screen (display unusable); potential
soft lockup of dependent subsystems.

### Step 8.4: CALCULATE RISK-BENEFIT RATIO
**Record:**
- **Benefit:** HIGH — prevents hardware IOMMU lockup and
  display/peripheral hangs on widely used SoCs.
- **Risk:** VERY LOW — 8-line register write matching vendor kernel and
  TRM; read-modify-write preserves other bits.
- **Ratio:** Strongly favors backport.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: COMPILE THE EVIDENCE

**FOR backporting:**
- Real hardware bug with documented failure mode (IOMMU block, display
  black, RGA3 hang)
- Hardware quirk/workaround — explicitly allowed stable category
- Small (8 lines), surgical, applies cleanly to 6.18.44
- Vendor kernel already does this unconditionally
- TRM documents BIT(31) should be 1
- Acked-by Rockchip maintainer (Heiko Stuebner)
- Affected SoC DT support present in this tree
- Buggy code path exists and has existed since driver introduction
- No prerequisite commits

**AGAINST backporting:**
- No `Cc: stable` or `Fixes:` tag (expected, not disqualifying)
- Applies to all Rockchip IOMMU instances, not SoC-gated (but vendor
  does same; low risk)
- Stale RV1126-only wording in commit message (code is correctly
  unconditional)

**Unresolved:** None that affect the decision.

### Step 9.2: STABLE RULES CHECKLIST
1. Obviously correct and tested? **PASS** — TRM + vendor kernel +
   Pengutronix RK3588 testing
2. Fixes a real bug affecting users? **PASS** — IOMMU hang, black screen
   on production hardware
3. Important issue? **PASS** — CRITICAL (hang, display failure)
4. Small and contained? **PASS** — 8 lines, one function
5. No new features or APIs? **PASS** — register workaround only
6. Can apply to local tree? **PASS** — clean apply verified

### Step 9.3: EXCEPTION CATEGORIES
**Record:** **Hardware quirk/workaround** — qualifies under stable
exception rules.

### Step 9.4: DECISION RATIONALE

For **Linux 6.18.44**, Rockchip IOMMU users on RK3568, RK3588, and
RV1126 platforms are exposed to a silicon bug where the IOMMU can enter
a blocked state during normal page-table maintenance, causing peripheral
hangs and display black screens. The fix is a minimal, vendor-validated
register write that matches TRM documentation. It applies cleanly, has
maintainer ack, and fixes a serious user-visible failure on hardware
well-supported in this tree.

---

## Verification

- [Phase 1] Parsed commit `8d4346ecd4950`: subject, body, tags (Acked-by
  Heiko Stuebner; no Fixes/stable/syzbot)
- [Phase 2] Diff analysis: +8 lines in `rk_iommu_enable()`, adds BIT(31)
  write to `RK_MMU_AUTO_GATING`
- [Phase 3] `git blame`: `rk_iommu_enable()` from 2014;
  `RK_MMU_AUTO_GATING` from original 2014 driver
- [Phase 3] No Fixes: tag to follow
- [Phase 3] Related commit `62e062a29ad51` (different bug) already in
  tree; this fix is not
- [Phase 3] `git format-patch` + `git apply --check`: applies cleanly
- [Phase 3] Commit on `master` but not on current `stable/linux-6.18.y`
  HEAD
- [Phase 4] `b4 dig -c 8d4346ecd4950`: lore thread found
- [Phase 4] `b4 dig -a`: v1 submission 2025-11-26; committed 2026-06-02
- [Phase 4] `b4 dig -w`: Joerg Roedel, Heiko Stuebner, Robin Murphy CC'd
- [Phase 4] Mbox: Pengutronix confirmed RK3588 RGA3 hangs; Shawn Lin
  comment-only TRM note; Heiko suggested resend; no NAKs, no stable
  nomination
- [Phase 5] Callers: `rk_iommu_attach_device()` (line 1043),
  `rk_iommu_resume()` (line 1330)
- [Phase 5] IOTLB zap path: `rk_iommu_zap_iova()` used from map/unmap —
  confirms concurrent zap mechanism
- [Phase 6] `git describe HEAD`: v6.18.44; `make kernelversion`: 6.18.44
- [Phase 6] Buggy code confirmed present: no
  `DISABLE_FETCH_DTE_TIME_LIMIT` in tree
- [Phase 6] DT: `rv1126.dtsi`, `rk356x-base.dtsi`, `rk3588-base.dtsi`
  have IOMMU nodes
- [Phase 6] `rk3568-iommu` support since 2021 (`c55356c534aa6`), in tree
- [Phase 7] `CONFIG_ROCKCHIP_IOMMU=y` in arm64 defconfig
- [Phase 8] Failure mode: IOMMU block → hang/black screen, severity
  CRITICAL

**YES**The background search on `master` found the commit:
**`8d4346ecd4950`** — `iommu/rockchip: disable fetch dte time limit`.

**Summary:** This is an 8-line hardware workaround for Rockchip IOMMU
silicon (RK3568, RK3588, RV1126). Without setting BIT(31) of
`RK_MMU_AUTO_GATING`, the IOMMU can block during concurrent DTE fetch
and IOTLB zaps, causing peripheral hangs and VOP black screens. The
patch applies cleanly to the local **6.18.44** tree, where the buggy
code is still present.

**YES**

 drivers/iommu/rockchip-iommu.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/iommu/rockchip-iommu.c b/drivers/iommu/rockchip-iommu.c
index 0861dd469bd86..2d0dabb0d101a 100644
--- a/drivers/iommu/rockchip-iommu.c
+++ b/drivers/iommu/rockchip-iommu.c
@@ -76,6 +76,8 @@
 #define SPAGE_ORDER 12
 #define SPAGE_SIZE (1 << SPAGE_ORDER)
 
+#define DISABLE_FETCH_DTE_TIME_LIMIT BIT(31)
+
  /*
   * Support mapping any size that fits in one page table:
   *   4 KiB to 4 MiB
@@ -930,6 +932,7 @@ static int rk_iommu_enable(struct rk_iommu *iommu)
 	struct iommu_domain *domain = iommu->domain;
 	struct rk_iommu_domain *rk_domain = to_rk_domain(domain);
 	int ret, i;
+	u32 auto_gate;
 
 	ret = clk_bulk_enable(iommu->num_clocks, iommu->clocks);
 	if (ret)
@@ -948,6 +951,11 @@ static int rk_iommu_enable(struct rk_iommu *iommu)
 			       rk_ops->mk_dtentries(rk_domain->dt_dma));
 		rk_iommu_base_command(iommu->bases[i], RK_MMU_CMD_ZAP_CACHE);
 		rk_iommu_write(iommu->bases[i], RK_MMU_INT_MASK, RK_MMU_IRQ_MASK);
+
+		/* Workaround for iommu blocked, BIT(31) default to 1 */
+		auto_gate = rk_iommu_read(iommu->bases[i], RK_MMU_AUTO_GATING);
+		auto_gate |= DISABLE_FETCH_DTE_TIME_LIMIT;
+		rk_iommu_write(iommu->bases[i], RK_MMU_AUTO_GATING, auto_gate);
 	}
 
 	ret = rk_iommu_enable_paging(iommu);
-- 
2.53.0

