Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 505EA5B79A1;
	Mon, 19 Oct 2026 14:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418448; cv=none; b=s1Xz+FLKILQJNHL0ccu2cfsFn3NsVN7ngdAsJCW+pqbjRgbI9hl6loV4BTMyiBD2poPbioEsruCpaJds8pY7upWnOq28gnSG51CO+rDBOJTbWGR5pGr2xu0ZcuExk6lw4e1kpuN18oYxP+dXBLcNcg6PEFezMqc8lW5ReoPWvzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418448; c=relaxed/simple;
	bh=WxDbETXTCvk7MDK8LMlTz8PpFXUsuAQ8lxlFUWSJNes=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tyVGU5XsqRHHZdhgCiJpRCMSeVkGcgHDg9QPRW8CLiCqy7Pp2WK5bLKktZiKGcKqlLdb08HYz6VjBPZSIAhNcQy95qcbgjoxz3xqwVYFIOi+9TN+4a1gnS554S/klEItbfQQDK4vOHP1aEua9keGgwZ/OHDgVwnfi83NGxBpBJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SkRPM+wV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SkRPM+wV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BFB61F000C4;
	Mon, 19 Oct 2026 14:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418445;
	bh=jEwxnsQF6sHZjugZq/00AG00Xt7EceYd4qsDmz22KOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SkRPM+wVvki+CaYEessUE0RLQnRVLnA1kvQC0H3vr196yfIJk17Vv217irKKt1uGM
	 11OhZbKvuDQoMIITOL19iJdi3GXwyuuKZl4AHMO4duBxLsae65iKOWJRTuceIlEQwM
	 9NjCltvtSfttfxULd/qDxMJG+RJ0FDZ5wi8DN1BUNkbb8R+l1N2pIaoxof05ReGpIm
	 nzXKEjYKyOs0EjrVjjguwZFaT05PxL4rghAeZINFYHHYVDkdzK8bL4SfUyI+pp6ogd
	 JTN154p5T7OtPJG1ehiHRuWDS0iDLlj3ursSyMSy+whGuKyEC4Tu0eDG5gYv8LvXcd
	 P5yuK32kshVug==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Nicolin Chen <nicolinc@nvidia.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	thierry.reding@kernel.org,
	joro@8bytes.org,
	jonathanh@nvidia.com,
	linux-tegra@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	iommu@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.12] iommu/tegra241-cmdqv: Rate-limit the error ISR's log message
Date: Mon, 19 Oct 2026 09:49:05 -0400
Message-ID: <20261019135441.1420968-254-sashal@kernel.org>
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

From: Nicolin Chen <nicolinc@nvidia.com>

[ Upstream commit a86c36163c9722545d27e92bdad8418fdcaa8b1d ]

tegra241_cmdqv_isr() logs the error-map registers on every error interrupt.
A malfunctioning device, or a guest deliberately faulting its own VCMDQs,
can raise these interrupts rapidly, and the unconditional dev_warn() then
floods the kernel log.

Rate-limit the message with dev_warn_ratelimited(), and pass the error-map
registers straight to it so their four MMIO reads run only when the limiter
prints, instead of building the string on every interrupt.

Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The local checkout is **v7.3-rc4**. The driver and the unconditional ISR
`dev_warn()` are present here; the change is a small, self-contained
log-flood / guest-DoS mitigation, so it belongs in this tree.

===============================================================
PHASE 1: COMMIT MESSAGE FORENSICS
===============================================================

**Step 1.1: PARSE THE SUBJECT LINE**
Record: **[iommu/tegra241-cmdqv] [Rate-limit] [stop the error ISR from
printing on every interrupt]**

**Step 1.2: PARSE ALL COMMIT MESSAGE TAGS**
Record:
- **Fixes:** none (expected)
- **Reported-by:** none
- **Tested-by:** none
- **Reviewed-by / Acked-by:** none on the commit itself
- **Link:** none
- **Cc: stable:** none on this patch
- **Assisted-by:** Claude:claude-opus-4-8
- **Signed-off-by:** Nicolin Chen (NVIDIA; author), Will Deacon (arm-
  smmu maintainer; applied it)
- Pipeline markers such as Sasha Levin SOB / “[Upstream commit]” were
  not on the real commit (`a86c36163c972`)

Notable: no user/syzbot report. The cover letter says the series came
from **Sashiko** (LLM) review, not a production crash.

