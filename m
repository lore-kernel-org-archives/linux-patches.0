Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B54313D9DCD;
	Tue, 14 Apr 2026 11:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776165915; cv=none; b=NcOWKT1TcmvqHAuuptQ5qC6CU811FNFwMeqvsRMS6l8ij4AAlq1YG7w83k5ksNPIjG7bParvYpNH9PjFWtWNIozdTp0DISmszCLxY8Bajrf/n+Pb5yl9E7un2Kx+sOnrPY8PCwReazEPDtCKtSwfFaGMSElJ8VjKy7lGpuP3Q9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776165915; c=relaxed/simple;
	bh=NoYrBg1ZRQqVciZb5ygqUsK3dsUjEu3DQbClFVmIsq0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rdslNC64WpMJ9L9XH4uV+TpAM3e2abtueDvy26SC3O1kEaIcCa6auxqLkodphmXEGaNjhs+yLKQsrK3R8LeRIiHnR1jyFZ3VnnaVGR1pUx/npjJdhm+JNv94onq4SZ75aa6rO2BIFW3klSlJremoQHPJVD2/qcUFiQV27hcQzr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h4fmXoo4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h4fmXoo4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8458C2BCB6;
	Tue, 14 Apr 2026 11:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776165915;
	bh=NoYrBg1ZRQqVciZb5ygqUsK3dsUjEu3DQbClFVmIsq0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h4fmXoo4yqLacLgw2WC4WNRvl4x4F2ctleWd81f6T6amNBhOQJO59H5mFzg9pzQ3Z
	 lO/UjiVcd2ZzqEl3H8KMvchK3RfrAvAnlIIQFueEWy2UH2LOeYbrvw7i2q3FCJGsIC
	 8juYmwY6OKSHgw6W6jrhIHVRMBPaJakddZi2v4EEWrZbKH0QeXgyufKTXQzfhTo+CF
	 KYV+fskTomPeeGjzmL3mcWBc8bgbXuc+dN23EAJk9WX8b+p2grwBeLigxWEQ4HK3VK
	 me1xTXPNx4OXoP/yWiF2paOshqqhT8EbnjjKwOeSz54Iw9Kgzzx2ZKJyXdebxiY/xX
	 1dmI9tYQLN9FA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: John Pavlick <jspavlick@posteo.net>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Marcin Nita <marcin.nita@leolabs.pl>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux@armlinux.org.uk,
	andrew@lunn.ch,
	hkallweit1@gmail.com,
	davem@davemloft.net,
	edumazet@google.com,
	pabeni@redhat.com,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.12] net: sfp: add quirks for Hisense and HSGQ GPON ONT SFP modules
Date: Tue, 14 Apr 2026 07:24:59 -0400
Message-ID: <20260414112509.410217-3-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260414112509.410217-1-sashal@kernel.org>
References: <20260414112509.410217-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.12
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: John Pavlick <jspavlick@posteo.net>

[ Upstream commit 95aca8602ef70ffd3d971675751c81826e124f90 ]

Several GPON ONT SFP sticks based on Realtek RTL960x report
1000BASE-LX at 1300MBd in their EEPROM but can operate at 2500base-X.
On hosts capable of 2500base-X (e.g. Banana Pi R3 / MT7986), the
kernel negotiates only 1G because it trusts the incorrect EEPROM data.

Add quirks for:
- Hisense-Leox LXT-010S-H
- Hisense ZNID-GPON-2311NA
- HSGQ HSGQ-XPON-Stick

Each quirk advertises 2500base-X and ignores TX_FAULT during the
module's ~40s Linux boot time.

Tested on Banana Pi R3 (MT7986) with OpenWrt 25.12.1, confirmed
2.5Gbps link and full throughput with flow offloading.

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Suggested-by: Marcin Nita <marcin.nita@leolabs.pl>
Signed-off-by: John Pavlick <jspavlick@posteo.net>
Link: https://patch.msgid.link/20260406132321.72563-1-jspavlick@posteo.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed. Let me compile my full analysis.

