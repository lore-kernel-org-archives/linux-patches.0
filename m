Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B0C6FC0B;
	Wed,  5 Feb 2025 14:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764460; cv=none; b=oDKw2FohPR5DxaW+lfy1ZTnvATmOZpFVOj8kwfQz5ucw2SF/CY2bevHcPhFyr6l5ULdav3gx+9r4XkOsmcHjRyLZwhcZ9JMqa6pmdhvkrMDHHXXmQYQP+QZ2hVR/ABfbCJj9uuxqgP8M4DrSud1NU140o4h5DWGTpjUhIOFcSDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764460; c=relaxed/simple;
	bh=OkuosoTmt1LFEzxJd4HcbaLHfFB7oTxcQdthHurTjyk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CY7u8wAiW/19LD3FNmNRntNzie8Ua646JQStgFXtejcKv5bGHliyprDgVDas2tdYOkoiBOK1WMcywgNbWtDxpwpNDefy+oI1ssYieKcbdLKu9Vb4fXnfaGxz1LRAFTkGCh4oxB40krG1HM6f6P7FdZDBefp5br7hKRPFKmkNa10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W/4tWrky; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W/4tWrky"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0669EC4CED1;
	Wed,  5 Feb 2025 14:07:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764460;
	bh=OkuosoTmt1LFEzxJd4HcbaLHfFB7oTxcQdthHurTjyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W/4tWrky0SEsz4NrXtdDxUfRnbHxfj8Wyy5JCAPHemcAEEs/rGx714BUDOamxPBhK
	 PJnPEFV+FnBqT+WPJX6ebcnievPCp2xJQh0E0f6aCCQdgexncz8O9/PdQuV+oat8Ey
	 u4EPvKW3HpTDFcHh9v8KOGl8gEdlkUWz2H54RsAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiang Liu <gerry@linux.alibaba.com>,
	Kent Russell <kent.russell@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 080/623] drm/amdgpu: tear down ttm range manager for doorbell in amdgpu_ttm_fini()
Date: Wed,  5 Feb 2025 14:37:02 +0100
Message-ID: <20250205134459.285186380@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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
index c8180cad0abdd..c4da62d111052 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
@@ -2065,6 +2065,7 @@ void amdgpu_ttm_fini(struct amdgpu_device *adev)
 	ttm_range_man_fini(&adev->mman.bdev, AMDGPU_PL_GDS);
 	ttm_range_man_fini(&adev->mman.bdev, AMDGPU_PL_GWS);
 	ttm_range_man_fini(&adev->mman.bdev, AMDGPU_PL_OA);
+	ttm_range_man_fini(&adev->mman.bdev, AMDGPU_PL_DOORBELL);
 	ttm_device_fini(&adev->mman.bdev);
 	adev->mman.initialized = false;
 	DRM_INFO("amdgpu: ttm finalized\n");
-- 
2.39.5



