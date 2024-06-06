Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A48219DF79;
	Thu,  6 Jun 2024 14:18:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683504; cv=none; b=u2wi6mj592jBT/+4NeEiNwZgIm6I5GD+E3LOH79vYsp7fqryaSTgkkJwRhSWOq7NVG6fH9PQnpakV9zx5+3flcLMlZjx5vE6/Zk6TofnFDBxNblMySJTgz4cWzDZQE0Q80jFJK4fZYlFEpDCCujZRJUJw97i0UUOjR4tDeiv+Ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683504; c=relaxed/simple;
	bh=FqqS6SGMyvZwsOVcPo+jEiOOUBKQH1KZiHfQ8q6nvBQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cjGiYcRoNU8xQDfmnvV1syUn3Jc4Qcl0zJzr1b73RsQKqpx7gl1j7j3x5ZkQFwfkHr0XuR8TDZqQjGBrnAsrOm8/fTKA7MXgazWgn+SB1Bd/NQWDBnotQ/3u2ZFejx+ZB9NF+lKb0srXDziZD1xii2MxWs9dQI43Krb3Ewl9ILg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xaS9YwZ9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xaS9YwZ9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 270C4C2BD10;
	Thu,  6 Jun 2024 14:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683504;
	bh=FqqS6SGMyvZwsOVcPo+jEiOOUBKQH1KZiHfQ8q6nvBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xaS9YwZ9P/imO2evqAG4IQwL0Ye13kfACaFvyiZX7iPiUfVpCZ6ylS2tN9UXPzLmj
	 4JXIhCfLWhYLeiHoU9UBXfSGnGyTeKGuf4lA0rpHJ+FDWezLVd7c448YSF13Gc7e5L
	 khy6wWe4jCIvzwnXr+0gUaRIYhwlQ9Z4+hu/iKRI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Clark <robdclark@chromium.org>,
	Douglas Anderson <dianders@chromium.org>,
	Chia-I Wu <olvaffe@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 393/473] drm/msm: Enable clamp_to_idle for 7c3
Date: Thu,  6 Jun 2024 16:05:22 +0200
Message-ID: <20240606131712.830429228@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

From: Rob Clark <robdclark@chromium.org>

[ Upstream commit 2c1b7748100e2e40155722589201f24c23ae5d53 ]

This was overlooked.

Signed-off-by: Rob Clark <robdclark@chromium.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Chia-I Wu <olvaffe@gmail.com>
Patchwork: https://patchwork.freedesktop.org/patch/511693/
Link: https://lore.kernel.org/r/20221115155535.1615278-1-robdclark@gmail.com
Stable-dep-of: 46d4efcccc68 ("drm/msm/a6xx: Avoid a nullptr dereference when speedbin setting fails")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
index 95e73eddc5e91..cdce27adbd03b 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
@@ -2036,13 +2036,6 @@ struct msm_gpu *a6xx_gpu_init(struct drm_device *dev)
 			adreno_cmp_rev(ADRENO_REV(6, 3, 5, ANY_ID), info->rev)))
 		adreno_gpu->base.hw_apriv = true;
 
-	/*
-	 * For now only clamp to idle freq for devices where this is known not
-	 * to cause power supply issues:
-	 */
-	if (info && (info->revn == 618))
-		gpu->clamp_to_idle = true;
-
 	a6xx_llc_slices_init(pdev, a6xx_gpu);
 
 	ret = a6xx_set_supported_hw(&pdev->dev, config->rev);
@@ -2057,6 +2050,13 @@ struct msm_gpu *a6xx_gpu_init(struct drm_device *dev)
 		return ERR_PTR(ret);
 	}
 
+	/*
+	 * For now only clamp to idle freq for devices where this is known not
+	 * to cause power supply issues:
+	 */
+	if (adreno_is_a618(adreno_gpu) || adreno_is_7c3(adreno_gpu))
+		gpu->clamp_to_idle = true;
+
 	/* Check if there is a GMU phandle and set it up */
 	node = of_parse_phandle(pdev->dev.of_node, "qcom,gmu", 0);
 
-- 
2.43.0



