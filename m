Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AFD7165F08;
	Tue,  8 Oct 2024 12:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390134; cv=none; b=O2futMm3JcTJlvedzCb0k6/b0hvHfkOWD6UVjeiOH8PIrkbk99gEZl81z0+2g2Bdyvc/yzq1SbfyQO/iyGsXPHOkqDDgCchGx8M6VcHdSXOPpSywPG5X12xUvjN05dmP1c9prewDhv8GOV7Hjekr8S/gP5dpfc9Ag+zByqISL2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390134; c=relaxed/simple;
	bh=VIDrS4QnIDXc6HHkTKXG9YfG8v78yD9pcNayHSJkYGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=toaHKgyafsW2G+qDeHqG37akHu0UPlfETNQrGwUR0oh0VPKDM9u8usbkHyjoXS+83WoDoyihOo8ChitxHtB9VEMdmkQ5WkjC2VUwZ0SdQXr1xC/EmhwMxD4us6coQC2zzfJbGqsJ01xrIIO7YFEMRh8sVYjISDKtRqCCgE4MEmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K37br7pP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K37br7pP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49354C4CEC7;
	Tue,  8 Oct 2024 12:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390134;
	bh=VIDrS4QnIDXc6HHkTKXG9YfG8v78yD9pcNayHSJkYGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K37br7pPG1FdYkpwj/yWgd7CtjtT7+Lst0pReoJuMQ7vDf8J8kkj4vscqqU+EnDw0
	 RqBj9Bk3xgEPExAnDxFZCIFVuJvQMtVlrexwVIFY4tMrDGmdpwOjUlP5URGRHqzCLj
	 OdFeqp87UsKAOB3Cwll4K4wyMDvE/q6PFypgaGqU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Rob Clark <robdclark@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 201/482] drm/msm/adreno: Assign msm_gpu->pdev earlier to avoid nullptrs
Date: Tue,  8 Oct 2024 14:04:24 +0200
Message-ID: <20241008115656.220261734@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit 16007768551d5bfe53426645401435ca8d2ef54f ]

There are some cases, such as the one uncovered by Commit 46d4efcccc68
("drm/msm/a6xx: Avoid a nullptr dereference when speedbin setting fails")
where

msm_gpu_cleanup() : platform_set_drvdata(gpu->pdev, NULL);

is called on gpu->pdev == NULL, as the GPU device has not been fully
initialized yet.

Turns out that there's more than just the aforementioned path that
causes this to happen (e.g. the case when there's speedbin data in the
catalog, but opp-supported-hw is missing in DT).

Assigning msm_gpu->pdev earlier seems like the least painful solution
to this, therefore do so.

Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/602742/
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/adreno_gpu.c | 1 +
 drivers/gpu/drm/msm/msm_gpu.c           | 1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/adreno/adreno_gpu.c b/drivers/gpu/drm/msm/adreno/adreno_gpu.c
index d5d9361e11aa5..8e8f55225e1ea 100644
--- a/drivers/gpu/drm/msm/adreno/adreno_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/adreno_gpu.c
@@ -1079,6 +1079,7 @@ int adreno_gpu_init(struct drm_device *drm, struct platform_device *pdev,
 	adreno_gpu->chip_id = config->chip_id;
 
 	gpu->allow_relocs = config->info->family < ADRENO_6XX_GEN1;
+	gpu->pdev = pdev;
 
 	/* Only handle the core clock when GMU is not in use (or is absent). */
 	if (adreno_has_gmu_wrapper(adreno_gpu) ||
diff --git a/drivers/gpu/drm/msm/msm_gpu.c b/drivers/gpu/drm/msm/msm_gpu.c
index cd185b9636d26..56b6de049bd7b 100644
--- a/drivers/gpu/drm/msm/msm_gpu.c
+++ b/drivers/gpu/drm/msm/msm_gpu.c
@@ -929,7 +929,6 @@ int msm_gpu_init(struct drm_device *drm, struct platform_device *pdev,
 	if (IS_ERR(gpu->gpu_cx))
 		gpu->gpu_cx = NULL;
 
-	gpu->pdev = pdev;
 	platform_set_drvdata(pdev, &gpu->adreno_smmu);
 
 	msm_devfreq_init(gpu);
-- 
2.43.0