**Step 1.3: ANALYZE THE COMMIT BODY TEXT**
Record:
- **Bug:** `tegra241_cmdqv_isr()` logs error-map registers with
  unconditional `dev_warn()` on every error interrupt.
- **Symptom:** kernel log flood.
- **Trigger (stated):** malfunctioning device, or a **guest deliberately
  faulting its own VCMDQs**, raising interrupts rapidly.
- **Root cause:** every interrupt builds a 256-byte string (including
  four extra MMIO reads) and prints it.
- **Fix:** `dev_warn_ratelimited()`, and pass the MMIO reads as printk
  args so they run only when the limiter actually prints.
- **Version info:** none in the message.

**Step 1.4: DETECT HIDDEN BUG FIXES**
Record: Not a disguised cleanup. It is an explicit flood/DoS mitigation.
It does not fix a UAF, leak, or crash by itself.

===============================================================
PHASE 2: DIFF ANALYSIS - LINE BY LINE
===============================================================

**Step 2.1: INVENTORY THE CHANGES**
Record:
- File: `drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c` (+7 / −9)
- Function: `tegra241_cmdqv_isr()`
- Scope: **single-file surgical** (one logging site)

**Step 2.2: UNDERSTAND THE CODE FLOW CHANGE**
Record:
- **Before:** ISR always `snprintf()`s into `char err_str[256]`, always
  does four `CMDQ_ERR_MAP` MMIO reads, always `dev_warn()`.
- **After:** no stack buffer; `dev_warn_ratelimited(...)` with the four
  `readl_relaxed()` calls as arguments.
- Path: **error interrupt path** (threaded IRQ). Error *handling* after
  the log is unchanged.

Verified `dev_level_ratelimited()` in `include/linux/dev_printk.h`: the
`__VA_ARGS__` are only substituted inside `if (__ratelimit(&_rs))`, so
those MMIO reads run only when a line is printed.

**Step 2.3: IDENTIFY THE BUG MECHANISM**
Record:
- **Category:** ISR log flood / availability (guest-triggered printk
  storm), plus extra MMIO on every interrupt.
- **Not:** UAF, leak, deadlock, OOB, or NULL deref.
- **Hardware workaround?** No.

**Step 2.4: ASSESS THE FIX QUALITY**
Record:
- Obviously correct: standard `*_ratelimited` pattern already used in
  other IOMMU fault paths (`arm-smmu-v3.c`, `virtio-iommu.c`, AMD/Intel,
  etc.).
- Minimal; no unrelated edits.
- Regression risk: **very low**. Worst case is fewer error-map dumps in
  dmesg (intended). Error recovery is untouched.
- Red flags: LLM-assisted; no `Fixes:`/`Reported-by`. Not a new API.

===============================================================
PHASE 3: GIT HISTORY INVESTIGATION
===============================================================

**Step 3.1: BLAME THE CHANGED LINES**
Record:
- Unconditional `dev_warn()` + `snprintf` were in the original driver:
  `918eb5c856f6` (“Add in-kernel support for NVIDIA Tegra241 (Grace)
  CMDQV”), **2024-08-30**, first in **v6.12-rc1**.
- This tree is **v7.3-rc4**, so that code is in this lineage.

**Step 3.2: FOLLOW THE FIXES: TAG**
Record: No `Fixes:` tag. N/A. The logging has been there since the
driver was added.

**Step 3.3: CHECK FILE HISTORY FOR RELATED CHANGES**
Record: This is **v2 11/11** of “Fix error-interrupt races and VINTF
lifecycle bugs” (Nicolin Chen, 2026-07-14). Cover letter: ordered
**most-critical-first**; this is the last, smallest issue (“ISR flooding
the kernel log under repeated guest errors”).
Standalone: it only changes the log line and does **not** need the
earlier UAF/lifecycle patches to be correct.

**Step 3.4: CHECK THE AUTHOR'S OTHER COMMITS**
Record: Nicolin Chen is the NVIDIA CMDQV contributor for this file; Will
Deacon applied the series. Same-day siblings are real
lifecycle/UAF/bounds fixes. This one is the leftover logging hardening.

**Step 3.5: CHECK FOR DEPENDENT/PREREQUISITE COMMITS**
Record: None required. `dev_warn_ratelimited` is old. The hunk applies
to the original ISR as well as the post-series ISR.

===============================================================
PHASE 4: MAILING LIST AND EXTERNAL RESEARCH
===============================================================

