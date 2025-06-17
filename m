Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87A742ECE86;
	Tue, 17 Jun 2025 16:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178785; cv=none; b=cFseo8/xxD0z3Yz/Tdb0IdEyyaZ+M2tGimaA9e9vxlY0e/2DxMZITAfjIt3mL+oW5aGKa8cj2PnboQMyltZpl58MuC4N/zY3abxAic7gI8f4Y2aYe5orExLUYdm8CvnXL0fIOzJCNPAHrcKLfo2Wa6tAmKZ3O4MK+I/P82zqQ5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178785; c=relaxed/simple;
	bh=X9sjX4x7eZGPd1/tiwbrd9zPXB0XIXHHsIPVYEdId3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dzLtruwCZWnep90H0RRUUG4QdkJvPBl/YhiR7fim6h12o3yICs5Q+/aZLiHFTMlTnJ7HYvfox702al7Uz/xjqmGTwEaSS0aolXlJf4c4J97nnsbwxwlVdS804lgfd2c/iWEPKHERIXzIso0uoNTo9eCU395EfCT24BXQZgumeNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K0+yiBHU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K0+yiBHU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FD9CC4CEE3;
	Tue, 17 Jun 2025 16:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178785;
	bh=X9sjX4x7eZGPd1/tiwbrd9zPXB0XIXHHsIPVYEdId3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K0+yiBHUt4ggkZIGV5XBEGDe18zPB3QlDTyGvfqgMrq9EG6ztYykszjJCDg9I77ze
	 FxKuKqZjYIHySM3fFPfApI1YU+TqTYKk8QwZZ81kgvQfW+zsu+KGjWn3+oB5LqCn7Y
	 l8w+05sj9Cx3jqqpMIY3RYGRTx+D2InunW9EhwJ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damon Ding <damon.ding@rock-chips.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Douglas Anderson <dianders@chromium.org>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 554/780] drm/bridge: analogix_dp: Add support to get panel from the DP AUX bus
Date: Tue, 17 Jun 2025 17:24:22 +0200
Message-ID: <20250617152514.064185427@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damon Ding <damon.ding@rock-chips.com>

[ Upstream commit e5e9fa9f7aad4ad7eedb6359baea9193531bf4ac ]

The main modification is moving the DP AUX initialization from function
analogix_dp_bind() to analogix_dp_probe(). In order to get the EDID of
eDP panel during probing, it is also needed to advance PM operations to
ensure that eDP controller and phy are prepared for AUX transmission.

Signed-off-by: Damon Ding <damon.ding@rock-chips.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Link: https://lore.kernel.org/r/20250310104114.2608063-7-damon.ding@rock-chips.com
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Stable-dep-of: fd03f82a026c ("drm/bridge: analogix_dp: Fix clk-disable removal")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/bridge/analogix/analogix_dp_core.c    | 20 ++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c b/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c
index b7a96f5bc0074..28a5326e11b35 100644
--- a/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c
+++ b/drivers/gpu/drm/bridge/analogix/analogix_dp_core.c
@@ -1643,6 +1643,17 @@ analogix_dp_probe(struct device *dev, struct analogix_dp_plat_data *plat_data)
 	}
 	disable_irq(dp->irq);
 
+	dp->aux.name = "DP-AUX";
+	dp->aux.transfer = analogix_dpaux_transfer;
+	dp->aux.dev = dp->dev;
+	drm_dp_aux_init(&dp->aux);
+
+	pm_runtime_use_autosuspend(dp->dev);
+	pm_runtime_set_autosuspend_delay(dp->dev, 100);
+	ret = devm_pm_runtime_enable(dp->dev);
+	if (ret)
+		goto err_disable_clk;
+
 	return dp;
 }
 EXPORT_SYMBOL_GPL(analogix_dp_probe);
@@ -1688,15 +1699,6 @@ int analogix_dp_bind(struct analogix_dp_device *dp, struct drm_device *drm_dev)
 	dp->drm_dev = drm_dev;
 	dp->encoder = dp->plat_data->encoder;
 
-	pm_runtime_use_autosuspend(dp->dev);
-	pm_runtime_set_autosuspend_delay(dp->dev, 100);
-	ret = devm_pm_runtime_enable(dp->dev);
-	if (ret)
-		return ret;
-
-	dp->aux.name = "DP-AUX";
-	dp->aux.transfer = analogix_dpaux_transfer;
-	dp->aux.dev = dp->dev;
 	dp->aux.drm_dev = drm_dev;
 
 	ret = drm_dp_aux_register(&dp->aux);
-- 
2.39.5



