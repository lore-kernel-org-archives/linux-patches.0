Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2FE933B6C4;
	Tue, 11 Nov 2025 01:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823160; cv=none; b=reyYAXqU0I/+SY2WI7B3/iofisKUvh0aPOInfBOo/Jb2X1q6L24LuwzApGkWT3bgCZ2WjdXH4n/3J76K0JMFtzysrDr7J/yNzkOxwX/LguIxjFJ3PrrqmjFDdXwXl+M6U4UAT70Hc/brXP/gExr66FvR7kD5QC0FuoCp/qEJEkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823160; c=relaxed/simple;
	bh=7u1xTAEwskNK19el2A6az/HWu+kNwujk7F322NoPgcw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XHV1XmvDGxzt+F0jZk+XVipHKV1SnFUVa/Xb5C20vADdhzfZdRvWO25N0SAsOtFaKLBK7e9MJGK7z0jIhbSbQ17fSYbjOhtkMl4jD3cRz86OwGu2HAIDxgu2ElMBtOYD1DTGIlx7V8/adQ7mUeytXE00z+Py3VHYx14/p6EwdfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bSJfxXai; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bSJfxXai"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71E21C4CEF5;
	Tue, 11 Nov 2025 01:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823160;
	bh=7u1xTAEwskNK19el2A6az/HWu+kNwujk7F322NoPgcw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bSJfxXaiBQsgsIfIupS+nqUkWiVNxfaJiDglC3eNfJBLrz+lbtGG5/bo9WNSdPC+F
	 Zro6opdZ/kwUKKtbscmytCAvKJGBLa83bdYgZJWjUVuR34glIH5qo1TOAYJyYzXWzM
	 MME2H9IPOF2z+hjPuu4qwOYKtmnHJetNbI4FeMG8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Auld <matthew.auld@intel.com>,
	Maarten Lankhorst <dev@lankhorst.se>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 242/849] drm/xe: Fix oops in xe_gem_fault when running core_hotunplug test.
Date: Tue, 11 Nov 2025 09:36:52 +0900
Message-ID: <20251111004542.287342008@linuxfoundation.org>
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
index 50c79049ccea0..d07e23eb1a54d 100644
--- a/drivers/gpu/drm/xe/xe_bo.c
+++ b/drivers/gpu/drm/xe/xe_bo.c
@@ -1711,22 +1711,26 @@ static vm_fault_t xe_gem_fault(struct vm_fault *vmf)
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



