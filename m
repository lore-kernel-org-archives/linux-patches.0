Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C005020A5EE;
	Thu, 12 Dec 2024 17:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024762; cv=none; b=DtilBtd9isDvv8RdpTmMf8SGxmidAAKWXR9u7Cd3450zF0BfqgBu1K20sikhBNtzNp4Vu70RNxuYbfhsTLWaPRXcGWTVw17AfjLW/70Kz9zuFKLt7huLMZMyaqYh8p/SsCamvUVjGjpa0dAPXf4B88/AjA80rsrW4MZFGMHaF/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024762; c=relaxed/simple;
	bh=ue71h0JcAU7aaiqYCvzCeiOy9YIhvIuQEmIs2S/rzr0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BEl/CAnD5eR3MBzPQyoAedE70jSjYsW8Ql3iebS+t5EZV06Sh8eHF7w86OSKaTYeXcIwvZYKOEBL5BglcvELN1g9ws/jRFllXIAP+D8GuerEBn2g+kGArECMIUG3Emj26Ac721cjE7YNkFBYH5uZWUCNXuxB3rWTL1PzU7BXL88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k7iv0qj5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k7iv0qj5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDFA4C4CECE;
	Thu, 12 Dec 2024 17:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024760;
	bh=ue71h0JcAU7aaiqYCvzCeiOy9YIhvIuQEmIs2S/rzr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k7iv0qj5ONmCBgu0GsDfswn0gO42k0gOX8oefSht4IoliGEV/WgnzahFicbhejHzW
	 eKSyqeYogI+t42XEgUlPwDMCmEvEcYqiZIHrjZZMnyA8Xq5MDlL7l8Vq6zewDoAE0O
	 XgVJsaTqW+aTFMBeiZeCOlcvM1K7uizlOFFz1DKM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lang Yu <lang.yu@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 402/459] drm/amdgpu: refine error handling in amdgpu_ttm_tt_pin_userptr
Date: Thu, 12 Dec 2024 16:02:20 +0100
Message-ID: <20241212144309.643863614@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lang Yu <lang.yu@amd.com>

[ Upstream commit 46186667f98fb7158c98f4ff5da62c427761ffcd ]

Free sg table when dma_map_sgtable() failed to avoid memory leak.

Signed-off-by: Lang Yu <lang.yu@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
index 0b162928a248b..8196a8e253266 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c
@@ -1006,7 +1006,7 @@ static int amdgpu_ttm_tt_pin_userptr(struct ttm_bo_device *bdev,
 	/* Map SG to device */
 	r = dma_map_sgtable(adev->dev, ttm->sg, direction, 0);
 	if (r)
-		goto release_sg;
+		goto release_sg_table;
 
 	/* convert SG to linear array of pages and dma addresses */
 	drm_prime_sg_to_page_addr_arrays(ttm->sg, ttm->pages,
@@ -1014,6 +1014,8 @@ static int amdgpu_ttm_tt_pin_userptr(struct ttm_bo_device *bdev,
 
 	return 0;
 
+release_sg_table:
+	sg_free_table(ttm->sg);
 release_sg:
 	kfree(ttm->sg);
 	ttm->sg = NULL;
-- 
2.43.0



