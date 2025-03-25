Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C72B826FA78;
	Tue, 25 Mar 2025 12:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906398; cv=none; b=KsBIqV/Coy3A5a32qzUDUT2/a3R0duBAJOZb0efc/LSbTXEFwI27lfs7h3PKKx4jIMEekEYgO2mjMSoseFKDAf4vM4FV+5z2NINNghJ+PnpLbSk3daOfiVOzuKyd1gMN9aPpeTPVoniysyq20IsuW/TTz2YjEo/Rizu+MOMxdKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906398; c=relaxed/simple;
	bh=yguvyvS1Jh++xtMl0gm3rU5hodbeKIGQDa6Idvsv8Xo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XjlA6A1b5BBh54NufjUxAQgisa9EcWChKtaVAO0+4ogUMg/kRpETIV8Ve4as0EjeIbK/lARoPd5mkT8rjWmrycyUu+RohVPdpBC5VeDzVXb5MzZXj7sV1aoKGf6wbmspIEXn4TlBemDhfWLroc6gTeA5An2v6IxkRu8tI6hPyqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fgf2HS0L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fgf2HS0L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76BB3C4CEF0;
	Tue, 25 Mar 2025 12:39:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906398;
	bh=yguvyvS1Jh++xtMl0gm3rU5hodbeKIGQDa6Idvsv8Xo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fgf2HS0Lw9xSiGXCtGkYV8HtHioGKr633Inqa+oOwWrkOzR3nJKTNfnnvZ5gkUxyb
	 mWQmivPe+dGBejLRgPn7c1x16Q0Vj/Nv9CUa7mHksP46yKHnlZkHcmXb8ICPTaPAvj
	 qHBwOu+fh25m8zDN8NDrnjXQRXhgwj+nMq+cQVDo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Belanger <david.belanger@amd.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 095/116] drm/amdgpu: Restore uncached behaviour on GFX12
Date: Tue, 25 Mar 2025 08:23:02 -0400
Message-ID: <20250325122151.637884730@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.207086105@linuxfoundation.org>
References: <20250325122149.207086105@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: David Belanger <david.belanger@amd.com>

commit 35b6162bb790555ad56b7f0d120e307b8334d778 upstream.

Always use MTYPE_UC if UNCACHED flag is specified.

This makes kernarg region uncached and it restores
usermode cache disable debug flag functionality.

Do not set MTYPE_UC for COHERENT flag, on GFX12 coherence is handled by
shader code.

Signed-off-by: David Belanger <david.belanger@amd.com>
Reviewed-by: Felix Kuehling <felix.kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit eb6cdfb807d038d9b9986b5c87188f28a4071eae)
Cc: stable@vger.kernel.org # 6.12.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/gmc_v12_0.c |   22 ++--------------------
 drivers/gpu/drm/amd/amdkfd/kfd_svm.c   |    8 +-------
 2 files changed, 3 insertions(+), 27 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/gmc_v12_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gmc_v12_0.c
@@ -498,9 +498,6 @@ static void gmc_v12_0_get_vm_pte(struct
 				 uint64_t *flags)
 {
 	struct amdgpu_bo *bo = mapping->bo_va->base.bo;
-	struct amdgpu_device *bo_adev;
-	bool coherent, is_system;
-
 
 	*flags &= ~AMDGPU_PTE_EXECUTABLE;
 	*flags |= mapping->flags & AMDGPU_PTE_EXECUTABLE;
@@ -516,26 +513,11 @@ static void gmc_v12_0_get_vm_pte(struct
 		*flags &= ~AMDGPU_PTE_VALID;
 	}
 
-	if (!bo)
-		return;
-
-	if (bo->flags & (AMDGPU_GEM_CREATE_COHERENT |
-			       AMDGPU_GEM_CREATE_UNCACHED))
-		*flags = AMDGPU_PTE_MTYPE_GFX12(*flags, MTYPE_UC);
-
-	bo_adev = amdgpu_ttm_adev(bo->tbo.bdev);
-	coherent = bo->flags & AMDGPU_GEM_CREATE_COHERENT;
-	is_system = bo->tbo.resource &&
-		(bo->tbo.resource->mem_type == TTM_PL_TT ||
-		 bo->tbo.resource->mem_type == AMDGPU_PL_PREEMPT);
-
 	if (bo && bo->flags & AMDGPU_GEM_CREATE_GFX12_DCC)
 		*flags |= AMDGPU_PTE_DCC;
 
-	/* WA for HW bug */
-	if (is_system || ((bo_adev != adev) && coherent))
-		*flags = AMDGPU_PTE_MTYPE_GFX12(*flags, MTYPE_NC);
-
+	if (bo && bo->flags & AMDGPU_GEM_CREATE_UNCACHED)
+		*flags = AMDGPU_PTE_MTYPE_GFX12(*flags, MTYPE_UC);
 }
 
 static unsigned gmc_v12_0_get_vbios_fb_size(struct amdgpu_device *adev)
--- a/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_svm.c
@@ -1276,13 +1276,7 @@ svm_range_get_pte_flags(struct kfd_node
 		break;
 	case IP_VERSION(12, 0, 0):
 	case IP_VERSION(12, 0, 1):
-		if (domain == SVM_RANGE_VRAM_DOMAIN) {
-			if (bo_node != node)
-				mapping_flags |= AMDGPU_VM_MTYPE_NC;
-		} else {
-			mapping_flags |= coherent ?
-				AMDGPU_VM_MTYPE_UC : AMDGPU_VM_MTYPE_NC;
-		}
+		mapping_flags |= AMDGPU_VM_MTYPE_NC;
 		break;
 	default:
 		mapping_flags |= coherent ?


