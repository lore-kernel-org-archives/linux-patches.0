Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6A56305960;
	Sat, 25 Oct 2025 16:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409559; cv=none; b=CJgiRfPxL8icIQA7JVJF9Kzg3hxpzKXCchvv3L00NJ5oxnRs+dWQhxxvBLSRYSt0YTx6tYDWckAXiRNohPrMAxaZpTv2gBfb0UwYoHHC/BB9F032DvKr1RdTVXKTkV0Lc2sRVnivTwtm8mfpOHUpz7YtM1Zq4tZAkfat9LDTM5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409559; c=relaxed/simple;
	bh=nEzJlp8R8ld7zC1UbOPJ4woN4/eXTEAhQSpp9tBM09U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MzUMGuX1ZFzw2CtCCTC2bh6QfEMtaiDtdB1lmVJGJKJb80P4/iZHgaSKHx8nI3X8kSnY49Vnr8UQS/ckgTG/tDOtxkgm59DOvt9Et5rxWieFTwKJ74ZlFIysQ+snEGRRnaM0ctZtmFf/BMI2hEGSBbhWutrVlA2YZwFqEXPs7Xg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oY31bgrZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oY31bgrZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B050C4CEF5;
	Sat, 25 Oct 2025 16:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409559;
	bh=nEzJlp8R8ld7zC1UbOPJ4woN4/eXTEAhQSpp9tBM09U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oY31bgrZW7Y2r5NoJj8p3c+ApR9oym7U3TMm+6zuU/aImOrSNFTBAng9n8539Mj5e
	 F7Wm9KBGfXv0d0jJjzU6xUQHwAJG3M7d1jFuMo5/bOefFi6zNUxLJkml7Sfw0hrVAX
	 oyiD8KGnImKIjCVJiTQwIwyoblSvpE+9flE0nPOoqlEYdd+w9LyDQt8sJPUc8UBptT
	 nuLPPrZuCHClMo+idJpuRH1YcsAc1sCw3Fp+9HZzF3r0WxrdqTTmSspIU3jcuaYPRo
	 b70UUQwP1AWAdwOAMpaD7E0pEm17mPfDF+67Z8Yk2RObs/Vdf8YEKMFckHJfhioI8X
	 TPyk1DX9HLVTA==
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
Subject: [PATCH AUTOSEL 6.17] iommu/amd: Add support to remap/unmap IOMMU buffers for kdump
Date: Sat, 25 Oct 2025 11:59:56 -0400
Message-ID: <20251025160905.3857885-365-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Transfer-Encoding: 8bit

From: Ashish Kalra <ashish.kalra@amd.com>

[ Upstream commit f32fe7cb019861f585b40bff4c3daf237b9af294 ]

After a panic if SNP is enabled in the previous kernel then the kdump
kernel boots with IOMMU SNP enforcement still enabled.

IOMMU completion wait buffers (CWBs), command buffers and event buffer
registers remain locked and exclusive to the previous kernel. Attempts
to allocate and use new buffers in the kdump kernel fail, as hardware
ignores writes to the locked MMIO registers as per AMD IOMMU spec
Section 2.12.2.1.

This results in repeated "Completion-Wait loop timed out" errors and a
second kernel panic: "Kernel panic - not syncing: timer doesn't work
through Interrupt-remapped IO-APIC"

The list of MMIO registers locked and which ignore writes after failed
SNP shutdown are mentioned in the AMD IOMMU specifications below:

Section 2.12.2.1.
https://docs.amd.com/v/u/en-US/48882_3.10_PUB

Reuse the pages of the previous kernel for completion wait buffers,
command buffers, event buffers and memremap them during kdump boot
and essentially work with an already enabled IOMMU configuration and
re-using the previous kernel’s data structures.

Reusing of command buffers and event buffers is now done for kdump boot
irrespective of SNP being enabled during kdump.

Re-use of completion wait buffers is only done when SNP is enabled as
the exclusion base register is used for the completion wait buffer
(CWB) address only when SNP is enabled.

Reviewed-by: Vasant Hegde <vasant.hegde@amd.com>
Tested-by: Sairaj Kodilkar <sarunkod@amd.com>
Signed-off-by: Ashish Kalra <ashish.kalra@amd.com>
Link: https://lore.kernel.org/r/ff04b381a8fe774b175c23c1a336b28bc1396511.1756157913.git.ashish.kalra@amd.com
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

