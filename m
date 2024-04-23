Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46C94146A94;
	Tue, 23 Apr 2024 21:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908678; cv=none; b=BguiVanjoauNAtRlrt4nIeyW8RRDqud7q+4zr3XvmJH+mtNBl6/d+F/rBCLkz6o4/gjzoLsB8sRu7QWg5idcCos9eTEsJAujs4k9jYBXURkRvzteOoJ5xRHJApXOtRz/44yQPqXSs1JKkVGWXIYZUid7A0QUIRYA0IwNUZz86hU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908678; c=relaxed/simple;
	bh=Kh5ykcHSFA7dXCNS2c7niqhL1ibVubiqepHAHWG2XQA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eNKCtBmWAHruvFpiVCHb3l+4AOHuOQR6RIMNp9tWKXDb/zTNmBTmOxkfYPjHpRcKPuZjpeHISHyN0ip7jfVmu54bQ3JiiDMBtPhISe+i8Gj2QgfiY30mHCHaw1x0qE5TKQiuKhxLvxT/Ligyl9poEfne1nn3NCpJW94bzIoMpeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pCwAaOG/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pCwAaOG/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 117AAC116B1;
	Tue, 23 Apr 2024 21:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908678;
	bh=Kh5ykcHSFA7dXCNS2c7niqhL1ibVubiqepHAHWG2XQA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pCwAaOG/n5foS1VjGtbPtbksz8mrL6wsnE1zMX2bInTcUwfWQEFt/fwm+BlEhGQg7
	 A8WYkEiH/2wBB7aU/4kLYdABskdAzP9WPjA/UDVirxJmUApZsA7oLRcSd9jkspCb5X
	 nULqgPmpf4YuhcLsuo7+LM3fsTK9sobY3jU1ML7c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Likun Gao <Likun.Gao@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 002/141] drm/amdgpu: fix incorrect active rb bitmap for gfx11
Date: Tue, 23 Apr 2024 14:37:50 -0700
Message-ID: <20240423213853.435557465@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213853.356988651@linuxfoundation.org>
References: <20240423213853.356988651@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hawking Zhang <Hawking.Zhang@amd.com>

[ Upstream commit f9c35f4fffc6cb5bbb23f546f48c045aef012518 ]

GFX v11 changes RB_BACKEND_DISABLE related registers
from per SA to global ones. The approach to query active
rb bitmap needs to be changed accordingly. Query per
SE setting returns wrong active RB bitmap especially
in the case when some of SA are disabled. With the new
approach, driver will generate the active rb bitmap
based on active SA bitmap and global active RB bitmap.

Signed-off-by: Hawking Zhang <Hawking.Zhang@amd.com>
Reviewed-by: Likun Gao <Likun.Gao@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: bbca7f414ae9 ("drm/amdgpu: fix incorrect number of active RBs for gfx11")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c | 78 +++++++++++++++++---------
 1 file changed, 52 insertions(+), 26 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
index 66a6f7a37ebcf..ec40f88da00c3 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v11_0.c
@@ -1531,44 +1531,70 @@ static void gfx_v11_0_select_se_sh(struct amdgpu_device *adev, u32 se_num,
 	WREG32_SOC15(GC, 0, regGRBM_GFX_INDEX, data);
 }
 
-static u32 gfx_v11_0_get_rb_active_bitmap(struct amdgpu_device *adev)
+static u32 gfx_v11_0_get_sa_active_bitmap(struct amdgpu_device *adev)
 {
-	u32 data, mask;
+	u32 gc_disabled_sa_mask, gc_user_disabled_sa_mask, sa_mask;
+
+	gc_disabled_sa_mask = RREG32_SOC15(GC, 0, regCC_GC_SA_UNIT_DISABLE);
+	gc_disabled_sa_mask = REG_GET_FIELD(gc_disabled_sa_mask,
+					   CC_GC_SA_UNIT_DISABLE,
+					   SA_DISABLE);
+	gc_user_disabled_sa_mask = RREG32_SOC15(GC, 0, regGC_USER_SA_UNIT_DISABLE);
+	gc_user_disabled_sa_mask = REG_GET_FIELD(gc_user_disabled_sa_mask,
+						 GC_USER_SA_UNIT_DISABLE,
+						 SA_DISABLE);
+	sa_mask = amdgpu_gfx_create_bitmask(adev->gfx.config.max_sh_per_se *
+					    adev->gfx.config.max_shader_engines);
 
-	data = RREG32_SOC15(GC, 0, regCC_RB_BACKEND_DISABLE);
-	data |= RREG32_SOC15(GC, 0, regGC_USER_RB_BACKEND_DISABLE);
+	return sa_mask & (~(gc_disabled_sa_mask | gc_user_disabled_sa_mask));
+}
 