---

## Complete Analysis

### PHASE 1: COMMIT MESSAGE FORENSICS

**Step 1.1: Subject Line**
- Subsystem: `net: sfp:`
- Action verb: "add" (quirks)
- Summary: Adding hardware quirks for Hisense and HSGQ GPON ONT SFP
  modules
- Record: [net: sfp] [add] [hardware quirks for GPON ONT SFP modules
  with incorrect EEPROM data]

**Step 1.2: Tags**
- Reviewed-by: Russell King (Oracle) — the SFP subsystem maintainer
- Suggested-by: Marcin Nita — suggested investigating sfp.c quirks as a
  solution
- Signed-off-by: John Pavlick (author)
- Link:
  https://patch.msgid.link/20260406132321.72563-1-jspavlick@posteo.net
- Signed-off-by: Jakub Kicinski (netdev maintainer, applied the patch)
- No Cc: stable (expected — that's why we're reviewing)
- No Fixes: tag (expected — this is a quirk addition, not a code fix)
- Record: Notable: Russell King, the SFP subsystem maintainer/author,
  reviewed this. Strong quality signal.

**Step 1.3: Commit Body**
- Bug: GPON ONT SFP sticks report 1000BASE-LX / 1300MBd in EEPROM but
  actually support 2500base-X
- Symptom: Kernel negotiates only 1G because it trusts incorrect EEPROM
  data
- Affected hardware: Hisense-Leox LXT-010S-H, Hisense ZNID-GPON-2311NA,
  HSGQ HSGQ-XPON-Stick
- All based on Realtek RTL960x chipset
- Tested: Banana Pi R3 (MT7986) with OpenWrt 25.12.1, confirmed 2.5Gbps
  link
- TX_FAULT quirk needed during module's ~40s Linux boot time
- Record: Real-world hardware problem limiting link speed. Users get 1G
  instead of 2.5G.

**Step 1.4: Hidden Bug Fix Detection**
- This is not a "hidden" bug fix — it is an explicit hardware quirk
  addition to work around incorrect EEPROM data. This falls squarely
  into the "QUIRKS and WORKAROUNDS" exception category for stable.

### PHASE 2: DIFF ANALYSIS

**Step 2.1: Inventory**
- Files changed: 1 (`drivers/net/phy/sfp.c`)
- Lines added: 16 (including comments)
- Lines removed: 0
- Functions modified: None — only the `sfp_quirks[]` static const array
  is extended
- Scope: Single-file, table-only addition
- Record: Extremely contained — 3 new entries in a quirk table, with
  explanatory comments.

**Step 2.2: Code Flow Change**
- Before: These three SFP modules (Hisense-Leox LXT-010S-H, Hisense
  ZNID-GPON-2311NA, HSGQ HSGQ-XPON-Stick) have no quirk entries, so the
  kernel reads their EEPROM data literally and negotiates 1G
- After: These modules are matched by vendor/part strings and:
  1. `sfp_quirk_2500basex` enables 2500base-X mode advertisement
  2. `sfp_fixup_ignore_tx_fault` ignores the TX_FAULT signal during boot

**Step 2.3: Bug Mechanism**
- Category: Hardware workaround (h)
- The modules have incorrect EEPROM data (report 1000BASE-LX but support
  2500base-X)
- The quirks use the exact same pattern as many existing entries (e.g.,
  HUAWEI MA5671A, FS GPON-ONU-34-20BI)
- Record: Hardware quirk — identical pattern to existing accepted
  entries.

**Step 2.4: Fix Quality**
- Obviously correct: Uses exact same macro and functions as ~10 other
  existing entries
- Minimal/surgical: Only adds data to a static table; no logic changes
- Regression risk: Zero for users without these modules (quirks matched
  by vendor/part string)
- For users WITH these modules: enables 2.5G link (improvement) and
  ignores TX_FAULT during boot
- Record: Highest possible confidence — data-only addition using
  established infrastructure.

### PHASE 3: GIT HISTORY INVESTIGATION