- Fixes a real kdump failure: After a panic with SNP enabled, AMD IOMMU
  MMIO registers for completion-wait buffer (CWB), command buffer, and
  event buffer remain locked to the previous kernel. The kdump kernel’s
  attempts to program new buffers are ignored, leading to “Completion-
  Wait loop timed out” and a second panic (“timer doesn't work through
  Interrupt-remapped IO-APIC”). The change reuses the previous kernel’s
  buffers and remaps them into the kdump kernel instead of reprogramming
  the locked registers.

What the change does
- New encrypted-aware remap helper: `iommu_memremap()` clears the SME
  mask and maps with `ioremap_encrypted()` when host memory encryption
  is active, otherwise uses `memremap(MEMREMAP_WB)`
  (drivers/iommu/amd/init.c:719).
- Reuse/remap buffers in kdump:
  - Event buffer remap from hardware register: reads
    `MMIO_EVT_BUF_OFFSET` to get paddr and remaps
    (drivers/iommu/amd/init.c:987).
  - Command buffer remap from hardware register: reads
    `MMIO_CMD_BUF_OFFSET` and remaps (drivers/iommu/amd/init.c:998).
  - CWB handling: If SNP is enabled, read `MMIO_EXCL_BASE_OFFSET` and
    remap the CWB; otherwise allocate a fresh CWB (consistent with spec
    that EXCL_BASE is only used for CWB with SNP)
    (drivers/iommu/amd/init.c:1009).
  - One orchestrating entry point `alloc_iommu_buffers()` chooses remap
    vs allocate strictly based on `is_kdump_kernel()`
    (drivers/iommu/amd/init.c:1031).
- Avoids writes to locked MMIO base registers in kdump:
  `iommu_enable_command_buffer()` and `iommu_enable_event_buffer()` skip
  programming base/length registers when `is_kdump_kernel()` and only
  reset head/tail and enable the features (drivers/iommu/amd/init.c:818,
  drivers/iommu/amd/init.c:878).
- Stores the physical CWB address once: Adds `cmd_sem_paddr` to `struct
  amd_iommu` (drivers/iommu/amd/amd_iommu_types.h:795). It is
  initialized on allocation or remap (drivers/iommu/amd/init.c:978,
  drivers/iommu/amd/init.c:1019) and then used directly when building
  completion-wait commands (drivers/iommu/amd/iommu.c:1195). This
  removes the need to resolve a virtual address that may be a remapped
  legacy physical address.
- Proper unmapping on teardown in kdump: Introduces unmap variants
  (`unmap_cwwb_sem`, `unmap_command_buffer`, `unmap_event_buffer`) and
  uses them conditionally via `free_iommu_buffers()` based on
  `is_kdump_kernel()` (drivers/iommu/amd/init.c:1031,
  drivers/iommu/amd/init.c:1757). Using `memunmap()` is correct for
  these mappings since `memunmap()` detects ioremap-backed regions and
  calls `iounmap()` (kernel/iomem.c:120).

Why it fits stable criteria
- User-visible bugfix: Prevents a second panic and restores kdump
  operation on AMD systems when the previous kernel had SNP enabled.
- Contained change: All changes are within the AMD IOMMU driver and its
  init/enable paths, with kdump-specific behavior guarded by
  `is_kdump_kernel()` and SNP checks. Normal boots remain on the
  original allocation path, with only a benign addition of caching
  `cmd_sem_paddr`.
- No architectural overhaul: Adds a small field and helper functions,
  plus remap/unmap paths. The IOMMU programming model remains unchanged;
  the kdump path just avoids touching registers the hardware purposely
  locks.
- Low regression risk:
  - Non-kdump boots: The existing flow still allocates buffers and
    programs MMIO registers as before. The only functional change is
    that completion-wait now uses the cached physical address
    `cmd_sem_paddr` (drivers/iommu/amd/iommu.c:1195), which is set at
    allocation time (drivers/iommu/amd/init.c:978).
  - Kdump boots: Writes to locked base/length registers are avoided;
    HEAD/TAIL resets and enables remain, which are the only needed
    touches (drivers/iommu/amd/init.c:818,
    drivers/iommu/amd/init.c:878).
  - Memory encryption correctness: `iommu_memremap()` clears the SME
    mask when deriving the true physical address for mapping
    (drivers/iommu/amd/init.c:719). Unmap correctness is ensured by
    `memunmap()`’s use of `iounmap()` for ioremap-backed regions
    (kernel/iomem.c:120).
- No feature additions: Strictly a robustness fix for crash kernels
  interacting with SNP-locked IOMMU hardware.
- Critical subsystem touch vs. mitigations: Although AMD IOMMU is
  critical, the change isolates the special handling to kdump/SNP cases
  and avoids altering normal runtime behavior.

