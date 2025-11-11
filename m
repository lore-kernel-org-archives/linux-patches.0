Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD7FF26E158;
	Tue, 11 Nov 2025 01:25:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824347; cv=none; b=V4lZbSpiUfncRxSe3zEM97ZGmBRMfsowvD27Z1Ejtso8LDnwpXd7tOUYz1/JPBxGiTXCZVqBcM4phgx7Yj8H/v5/yTgmpk3U/E8BR9MxgCALRLiLJfy8QLqM8YRZhoNTUjOaf5fQywnifvW1E9aof2q8WRU2joNCtD6HKsbaJHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824347; c=relaxed/simple;
	bh=21lDTjUr7yDI/czM3QM34TZU2yvHimMWlS5K3t5cQU8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nZeLdzNe5icvrUxD6opI3KXZg2qNHhQ8K6auPsBTYqFwo9hEyl9Z9mmL70I0HvYsfed5Uwb11xymjwscIOG0zgDYqdmE9lttCuZFG/XeP81QDy8ds7v+Je0ej4ppG6o0R8kWXB6rg1YDtNBuL4tFK2plEeiqpaRWKPLA8jK4+qU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b252c2GZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b252c2GZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23F13C4CEFB;
	Tue, 11 Nov 2025 01:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824346;
	bh=21lDTjUr7yDI/czM3QM34TZU2yvHimMWlS5K3t5cQU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b252c2GZPdbJaohi/kfOef5GBJdiA9B4wTfEOouWIdet6VSa+a+G4Kogu67TWnHui
	 IuH40gkuGB2UM34QxImntuXdGehxYvhmZ458Ui/ZTcT6prkh+7DG2AXvwq2MfU4ViE
	 Q3R8HKJJWtM/7IjbKnDd274Ieb7/rwLjSElQ3hVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Moti Haimovski <moti.haimovski@intel.com>,
	Koby Elbaz <koby.elbaz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 426/565] accel/habanalabs: support mapping cb with vmalloc-backed coherent memory
Date: Tue, 11 Nov 2025 09:44:42 +0900
Message-ID: <20251111004536.447384573@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Moti Haimovski <moti.haimovski@intel.com>

[ Upstream commit 513024d5a0e34fd34247043f1876b6138ca52847 ]

When IOMMU is enabled, dma_alloc_coherent() with GFP_USER may return
addresses from the vmalloc range. If such an address is mapped without
VM_MIXEDMAP, vm_insert_page() will trigger a BUG_ON due to the
VM_PFNMAP restriction.

Fix this by checking for vmalloc addresses and setting VM_MIXEDMAP
in the VMA before mapping. This ensures safe mapping and avoids kernel
crashes. The memory is still driver-allocated and cannot be accessed
directly by userspace.

Signed-off-by: Moti Haimovski  <moti.haimovski@intel.com>
Reviewed-by: Koby Elbaz <koby.elbaz@intel.com>
Signed-off-by: Koby Elbaz <koby.elbaz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/habanalabs/gaudi/gaudi.c   | 19 +++++++++++++++++++
 drivers/accel/habanalabs/gaudi2/gaudi2.c |  7 +++++++
 2 files changed, 26 insertions(+)

diff --git a/drivers/accel/habanalabs/gaudi/gaudi.c b/drivers/accel/habanalabs/gaudi/gaudi.c
index fa893a9b826ec..34771d75da9d7 100644
--- a/drivers/accel/habanalabs/gaudi/gaudi.c
+++ b/drivers/accel/habanalabs/gaudi/gaudi.c
@@ -4168,10 +4168,29 @@ static int gaudi_mmap(struct hl_device *hdev, struct vm_area_struct *vma,
 	vm_flags_set(vma, VM_IO | VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP |
 			VM_DONTCOPY | VM_NORESERVE);
 
+#ifdef _HAS_DMA_MMAP_COHERENT
+	/*
+	 * If dma_alloc_coherent() returns a vmalloc address, set VM_MIXEDMAP
+	 * so vm_insert_page() can handle it safely. Without this, the kernel
+	 * may BUG_ON due to VM_PFNMAP.
+	 */
+	if (is_vmalloc_addr(cpu_addr))
+		vm_flags_set(vma, VM_MIXEDMAP);
+
 	rc = dma_mmap_coherent(hdev->dev, vma, cpu_addr,
 				(dma_addr - HOST_PHYS_BASE), size);
 	if (rc)
 		dev_err(hdev->dev, "dma_mmap_coherent error %d", rc);
+#else
+
+	rc = remap_pfn_range(vma, vma->vm_start,
+				virt_to_phys(cpu_addr) >> PAGE_SHIFT,
+				size, vma->vm_page_prot);
+	if (rc)
+		dev_err(hdev->dev, "remap_pfn_range error %d", rc);
+
+ #endif
+
 
 	return rc;
 }
diff --git a/drivers/accel/habanalabs/gaudi2/gaudi2.c b/drivers/accel/habanalabs/gaudi2/gaudi2.c
index 3df72a5d024a6..b957957df3d3a 100644
--- a/drivers/accel/habanalabs/gaudi2/gaudi2.c
+++ b/drivers/accel/habanalabs/gaudi2/gaudi2.c
@@ -6490,6 +6490,13 @@ static int gaudi2_mmap(struct hl_device *hdev, struct vm_area_struct *vma,
 			VM_DONTCOPY | VM_NORESERVE);
 
 #ifdef _HAS_DMA_MMAP_COHERENT
+	/*
+	 * If dma_alloc_coherent() returns a vmalloc address, set VM_MIXEDMAP
+	 * so vm_insert_page() can handle it safely. Without this, the kernel
+	 * may BUG_ON due to VM_PFNMAP.
+	 */
+	if (is_vmalloc_addr(cpu_addr))
+		vm_flags_set(vma, VM_MIXEDMAP);
 
 	rc = dma_mmap_coherent(hdev->dev, vma, cpu_addr, dma_addr, size);
 	if (rc)
-- 
2.51.0



