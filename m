Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE0BD246798;
	Tue, 21 Oct 2025 19:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761076760; cv=none; b=su3kFcfCVs+hdKScLHQGM34uPaq6wFli/BLU76u73fy94if6SJXAlD749RT6WC7+OKdmkoTzRNWCGf8nvXPWQ5YmBC+4WChgdgozFjgUcbPoV/Q0vXmyggeZDiFVPofk4GV1uyc23MH584E5oN262Rjok4rvBZ8+skKiKTuBYW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761076760; c=relaxed/simple;
	bh=Xqx5wmOk/m/S0HAuySVpNK2Q1iwjagBv05VmohTMM+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BwdalqqPX0NzBIR5/29RmL1jq4RKu5AkiAXdg42tKDEsZVDfsX/uZ82wwCJItVrPf70CG94WyUmPKvosE5/Vunh/Tb9YnJ73wGVpFAu+ciFa51lR9ZgQOURcu4X5Wl+YbLZP4gyeAiaW+kfhwfzV+P4gdenC9G0sd3aQuCicJJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DygfbSzv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DygfbSzv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7EB0C4CEF1;
	Tue, 21 Oct 2025 19:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761076760;
	bh=Xqx5wmOk/m/S0HAuySVpNK2Q1iwjagBv05VmohTMM+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DygfbSzvP7l3/hJGfFheXUs9K3vOGI+nQgifwLzcFGJhMjC0anjGWYfIYUQvU9+mH
	 nVBMygrqx7nMiRPnpKL5QtLMISVAAB8wowiIUv2l0mP1XRTF1FP8z3a9X1UR2H28YT
	 P0ycyhN7eul+R/9gk9xA9pVTHhgr3aRSuoUieGPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akhil P Oommen <akhilpo@oss.qualcomm.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 029/136] drm/msm/a6xx: Fix PDC sleep sequence
Date: Tue, 21 Oct 2025 21:50:17 +0200
Message-ID: <20251021195036.674001291@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195035.953989698@linuxfoundation.org>
References: <20251021195035.953989698@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Akhil P Oommen <akhilpo@oss.qualcomm.com>

[ Upstream commit f248d5d5159a88ded55329f0b1b463d0f4094228 ]

Since the PDC resides out of the GPU subsystem and cannot be reset in
case it enters bad state, utmost care must be taken to trigger the PDC
wake/sleep routines in the correct order.

The PDC wake sequence can be exercised only after a PDC sleep sequence.
Additionally, GMU firmware should initialize a few registers before the
KMD can trigger a PDC sleep sequence. So PDC sleep can't be done if the
GMU firmware has not initialized. Track these dependencies using a new
status variable and trigger PDC sleep/wake sequences appropriately.

Cc: stable@vger.kernel.org
Fixes: 4b565ca5a2cb ("drm/msm: Add A6XX device support")
Signed-off-by: Akhil P Oommen <akhilpo@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/673362/
Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
[ Adjust context ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/msm/adreno/a6xx_gmu.c |   28 +++++++++++++++++-----------
 drivers/gpu/drm/msm/adreno/a6xx_gmu.h |    6 ++++++
 2 files changed, 23 insertions(+), 11 deletions(-)

--- a/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
@@ -236,6 +236,8 @@ static int a6xx_gmu_start(struct a6xx_gm
 	if (ret)
 		DRM_DEV_ERROR(gmu->dev, "GMU firmware initialization timed out\n");
 
+	set_bit(GMU_STATUS_FW_START, &gmu->status);
+
 	return ret;
 }
 
@@ -482,6 +484,9 @@ static int a6xx_rpmh_start(struct a6xx_g
 	int ret;
 	u32 val;
 
+	if (!test_and_clear_bit(GMU_STATUS_PDC_SLEEP, &gmu->status))
+		return 0;
+
 	gmu_write(gmu, REG_A6XX_GMU_RSCC_CONTROL_REQ, BIT(1));
 
 	ret = gmu_poll_timeout(gmu, REG_A6XX_GMU_RSCC_CONTROL_ACK, val,
@@ -509,6 +514,9 @@ static void a6xx_rpmh_stop(struct a6xx_g
 	int ret;
 	u32 val;
 
+	if (test_and_clear_bit(GMU_STATUS_FW_START, &gmu->status))
+		return;
+
 	gmu_write(gmu, REG_A6XX_GMU_RSCC_CONTROL_REQ, 1);
 
 	ret = gmu_poll_timeout_rscc(gmu, REG_A6XX_GPU_RSCC_RSC_STATUS0_DRV0,
@@ -517,6 +525,8 @@ static void a6xx_rpmh_stop(struct a6xx_g
 		DRM_DEV_ERROR(gmu->dev, "Unable to power off the GPU RSC\n");
 
 	gmu_write(gmu, REG_A6XX_GMU_RSCC_CONTROL_REQ, 0);
+
+	set_bit(GMU_STATUS_PDC_SLEEP, &gmu->status);
 }
 
 static inline void pdc_write(void __iomem *ptr, u32 offset, u32 value)
@@ -645,8 +655,6 @@ setup_pdc:
 	/* ensure no writes happen before the uCode is fully written */
 	wmb();
 
-	a6xx_rpmh_stop(gmu);
-
 err:
 	if (!IS_ERR_OR_NULL(pdcptr))
 		iounmap(pdcptr);
@@ -799,19 +807,15 @@ static int a6xx_gmu_fw_start(struct a6xx
 	else
 		gmu_write(gmu, REG_A6XX_GMU_GENERAL_7, 1);
 
-	if (state == GMU_WARM_BOOT) {
-		ret = a6xx_rpmh_start(gmu);
-		if (ret)
-			return ret;
-	} else {
+	ret = a6xx_rpmh_start(gmu);
+	if (ret)
+		return ret;
+
+	if (state == GMU_COLD_BOOT) {
 		if (WARN(!adreno_gpu->fw[ADRENO_FW_GMU],
 			"GMU firmware is not loaded\n"))
 			return -ENOENT;
 
-		ret = a6xx_rpmh_start(gmu);
-		if (ret)
-			return ret;
-
 		ret = a6xx_gmu_fw_load(gmu);
 		if (ret)
 			return ret;
@@ -980,6 +984,8 @@ static void a6xx_gmu_force_off(struct a6
 
 	/* Reset GPU core blocks */
 	a6xx_gpu_sw_reset(gpu, true);
+
+	a6xx_rpmh_stop(gmu);
 }
 
 static void a6xx_gmu_set_initial_freq(struct msm_gpu *gpu, struct a6xx_gmu *gmu)
--- a/drivers/gpu/drm/msm/adreno/a6xx_gmu.h
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gmu.h
@@ -99,6 +99,12 @@ struct a6xx_gmu {
 	struct completion pd_gate;
 
 	struct qmp *qmp;
+
+/* To check if we can trigger sleep seq at PDC. Cleared in a6xx_rpmh_stop() */
+#define GMU_STATUS_FW_START	0
+/* To track if PDC sleep seq was done */
+#define GMU_STATUS_PDC_SLEEP	1
+	unsigned long status;
 };
 
 static inline u32 gmu_read(struct a6xx_gmu *gmu, u32 offset)


