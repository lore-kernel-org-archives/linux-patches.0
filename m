Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF98D3DD504;
	Tue, 14 Apr 2026 11:25:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776165920; cv=none; b=ORaEOoREfrAGHcBbeDq5+Iy6woxRgnsH+gvyfIK2moCQLlggudxSo7yW/AOtQcP2OedQ+aHWA9RQCjWUta5o89OpCsG7d6ecl4FbXTmdvwvrth9GmprWjCKrpxnN4B0N4zGwxbBXMc3ckep5YKX2jaTNS57Ox5u3y0ed0CFue2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776165920; c=relaxed/simple;
	bh=Q2bGSSMUSvOsc8sm87W9y7wyqqS161Kk8NfSpYS2EtY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a3Osk1OFIv3H+7DQYnGBrm7tZolGIrCbtggzveuL/DpyFwZr65UDH8W/1R0ZvbLw9Y6BC1jkV5UakzUUG0UJHlrdJn0UcNWVPkX15xQAZJtZXjegwc7jeRALXWFwq6mhKSFdOxl0gP2jznJR31dFe4YGLOnrGC3Me6TSnOv7rVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=q75vpvOl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="q75vpvOl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3EE8C2BCB6;
	Tue, 14 Apr 2026 11:25:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776165920;
	bh=Q2bGSSMUSvOsc8sm87W9y7wyqqS161Kk8NfSpYS2EtY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q75vpvOlzUAsmZ2f9IDGz0aTzVEOr8HWSao2WqCsiVu18DPVrwMKM7z+p4R3tIoif
	 dLe2jHtUKUep1S52UVwTupVHS7jSb8Z8vkEZ2cflNmBJ1sioOgYaJ1o9+JvxhSoEUP
	 e4u21mQn6gn4dG03EaIiNApgWnUNpDD8nNfKExgjyGw3Y+7n3ZLZ7G+6MSQ/Dp/hI3
	 tnyfo1Glz8lp5DNAz492DwxcfUXr90ahfAwFUhnup50c5ZmYjEFz7QPCkne0nJav1S
	 gyEcT+0l9oPleS4Rmrx/7zqRqawQQ3mmQXFgFBCRLozhfchJIkCxnOtue61XAjiOET
	 +i5nVLTFktUwQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Arthur Husband <artmoty@gmail.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-ide@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-5.10] ata: ahci: force 32-bit DMA for JMicron JMB582/JMB585
Date: Tue, 14 Apr 2026 07:25:03 -0400
Message-ID: <20260414112509.410217-7-sashal@kernel.org>
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

From: Arthur Husband <artmoty@gmail.com>

[ Upstream commit 105c42566a550e2d05fc14f763216a8765ee5d0e ]

The JMicron JMB585 (and JMB582) SATA controllers advertise 64-bit DMA
support via the S64A bit in the AHCI CAP register, but their 64-bit DMA
implementation is defective. Under sustained I/O, DMA transfers targeting
addresses above 4GB silently corrupt data -- writes land at incorrect
memory addresses with no errors logged.

