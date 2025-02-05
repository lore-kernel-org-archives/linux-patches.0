Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15C0313C9C4;
	Wed,  5 Feb 2025 13:48:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763337; cv=none; b=RH0kwGSPFnwxQ9Zj9fUxOyhzAIL+bCnhAcMMunwW+8oIZT5+09LMu3Y0HhB8U70T7Jyx6Z+g8VWzMw4zfHA9+QU2OaB8dBV8xROgfEzLhH7U+ZZ0DqGUozDG2dn1XPPhyz2BSPYoMs/zOnUX/tb3gBxM14QliygIZcTjLw30hlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763337; c=relaxed/simple;
	bh=e40hUqg96V7BbVRbYKOkxHmkhF0bSWlqFhAy0OpW8BU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mDFDVfUcKBm/bbP9Ms7dhg7Jing9zAcdKXkhKSa/OZ31X72lhIbmAW1L1aTLIdKk6YUr0ZlsKmGyuiPj0q+ldzbDhhXKpBdSwzPIRf7OCbxXKb8eziJTgZmMBTzw3sLe/IazRgKVOEQ+2lzV4lnspEw+EExhHF4jfGebbAE6jEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BsMgPMcw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BsMgPMcw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75D3CC4CED1;
	Wed,  5 Feb 2025 13:48:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763337;
	bh=e40hUqg96V7BbVRbYKOkxHmkhF0bSWlqFhAy0OpW8BU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BsMgPMcwMP7GVrEtI8J2P4YwIHJANPNvAxlqsAYccM5fF7y8HvBGnGfo7ercCZbfS
	 fvihgUcgJKY4sZh2ZSAs/w6d+jH/YFCWgbWMtqccWKw9sqbfadl0O5or/f9AHjngEO
	 +V1FcxkwaKkv0YcsBwtSEIiFGpwjyXHUXLGJs1IY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiang Liu <gerry@linux.alibaba.com>,
	Kent Russell <kent.russell@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 045/393] drm/amdgpu: tear down ttm range manager for doorbell in amdgpu_ttm_fini()
Date: Wed,  5 Feb 2025 14:39:24 +0100
Message-ID: <20250205134422.025409749@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiang Liu <gerry@linux.alibaba.com>

[ Upstream commit 60a2c0c12b644450e420ffc42291d1eb248bacb7 ]

Tear down ttm range manager for doorbell in function amdgpu_ttm_fini(),
to avoid memory leakage.

Fixes: 792b84fb9038 ("drm/amdgpu: initialize ttm for doorbells")
Signed-off-by: Jiang Liu <gerry@linux.alibaba.com>
Signed-off-by: Kent Russell <kent.russell@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
index c89264242bea3..69dfc3da5e15c 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
@@ -2049,6 +2049,7 @@ void amdgpu_ttm_fini(struct amdgpu_device *adev)
 	ttm_range_man_fini(&adev->mman.bdev, AMDGPU_PL_GDS);
 	ttm_range_man_fini(&adev->mman.bdev, AMDGPU_PL_GWS);
 	ttm_range_man_fini(&adev->mman.bdev, AMDGPU_PL_OA);
+	ttm_range_man_fini(&adev->mman.bdev, AMDGPU_PL_DOORBELL);
 	ttm_device_fini(&adev->mman.bdev);
 	adev->mman.initialized = false;
 	DRM_INFO("amdgpu: ttm finalized\n");
-- 
2.39.5



