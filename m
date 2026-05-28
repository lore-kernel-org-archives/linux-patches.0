Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89BE933F5B4;
	Thu, 28 May 2026 20:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999178; cv=none; b=dHC2TDvI/1cX47PqMoNM644fuCk2r9zpGPRDZeGQc3X7xJ4p4XrKeXdY34jvvW5LiZVrfBMyLlmqS0pKsDjG0RkbvFCmCnlINp6orlFkSTc1XzFC/14bpMQsZWQBh8i4z+or3ykuexgbGFN80/XyNHFujYHVpSId6kJjWPAOOD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999178; c=relaxed/simple;
	bh=iGoASSylRKnQWQ5doSV7yVpAmfkM0jqXdY+cCAw5A40=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jTH8D/eUoAV3zY5gBiTFnjQAZqW07Ang2bV7YeYsBzcqYukyCS12jLwDZ9M3tIPwSHOzlk+PX7V8eET6C221UAKPwadR+fvmsc7ESosmValsb/3HpCdrEE8/5/vkzb9r3RTiucYvvEmjva7fLXTTgs9TMvZ2iWrHXyGxFszWJrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EhiCwDpr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EhiCwDpr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8C221F000E9;
	Thu, 28 May 2026 20:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999177;
	bh=wVhkrk7mzg8WF/ftAaheZ9+jks1T/fPSVR6McmZaR4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EhiCwDpref8r/a6+iKrAPaX8rYCMR+WgOUFG4Tg3zioffKpmx1eFe4njogNwVkDZa
	 WSYn5Bpv8PguhvBg3AnaxtwfFiUULImZHgh+Qtz43YH0F+Uv1Qw66Ej1jD3mvrIgzz
	 Kxvy+qCyW18nE2F+TT31+paE+7k55brcPNWLiEEo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 399/461] drm/amdgpu/vce1: Check that the GPU address is < 128 MiB
Date: Thu, 28 May 2026 21:48:48 +0200
Message-ID: <20260528194659.022421005@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
User-Agent: quilt/0.69
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Kristóf <timur.kristof@gmail.com>

[ Upstream commit 9f907adb66d8369dd45412794a04845011503fa8 ]

When ensuring the low 32-bit address, make sure it is
less than 128 MiB, otherwise the VCE seems to fail to initialize.
This seems to be an undocumented limitation of the firmware
validation mechanism. Note that in case of VCE1 the BAR
address is zero and we can't change it also due to the
firmware validator.

When programming the mmVCE_VCPU_CACHE_OFFSETn registers,
don't AND them with a mask. This is incorrect because
the register mask is actually 0x0fffffff and useless because
we already ensure the addresses are below the limit.

Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit e729ae5f3ac73c861c062080ac8c3d666c972404)
Stable-dep-of: 3e5a1d5bb2ff ("drm/amdgpu/vce1: Fix VCE 1 firmware size and offsets")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/vce_v1_0.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/vce_v1_0.c b/drivers/gpu/drm/amd/amdgpu/vce_v1_0.c
index 9ae4246185560..0b69773b71848 100644
--- a/drivers/gpu/drm/amd/amdgpu/vce_v1_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/vce_v1_0.c
@@ -318,17 +318,17 @@ static int vce_v1_0_mc_resume(struct amdgpu_device *adev)
 
 	offset =  adev->vce.gpu_addr + AMDGPU_VCE_FIRMWARE_OFFSET;
 	size = VCE_V1_0_FW_SIZE;
-	WREG32(mmVCE_VCPU_CACHE_OFFSET0, offset & 0x7fffffff);
+	WREG32(mmVCE_VCPU_CACHE_OFFSET0, offset);
 	WREG32(mmVCE_VCPU_CACHE_SIZE0, size);
 
 	offset += size;
 	size = VCE_V1_0_STACK_SIZE;
-	WREG32(mmVCE_VCPU_CACHE_OFFSET1, offset & 0x7fffffff);
+	WREG32(mmVCE_VCPU_CACHE_OFFSET1, offset);
 	WREG32(mmVCE_VCPU_CACHE_SIZE1, size);
 
 	offset += size;
 	size = VCE_V1_0_DATA_SIZE;
-	WREG32(mmVCE_VCPU_CACHE_OFFSET2, offset & 0x7fffffff);
+	WREG32(mmVCE_VCPU_CACHE_OFFSET2, offset);
 	WREG32(mmVCE_VCPU_CACHE_SIZE2, size);
 
 	WREG32_P(mmVCE_LMI_CTRL2, 0x0, ~0x100);
@@ -532,12 +532,16 @@ static int vce_v1_0_early_init(struct amdgpu_ip_block *ip_block)
  * To accomodate that, we put GART to the LOW address range
  * and reserve some GART pages where we map the VCPU BO,
  * so that it gets a 32-bit address.
+ *
+ * The BAR address is zero and we can't change it
+ * due to the firmware validation mechanism.
+ * It seems that it fails to initialize if the address is >= 128 MiB.
  */
 static int vce_v1_0_ensure_vcpu_bo_32bit_addr(struct amdgpu_device *adev)
 {
 	u64 gpu_addr = amdgpu_bo_gpu_offset(adev->vce.vcpu_bo);
 	u64 bo_size = amdgpu_bo_size(adev->vce.vcpu_bo);
-	u64 max_vcpu_bo_addr = 0xffffffff - bo_size;
+	u64 max_vcpu_bo_addr = 0x07ffffff - bo_size;
 	u64 num_pages = ALIGN(bo_size, AMDGPU_GPU_PAGE_SIZE) / AMDGPU_GPU_PAGE_SIZE;
 	u64 pa = amdgpu_gmc_vram_pa(adev, adev->vce.vcpu_bo);
 	u64 flags = AMDGPU_PTE_READABLE | AMDGPU_PTE_WRITEABLE | AMDGPU_PTE_VALID;
-- 
2.53.0



