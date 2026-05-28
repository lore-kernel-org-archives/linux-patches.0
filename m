Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B184DDC5;
	Thu, 28 May 2026 20:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000133; cv=none; b=LnKOipJuF3EK35BjIV/UrE2m9/X/+BTVznH7Ej8doaf85W67bK4ZplP5EP/q8YJqeCSx6wHaaZUCqcrO+3vW9gz7+96NhL2dHZJtIexxPALxLX3/0blgKD9Z/j1Gizt6mSCMHGjdSPRwkRCpuQlXzQwXLd80fU18KeAzFLaaN/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000133; c=relaxed/simple;
	bh=MqxQ6LSGpmvDMfMvUh8jNembAMIhfBV3+X8qj2+wh2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ro9xhY5qUJN8SbU/Moym4Lr/Xnr6huHoR1y/Q8rttmU6KkaAJJ1Kfof/pTw0Gmu8s1MQqirribEmJ0ZZn3vdbVrN11QU5DDdmLdD49YAa3v8L4ZSUcTbX5yO3yBjgbG6tK2IhS1f68uwVtOzNBbvak6xYaxfnOI10eUyeUZqyds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UY3dxjCu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UY3dxjCu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06DAD1F00A3A;
	Thu, 28 May 2026 20:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000132;
	bh=X23AgQYENaJD5I6xsX1rYMhczbIcMJx+aM148GkW/MY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UY3dxjCud68DtAD9PwJvoG2IcK3gkb7+K6Ev+wQpblMCsW1RQz3v1fLo0HWKO6n7t
	 IdENuT9HGsU7yF0MtSP9uAnFpdfIHU769cXj4ra17D8/ZXZt8/XOIDuuK5LggX/1Vj
	 oRMOjKQ2LEbBp7EN02UVs1hJYv/TpVdTrmF/0IbI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Rob Clark <rob.clark@oss.qualcomm.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 277/377] drm/msm/adreno: fix userspace-triggered crash on a2xx-a4xx
Date: Thu, 28 May 2026 21:48:35 +0200
Message-ID: <20260528194646.378652378@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

[ Upstream commit 2b4abf879360ea00a9e2b46d2d15dcdbc0687eed ]

Before a5xx Adreno driver will not try fetching UBWC params (because
those generations didn't support UBWC anyway), however it's still
possible to query UBWC-related params from the userspace, triggering
possible NULL pointer dereference. Check for UBWC config in
adreno_get_param() and return sane defaults if there is none.

Fixes: a452510aad53 ("drm/msm/adreno: Switch to the common UBWC config struct")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Rob Clark <rob.clark@oss.qualcomm.com>
Patchwork: https://patchwork.freedesktop.org/patch/717778/
Message-ID: <20260411-adreno-fix-ubwc-v3-1-4983156f3f80@oss.qualcomm.com>
Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/adreno/adreno_gpu.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/msm/adreno/adreno_gpu.c b/drivers/gpu/drm/msm/adreno/adreno_gpu.c
index 4b5a4edd07028..056a9e18cd4ac 100644
--- a/drivers/gpu/drm/msm/adreno/adreno_gpu.c
+++ b/drivers/gpu/drm/msm/adreno/adreno_gpu.c
@@ -419,15 +419,21 @@ int adreno_get_param(struct msm_gpu *gpu, struct msm_context *ctx,
 		*value = vm->mm_range;
 		return 0;
 	case MSM_PARAM_HIGHEST_BANK_BIT:
+		if (!adreno_gpu->ubwc_config)
+			return UERR(ENOENT, drm, "no UBWC on this platform");
 		*value = adreno_gpu->ubwc_config->highest_bank_bit;
 		return 0;
 	case MSM_PARAM_RAYTRACING:
 		*value = adreno_gpu->has_ray_tracing;
 		return 0;
 	case MSM_PARAM_UBWC_SWIZZLE:
+		if (!adreno_gpu->ubwc_config)
+			return UERR(ENOENT, drm, "no UBWC on this platform");
 		*value = adreno_gpu->ubwc_config->ubwc_swizzle;
 		return 0;
 	case MSM_PARAM_MACROTILE_MODE:
+		if (!adreno_gpu->ubwc_config)
+			return UERR(ENOENT, drm, "no UBWC on this platform");
 		*value = adreno_gpu->ubwc_config->macrotile_mode;
 		return 0;
 	case MSM_PARAM_UCHE_TRAP_BASE:
-- 
2.53.0



