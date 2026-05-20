Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C5B7221F2F;
	Wed, 20 May 2026 16:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295196; cv=none; b=oZWR42Wt4l6hFfEktKUTVBLkXpZUceM01HG4FdMYhzxkmR0dV1RTca6gsrWHAPZhI/p0Bch85GD5d2w4zKZWXc2EK8w6UniO9rWqWT/1ORfWbZORx0J4Li3zVKn5kdp5XCuiopUHa/Yb+Sl0zbFP00Yhw64OiWdtJPdpdOG0sWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295196; c=relaxed/simple;
	bh=gjWT0C+qquBlWgQk5So8qar7c9nYav3KApgyxe7dkw4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RAZIjPVKh647l+rXt8tSVSvRdYgMIUsGvCEAXZ44aioyP1+2FEtHeKHW/4u9Wujx1oP7VKB10y9cpnh3P7mCsDpySxRERPYt8MqKBy3KvzRFKuwf6XvMSfx0Gha/8O7SlQqfSkuzwxdDbmMHCpPjq/Bz/RVbpO6WJbGaktJHPjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j6iY4NtJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j6iY4NtJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 043B91F000E9;
	Wed, 20 May 2026 16:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295195;
	bh=qtVXUu6Of3P93hnL//HpA1qlQz7RzZeO/PB6XXKujN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j6iY4NtJMpcQX/LX8kCsPAqc8qzUGEB5tVQiElBQ+UvQ8evDyk5xQKDQ/GtcvWPqN
	 tB9+bQj1s1Pmjxtp86OLuAwJrfhOlE6gTwu+uEmA/kDqryRL/uzeIXzbUT7yb0a4ec
	 OW1TuMCwmOnbk0S1Lw5rbnwZ9Edv1qzwBCJ6QK/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Ellen Pan <yunru.pan@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>,
	Bokun Zhang <bokun.zhang@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0300/1146] drm/amdgpu: Remove dead negative offset check in amdgpu_virt_init_critical_region()
Date: Wed, 20 May 2026 18:09:10 +0200
Message-ID: <20260520162154.999434316@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

From: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>

[ Upstream commit 4fce3dfab54d60ebaff1c7a9020a730a0708b705 ]

amdgpu_virt_init_critical_region() stores init_hdr_offset as u64.
The subsequent check for init_hdr_offset < 0 is therefore always false.

Drop the unreachable validation and rely on the existing
check_add_overflow() and VRAM end bounds check for offset validation.

This resolves the Smatch warning about comparing an unsigned value
against zero.

drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c:953 amdgpu_virt_init_critical_region() warn: unsigned 'init_hdr_offset' is never less than zero.

Fixes: 07009df6494d ("drm/amdgpu: Introduce SRIOV critical regions v2 during VF init")
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Ellen Pan <yunru.pan@amd.com>
Cc: Lijo Lazar <lijo.lazar@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Christian König <christian.koenig@amd.com>
Signed-off-by: Srinivasan Shanmugam <srinivasan.shanmugam@amd.com>
Reviewed-by: Bokun Zhang <bokun.zhang@amd.com>
Reviewed-by: Ellen Pan <yunru.pan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c
index 275745aa58292..1e284ecad2170 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c
@@ -950,11 +950,6 @@ int amdgpu_virt_init_critical_region(struct amdgpu_device *adev)
 	if (adev->virt.req_init_data_ver != GPU_CRIT_REGION_V2)
 		return 0;
 
-	if (init_hdr_offset < 0) {
-		dev_err(adev->dev, "Invalid init header offset\n");
-		return -EINVAL;
-	}
-
 	vram_size = RREG32(mmRCC_CONFIG_MEMSIZE);
 	if (!vram_size || vram_size == U32_MAX)
 		return -EINVAL;
-- 
2.53.0



