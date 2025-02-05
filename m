Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC04D15573F;
	Wed,  5 Feb 2025 13:57:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738763856; cv=none; b=CrSJHteM1CIyM7LE6TYN2j7ypbipF0Y4Ay6WChxfKta939BThxtIolWMItLWO5DKpDwt8hpW68kVdUbCRNge6sN67CXFLiDRfMUTsH8ed/BFs/QRGjivx3v/2JQC7gnjmL/ban+IgeJvlQeqdaP/WES69PhQ2zAiOffnuY3I2MQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738763856; c=relaxed/simple;
	bh=jiFfABDCQroDxmh4j0HC0QEt0E2PNF2Zh+RKJ853X2c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jExxPcm8TBtig2jzAW5ZjWPqn6Svxn9n2SkWy9/8wVoCpWSsUXYMaT3248HdnCp0RPdz4Y2aWolyGMoOeR5hA3q/uXKW2NQ/FJTmnCpHNeRpvEkMvP8GdqiqRtjOUZl9oxtgocICPoU5fYMbOfCnb+8rWQx0PDRL19tBdHSOELo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tiPMtDEF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tiPMtDEF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28A5BC4CED1;
	Wed,  5 Feb 2025 13:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738763856;
	bh=jiFfABDCQroDxmh4j0HC0QEt0E2PNF2Zh+RKJ853X2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tiPMtDEF6cgUE2aOpP+SIBWrefl/d1Na8yKuLcI8WHu+lxlco8c9DWdl7hG5qBXmn
	 AagO9jtgjKRK0xQqySA/uHbEKbaoQtezM9LtkeN/lWJaKz98qT2PQa8npKqjMf1nh5
	 K1XCWaIDcp33qVmgKjVOtgAwoqhcP8LetJ68ZwWU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 067/590] drm/msm: dont clean up priv->kms prematurely
Date: Wed,  5 Feb 2025 14:37:02 +0100
Message-ID: <20250205134457.821469307@linuxfoundation.org>
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

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit ebc0deda3c2948d40419677d388b4e6081688a06 ]

MSM display drivers provide kms structure allocated during probe().
Don't clean up priv->kms field in case of an error. Otherwise probe
functions might fail after KMS probe deferral.

Fixes: a2ab5d5bb6b1 ("drm/msm: allow passing struct msm_kms to msm_drv_probe()")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Fixes: 506efcba3129 ("drm/msm: carve out KMS code from msm_drv.c")
Patchwork: https://patchwork.freedesktop.org/patch/590411/
Link: https://lore.kernel.org/r/20240420-mdp4-fixes-v1-1-96a70f64fa85@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/msm_kms.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/msm_kms.c b/drivers/gpu/drm/msm/msm_kms.c
index af6a6fcb11736..6749f0fbca96d 100644
--- a/drivers/gpu/drm/msm/msm_kms.c
+++ b/drivers/gpu/drm/msm/msm_kms.c
@@ -244,7 +244,6 @@ int msm_drm_kms_init(struct device *dev, const struct drm_driver *drv)
 	ret = priv->kms_init(ddev);
 	if (ret) {
 		DRM_DEV_ERROR(dev, "failed to load kms\n");
-		priv->kms = NULL;
 		return ret;
 	}
 
-- 
2.39.5



