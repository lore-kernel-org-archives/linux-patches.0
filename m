Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72F75540760;
	Mon, 19 Oct 2026 14:05:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792418734; cv=none; b=jgpgqCjKZJpabfOfQWD7gJAu3zO9mqAoLnkkFMyI00jz8MG7RWzvEGumOkVaS/R7IOlng9Ng7TmaiaZZSwWiWNHh+KTU7cb3y9/ga57tz43+113lUFKYfDoWPdVAuyY76O8GPxviTK0AYVGPVNSUKEWbQHYfQt7+QaMZBZwJTpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792418734; c=relaxed/simple;
	bh=wuv4QQPfrA+28/x/mOc9yJ6c1H1DGov3sFiROc4ep7I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=h/6AoCEJxaaor3RsDpUMhBKK7NdVTKW5UqYuVJr9l1utk5DARj2IDWEDa241bpKmtf8g++Si2iIuAfn4maSbzAhRfs/q4WRGmuu0ovTURleSFzgOJObXoHaHXmdz8mi5Mz59z9pK7XpDBHSXGiEfUpc0MD8tIKfgBHPJ49ZqHt8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aslYCR1E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aslYCR1E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16E531F000C8;
	Mon, 19 Oct 2026 14:05:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792418731;
	bh=ZsRVqzdZHElcE+klBvADse0UYwgU5hroLrFhVkJiRL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aslYCR1EJtDGab37v7SuQiyNLKqdyed7jM53r1xQ6WRp/etcVWnkI+M3C/Ghni3jO
	 3/AFUhxHkc7lSS0Q7PavIUidlEITaQiiD0iugGS5ahUKeRMNitpY1DjWoYhWkqIQus
	 5PpKzPc3ootboQN6dHDE8mMecqmxOcNOfDdGBar7FV/YTjoc5pkA3PLSIpx6Vp8Lia
	 arNUKgh1//eDpGcYJkCnezO0AroFeM6HCzKlaIHiiiDiYXuXb2gBTf7WqWqVQ2Z33E
	 x71+TNaL+MHrsWHA0MN3r3UW1PRLdpJdFGrinF2eRpThCwXGVl8gAJqdJFdNq4qj1/
	 HAem0Jei1a/aw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Pranjal Shrivastava <praan@google.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-5.10] PCI/ATS: Ensure pci_ats_supported() is PF-aware for VFs
Date: Mon, 19 Oct 2026 09:52:27 -0400
Message-ID: <20261019135441.1420968-456-sashal@kernel.org>
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

From: Pranjal Shrivastava <praan@google.com>

[ Upstream commit 4f2cd6091ac41566a7300f5a4590d20a99aaa8bc ]

Update pci_ats_supported() to additionally check the associated PF's
status when called on a VF. This ensures that PF-level quirks and
untrusted status are correctly propagated to VFs, providing a robust
support check that aligns with the kernel's PF-centric ATS configuration
model and is immune to the timing of VF-specific fixups.

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Pranjal Shrivastava <praan@google.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Phase 1: Commit message forensics

**Step 1.1: Subject line**
Record: `[PCI/ATS] [Ensure] make pci_ats_supported() PF-aware when
called on a VF`

**Step 1.2: Tags**
Record:
- Reviewed-by: Jason Gunthorpe (NVIDIA / IOMMU)
- Reviewed-by: Samiullah Khawaja (Google)
- Reviewed-by: Nicolin Chen (NVIDIA)
- Reviewed-by: Lu Baolu (Intel VT-d)
- Reviewed-by: Kevin Tian (Intel)
- Acked-by: Bjorn Helgaas (PCI maintainer)
- Signed-off-by: Pranjal Shrivastava (author)
- Signed-off-by: Joerg Roedel (IOMMU maintainer, committer)
- No Fixes:, Reported-by:, Tested-by:, Link:, or Cc: stable (absence
  expected)

**Step 1.3: Body**
Record:
- Bug: `pci_ats_supported()` on a VF only inspects that VF. PF quirks
  (`quirk_no_ats` zeros `ats_cap`) and PF `untrusted` are not applied.
- Symptom: VFs can be treated as ATS-capable when the PF is not allowed
  to use ATS; IOMMU then programs ATS and `pci_enable_ats()` can fail,
  leaving inconsistent ATS/IOMMU state.
- Cover letter (v9 0/4): seen under `iova_stress` as `pci_enable_ats()`
  failure → PCI warnings on detach. Also: “`pci_ats_supported()` did not
  account for PF-level quirked status.”
- Root cause: helper is device-local; kernel ATS policy is PF-centric
  (STU programmed on PF, VFs share it).
