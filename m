Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55A561A841C;
	Wed, 19 Mar 2025 14:39:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395144; cv=none; b=SNu2vdjn2OIkUCIewI01qVw6sZX1XPXtS172qS6MpLSCBI08G1wyaU6ncXBS7AdzcurMwcWXKpXIpj5OHYpIoPpOFDtA/BmRSs0PupM50SuX0/6BH6UpZPalRkeEjiZkaBKwd6qjL9cDHvMdb4dyWNhPlL4T1dzio1CbB2VQgBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395144; c=relaxed/simple;
	bh=iX1OqZY2rZGviVxUK5qI42O0aIvxe13gDil03XrF8tc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=C6GGP6Y89/edYLjTNcF0VMTT/3Ob71gUp51yAWoRE/TmlCgCb3DRUvTOCMwBPQ/2UF3gAvGSglguGXOJRlEzthpupLpGcfyd+kjdMOxYGfE9DJqTLivt7V55q2uXkAZhRMSbWKVZs9TJbUSI8+sauKJsbaoDFnmM0m1ceBSFEWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n1/mK4tl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n1/mK4tl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C321C4CEE4;
	Wed, 19 Mar 2025 14:39:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395144;
	bh=iX1OqZY2rZGviVxUK5qI42O0aIvxe13gDil03XrF8tc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n1/mK4tlwMJ3gyHvyUtjxVVPCJMetoIH/SpEebPkHGwlzxIdHcJ3hxNnMnibR2uhR
	 QIWTvmPglxFGaocjO8W15g8M0m6HOf9h88BVuPgFN9Ael3CbZ8ewq/+2qltVD0iUSj
	 MrsCEi4TCwA1o+DPxNEaCw6ARrrNvkTr9/ULtspk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Natalie Vock <natalie.vock@gmx.de>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 174/231] drm/amdgpu: NULL-check BOs backing store when determining GFX12 PTE flags
Date: Wed, 19 Mar 2025 07:31:07 -0700
Message-ID: <20250319143031.139634805@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Natalie Vock <natalie.vock@gmx.de>

commit 6cc30748e17ea2a64051ceaf83a8372484e597f1 upstream.

PRT BOs may not have any backing store, so bo->tbo.resource will be
NULL. Check for that before dereferencing.

Fixes: 0cce5f285d9a ("drm/amdkfd: Check correct memory types for is_system variable")
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Natalie Vock <natalie.vock@gmx.de>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 3e3fcd29b505cebed659311337ea03b7698767fc)
Cc: stable@vger.kernel.org # 6.12.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/gmc_v12_0.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/gmc_v12_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gmc_v12_0.c
@@ -525,8 +525,9 @@ static void gmc_v12_0_get_vm_pte(struct
 
 	bo_adev = amdgpu_ttm_adev(bo->tbo.bdev);
 	coherent = bo->flags & AMDGPU_GEM_CREATE_COHERENT;
-	is_system = (bo->tbo.resource->mem_type == TTM_PL_TT) ||
-		(bo->tbo.resource->mem_type == AMDGPU_PL_PREEMPT);
+	is_system = bo->tbo.resource &&
+		(bo->tbo.resource->mem_type == TTM_PL_TT ||
+		 bo->tbo.resource->mem_type == AMDGPU_PL_PREEMPT);
 
 	if (bo && bo->flags & AMDGPU_GEM_CREATE_GFX12_DCC)
 		*flags |= AMDGPU_PTE_DCC;


