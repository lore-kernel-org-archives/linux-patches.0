Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 793BC3B19A0;
	Mon, 20 Apr 2026 13:16:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691000; cv=none; b=gXqi2Hh8nFmzUcsL/7pdlHHAxlzv0GMGe8F/2PH+3+Bfzc980H3KPWd5oNPOr1itWslSk7FjhMx3uzKLNhoqoh3r/CuJlhmxq3nOhFFNQtpWSajhgkTL75/cYAVr9ivEtTyqtjfKHldVhLIMkFnGmaLBcg+0sAjX5LR4tVOBDYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691000; c=relaxed/simple;
	bh=sLlPteD7lQfoTv9dBR+y8MY+DTQXae9AAcAO6Liy7pM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oFpI6eV0gURKQqERg+vyv1DtvM9p0H8OqqeToFm6jbzqoaPbPgUx8AzdZbHJcBJEWHkk9aQfiOHlsc3qRmllDP706UDwb0EcuIop4I0aGgHChl72puZqSUtEEy5LItzYsfbY94jMyAmxUTVBWn1kt2Ij+yn3AB5k0GNMqH5+6I8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uL/ZFLdr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uL/ZFLdr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F666C2BCB7;
	Mon, 20 Apr 2026 13:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691000;
	bh=sLlPteD7lQfoTv9dBR+y8MY+DTQXae9AAcAO6Liy7pM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uL/ZFLdrFDsfRc52cvS4/vmu8/uUgKta+/DwqT2AiFT3trzpPthFQ+H0Xywb37AxO
	 sZiGu5Cjvqi6UTJAX6GqRzwckTESb9DCa2c17hFg7+4XbVGKEmyr7My9HyKRytN8xt
	 lwiR6aiNMhRvO272TOb6vXDjaltQZrFbS00XgWwHDczOS4s69Z/Fc157taZeewIGn8
	 UC72BrlVo2xxtVCcFJef8sZs6QIfVppOm5Nvym32Lw5hiDGjRGPN3WZ+Bcy6zc2dC2
	 gH4Pq3+vc13uTLm8claMFOFxCZIvaKgps6tYoitlFj6GTN7jQ46tr6AwXxycQmCLXS
	 uTAJ2HCLQrFtw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Vidya Sagar <vidyas@nvidia.com>,
	Manikanta Maddireddy <mmaddireddy@nvidia.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Jon Hunter <jonathanh@nvidia.com>,
	Sasha Levin <sashal@kernel.org>,
	lpieralisi@kernel.org,
	kwilczynski@kernel.org,
	thierry.reding@kernel.org,
	linux-pci@vger.kernel.org,
	linux-tegra@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 7.0-5.10] PCI: tegra194: Assert CLKREQ# explicitly by default
Date: Mon, 20 Apr 2026 09:08:21 -0400
Message-ID: <20260420131539.986432-35-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420131539.986432-1-sashal@kernel.org>
References: <20260420131539.986432-1-sashal@kernel.org>
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

From: Vidya Sagar <vidyas@nvidia.com>

[ Upstream commit 01d36261ae331583e6bc2034e6aa75c101b83e1d ]

The Root Port's CLKREQ# signal is shared with a downstream PCIe switch and
the endpoints behind it. By default, APPL_PINMUX_CLKREQ_OVERRIDE only
overrides the CLKREQ# input to the controller (so REFCLK is enabled
internally); it does not drive the CLKREQ# output pin low. Some PCIe
switches (e.g. Broadcom PCIe Gen4) forward the Root Port's CLKREQ# to their
downstream side and expect it to be driven low for REFCLK, even when the
switch does not support CLK-PM or ASPM-L1SS. Without driving the output
pin low, link-up can fail between the switch and endpoints.

Clear APPL_PINMUX_CLKREQ_DEFAULT_VALUE so the CLKREQ# output pad is
explicitly driven low. That makes the shared CLKREQ# line low on the wire
and avoids link-up issues with such switches.

Signed-off-by: Vidya Sagar <vidyas@nvidia.com>
Signed-off-by: Manikanta Maddireddy <mmaddireddy@nvidia.com>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Jon Hunter <jonathanh@nvidia.com>
Reviewed-by: Vidya Sagar <vidyas@nvidia.com>
Reviewed-by: Jon Hunter <jonathanh@nvidia.com>
Link: https://patch.msgid.link/20260324191000.1095768-2-mmaddireddy@nvidia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed. Let me compile the full analysis.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: PARSE THE SUBJECT LINE
Record: [PCI: tegra194] [Assert (fix/enable)] [CLKREQ# output pin driven
low by default to fix PCIe link-up failures with certain switches]

