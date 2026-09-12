Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F3F141A508;
	Sat, 12 Sep 2026 10:32:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209174; cv=none; b=CBC4ljYuJ1U+cTGXjpGXWX7K379lNvfe9PY4v/8TzkAyOCrc0uQDikDThjs9uFWmpYU+tcrgbSIJ9PWgGS51+AEBVAO7bKpFnJcjzcS5XSHPhB5ZzYqHVSzRwH3TSGo6Ch6hecZ9bJVVPOjJLsDhWqGLnqA+IJvUhBDz9/bRtes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209174; c=relaxed/simple;
	bh=LDRvlXEB6b41dJ5vnNYJB2OOghOoFPvAEpBn9iL6ASM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tdbomSUSVoQO7+mNvz9EPSH+2RdLPS21Ul30sQ97pjiCcfAluLIpu+h/emc6xXW9rA7aG/n97Y+SnZLnE/3LTqo0/R4+MbHb/UsqTVwmDPIHSFVL57/kg3qO7WuEe3jWnNBcXe3RMb/c14MuLxNz8hiKD8NLpX8nO49jccPMZVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aZKdSuuX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aZKdSuuX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 608CA1F000FF;
	Sat, 12 Sep 2026 10:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209172;
	bh=4FTqg5DoJa1HnsGJCtjsrWkuMg+IH/hTfCl5VLH+uDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aZKdSuuX4uqJIo3I5qH0jUfGV3I5Yp0qJaRa/WCjTXePxW1qWng7hGUTdG/hH/Xgb
	 cxZMoVL+WXlsCss2I+GDcIhygGAY5PApOZfouuifO3mOSMQ612bnMmCAxiMxOU1Gq1
	 KSrUl3IGLSC3jnaSZPSVbdVFYAUF3hgvXAFr1534=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0766/1518] drm/msm: dont tear down KMS twice when KMS init fails
Date: Sat, 12 Sep 2026 08:48:55 +0200
Message-ID: <20260912065640.761357968@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

[ Upstream commit 93c125e4ea98fb25f927ba5a334d85845127d667 ]

When priv->kms_init() (mdp4_kms_init() / mdp5_kms_init()) fails partway
through, both display drivers already tear their KMS state down via
mdp4_destroy() / mdp5_kms_destroy() before returning the error. The
common error path in msm_drm_init() then runs msm_drm_uninit() ->
msm_drm_kms_uninit(), which tries to destroy the very same KMS a second
time, which causes a use-after-free crash.

Bring MDP4/MDP5 in line with the DPU driver whose dpu_kms_init() doesn't
perform error cleanup on the failure. Let the common path own the
cleanup, instead of freeing the KMS from their error paths.

The crash trace for the reference:

  __lock_acquire from lock_acquire (kernel/locking/lockdep.c:5906 kernel/locking/lockdep.c:5863)
  lock_acquire from touch_wq_lockdep_map (kernel/workqueue.c:4094 (discriminator 1))
  touch_wq_lockdep_map from __flush_workqueue (kernel/workqueue.c:4136)
  __flush_workqueue from msm_drm_kms_uninit (drivers/gpu/drm/msm/msm_kms.c:243 (discriminator 33))
  msm_drm_kms_uninit from msm_drm_uninit (drivers/gpu/drm/msm/msm_drv.c:93)
  msm_drm_uninit from msm_drm_init (drivers/gpu/drm/msm/msm_drv.c:184)
  msm_drm_init from try_to_bring_up_aggregate_device (drivers/base/component.c:249 drivers/base/component.c:227)
  try_to_bring_up_aggregate_device from __component_add (drivers/base/component.c:269 drivers/base/component.c:748)
  __component_add from dsi_host_attach (drivers/gpu/drm/msm/dsi/dsi_host.c:1739)
  dsi_host_attach from mipi_dsi_attach (drivers/gpu/drm/drm_mipi_dsi.c:383)
  mipi_dsi_attach from sharp_nt_panel_probe (drivers/gpu/drm/panel/panel-sharp-ls043t1le01.c:247)

Fixes: 506efcba3129 ("drm/msm: carve out KMS code from msm_drv.c")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/742068/
Link: https://lore.kernel.org/r/20260723-msm-fix-crash-v1-1-78fb4721c2d9@oss.qualcomm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/disp/mdp4/mdp4_kms.c | 22 ++++++++--------------
 drivers/gpu/drm/msm/disp/mdp5/mdp5_kms.c | 11 +++--------
 2 files changed, 11 insertions(+), 22 deletions(-)

diff --git a/drivers/gpu/drm/msm/disp/mdp4/mdp4_kms.c b/drivers/gpu/drm/msm/disp/mdp4/mdp4_kms.c
index 809ca191e9de7..c5cd19d1a486a 100644
--- a/drivers/gpu/drm/msm/disp/mdp4/mdp4_kms.c
+++ b/drivers/gpu/drm/msm/disp/mdp4/mdp4_kms.c
@@ -405,7 +405,7 @@ static int mdp4_kms_init(struct drm_device *dev)
 	ret = mdp_kms_init(&mdp4_kms->base, &kms_funcs);
 	if (ret) {
 		DRM_DEV_ERROR(dev->dev, "failed to init kms\n");
-		goto fail;
+		return ret;
 	}
 
 	kms = priv->kms;
