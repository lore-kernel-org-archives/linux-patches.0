Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B60E92F12B7;
	Fri, 17 Oct 2025 14:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713091; cv=none; b=lzK48KoHZe+x5sTLiAXlN5/9jRe6v4tD/6KcawgB0neqazx0UO/3fH4ioPqgCUVcSxeetEPmhu2pIrbv5ESQlwXs0uDjAO0Iv3obuDDMGVwZ834f/v2KuHgEF1fK3WVGv22uJqHMMTYpR2TLs4b78JtCZkm9qmTbqEgmS8nZfc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713091; c=relaxed/simple;
	bh=pi/4WtHVO6WIllfEJNNgW2p5S66RgAzVQSqwXsThG+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bN/IEiugX6UUX76zxm3PTOuYtP9jM8F1+k1pG4PHNbYtPOjb/8EWuXR3u8EQ0MRa2v/8VmDX4qkPLDjQTduKFLjIvlgfWWuwJy8jxaE9VK04qb2W7kuh4Sfp/UzLehS5bAXm9iRYwG8FFiUcH37H4TV2CLNeb6uFsb13PxF+b+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zhkgmyjm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zhkgmyjm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD352C4CEF9;
	Fri, 17 Oct 2025 14:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713091;
	bh=pi/4WtHVO6WIllfEJNNgW2p5S66RgAzVQSqwXsThG+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZhkgmyjmrkfeEqlQR3BCSuOGk89VIjmRuP0NxvEl7GB+YXCAmuF9jietsSr3ogDNT
	 8Cyyw11auylAgZZd0N7W78UoDILNyKM8y820B+ef7OxC4X0yB733oMnwUTNsQxbjYW
	 j5OkTHa1M1zPgz9tYWkpB343CUKqrMQz4D79rywA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 044/168] drm/amd/display: Properly disable scaling on DCE6
Date: Fri, 17 Oct 2025 16:52:03 +0200
Message-ID: <20251017145130.641321576@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145129.000176255@linuxfoundation.org>
References: <20251017145129.000176255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Kristóf <timur.kristof@gmail.com>

[ Upstream commit a7dc87f3448bea5ebe054f14e861074b9c289c65 ]

SCL_SCALER_ENABLE can be used to enable/disable the scaler
on DCE6. Program it to 0 when scaling isn't used, 1 when used.
Additionally, clear some other registers when scaling is
disabled and program the SCL_UPDATE register as recommended.

This fixes visible glitches for users whose BIOS sets up a
mode with scaling at boot, which DC was unable to clean up.

Fixes: b70aaf5586f2 ("drm/amd/display: dce_transform: add DCE6 specific macros,functions")
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Timur Kristóf <timur.kristof@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/dc/dce/dce_transform.c    | 15 +++++++++++----
 .../gpu/drm/amd/display/dc/dce/dce_transform.h    |  2 ++
 2 files changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dce/dce_transform.c b/drivers/gpu/drm/amd/display/dc/dce/dce_transform.c
index b761dda491d54..f97c182677082 100644
--- a/drivers/gpu/drm/amd/display/dc/dce/dce_transform.c
+++ b/drivers/gpu/drm/amd/display/dc/dce/dce_transform.c
@@ -154,10 +154,13 @@ static bool dce60_setup_scaling_configuration(
 	REG_SET(SCL_BYPASS_CONTROL, 0, SCL_BYPASS_MODE, 0);
 
 	if (data->taps.h_taps + data->taps.v_taps <= 2) {
-		/* Set bypass */
-
-		/* DCE6 has no SCL_MODE register, skip scale mode programming */
+		/* Disable scaler functionality */
+		REG_WRITE(SCL_SCALER_ENABLE, 0);
 
+		/* Clear registers that can cause glitches even when the scaler is off */
+		REG_WRITE(SCL_TAP_CONTROL, 0);
+		REG_WRITE(SCL_AUTOMATIC_MODE_CONTROL, 0);
+		REG_WRITE(SCL_F_SHARP_CONTROL, 0);
 		return false;
 	}
 
@@ -165,7 +168,7 @@ static bool dce60_setup_scaling_configuration(
 			SCL_H_NUM_OF_TAPS, data->taps.h_taps - 1,
 			SCL_V_NUM_OF_TAPS, data->taps.v_taps - 1);
 
-	/* DCE6 has no SCL_MODE register, skip scale mode programming */
+	REG_WRITE(SCL_SCALER_ENABLE, 1);
 
 	/* DCE6 has no SCL_BOUNDARY_MODE bit, skip replace out of bound pixels */
 
@@ -502,6 +505,8 @@ static void dce60_transform_set_scaler(
 	REG_SET(DC_LB_MEM_SIZE, 0,
 		DC_LB_MEM_SIZE, xfm_dce->lb_memory_size);
 
+	REG_WRITE(SCL_UPDATE, 0x00010000);
+
 	/* Clear SCL_F_SHARP_CONTROL value to 0 */
 	REG_WRITE(SCL_F_SHARP_CONTROL, 0);
 
@@ -564,6 +569,8 @@ static void dce60_transform_set_scaler(
 	/* DCE6 has no SCL_COEF_UPDATE_COMPLETE bit to flip to new coefficient memory */
 
 	/* DCE6 DATA_FORMAT register does not support ALPHA_EN */
+
+	REG_WRITE(SCL_UPDATE, 0);
 }
 #endif
 
diff --git a/drivers/gpu/drm/amd/display/dc/dce/dce_transform.h b/drivers/gpu/drm/amd/display/dc/dce/dce_transform.h
index ff746fba850bc..eb716e8337e23 100644
--- a/drivers/gpu/drm/amd/display/dc/dce/dce_transform.h
+++ b/drivers/gpu/drm/amd/display/dc/dce/dce_transform.h
@@ -155,6 +155,7 @@
 	SRI(SCL_COEF_RAM_TAP_DATA, SCL, id), \
 	SRI(VIEWPORT_START, SCL, id), \
 	SRI(VIEWPORT_SIZE, SCL, id), \
+	SRI(SCL_SCALER_ENABLE, SCL, id), \
 	SRI(SCL_HORZ_FILTER_INIT_RGB_LUMA, SCL, id), \
 	SRI(SCL_HORZ_FILTER_INIT_CHROMA, SCL, id), \
 	SRI(SCL_HORZ_FILTER_SCALE_RATIO, SCL, id), \
@@ -592,6 +593,7 @@ struct dce_transform_registers {
 	uint32_t SCL_VERT_FILTER_SCALE_RATIO;
 	uint32_t SCL_HORZ_FILTER_INIT;
 #if defined(CONFIG_DRM_AMD_DC_SI)
+	uint32_t SCL_SCALER_ENABLE;
 	uint32_t SCL_HORZ_FILTER_INIT_RGB_LUMA;
 	uint32_t SCL_HORZ_FILTER_INIT_CHROMA;
 #endif
-- 
2.51.0



