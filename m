Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E6851A1871;
	Thu,  6 Jun 2024 14:21:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683717; cv=none; b=DDjcxzsJpJVlVXHlpCSLSdB4MeH5ScDODVTAdb4tRCwqBCvlaXE3OcGQ+AzlDfK2h7Lv8OrwCr/leJCb6Py80VqZJFxZsJX4t8Ar2NRH7u/DpYZoLj1sc932CpE7su7I5N8ejZYl/CL4aFnnzYX6VRLlTxKTkYOa9wriwgVGNk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683717; c=relaxed/simple;
	bh=AdwWhynfYDj6aESQpjYxLLjoURTr/jf2OpxoE+0DKvc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fiabiHwRnNCxQK5L1LtgpMbo5quGO1NJe2uwjxTNfa0H0u3G/RnS8PbNmSKm2dF50GytnpVip9xyY48wB8kUCjpaAzXmWwqOeCI3dHKY5RhhsLBtJmTPjCTEFlbZUhplehBeVIuPOMCvd6yUmUSPLmvhr0Fxcut3sASI5NI8T1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MSSaMSXI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MSSaMSXI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63A9AC2BD10;
	Thu,  6 Jun 2024 14:21:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683717;
	bh=AdwWhynfYDj6aESQpjYxLLjoURTr/jf2OpxoE+0DKvc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MSSaMSXIrys6grfVdXDJOEsnfZsZpV5l9/1WCbDcT+Im2SGpPiaEI05ZIJ2EH7bz1
	 BXWnCzeU5VTdY9Zh8TRgNYAFEqs4i6MAzlqbB3OmBQ39gZpHaoYohJMsrM3m1zschc
	 QgaqRjPy87zIQ8/13ad/pcsRjgMUsiraU7Ce9rmw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Rob Clark <robdclark@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 614/744] drm/msm/a6xx: Avoid a nullptr dereference when speedbin setting fails
Date: Thu,  6 Jun 2024 16:04:46 +0200
Message-ID: <20240606131752.185902358@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 522ca7fe67625..3664c1476a83a 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
@@ -2343,7 +2343,8 @@ struct msm_gpu *a6xx_gpu_init(struct drm_device *dev)
 
 	ret = a6xx_set_supported_hw(&pdev->dev, config->info);
 	if (ret) {
-		a6xx_destroy(&(a6xx_gpu->base.base));
+		a6xx_llc_slices_destroy(a6xx_gpu);
+		kfree(a6xx_gpu);
 		return ERR_PTR(ret);
 	}
 
-- 
2.43.0



