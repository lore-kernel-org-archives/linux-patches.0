Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA80723D7FC;
	Tue, 11 Nov 2025 01:37:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825049; cv=none; b=TeXDXSmiK/0ABHxoskOq+1h08YvgmYqLde+E0+ccHWOATJfaQwZHDeMUv2Qx8Os9sr8/D3ztNRwa8nxWhf0z3ie8GMEXwuKAAv+zXab/llPuW2L530mTJWaPNh6ZpS0uHkT5ohQT6Vkg3YalGKDvraJ0QKsqLpWzOY+ozsX9Il4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825049; c=relaxed/simple;
	bh=7ScxooF8r9t9TR8s8Tyn/lt6bcLmwVsDVsB5kcmLYW0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e550BV6GJLGMZVVXZ0IYZS/lhaku0oxUIsX5rOk7VrKwqnEZo8DWxHiHAAFu0FqGhur6Sfi8EQpdnIT6jKfHtElg6+JHhfwCz03ZLhmXTvGWNVr7Y3k9nQ0gPL181w4WRmslExtrQsDKnJS6OYOUz9JEdQHzrKysgkBZ9FVXcKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f8DnzQ8+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f8DnzQ8+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AE9EC113D0;
	Tue, 11 Nov 2025 01:37:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825049;
	bh=7ScxooF8r9t9TR8s8Tyn/lt6bcLmwVsDVsB5kcmLYW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f8DnzQ8+Ep/ARktrKZsFi1kywpJs2Iuzl7nFX2V1VcERmuZ+tBTMV57McUkyY+Ei5
	 QPcHpJdgm1iYh+lWKkPC2NI+f+cyHD+Tir9ccQbUukI+KMP1mqFhcQsL33aD1K5nFA
	 Ka3DccWXiCAVflFTmoEuFDTOAnX8Ik22d7HOPYfg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Moti Haimovski <moti.haimovski@intel.com>,
	Koby Elbaz <koby.elbaz@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 639/849] accel/habanalabs: support mapping cb with vmalloc-backed coherent memory
Date: Tue, 11 Nov 2025 09:43:29 +0900
Message-ID: <20251111004551.877912421@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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