Net: This is a targeted, necessary fix for a severe kdump failure mode
on AMD platforms with SNP. The changes are well-scoped, guarded, and
follow kernel mapping/unmapping conventions. It’s a good candidate for
stable backport.

 drivers/iommu/amd/amd_iommu_types.h |   5 +
 drivers/iommu/amd/init.c            | 152 +++++++++++++++++++++++++---
 drivers/iommu/amd/iommu.c           |   2 +-
 3 files changed, 146 insertions(+), 13 deletions(-)

diff --git a/drivers/iommu/amd/amd_iommu_types.h b/drivers/iommu/amd/amd_iommu_types.h
index 95f63c5f6159f..a698a2e7ce2a6 100644
--- a/drivers/iommu/amd/amd_iommu_types.h
+++ b/drivers/iommu/amd/amd_iommu_types.h
@@ -792,6 +792,11 @@ struct amd_iommu {
 	u32 flags;
 	volatile u64 *cmd_sem;
 	atomic64_t cmd_sem_val;
+	/*
+	 * Track physical address to directly use it in build_completion_wait()
+	 * and avoid adding any special checks and handling for kdump.
+	 */
+	u64 cmd_sem_paddr;
 
 #ifdef CONFIG_AMD_IOMMU_DEBUGFS
 	/* DebugFS Info */
diff --git a/drivers/iommu/amd/init.c b/drivers/iommu/amd/init.c
index ba9e582a8bbe5..309951e57f301 100644
--- a/drivers/iommu/amd/init.c
+++ b/drivers/iommu/amd/init.c
@@ -710,6 +710,26 @@ static void __init free_alias_table(struct amd_iommu_pci_seg *pci_seg)
 	pci_seg->alias_table = NULL;
 }
 
+static inline void *iommu_memremap(unsigned long paddr, size_t size)
+{
+	phys_addr_t phys;
+
+	if (!paddr)
+		return NULL;
+
+	/*
+	 * Obtain true physical address in kdump kernel when SME is enabled.
+	 * Currently, previous kernel with SME enabled and kdump kernel
+	 * with SME support disabled is not supported.
+	 */
+	phys = __sme_clr(paddr);
+
+	if (cc_platform_has(CC_ATTR_HOST_MEM_ENCRYPT))
+		return (__force void *)ioremap_encrypted(phys, size);
+	else
+		return memremap(phys, size, MEMREMAP_WB);
+}
+
 /*
  * Allocates the command buffer. This buffer is per AMD IOMMU. We can
  * write commands to that buffer later and the IOMMU will execute them
@@ -942,8 +962,91 @@ static int iommu_init_ga_log(struct amd_iommu *iommu)
 static int __init alloc_cwwb_sem(struct amd_iommu *iommu)
 {
 	iommu->cmd_sem = iommu_alloc_4k_pages(iommu, GFP_KERNEL, 1);
+	if (!iommu->cmd_sem)
+		return -ENOMEM;
+	iommu->cmd_sem_paddr = iommu_virt_to_phys((void *)iommu->cmd_sem);
+	return 0;
+}
+
+static int __init remap_event_buffer(struct amd_iommu *iommu)
+{
+	u64 paddr;
+
+	pr_info_once("Re-using event buffer from the previous kernel\n");
+	paddr = readq(iommu->mmio_base + MMIO_EVT_BUF_OFFSET) & PM_ADDR_MASK;
+	iommu->evt_buf = iommu_memremap(paddr, EVT_BUFFER_SIZE);
+
+	return iommu->evt_buf ? 0 : -ENOMEM;
+}
+
+static int __init remap_command_buffer(struct amd_iommu *iommu)
+{
+	u64 paddr;
 
-	return iommu->cmd_sem ? 0 : -ENOMEM;
+	pr_info_once("Re-using command buffer from the previous kernel\n");
+	paddr = readq(iommu->mmio_base + MMIO_CMD_BUF_OFFSET) & PM_ADDR_MASK;
+	iommu->cmd_buf = iommu_memremap(paddr, CMD_BUFFER_SIZE);
+
+	return iommu->cmd_buf ? 0 : -ENOMEM;
+}
+
+static int __init remap_or_alloc_cwwb_sem(struct amd_iommu *iommu)
+{
+	u64 paddr;
+
+	if (check_feature(FEATURE_SNP)) {
+		/*
+		 * When SNP is enabled, the exclusion base register is used for the
+		 * completion wait buffer (CWB) address. Read and re-use it.
+		 */
+		pr_info_once("Re-using CWB buffers from the previous kernel\n");
+		paddr = readq(iommu->mmio_base + MMIO_EXCL_BASE_OFFSET) & PM_ADDR_MASK;
+		iommu->cmd_sem = iommu_memremap(paddr, PAGE_SIZE);
+		if (!iommu->cmd_sem)
+			return -ENOMEM;
+		iommu->cmd_sem_paddr = paddr;
+	} else {
+		return alloc_cwwb_sem(iommu);
+	}
+
+	return 0;
+}
+
+static int __init alloc_iommu_buffers(struct amd_iommu *iommu)
+{
+	int ret;
+
+	/*
+	 * Reuse/Remap the previous kernel's allocated completion wait
+	 * command and event buffers for kdump boot.
+	 */
+	if (is_kdump_kernel()) {
+		ret = remap_or_alloc_cwwb_sem(iommu);
+		if (ret)
+			return ret;
+
+		ret = remap_command_buffer(iommu);
+		if (ret)
+			return ret;
+
+		ret = remap_event_buffer(iommu);
+		if (ret)
+			return ret;
+	} else {
+		ret = alloc_cwwb_sem(iommu);
+		if (ret)
+			return ret;
+
+		ret = alloc_command_buffer(iommu);
+		if (ret)
+			return ret;
+
+		ret = alloc_event_buffer(iommu);
+		if (ret)
+			return ret;
+	}
+
+	return 0;
 }
 
 static void __init free_cwwb_sem(struct amd_iommu *iommu)