- Version: helper added in 2020 (`521376741b2c2`); this change landed
  for v7.3-rc1.

**Step 1.4: Hidden bug fix?**
Record: Yes. “Ensure” / “robust support check” is a real correctness
fix: VFs of quirked or untrusted PFs could be reported as ATS-capable.
Not style-only.

---

## Phase 2: Diff analysis

**Step 2.1: Inventory**
Record:
- File: `drivers/pci/ats.c` (+5 / −2)
- Function: `pci_ats_supported()`
- Scope: single-function surgical change

**Step 2.2: Control flow**
Record: Before: `false` if `!ats_cap`, else `untrusted == 0`. After:
`false` if `!ats_cap` or `untrusted`; if VF, recurse to
`pci_physfn(dev)`; else `true`. Recursion is one level (PF is not a
virtfn).

**Step 2.3: Bug mechanism**
Record:
- Category: logic/correctness + hardware quirk inheritance (security-
  adjacent ATS policy)
- Mechanism: `quirk_no_ats()` is `DECLARE_PCI_FIXUP_FINAL` and matches
  PF IDs, zeroing PF `ats_cap`. VFs have their own ATS cap and usually
  different IDs, so VF `ats_cap` stays set. FINAL quirks run in
  `pci_bus_add_device()` after `device_add()` → IOMMU probe. Checking
  the PF avoids depending on VF FINAL fixup timing.

**Step 2.4: Fix quality**
Record: Minimal and aligned with `pci_ats_required()` /
`pci_pri_supported()`, which already walk to the PF. Regression risk is
low: it only denies ATS when the PF is already denied. VF ATS without a
usable PF was already broken (`pci_enable_ats()` requires matching PF
STU).

---

## Phase 3: Git history

**Step 3.1: Blame**
Record: Helper introduced by `521376741b2c2` (“PCI/ATS: Only enable ATS
for trusted devices”, 2020-05-27, ~v5.8). The VF PF walk is
`4f2cd6091ac41` (2026-07-09).

**Step 3.2: Fixes: tag**
Record: None. Buggy code is the original helper from `521376741b2c2`,
present in this tree.

**Step 3.3: Related file history**
Record:
- `6c17c7d5936e6` (v6.12): `pci_prepare_ats()` — PF STU before VFs
- `4f2cd6091ac41`: this change (series 1/4)
- `6fd7c5c81af23`: series 2/4, STU check in `pci_prepare_ats()` —
  follow-on, not a prerequisite

**Step 3.4: Author**
Record: Pranjal Shrivastava; IOMMU/PCI ATS work. Not subsystem
maintainer. Joerg Roedel applied it; Bjorn Helgaas acked.

**Step 3.5: Dependencies**
Record: Standalone. Uses existing `pci_physfn()`, `is_virtfn`,
`ats_cap`, `untrusted`. Later series patches (SMMUv3 WARN, VT-d probe
fail) depend on this, not the reverse.

---

## Phase 4: Mailing list

**Step 4.1: Original discussion**
Record:
- Lore:
  https://patch.msgid.link/20260615235037.259909-2-praan@google.com
- Cover:
  https://patch.msgid.link/20260615235037.259909-1-praan@google.com
- Revisions: v3 (2026-05-19) through v9 (2026-06-15). Applied version is
  v9 1/4.
- No NAKs in the v9 mbox. Joerg: “Applied, thanks.”
- No reviewer Cc: stable.

**Step 4.2: Recipients (`b4 dig -w`)**
Record: iommu@lists.linux.dev, linux-pci@, Joerg Roedel, Will Deacon,
Robin Murphy, Lu Baolu, Jason Gunthorpe, Kevin Tian, Bjorn Helgaas,
Nicolin Chen, Samiullah Khawaja.

**Step 4.3: Bug report**
Record: No syzbot/bugzilla. Cover letter: `iova_stress` ATS mismatch; PF
quirk gap after David’s HEADER-phase work. UNVERIFIED: I could not open
lore via WebFetch (403); content is from `b4 dig -m`.

**Step 4.4: Series**
Record: v9 0/4 “iommu: Standardize ATS robustness and state tracking” (4
patches). This is patch 1 and is independently correct.

**Step 4.5: Stable list**
Record: No hit that this was requested or rejected for stable (curl to
lore.kernel.org/stable returned empty). UNVERIFIED beyond that.

---

## Phase 5: Code semantics

**Step 5.1: Functions**
Record: `pci_ats_supported()` only.

**Step 5.2: Callers**
Record:
- `pci_prepare_ats()` / `pci_enable_ats()` / `pci_ats_required()`
  (`drivers/pci/ats.c`)