**Step 4.1: FIND THE ORIGINAL PATCH DISCUSSION**
Record:
- `b4 dig -c a86c36163c972` → https://patch.msgid.link/2e9d088c059037d5f
  c23532820444720b870d2c7.1784059577.git.nicolinc@nvidia.com
- **v1** (2026-07-02) and **v2** (2026-07-14); committed version is **v2
  11/11**.
- No NAK on this patch. Review noise in the thread was about **patch
  10/11** (dropped); Will applied 01–09 and 11.
- No reviewer asked for `Cc: stable` on *this* patch. Patch 07/11 in the
  same series did have `Cc: stable` (unrelated vSID check).
- WebFetch to lore returned **403**; thread was read from the b4 mbox
  instead.

**Step 4.2: CHECK WHO REVIEWED THE PATCH**
Record (`b4 dig -w`): Nicolin Chen, Will Deacon, Robin Murphy, Joerg
Roedel, Jason Gunthorpe; lists `iommu@`, `linux-arm-kernel`, `linux-
tegra`. Maintainer **Will Deacon applied it** (“Applied (apart from
patch 10)”).

**Step 4.3: SEARCH FOR THE BUG REPORT**
Record: No syzbot/bugzilla link. Origin is **Sashiko** static review,
described in the cover letter. Nicolin also noted Sashiko false
positives (including a wrong “level-triggered / kdump storm” claim);
CMDQV is **edge-triggered**, so an *unacked* pending error does not re-
assert. **Each new error still fires the ISR**, which is the remaining
flood path this patch addresses.

**Step 4.4: CHECK FOR RELATED PATCHES AND SERIES**
Record: 11-patch series; this patch is independent logging. Not blocked
on the dropped 10/11.

**Step 4.5: CHECK STABLE MAILING LIST HISTORY**
Record: **UNVERIFIED** via lore.kernel.org/stable (HTTP 403). The
submitted 11/11 message itself has no `Cc: stable`.

===============================================================
PHASE 5: CODE SEMANTIC ANALYSIS
===============================================================

semcode MCP: **not available**. Used `git grep` / file reads.

**Step 5.1: IDENTIFY KEY FUNCTIONS**
Record: `tegra241_cmdqv_isr()` only.

**Step 5.2: TRACE CALLERS**
Record: Registered in `__tegra241_cmdqv_probe()` via
`request_threaded_irq(..., tegra241_cmdqv_isr, IRQF_ONESHOT, ...)`. Not
a hardirq; still a hot error path. Hardware: NVIDIA Tegra241 (Grace)
CMDQ-V (`CONFIG_TEGRA241_CMDQV`).

**Step 5.3: TRACE CALLEES**
Record: `readl_relaxed` of VINTF/CMDQ error maps;
`dev_warn_ratelimited`; then `tegra241_vintf0_handle_error` /
`tegra241_vintf_user_handle_error`. Those handlers are unchanged.

**Step 5.4: FOLLOW THE CALL CHAIN**
Record: Reachable when CMDQV is enabled (Grace SMMU). A guest with a
user VINTF/VCMDQ can generate command-queue errors; each new error
latches and interrupts. That is a userspace/VM-reachable path, not a
theoretical internal-only site.

**Step 5.5: SEARCH FOR SIMILAR PATTERNS**
Record: Rate-limited IOMMU fault logs are the normal pattern elsewhere.
This driver was the outlier with a raw `dev_warn()` in the ISR.

===============================================================
PHASE 6: CROSS-REFERENCING AGAINST THE LOCAL TREE
===============================================================

**Step 6.1: DOES THE BUGGY CODE EXIST IN THIS TREE?**
Record:
- `git describe HEAD` → **v7.3-rc4-27-gf0100363d8c37**
- `make kernelversion` → **7.3.0-rc4**
- Driver file exists; original ISR logging from `918eb5c856f6` (v6.12).
- `git merge-base --is-ancestor a86c36163c972 HEAD` → **yes** (already
  merged here). That is not used as “already selected for stable”; it
  only confirms this lineage has the driver and the fix.

**Step 6.2: CHECK FOR BACKPORT COMPLICATIONS**
Record: **Clean apply** on this tree (already applied). The hunk does
not depend on later ISR locking. On a tree that still has the original
`snprintf`/`dev_warn` ISR, it would apply with at most trivial context.

**Step 6.3: CHECK IF RELATED FIXES ARE ALREADY HERE**
Record: No earlier equivalent rate-limit. `a2ee315db4261` only uses
`WARN_ON_ONCE` for out-of-bounds map bits; it does not throttle the
“unexpected error reported” line.