@@ -951,6 +1054,38 @@ static void __init free_cwwb_sem(struct amd_iommu *iommu)
 	if (iommu->cmd_sem)
 		iommu_free_pages((void *)iommu->cmd_sem);
 }
+static void __init unmap_cwwb_sem(struct amd_iommu *iommu)
+{
+	if (iommu->cmd_sem) {
+		if (check_feature(FEATURE_SNP))
+			memunmap((void *)iommu->cmd_sem);
+		else
+			iommu_free_pages((void *)iommu->cmd_sem);
+	}
+}
+
+static void __init unmap_command_buffer(struct amd_iommu *iommu)
+{
+	memunmap((void *)iommu->cmd_buf);
+}
+
+static void __init unmap_event_buffer(struct amd_iommu *iommu)
+{
+	memunmap(iommu->evt_buf);
+}
+
+static void __init free_iommu_buffers(struct amd_iommu *iommu)
+{
+	if (is_kdump_kernel()) {
+		unmap_cwwb_sem(iommu);
+		unmap_command_buffer(iommu);
+		unmap_event_buffer(iommu);
+	} else {
+		free_cwwb_sem(iommu);
+		free_command_buffer(iommu);
+		free_event_buffer(iommu);
+	}
+}
 
 static void iommu_enable_xt(struct amd_iommu *iommu)
 {
@@ -1655,9 +1790,7 @@ static void __init free_sysfs(struct amd_iommu *iommu)
 static void __init free_iommu_one(struct amd_iommu *iommu)
 {
 	free_sysfs(iommu);
-	free_cwwb_sem(iommu);
-	free_command_buffer(iommu);
-	free_event_buffer(iommu);
+	free_iommu_buffers(iommu);
 	amd_iommu_free_ppr_log(iommu);
 	free_ga_log(iommu);
 	iommu_unmap_mmio_space(iommu);
@@ -1821,14 +1954,9 @@ static int __init init_iommu_one_late(struct amd_iommu *iommu)
 {
 	int ret;
 
-	if (alloc_cwwb_sem(iommu))
-		return -ENOMEM;
-
-	if (alloc_command_buffer(iommu))
-		return -ENOMEM;
-
-	if (alloc_event_buffer(iommu))
-		return -ENOMEM;
+	ret = alloc_iommu_buffers(iommu);
+	if (ret)
+		return ret;
 
 	iommu->int_enabled = false;
 
diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index eb348c63a8d09..05a9ab3da1a3e 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -1195,7 +1195,7 @@ static void build_completion_wait(struct iommu_cmd *cmd,
 				  struct amd_iommu *iommu,
 				  u64 data)
 {
-	u64 paddr = iommu_virt_to_phys((void *)iommu->cmd_sem);
+	u64 paddr = iommu->cmd_sem_paddr;
 
 	memset(cmd, 0, sizeof(*cmd));
 	cmd->data[0] = lower_32_bits(paddr) | CMD_COMPL_WAIT_STORE_MASK;
-- 
2.51.0