**Step 3.1: Blame**
- The `sfp_quirks[]` table was introduced by Russell King in commit
  23571c7b9643 (2022-09-13)
- The `sfp_quirk_2500basex` function and `sfp_fixup_ignore_tx_fault`
  function have existed since at least v6.1
- Record: Infrastructure is mature and present in all active stable
  trees.

**Step 3.2: Fixes Tag**
- No Fixes: tag (expected for quirk additions). N/A.

**Step 3.3: File History**
- SFP quirk additions are extremely frequent — ~17 quirk-related commits
  since v6.6
- This is a well-established pattern in the kernel community
- Record: Standalone commit, no dependencies on other patches.

**Step 3.4: Author**
- John Pavlick is a community contributor (not subsystem maintainer)
- But the patch was reviewed by Russell King (SFP subsystem
  author/maintainer) and applied by Jakub Kicinski (netdev maintainer)
- Record: Properly reviewed by the right maintainers.

**Step 3.5: Dependencies**
- The patch uses `SFP_QUIRK()` macro, `sfp_quirk_2500basex`, and
  `sfp_fixup_ignore_tx_fault`
- All three exist in v6.1, v6.6, and v6.12 stable trees (verified)
- Record: No dependencies. Completely self-contained.

### PHASE 4: MAILING LIST RESEARCH

**Step 4.1: Original Patch Discussion**
- Found via lore: v3 of the patch, submitted 2026-04-06
- v1→v2: Added Suggested-by tag
- v2→v3: Fixed inaccurate commit message about MT7986 SerDes
  capabilities
- Applied by Jakub Kicinski to netdev/net.git (main) as commit
  95aca8602ef7
- Record: Clean submission history, no objections.

**Step 4.2: Reviewers**
- Russell King (Oracle) — SFP subsystem maintainer — Reviewed-by
- Applied by Jakub Kicinski — netdev maintainer
- Record: Reviewed by the right people.

**Step 4.3-4.5: Bug Reports / Related / Stable Discussion**
- No formal bug report — this is a hardware enablement quirk
- The underlying problem is that these GPON SFP sticks' EEPROM
  incorrectly reports capabilities
- No stable-specific discussion found; no prior nomination

### PHASE 5: CODE SEMANTIC ANALYSIS

**Step 5.1-5.4: Functions**
- No functions are modified. Only static data (the `sfp_quirks[]` array)
  is extended.
- The quirk matching happens in `sfp_lookup_quirk()` which iterates the
  table and matches vendor/part strings
- The matched `sfp_quirk_2500basex` and `sfp_fixup_ignore_tx_fault`
  functions are called during SFP module insertion
- Record: No code flow changes — purely data-driven matching.

**Step 5.5: Similar Patterns**
- Exact same pattern used by:
  - HUAWEI MA5671A (sfp_quirk_2500basex + sfp_fixup_ignore_tx_fault)
  - FS GPON-ONU-34-20BI (sfp_quirk_2500basex +
    sfp_fixup_ignore_tx_fault)
  - ALCATELLUCENT G010SP (sfp_quirk_2500basex +
    sfp_fixup_ignore_tx_fault)
- Record: Identical pattern to multiple existing accepted entries.

### PHASE 6: STABLE TREE ANALYSIS

**Step 6.1: Code Existence in Stable**
- `sfp_quirk_2500basex` exists in v6.1, v6.6, v6.12 (verified)
- `sfp_fixup_ignore_tx_fault` exists in v6.1, v6.6, v6.12 (verified)
- `SFP_QUIRK()` 4-argument macro exists in all stable trees (verified)
- Record: All needed infrastructure exists in all active stable trees.

**Step 6.2: Backport Complications**
- Minor context difference: In mainline, HUAWEI MA5671A uses
  `sfp_fixup_ignore_tx_fault_and_los` (changed by commit 9f9c31bacaae),
  while in v6.6 and v6.12 it still uses `sfp_fixup_ignore_tx_fault`.
  This affects the context lines around the insertion point.
