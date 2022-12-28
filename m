Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F0C91863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:32:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88259C433D2;
	Wed, 28 Dec 2022 15:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672241564;
	bh=GGEAZCiZMUh8tECm3Q/1mQ8BDuVYn8aXuNNcpXiaEwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CunkVF3E6x/opqGDkhzXOrg2wf6siX7eFWVOKTSRWIzUOU3nUjV/SBQAYLtR9jB6k
	 jmEKGtuyAvxxLUB2BJrEpsnCMNCrZRt2RM6CPc2Hktrz9goMYVOr/b3/0zpeiDAdMZ
	 twGUtS2nQN0nBEXUuNF+qMW808vAmRCjuORQkdXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Qilong <zhangqilong3@huawei.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0261/1146] drm/rockchip: lvds: fix PM usage counter unbalance in poweron
Date: Wed, 28 Dec 2022 15:30:00 +0100
Message-Id: <20221228144337.227314931@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zhang Qilong <zhangqilong3@huawei.com>

[ Upstream commit 4dba27f1a14592ac4cf71c3bc1cc1fd05dea8015 ]

pm_runtime_get_sync will increment pm usage counter even it failed.
Forgetting to putting operation will result in reference leak here.
We fix it by replacing it with the newest pm_runtime_resume_and_get
to keep usage counter balanced.

Fixes: 34cc0aa25456 ("drm/rockchip: Add support for Rockchip Soc LVDS")
Fixes: cca1705c3d89 ("drm/rockchip: lvds: Add PX30 support")
Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20220922132107.105419-3-zhangqilong3@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/rockchip/rockchip_lvds.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/rockchip/rockchip_lvds.c b/drivers/gpu/drm/rockchip/rockchip_lvds.c
index 5a284332ec49..68f6ebb33460 100644
--- a/drivers/gpu/drm/rockchip/rockchip_lvds.c
+++ b/drivers/gpu/drm/rockchip/rockchip_lvds.c
@@ -152,7 +152,7 @@ static int rk3288_lvds_poweron(struct rockchip_lvds *lvds)
 		DRM_DEV_ERROR(lvds->dev, "failed to enable lvds pclk %d\n", ret);
 		return ret;
 	}
-	ret = pm_runtime_get_sync(lvds->dev);
+	ret = pm_runtime_resume_and_get(lvds->dev);
 	if (ret < 0) {
 		DRM_DEV_ERROR(lvds->dev, "failed to get pm runtime: %d\n", ret);
 		clk_disable(lvds->pclk);
@@ -336,16 +336,20 @@ static int px30_lvds_poweron(struct rockchip_lvds *lvds)
 {
 	int ret;
 
-	ret = pm_runtime_get_sync(lvds->dev);
+	ret = pm_runtime_resume_and_get(lvds->dev);
 	if (ret < 0) {
 		DRM_DEV_ERROR(lvds->dev, "failed to get pm runtime: %d\n", ret);
 		return ret;
 	}
 
 	/* Enable LVDS mode */
-	return regmap_update_bits(lvds->grf, PX30_LVDS_GRF_PD_VO_CON1,
+	ret = regmap_update_bits(lvds->grf, PX30_LVDS_GRF_PD_VO_CON1,
 				  PX30_LVDS_MODE_EN(1) | PX30_LVDS_P2S_EN(1),
 				  PX30_LVDS_MODE_EN(1) | PX30_LVDS_P2S_EN(1));
+	if (ret)
+		pm_runtime_put(lvds->dev);
+
+	return ret;
 }
 
 static void px30_lvds_poweroff(struct rockchip_lvds *lvds)
-- 
2.35.1



