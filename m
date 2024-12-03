Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B82D21F8910;
	Tue,  3 Dec 2024 15:14:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238885; cv=none; b=WWwmXRn65GfBnLUF0KPfnYVZI0sH5df8gLDFSUyk1S8EPRlQfQXRdAWHeSQFJ329rDu/9G9WjHNeUHIbLRkuW7QsD9hsoc34Qo+uv4y44DJvsWHa3XE5Dh7pfSFOB5oE+UCpXTiH7aKmgbacg0pCLk3nB1YPjbyB6419ZWy4+Jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238885; c=relaxed/simple;
	bh=WEMsu+Iv6cRu+A/0zVIeBzXoalSWXUwvs5RRLr0AL6o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=buKL7vJL4sIAe8Eh4X8fZew1bymGNtBP3fyNc7BC16RurXmOfhWjY5zJFhnKHdAG04umYuNEbo0PH4JOtXJjmuE3X3CC6jnL65gu4ln97JYS9h0LnSqTrdgcV/qAkt9U5X7t7nSVgOZFSBG2iF70jBR67/ABvXY0CPtajt3YOxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jy6MYHwo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jy6MYHwo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E4DCC4CECF;
	Tue,  3 Dec 2024 15:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238885;
	bh=WEMsu+Iv6cRu+A/0zVIeBzXoalSWXUwvs5RRLr0AL6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jy6MYHwoV+GA0MylGf40jvAmUXN6EbkgZnAFa8jWUOb6oTghtfZTezgzO+Q54atQq
	 Jopo0BrNmMmCcw72+6OITiUYYK3H89D0TbBrTXnqZUcJ57zxB9a78XLyq2nxSs8k1V
	 FBWPkJjg65j6Wlo2LbnYoGMJQ3LJ6QYIv4Srmaes=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhenzhong Duan <zhenzhong.duan@intel.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 430/817] iommu/vt-d: Fix checks and print in dmar_fault_dump_ptes()
Date: Tue,  3 Dec 2024 15:40:02 +0100
Message-ID: <20241203144012.667980509@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhenzhong Duan <zhenzhong.duan@intel.com>

[ Upstream commit 6ceb93f952f6ca34823ce3650c902c31b8385b40 ]

There are some issues in dmar_fault_dump_ptes():

1. return value of phys_to_virt() is used for checking if an entry is
   present.
2. dump is confusing, e.g., "pasid table entry is not present", confusing
   by unpresent pasid table vs. unpresent pasid table entry. Current code
   means the former.
3. pgtable_walk() is called without checking if page table is present.

Fix 1 by checking present bit of an entry before dump a lower level entry.
Fix 2 by removing "entry" string, e.g., "pasid table is not present".
Fix 3 by checking page table present before walk.

Take issue 3 for example, before fix:

[  442.240357] DMAR: pasid dir entry: 0x000000012c83e001
[  442.246661] DMAR: pasid table entry[0]: 0x0000000000000000
[  442.253429] DMAR: pasid table entry[1]: 0x0000000000000000
[  442.260203] DMAR: pasid table entry[2]: 0x0000000000000000
[  442.266969] DMAR: pasid table entry[3]: 0x0000000000000000
[  442.273733] DMAR: pasid table entry[4]: 0x0000000000000000
[  442.280479] DMAR: pasid table entry[5]: 0x0000000000000000
[  442.287234] DMAR: pasid table entry[6]: 0x0000000000000000
[  442.293989] DMAR: pasid table entry[7]: 0x0000000000000000
[  442.300742] DMAR: PTE not present at level 2

After fix:
...
[  357.241214] DMAR: pasid table entry[6]: 0x0000000000000000
[  357.248022] DMAR: pasid table entry[7]: 0x0000000000000000
[  357.254824] DMAR: scalable mode page table is not present

Fixes: 914ff7719e8a ("iommu/vt-d: Dump DMAR translation structure when DMA fault occurs")
Signed-off-by: Zhenzhong Duan <zhenzhong.duan@intel.com>
Link: https://lore.kernel.org/r/20241024092146.715063-2-zhenzhong.duan@intel.com
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/iommu.c | 29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index dda6dea7cce09..8e56df584d3f4 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -752,11 +752,11 @@ void dmar_fault_dump_ptes(struct intel_iommu *iommu, u16 source_id,
 	pr_info("Dump %s table entries for IOVA 0x%llx\n", iommu->name, addr);
 
 	/* root entry dump */
-	rt_entry = &iommu->root_entry[bus];
-	if (!rt_entry) {
-		pr_info("root table entry is not present\n");
+	if (!iommu->root_entry) {
+		pr_info("root table is not present\n");
 		return;
 	}
+	rt_entry = &iommu->root_entry[bus];
 
 	if (sm_supported(iommu))
 		pr_info("scalable mode root entry: hi 0x%016llx, low 0x%016llx\n",
@@ -767,7 +767,7 @@ void dmar_fault_dump_ptes(struct intel_iommu *iommu, u16 source_id,
 	/* context entry dump */
 	ctx_entry = iommu_context_addr(iommu, bus, devfn, 0);
 	if (!ctx_entry) {
-		pr_info("context table entry is not present\n");
+		pr_info("context table is not present\n");
 		return;
 	}
 
@@ -776,17 +776,23 @@ void dmar_fault_dump_ptes(struct intel_iommu *iommu, u16 source_id,
 
 	/* legacy mode does not require PASID entries */
 	if (!sm_supported(iommu)) {
+		if (!context_present(ctx_entry)) {
+			pr_info("legacy mode page table is not present\n");
+			return;
+		}
 		level = agaw_to_level(ctx_entry->hi & 7);
 		pgtable = phys_to_virt(ctx_entry->lo & VTD_PAGE_MASK);
 		goto pgtable_walk;
 	}
 
-	/* get the pointer to pasid directory entry */
-	dir = phys_to_virt(ctx_entry->lo & VTD_PAGE_MASK);
-	if (!dir) {
-		pr_info("pasid directory entry is not present\n");
+	if (!context_present(ctx_entry)) {
+		pr_info("pasid directory table is not present\n");
 		return;
 	}
+
+	/* get the pointer to pasid directory entry */
+	dir = phys_to_virt(ctx_entry->lo & VTD_PAGE_MASK);
+
 	/* For request-without-pasid, get the pasid from context entry */
 	if (intel_iommu_sm && pasid == IOMMU_PASID_INVALID)
 		pasid = IOMMU_NO_PASID;
@@ -798,7 +804,7 @@ void dmar_fault_dump_ptes(struct intel_iommu *iommu, u16 source_id,
 	/* get the pointer to the pasid table entry */
 	entries = get_pasid_table_from_pde(pde);
 	if (!entries) {
-		pr_info("pasid table entry is not present\n");
+		pr_info("pasid table is not present\n");
 		return;
 	}
 	index = pasid & PASID_PTE_MASK;
@@ -806,6 +812,11 @@ void dmar_fault_dump_ptes(struct intel_iommu *iommu, u16 source_id,
 	for (i = 0; i < ARRAY_SIZE(pte->val); i++)
 		pr_info("pasid table entry[%d]: 0x%016llx\n", i, pte->val[i]);
 
+	if (!pasid_pte_is_present(pte)) {
+		pr_info("scalable mode page table is not present\n");
+		return;
+	}
+
 	if (pasid_pte_get_pgtt(pte) == PASID_ENTRY_PGTT_FL_ONLY) {
 		level = pte->val[2] & BIT_ULL(2) ? 5 : 4;
 		pgtable = phys_to_virt(pte->val[2] & VTD_PAGE_MASK);
-- 
2.43.0



