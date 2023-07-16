Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF7BE8F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:12:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 640EBC433C7;
	Sun, 16 Jul 2023 20:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689538372;
	bh=jl5A2tTzsRrYvVyWXAcLfG3JoPNk4xIXWWIBWunHcJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iDwkX68c8m2Z640DqNC34ChTfRTEFPBBA19UUE5gpZionWFjU1ED6Gk/qmcv8ZDXm
	 wyCZ0H1SqWlikojOKpwi1JECNZsCCt2Fl30Owy86iHE0qErHJit4YTGjeOciDfsAxa
	 Ykk07SH6WdcSZUb2dzZCsP1lf2mqBf107lojWuZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yongqin Liu <yongqin.liu@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Marijn Suijten <marijn.suijten@somainline.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 398/800] drm/msm/dpu: do not enable color-management if DSPPs are not available
Date: Sun, 16 Jul 2023 21:44:11 +0200
Message-ID: <20230716194958.315328896@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 3bcfc7b90465efd337d39b91b43972162f0d1908 ]

We can not support color management without DSPP blocks being provided
in the HW catalog. Do not enable color management for CRTCs if num_dspps
is 0.

Fixes: 4259ff7ae509 ("drm/msm/dpu: add support for pcc color block in dpu driver")
Reported-by: Yongqin Liu <yongqin.liu@linaro.org>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Reviewed-by: Marijn Suijten <marijn.suijten@somainline.org>
Reviewed-by: Sumit Semwal <sumit.semwal@linaro.org>
Tested-by: Yongqin Liu <yongqin.liu@linaro.org>
Patchwork: https://patchwork.freedesktop.org/patch/542141/
Link: https://lore.kernel.org/r/20230612182534.3345805-1-dmitry.baryshkov@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c b/drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c
index cc66ddffe6723..eee48371126d8 100644
--- a/drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c
+++ b/drivers/gpu/drm/msm/disp/dpu1/dpu_crtc.c
@@ -1463,6 +1463,8 @@ static const struct drm_crtc_helper_funcs dpu_crtc_helper_funcs = {
 struct drm_crtc *dpu_crtc_init(struct drm_device *dev, struct drm_plane *plane,
 				struct drm_plane *cursor)
 {
+	struct msm_drm_private *priv = dev->dev_private;
+	struct dpu_kms *dpu_kms = to_dpu_kms(priv->kms);
 	struct drm_crtc *crtc = NULL;
 	struct dpu_crtc *dpu_crtc = NULL;
 	int i, ret;
@@ -1494,7 +1496,8 @@ struct drm_crtc *dpu_crtc_init(struct drm_device *dev, struct drm_plane *plane,
 
 	drm_crtc_helper_add(crtc, &dpu_crtc_helper_funcs);
 
-	drm_crtc_enable_color_mgmt(crtc, 0, true, 0);
+	if (dpu_kms->catalog->dspp_count)
+		drm_crtc_enable_color_mgmt(crtc, 0, true, 0);
 
 	/* save user friendly CRTC name for later */
 	snprintf(dpu_crtc->name, DPU_CRTC_NAME_SIZE, "crtc%u", crtc->base.id);
-- 
2.39.2



