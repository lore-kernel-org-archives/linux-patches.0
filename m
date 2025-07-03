Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA2BA22069F;
	Thu,  3 Jul 2025 15:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555360; cv=none; b=V3HE0jSjpWqEiOO6V0UBfKRxtyn7X+KmV6xE2GDzxCganJcWIKMIeAGGdM8tFL3q9b2rEmxu/vpQ5uTCLi/uASMuvglPZ2Eukpt+wzcA1ri6215iTAZYswywJE3sKpQxoxsMGIYMOv3D0l10JJJqtqxS74xOXYpOVen+AxZ4pLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555360; c=relaxed/simple;
	bh=0fqBu1PBjNDxLo/WKH/kPy5FBsz19THuvrYyd5sSCYc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JF9s8xwBpyX/NxLZi/aJY+5p+bhb2J0txMSBfotMaqdPrHq26XccZ+SHiIccOuDkBZNLiZRibtWffzWjfIObjo7aKUzCPnCHurrSELSt+DMBn6jj2kfkuA3fdWKSDT7MKffrZg/lI6PuKQ61FZYdvx+cSxTCzFtknHULbWF7BRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=exuXLv8+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="exuXLv8+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E86FEC4CEE3;
	Thu,  3 Jul 2025 15:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555360;
	bh=0fqBu1PBjNDxLo/WKH/kPy5FBsz19THuvrYyd5sSCYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=exuXLv8+iHDeiCWAdo1N7QZrywn5UCcVODt5g8o6le9pqLZo0YnGF52gZnach8E8s
	 URckOO0djqJfq0unTDpsoS+i7eQI5CMWSIJwlE99mB8XyY/CDmibCFOrffeLCtCj/d
	 yXcaRy777ytL5P3Ykck9Y3e6AH8N/P1Ga1KHgVd8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Roman Li <roman.li@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>
Subject: [PATCH 6.15 253/263] drm/amd/display: Export full brightness range to userspace
Date: Thu,  3 Jul 2025 16:42:53 +0200
Message-ID: <20250703144014.556357863@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mario Limonciello <mario.limonciello@amd.com>

[WHY]
Userspace currently is offered a range from 0-0xFF but the PWM is
programmed from 0-0xFFFF.  This can be limiting to some software
that wants to apply greater granularity.

[HOW]
Convert internally to firmware values only when mapping custom
brightness curves because these are in 0-0xFF range. Advertise full
PWM range to userspace.

Cc: Mario Limonciello <mario.limonciello@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Roman Li <roman.li@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Hung <alex.hung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 8dbd72cb790058ce52279af38a43c2b302fdd3e5)
Cc: stable@vger.kernel.org
---
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 41 ++++++++++++-------
 1 file changed, 27 insertions(+), 14 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index a9a719f051f90..c5c2f82448f21 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -4655,9 +4655,23 @@ static int get_brightness_range(const struct amdgpu_dm_backlight_caps *caps,
 	return 1;
 }
 
+/* Rescale from [min..max] to [0..AMDGPU_MAX_BL_LEVEL] */
+static inline u32 scale_input_to_fw(int min, int max, u64 input)
+{
+	return DIV_ROUND_CLOSEST_ULL(input * AMDGPU_MAX_BL_LEVEL, max - min);
+}
+
+/* Rescale from [0..AMDGPU_MAX_BL_LEVEL] to [min..max] */
+static inline u32 scale_fw_to_input(int min, int max, u64 input)
+{
+	return min + DIV_ROUND_CLOSEST_ULL(input * (max - min), AMDGPU_MAX_BL_LEVEL);
+}
+
 static void convert_custom_brightness(const struct amdgpu_dm_backlight_caps *caps,
-				      uint32_t *brightness)
+				      unsigned int min, unsigned int max,
+				      uint32_t *user_brightness)
 {
+	u32 brightness = scale_input_to_fw(min, max, *user_brightness);
 	u8 prev_signal = 0, prev_lum = 0;
 	int i = 0;
 
@@ -4668,7 +4682,7 @@ static void convert_custom_brightness(const struct amdgpu_dm_backlight_caps *cap
 		return;
 
 	/* choose start to run less interpolation steps */
-	if (caps->luminance_data[caps->data_points/2].input_signal > *brightness)
+	if (caps->luminance_data[caps->data_points/2].input_signal > brightness)
 		i = caps->data_points/2;
 	do {
 		u8 signal = caps->luminance_data[i].input_signal;
@@ -4679,17 +4693,18 @@ static void convert_custom_brightness(const struct amdgpu_dm_backlight_caps *cap
 		 * brightness < signal: interpolate between previous and current luminance numerator
 		 * brightness > signal: find next data point
 		 */
-		if (*brightness > signal) {
+		if (brightness > signal) {
 			prev_signal = signal;
 			prev_lum = lum;
 			i++;
 			continue;
 		}
-		if (*brightness < signal)
+		if (brightness < signal)
 			lum = prev_lum + DIV_ROUND_CLOSEST((lum - prev_lum) *
-							   (*brightness - prev_signal),
+							   (brightness - prev_signal),
 							   signal - prev_signal);
-		*brightness = DIV_ROUND_CLOSEST(lum * *brightness, 101);
+		*user_brightness = scale_fw_to_input(min, max,
+						     DIV_ROUND_CLOSEST(lum * brightness, 101));
 		return;
 	} while (i < caps->data_points);
 }
@@ -4702,11 +4717,10 @@ static u32 convert_brightness_from_user(const struct amdgpu_dm_backlight_caps *c
 	if (!get_brightness_range(caps, &min, &max))
 		return brightness;
 
-	convert_custom_brightness(caps, &brightness);
+	convert_custom_brightness(caps, min, max, &brightness);
 
-	// Rescale 0..255 to min..max
-	return min + DIV_ROUND_CLOSEST((max - min) * brightness,
-				       AMDGPU_MAX_BL_LEVEL);
+	// Rescale 0..max to min..max
+	return min + DIV_ROUND_CLOSEST_ULL((u64)(max - min) * brightness, max);
 }
 
 static u32 convert_brightness_to_user(const struct amdgpu_dm_backlight_caps *caps,
@@ -4719,8 +4733,8 @@ static u32 convert_brightness_to_user(const struct amdgpu_dm_backlight_caps *cap
 
 	if (brightness < min)
 		return 0;
-	// Rescale min..max to 0..255
-	return DIV_ROUND_CLOSEST(AMDGPU_MAX_BL_LEVEL * (brightness - min),
+	// Rescale min..max to 0..max
+	return DIV_ROUND_CLOSEST_ULL((u64)max * (brightness - min),
 				 max - min);
 }
 
@@ -4870,11 +4884,10 @@ amdgpu_dm_register_backlight_device(struct amdgpu_dm_connector *aconnector)
 		drm_dbg(drm, "Backlight caps: min: %d, max: %d, ac %d, dc %d\n", min, max,
 			caps->ac_level, caps->dc_level);
 	} else
-		props.brightness = AMDGPU_MAX_BL_LEVEL;
+		props.brightness = props.max_brightness = AMDGPU_MAX_BL_LEVEL;
 
 	if (caps->data_points && !(amdgpu_dc_debug_mask & DC_DISABLE_CUSTOM_BRIGHTNESS_CURVE))
 		drm_info(drm, "Using custom brightness curve\n");
-	props.max_brightness = AMDGPU_MAX_BL_LEVEL;
 	props.type = BACKLIGHT_RAW;
 
 	snprintf(bl_name, sizeof(bl_name), "amdgpu_bl%d",
-- 
2.39.5



