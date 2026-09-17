Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 354ED3B0586;
	Thu, 17 Sep 2026 18:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668289; cv=none; b=H4dHp3wTPVvgOorasvTeZdvlcH5LGWuI7Bv7Vttfh8dzO/8l3N1C8FOVP1oPaiNCkxzBC7tnkapc2ACsVm5ps2T5tS0ajNdDO33xRhkZcZJXhYVEDZLZau9l6TtLmCxPQptbpwB0MnmD97qc8a8AJ5hogYB2iCPC8m12vWdBiEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668289; c=relaxed/simple;
	bh=fxrhyYY7vwGE4cRUwkoFeQ8j+t46VsVVHdo9xXfiGgA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GHxWNRcoFydTPNr9junQ6ousOmwy4EnkeQagL91KRO9d78OmrvJaKJcd3Fn1MDHwnsLIc01w2dNjM+kK3lnlRXMdfAaxB7ruEJ3W8sIGL9AQwCHie8tU0d69/Vt4gWu0bHL73DRUkpNFmyYyB7aEinS5iNaqmgxhfOAd309VTr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DuNDIrnS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DuNDIrnS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76A5B1F000FF;
	Thu, 17 Sep 2026 18:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668288;
	bh=kNSL6t1WSGJ4Pi0mIuH+woeQ7mLsiPUcpX9IGvxvDFY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DuNDIrnS1RZDozgopYcUyFj33KFQtPRAmYeEfco2zCoJDOTktWqw6TUu/UEfuSnfm
	 +Gy26oMvHGL7cDlY8+sVJy8dJ5TpJzCw7kD9sFP0gXVWdfW1ViopJxUrmRW0PDnrwi
	 +00I4YqNvGmbB1j/De55ooZIIfZvEmEW8qzxtOsg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Gustavo=20Kenji=20Mendon=C3=A7a=20Kaneko?= <kaneko.dev@pm.me>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0376/1102] drm/arm/komeda: fix error handling for clk_prepare_enable() and callers
Date: Thu, 17 Sep 2026 16:05:19 +0100
Message-ID: <20260917151549.093345821@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 55c3773befde2..20a1a11262759 100644
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