===============================================================
PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT
===============================================================

**Step 7.1: IDENTIFY THE SUBSYSTEM AND ITS CRITICALITY**
Record: **drivers/iommu/arm/arm-smmu-v3** (NVIDIA Grace CMDQ-V).
**PERIPHERAL/IMPORTANT for that platform**: only `CONFIG_TEGRA241_CMDQV`
/ Tegra241 (Grace) systems, including virtualization hosts using user
VINTFs.

**Step 7.2: ASSESS SUBSYSTEM ACTIVITY**
Record: Actively developed in 2026 (large Sashiko fix series + iommufd
work). Logging bug itself is old (v6.12).

===============================================================
PHASE 8: IMPACT AND RISK ASSESSMENT
===============================================================

**Step 8.1: DETERMINE WHO IS AFFECTED**
Record: **platform-specific / config-specific** — NVIDIA Grace +
`CONFIG_TEGRA241_CMDQV`. Hosts that expose guest VCMDQs are the
interesting population.

**Step 8.2: DETERMINE THE TRIGGER CONDITIONS**
Record: CMDQV error IRQ. Commonness: rare on healthy HW; can be
**frequent** if a device malfunctions or a **guest injects VCMDQ
errors**. Unprivileged guest with VCMDQ access can trigger it. Not every
boot.

**Step 8.3: DETERMINE THE FAILURE MODE SEVERITY**
Record:
- Direct effect: dmesg/console flood; extra MMIO + `snprintf` on every
  interrupt.
- Indirect: printk/console contention, lost messages, possible stalls on
  a slow console.
- Not an oops, UAF, or data corruption.
- **Severity: MEDIUM** (availability / “oh, that’s not good”), with a
  stated guest DoS path.

**Step 8.4: CALCULATE RISK-BENEFIT RATIO**
Record:
- **Benefit:** medium for Grace virtualization hosts; low for everyone
  else.
- **Risk:** very low (7 lines, logging only).
- **Ratio:** favorable. Official stable rules allow “oh, that’s not
  good” and require an exploit explanation for “could be a problem”
  issues; the message gives that explanation.

===============================================================
PHASE 9: FINAL SYNTHESIS
===============================================================

**Step 9.1: COMPILE THE EVIDENCE**

FOR:
- Real, described flood: guest or bad device can fire the error IRQ
  repeatedly; each new error still interrupts (edge-triggered, latched
  per event).
- Tiny, obviously correct, matches other IOMMU drivers.
- Error handling unchanged; MMIO for the log runs only when printing.
- Driver and buggy logging exist in **this** 7.3-rc4 tree (since v6.12).
- Applied by the arm-smmu maintainer; no NAK on this patch.
- Official rules: not a trivia cleanup; exploit path is written down.

AGAINST:
- No production `Reported-by`; LLM-found.
- Least-critical patch in its series (11/11).
- Threaded IRQ (`IRQF_ONESHOT`), so not a hardirq printk.
- Unacked-guest *storm* was already ruled out as a false positive; this
  only limits *new*-error spam.
- Not a crash/corruption/UAF.

UNRESOLVED:
- Could not query lore.kernel.org/stable (403).
- No Tested-by.

**Step 9.2: APPLY THE STABLE RULES CHECKLIST**
1. Obviously correct and tested? **PASS** — standard ratelimit;
   maintainer applied. No extra tester tag.
2. Fixes a real bug that affects users? **PASS** — log flood / guest-
   driven interrupt spam on Grace CMDQV; users of that hardware exist.
3. Important issue? **PASS** (low end) — not oops/corruption; it is an
   explained availability issue (“oh, that’s not good” / guest printk
   DoS), which the documented rules allow.
4. Small and contained? **PASS** — ~16 lines, one function.
5. No new features or APIs? **PASS**.
6. Can apply to the local tree? **PASS** — pre-image exists here; apply
   is clean.

**Step 9.3: CHECK FOR EXCEPTION CATEGORIES**
Record: None (not a device ID, quirk table, DT, build, or docs fix).
Qualifies as a normal small bugfix, not via an exception.

**Step 9.4: MAKE YOUR DECISION**
This tree contains the Tegra241 CMDQV driver and the original
unconditional ISR `dev_warn()`. The patch is a 7-line, obviously correct
rate-limit that closes a guest-reachable log flood without touching
recovery logic. Benefit is limited to Grace CMDQV, but risk is
negligible, so it meets the bar for this tree.

