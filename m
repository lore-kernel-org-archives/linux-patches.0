Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11B3A314A63;
	Sat, 25 Oct 2025 16:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409425; cv=none; b=bS9lCSEn9YAMWnfFJhrzp5W2YK92LQr+SjRtvDKpTHAdBlLE+izWlqns3+tgaSmj44zbuUs7J7zK6Oj6NdToj4lrjiuMnonwpLN8m9tBRM1R2iBDDli5jpozXoWBFnlfi7F9Wa7CFCCkUEobNd/r/Uhw3GutYEPUuOsCHvuoRg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409425; c=relaxed/simple;
	bh=HFFKs1k/K/ngoA9IpTMdvFvqArQRD8bzUOkhwaRD5vc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PH2nA8NlBQEuDUaU4peD0v0OLC1wo/zTEl/VodJOfEKWMr2W2aPE2UehUG0l1inpxbL7UTIKL18m20SfsCxb7fVCRKk1E765+ZA+7Os/UxKXqtTl+q7ZCSzuzTvfExgS7EvW7UCAyu25wh5c6d5s8/vF+1fTrEXYNUmoP9Uwhew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nIXluH6i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nIXluH6i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E21AAC113D0;
	Sat, 25 Oct 2025 16:23:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409424;
	bh=HFFKs1k/K/ngoA9IpTMdvFvqArQRD8bzUOkhwaRD5vc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nIXluH6iaQIYFDtYygGzb/6Hv2MXgqMyzHnGQ+jOc0xgNdbC2Y9j2hrMmJPLh3ct+
	 i71D+7V9XAB9P/llgoXQfimORRNTfjXINwZ9n7UApx2BX+xXz2HO6t1pTzE56zY7Dd
	 7MSR5vz0YZPq3dbyuBn8ada+32qUFc5lKCYNnUYHIBJXKthpidVnEbXVXeHXYo7jKN
	 WYjJrD+0j8UdCMTY/sB0Z5XYJfjQ0/+knPzm9AfTATiriSCtWWaf+Fkp/FD2HegW6v
	 U0PaSRWj185Ng0oZ/umfUH6K/bNY4dZL76NB/7GdGfV7HQehXEJCsbFC4mu6PtjFZT
	 Ou1uRfOPjUwkw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ashish Kalra <ashish.kalra@amd.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Sairaj Kodilkar <sarunkod@amd.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	joro@8bytes.org,
	iommu@lists.linux.dev
Subject: [PATCH AUTOSEL 6.17] iommu/amd: Reuse device table for kdump
Date: Sat, 25 Oct 2025 11:59:11 -0400
Message-ID: <20251025160905.3857885-320-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ashish Kalra <ashish.kalra@amd.com>

[ Upstream commit 38e5f33ee3596f37ee8d1e694073a17590904004 ]

After a panic if SNP is enabled in the previous kernel then the kdump
kernel boots with IOMMU SNP enforcement still enabled.

IOMMU device table register is locked and exclusive to the previous
kernel. Attempts to copy old device table from the previous kernel
fails in kdump kernel as hardware ignores writes to the locked device
table base address register as per AMD IOMMU spec Section 2.12.2.1.

This causes the IOMMU driver (OS) and the hardware to reference
different memory locations. As a result, the IOMMU hardware cannot
process the command which results in repeated "Completion-Wait loop
timed out" errors and a second kernel panic: "Kernel panic - not
syncing: timer doesn't work through Interrupt-remapped IO-APIC".

Reuse device table instead of copying device table in case of kdump
boot and remove all copying device table code.

Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>
Tested-by: Sairaj Kodilkar <sarunkod@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Link: https://lore.kernel.org/r/3a31036fb2f7323e6b1a1a1921ac777e9f7bdddc.1756157913.git.ashish.kalra@amd.com
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- Fixes a real kdump crash on AMD systems with SNP: When the first
  kernel panics with SNP enforced, the AMD IOMMU device-table base
  register remains locked (per spec), so the crash kernel’s attempts to
  program a new device table base are ignored. This leaves the OS and
  hardware pointing at different device tables, causing command timeouts
  and a second panic. The change makes the crash kernel reuse the
  previous kernel’s device table instead of copying it and trying to
  reprogram the base register.

- Minimal, targeted scope in AMD IOMMU init: All changes are confined to
  the AMD IOMMU initialization path and are conditional to kdump/“pre-
  enabled translation” scenarios. Normal boot paths are unaffected.

