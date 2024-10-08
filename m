Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4BE61DED60;
	Tue,  8 Oct 2024 12:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391940; cv=none; b=WtMMSExsAAz7UBVVmEL1IR7HTl+4n7g2QuwcIJA47L6cbpigeJYqZ5bsGsEq0MYpAVS99ePXwVQBTTVVKTKFh+K1kWwejLFixoAID1yuMMDsWCEQVimUJQ+5HMCZJff5WicR5eRhw5z5sBB6EQgqqLnDmQrJlXhpAUveIZx4H9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391940; c=relaxed/simple;
	bh=B1rcXRWWW5oYjg4Woj6i2U1Nfk0U8/3jyaA1pk4tkk4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sKlWm7uYWRYUz3k/nRoeWHGZ90Hohd5sO3POAoAqg04T1h0PsEoWe4sTEFJeWPoKh0PNyWIlKUw3zqrdGvGtLEVcQY9qOnx4C2YecSUoQ/s/U5K2EjLrfj5SSQpff+cSbW5191ig6AxhbiIwIBdQ4xxC1ihjNSrxA/LLeX6QNFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PASDTLLw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PASDTLLw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 549EFC4CEC7;
	Tue,  8 Oct 2024 12:52:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391940;
	bh=B1rcXRWWW5oYjg4Woj6i2U1Nfk0U8/3jyaA1pk4tkk4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PASDTLLwCq9vTX+B0M1ASzbT1liXoTSRf/hGFg1rNd2Z1KEQ//Cnp92DiKanjzRm9
	 f5JIwyIecfxulvdW1klvA7xwEYY0pvswch+V7lFETm7XocGxWmD5X93FFVGVLuxSBX
	 /UarTD78ppqnS9t4oT/2JZneuJ65wtxrsGOecx+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Rob Clark <robdclark@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 241/558] drm/msm/adreno: Assign msm_gpu->pdev earlier to avoid nullptrs
Date: Tue,  8 Oct 2024 14:04:31 +0200
Message-ID: <20241008115711.825191852@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 3896123ec51c9..83caca2c4026a 100644
--- a/drivers/gpu/drm/msm/adreno/adreno_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/adreno_gpu.c
@@ -1083,6 +1083,7 @@ int adreno_gpu_init(struct drm_device *drm, struct platform_device *pdev,
 	adreno_gpu->chip_id = config->chip_id;
 
 	gpu->allow_relocs = config->info->family < ADRENO_6XX_GEN1;
+	gpu->pdev = pdev;
 
 	/* Only handle the core clock when GMU is not in use (or is absent). */
 	if (adreno_has_gmu_wrapper(adreno_gpu) ||
diff --git a/drivers/gpu/drm/msm/msm_gpu.c b/drivers/gpu/drm/msm/msm_gpu.c
index 3666b42b4ecd7..a274b84664237 100644
--- a/drivers/gpu/drm/msm/msm_gpu.c
+++ b/drivers/gpu/drm/msm/msm_gpu.c
@@ -931,7 +931,6 @@ int msm_gpu_init(struct drm_device *drm, struct platform_device *pdev,
 	if (IS_ERR(gpu->gpu_cx))
 		gpu->gpu_cx = NULL;
 
-	gpu->pdev = pdev;
 	platform_set_drvdata(pdev, &gpu->adreno_smmu);
 
 	msm_devfreq_init(gpu);
-- 
2.43.0



