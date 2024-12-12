Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3B0C22A7FF;
	Thu, 12 Dec 2024 16:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019283; cv=none; b=ovgIOQB7SI+0FYpp6BvOgJum6AIFT93qgbyV8FurKT4W3F0CukXh8i5D8tQo9PMezxkJQ4AmPXQjz/p8B7+VtarsbeZ6cmG/PaQVyFpoKTXHJDLi6Jah6e1bpwORHL/JbnKqvpGMAfHS1BSQjd3ivV31YPqkGADx6o89TnTUJoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019283; c=relaxed/simple;
	bh=MDgJS3UHi2/Kp1gEdz9iTUIj7qzHZI1WLru6kvl7IgM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NfBZABsUdYkrCde+6CZSjJsmhhx3ezR3SNmPEYiHrVDQ8lQ4+BcYe/myCyxKFfOodjSJy8nmlaDWwThG66DV8ioYgeb0NXo3mr5ga1cEIeXe9qv9mrBWfbXdfj+5pE+H1+NZ7C0U490AAntl6cQVJqEH+wYGdWdzYiDDrhUEc8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bMgvv91U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bMgvv91U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68E0CC4CECE;
	Thu, 12 Dec 2024 16:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019282;
	bh=MDgJS3UHi2/Kp1gEdz9iTUIj7qzHZI1WLru6kvl7IgM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bMgvv91UTjZzNjs5vi/CU+lGvs5+SWpoCBLO0bL6Km84Ar56eON/7wh1l+gaJabSs
	 OPCOjwzFctsRRvuWXTCqEykg7rpvKm7X6IPMrwmuGd9Ps8UDWMCGU3Sys33dLgVJUz
	 duXc6sLrS+slAibUS7tpUr9jDKJWgauPi9P2MpQM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rob Clark <robdclark@chromium.org>,
	Chia-I Wu <olvaffe@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 167/772] drm/msm/gpu: Add devfreq tuning debugfs
Date: Thu, 12 Dec 2024 15:51:52 +0100
Message-ID: <20241212144356.844371053@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rob Clark <robdclark@chromium.org>

[ Upstream commit 6563f60f14cbb3dcbdc4e1d8469fc0fbaaa80544 ]

Make the handful of tuning knobs available visible via debugfs.

v2: select DEVFREQ_GOV_SIMPLE_ONDEMAND because for some reason
    struct devfreq_simple_ondemand_data depends on this

Signed-off-by: Rob Clark <robdclark@chromium.org>
Patchwork: https://patchwork.freedesktop.org/patch/517784/
Link: https://lore.kernel.org/r/20230110231447.1939101-2-robdclark@gmail.com
Reviewed-by: Chia-I Wu <olvaffe@gmail.com>
Stable-dep-of: 8f32ddd87e49 ("drm/msm/gpu: Check the status of registration to PM QoS")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/Kconfig           |  1 +
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c |  2 +-
 drivers/gpu/drm/msm/msm_debugfs.c     | 12 ++++++++++++
 drivers/gpu/drm/msm/msm_drv.h         |  9 +++++++++
 drivers/gpu/drm/msm/msm_gpu.h         |  3 ---
 drivers/gpu/drm/msm/msm_gpu_devfreq.c |  6 ++++--
 6 files changed, 27 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/msm/Kconfig b/drivers/gpu/drm/msm/Kconfig
index 3c9dfdb0b3283..f7abacb4b221b 100644
--- a/drivers/gpu/drm/msm/Kconfig
+++ b/drivers/gpu/drm/msm/Kconfig
@@ -23,6 +23,7 @@ config DRM_MSM
 	select SHMEM
 	select TMPFS
 	select QCOM_SCM
+	select DEVFREQ_GOV_SIMPLE_ONDEMAND
 	select WANT_DEV_COREDUMP
 	select SND_SOC_HDMI_CODEC if SND_SOC
 	select SYNC_FILE
diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
index d6a810b7cfa2c..cdb4665b953c8 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
@@ -2056,7 +2056,7 @@ struct msm_gpu *a6xx_gpu_init(struct drm_device *dev)
 	 * to cause power supply issues:
 	 */
 	if (adreno_is_a618(adreno_gpu) || adreno_is_7c3(adreno_gpu))
-		gpu->clamp_to_idle = true;
+		priv->gpu_clamp_to_idle = true;
 
 	/* Check if there is a GMU phandle and set it up */
 	node = of_parse_phandle(pdev->dev.of_node, "qcom,gmu", 0);
