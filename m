Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6C392C870
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:26:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CoqkQDxn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86DF4C433C9;
	Wed, 15 Nov 2023 19:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076372;
	bh=sj7kkNMUiDk68FRiA8W0E2uN83AAPqvUTzPednt2qW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CoqkQDxngN0975xZgfatobvoS2t0XwPEJrk7Vx9ktmL8Ye8Si4ymAr4b7vNAR1/UM
	 Ahn3/c2kthXQ1+LYasKFss5hQUrMpalY40n630flOE6rh/vk2Y06MpNZqvGuSIoSsH
	 RGulOyo9v3cimWcaqPSSHeIAiqeanBVz5fuaZ5/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	=?UTF-8?q?Rapha=C3=ABl=20Gallais-Pou?= <raphael.gallais-pou@foss.st.com>,
	Douglas Anderson <dianders@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 226/550] drm/stm: Convert to platform remove callback returning void
Date: Wed, 15 Nov 2023 14:13:30 -0500
Message-ID: <20231115191616.447513047@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit 0c259ab1914664a9865ddebe9baf66e0b5a25b08 ]

The .remove() callback for a platform driver returns an int which makes
many driver authors wrongly assume it's possible to do error handling by
returning an error code. However the value returned is (mostly) ignored
and this typically results in resource leaks. To improve here there is a
quest to make the remove callback return void. In the first step of this
quest all drivers are converted to .remove_new() which already returns
void.

Trivially convert the stm drm drivers from always returning zero in the
remove callback to the void returning variant.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Acked-by: Raphaël Gallais-Pou <raphael.gallais-pou@foss.st.com>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20230507162616.1368908-43-u.kleine-koenig@pengutronix.de
Stable-dep-of: 3c4babae3c4a ("drm: Call drm_atomic_helper_shutdown() at shutdown/remove time for misc drivers")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/stm/drv.c             | 6 ++----
 drivers/gpu/drm/stm/dw_mipi_dsi-stm.c | 6 ++----
 2 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/drm/stm/drv.c b/drivers/gpu/drm/stm/drv.c
index cb4404b3ce62c..c387fb5a87c3d 100644
--- a/drivers/gpu/drm/stm/drv.c
+++ b/drivers/gpu/drm/stm/drv.c
@@ -213,7 +213,7 @@ static int stm_drm_platform_probe(struct platform_device *pdev)
 	return ret;
 }
 
-static int stm_drm_platform_remove(struct platform_device *pdev)
+static void stm_drm_platform_remove(struct platform_device *pdev)
 {
 	struct drm_device *ddev = platform_get_drvdata(pdev);
 
@@ -222,8 +222,6 @@ static int stm_drm_platform_remove(struct platform_device *pdev)
 	drm_dev_unregister(ddev);
 	drv_unload(ddev);
 	drm_dev_put(ddev);
-
-	return 0;
 }
 
 static const struct of_device_id drv_dt_ids[] = {
@@ -234,7 +232,7 @@ MODULE_DEVICE_TABLE(of, drv_dt_ids);
 
 static struct platform_driver stm_drm_platform_driver = {
 	.probe = stm_drm_platform_probe,
-	.remove = stm_drm_platform_remove,
+	.remove_new = stm_drm_platform_remove,
 	.driver = {
 		.name = "stm32-display",
 		.of_match_table = drv_dt_ids,
diff --git a/drivers/gpu/drm/stm/dw_mipi_dsi-stm.c b/drivers/gpu/drm/stm/dw_mipi_dsi-stm.c
index 1750b6a25e871..d5f8c923d7bc7 100644
--- a/drivers/gpu/drm/stm/dw_mipi_dsi-stm.c
+++ b/drivers/gpu/drm/stm/dw_mipi_dsi-stm.c
@@ -535,15 +535,13 @@ static int dw_mipi_dsi_stm_probe(struct platform_device *pdev)
 	return ret;
 }
 
-static int dw_mipi_dsi_stm_remove(struct platform_device *pdev)
+static void dw_mipi_dsi_stm_remove(struct platform_device *pdev)
 {
 	struct dw_mipi_dsi_stm *dsi = platform_get_drvdata(pdev);
 
 	dw_mipi_dsi_remove(dsi->dsi);
 	clk_disable_unprepare(dsi->pllref_clk);
 	regulator_disable(dsi->vdd_supply);
-
-	return 0;
 }
 
 static int __maybe_unused dw_mipi_dsi_stm_suspend(struct device *dev)
@@ -588,7 +586,7 @@ static const struct dev_pm_ops dw_mipi_dsi_stm_pm_ops = {
 
 static struct platform_driver dw_mipi_dsi_stm_driver = {
 	.probe		= dw_mipi_dsi_stm_probe,
-	.remove		= dw_mipi_dsi_stm_remove,
+	.remove_new	= dw_mipi_dsi_stm_remove,
 	.driver		= {
 		.of_match_table = dw_mipi_dsi_stm_dt_ids,
 		.name	= "stm32-display-dsi",
-- 
2.42.0