### Step 1.2: PARSE ALL COMMIT MESSAGE TAGS
- **Signed-off-by**: Vidya Sagar (original driver author), Manikanta
  Maddireddy (author), Manivannan Sadhasivam (PCI maintainer), Bjorn
  Helgaas (PCI global maintainer)
- **Tested-by**: Jon Hunter (NVIDIA kernel lead for Tegra)
- **Reviewed-by**: Vidya Sagar (original driver author), Jon Hunter
- **Link**: `https://patch.msgid.link/20260324191000.1095768-2-
  mmaddireddy@nvidia.com` (patch 2 in series)
- No Fixes: tag (expected)
- No Cc: stable (expected)

Record: Strong review chain - original driver author, NVIDIA Tegra
kernel lead, and PCI subsystem maintainers all signed off/reviewed.

### Step 1.3: ANALYZE THE COMMIT BODY TEXT
The commit explains that `APPL_PINMUX_CLKREQ_OVERRIDE` only overrides
the CLKREQ# *input* to the controller (enabling REFCLK internally), but
does NOT drive the CLKREQ# *output* pin low. Some PCIe switches (e.g.,
Broadcom PCIe Gen4) forward the Root Port's CLKREQ# to their downstream
side. Without driving the output low, **link-up can fail** between the
switch and endpoints.

Record: Bug = PCIe link-up failure. Symptom = endpoints behind PCIe
switches don't enumerate. Root cause = CLKREQ# output pad not driven low
when it should be.

### Step 1.4: DETECT HIDDEN BUG FIXES
Record: This IS a bug fix - it fixes a real hardware link-up failure.
The language "assert... explicitly" and "avoids link-up issues"
describes fixing broken behavior.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: INVENTORY THE CHANGES
- **File**: `drivers/pci/controller/dwc/pcie-tegra194.c` (+2 lines)
- **Change 1**: Add `#define APPL_PINMUX_CLKREQ_DEFAULT_VALUE BIT(13)`
  in the register bit definitions
- **Change 2**: Add `val &= ~APPL_PINMUX_CLKREQ_DEFAULT_VALUE;` inside
  `tegra_pcie_config_controller()` in the `!supports_clkreq` block

Record: Single file, 2 lines added. Functions modified:
`tegra_pcie_config_controller()`. Scope: single-file surgical fix.

### Step 2.2: UNDERSTAND THE CODE FLOW CHANGE
- **Before**: When `!supports_clkreq`, the code enabled CLKREQ# override
  (bit 2) and cleared CLKREQ# override value (bit 3) - this overrides
  the CLKREQ# *input* but left the *output pad default value* (bit 13)
  unchanged (high by default)
- **After**: Additionally clears bit 13, which explicitly drives the
  CLKREQ# output pad low on the wire

Record: Before = REFCLK internally enabled but output pad floats high.
After = REFCLK internally enabled AND output pad driven low.

### Step 2.3: IDENTIFY THE BUG MECHANISM
Record: Category (h) Hardware workaround. The hardware register has a
default-high bit for the CLKREQ# output pad that wasn't being cleared,
causing PCIe link-up failures with switches that forward CLKREQ#.

### Step 2.4: ASSESS THE FIX QUALITY
- Obviously correct: just clearing one more register bit in a register
  already being configured
- Minimal/surgical: 2 lines total
- Regression risk: extremely low - only affects Tegra platforms in the
  `!supports_clkreq` path, only clears an additional bit that logically
  should be cleared
