Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 913E339B969;
	Wed, 20 May 2026 16:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295291; cv=none; b=G8+Py2u2OZWqDJ0tsMDrAZiVrjgZRQDGpoRIrHGQLLej4yprEyKHEO6LMY/k4okB/NiVvotQGR92ASa409r4oxyPwhHEzOU7Y5qHkhxSNTE42AQjLmRxyDAtxY4QwtkHJrDTyFnk6uQTThVVTziBR7p/d4sg9Sn7R9KHp9cgIcs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295291; c=relaxed/simple;
	bh=pSFCrCEL3ngAxo7YKBBf6VdBZbkLx4DMaHxo1/k5hRc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uNPQBOdhA1Z+4TM1VHTWkFzCdVvvcKSFNLH179SqGhvb0PYvkWJbFX93pG5HJnZkpAG6hLoZXS6JZkFC0dv679V0vHdRKu2MN3Lrg6zvr4ij8PR8CyNowzJB62Tskji2veNV6a5zCU/M0eyoa3MBeqXC3FSVE6zkrjkNzq6S8/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sOsXp6Bq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sOsXp6Bq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F421D1F000E9;
	Wed, 20 May 2026 16:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295290;
	bh=w8gsoZFt31jUb+5+rfyRqyub8G4/Dl3BicJHsXI5LCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sOsXp6BqQJACkYKialFuuCmrU0+Ued1OGx3QgPCyRyroC5MYvkyIt25+5lTEdRdEH
	 SSmGh1KwUZ1mTQMO3bteqLUU9VVXxp2lm3ixPII9k12h4/Ij2I2aQPnSdNHilu30Bb
	 a7XI1iKWRR1pJpDWHubZYrlFCDMCtzS8psnELTGE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akhil P Oommen <akhilpo@oss.qualcomm.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0363/1146] drm/msm/a6xx: Fix gpu init from secure world
Date: Wed, 20 May 2026 18:10:13 +0200
Message-ID: <20260520162156.416436982@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Akhil P Oommen <akhilpo@oss.qualcomm.com>

[ Upstream commit bb9b1d6e945ea90459bda1aac7e2aa7179119887 ]

A7XX_GEN2 and newer GPUs requires initialization of few configurations
related to features/power from secure world. The SCM call to do this
should be triggered after GDSC and clocks are enabled. So, keep this
sequence to a6xx_gmu_resume instead of the probe.

Also, simplify the error handling in a6xx_gmu_resume() using 'goto'
labels.

Fixes: 14b27d5df3ea ("drm/msm/a7xx: Initialize a750 "software fuse"")
Signed-off-by: Akhil P Oommen <akhilpo@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/714664/
Message-ID: <20260327-a8xx-gpu-batch2-v2-6-2b53c38d2101@oss.qualcomm.com>
Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/a6xx_gmu.c | 93 ++++++++++++++++++++++-----
 drivers/gpu/drm/msm/adreno/a6xx_gmu.h |  2 +
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c | 59 -----------------
 3 files changed, 80 insertions(+), 74 deletions(-)

diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gmu.c b/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
index b41dbca1ebc63..1b44b9e21ad86 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
@@ -3,6 +3,7 @@
 
 #include <linux/bitfield.h>
 #include <linux/clk.h>
+#include <linux/firmware/qcom/qcom_scm.h>
 #include <linux/interconnect.h>
 #include <linux/of_platform.h>
 #include <linux/platform_device.h>
@@ -1191,6 +1192,65 @@ static void a6xx_gmu_set_initial_bw(struct msm_gpu *gpu, struct a6xx_gmu *gmu)
 	dev_pm_opp_put(gpu_opp);
 }
 
