Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73B4226CE37;
	Tue, 11 Nov 2025 01:05:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823142; cv=none; b=VLjh2zTH5/JN0K6IoWH6umT9EacNrX5NAT5/HG8f8a4bXg96tpRmDYbIzTrb0k8U7BpLWch4L0gZEUQf16dFabH2OrUDr+Fq4V6YvKCirtAbDerEgCGoLNPaRaofVvjILdVEwSWDXRK15LZgIBYsP0YIc5BXSUjjk1F4oqbaJuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823142; c=relaxed/simple;
	bh=1KqUIx3DzQwDGXHoSPGcRaNUSB2kH0XaO3IECzcvtPY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q+7qR/fn9kNj9srZDztt3lydETDvoA/CJXqOVB11ip7n8IXDoWAyHa4pjN0V061/LGfDagrH5pDIoCOCHhZjokPDS3xiXdcLmsMXRsH5v77PO2ZdaKe8f13bmfO76AeaC8jx+F9vMYVRvTqNpgkTYhA4KQxEL2+VJdx0zq8JZPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h8ZQ4uN3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h8ZQ4uN3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E589CC16AAE;
	Tue, 11 Nov 2025 01:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823142;
	bh=1KqUIx3DzQwDGXHoSPGcRaNUSB2kH0XaO3IECzcvtPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h8ZQ4uN32uX10aynHf3mVg02okZq/N6MJU5L2gVsC5anYAoMu0e4/6f/Vsmn68MOg
	 FHv2c99DVJFAw/ouUqIL26dQi+Rax+2KuqHx9sdDK89P8kceCDaOSjaLMvGfhLAl6p
	 mZflNXmDM5nkAGKOHDrRW+ay7rh+B+eQRthNV6pk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Auld <matthew.auld@intel.com>,
	Maarten Lankhorst <dev@lankhorst.se>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 179/565] drm/xe: Fix oops in xe_gem_fault when running core_hotunplug test.
Date: Tue, 11 Nov 2025 09:40:35 +0900
Message-ID: <20251111004530.959519556@linuxfoundation.org>
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

From: Maarten Lankhorst <dev@lankhorst.se>

[ Upstream commit 1cda3c755bb7770be07d75949bb0f45fb88651f6 ]

I saw an oops in xe_gem_fault when running the xe-fast-feedback
testlist against the realtime kernel without debug options enabled.

The panic happens after core_hotunplug unbind-rebind finishes.
Presumably what happens is that a process mmaps, unlocks because
of the FAULT_FLAG_RETRY_NOWAIT logic, has no process memory left,
causing ttm_bo_vm_dummy_page() to return VM_FAULT_NOPAGE, since
there was nothing left to populate, and then oopses in
"mem_type_is_vram(tbo->resource->mem_type)" because tbo->resource
is NULL.

It's convoluted, but fits the data and explains the oops after
the test exits.

Reviewed-by: Matthew Auld <matthew.auld@intel.com>
Link: https://lore.kernel.org/r/20250715152057.23254-2-dev@lankhorst.se
Signed-off-by: Maarten Lankhorst <dev@lankhorst.se>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_bo.c | 28 ++++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_bo.c b/drivers/gpu/drm/xe/xe_bo.c
index b5058a35c4513..b71156e9976aa 100644
--- a/drivers/gpu/drm/xe/xe_bo.c
+++ b/drivers/gpu/drm/xe/xe_bo.c
@@ -1218,22 +1218,26 @@ static vm_fault_t xe_gem_fault(struct vm_fault *vmf)
 		ret = ttm_bo_vm_fault_reserved(vmf, vmf->vma->vm_page_prot,
 					       TTM_BO_VM_NUM_PREFAULT);
 		drm_dev_exit(idx);
+
+		if (ret == VM_FAULT_RETRY &&
+		    !(vmf->flags & FAULT_FLAG_RETRY_NOWAIT))
+			goto out;
+
+		/*
+		 * ttm_bo_vm_reserve() already has dma_resv_lock.
+		 */
+		if (ret == VM_FAULT_NOPAGE &&
+		    mem_type_is_vram(tbo->resource->mem_type)) {
+			mutex_lock(&xe->mem_access.vram_userfault.lock);
+			if (list_empty(&bo->vram_userfault_link))
+				list_add(&bo->vram_userfault_link,
+					 &xe->mem_access.vram_userfault.list);
+			mutex_unlock(&xe->mem_access.vram_userfault.lock);
+		}
 	} else {
 		ret = ttm_bo_vm_dummy_page(vmf, vmf->vma->vm_page_prot);
 	}
 
-	if (ret == VM_FAULT_RETRY && !(vmf->flags & FAULT_FLAG_RETRY_NOWAIT))
-		goto out;
-	/*
-	 * ttm_bo_vm_reserve() already has dma_resv_lock.
-	 */
-	if (ret == VM_FAULT_NOPAGE && mem_type_is_vram(tbo->resource->mem_type)) {
-		mutex_lock(&xe->mem_access.vram_userfault.lock);
-		if (list_empty(&bo->vram_userfault_link))
-			list_add(&bo->vram_userfault_link, &xe->mem_access.vram_userfault.list);
-		mutex_unlock(&xe->mem_access.vram_userfault.lock);
-	}
-
 	dma_resv_unlock(tbo->base.resv);
 out:
 	if (needs_rpm)
-- 
2.51.0