-	data &= CC_RB_BACKEND_DISABLE__BACKEND_DISABLE_MASK;
-	data >>= GC_USER_RB_BACKEND_DISABLE__BACKEND_DISABLE__SHIFT;
+static u32 gfx_v11_0_get_rb_active_bitmap(struct amdgpu_device *adev)
+{
+	u32 gc_disabled_rb_mask, gc_user_disabled_rb_mask;
+	u32 rb_mask;
 
-	mask = amdgpu_gfx_create_bitmask(adev->gfx.config.max_backends_per_se /
-					 adev->gfx.config.max_sh_per_se);
+	gc_disabled_rb_mask = RREG32_SOC15(GC, 0, regCC_RB_BACKEND_DISABLE);
+	gc_disabled_rb_mask = REG_GET_FIELD(gc_disabled_rb_mask,
+					    CC_RB_BACKEND_DISABLE,
+					    BACKEND_DISABLE);
+	gc_user_disabled_rb_mask = RREG32_SOC15(GC, 0, regGC_USER_RB_BACKEND_DISABLE);
+	gc_user_disabled_rb_mask = REG_GET_FIELD(gc_user_disabled_rb_mask,
+						 GC_USER_RB_BACKEND_DISABLE,
+						 BACKEND_DISABLE);
+	rb_mask = amdgpu_gfx_create_bitmask(adev->gfx.config.max_backends_per_se *
+					    adev->gfx.config.max_shader_engines);
 
-	return (~data) & mask;
+	return rb_mask & (~(gc_disabled_rb_mask | gc_user_disabled_rb_mask));
 }
 
 static void gfx_v11_0_setup_rb(struct amdgpu_device *adev)
 {
-	int i, j;
-	u32 data;
-	u32 active_rbs = 0;
-	u32 rb_bitmap_width_per_sh = adev->gfx.config.max_backends_per_se /
-					adev->gfx.config.max_sh_per_se;
+	u32 rb_bitmap_width_per_sa;
+	u32 max_sa;
+	u32 active_sa_bitmap;
+	u32 global_active_rb_bitmap;
+	u32 active_rb_bitmap = 0;
+	u32 i;
 
-	mutex_lock(&adev->grbm_idx_mutex);
-	for (i = 0; i < adev->gfx.config.max_shader_engines; i++) {
-		for (j = 0; j < adev->gfx.config.max_sh_per_se; j++) {
-			gfx_v11_0_select_se_sh(adev, i, j, 0xffffffff);
-			data = gfx_v11_0_get_rb_active_bitmap(adev);
-			active_rbs |= data << ((i * adev->gfx.config.max_sh_per_se + j) *
-					       rb_bitmap_width_per_sh);
-		}
+	/* query sa bitmap from SA_UNIT_DISABLE registers */
+	active_sa_bitmap = gfx_v11_0_get_sa_active_bitmap(adev);
+	/* query rb bitmap from RB_BACKEND_DISABLE registers */
+	global_active_rb_bitmap = gfx_v11_0_get_rb_active_bitmap(adev);
+
+	/* generate active rb bitmap according to active sa bitmap */
+	max_sa = adev->gfx.config.max_shader_engines *
+		 adev->gfx.config.max_sh_per_se;
+	rb_bitmap_width_per_sa = adev->gfx.config.max_backends_per_se /
+				 adev->gfx.config.max_sh_per_se;
+	for (i = 0; i < max_sa; i++) {
+		if (active_sa_bitmap & (1 << i))
+			active_rb_bitmap |= (0x3 << (i * rb_bitmap_width_per_sa));
 	}
-	gfx_v11_0_select_se_sh(adev, 0xffffffff, 0xffffffff, 0xffffffff);
-	mutex_unlock(&adev->grbm_idx_mutex);
 
-	adev->gfx.config.backend_enable_mask = active_rbs;
-	adev->gfx.config.num_rbs = hweight32(active_rbs);
+	active_rb_bitmap |= global_active_rb_bitmap;
+	adev->gfx.config.backend_enable_mask = active_rb_bitmap;
+	adev->gfx.config.num_rbs = hweight32(active_rb_bitmap);
 }
 
 #define DEFAULT_SH_MEM_BASES	(0x6000)
-- 
2.43.0