+static int a6xx_gmu_secure_init(struct a6xx_gpu *a6xx_gpu)
+{
+	struct adreno_gpu *adreno_gpu = &a6xx_gpu->base;
+	struct msm_gpu *gpu = &adreno_gpu->base;
+	struct a6xx_gmu *gmu = &a6xx_gpu->gmu;
+	u32 fuse_val;
+	int ret;
+
+	if (test_bit(GMU_STATUS_SECURE_INIT, &gmu->status))
+		return 0;
+
+	if (adreno_is_a750(adreno_gpu) || adreno_is_a8xx(adreno_gpu)) {
+		/*
+		 * Assume that if qcom scm isn't available, that whatever
+		 * replacement allows writing the fuse register ourselves.
+		 * Users of alternative firmware need to make sure this
+		 * register is writeable or indicate that it's not somehow.
+		 * Print a warning because if you mess this up you're about to
+		 * crash horribly.
+		 */
+		if (!qcom_scm_is_available()) {
+			dev_warn_once(gpu->dev->dev,
+				"SCM is not available, poking fuse register\n");
+			a6xx_llc_write(a6xx_gpu, REG_A7XX_CX_MISC_SW_FUSE_VALUE,
+				A7XX_CX_MISC_SW_FUSE_VALUE_RAYTRACING |
+				A7XX_CX_MISC_SW_FUSE_VALUE_FASTBLEND |
+				A7XX_CX_MISC_SW_FUSE_VALUE_LPAC);
+			adreno_gpu->has_ray_tracing = true;
+			goto done;
+		}
+
+		ret = qcom_scm_gpu_init_regs(QCOM_SCM_GPU_ALWAYS_EN_REQ |
+					     QCOM_SCM_GPU_TSENSE_EN_REQ);
+		if (ret) {
+			dev_warn_once(gpu->dev->dev,
+				"SCM call failed\n");
+			return ret;
+		}
+
+		/*
+		 * On A7XX_GEN3 and newer, raytracing may be disabled by the
+		 * firmware, find out whether that's the case. The scm call
+		 * above sets the fuse register.
+		 */
+		fuse_val = a6xx_llc_read(a6xx_gpu,
+					 REG_A7XX_CX_MISC_SW_FUSE_VALUE);
+		adreno_gpu->has_ray_tracing =
+			!!(fuse_val & A7XX_CX_MISC_SW_FUSE_VALUE_RAYTRACING);
+	} else if (adreno_is_a740(adreno_gpu)) {
+		/* Raytracing is always enabled on a740 */
+		adreno_gpu->has_ray_tracing = true;
+	}
+
+done:
+	set_bit(GMU_STATUS_SECURE_INIT, &gmu->status);
+	return 0;
+}
+
+
 int a6xx_gmu_resume(struct a6xx_gpu *a6xx_gpu)
 {
 	struct adreno_gpu *adreno_gpu = &a6xx_gpu->base;
@@ -1219,11 +1279,12 @@ int a6xx_gmu_resume(struct a6xx_gpu *a6xx_gpu)
 	clk_set_rate(gmu->hub_clk, adreno_is_a740_family(adreno_gpu) ?
 		     200000000 : 150000000);
 	ret = clk_bulk_prepare_enable(gmu->nr_clocks, gmu->clocks);
-	if (ret) {
-		pm_runtime_put(gmu->gxpd);
-		pm_runtime_put(gmu->dev);
-		return ret;
-	}
+	if (ret)
+		goto rpm_put;
+
+	ret = a6xx_gmu_secure_init(a6xx_gpu);
+	if (ret)
+		goto disable_clk;
 
 	/* Read the slice info on A8x GPUs */
 	a8xx_gpu_get_slice_info(gpu);
@@ -1253,11 +1314,11 @@ int a6xx_gmu_resume(struct a6xx_gpu *a6xx_gpu)
 
 	ret = a6xx_gmu_fw_start(gmu, status);
 	if (ret)
-		goto out;
+		goto disable_irq;
 
 	ret = a6xx_hfi_start(gmu, status);
 	if (ret)
-		goto out;
+		goto disable_irq;
 
 	/*
 	 * Turn on the GMU firmware fault interrupt after we know the boot
@@ -1270,14 +1331,16 @@ int a6xx_gmu_resume(struct a6xx_gpu *a6xx_gpu)
 	/* Set the GPU to the current freq */
 	a6xx_gmu_set_initial_freq(gpu, gmu);
 
-out:
-	/* On failure, shut down the GMU to leave it in a good state */
-	if (ret) {
-		disable_irq(gmu->gmu_irq);
-		a6xx_rpmh_stop(gmu);
-		pm_runtime_put(gmu->gxpd);
-		pm_runtime_put(gmu->dev);
-	}
+	return 0;
+
+disable_irq:
+	disable_irq(gmu->gmu_irq);
+	a6xx_rpmh_stop(gmu);
+disable_clk:
+	clk_bulk_disable_unprepare(gmu->nr_clocks, gmu->clocks);
+rpm_put:
+	pm_runtime_put(gmu->gxpd);
+	pm_runtime_put(gmu->dev);
 
 	return ret;
 }
diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gmu.h b/drivers/gpu/drm/msm/adreno/a6xx_gmu.h
index 9f09daf45ab2b..0cd8ae1b4f5c8 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gmu.h
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gmu.h
@@ -130,6 +130,8 @@ struct a6xx_gmu {
 #define GMU_STATUS_PDC_SLEEP	1
 /* To track Perfcounter OOB set status */
 #define GMU_STATUS_OOB_PERF_SET 2
+/* To track whether secure world init was done */
+#define GMU_STATUS_SECURE_INIT	3
 	unsigned long status;
 };
 
diff --git a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
index 9327ecf94386e..0e8a48ca816dd 100644
--- a/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gpu.c
@@ -10,7 +10,6 @@
 
 #include <linux/bitfield.h>
 #include <linux/devfreq.h>
-#include <linux/firmware/qcom/qcom_scm.h>
 #include <linux/pm_domain.h>
 #include <linux/soc/qcom/llcc-qcom.h>
 
@@ -2160,56 +2159,6 @@ static void a6xx_llc_slices_init(struct platform_device *pdev,
 		a6xx_gpu->llc_mmio = ERR_PTR(-EINVAL);
 }
 
-static int a7xx_cx_mem_init(struct a6xx_gpu *a6xx_gpu)
-{
-	struct adreno_gpu *adreno_gpu = &a6xx_gpu->base;
-	struct msm_gpu *gpu = &adreno_gpu->base;
-	u32 fuse_val;
-	int ret;
-
-	if (adreno_is_a750(adreno_gpu) || adreno_is_a8xx(adreno_gpu)) {
-		/*
-		 * Assume that if qcom scm isn't available, that whatever
-		 * replacement allows writing the fuse register ourselves.
-		 * Users of alternative firmware need to make sure this
-		 * register is writeable or indicate that it's not somehow.
-		 * Print a warning because if you mess this up you're about to
-		 * crash horribly.
-		 */
-		if (!qcom_scm_is_available()) {
-			dev_warn_once(gpu->dev->dev,
-				"SCM is not available, poking fuse register\n");
-			a6xx_llc_write(a6xx_gpu, REG_A7XX_CX_MISC_SW_FUSE_VALUE,
-				A7XX_CX_MISC_SW_FUSE_VALUE_RAYTRACING |
-				A7XX_CX_MISC_SW_FUSE_VALUE_FASTBLEND |
-				A7XX_CX_MISC_SW_FUSE_VALUE_LPAC);
-			adreno_gpu->has_ray_tracing = true;
-			return 0;
-		}
-
-		ret = qcom_scm_gpu_init_regs(QCOM_SCM_GPU_ALWAYS_EN_REQ |
-					     QCOM_SCM_GPU_TSENSE_EN_REQ);
-		if (ret)
-			return ret;
-
-		/*
-		 * On A7XX_GEN3 and newer, raytracing may be disabled by the
-		 * firmware, find out whether that's the case. The scm call
-		 * above sets the fuse register.
-		 */
-		fuse_val = a6xx_llc_read(a6xx_gpu,
-					 REG_A7XX_CX_MISC_SW_FUSE_VALUE);
-		adreno_gpu->has_ray_tracing =
-			!!(fuse_val & A7XX_CX_MISC_SW_FUSE_VALUE_RAYTRACING);
-	} else if (adreno_is_a740(adreno_gpu)) {
-		/* Raytracing is always enabled on a740 */
-		adreno_gpu->has_ray_tracing = true;
-	}
-
-	return 0;
-}
-
-
 #define GBIF_CLIENT_HALT_MASK		BIT(0)
 #define GBIF_ARB_HALT_MASK		BIT(1)
 #define VBIF_XIN_HALT_CTRL0_MASK	GENMASK(3, 0)
@@ -2706,14 +2655,6 @@ static struct msm_gpu *a6xx_gpu_init(struct drm_device *dev)
 		return ERR_PTR(ret);
 	}
 
-	if (adreno_is_a7xx(adreno_gpu) || adreno_is_a8xx(adreno_gpu)) {
-		ret = a7xx_cx_mem_init(a6xx_gpu);
-		if (ret) {
-			a6xx_destroy(&(a6xx_gpu->base.base));
-			return ERR_PTR(ret);
-		}
-	}
-
 	adreno_gpu->uche_trap_base = 0x1fffffffff000ull;
 
 	msm_mmu_set_fault_handler(to_msm_vm(gpu->vm)->mmu, gpu,
-- 
2.53.0