@@ -416,7 +416,7 @@ static int mdp4_kms_init(struct drm_device *dev)
 		ret = regulator_enable(mdp4_kms->vdd);
 		if (ret) {
 			DRM_DEV_ERROR(dev->dev, "failed to enable regulator vdd: %d\n", ret);
-			goto fail;
+			return ret;
 		}
 	}
 
@@ -428,7 +428,7 @@ static int mdp4_kms_init(struct drm_device *dev)
 		DRM_DEV_ERROR(dev->dev, "unexpected MDP version: v%d.%d\n",
 			      major, minor);
 		ret = -ENXIO;
-		goto fail;
+		return ret;
 	}
 
 	mdp4_kms->rev = minor;
@@ -437,7 +437,7 @@ static int mdp4_kms_init(struct drm_device *dev)
 		if (!mdp4_kms->lut_clk) {
 			DRM_DEV_ERROR(dev->dev, "failed to get lut_clk\n");
 			ret = -ENODEV;
-			goto fail;
+			return ret;
 		}
 		clk_set_rate(mdp4_kms->lut_clk, max_clk);
 	}
@@ -459,7 +459,7 @@ static int mdp4_kms_init(struct drm_device *dev)
 	vm = msm_kms_init_vm(mdp4_kms->dev, NULL);
 	if (IS_ERR(vm)) {
 		ret = PTR_ERR(vm);
-		goto fail;
+		return ret;
 	}
 
 	kms->vm = vm;
@@ -467,7 +467,7 @@ static int mdp4_kms_init(struct drm_device *dev)
 	ret = modeset_init(mdp4_kms);
 	if (ret) {
 		DRM_DEV_ERROR(dev->dev, "modeset_init failed: %d\n", ret);
-		goto fail;
+		return ret;
 	}
 
 	mdp4_kms->blank_cursor_bo = msm_gem_new(dev, SZ_16K, MSM_BO_WC | MSM_BO_SCANOUT);
@@ -475,14 +475,14 @@ static int mdp4_kms_init(struct drm_device *dev)
 		ret = PTR_ERR(mdp4_kms->blank_cursor_bo);
 		DRM_DEV_ERROR(dev->dev, "could not allocate blank-cursor bo: %d\n", ret);
 		mdp4_kms->blank_cursor_bo = NULL;
-		goto fail;
+		return ret;
 	}
 
 	ret = msm_gem_get_and_pin_iova(mdp4_kms->blank_cursor_bo, kms->vm,
 			&mdp4_kms->blank_cursor_iova);
 	if (ret) {
 		DRM_DEV_ERROR(dev->dev, "could not pin blank-cursor bo: %d\n", ret);
-		goto fail;
+		return ret;
 	}
 
 	dev->mode_config.min_width = 0;
@@ -491,12 +491,6 @@ static int mdp4_kms_init(struct drm_device *dev)
 	dev->mode_config.max_height = 2048;
 
 	return 0;
-
-fail:
-	if (kms)
-		mdp4_destroy(kms);
-
-	return ret;
 }
 
 static const struct dev_pm_ops mdp4_pm_ops = {
diff --git a/drivers/gpu/drm/msm/disp/mdp5/mdp5_kms.c b/drivers/gpu/drm/msm/disp/mdp5/mdp5_kms.c
index 61edf68640926..0b6b97be3ce93 100644
--- a/drivers/gpu/drm/msm/disp/mdp5/mdp5_kms.c
+++ b/drivers/gpu/drm/msm/disp/mdp5/mdp5_kms.c
@@ -514,7 +514,7 @@ static int mdp5_kms_init(struct drm_device *dev)
 	ret = mdp_kms_init(&mdp5_kms->base, &kms_funcs);
 	if (ret) {
 		DRM_DEV_ERROR(&pdev->dev, "failed to init kms\n");
-		goto fail;
+		return ret;
 	}
 
 	config = mdp5_cfg_get_config(mdp5_kms->cfg);
@@ -537,7 +537,7 @@ static int mdp5_kms_init(struct drm_device *dev)
 	vm = msm_kms_init_vm(mdp5_kms->dev, pdev->dev.parent);
 	if (IS_ERR(vm)) {
 		ret = PTR_ERR(vm);
-		goto fail;
+		return ret;
 	}
 
 	kms->vm = vm;
@@ -547,7 +547,7 @@ static int mdp5_kms_init(struct drm_device *dev)
 	ret = modeset_init(mdp5_kms);
 	if (ret) {
 		DRM_DEV_ERROR(&pdev->dev, "modeset_init failed: %d\n", ret);
-		goto fail;
+		return ret;
 	}
 
 	dev->mode_config.min_width = 0;
@@ -559,11 +559,6 @@ static int mdp5_kms_init(struct drm_device *dev)
 	dev->vblank_disable_immediate = true;
 
 	return 0;
-fail:
-	if (kms)
-		mdp5_kms_destroy(kms);
-
-	return ret;
 }
 
 static void mdp5_destroy(struct mdp5_kms *mdp5_kms)
-- 
2.53.0