- Core behavior changes that address the bug:
  - Skip programming the DEV table base in kdump:
    drivers/iommu/amd/init.c:401–416 adds an early return in
    `iommu_set_device_table()` for `is_kdump_kernel()`. This avoids
    writing to the locked `MMIO_DEV_TABLE_OFFSET`, exactly the condition
    that was breaking kdump (hardware ignores the write).
  - Reuse instead of copy the prior device table:
    drivers/iommu/amd/init.c:1136–1177 implements
    `__reuse_device_table()` which reads the old table base from
    hardware, clears SME C-bit as needed, and maps it via
    `iommu_memremap()`. The segment-level wrapper `reuse_device_table()`
    at drivers/iommu/amd/init.c:1179–1204 ensures reuse happens only
    once per PCI segment (same as the old “copy” logic, but now purely
    reuse).
  - Driver now adopts the remapped table: in the success path, the
    driver frees its freshly allocated table and replaces it with the
    remapped one (drivers/iommu/amd/init.c:2916–2920). It logs “Reused
    DEV table from previous kernel.” (drivers/iommu/amd/init.c:2914).
  - Robust failure handling when reuse is required: If reuse fails while
    the IOMMU was pre-enabled (the problematic kdump case) and SNP is
    present, the code bails out early with a `BUG_ON()` to prevent
    subsequent hangs/timeouts that lead to a secondary panic
    (drivers/iommu/amd/init.c:2899–2913). This is appropriate for a
    crash kernel context.
  - Correct freeing/unmapping for kdump allocations: In kdump paths,
    previously allocated memory is unmmapped rather than freed from the
    page allocator (e.g., `free_dev_table()` uses `memunmap()` under
    kdump in drivers/iommu/amd/init.c:650–657; similarly for
    `old_dev_tbl_cpy` at drivers/iommu/amd/init.c:2902–2904). This
    matches the new “reuse/remap” strategy.

- Why reuse is necessary vs copying: The old approach copied contents
  into a new table and then tried to reprogram the base register to
  point at it. In kdump with SNP, the base register remains locked to
  the prior kernel’s table; hardware keeps using the old table while the
  OS uses the new copy, causing “Completion-Wait loop timed out” and
  eventually a timer-related panic. Reusing the same memory location
  aligns OS and hardware references immediately and resolves the failure
  mode.

- Removed copy-time fixups are safe in this model: The old copy path
  reserved domain IDs and masked out GCR3/GV bits while copying. With
  reuse, the crash kernel updates DTEs in-place and the attach path
  handles necessary state transitions:
  - New domain associations overwrite the DTE’s `domid` and flush the
    old domain’s TLB if needed (drivers/iommu/amd/iommu.c:2096–2126).
    This mitigates the need to pre-reserve legacy domain IDs.
  - GCR3/guest state is set appropriately when attaching domains via
    `set_dte_gcr3_table()` and associated code in the attach/update path
    (drivers/iommu/amd/iommu.c:2082–2126). This removes the need for ad-
    hoc masking in the copy code.

- Backport risk/considerations:
  - Dependencies: This change relies on `iommu_memremap()`
    (drivers/iommu/amd/init.c:659–681) and the broader kdump reuse
    plumbing already present for the completion wait buffer, command
    buffer, and event buffer (e.g., drivers/iommu/amd/init.c:1089–1177).
    If a target stable branch does not yet have these helpers and reuse
    logic, they should be brought in along with this patch.
  - Kdump-only behavior change in `iommu_set_device_table()`: The
    unconditional `is_kdump_kernel()` early return
    (drivers/iommu/amd/init.c:409–415) is intentional because the base
    register is locked when translation is pre-enabled by the prior
    kernel (i.e., precisely the scenario that matters for kdump). The
    `early_enable_iommus()` logic uses reuse only when
    `amd_iommu_pre_enabled` is true and falls back to full
    initialization otherwise; with SNP and pre-enabled translation, it
    deliberately BUG_ON if reuse fails to avoid the known-timeout/panic
    path (drivers/iommu/amd/init.c:2888–2952).
  - Scope is limited; no architectural changes; affects AMD-IOMMU kdump
    path only.

- Meets stable criteria:
  - Important user-visible bugfix (crash kernel panic on AMD SNP
    systems).
  - Contained to the AMD IOMMU driver init path.
  - No new features or ABI changes.
  - Low regression risk outside kdump; guarded by `is_kdump_kernel()`
    and `amd_iommu_pre_enabled` checks.

Given the severity of the kdump failure and the focused nature of the
fix, this is a strong candidate for stable backport, provided the small
helper/dependency pieces used in this change are included or adapted for
the target branches.

 drivers/iommu/amd/init.c | 104 +++++++++++++--------------------------
 1 file changed, 34 insertions(+), 70 deletions(-)

diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index d0cd40ee0dec6..f2991c11867cb 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -406,6 +406,9 @@ static void iommu_set_device_table(struct amd_iommu *iommu)
 
 	BUG_ON(iommu->mmio_base == NULL);
 
+	if (is_kdump_kernel())
+		return;
+
 	entry = iommu_virt_to_phys(dev_table);
 	entry |= (dev_table_size >> 12) - 1;
 	memcpy_toio(iommu->mmio_base + MMIO_DEV_TABLE_OFFSET,
@@ -646,7 +649,10 @@ static inline int __init alloc_dev_table(struct amd_iommu_pci_seg *pci_seg)
 
 static inline void free_dev_table(struct amd_iommu_pci_seg *pci_seg)
 {
-	iommu_free_pages(pci_seg->dev_table);
+	if (is_kdump_kernel())
+		memunmap((void *)pci_seg->dev_table);
+	else
+		iommu_free_pages(pci_seg->dev_table);
 	pci_seg->dev_table = NULL;
 }
 
@@ -1127,15 +1133,12 @@ static void set_dte_bit(struct dev_table_entry *dte, u8 bit)
 	dte->data[i] |= (1UL << _bit);
 }
 
-static bool __copy_device_table(struct amd_iommu *iommu)
+static bool __reuse_device_table(struct amd_iommu *iommu)
 {
-	u64 int_ctl, int_tab_len, entry = 0;
 	struct amd_iommu_pci_seg *pci_seg = iommu->pci_seg;
-	struct dev_table_entry *old_devtb = NULL;
-	u32 lo, hi, devid, old_devtb_size;
+	u32 lo, hi, old_devtb_size;
 	phys_addr_t old_devtb_phys;
-	u16 dom_id, dte_v, irq_v;
-	u64 tmp;
+	u64 entry;
 
 	/* Each IOMMU use separate device table with the same size */
 	lo = readl(iommu->mmio_base + MMIO_DEV_TABLE_OFFSET);
@@ -1160,66 +1163,20 @@ static bool __copy_device_table(struct amd_iommu *iommu)
 		pr_err("The address of old device table is above 4G, not trustworthy!\n");
 		return false;
 	}
-	old_devtb = (cc_platform_has(CC_ATTR_HOST_MEM_ENCRYPT) && is_kdump_kernel())
-		    ? (__force void *)ioremap_encrypted(old_devtb_phys,
-							pci_seg->dev_table_size)
-		    : memremap(old_devtb_phys, pci_seg->dev_table_size, MEMREMAP_WB);
-
-	if (!old_devtb)
-		return false;
 
-	pci_seg->old_dev_tbl_cpy = iommu_alloc_pages_sz(
-		GFP_KERNEL | GFP_DMA32, pci_seg->dev_table_size);
+	/*
+	 * Re-use the previous kernel's device table for kdump.
+	 */
+	pci_seg->old_dev_tbl_cpy = iommu_memremap(old_devtb_phys, pci_seg->dev_table_size);
 	if (pci_seg->old_dev_tbl_cpy == NULL) {
-		pr_err("Failed to allocate memory for copying old device table!\n");
-		memunmap(old_devtb);
+		pr_err("Failed to remap memory for reusing old device table!\n");
 		return false;
 	}
 
