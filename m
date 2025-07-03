Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CB1815442C;
	Thu,  3 Jul 2025 15:09:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555357; cv=none; b=cfl1yx8ncGou9DFwZmG9cDBpL4P51P4dDqHBXKGYCA3FI2LuiY/wBY9Lg6C7wzbSM+EoCR3utWGGcXi6bAMU7Bv8UMD7glMNP3NF0b3jnm9AyhUMObiYbXdEGuDhA7ARF+qhebKVgGmqQfK3GrIFqJSYI0JSoGQDhwTxRPuRXNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555357; c=relaxed/simple;
	bh=4uX/E8LWRCHXb8Tac4IU3R9eE9OG6WDkGaYOQJZtgjE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fCE7Tgx0DAQb5/4+ry7s7QdNKKxxmwDztY99jfntrvNFsI453nuumv1AWHN+B5cyfmn/KmGQugotZXdyZ903HSSX64QD3gWa7lSBijw0WNUDK9bZT7+vlGcbw9xiGfpmDdQQfEHjxSfOFUlQ4NgxuRCfgpD8xAnmQBx+S79gi/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zogt4OMz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zogt4OMz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7839C4CEEE;
	Thu,  3 Jul 2025 15:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555357;
	bh=4uX/E8LWRCHXb8Tac4IU3R9eE9OG6WDkGaYOQJZtgjE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zogt4OMzvjyqknF42H3kcrwzh0SxZsY2/012M0D6tdHAFNRDBQSQdAVAjTOrCcfp4
	 1HIIyYmpZ6wt/dikWrr5dlqidMX9uvHgITjiggTMgR/Uurpc8tfKFmASX/6IltJeuk
	 unwNm1jb/dpg+rfaWFw9/4sdIzbunbIJVrctkrLY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Hung <alex.hung@amd.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Roman Li <roman.li@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.15 252/263] drm/amd/display: Optimize custom brightness curve
Date: Thu,  3 Jul 2025 16:42:52 +0200
Message-ID: <20250703144014.514978742@linuxfoundation.org>
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

[Why]
When BIOS includes a lot of custom brightness data points, walking
the entire list can be time consuming.  This is most noticed when
dragging a power slider.  The "higher" values are "slower" to drag
around.

[How]
Move custom brightness calculation loop into a static function. Before
starting the loop check the "half way" data point to see how it compares
to the input.  If greater than the half way data point use that as the
starting point instead.

Reviewed-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Roman Li <roman.li@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
---
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 53 ++++++++++++-------
 1 file changed, 33 insertions(+), 20 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index e61166a8230b6..a9a719f051f90 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -4655,41 +4655,54 @@ static int get_brightness_range(const struct amdgpu_dm_backlight_caps *caps,
 	return 1;
 }
 
-static u32 convert_brightness_from_user(const struct amdgpu_dm_backlight_caps *caps,
-					uint32_t brightness)
+static void convert_custom_brightness(const struct amdgpu_dm_backlight_caps *caps,
+				      uint32_t *brightness)
 {
-	unsigned int min, max;
 	u8 prev_signal = 0, prev_lum = 0;
+	int i = 0;
 
-	if (!get_brightness_range(caps, &min, &max))
-		return brightness;
-
-	for (int i = 0; i < caps->data_points; i++) {
-		u8 signal, lum;
+	if (amdgpu_dc_debug_mask & DC_DISABLE_CUSTOM_BRIGHTNESS_CURVE)
+		return;
 
-		if (amdgpu_dc_debug_mask & DC_DISABLE_CUSTOM_BRIGHTNESS_CURVE)
-			break;
+	if (!caps->data_points)
+		return;
 
-		signal = caps->luminance_data[i].input_signal;
-		lum = caps->luminance_data[i].luminance;
+	/* choose start to run less interpolation steps */
+	if (caps->luminance_data[caps->data_points/2].input_signal > *brightness)
+		i = caps->data_points/2;
+	do {
+		u8 signal = caps->luminance_data[i].input_signal;
+		u8 lum = caps->luminance_data[i].luminance;
 
 		/*
 		 * brightness == signal: luminance is percent numerator
 		 * brightness < signal: interpolate between previous and current luminance numerator
 		 * brightness > signal: find next data point
 		 */
-		if (brightness < signal)
-			lum = prev_lum + DIV_ROUND_CLOSEST((lum - prev_lum) *
-							   (brightness - prev_signal),
-							   signal - prev_signal);
-		else if (brightness > signal) {
+		if (*brightness > signal) {
 			prev_signal = signal;
 			prev_lum = lum;
+			i++;
 			continue;
 		}
-		brightness = DIV_ROUND_CLOSEST(lum * brightness, 101);
-		break;
-	}
+		if (*brightness < signal)
+			lum = prev_lum + DIV_ROUND_CLOSEST((lum - prev_lum) *
+							   (*brightness - prev_signal),
+							   signal - prev_signal);
+		*brightness = DIV_ROUND_CLOSEST(lum * *brightness, 101);
+		return;
+	} while (i < caps->data_points);
+}
+
+static u32 convert_brightness_from_user(const struct amdgpu_dm_backlight_caps *caps,
+					uint32_t brightness)
+{
+	unsigned int min, max;
+
+	if (!get_brightness_range(caps, &min, &max))
+		return brightness;
+
+	convert_custom_brightness(caps, &brightness);
 
 	// Rescale 0..255 to min..max
 	return min + DIV_ROUND_CLOSEST((max - min) * brightness,
-- 
2.39.5



