Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C41019DF7D;
	Thu,  6 Jun 2024 14:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683505; cv=none; b=Ko0ACXjY98Z5XLFIC9qXfbqHgkxGMpxpYEVM0qTw+DEivaXQpkSGyxvHyCP9he/v8ckeUcrxUvh6Ey72H+o3uzFlw/YXHU/G6V3tYrF9HDprhDT0oHPnKfqqe79H0zuSaqiWNZQbvGNLQ0MAAW4vBNwoOb9bQbRt8vhF8TKu0Ik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683505; c=relaxed/simple;
	bh=VHc6BMR0DtyrZPlx8uMmYmd5gw0dBlnsp9RoROYbiLo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KfWx9HbabRovCoVKSPpzK30i4uZWxJpzFp0OT9d3BMf4B82TbPTVVRDTAqTegnYI0RTjkSRv/fUeE/0IFJEge6OWBeph1AyanASRuVXc8C0cH1gESwCobpAtzVYP+a84bYrN1R5B506e3j+4VKtW3rgY0jobJo+nNSluMkaZ9T4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EOsDM+lc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EOsDM+lc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26FDCC32782;
	Thu,  6 Jun 2024 14:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683505;
	bh=VHc6BMR0DtyrZPlx8uMmYmd5gw0dBlnsp9RoROYbiLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EOsDM+lcL1/1B/49rCqNmgegue+GDTu58k4OqLdsk5lgvlFV1UtMrqKpXbVFTlglY
	 jeNQ0EY6DyKbm5poeb7z/L1fsRLNJmPhdz8cOL+haZXL8j9MagFH4IU626PFbF2N9J
	 3RtPcofhjWu9kIxPerFNuxXE+EJj+zZgjszo0Ojg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Rob Clark <robdclark@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 394/473] drm/msm/a6xx: Avoid a nullptr dereference when speedbin setting fails
Date: Thu,  6 Jun 2024 16:05:23 +0200
Message-ID: <20240606131712.856745452@linuxfoundation.org>
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
index cdce27adbd03b..d6a810b7cfa2c 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
@@ -2040,7 +2040,8 @@ struct msm_gpu *a6xx_gpu_init(struct drm_device *dev)
 
 	ret = a6xx_set_supported_hw(&pdev->dev, config->rev);
 	if (ret) {
-		a6xx_destroy(&(a6xx_gpu->base.base));
+		a6xx_llc_slices_destroy(a6xx_gpu);
+		kfree(a6xx_gpu);
 		return ERR_PTR(ret);
 	}
 
-- 
2.43.0