-	for (devid = 0; devid <= pci_seg->last_bdf; ++devid) {
-		pci_seg->old_dev_tbl_cpy[devid] = old_devtb[devid];
-		dom_id = old_devtb[devid].data[1] & DEV_DOMID_MASK;
-		dte_v = old_devtb[devid].data[0] & DTE_FLAG_V;
-
-		if (dte_v && dom_id) {
-			pci_seg->old_dev_tbl_cpy[devid].data[0] = old_devtb[devid].data[0];
-			pci_seg->old_dev_tbl_cpy[devid].data[1] = old_devtb[devid].data[1];
-			/* Reserve the Domain IDs used by previous kernel */
-			if (ida_alloc_range(&pdom_ids, dom_id, dom_id, GFP_ATOMIC) != dom_id) {
-				pr_err("Failed to reserve domain ID 0x%x\n", dom_id);
-				memunmap(old_devtb);
-				return false;
-			}
-			/* If gcr3 table existed, mask it out */
-			if (old_devtb[devid].data[0] & DTE_FLAG_GV) {
-				tmp = (DTE_GCR3_30_15 | DTE_GCR3_51_31);
-				pci_seg->old_dev_tbl_cpy[devid].data[1] &= ~tmp;
-				tmp = (DTE_GCR3_14_12 | DTE_FLAG_GV);
-				pci_seg->old_dev_tbl_cpy[devid].data[0] &= ~tmp;
-			}
-		}
-
-		irq_v = old_devtb[devid].data[2] & DTE_IRQ_REMAP_ENABLE;
-		int_ctl = old_devtb[devid].data[2] & DTE_IRQ_REMAP_INTCTL_MASK;
-		int_tab_len = old_devtb[devid].data[2] & DTE_INTTABLEN_MASK;
-		if (irq_v && (int_ctl || int_tab_len)) {
-			if ((int_ctl != DTE_IRQ_REMAP_INTCTL) ||
-			    (int_tab_len != DTE_INTTABLEN_512 &&
-			     int_tab_len != DTE_INTTABLEN_2K)) {
-				pr_err("Wrong old irq remapping flag: %#x\n", devid);
-				memunmap(old_devtb);
-				return false;
-			}
-
-			pci_seg->old_dev_tbl_cpy[devid].data[2] = old_devtb[devid].data[2];
-		}
-	}
-	memunmap(old_devtb);
-
 	return true;
 }
 
-static bool copy_device_table(void)
+static bool reuse_device_table(void)
 {
 	struct amd_iommu *iommu;
 	struct amd_iommu_pci_seg *pci_seg;
@@ -1227,17 +1184,17 @@ static bool copy_device_table(void)
 	if (!amd_iommu_pre_enabled)
 		return false;
 
-	pr_warn("Translation is already enabled - trying to copy translation structures\n");
+	pr_warn("Translation is already enabled - trying to reuse translation structures\n");
 
 	/*
 	 * All IOMMUs within PCI segment shares common device table.
-	 * Hence copy device table only once per PCI segment.
+	 * Hence reuse device table only once per PCI segment.
 	 */
 	for_each_pci_segment(pci_seg) {
 		for_each_iommu(iommu) {
 			if (pci_seg->id != iommu->pci_seg->id)
 				continue;
-			if (!__copy_device_table(iommu))
+			if (!__reuse_device_table(iommu))
 				return false;
 			break;
 		}
@@ -2916,8 +2873,8 @@ static void early_enable_iommu(struct amd_iommu *iommu)
  * This function finally enables all IOMMUs found in the system after
  * they have been initialized.
  *
- * Or if in kdump kernel and IOMMUs are all pre-enabled, try to copy
- * the old content of device table entries. Not this case or copy failed,
+ * Or if in kdump kernel and IOMMUs are all pre-enabled, try to reuse
+ * the old content of device table entries. Not this case or reuse failed,
  * just continue as normal kernel does.
  */
 static void early_enable_iommus(void)
@@ -2925,18 +2882,25 @@ static void early_enable_iommus(void)
 	struct amd_iommu *iommu;
 	struct amd_iommu_pci_seg *pci_seg;
 
-	if (!copy_device_table()) {
+	if (!reuse_device_table()) {
 		/*
-		 * If come here because of failure in copying device table from old
+		 * If come here because of failure in reusing device table from old
 		 * kernel with all IOMMUs enabled, print error message and try to
 		 * free allocated old_dev_tbl_cpy.
 		 */
-		if (amd_iommu_pre_enabled)
-			pr_err("Failed to copy DEV table from previous kernel.\n");
+		if (amd_iommu_pre_enabled) {
+			pr_err("Failed to reuse DEV table from previous kernel.\n");
+			/*
+			 * Bail out early if unable to remap/reuse DEV table from
+			 * previous kernel if SNP enabled as IOMMU commands will
+			 * time out without DEV table and cause kdump boot panic.
+			 */
+			BUG_ON(check_feature(FEATURE_SNP));
+		}
 
 		for_each_pci_segment(pci_seg) {
 			if (pci_seg->old_dev_tbl_cpy != NULL) {
-				iommu_free_pages(pci_seg->old_dev_tbl_cpy);
+				memunmap((void *)pci_seg->old_dev_tbl_cpy);
 				pci_seg->old_dev_tbl_cpy = NULL;
 			}
 		}
@@ -2946,7 +2910,7 @@ static void early_enable_iommus(void)
 			early_enable_iommu(iommu);
 		}
 	} else {
-		pr_info("Copied DEV table from previous kernel.\n");
+		pr_info("Reused DEV table from previous kernel.\n");
 
 		for_each_pci_segment(pci_seg) {
 			iommu_free_pages(pci_seg->dev_table);
-- 
2.51.0

