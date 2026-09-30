Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CAB350B42C;
	Wed, 30 Sep 2026 15:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790782739; cv=none; b=XczlwMWx+TsEEq/+wct/op9f01Ib5NflU05WrfVsWsrP251AOQHRgSuh80eCXzcO3ywFg2/mWMdKeXnkQyXlO123dv/noHR7C5XUXZco+uAV3RwhFafakr3APEvRsMpv5PG2CRE2Dnk0Ku1Q6am66xHE38tS+ONgO+r9w67CdHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790782739; c=relaxed/simple;
	bh=VaN6qvT+yi4eqNnpRrw+eYXZhFQxJQeJA1ND3JdgOtE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rcgHiJlU1hcptGpmW1Y8Mi+fGapVeBYDXrB+RbjKJ+KUW77f2LVH4PKHSyPriplk83l6ezP9VyIX9ApB+7GsbjlVw5zF0yIXWSu36nZFhBZJmtOcYD1kdmKUH/TkYqI91vj+o281DSrYje1ZgwliXiWqqlB2DKJLQSxQCTyIJ44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wNh5e74r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wNh5e74r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5377B1F00893;
	Wed, 30 Sep 2026 15:38:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790782734;
	bh=nxQwN6/rjDjPRIBNNAQ/yViOczxFDNawCxaZZSpBhe4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wNh5e74rM3jpNIe0QWMox0z8dx1KRI/soUCkShF4Sf7kTn1GGCX2qqh06zsaNdE6C
	 XDs976ydsIHZKV3OA+Csy2RpoyCwJrcTNxGwVBX0Mn/kPvHkGNiVh+T0ZpUQ8N5TkN
	 6HimsUSWZR83IwMepm5ZX9qLmjakyr/Ws18hXJFs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Gustavo=20Kenji=20Mendon=C3=A7a=20Kaneko?= <kaneko.dev@pm.me>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 150/595] drm/arm/komeda: fix error handling for clk_prepare_enable() and callers
Date: Wed, 30 Sep 2026 17:20:43 +0200
Message-ID: <20260930152350.960480945@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 1d767473ba8a0..e5eead1505385 100644
--- a/drivers/gpu/drm/arm/display/komeda/komeda_dev.c
+++ b/drivers/gpu/drm/arm/display/komeda/komeda_dev.c
@@ -334,7 +334,11 @@ void komeda_dev_destroy(struct komeda_dev *mdev)
 
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
index e7933930a6577..b7848e4f03faa 100644
--- a/drivers/gpu/drm/arm/display/komeda/komeda_drv.c
+++ b/drivers/gpu/drm/arm/display/komeda/komeda_drv.c
@@ -61,8 +61,11 @@ static int komeda_bind(struct device *dev)
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
@@ -79,7 +82,7 @@ static int komeda_bind(struct device *dev)
 		pm_runtime_disable(dev);
 	else
 		komeda_dev_suspend(mdrv->mdev);
-
+err_destroy_mdev:
 	komeda_dev_destroy(mdrv->mdev);
 
 free_mdrv:
@@ -176,11 +179,12 @@ static int __maybe_unused komeda_pm_suspend(struct device *dev)
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



