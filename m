Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CBAB2AD35;
	Sat, 12 Sep 2026 07:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198137; cv=none; b=h6QO4nxtvFisW1vOKR5sbpoQDlQQ70e2C9izOBblQxdVwmod06NQa+0AIL6yA3AQMAROypGF5P3jXULY1jTTF0sKNH2WjuxbP6JXDMSv1ctTRO10wgKEfbfx+UYewGfCoIoDkL1czO09Oy97MU0Tm2BTyOQIR8b36a+Jy3BKNfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198137; c=relaxed/simple;
	bh=GSjjz6TY9ZsrsBrn3b40y4d6sgTORQl2EmH5/rQY2tw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l2PmP6hkN43XAjAX93MvpwyGqwhS3XZBZ99TbX6Id7amd/Gu41NlKFc4wjlrs9AjghKxLvkJnC/Ks4zBr02ZdnzSYd8ZI1KSQ1R9YvNd/Y39T/BdlTIoFzzJN5hqoLbh+VWYotGbhA1S1DpjDgsxy4znwVq5STStFN7JGHX1Z2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U+heCQig; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U+heCQig"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1A7D1F000FF;
	Sat, 12 Sep 2026 07:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198135;
	bh=hbcmqgHhLqLPs6m6LAVDPWBt3yw6fx0/avi+bkc5QvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U+heCQigi6cAjxAERNB+Flgw2fzid7mDQeQfrOhF1gW+I7yetH6AXMFdjjvzKgBs0
	 1CusshOdMIqPCE4GXXgEQD+nWTWKVOP84NpGUPhZwMTaE6GkVHj6Rh6YhNFx9qfVGn
	 n2coHU4T9S+MuhO14OzQpsLJfLjkIlgI2sFc23zA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geoffrey McRae <geoffrey.mcrae@amd.com>,
	Amber Lin <amber.lin@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0276/1815] drm/amdgpu/mes: Fix hung_queue_db_array loop limit for multi-XCC
Date: Sat, 12 Sep 2026 08:33:46 +0200
Message-ID: <20260912065655.445654365@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geoffrey McRae <geoffrey.mcrae@amd.com>

[ Upstream commit 2c256086a363f01f9840a57949506eccf5c990a6 ]

The loop iterated only AMDGPU_MAX_MES_PIPES times, leaving entries
uninitialized for multi-XCC GPUs. This causes null pointer dereferences
when accessing arrays indexed by XCC ID >= 2. Extend the loop to cover
all XCCs (AMDGPU_MAX_MES_PIPES * num_xcc), matching other per-XCC
arrays.

Fixes: a132fc9bc2f8 ("drm/amdgpu: Fixup boost mes detect hang array size")
Signed-off-by: Geoffrey McRae <geoffrey.mcrae@amd.com>
Reviewed-by: Amber Lin <amber.lin@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_mes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_mes.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_mes.c
index e3972673fd641..c47e5ffd3d0c7 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_mes.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_mes.c
@@ -237,7 +237,7 @@ int amdgpu_mes_init(struct amdgpu_device *adev)
 	}
 
 	if (adev->mes.hung_queue_db_array_size) {
-		for (i = 0; i < AMDGPU_MAX_MES_PIPES; i++) {
+		for (i = 0; i < AMDGPU_MAX_MES_PIPES * num_xcc; i++) {
 			r = amdgpu_bo_create_kernel(adev,
 						    adev->mes.hung_queue_db_array_size * sizeof(u32),
 						    PAGE_SIZE,
-- 
2.53.0