- The Lantech entries also differ (SFP_QUIRK_S vs SFP_QUIRK_M,
  additional 8330-265D entry)
- This means the patch will need minor context adjustment (fuzz or
  manual resolution) for older trees
- Record: Expected minor context conflicts, trivially resolvable.

**Step 6.3: Related Fixes Already in Stable**
- No — these specific modules (Hisense-Leox, Hisense ZNID, HSGQ) have no
  existing quirks in any tree.

### PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

**Step 7.1: Subsystem Criticality**
- Subsystem: net/phy (SFP transceiver support)
- Criticality: IMPORTANT — SFP modules are used in many networking
  setups, particularly in GPON/fiber deployments and embedded/router
  platforms (OpenWrt, etc.)
- Record: [net/phy/sfp] [IMPORTANT]

**Step 7.2: Subsystem Activity**
- Very active — 31 changes since v6.6, including many quirk additions
- SFP quirk additions to stable are a well-established practice
- Record: Actively maintained, frequent quirk additions.

### PHASE 8: IMPACT AND RISK ASSESSMENT

**Step 8.1: Affected Users**
- Users of Hisense-Leox LXT-010S-H, Hisense ZNID-GPON-2311NA, and HSGQ
  HSGQ-XPON-Stick SFP modules
- These are GPON ONT SFP sticks commonly used in fiber-to-the-home
  setups and by OpenWrt users
- Record: Driver-specific, but affects a real user population in the
  fiber networking community.

**Step 8.2: Trigger Conditions**
- Every time these SFP modules are inserted into a host capable of
  2500base-X
- 100% reproducible — the EEPROM always reports wrong data
- Record: Deterministic, always triggers, no race or timing dependency.

**Step 8.3: Failure Mode**
- Without quirk: Link operates at 1G instead of 2.5G — loss of 60%
  bandwidth
- This is a functional issue, not a crash or security issue
- Severity: MEDIUM (hardware not working at full capability)
- Record: Performance/capability limitation, not crash or corruption.

**Step 8.4: Risk-Benefit**
- BENEFIT: HIGH — enables proper 2.5G operation for these GPON SFP
  modules
- RISK: VERY LOW — data-only addition, zero impact on users without
  these specific modules, uses well-tested infrastructure
- Record: Very favorable risk-benefit ratio.

### PHASE 9: FINAL SYNTHESIS

**Step 9.1: Evidence Summary**

FOR backporting:
- Falls squarely into the "SFP/NETWORK QUIRKS" exception category
  (explicitly called out as YES for stable)
- 16 lines added, zero lines removed — purely additive data
- Uses exact same pattern as many existing entries already in stable
  trees
- All required infrastructure (macros, functions) exists in all active
  stable trees
- Reviewed by Russell King (SFP subsystem maintainer)
- Applied by Jakub Kicinski (netdev maintainer)
- Tested on real hardware with confirmed results
- Zero regression risk for unaffected users
- Fixes real hardware limitation for GPON fiber users

AGAINST backporting:
- Not a crash/security/corruption fix — it's hardware enablement
- Minor context conflicts needed for older stable trees
- No explicit Cc: stable nomination (but this is expected per our
  guidelines)

**Step 9.2: Stable Rules Checklist**
1. Obviously correct and tested? YES — data-only addition, reviewed by
   subsystem maintainer, tested on hardware
2. Fixes a real bug? YES — SFP modules operate at wrong speed due to
   incorrect EEPROM
3. Important issue? MEDIUM — hardware not operating at full capability
4. Small and contained? YES — 16 lines in one file, data-only
5. No new features or APIs? CORRECT — no new features, just device quirk
   entries
6. Can apply to stable? YES — with minor context adjustment

**Step 9.3: Exception Categories**
This is a **hardware quirk/workaround** — one of the explicitly listed
exception categories that is "YES for stable" even though it technically
"adds code." SFP quirks are specifically called out in the analysis
guidelines.

