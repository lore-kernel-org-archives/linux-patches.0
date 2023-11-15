Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E8283FB0F
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HBOE70SV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEA98C433C8;
	Wed, 15 Nov 2023 19:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076411;
	bh=SVqJMIc8DdS5YCkNcag5GVn72zPmdP1bU0ALqA2Qrq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HBOE70SVut60VQTh70Fl3RDMgMBKrhRiuHj7FMTSt6vIUE93skd5I3RcIFc1fbd75
	 ebgCefOfZqL1e6uw87PSQWVDdTbFQAFEBeHh1RyzCtIQDvXRmp+ELrgA5L7tRIrqiQ
	 R55ictFRu02xHQXuGCar22MBw85iJVLJn1kXSwUU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Abhinav Kumar <quic_abhinavk@quicinc.com>,
	Rob Clark <robdclark@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 251/550] drm/msm/dsi: use msm_gem_kernel_put to free TX buffer
Date: Wed, 15 Nov 2023 14:13:55 -0500
Message-ID: <20231115191618.092850801@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 69b321b2c3df4f7e51a9de587e41f324b0b717b0 ]

Use exiting function to free the allocated GEM object instead of
open-coding it. This has a bonus of internally calling
msm_gem_put_vaddr() to compensate for msm_gem_get_vaddr() in
msm_get_kernel_new().

Fixes: 1e29dff00400 ("drm/msm: Add a common function to free kernel buffer objects")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/562239/
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/dsi/dsi_host.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/msm/dsi/dsi_host.c b/drivers/gpu/drm/msm/dsi/dsi_host.c
index 9ac62651eb756..d433552c94f30 100644
--- a/drivers/gpu/drm/msm/dsi/dsi_host.c
+++ b/drivers/gpu/drm/msm/dsi/dsi_host.c
@@ -1150,8 +1150,7 @@ static void dsi_tx_buf_free(struct msm_dsi_host *msm_host)
 
 	priv = dev->dev_private;
 	if (msm_host->tx_gem_obj) {
-		msm_gem_unpin_iova(msm_host->tx_gem_obj, priv->kms->aspace);
-		drm_gem_object_put(msm_host->tx_gem_obj);
+		msm_gem_kernel_put(msm_host->tx_gem_obj, priv->kms->aspace);
 		msm_host->tx_gem_obj = NULL;
 	}
 
-- 
2.42.0



