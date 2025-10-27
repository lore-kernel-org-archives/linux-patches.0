Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32AAB32A3C3;
	Mon, 27 Oct 2025 18:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591338; cv=none; b=gz7IFkFnHqONxr87RoJzrETSjN9Pe1e9UeeB2y5No1S3sovPl9hwpUWbr3TZS3U7S8YmcgiWfYFTT/gkZ+e0qQ6EjC/4ej1hGrnzBsOH9A3sjQodps6lsjVYuNyWngPY2o1kMDcywbmI9P79d8iqvPR00r4Kq5+Hmi3qC/sOVnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591338; c=relaxed/simple;
	bh=JxSoFwzuH+5u58wbXW2kvTZ3R9gLk54vR/GcHtVF/+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=knym9R7XIMxA6F0bW8PZbcm/fyoek8kScWmqNzh/TQhEzBFEPm3b//Gh+ddpvjqz5/zdGwW9KUtVzyIMpf7lz7f0pCshbOw6oRFtFtMUy6Akb1ODilHBAiTX0trMeLTXKawLbcb24fPKULQ5XecPgdxfnjMwPmZo8ZIcD6T5VgI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fW5izr+y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fW5izr+y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7A4DC4CEF1;
	Mon, 27 Oct 2025 18:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591338;
	bh=JxSoFwzuH+5u58wbXW2kvTZ3R9gLk54vR/GcHtVF/+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fW5izr+yVUfnr/UC4iSZzrs747dAeW6H92X6VKh0xi/jaJWzC+v/LV/2dAq+rUmZi
	 AHNS2xrrOUZjy+QudB5F4O27xtmxlU4hefQVONG97ljuuJaavrFoXR5GPgMC9Kyttf
	 4e+DBY5kesHSe1N/UNGlJjP0RTiv0NkrIei4/q3w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Timur=20Krist=C3=B3f?= <timur.kristof@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 122/332] drm/amd/display: Properly disable scaling on DCE6
Date: Mon, 27 Oct 2025 19:32:55 +0100
Message-ID: <20251027183527.832321860@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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
index a3f4fa346b77e..19859c44f9d51 100644
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
 
@@ -503,6 +506,8 @@ static void dce60_transform_set_scaler(
 	REG_SET(DC_LB_MEM_SIZE, 0,
 		DC_LB_MEM_SIZE, xfm_dce->lb_memory_size);
 
+	REG_WRITE(SCL_UPDATE, 0x00010000);
+
 	/* Clear SCL_F_SHARP_CONTROL value to 0 */
 	REG_WRITE(SCL_F_SHARP_CONTROL, 0);
 
@@ -566,6 +571,8 @@ static void dce60_transform_set_scaler(
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