Record: Fix quality = excellent. Regression risk = negligible.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: BLAME THE CHANGED LINES
The `!supports_clkreq` code block was introduced in commit
`56e15a238d9278` ("PCI: tegra: Add Tegra194 PCIe support", 2019-08-13,
v5.4) and modified by `ff5c2bb9c6f5ee` ("PCI: tegra: Fix CLKREQ
dependency programming", 2019-10-05, also v5.4).

Record: Buggy code has been present since v5.4, when the driver was
introduced. The code exists in all stable trees since v5.4.

### Step 3.2: FOLLOW THE FIXES TAG
No Fixes: tag present. This is expected for candidate review.

### Step 3.3: CHECK FILE HISTORY
The file has many commits since v5.4 but the `!supports_clkreq` block
hasn't changed since ff5c2bb9c6f5ee.

Record: No prerequisites for this specific code block. The patch is
standalone.

### Step 3.4: CHECK THE AUTHOR
Manikanta Maddireddy is an NVIDIA engineer working on Tegra PCI. Vidya
Sagar (original driver author) reviewed the patch. Jon Hunter (NVIDIA
Tegra kernel lead) tested and reviewed it.

Record: Author is an NVIDIA Tegra PCI engineer. Original driver author
and NVIDIA kernel team lead both reviewed/tested.

### Step 3.5: CHECK FOR DEPENDENCIES
The patch is patch 2 of a series (from the message ID). However, the fix
is completely self-contained:
1. The new `#define` doesn't depend on anything new
2. The bit-clear operation is added to an existing code block
3. No other functions or data structures are modified

One concern: the diff context shows `DW_PCIE_VER_500A` /
`DW_PCIE_VER_562A` macros, but the v7.0 tree uses raw hex values
`0x490A` / `0x562A`. This means the commit was built on top of a tree
with a version macro rename. However, this only affects context lines in
the header area — the actual code change applies to a completely
different part of the function.

Record: Self-contained fix. Minor context mismatch in header defines
area, but actual functional change applies cleanly.

---

## PHASE 4: MAILING LIST AND EXTERNAL RESEARCH

### Step 4.1-4.5: MAILING LIST INVESTIGATION
Lore.kernel.org was behind an anti-scraping challenge and could not be
accessed. However:
- b4 dig found the original CLKREQ fix (ff5c2bb9c6f5ee) was part of a
  series
- The commit was accepted through the PCI maintainer tree (Manivannan
  Sadhasivam -> Bjorn Helgaas)
- The strong review chain (Tested-by, Reviewed-by from original author
  and NVIDIA kernel lead) provides high confidence

Record: Could not access lore directly. Review chain provides strong
confidence.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1-5.4: FUNCTION AND CALLER ANALYSIS
`tegra_pcie_config_controller()` is called from:
1. `tegra_pcie_init_controller()` (line 1526) — during initial
   probe/boot
2. `tegra_pcie_dw_resume_noirq()` (line 2346) — during resume from
   suspend

Both are critical paths. The fix affects both initial boot and resume,
meaning without the fix, PCIe link-up can fail both at boot and after
suspend/resume.

The `!supports_clkreq` condition is determined by the `supports-clkreq`
DT property (line 1138-1139). Systems without this property will hit the
bug.

Record: Critical paths affected (boot and resume). Impact depends on DT
configuration.

---

## PHASE 6: CROSS-REFERENCING AND STABLE TREE ANALYSIS

### Step 6.1: DOES THE BUGGY CODE EXIST IN STABLE TREES?
Yes. The driver was introduced in v5.4, and the specific code block has
been unchanged since ff5c2bb9c6f5ee (also v5.4). All active stable trees
(5.4.y through 6.12.y and 7.0.y) contain the buggy code.

### Step 6.2: BACKPORT COMPLICATIONS
Minor context difference in the header define area (version macros
changed upstream). The actual functional change in
`tegra_pcie_config_controller()` applies cleanly to all stable trees
since the `!supports_clkreq` block hasn't changed since v5.4.

Record: Minor context adjustment needed for defines area. Functional
code change applies cleanly.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: SUBSYSTEM CRITICALITY
PCI controller driver for NVIDIA Tegra194/234 SoCs. Platform: ARM64
Tegra (Jetson, automotive, embedded).

Record: Subsystem = PCI controller (drivers/pci/controller/dwc).
Criticality = IMPORTANT (affects Tegra platform users, including Jetson
dev boards and automotive systems).

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: WHO IS AFFECTED
Users of Tegra194/234 PCIe root ports with downstream PCIe switches that
forward CLKREQ# (e.g., Broadcom PCIe Gen4 switches), on systems without
the `supports-clkreq` DT property.

### Step 8.2: TRIGGER CONDITIONS
- Triggered on every boot and resume when the hardware configuration
  matches
- Deterministic (not a race)

### Step 8.3: FAILURE MODE SEVERITY
PCIe link-up failure = devices behind the switch don't enumerate =
hardware doesn't work.
Severity: HIGH (complete loss of PCIe functionality behind the affected
switch)

### Step 8.4: RISK-BENEFIT RATIO
- **Benefit**: HIGH — fixes complete PCIe link failure for affected
  configurations
- **Risk**: VERY LOW — 2 lines, clears one register bit, only affects
  `!supports_clkreq` path on Tegra platforms
- **Ratio**: Strongly favorable for backporting

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: EVIDENCE COMPILATION

**FOR backporting:**
- Fixes real hardware link-up failures on Tegra platforms
- Extremely small and surgical (2 lines)
- Obviously correct (clearing a register bit to match intended behavior)
- Strong review chain: original driver author, NVIDIA kernel team lead,
  PCI maintainers
- Tested by Jon Hunter
- Falls into "hardware workaround" exception category
- Code has been present since v5.4 — affects all stable trees
- Affects boot AND resume paths

**AGAINST backporting:**
- No crash/security/data corruption — "just" link-up failure
- Minor context difference in header area requires fuzz/adjustment for
  backport
- Part of a multi-patch series (patch 2/N) — though self-contained

### Step 9.2: STABLE RULES CHECKLIST
1. Obviously correct and tested? **YES** — Tested-by and Reviewed-by,
   trivial change
2. Fixes a real bug? **YES** — PCIe link-up failure
3. Important issue? **YES** — complete PCIe failure for affected
   configurations
4. Small and contained? **YES** — 2 lines in 1 file
5. No new features or APIs? **YES** — no new features
6. Can apply to stable trees? **YES** — minor context adjustment may be
   needed

### Step 9.3: EXCEPTION CATEGORIES
This falls into the **hardware quirk/workaround** category (explicitly
allowed for stable).

---

## Verification

- [Phase 1] Parsed tags: Tested-by Jon Hunter, Reviewed-by Vidya Sagar +
  Jon Hunter, SOBs from PCI maintainers
- [Phase 2] Diff analysis: 2 lines added — 1 new #define + 1 register
  bit clear in `tegra_pcie_config_controller()`
- [Phase 3] git blame: buggy code block from ff5c2bb9c6f5ee (v5.4),
  present in all stable trees
- [Phase 3] git show ff5c2bb9c6f5ee: confirmed this was "PCI: tegra: Fix
  CLKREQ dependency programming" — an earlier incomplete fix
- [Phase 3] git show 56e15a238d9278: confirmed original driver added in
  v5.4
- [Phase 4] b4 dig found the earlier CLKREQ fix series at lore;
  lore.kernel.org blocked by anti-scraping
- [Phase 5] `tegra_pcie_config_controller()` called from
  `tegra_pcie_init_controller()` (probe) and
  `tegra_pcie_dw_resume_noirq()` (resume)
- [Phase 5] `supports_clkreq` determined from DT property "supports-
  clkreq" (line 1138-1139)
- [Phase 6] Code exists in all stable trees since v5.4; context mismatch
  only in header defines area
- [Phase 8] Failure mode: complete PCIe link-up failure, severity HIGH
- UNVERIFIED: Could not access lore.kernel.org to verify mailing list
  discussion or whether patch 1 of the series has any relevance

The fix is a small, surgical hardware workaround that fixes real PCIe
link-up failures on Tegra platforms. It meets all stable kernel criteria
and falls into the hardware workaround exception category.

**YES**

 drivers/pci/controller/dwc/pcie-tegra194.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pci/controller/dwc/pcie-tegra194.c b/drivers/pci/controller/dwc/pcie-tegra194.c
index 06571d806ab31..8ac9863fcc7ad 100644
--- a/drivers/pci/controller/dwc/pcie-tegra194.c
+++ b/drivers/pci/controller/dwc/pcie-tegra194.c
@@ -44,6 +44,7 @@
 #define APPL_PINMUX_CLKREQ_OVERRIDE		BIT(3)
 #define APPL_PINMUX_CLK_OUTPUT_IN_OVERRIDE_EN	BIT(4)
 #define APPL_PINMUX_CLK_OUTPUT_IN_OVERRIDE	BIT(5)
+#define APPL_PINMUX_CLKREQ_DEFAULT_VALUE	BIT(13)
 
 #define APPL_CTRL				0x4
 #define APPL_CTRL_SYS_PRE_DET_STATE		BIT(6)
@@ -1454,6 +1455,7 @@ static int tegra_pcie_config_controller(struct tegra_pcie_dw *pcie,
 		val = appl_readl(pcie, APPL_PINMUX);
 		val |= APPL_PINMUX_CLKREQ_OVERRIDE_EN;
 		val &= ~APPL_PINMUX_CLKREQ_OVERRIDE;
+		val &= ~APPL_PINMUX_CLKREQ_DEFAULT_VALUE;
 		appl_writel(pcie, val, APPL_PINMUX);
 	}
 
-- 
2.53.0

