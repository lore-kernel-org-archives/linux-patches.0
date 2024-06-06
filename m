Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4874196D99;
	Thu,  6 Jun 2024 14:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683002; cv=none; b=EoiG0dCmsYTZXPrJMSJnQH0b/cB57NMfJpCYV/tVvYIncuTo5CN374egwgCmBf+LYmuDBNlDHNNN8q3W6NQSt2rgvySGuWiyLqynJ3urX59W+5qgC9NrUnXsEK/r2P0aU/QisVd/5ZHhYZ9yRW9phN54CzyuTVGAyvN8GBXmdps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683002; c=relaxed/simple;
	bh=/ZYii4fqfJ5xz/vdGJDC/Y+QnKQZoutPbu7ReeGS6fA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K/eVlPpP65lOZ+Hoyu/vFR+XJO2yKLbjmlag32r8loa5C4vU0kQR2AAlj/KkQaAImXjjr1nRqEIXQ1ofad1L5cVOr1xAQfPHGCWLGAA/za70TExrTe4ty01XF/OHQOZ5yqv3IPSRChoRhSCXfSbWmsYoOu2Jl1RUCuiBsID+Szw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RC2a2abp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RC2a2abp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFF31C2BD10;
	Thu,  6 Jun 2024 14:10:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683002;
	bh=/ZYii4fqfJ5xz/vdGJDC/Y+QnKQZoutPbu7ReeGS6fA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RC2a2abpyCN81xbsulFzRE6ghzfVG3AMCAefpSJIPuzPe3H9o5FUbdKQ/7lLDc25q
	 99iUnauqUDQRzWJlnC9kdcLlog/bVBkW6G5mOPqYLEitJ1Cg/SmL9VxYlVgscJ3Wxt
	 BAzBPhmpkzKHimoYIbgbI3whpqB+tFRJjQKDnSN4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Rob Clark <robdclark@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 207/374] drm/msm/a6xx: Avoid a nullptr dereference when speedbin setting fails
Date: Thu,  6 Jun 2024 16:03:06 +0200
Message-ID: <20240606131658.757941194@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit 46d4efcccc688cbacdd70a238bedca510acaa8e4 ]

Calling a6xx_destroy() before adreno_gpu_init() leads to a null pointer
dereference on:

msm_gpu_cleanup() : platform_set_drvdata(gpu->pdev, NULL);

as gpu->pdev is only assigned in:

a6xx_gpu_init()
|_ adreno_gpu_init
    |_ msm_gpu_init()

Instead of relying on handwavy null checks down the cleanup chain,
explicitly de-allocate the LLC data and free a6xx_gpu instead.

Fixes: 76efc2453d0e ("drm/msm/gpu: Fix crash during system suspend after unbind")
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/588919/
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
index 441dfebb36386..7b72327df7f3f 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
@@ -3062,7 +3062,8 @@ struct msm_gpu *a6xx_gpu_init(struct drm_device *dev)
 
 	ret = a6xx_set_supported_hw(&pdev->dev, config->info);
 	if (ret) {
-		a6xx_destroy(&(a6xx_gpu->base.base));
+		a6xx_llc_slices_destroy(a6xx_gpu);
+		kfree(a6xx_gpu);
 		return ERR_PTR(ret);
 	}
 
-- 
2.43.0



