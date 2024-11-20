Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 987D11AAE3B;
	Wed, 20 Nov 2024 12:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107552; cv=none; b=YUCGQDiWYhaZSAvVZRMAlomDm/BfW5URGCRhTFFbNhBHfChiYGihIuuoXoDjA+a+hYiEyv583QCji6sxWhAPLwrwFtDQ7BF4XyKYg4ZYkkQCAQ2anzfWaD0xsog/prfqterwcEw0knxnqSODhQj+DadES1WHS02wI35T8wke/XQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107552; c=relaxed/simple;
	bh=qUGqCumYOecAmSTcMYwpPXgS4TNidTZL+BR2Jl/ZqQw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DMIa4TWI01KuwabAGk3VHWf5aHyuGuve2WiOooRuCvp05h+dJ3emIj6708MBqgTgxjHSMXIETgijYFZS0v0vrkwmRmgafAXnhyrpGc+XBZzd6NfkiRQ8BgDZqhRRyasr6LtmgY9Ia2am6P9QEkpXlGhYCsx75OjQ6sPludhhIJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eG/okq+z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eG/okq+z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 682CBC4CED8;
	Wed, 20 Nov 2024 12:59:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107552;
	bh=qUGqCumYOecAmSTcMYwpPXgS4TNidTZL+BR2Jl/ZqQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eG/okq+zN9vC0xG+U00F+lJLehg4271+zIgFViUlJB7M38swLdsK+ggfXQ0kw8aid
	 5iJuNZR9Uj7U5hQOjZWxsMr6dgqHyZTZuYxPn/NreOiv/tAt5ENfIkVHzPwmvI234c
	 dDTZc3+0ggdU1CNKBfSRnXI6Y/+UH+XABxo3vYyE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.11 093/107] drm/amdgpu: fix check in gmc_v9_0_get_vm_pte()
Date: Wed, 20 Nov 2024 13:57:08 +0100
Message-ID: <20241120125631.812057350@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.681745345@linuxfoundation.org>
References: <20241120125629.681745345@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian König <christian.koenig@amd.com>

commit 0e5ac88fb918297a7484b67f2b484d43bed3fbbe upstream.

The coherency flags can only be determined when the BO is locked and that
in turn is only guaranteed when the mapping is validated.

Fix the check, move the resource check into the function and add an assert
that the BO is locked.

Signed-off-by: Christian König <christian.koenig@amd.com>
Fixes: d1a372af1c3d ("drm/amdgpu: Set MTYPE in PTE based on BO flags")
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 1b4ca8546f5b5c482717bedb8e031227b1541539)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c
@@ -1124,8 +1124,10 @@ static void gmc_v9_0_get_coherence_flags
 					 uint64_t *flags)
 {
 	struct amdgpu_device *bo_adev = amdgpu_ttm_adev(bo->tbo.bdev);
-	bool is_vram = bo->tbo.resource->mem_type == TTM_PL_VRAM;
-	bool coherent = bo->flags & (AMDGPU_GEM_CREATE_COHERENT | AMDGPU_GEM_CREATE_EXT_COHERENT);
+	bool is_vram = bo->tbo.resource &&
+		bo->tbo.resource->mem_type == TTM_PL_VRAM;
+	bool coherent = bo->flags & (AMDGPU_GEM_CREATE_COHERENT |
+				     AMDGPU_GEM_CREATE_EXT_COHERENT);
 	bool ext_coherent = bo->flags & AMDGPU_GEM_CREATE_EXT_COHERENT;
 	bool uncached = bo->flags & AMDGPU_GEM_CREATE_UNCACHED;
 	struct amdgpu_vm *vm = mapping->bo_va->base.vm;
@@ -1133,6 +1135,8 @@ static void gmc_v9_0_get_coherence_flags
 	bool snoop = false;
 	bool is_local;
 
+	dma_resv_assert_held(bo->tbo.base.resv);
+
 	switch (amdgpu_ip_version(adev, GC_HWIP, 0)) {
 	case IP_VERSION(9, 4, 1):
 	case IP_VERSION(9, 4, 2):
@@ -1251,9 +1255,8 @@ static void gmc_v9_0_get_vm_pte(struct a
 		*flags &= ~AMDGPU_PTE_VALID;
 	}
 
-	if (bo && bo->tbo.resource)
-		gmc_v9_0_get_coherence_flags(adev, mapping->bo_va->base.bo,
-					     mapping, flags);
+	if ((*flags & AMDGPU_PTE_VALID) && bo)
+		gmc_v9_0_get_coherence_flags(adev, bo, mapping, flags);
 }
 
 static void gmc_v9_0_override_vm_pte_flags(struct amdgpu_device *adev,