diff --git a/drivers/gpu/drm/msm/msm_debugfs.c b/drivers/gpu/drm/msm/msm_debugfs.c
index 95f4374ae21c2..d6ecff0ab6187 100644
--- a/drivers/gpu/drm/msm/msm_debugfs.c
+++ b/drivers/gpu/drm/msm/msm_debugfs.c
@@ -305,6 +305,7 @@ void msm_debugfs_init(struct drm_minor *minor)
 {
 	struct drm_device *dev = minor->dev;
 	struct msm_drm_private *priv = dev->dev_private;
+	struct dentry *gpu_devfreq;
 
 	drm_debugfs_create_files(msm_debugfs_list,
 				 ARRAY_SIZE(msm_debugfs_list),
@@ -325,6 +326,17 @@ void msm_debugfs_init(struct drm_minor *minor)
 	debugfs_create_file("shrink", S_IRWXU, minor->debugfs_root,
 		dev, &shrink_fops);
 
+	gpu_devfreq = debugfs_create_dir("devfreq", minor->debugfs_root);
+
+	debugfs_create_bool("idle_clamp",0600, gpu_devfreq,
+			    &priv->gpu_clamp_to_idle);
+
+	debugfs_create_u32("upthreshold",0600, gpu_devfreq,
+			   &priv->gpu_devfreq_config.upthreshold);
+
+	debugfs_create_u32("downdifferential",0600, gpu_devfreq,
+			   &priv->gpu_devfreq_config.downdifferential);
+
 	if (priv->kms && priv->kms->funcs->debugfs_init)
 		priv->kms->funcs->debugfs_init(priv->kms, minor);
 
diff --git a/drivers/gpu/drm/msm/msm_drv.h b/drivers/gpu/drm/msm/msm_drv.h
index d4e0ef608950e..81deb112ea446 100644
--- a/drivers/gpu/drm/msm/msm_drv.h
+++ b/drivers/gpu/drm/msm/msm_drv.h
@@ -11,6 +11,7 @@
 #include <linux/kernel.h>
 #include <linux/clk.h>
 #include <linux/cpufreq.h>
+#include <linux/devfreq.h>
 #include <linux/module.h>
 #include <linux/component.h>
 #include <linux/platform_device.h>
@@ -233,6 +234,14 @@ struct msm_drm_private {
 	 */
 	unsigned int hangcheck_period;
 
+	/** gpu_devfreq_config: Devfreq tuning config for the GPU. */
+	struct devfreq_simple_ondemand_data gpu_devfreq_config;
+
+	/**
+	 * gpu_clamp_to_idle: Enable clamping to idle freq when inactive
+	 */
+	bool gpu_clamp_to_idle;
+
 	/**
 	 * disable_err_irq:
 	 *
diff --git a/drivers/gpu/drm/msm/msm_gpu.h b/drivers/gpu/drm/msm/msm_gpu.h
index b39cd332751dc..a326b6d1adbe2 100644
--- a/drivers/gpu/drm/msm/msm_gpu.h
+++ b/drivers/gpu/drm/msm/msm_gpu.h
@@ -275,9 +275,6 @@ struct msm_gpu {
 
 	struct msm_gpu_state *crashstate;
 
-	/* Enable clamping to idle freq when inactive: */
-	bool clamp_to_idle;
-
 	/* True if the hardware supports expanded apriv (a650 and newer) */
 	bool hw_apriv;
 
diff --git a/drivers/gpu/drm/msm/msm_gpu_devfreq.c b/drivers/gpu/drm/msm/msm_gpu_devfreq.c
index 85c443a37e4e8..1f4e2dd8e76dd 100644
--- a/drivers/gpu/drm/msm/msm_gpu_devfreq.c
+++ b/drivers/gpu/drm/msm/msm_gpu_devfreq.c
@@ -183,6 +183,7 @@ static bool has_devfreq(struct msm_gpu *gpu)
 void msm_devfreq_init(struct msm_gpu *gpu)
 {
 	struct msm_gpu_devfreq *df = &gpu->devfreq;
+	struct msm_drm_private *priv = gpu->dev->dev_private;
 
 	/* We need target support to do devfreq */
 	if (!gpu->funcs->gpu_busy)
@@ -209,7 +210,7 @@ void msm_devfreq_init(struct msm_gpu *gpu)
 
 	df->devfreq = devm_devfreq_add_device(&gpu->pdev->dev,
 			&msm_devfreq_profile, DEVFREQ_GOV_SIMPLE_ONDEMAND,
-			NULL);
+			&priv->gpu_devfreq_config);
 
 	if (IS_ERR(df->devfreq)) {
 		DRM_DEV_ERROR(&gpu->pdev->dev, "Couldn't initialize GPU devfreq\n");
@@ -358,10 +359,11 @@ static void msm_devfreq_idle_work(struct kthread_work *work)
 	struct msm_gpu_devfreq *df = container_of(work,
 			struct msm_gpu_devfreq, idle_work.work);
 	struct msm_gpu *gpu = container_of(df, struct msm_gpu, devfreq);
+	struct msm_drm_private *priv = gpu->dev->dev_private;
 
 	df->idle_time = ktime_get();
 
-	if (gpu->clamp_to_idle)
+	if (priv->gpu_clamp_to_idle)
 		dev_pm_qos_update_request(&df->idle_freq, 0);
 }
 
-- 
2.43.0



