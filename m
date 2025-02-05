Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E997F510;
	Wed,  5 Feb 2025 14:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764412; cv=none; b=u2HdpeEWDWfQ7E5HlTo65Ur3CYGXNBL49+AZzsoJMHa+IeYhlFMxnp+R5K6B6ejySnQIkGudXQI7jnovTkwbVH9m0TAIZchtRyH0s2TPg0etIj+b0FASiAjqe+F4vBvMbLPFHRojk+LiKxv2sHsGtZcD9OL9SK9g73i7VYGC7c4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764412; c=relaxed/simple;
	bh=oAXfLkoWBJTMOKmWDG6h+9yuURUrLdDO3i4pMlMyv3c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m1DHyT1cd+FMwP8EYNYNjX8Jj0eBtxBYBVmaAiuxXJQXDRuI3GHPfPDvs49D7BEtaLUeXfvyCi0VFk/YuUFkuw5X/ljOl7r8PARU8aTwSqGGeuP5/7D6xrsaQ0mUfI6dne8wuRmOD6jIE6qfmhiwSbvsxLyGHSKLOLxvY+uL+2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UEGBx0Lj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UEGBx0Lj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78330C4CED1;
	Wed,  5 Feb 2025 14:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764412;
	bh=oAXfLkoWBJTMOKmWDG6h+9yuURUrLdDO3i4pMlMyv3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UEGBx0Ljm2YUnFR9eQvMc7lC83Wpq7+niQQZvF9aze218PBkmskWd2EaoP/2Is3QS
	 1D/6q8Z8t0WlfOXfLU5OTEj9tG4zOHieqNSULkByE6ler/FWGLL6qHeioZ69LkkFOv
	 kqYf3ooQZcWOnLVX3PFzuhr+uXo72VQXMwvDnA0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 076/623] drm/msm: dont clean up priv->kms prematurely
Date: Wed,  5 Feb 2025 14:36:58 +0100
Message-ID: <20250205134459.134206435@linuxfoundation.org>
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
index f3326d09bdbce..4cfad12f4dc1f 100644
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



