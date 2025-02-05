Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEABE1519AA;
	Wed,  5 Feb 2025 14:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764401; cv=none; b=evdb5erle8sjMiQS6vIYIu+Sh1hFyU+G41F/cUhM0l5Q0Iq9e/mZ3/Y6jZ2AKVb8OGDrVdvFIAfSBqvagc4DU8HN3C9mLjaUzjEXioFSzYQ2dGvfzknkSS0aMo037bNfyLwRcWt2sU2byrO0WY/FLBKeKoqjt96bhYPOPh0gJDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764401; c=relaxed/simple;
	bh=oOahCVCsc333TuG0vS2dSnKN8BMQYlqy/rfzOtwRFTg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aiWPfsV0v666Yw0UpH6dP8dy0lgCUnXXV4Mn9WQQbdFl32Yw4pvkmok+GUfvDJ16T8kK5TJt9pj6QUW+9ojvIbyS1sPM5pqQ16U1w5Sor9L+MkjrC9f/4PXQ3sJMtJI0B7r/UYri09vxQLf2SwwPBhpn+xfFqnDRGWtpe19YEhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vAL11fu7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vAL11fu7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 253E2C4CED1;
	Wed,  5 Feb 2025 14:06:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764401;
	bh=oOahCVCsc333TuG0vS2dSnKN8BMQYlqy/rfzOtwRFTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vAL11fu7GdFN7NMhBgIaIIdo9M0owYTN77bGhMJtQphMoGETYWsLhrYKwEdj9uubr
	 v8GZ85JNoBZX3laWXit1rTl4h0jGFRBcPhgSBNd5ym1PEmc4glUhsQ9WSrs1GaLMzn
	 JL8SQZfA82Y/i3LWr/+aiqk1rajMNxG9HhYZ9cc4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sui Jingfeng <sui.jingfeng@linux.dev>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 075/623] drm/msm: Check return value of of_dma_configure()
Date: Wed,  5 Feb 2025 14:36:57 +0100
Message-ID: <20250205134459.096077291@linuxfoundation.org>
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



