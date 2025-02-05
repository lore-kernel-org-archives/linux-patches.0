Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69D0114D28C;
	Wed,  5 Feb 2025 13:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763846; cv=none; b=owq1BtLW/T8IDMQfwX2Eh0q57VlgHUeadPyv04tHVRwtA3r8tCHRPNiLTGWa7xM2eaH6JgktG2aFDD0lcl9zPzHQ2jgJytJ0dSdCxbwQvHF5/iB+SlXsOnt+Gr+yqQQizsMHSh2jjOmrF6CJDF345KxCGjKBvQcQ+kISfLG9TAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763846; c=relaxed/simple;
	bh=xsZ7UqPuKGByM0oa2NHaD1Cv3dxz4Jw62g9JSnOBdk8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rf9yrVXJMw8d0mp416Cf8Y7m8bg8Xt1C/6oMHFPaLjIb+qTDlYrOnGXLyGMuQXGyP1vVONMpSummUhNnfOXY3hCpslHaW6LgeDwp2G/hD99aEwUyw/VvBuMfE+UbeR9VSQ3FkGYM6rFrjuNj+2cmrhtGYgD3WDk22zLSpkyRryQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LNDwv0W3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LNDwv0W3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C972AC4CED1;
	Wed,  5 Feb 2025 13:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763846;
	bh=xsZ7UqPuKGByM0oa2NHaD1Cv3dxz4Jw62g9JSnOBdk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LNDwv0W3cjQouJuZzlg9uzOShxvXCFLwt+8rm5N7FTwh/bODTHY6uGZA578jch/U+
	 frZaCzfqPdMLZc/xhMNhyLkRFlke/k4YPQBzLXKr2zASLtwO7k6Ptiomls57hhC8mO
	 /bkziMrKTHollFdjz4aJ8JESUGYG+dpSd1Otnfpo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sui Jingfeng <sui.jingfeng@linux.dev>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 066/590] drm/msm: Check return value of of_dma_configure()
Date: Wed,  5 Feb 2025 14:37:01 +0100
Message-ID: <20250205134457.782293401@linuxfoundation.org>
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

From: Sui Jingfeng <sui.jingfeng@linux.dev>

[ Upstream commit b34a7401ffaee45354e81b38a4d072794079cfd6 ]

Because the of_dma_configure() will returns '-EPROBE_DEFER' if the probe
procedure of the specific platform IOMMU driver is not finished yet. It
can also return other error code for various reasons.

Stop pretending that it will always suceess, quit if it fail.

Signed-off-by: Sui Jingfeng <sui.jingfeng@linux.dev>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Fixes: 29ac8979cdf7 ("drm/msm/a6xx: use msm_gem for GMU memory objects")
Fixes: 5a903a44a984 ("drm/msm/a6xx: Introduce GMU wrapper support")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/622782/
Link: https://lore.kernel.org/r/20241104090738.529848-1-sui.jingfeng@linux.dev
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a6xx_gmu.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gmu.c b/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
index 14db7376c712d..e386b059187ac 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
@@ -1603,7 +1603,9 @@ int a6xx_gmu_wrapper_init(struct a6xx_gpu *a6xx_gpu, struct device_node *node)
 
 	gmu->dev = &pdev->dev;
 
-	of_dma_configure(gmu->dev, node, true);
+	ret = of_dma_configure(gmu->dev, node, true);
+	if (ret)
+		return ret;
 
 	pm_runtime_enable(gmu->dev);
 
@@ -1668,7 +1670,9 @@ int a6xx_gmu_init(struct a6xx_gpu *a6xx_gpu, struct device_node *node)
 
 	gmu->dev = &pdev->dev;
 
-	of_dma_configure(gmu->dev, node, true);
+	ret = of_dma_configure(gmu->dev, node, true);
+	if (ret)
+		return ret;
 
 	/* Fow now, don't do anything fancy until we get our feet under us */
 	gmu->idle_level = GMU_IDLE_STATE_ACTIVE;
-- 
2.39.5



