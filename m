Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20834345751;
	Fri, 21 Nov 2025 13:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732967; cv=none; b=EThNbNnR5XfWAb94YohvVOtsGIrZwQkoqMjPwXuvFbYOO1Bx9AuLyE7pwCA15P3kUXyGqApB4e0VJVD+MPBH2UbzAvQK+1RfYWwkJbOUoXqFF6a+v2CWGnA0cuRXDf/U0J7XhTz4RKjCZ0Sq5FKkCNuEqrEjoqHBIy1P4wEJd+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732967; c=relaxed/simple;
	bh=0MTdJkE5kydAbSkgqDcjtzCop/ArAWw85WuS0EamvU8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ml+aavDFJGg0ZtoaFdhgpU1zLxeXoR3uZYM2kd/hO49gNxSe1DjrZA7iAp5g2061LWzl4rg9xCOd8E8eWcldcz34cGLxOHsg9+cJ75/L78B4PzZPqA9janH4iapgtZ3dezX7Yf/Fkv4TgWRnUMbjwwjCCLmcUu+31wDcs7+xUg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UJR/AslJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UJR/AslJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D8FDC4CEF1;
	Fri, 21 Nov 2025 13:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732967;
	bh=0MTdJkE5kydAbSkgqDcjtzCop/ArAWw85WuS0EamvU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UJR/AslJyCAntcA/HZOZt13kqkNuEmuPXWVRDA8jZrj5EgJcqXWF0IgO0DSi4A7Q7
	 t7UsKxZPqKhNwc/1TyIR/XBRSFJaPuyB+ZS6BCYMPsHOiG6AQV+R6oMBcJaze5xoBw
	 P1ekjlQe3JlsgmKECkY6LEKm5yVGEPA6jVtpE2Yw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Moti Haimovski <moti.haimovski@intel.com>,
	Koby Elbaz <koby.elbaz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 278/529] accel/habanalabs: support mapping cb with vmalloc-backed coherent memory
Date: Fri, 21 Nov 2025 14:09:37 +0100
Message-ID: <20251121130240.921091908@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 056e2ef44afb5..ceed6cfe2f919 100644
--- a/drivers/accel/habanalabs/gaudi/gaudi.c
+++ b/drivers/accel/habanalabs/gaudi/gaudi.c
@@ -4173,10 +4173,29 @@ static int gaudi_mmap(struct hl_device *hdev, struct vm_area_struct *vma,
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
index 01df5435d92c4..44b5678ea615c 100644
--- a/drivers/accel/habanalabs/gaudi2/gaudi2.c
+++ b/drivers/accel/habanalabs/gaudi2/gaudi2.c
@@ -6345,6 +6345,13 @@ static int gaudi2_mmap(struct hl_device *hdev, struct vm_area_struct *vma,
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