The failure pattern is similar to the ASMedia ASM1061
(commit 20730e9b2778 ("ahci: add 43-bit DMA address quirk for ASMedia
ASM1061 controllers")), which also falsely advertised full 64-bit DMA
support. However, the JMB585 requires a stricter 32-bit DMA mask rather
than 43-bit, as corruption occurs with any address above 4GB.

On the Minisforum N5 Pro specifically, the combination of the JMB585's
broken 64-bit DMA with the AMD Family 1Ah (Strix Point) IOMMU causes
silent data corruption that is only detectable via checksumming
filesystems (BTRFS/ZFS scrub). The corruption occurs when 32-bit IOVA
space is exhausted and the kernel transparently switches to 64-bit DMA
addresses.

Add device-specific PCI ID entries for the JMB582 (0x0582) and JMB585
(0x0585) before the generic JMicron class match, using a new board type
that combines AHCI_HFLAG_IGN_IRQ_IF_ERR (preserving existing behavior)
with AHCI_HFLAG_32BIT_ONLY to force 32-bit DMA masks.

Signed-off-by: Arthur Husband <artmoty@gmail.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed. Let me compile the full analysis.

---

## PHASE 1: COMMIT MESSAGE FORENSICS

### Step 1.1: Subject Line
- **Subsystem**: `ata: ahci:` (AHCI SATA controller driver)
- **Action verb**: "force" — explicitly restricting a capability to work
  around broken hardware
- **Summary**: Force 32-bit DMA for JMicron JMB582/JMB585 controllers
  because their 64-bit DMA is broken

Record: [ata: ahci] [force] [Add hardware quirk to force 32-bit DMA for
JMicron JMB582/JMB585 due to broken 64-bit DMA causing silent data
corruption]

### Step 1.2: Tags
- **Signed-off-by**: Arthur Husband `<artmoty@gmail.com>` —
  author/contributor
- **Reviewed-by**: Damien Le Moal `<dlemoal@kernel.org>` — AHCI
  subsystem co-maintainer
- **Signed-off-by**: Niklas Cassel `<cassel@kernel.org>` — AHCI
  subsystem maintainer (committer)
- No Fixes: tag (expected for this type of hardware quirk — there's no
  single commit that introduced the bug; the hardware itself is broken)
- No Cc: stable (expected, this is why we're reviewing it)
- No Reported-by (the author discovered and fixed it themselves)

Record: Reviewed by subsystem co-maintainer (Damien Le Moal), committed
by subsystem maintainer (Niklas Cassel). Strong trust signals.

### Step 1.3: Commit Body Analysis
- **Bug**: JMB582/JMB585 controllers advertise 64-bit DMA support (S64A
  bit in AHCI CAP register) but it is defective
- **Symptom**: Under sustained I/O, DMA transfers above 4GB **silently
  corrupt data** — writes land at incorrect memory addresses with NO
  errors logged
- **Comparison**: Similar to ASMedia ASM1061 (commit 20730e9b2778), but
  JMB585 needs stricter 32-bit mask (not 43-bit)
- **Real-world trigger**: On Minisforum N5 Pro with AMD Family 1Ah
  (Strix Point) IOMMU, corruption occurs when 32-bit IOVA space is
  exhausted and kernel switches to 64-bit DMA addresses
- **Detection**: Only detectable via checksumming filesystems (BTRFS/ZFS
  scrub)
- **Failure mode**: **SILENT DATA CORRUPTION** — the most severe
  category

Record: Silent data corruption with no error logging. Only detectable by
checksumming filesystems. Triggered when kernel exhausts 32-bit IOVA
space. Severity: CRITICAL.

### Step 1.4: Hidden Bug Fix Detection
This is not a hidden fix — it's an explicit hardware workaround for a
broken controller. It falls squarely in the "hardware quirk" exception
category.

Record: Explicit hardware quirk/workaround. Not disguised.

---

## PHASE 2: DIFF ANALYSIS

### Step 2.1: Inventory
- **Files changed**: 1 file (`drivers/ata/ahci.c`)
- **Changes**:
  1. Add `board_ahci_jmb585` to `enum board_ids` (+1 line)
  2. Add `board_ahci_jmb585` port_info entry (+9 lines)
  3. Add two PCI ID entries for JMB582 (0x0582) and JMB585 (0x0585) (+3
     lines including comment)
- **Total**: ~13 lines added, 0 removed
- **Scope**: Single-file, surgical hardware quirk addition

Record: [drivers/ata/ahci.c: +13 lines] [Functions modified: none — only
static data arrays] [Scope: single-file, data-only addition]

### Step 2.2: Code Flow Change
- **Enum addition**: Adds a new board ID `board_ahci_jmb585` in
  alphabetical order among chipset-specific IDs
- **Port info entry**: Defines `board_ahci_jmb585` combining
  `AHCI_HFLAG_IGN_IRQ_IF_ERR` (preserving existing behavior from generic
  JMicron match) with `AHCI_HFLAG_32BIT_ONLY` (the new fix)
- **PCI ID table**: Adds device-specific matches for 0x0582 and 0x0585
  **before** the generic JMicron class match so they take priority

Record: Before: JMB582/JMB585 matched the generic JMicron class entry
(board_ahci_ign_iferr), allowing 64-bit DMA. After: They match specific
PCI IDs with board_ahci_jmb585, which forces 32-bit DMA.

### Step 2.3: Bug Mechanism
Category: **Hardware workaround** (h)
- The hardware has broken 64-bit DMA that causes silent data corruption
- The fix adds `AHCI_HFLAG_32BIT_ONLY` which is handled in
  `libahci.c:482` to clear `HOST_CAP_64`, which then causes
  `ahci_configure_dma_masks()` to set 32-bit DMA mask

Record: Hardware DMA implementation defect. Fix uses well-established
AHCI_HFLAG_32BIT_ONLY mechanism already used by ATI SB600 and
ahci_sunxi.

### Step 2.4: Fix Quality
- **Obviously correct**: Yes. Uses well-established flag infrastructure
  that has existed since early kernels
- **Minimal/surgical**: Yes. Only data-table additions, no code logic
  changes
- **Regression risk**: Extremely low. Only affects JMB582/JMB585
  devices. The only behavior change is limiting DMA to 32-bit, which is
  strictly safer. Preserves existing IGN_IRQ_IF_ERR behavior.
- **Red flags**: None

Record: Fix is obviously correct, minimal, and uses proven
infrastructure. Zero regression risk for non-JMicron hardware.

---

## PHASE 3: GIT HISTORY INVESTIGATION

### Step 3.1: Blame
The generic JMicron class match entry has existed since very early
kernels (the JMicron support commits go back to 2006-era). The
`AHCI_HFLAG_32BIT_ONLY` flag and `board_ahci_sb600` have also existed
since the v2.6.x era. All infrastructure needed is present in every
active stable tree.

Record: All required infrastructure (AHCI_HFLAG_32BIT_ONLY, generic
JMicron match, board_ids enum) exists in all stable trees.

### Step 3.2: Fixes Tag
No Fixes: tag present (expected — this is a hardware defect, not a
software regression).

Record: N/A — hardware bug, not introduced by any specific commit.

### Step 3.3: File History
Recent changes to `drivers/ata/ahci.c` are mostly LPM quirks, PCS
quirks, and other device-specific additions. The ASMedia 43-bit DMA
quirk (commit 20730e9b27787) is a very similar precedent for the same
type of fix.

Record: Standalone fix, no prerequisites needed. Similar to ASMedia DMA
quirk already in stable.

### Step 3.4: Author
Arthur Husband appears to be a first-time contributor (no other commits
found). However, the patch was reviewed by Damien Le Moal (co-
maintainer) and committed by Niklas Cassel (maintainer) — the top two
committers to the ata subsystem.

Record: New contributor, but reviewed and committed by both ata
subsystem maintainers.

### Step 3.5: Dependencies
No dependencies. The commit only uses existing flags
(`AHCI_HFLAG_IGN_IRQ_IF_ERR`, `AHCI_HFLAG_32BIT_ONLY`) and existing
infrastructure (PCI ID table, board_ids enum, port_info array). These
all exist in every active stable tree.

Record: Fully standalone. No dependencies.

---

## PHASE 4: MAILING LIST RESEARCH

### Step 4.1-4.4: Lore Search
Lore.kernel.org blocked automated access (Anubis challenge). However,
the commit itself contains sufficient information:
- The commit was reviewed by Damien Le Moal (subsystem co-maintainer)
- It was accepted and committed by Niklas Cassel (subsystem maintainer)
- The technical description is detailed and includes specific hardware,
  symptoms, and comparison to prior similar fix

Record: Could not access lore.kernel.org due to access restrictions.
Relying on commit metadata which shows maintainer review and acceptance.

---

## PHASE 5: CODE SEMANTIC ANALYSIS

### Step 5.1: Functions Modified
No functions were modified. Only static data structures were changed:
1. `enum board_ids` — added entry
2. `ahci_port_info[]` — added entry
3. `ahci_pci_tbl[]` — added two PCI ID entries

### Step 5.2-5.4: Call Chain
The data structures affect:
- `ahci_init_one()` — PCI probe function, reads `ahci_pci_tbl` to match
  devices and uses `ahci_port_info` to configure the host
- `ahci_save_initial_config()` in libahci.c:482 — checks
  `AHCI_HFLAG_32BIT_ONLY` and clears `HOST_CAP_64`
- `ahci_configure_dma_masks()` in ahci.c:1069 — reads `hpriv->cap` which
  no longer has `HOST_CAP_64`, sets 32-bit DMA mask

Record: Well-understood, tested code path. AHCI_HFLAG_32BIT_ONLY has
been used by ATI SB600 and ahci_sunxi for years.

### Step 5.5: Similar Patterns
- ATI SB600 (`board_ahci_sb600`) — uses `AHCI_HFLAG_32BIT_ONLY` for the
  same reason
- ASMedia ASM1061/1062 (`board_ahci_43bit_dma`) — uses
  `AHCI_HFLAG_43BIT_ONLY` for a related DMA address limitation
- `ahci_sunxi.c` — also uses `AHCI_HFLAG_32BIT_ONLY`

Record: Three existing precedents for this exact pattern of DMA address
quirking.

---

## PHASE 6: STABLE TREE ANALYSIS

### Step 6.1: Buggy Code in Stable
The "buggy code" is the generic JMicron class match that doesn't include
`AHCI_HFLAG_32BIT_ONLY`. This has been present since the JMicron support
was first added (v2.6.x era). The bug exists in ALL active stable trees.

Record: Bug exists in all active stable trees (5.4.y, 5.10.y, 5.15.y,
6.1.y, 6.6.y, 6.12.y).

### Step 6.2: Backport Complications
The patch should apply cleanly or with minimal context adjustments. The
only concern is whether `board_ahci_jmb585` enum placement might have
different surrounding entries in older trees. But since it's just adding
a new enum value and corresponding data, any conflicts would be
trivially resolvable.

Record: Expected to apply cleanly or with trivial context adjustments.

### Step 6.3: Related Fixes in Stable
No related JMB582/JMB585 DMA fixes found in git history.

Record: No prior fix for this issue.

---

## PHASE 7: SUBSYSTEM AND MAINTAINER CONTEXT

### Step 7.1: Subsystem Criticality
- **Subsystem**: drivers/ata (SATA storage controllers)
- **Criticality**: IMPORTANT — SATA controllers are core to data
  storage. This driver handles disk I/O for millions of systems.
- JMB582/JMB585 are popular consumer SATA controllers found in many PCIe
  add-in cards and mini-PCs

Record: [drivers/ata - SATA storage] [Criticality: IMPORTANT - data
integrity]

### Step 7.2: Subsystem Activity
Active subsystem with regular commits from two maintainers (Niklas
Cassel and Damien Le Moal). 69 commits since v5.15.

Record: Active, well-maintained subsystem.

---

## PHASE 8: IMPACT AND RISK ASSESSMENT

### Step 8.1: Who Is Affected
Users of JMicron JMB582 and JMB585 SATA controllers on systems with more
than 4GB RAM where 32-bit IOVA space can be exhausted. These are popular
consumer PCIe SATA controller cards. The JMB585 in particular is one of
the most common PCIe-to-SATA bridge chips available.

Record: Driver-specific, but affects a popular controller used in many
add-in SATA cards and embedded systems.

### Step 8.2: Trigger Conditions
- System must have >4GB RAM (extremely common)
- Sustained I/O that exhausts 32-bit IOVA space (common under heavy
  workloads)
- Uses AMD IOMMU (but the hardware bug exists regardless — AMD IOMMU
  just makes the IOVA exhaustion trigger more visible)
- Any unprivileged user doing significant disk I/O could trigger it

Record: Common trigger conditions under normal workloads. Any user with
sufficient RAM doing sustained I/O.

### Step 8.3: Failure Mode Severity
**SILENT DATA CORRUPTION** — the absolute worst failure mode:
- No kernel errors, no warnings, no oopses
- Data is written to incorrect memory addresses
- Only detectable via checksumming filesystems (BTRFS scrub, ZFS scrub)
- Users on ext4/XFS may never know their data is corrupt until they try
  to use it
- Severity: **CRITICAL**

Record: Silent data corruption. Severity: CRITICAL. No warnings or
errors — data loss can be undetectable.

### Step 8.4: Risk-Benefit Ratio
- **BENEFIT**: Very high — prevents silent data corruption on popular
  hardware
- **RISK**: Very low — 13 lines of data-only additions, uses proven
  infrastructure, only affects two specific device IDs, no code logic
  changes
- **Ratio**: Overwhelmingly favorable

Record: Benefit: VERY HIGH (prevents data corruption). Risk: VERY LOW
(data-only, proven pattern). Ratio: Strongly favorable.

---

## PHASE 9: FINAL SYNTHESIS

### Step 9.1: Evidence Compilation

**Evidence FOR backporting:**
- Fixes **silent data corruption** — the most critical category of bug
- Extremely small, surgical change (~13 lines, data-only, single file)
- Uses well-proven infrastructure (`AHCI_HFLAG_32BIT_ONLY`) existing
  since v2.6.x
- Multiple precedents: ATI SB600, ASMedia ASM1061, ahci_sunxi all use
  the same mechanism
- Reviewed by subsystem co-maintainer (Damien Le Moal)
- Committed by subsystem maintainer (Niklas Cassel)
- Hardware quirk/workaround — explicitly listed as an exception category
- Affects popular consumer hardware (JMB585 is widely used)
- Zero regression risk for non-affected hardware
- No dependencies, fully standalone
- No code logic changes — purely data table additions

**Evidence AGAINST backporting:**
- (None found)

**Unresolved:**
- Could not verify mailing list discussion (lore access blocked)

### Step 9.2: Stable Rules Checklist
1. **Obviously correct and tested?** YES — uses established flag
   mechanism, reviewed by maintainers, author tested on real hardware
   (Minisforum N5 Pro)
2. **Fixes a real bug?** YES — silent data corruption on real hardware
3. **Important issue?** YES — data corruption, CRITICAL severity
4. **Small and contained?** YES — ~13 lines, single file, data-only
5. **No new features or APIs?** CORRECT — no new features, just hardware
   workaround
6. **Can apply to stable trees?** YES — all infrastructure exists in all
   stable trees

### Step 9.3: Exception Categories
This falls into **hardware quirk/workaround** — explicitly listed as
always-YES for stable.

### Step 9.4: Decision
This is a textbook example of a commit that should be backported to
stable. It's a small, obviously correct hardware quirk that prevents
silent data corruption on popular hardware, uses proven infrastructure,
was reviewed by both subsystem maintainers, has zero regression risk,
and requires no dependencies.

---

## Verification

- [Phase 1] Parsed tags: Reviewed-by Damien Le Moal (co-maintainer),
  Signed-off-by Niklas Cassel (maintainer). No Fixes: tag (expected for
  hardware bug).
- [Phase 2] Diff analysis: +13 lines, data-only additions to enum,
  port_info array, and PCI ID table in drivers/ata/ahci.c. No code logic
  changes.
- [Phase 2] Verified AHCI_HFLAG_32BIT_ONLY defined at
  drivers/ata/ahci.h:216, enforced at libahci.c:482 (clears
  HOST_CAP_64).
- [Phase 2] Verified ahci_configure_dma_masks() at ahci.c:1069-1097
  reads hpriv->cap to decide DMA bits.
- [Phase 2] Verified PCI ID entries placed before generic JMicron class
  match (first-match semantics).
- [Phase 3] git log --oneline -20 -- drivers/ata/ahci.c: confirmed file
  is actively maintained by Cassel and Le Moal.
- [Phase 3] git log --author confirms Niklas Cassel is #1 committer,
  Damien Le Moal is #2 to drivers/ata/.
- [Phase 3] Confirmed ASMedia 43-bit DMA quirk (commit 20730e9b27787) as
  precedent for same type of fix.
- [Phase 3] No JMB582/585 related commits found in history — this is the
  first fix.
- [Phase 4] UNVERIFIED: Could not access lore.kernel.org for mailing
  list discussion (Anubis challenge). Does not affect decision — commit
  metadata provides sufficient confidence.
- [Phase 5] Verified AHCI_HFLAG_32BIT_ONLY used by 3 other board
  entries: board_ahci_sb600, ahci_sunxi, confirming proven
  infrastructure.
- [Phase 6] All required infrastructure exists since very early kernels
  — present in all active stable trees.
- [Phase 6] No prior JMB582/585 DMA fixes found in any stable tree.
- [Phase 7] drivers/ata is IMPORTANT criticality — SATA controllers
  affect data integrity for storage.
- [Phase 8] Failure mode: silent data corruption with no kernel errors.
  Severity: CRITICAL.
- [Phase 8] Risk: VERY LOW (data-only changes, proven mechanism, device-
  specific).

**YES**

 drivers/ata/ahci.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 931d0081169b9..1d73a53370cf3 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -68,6 +68,7 @@ enum board_ids {
 	/* board IDs for specific chipsets in alphabetical order */
 	board_ahci_al,
 	board_ahci_avn,
+	board_ahci_jmb585,
 	board_ahci_mcp65,
 	board_ahci_mcp77,
 	board_ahci_mcp89,
@@ -212,6 +213,15 @@ static const struct ata_port_info ahci_port_info[] = {
 		.udma_mask	= ATA_UDMA6,
 		.port_ops	= &ahci_avn_ops,
 	},
+	/* JMicron JMB582/585: 64-bit DMA is broken, force 32-bit */
+	[board_ahci_jmb585] = {
+		AHCI_HFLAGS	(AHCI_HFLAG_IGN_IRQ_IF_ERR |
+				 AHCI_HFLAG_32BIT_ONLY),
+		.flags		= AHCI_FLAG_COMMON,
+		.pio_mask	= ATA_PIO4,
+		.udma_mask	= ATA_UDMA6,
+		.port_ops	= &ahci_ops,
+	},
 	[board_ahci_mcp65] = {
 		AHCI_HFLAGS	(AHCI_HFLAG_NO_FPDMA_AA | AHCI_HFLAG_NO_PMP |
 				 AHCI_HFLAG_YES_NCQ),
@@ -439,6 +449,10 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	/* Elkhart Lake IDs 0x4b60 & 0x4b62 https://sata-io.org/product/8803 not tested yet */
 	{ PCI_VDEVICE(INTEL, 0x4b63), board_ahci_pcs_quirk }, /* Elkhart Lake AHCI */
 
+	/* JMicron JMB582/585: force 32-bit DMA (broken 64-bit implementation) */
+	{ PCI_VDEVICE(JMICRON, 0x0582), board_ahci_jmb585 },
+	{ PCI_VDEVICE(JMICRON, 0x0585), board_ahci_jmb585 },
+
 	/* JMicron 360/1/3/5/6, match class to avoid IDE function */
 	{ PCI_VENDOR_ID_JMICRON, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
 	  PCI_CLASS_STORAGE_SATA_AHCI, 0xffffff, board_ahci_ign_iferr },
-- 
2.53.0

