Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B9661DE2C0;
	Wed, 19 Mar 2025 14:35:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394953; cv=none; b=BHTTRke5DgGlkhWUXDknG9T2JX4ynay49RPjVoaZqxkAuSbCbnF2cxL5wXexIR04XYL3RQC/mYfDwIY/0mW3fpsIJDLMmLbTzD6PO7WLUm3wXeIlMVby+s/4fE8jYe+oynAZgZSys79xH8Kh7L/DtCoMZVC7qMU5v18tqTrQ+J0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394953; c=relaxed/simple;
	bh=qyG5tfLAtdN3xc+oQtVvUgdWsDb9r00kkSfg9JH8hFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rSRx7F67M1NpracuaqF7o+VF2sgEk7MeZvaJ/MN29x13RSI47flo+/zWsk/H6a6wyBOQ5lUqWTRFO78s22CN3zkwzqtzjpl88AXw8e2d/TDAdDssV7NlnIYC3Oi2jOiYV73w+chdksNvQpi5rSc9C413YiE2Afg8w9GQ9rvCDzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rcPn/Jv4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rcPn/Jv4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69520C4CEE4;
	Wed, 19 Mar 2025 14:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394953;
	bh=qyG5tfLAtdN3xc+oQtVvUgdWsDb9r00kkSfg9JH8hFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rcPn/Jv47lpMsc8ZlSGAZPA9UYB9TzoybJgquOdMQzKJaEoRHPQaxGqigNpmHM0CO
	 5TONq92x74scZ+zTxjdZBDgS5ygcFOWh64HjZJ35zR4fs3/4TEp3OtGpMq0YhEZU1Z
	 PW/TETvSv6kX/pBbxNVC9ek2xa8bNih3iVODyukQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Natalie Vock <natalie.vock@gmx.de>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.13 179/241] drm/amdgpu: NULL-check BOs backing store when determining GFX12 PTE flags
Date: Wed, 19 Mar 2025 07:30:49 -0700
Message-ID: <20250319143032.159638204@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
@@ -528,8 +528,9 @@ static void gmc_v12_0_get_vm_pte(struct
 
 	bo_adev = amdgpu_ttm_adev(bo->tbo.bdev);
 	coherent = bo->flags & AMDGPU_GEM_CREATE_COHERENT;
-	is_system = (bo->tbo.resource->mem_type == TTM_PL_TT) ||
-		(bo->tbo.resource->mem_type == AMDGPU_PL_PREEMPT);
+	is_system = bo->tbo.resource &&
+		(bo->tbo.resource->mem_type == TTM_PL_TT ||
+		 bo->tbo.resource->mem_type == AMDGPU_PL_PREEMPT);
 
 	if (bo && bo->flags & AMDGPU_GEM_CREATE_GFX12_DCC)
 		*flags |= AMDGPU_PTE_DCC;