- Intel VT-d probe / ATS / release (`drivers/iommu/intel/iommu.c`)
- ARM SMMUv3 `arm_smmu_ats_supported()` and probe
  (`drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c`)
- AMD IOMMU `pdev_get_caps()` (`drivers/iommu/amd/iommu.c`)
- IOMMU reset prepare/done (`drivers/iommu/iommu.c`)

**Step 5.3: Callees**
Record: `pci_physfn()` (returns `dev->physfn` for VFs).

**Step 5.4: Reachability**
Record: Yes. IOMMU `probe_device` during PCI add / SR-IOV VF create.
Userspace can create VFs (sysfs `sriov_numvfs`). Not a rare config-only
path if IOMMU + SR-IOV + ATS are enabled.

**Step 5.5: Similar patterns**
Record: `pci_ats_required()`, `pci_pri_supported()`, PASID helpers
already use `pci_physfn()`. This helper was the outlier.

Verified probe vs quirk order:
- `pci_device_add()`: HEADER fixups → `pci_ats_init()` → `device_add()`
  (IOMMU probe)
- `pci_bus_add_device()`: FINAL fixups (`quirk_no_ats`) after that
So IOMMU can observe VF `ats_cap` before VF FINAL quirks. PF FINAL
quirks have usually already run when VFs are created later.

---

## Phase 6: This checkout

**Step 6.1: Buggy code in this tree?**
Record: Yes. Tree is **v7.3-rc4** (`7.3.0-rc4`). `pci_ats_supported()`
exists since v5.8. Pre-change body is the `!ats_cap` / `untrusted == 0`
check. `git merge-base --is-ancestor 4f2cd6091ac41 HEAD` is true (native
7.3-rc1 merge, not a reason to skip technical review).

**Step 6.2: Backport difficulty**
Record: Clean apply onto the parent helper. No API/struct change.

**Step 6.3: Related fixes already here?**
Record: No earlier substitute for PF-aware `pci_ats_supported()`.
`quirk_no_ats` is still FINAL, not HEADER, so the VF/PF gap remains
without this change.

---

## Phase 7: Subsystem context

**Step 7.1**
Record: PCI ATS / IOMMU. Criticality: **IMPORTANT** (IOMMU DMA
translation; ATS can emit Translated AT and partially bypass IOMMU).

**Step 7.2**
Record: Active (VF ATS, CXL always-on ATS, Intel/AMD/SMMUv3). Helper
itself is mature (2020).

---

## Phase 8: Impact and risk

**Step 8.1: Who is affected**
Record: SR-IOV + IOMMU + ATS. Datacenter NICs/IPUs/GPUs. Intel IPU E2000
quirk: broken ATS invalidation → “outdated translations” and “system
instability.” Those FINAL quirks match listed PF IDs; VF IDs often
differ.

**Step 8.2: Trigger**
Record: Creating/probing a VF of a PF with `ats_cap` cleared or
`untrusted` set. Common on SR-IOV enable, not every boot. Unprivileged
users cannot usually create VFs.

**Step 8.3: Failure mode**
Record:
- ATS enabled on hardware the PF quirk meant to disable → stale IOTLB /
  instability / possible bad DMA (**HIGH**)
- IOMMU thinks ATS is supported, `pci_enable_ats()` fails, detach
  warnings / inconsistent state (**MEDIUM–HIGH**)
- Untrusted PF VFs getting ATS would be a DMA/ATS bypass gap; VF
  `untrusted` is often already set from the upstream bridge, so this
  part is extra defense

Severity: **HIGH** (quirk bypass on broken ATS), not a universal panic.

**Step 8.4: Risk-benefit**
Record: Benefit high for SR-IOV ATS users on quirked devices; risk very
low (5 lines, stricter deny only). Ratio: favorable.

---

## Phase 9: Synthesis

**Step 9.1: Evidence**

For:
- Real bug: VF ATS allow-list ignored PF quirk/`untrusted`
- Concrete trigger: SR-IOV VF probe; `iova_stress` saw enable-fail /
  detach warnings
- E2000-class quirks document instability if ATS stays on
- 5-line, obviously correct, PF walk matches the rest of PCI ATS
- Reviewed by PCI and Intel/AMD/ARM IOMMU maintainers
- Self-contained; applies to this tree’s helper

Against:
- Framed as robustness in a 4-patch series, not a panic/CVE
- No Fixes:/Cc: stable (not a negative by itself)
- Affects SR-IOV+ATS, not all machines
- Untrusted gap is weaker than the quirk/`ats_cap` gap