What it solves for users here: a VM or failing CMDQ can spam the host
log and extra MMIO on every error IRQ. That is not a panic, but it is a
real host-side availability nuisance on this platform.

Verification:
- [Phase 1] Tags: Assisted-by Claude; SOB Nicolin Chen + Will Deacon; no
  Fixes/Reported-by/Cc: stable on this commit
- [Phase 2] Diff: `tegra241_cmdqv_isr()` snprintf+dev_warn →
  dev_warn_ratelimited; +7/−9
- [Phase 2] Confirmed `dev_level_ratelimited` only evaluates args when
  `__ratelimit()` allows print
- [Phase 3] `git blame` / original file: logging from `918eb5c856f6`
  (v6.12-rc1)
- [Phase 3] `git describe --contains 918eb5c856f6` →
  v6.12-rc1~149^2^2~19
- [Phase 3] Series: v2 11/11; parent is VINTF0 leak fix, not a
  functional prereq
- [Phase 4] `b4 dig -c a86c36163c972`: lore/patch.msgid.link match; v1
  then v2
- [Phase 4] `b4 dig -a`: v1 2026-07-02, v2 2026-07-14 (applied)
- [Phase 4] `b4 dig -w`: iommu maintainers on To/Cc; Will applied 11/11,
  dropped 10/11
- [Phase 4] mbox: cover letter lists log flood; no comments/NAK on
  11/11; Cc: stable only on 07/11
- [Phase 4] WebFetch lore/stable: 403; stable-list search UNVERIFIED
- [Phase 5] Caller: `request_threaded_irq` in `__tegra241_cmdqv_probe`;
  CONFIG_TEGRA241_CMDQV
- [Phase 6] `git describe HEAD` → v7.3-rc4-27-gf0100363d8c37; `make
  kernelversion` → 7.3.0-rc4
- [Phase 6] `git merge-base --is-ancestor a86c36163c972 HEAD` → ancestor
  (code exists here)
- [Phase 8] Failure mode: printk flood / guest DoS, severity MEDIUM
- UNVERIFIED: lore.kernel.org/stable discussion (HTTP 403)

**YES**

 drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c b/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c
index fdbd487848e64..8c9530873ed98 100644
--- a/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c
+++ b/drivers/iommu/arm/arm-smmu-v3/tegra241-cmdqv.c
@@ -350,21 +350,19 @@ static irqreturn_t tegra241_cmdqv_isr(int irq, void *devid)
 {
 	struct tegra241_cmdqv *cmdqv = (struct tegra241_cmdqv *)devid;
 	void __iomem *reg_vintf_map = REG_CMDQV(cmdqv, VINTF_ERR_MAP);
-	char err_str[256];
 	u64 vintf_map;
 
 	/* Use readl_relaxed() as register addresses are not 64-bit aligned */
 	vintf_map = (u64)readl_relaxed(reg_vintf_map + 0x4) << 32 |
 		    (u64)readl_relaxed(reg_vintf_map);
 
-	snprintf(err_str, sizeof(err_str),
-		 "vintf_map: %016llx, vcmdq_map %08x:%08x:%08x:%08x", vintf_map,
-		 readl_relaxed(REG_CMDQV(cmdqv, CMDQ_ERR_MAP(3))),
-		 readl_relaxed(REG_CMDQV(cmdqv, CMDQ_ERR_MAP(2))),
-		 readl_relaxed(REG_CMDQV(cmdqv, CMDQ_ERR_MAP(1))),
-		 readl_relaxed(REG_CMDQV(cmdqv, CMDQ_ERR_MAP(0))));
-
-	dev_warn(cmdqv->dev, "unexpected error reported. %s\n", err_str);
+	dev_warn_ratelimited(
+		cmdqv->dev,
+		"unexpected error reported. vintf_map: %016llx, vcmdq_map %08x:%08x:%08x:%08x\n",
+		vintf_map, readl_relaxed(REG_CMDQV(cmdqv, CMDQ_ERR_MAP(3))),
+		readl_relaxed(REG_CMDQV(cmdqv, CMDQ_ERR_MAP(2))),
+		readl_relaxed(REG_CMDQV(cmdqv, CMDQ_ERR_MAP(1))),
+		readl_relaxed(REG_CMDQV(cmdqv, CMDQ_ERR_MAP(0))));
 
 	/* Handle VINTF0 and its LVCMDQs */
 	if (vintf_map & BIT_ULL(0)) {
-- 
2.53.0

