Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C1442989B4;
	Wed, 23 Apr 2025 15:33:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422433; cv=none; b=mLGl5iSzCog9iSc/8u4lWT7jlYh5IegsQfYuaj4PYb9a6OERlbj2L7yw/zrXKNbYgMSu/s4G32DJZ+B8UNJD7j0fUN4m7PPFHBojXdXDY3Z/a71UbOofL9djArFXeg8JALyzw0lTLdvuBEzL5pN7PTuZTL4ASPgPjqfPmf9Hsa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422433; c=relaxed/simple;
	bh=Qyqvlhj3EUDXRc1v2X1gXfyRP8ZFbB7s3opwGEFulSM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NpKAs2srbsu6oQmuL4nHBIvdY2FX2rpkI3x50NSbTaC5ma1d1SYpnkd/lAMKfxq74Ov7gZZXQQcsxYu0DtvF/dREJFUYGyuKOwJda9oaq/ZS1l4fh3/QEPBy+IL24ZP9iGtaNqBgquNvboKRC8A8hknGrHava5cGg7Zoirs1cYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C7VReZHu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C7VReZHu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1D47C4CEF7;
	Wed, 23 Apr 2025 15:33:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422433;
	bh=Qyqvlhj3EUDXRc1v2X1gXfyRP8ZFbB7s3opwGEFulSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C7VReZHuIzfCymyZEdmONAhuA4AoAgUGRzFJU7yfybEb/V+eZ8aM2H6SP8W5XoYtx
	 dnhTGKDlYYWcEwqpNTyfgI9eWMZJFdo9e6w8I19TcgxOKc/Ppc1AK+kRDUhbi7LRfc
	 hF7uuzqu0tfMdTQ+l6tQKFByna+kMgvkefOwyCw4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akhil P Oommen <quic_akhilpo@quicinc.com>,
	Rob Clark <robdclark@chromium.org>
Subject: [PATCH 6.6 347/393] drm/msm/a6xx: Fix stale rpmh votes from GPU
Date: Wed, 23 Apr 2025 16:44:03 +0200
Message-ID: <20250423142657.670873942@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Akhil P Oommen <quic_akhilpo@quicinc.com>

commit f561db72a663f8a73c2250bf3244ce1ce221bed7 upstream.

It was observed on sc7180 (A618 gpu) that GPU votes for GX rail and CNOC
BCM nodes were not removed after GPU suspend. This was because we
skipped sending 'prepare-slumber' request to gmu during suspend sequence
in some cases. So, make sure we always call prepare-slumber hfi during
suspend. Also, calling prepare-slumber without a prior oob-gpu handshake
messes up gmu firmware's internal state. So, do that when required.

Fixes: 4b565ca5a2cb ("drm/msm: Add A6XX device support")
Cc: stable@vger.kernel.org
Signed-off-by: Akhil P Oommen <quic_akhilpo@quicinc.com>
Patchwork: https://patchwork.freedesktop.org/patch/639569/
Signed-off-by: Rob Clark <robdclark@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/msm/adreno/a6xx_gmu.c |   82 ++++++++++++++++++----------------
 1 file changed, 44 insertions(+), 38 deletions(-)

--- a/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
+++ b/drivers/gpu/drm/msm/adreno/a6xx_gmu.c
@@ -1042,50 +1042,51 @@ static void a6xx_gmu_shutdown(struct a6x
 	struct a6xx_gpu *a6xx_gpu = container_of(gmu, struct a6xx_gpu, gmu);
 	struct adreno_gpu *adreno_gpu = &a6xx_gpu->base;
 	u32 val;
+	int ret;
 
 	/*
-	 * The GMU may still be in slumber unless the GPU started so check and
-	 * skip putting it back into slumber if so
+	 * GMU firmware's internal power state gets messed up if we send "prepare_slumber" hfi when
+	 * oob_gpu handshake wasn't done after the last wake up. So do a dummy handshake here when
+	 * required
 	 */
-	val = gmu_read(gmu, REG_A6XX_GPU_GMU_CX_GMU_RPMH_POWER_STATE);
+	if (adreno_gpu->base.needs_hw_init) {
+		if (a6xx_gmu_set_oob(&a6xx_gpu->gmu, GMU_OOB_GPU_SET))
+			goto force_off;
 
-	if (val != 0xf) {
-		int ret = a6xx_gmu_wait_for_idle(gmu);
-
-		/* If the GMU isn't responding assume it is hung */
-		if (ret) {
-			a6xx_gmu_force_off(gmu);
-			return;
-		}
-
-		a6xx_bus_clear_pending_transactions(adreno_gpu, a6xx_gpu->hung);
-
-		/* tell the GMU we want to slumber */
-		ret = a6xx_gmu_notify_slumber(gmu);
-		if (ret) {
-			a6xx_gmu_force_off(gmu);
-			return;
-		}
-
-		ret = gmu_poll_timeout(gmu,
-			REG_A6XX_GPU_GMU_AO_GPU_CX_BUSY_STATUS, val,
-			!(val & A6XX_GPU_GMU_AO_GPU_CX_BUSY_STATUS_GPUBUSYIGNAHB),
-			100, 10000);
-
-		/*
-		 * Let the user know we failed to slumber but don't worry too
-		 * much because we are powering down anyway
-		 */
-
-		if (ret)
-			DRM_DEV_ERROR(gmu->dev,
-				"Unable to slumber GMU: status = 0%x/0%x\n",
-				gmu_read(gmu,
-					REG_A6XX_GPU_GMU_AO_GPU_CX_BUSY_STATUS),
-				gmu_read(gmu,
-					REG_A6XX_GPU_GMU_AO_GPU_CX_BUSY_STATUS2));
+		a6xx_gmu_clear_oob(&a6xx_gpu->gmu, GMU_OOB_GPU_SET);
 	}
 
+	ret = a6xx_gmu_wait_for_idle(gmu);
+
+	/* If the GMU isn't responding assume it is hung */
+	if (ret)
+		goto force_off;
+
+	a6xx_bus_clear_pending_transactions(adreno_gpu, a6xx_gpu->hung);
+
+	/* tell the GMU we want to slumber */
+	ret = a6xx_gmu_notify_slumber(gmu);
+	if (ret)
+		goto force_off;
+
+	ret = gmu_poll_timeout(gmu,
+		REG_A6XX_GPU_GMU_AO_GPU_CX_BUSY_STATUS, val,
+		!(val & A6XX_GPU_GMU_AO_GPU_CX_BUSY_STATUS_GPUBUSYIGNAHB),
+		100, 10000);
+
+	/*
+	 * Let the user know we failed to slumber but don't worry too
+	 * much because we are powering down anyway
+	 */
+
+	if (ret)
+		DRM_DEV_ERROR(gmu->dev,
+			"Unable to slumber GMU: status = 0%x/0%x\n",
+			gmu_read(gmu,
+				REG_A6XX_GPU_GMU_AO_GPU_CX_BUSY_STATUS),
+			gmu_read(gmu,
+				REG_A6XX_GPU_GMU_AO_GPU_CX_BUSY_STATUS2));
+
 	/* Turn off HFI */
 	a6xx_hfi_stop(gmu);
 
@@ -1094,6 +1095,11 @@ static void a6xx_gmu_shutdown(struct a6x
 
 	/* Tell RPMh to power off the GPU */
 	a6xx_rpmh_stop(gmu);
+
+	return;
+
+force_off:
+	a6xx_gmu_force_off(gmu);
 }
 
 