Unresolved:
- Exact `iova_stress` trace not in the v9 mbox
- Whether every E2000 VF ID is already in the quirk table (PF walk still
  needed for timing and other `quirk_no_ats` IDs)

**Step 9.2: Stable rules**
1. Obviously correct and tested? **PASS** — one-level PF recurse; v9
   reviews; `iova_stress` mentioned
2. Real user-visible bug? **PASS** — false ATS support on VFs; IOMMU
   mismatch; quirk bypass
3. Important (crash/security/corruption/deadlock)? **PASS** — ATS on
   quirked broken invalidation is instability / stale translations; ATS
   policy is security-adjacent
4. Small and contained? **PASS** — +5/−2, one function
5. No new features/APIs? **PASS**
6. Applies to this tree? **PASS** — helper and fields exist; parent hunk
   matches

**Step 9.3: Exceptions**
Record: Not a device-ID/DT/build/doc exception. Hardware-quirk
*inheritance* for existing `quirk_no_ats` entries.

**Step 9.4: Decision**
This tree is Linux **7.3-rc4**. The helper has been wrong for VFs since
v5.8. The change is a small, reviewed correctness fix so VFs cannot use
ATS when the PF is quirk-disabled or untrusted, which is the kernel’s
PF-centric ATS model. That is appropriate here.

### What the commit solves for users of this tree
Without it, `pci_ats_supported(VF)` can be true while the PF has
`ats_cap == 0` (FINAL `quirk_no_ats`) or is untrusted. IOMMU drivers
then set up ATS on the VF. That can enable ATS on hardware the PF quirk
turned off (Intel E2000: bad invalidate endianness → stale translations
/ instability), or fail later in `pci_enable_ats()` and leave IOMMU/PCI
ATS state inconsistent.

### Verification
- [Phase 1] Tags: five Reviewed-by + Bjorn Acked-by; no Fixes/Reported-
  by/Cc: stable
- [Phase 1] Cover letter from `/tmp/ats-thread.mbox`: `iova_stress`, PF
  quirk gap
- [Phase 2] Diff: +5/−2 in `pci_ats_supported()` only
- [Phase 3] `git blame`: helper from `521376741b2c2` (v5.8); VF walk
  from `4f2cd6091ac41`
- [Phase 3] `git show 4f2cd6091ac41^:drivers/pci/ats.c`: old `return
  (dev->untrusted == 0)`
- [Phase 3] Series 2/4 is `6fd7c5c81af23`; not required for this helper
  change
- [Phase 4] `b4 dig -c 4f2cd6091ac41`: v9 1/4 at
  patch.msgid.link/20260615235037.259909-2-praan@google.com
- [Phase 4] `b4 dig -a`: v3–v9; applied = v9
- [Phase 4] `b4 dig -w`: PCI + IOMMU maintainers on Cc
- [Phase 4] mbox msg 9: Joerg “Applied, thanks.” No NAK
- [Phase 4] WebFetch lore: 403; used b4 mbox instead
- [Phase 5] Callers: VT-d, SMMUv3, AMD IOMMU,
  `pci_enable_ats`/`pci_prepare_ats`
- [Phase 5] `pci_device_add` vs `pci_bus_add_device`: IOMMU probe before
  FINAL `quirk_no_ats`
- [Phase 6] `git describe HEAD` = v7.3-rc4-27-gf0100363d8c37; `make
  kernelversion` = 7.3.0-rc4
- [Phase 6] `git merge-base --is-ancestor 4f2cd6091ac41 HEAD` = yes
- [Phase 8] E2000 quirk commit `a18615b1cfc04`: ATS invalidate endian
  bug → system instability
- UNVERIFIED: full `iova_stress` log; whether every E2000 VF ID is
  already quirked

The fix is small, surgical, and meets the stable criteria for this tree.

**YES**

 drivers/pci/ats.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/ats.c b/drivers/pci/ats.c
index ec6c8dbdc5e9c..a5fa7745bce8e 100644
--- a/drivers/pci/ats.c
+++ b/drivers/pci/ats.c
@@ -40,10 +40,13 @@ void pci_ats_init(struct pci_dev *dev)
  */
 bool pci_ats_supported(struct pci_dev *dev)
 {
-	if (!dev->ats_cap)
+	if (!dev->ats_cap || dev->untrusted)
 		return false;
 
-	return (dev->untrusted == 0);
+	if (dev->is_virtfn)
+		return pci_ats_supported(pci_physfn(dev));
+
+	return true;
 }
 EXPORT_SYMBOL_GPL(pci_ats_supported);
 
-- 
2.53.0

