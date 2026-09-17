Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F2CF4FDA4C;
	Thu, 17 Sep 2026 17:07:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664879; cv=none; b=N3SZj3kTszxOIXAwpkRO2qXvanmmR8VUsy2HdFRK5y/TxNohYKJCJ/9f7l43rRPniNHGA97+Fa+jRnGgTzXm3mninQZNekNzatl9P0/Ra3b8uRVpUcV883Vaj3ify9UfpfVcdWzJl4+zPis9aewAVC3kmQPEXJ9iP+Y/MAeH6GU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664879; c=relaxed/simple;
	bh=KdjR1D4awLab3GAbjvoafU2fRozVqrRl9wQkG1h8WeM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KKMzz39/KqQgrUQ6w6193dpNJnnPlafs4THfkOpZXzl4gyt85t5EUaHzZzo2mq2TKX6JrU6pHlY608bTcAoOFFyaCXB8pL/TzHJUwUP1jIQmZ1zHeU/rC4LQjkYtPYu8E6vjZ6u5uWxdLyty/vABvzcjG5hawFKU8i44u3lca0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RFd9NLL+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RFd9NLL+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19A4C1F00893;
	Thu, 17 Sep 2026 17:07:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664876;
	bh=6aPm4tE9fgDWXLAMVh/xkFZ/Wg8lt0GGpYBsLhh4LkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RFd9NLL+Gk+PNRhkFsO1Wot8ER2D5STwlx1SXV0T8mzmW90EJ6p/Of440a6RQBYZ3
	 DxecP14M84C/WzB7u0w8jf6LGUTKwjJX3Sx/P9aKZwww70wEbr0dOEgCRWDgOUYSUo
	 1nLfkvhBgg1ATp17qPPQM7SdEjTP6G/HLDkWYYkw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Gustavo=20Kenji=20Mendon=C3=A7a=20Kaneko?= <kaneko.dev@pm.me>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0480/1250] drm/arm/komeda: fix error handling for clk_prepare_enable() and callers
Date: Thu, 17 Sep 2026 16:04:35 +0100
Message-ID: <20260917151604.976978637@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gustavo Kenji Mendonça Kaneko <kaneko.dev@pm.me>

[ Upstream commit 6502eb8cfcd6f7bc5f1f8b73ee524112bd93319d ]

komeda_dev_resume() calls clk_prepare_enable() without checking the
return value. If the clock fails to enable, the function returns 0
(success) while IRQs are enabled and IOMMU is connected on potentially
unclocked hardware, causing undefined behavior on resume.

Propagate the error from clk_prepare_enable() and fix all call sites
in komeda_drv.c that previously ignored the return value of
komeda_dev_resume():

- komeda_platform_probe(): if resume fails, jump to err_destroy_mdev
  (skipping the suspend call, since the clock was never enabled)
- komeda_pm_resume(): propagate the error and skip
  drm_mode_config_helper_resume() on failure

This issue was found by code review without access to Komeda hardware.

Signed-off-by: Gustavo Kenji Mendonça Kaneko <kaneko.dev@pm.me>
Reviewed-by: Liviu Dudau <liviu.dudau@arm.com>
Link: https://patch.msgid.link/20260609130828.1066038-1-kaneko.dev@pm.me
Signed-off-by: Liviu Dudau <liviu.dudau@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/arm/display/komeda/komeda_dev.c |  6 +++++-
 drivers/gpu/drm/arm/display/komeda/komeda_drv.c | 14 +++++++++-----
 2 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/arm/display/komeda/komeda_dev.c b/drivers/gpu/drm/arm/display/komeda/komeda_dev.c
index 5ba62e637a616..9aad1d1d28ec0 100644
--- a/drivers/gpu/drm/arm/display/komeda/komeda_dev.c
+++ b/drivers/gpu/drm/arm/display/komeda/komeda_dev.c
@@ -313,7 +313,11 @@ void komeda_dev_destroy(struct komeda_dev *mdev)
 
 int komeda_dev_resume(struct komeda_dev *mdev)
 {
-	clk_prepare_enable(mdev->aclk);
+	int err;
+
+	err = clk_prepare_enable(mdev->aclk);
+	if (err)
+		return err;
 
 	mdev->funcs->enable_irq(mdev);
 
diff --git a/drivers/gpu/drm/arm/display/komeda/komeda_drv.c b/drivers/gpu/drm/arm/display/komeda/komeda_drv.c
index 358c1512b0879..fc1816c634087 100644
--- a/drivers/gpu/drm/arm/display/komeda/komeda_drv.c
+++ b/drivers/gpu/drm/arm/display/komeda/komeda_drv.c
@@ -74,8 +74,11 @@ static int komeda_platform_probe(struct platform_device *pdev)
 	}
 
 	pm_runtime_enable(dev);
-	if (!pm_runtime_enabled(dev))
-		komeda_dev_resume(mdrv->mdev);
+	if (!pm_runtime_enabled(dev)) {
+		err = komeda_dev_resume(mdrv->mdev);
+		if (err)
+			goto err_destroy_mdev;
+	}
 
 	mdrv->kms = komeda_kms_attach(mdrv->mdev);
 	if (IS_ERR(mdrv->kms)) {
@@ -93,7 +96,7 @@ static int komeda_platform_probe(struct platform_device *pdev)
 		pm_runtime_disable(dev);
 	else
 		komeda_dev_suspend(mdrv->mdev);
-
+err_destroy_mdev:
 	komeda_dev_destroy(mdrv->mdev);
 
 free_mdrv:
@@ -139,11 +142,12 @@ static int __maybe_unused komeda_pm_suspend(struct device *dev)
 static int __maybe_unused komeda_pm_resume(struct device *dev)
 {
 	struct komeda_drv *mdrv = dev_get_drvdata(dev);
+	int err = 0;
 
 	if (!pm_runtime_status_suspended(dev))
-		komeda_dev_resume(mdrv->mdev);
+		err = komeda_dev_resume(mdrv->mdev);
 
-	return drm_mode_config_helper_resume(&mdrv->kms->base);
+	return err ? err : drm_mode_config_helper_resume(&mdrv->kms->base);
 }
 
 static const struct dev_pm_ops komeda_pm_ops = {
-- 
2.53.0