**Step 9.4: Decision**
This is a textbook SFP quirk addition. The guidelines explicitly state:
"SFP_QUIRK_* for optical modules with broken behavior... These are all
YES for stable." The patch is minimal, uses existing infrastructure
available in all stable trees, is reviewed by the subsystem maintainer,
was tested on real hardware, and carries essentially zero regression
risk.

### Verification

- [Phase 1] Parsed tags: Reviewed-by Russell King (SFP maintainer),
  Signed-off-by Jakub Kicinski (netdev maintainer), Suggested-by Marcin
  Nita, Link to lore
- [Phase 2] Diff analysis: 16 lines added (3 SFP_QUIRK entries +
  comments) to static const sfp_quirks[] array, zero lines removed,
  single file
- [Phase 3] git blame: sfp_quirks[] table introduced by Russell King in
  23571c7b9643 (2022-09-13), infrastructure present since v6.1
- [Phase 3] Verified sfp_quirk_2500basex exists in v6.1 (line 355), v6.6
  (line 399), v6.12 (line 424)
- [Phase 3] Verified sfp_fixup_ignore_tx_fault exists in v6.1 (line
  325), v6.6 (line 348), v6.12 (line 358)
- [Phase 3] Verified SFP_QUIRK() 4-argument macro exists in v6.1, v6.6,
  v6.12
- [Phase 3] No dependencies — standalone commit confirmed
- [Phase 4] Lore thread found: v3 submission, applied to netdev/net, no
  NAKs or concerns
- [Phase 4] b4 dig found original submission; Russell King CC'd and
  provided Reviewed-by
- [Phase 4] Patch went through v1→v2→v3, applied version is v3 (latest)
- [Phase 5] No function modifications — only static data table extended
- [Phase 6] Minor context conflict expected: HUAWEI MA5671A entry uses
  sfp_fixup_ignore_tx_fault in v6.6/v6.12 but
  sfp_fixup_ignore_tx_fault_and_los in mainline; Lantech entries differ
  (SFP_QUIRK_M vs SFP_QUIRK_S)
- [Phase 6] Confirmed all needed infrastructure exists in all active
  stable trees
- [Phase 7] SFP subsystem is actively maintained with frequent quirk
  additions
- [Phase 8] Zero regression risk for unaffected users; deterministic
  2.5G enablement for affected hardware

**YES**

 drivers/net/phy/sfp.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 7a85b758fb1e6..c62e3f364ea73 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -543,6 +543,22 @@ static const struct sfp_quirk sfp_quirks[] = {
 	SFP_QUIRK("HUAWEI", "MA5671A", sfp_quirk_2500basex,
 		  sfp_fixup_ignore_tx_fault_and_los),
 
+	// Hisense LXT-010S-H is a GPON ONT SFP (sold as LEOX LXT-010S-H) that
+	// can operate at 2500base-X, but reports 1000BASE-LX / 1300MBd in its
+	// EEPROM
+	SFP_QUIRK("Hisense-Leox", "LXT-010S-H", sfp_quirk_2500basex,
+		  sfp_fixup_ignore_tx_fault),
+
+	// Hisense ZNID-GPON-2311NA can operate at 2500base-X, but reports
+	// 1000BASE-LX / 1300MBd in its EEPROM
+	SFP_QUIRK("Hisense", "ZNID-GPON-2311NA", sfp_quirk_2500basex,
+		  sfp_fixup_ignore_tx_fault),
+
+	// HSGQ HSGQ-XPON-Stick can operate at 2500base-X, but reports
+	// 1000BASE-LX / 1300MBd in its EEPROM
+	SFP_QUIRK("HSGQ", "HSGQ-XPON-Stick", sfp_quirk_2500basex,
+		  sfp_fixup_ignore_tx_fault),
+
 	// Lantech 8330-262D-E and 8330-265D can operate at 2500base-X, but
 	// incorrectly report 2500MBd NRZ in their EEPROM.
 	// Some 8330-265D modules have inverted LOS, while all of them report
-- 
2.53.0

