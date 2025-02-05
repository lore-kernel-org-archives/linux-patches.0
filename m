Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E40714B080;
	Wed,  5 Feb 2025 13:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763891; cv=none; b=sPpKikgGa5d+104Ji8+DgHwKgsCvM4qtEFD2lX8rjSgEojQ/AqczStQtBnqNAFrCQp8YhQFq6Vogc92DOE1kh+Jpd7i925jN48tntdFv8rDpVi7RfcOIqkcVmfy/l57tVchw089wM8WSMiQapzlRviS1vjGDlOjinwOjlfm0+1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763891; c=relaxed/simple;
	bh=xHwS27tT4DeJiGk2g8UUS9qs4szV4VvoD/q252rXxck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ONZP9Y0swq6oeuLkBPSdc5V8XtZF6EeHiRuMji8TW8K69WeNcZJnztKwOEI0v7B6G9d+1hyIMp7lwQXwjR4iHy3c1TpqXxw833Dyz2rUL6UmlS6LnlHak1ZLLdmm0QbFQq5dzn+qA4ph8vKJy3IUnL/jF3lm0JU9k8E1C+ZIDyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1LOjqb70; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1LOjqb70"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A563EC4CED1;
	Wed,  5 Feb 2025 13:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763891;
	bh=xHwS27tT4DeJiGk2g8UUS9qs4szV4VvoD/q252rXxck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1LOjqb70b9Hgsv/7R7PMmjeGogYSRgt/8XiUnvDRaH8viFd7nRs84zW9APcI0QiUi
	 MLjtPHQ4DkWWF2mPaDEln6pVu7vXtmcbmzeCAMLIj2adpPBvIeD+UDJU/xMPNzoXH5
	 tJxwerH+VH3QCDbPWSDf8zmxTldx7xci+5sXKKKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiang Liu <gerry@linux.alibaba.com>,
	Kent Russell <kent.russell@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 070/590] drm/amdgpu: tear down ttm range manager for doorbell in amdgpu_ttm_fini()
Date: Wed,  5 Feb 2025 14:37:05 +0100
Message-ID: <20250205134457.935848128@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 9f922ec50ea2d..ae9ca6788df78 100644
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



