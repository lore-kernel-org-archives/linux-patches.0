Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F599231A29;
	Thu, 12 Dec 2024 16:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019547; cv=none; b=VZs3iFsBlypOZ4QTw593vgyslRrOY4C7Fyh7uVe6E/JGAUCahI9HcNdZ6MrAG1kVUmnFSeg7lzetVv020+TRpEL9NndD+HYg/Pt9tF7vPve4QlUVcZpf+J62a98AhAZWELAwvLnUBoP9B9a8RO3WMjIy/OPw0M+5i5oOzbU2DDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019547; c=relaxed/simple;
	bh=uj1DIkudqaMbmAWzOmaDlYS0G8ohlIiqOioPJw6Mwyk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W/6c6t9NHw4ln5x4cPvf5LCkxAcV2i+aLZFxEqj0JRAMEuWjNkuCHTRSvQzeDYB3iYG7KXHiNtJh68sA/CjovDLeWqiWioE4Tefb0WANAG4BkBfYLY+/ikiIpy7x1Hn9nkvOtPn2cLZsuqATkhaKKkYDjEd0QjL67woy76cIkWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zALhJprO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zALhJprO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A410C4CECE;
	Thu, 12 Dec 2024 16:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019547;
	bh=uj1DIkudqaMbmAWzOmaDlYS0G8ohlIiqOioPJw6Mwyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zALhJprOMUduUgfsT5zT1rcw+l7Ko/f40J9LZi67i5k8JI2O2vqMU3I4gpae577yu
	 82ky3NlAUFAFNeCxB6sFwEyDIslU8v+4WBviqyDHBksF1TpBplt7ht97bqDY/Bqvbe
	 alGAz+IxFepmMTSLqkZF+JmkUU3mPE6O/SMKrjsA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhenzhong Duan <zhenzhong.duan@intel.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <jroedel@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 236/772] iommu/vt-d: Fix checks and print in pgtable_walk()
Date: Thu, 12 Dec 2024 15:53:01 +0100
Message-ID: <20241212144359.664547075@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhenzhong Duan <zhenzhong.duan@intel.com>

[ Upstream commit f1645676f25d2c846798f0233c3a953efd62aafb ]

There are some issues in pgtable_walk():

1. Super page is dumped as non-present page
2. dma_pte_superpage() should not check against leaf page table entries
3. Pointer pte is never NULL so checking it is meaningless
4. When an entry is not present, it still makes sense to dump the entry
   content.

Fix 1,2 by checking dma_pte_superpage()'s returned value after level check.
Fix 3 by removing pte check.
Fix 4 by checking present bit after printing.

By this chance, change to print "page table not present" instead of "PTE
not present" to be clearer.

Fixes: 914ff7719e8a ("iommu/vt-d: Dump DMAR translation structure when DMA fault occurs")
Signed-off-by: Zhenzhong Duan <zhenzhong.duan@intel.com>
Link: https://lore.kernel.org/r/20241024092146.715063-3-zhenzhong.duan@intel.com
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/iommu.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 2bf9157256c55..9a1bdfda9a9af 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -831,14 +831,15 @@ static void pgtable_walk(struct intel_iommu *iommu, unsigned long pfn,
 	while (1) {
 		offset = pfn_level_offset(pfn, level);
 		pte = &parent[offset];
-		if (!pte || (dma_pte_superpage(pte) || !dma_pte_present(pte))) {
-			pr_info("PTE not present at level %d\n", level);
-			break;
-		}
 
 		pr_info("pte level: %d, pte value: 0x%016llx\n", level, pte->val);
 
-		if (level == 1)
+		if (!dma_pte_present(pte)) {
+			pr_info("page table not present at level %d\n", level - 1);
+			break;
+		}
+
+		if (level == 1 || dma_pte_superpage(pte))
 			break;
 
 		parent = phys_to_virt(dma_pte_addr(pte));
-- 
2.43.0



