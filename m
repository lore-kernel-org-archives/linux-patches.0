Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B89872571AB;
	Tue, 25 Mar 2025 12:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906035; cv=none; b=PpPUNhtMDlwqvfcRQNG/bkxOy8J5X7Q+2gLmym9+rJ8+vRYocGXU1JRkBTe6mtjkXs2b0koHPOiei+Cl6GRTcPwPiTrZzNVM2q2C2ZQ+ZvjFY8pv2FN7YPZ16ZEsJskegL/XIomCwTNy41qq4X4lTwZ7+KU8DIpPz3kBQ0ZQ8wY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906035; c=relaxed/simple;
	bh=yLQ3WbUaTMil23v0t/bzXpYS8b1Hm3s0rtZHLK/so14=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iIWSE6OBsxjBlcXFv4xZqLy61FOcRPmUE3OQ9e5kZ4PzJoMqgaC2gvhv15k/kuxtFYbQgXa6eCZCHqJ/mq2Fx2JTRbTn1V0jXQP7itNs6r4P0IjnqmOrOImoVDx9P3ach1LP03G2trtgRcPndnX6uyFl165xe7uJMQ/J46EWjBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EV/am8Rm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EV/am8Rm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12C90C4CEE4;
	Tue, 25 Mar 2025 12:33:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906035;
	bh=yLQ3WbUaTMil23v0t/bzXpYS8b1Hm3s0rtZHLK/so14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EV/am8RmiNvS98mm7mGJIcK/IN9ilBR+DpLFSmpJk5hS2PqpC9z7K5MzCOAf6GyzV
	 Njl36nicYQP6sWR1nZWgfCOIQRY5sq8Dq1PwiNB+bGXbIWtdrEkALH2kqauaTBaHb9
	 Nefq8cAFbdPN0GLnmZ3PMmH+P2yPXhPgXJBFGBbo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Belanger <david.belanger@amd.com>,
	Felix Kuehling <felix.kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.13 100/119] drm/amdgpu: Restore uncached behaviour on GFX12
Date: Tue, 25 Mar 2025 08:22:38 -0400
Message-ID: <20250325122151.612259868@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122149.058346343@linuxfoundation.org>
References: <20250325122149.058346343@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
@@ -501,9 +501,6 @@ static void gmc_v12_0_get_vm_pte(struct
 				 uint64_t *flags)
 {
 	struct amdgpu_bo *bo = mapping->bo_va->base.bo;
-	struct amdgpu_device *bo_adev;
-	bool coherent, is_system;
-
 
 	*flags &= ~AMDGPU_PTE_EXECUTABLE;
 	*flags |= mapping->flags & AMDGPU_PTE_EXECUTABLE;
@@ -519,26 +516,11 @@ static void gmc_v12_0_get_vm_pte(struct
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


