Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FC9C303A2A;
	Sat, 25 Oct 2025 16:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761408800; cv=none; b=JhzEpI64wIw1NeCVZr8EAIyximdHaJx+LUUaJ/i7bWB4xdKI49OyZWOv6gwLQkpgQQOy8CGMMlRqDt7000/bMn82Z7Q3O/2YxKtggphRK6uBWtVYZJq77/pGguswEAiCDZhNYT65YKkGAnQiCgIkKsWb7vxr7aAD9iIy3XTbOCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761408800; c=relaxed/simple;
	bh=l/70gdh3ZUZQLsEO0xj3WYvStd3v1NRFUVAbh/vrMXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jKRSURbn+UV9dilFKA4wNiQI4pD5pZz1KZ68AVMxtgsqe9bfblFozNr1FFNUSnSgKHt+Z3MvwAj1UfCEBx2sJToZoK0n5EZ9LbkVoXUfMDV7t6bo01JohBRWlIspWNJmyEEYNunmScz2KG4csEgP6ZnJixB9S/Y9DTfP3J0Cfck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CYnhel15; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CYnhel15"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23804C4CEF5;
	Sat, 25 Oct 2025 16:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761408800;
	bh=l/70gdh3ZUZQLsEO0xj3WYvStd3v1NRFUVAbh/vrMXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CYnhel15I569i0ld3F+tIj/uv2dj4NeSis5TBT7YlMiGJCBpAAGqaZ/UCXHs8ow+O
	 jYlIzaKviqBVLPQJePeN1K5GnKfEBDx4vURu7aH6kgnckOZrZyvOUKtwIgssOguRui
	 XJY71CiDqWkpzR3FKwK4siDB9ImsEew097HgfBn9aSqsrhBoJhi7vAkWAYlS3HPyMX
	 5o0yphZKwPueEhCmZ0i7vf2hH+a+00W9020BtzhEGX8VYPijpYHawh8BacJAAcUpuh
	 Kddw8dS9GB60f+aAMUUptIIf2AhdTaql7LaxGV9QZbXB8ONkfxE6v1I1B3AjTlu3DP
	 5bTK8Xlg2Vn2g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Moti Haimovski <moti.haimovski@intel.com>,
	Koby Elbaz <koby.elbaz@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	alexander.deucher@amd.com,
	alexandre.f.demers@gmail.com,
	konstantin.sinyuk@intel.com,
	sharley.calzolari@intel.com,
	thorsten.blum@linux.dev,
	ariel.suller@intel.com
Subject: [PATCH AUTOSEL 6.17-6.6] accel/habanalabs: support mapping cb with vmalloc-backed coherent memory
Date: Sat, 25 Oct 2025 11:55:07 -0400
Message-ID: <20251025160905.3857885-76-sashal@kernel.org>
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

LLM Generated explanations, may be completely bogus:

YES Fix prevents a hard kernel BUG when user CBs are mmap’ed under an
IOMMU.

- `drivers/accel/habanalabs/gaudi/gaudi.c:4173` now marks the VMA with
  `VM_MIXEDMAP` whenever the coherent buffer lives in the vmalloc space,
  which is exactly what `dma_alloc_coherent(..., GFP_USER, …)` can
  return on IOMMU-backed systems; without this flag the later
  `vm_insert_page()` path hits `BUG_ON(vma->vm_flags & VM_PFNMAP)` in
  `mm/memory.c:2475`, crashing the kernel.
- The same guard is added for Gaudi2 in
  `drivers/accel/habanalabs/gaudi2/gaudi2.c:6842`, covering both current
  ASIC generations whose command buffers are allocated this way.
- Behaviour is unchanged for the legacy fallback path (`#else` branch
  using `remap_pfn_range`) and for non-vmalloc allocations, so
  regression risk is limited to setting one extra VMA flag only when
  needed.

Given that the pre-existing bug is an immediate kernel crash reachable
from userspace workloads and the fix is tightly scoped with no
architectural side effects, this is an excellent stable-candidate
backport. Suggested follow-up test: on affected hardware with IOMMU
enabled, mmap a user CB allocated via `GFP_USER` to confirm the BUG is
gone.

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

