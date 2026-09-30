Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2DE351C067;
	Wed, 30 Sep 2026 17:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791095; cv=none; b=pZJj3v/ZdxeQ+x/+0g9BvTcC/HelXmf+AFumXBi/ECzVm+T3XAOKcnp5FfPLU1Zm78pmLHrZbsAWC02nVFrWvNScqDABfTh3dVd5kjONLN13Llv28yrFST0xxUpAojXR2AiQE2FccAJAguV6eR8PG3tNYfeFo3eXTCTMfGUzOks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791095; c=relaxed/simple;
	bh=h5U0Cxc+TkK8vqZx2eHOcjjhUxsZogBvmUYFDV3YDZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AMTWusQrzyIROFDnQpjBJDg1W37rOy4p8e06chm98PN+WYbhCLg1ac/WF5qAPaiEHDklUAOjRMdZGaokDxzKLr8wbFuIXuMDuzqdg0UvpWFB8CNLDS41dLRBqDLa7VFhYirmY5m/5HmVXUIZXA9u94HcPZjichOyfrq0ky1n2xA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iCjKEq6s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iCjKEq6s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 545E01F000FF;
	Wed, 30 Sep 2026 17:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791093;
	bh=KfupcYW36nz+JLIrhJRjuhZ2KarVoxCDYt7uD1wCHTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iCjKEq6slNoKJmWjYmZO4kBL3lfncuUQ5G/As2a0RiW8TfFQpWx1cs70grE62iu/o
	 Zqp85Xv65Ri7GnB6snSkuURU8vnvBIw53s7xzPcbcoQ5xv76DrPZdwM/YDDyOfaqVP
	 cOhiwgaJlGRF0bIK/4HUaf+2kSbUlyGOkUYP3fzk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Gustavo=20Kenji=20Mendon=C3=A7a=20Kaneko?= <kaneko.dev@pm.me>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 183/752] drm/arm/komeda: fix error handling for clk_prepare_enable() and callers
Date: Wed, 30 Sep 2026 17:20:53 +0200
Message-ID: <20260930152402.164621101@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index cc7664c95a547..5df7756efd525 100644
--- a/drivers/gpu/drm/arm/display/komeda/komeda_dev.c
+++ b/drivers/gpu/drm/arm/display/komeda/komeda_dev.c
@@ -321,7 +321,11 @@ void komeda_dev_destroy(struct komeda_dev *mdev)
 
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



