Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 415993E95A8;
	Thu, 30 Jul 2026 15:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424408; cv=none; b=Q7M7A5fAiJCft5QxlSeIyyg2UvYiO8p5HOR3X3yG8dKAi1X9lz9oCI7Lj1uXLWrSN0bEVzW0LjGRADCnlfIkENURLXwUhacbJNM10JfRoEb45Rt7kwQzXo1IJb+ISEfXfNVc6bHnythV8PIcoMa3u6ut34KwT5yV3eAg6/c7VKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424408; c=relaxed/simple;
	bh=7+lx4IhQVYwby9jOnnw07Edci1dUiggyFBAHNEuN9U8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aPA7dg4N4yOZ3gTq/mAyTGG6rWsc9nC1T6bvtNXf3Vn9UMjnUrDhtdpR7BysR7ocg7wpJByT+rhxGgdww46P8/SxEY4sYyHn9YqUO6YRFJv84WSHsE5KBml1b9LovGOfzEbjJXnwuZKIuGGuJFtbU+Hix9utjFJtqxy29xLn8r8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V8jY9bCB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V8jY9bCB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BCD31F000E9;
	Thu, 30 Jul 2026 15:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424407;
	bh=jVF7IS92EY0u+C6HFHHpMFrAMZxVZGcHmQ6exXqwZPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V8jY9bCBuVxlh0HT6gSJrYUTFD3Fp6P62HD+tWOIhmmDG+6wfWrgnq8J5XHzAHkFQ
	 u6lSlGGOEjj+r911t+vTHiZFRifimQbTcROxqQHe6w1IzqDv4iry2FBoP4tfWlCMdj
	 i/pGwbWrgnoT9A1noQW0Tm/61h8SFlZ3ossYwSAk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alessandro Rinaldi <ale@alerinaldi.it>,
	George Zhang <george.zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 383/675] drm/amd/display: Force PWM backlight on Lenovo Legion 5 15ARH05
Date: Thu, 30 Jul 2026 16:11:53 +0200
Message-ID: <20260730141453.274979128@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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

From: Alessandro Rinaldi <ale@alerinaldi.it>

commit bad177fa75e607e396cd57daaaed881450d7a471 upstream.

The Lenovo Legion 5 15ARH05 (Renoir) ships a BOE 0x08DF eDP panel that
advertises AUX/DPCD backlight control, so amdgpu's automatic detection
(amdgpu_backlight == -1) selects AUX. On this panel the AUX backlight
path has no effect: brightness writes are accepted but the panel level
never changes, the display is stuck at a fixed brightness and
max_brightness is reported as a bogus 511000. As a result neither the
desktop brightness slider nor the brightness hotkeys do anything.

Forcing PWM backlight (amdgpu.backlight=0) restores working control:
max_brightness becomes 65535 and the level tracks writes. This has long
been applied by users as a manual kernel-parameter workaround.

Extend the generic panel backlight quirk with a force_pwm flag, add an
entry for the Legion 5 15ARH05 / BOE 0x08DF panel, and have amdgpu
disable AUX backlight (use PWM) when the quirk matches and the user
lets the driver auto-select the backlight type.

Signed-off-by: Alessandro Rinaldi <ale@alerinaldi.it>
Tested-by: Alessandro Rinaldi <ale@alerinaldi.it>
Reviewed-by: George Zhang <george.zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 81b39f43e7e53589491e2eef6bad5389626b4b9c)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    7 +++++--
 drivers/gpu/drm/drm_panel_backlight_quirks.c      |    9 +++++++++
 include/drm/drm_utils.h                           |    1 +
 3 files changed, 15 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -3724,6 +3724,8 @@ static void update_connector_ext_caps(st
 	caps->ext_caps = &aconnector->dc_link->dpcd_sink_ext_caps;
 	caps->aux_support = false;
 
+	panel_backlight_quirk = drm_get_panel_backlight_quirk(aconnector->drm_edid);
+
 	if (caps->ext_caps->bits.oled == 1
 	    /*
 	     * ||
@@ -3736,6 +3738,9 @@ static void update_connector_ext_caps(st
 		caps->aux_support = false;
 	else if (amdgpu_backlight == 1)
 		caps->aux_support = true;
+	else if (!IS_ERR_OR_NULL(panel_backlight_quirk) &&
+		 panel_backlight_quirk->force_pwm)
+		caps->aux_support = false;
 	if (caps->aux_support)
 		aconnector->dc_link->backlight_control_type = BACKLIGHT_CONTROL_AMD_AUX;
 
@@ -3751,8 +3756,6 @@ static void update_connector_ext_caps(st
 	else
 		caps->aux_min_input_signal = 1;
 
-	panel_backlight_quirk =
-		drm_get_panel_backlight_quirk(aconnector->drm_edid);
 	if (!IS_ERR_OR_NULL(panel_backlight_quirk)) {
 		if (panel_backlight_quirk->min_brightness) {
 			caps->min_input_signal =
--- a/drivers/gpu/drm/drm_panel_backlight_quirks.c
+++ b/drivers/gpu/drm/drm_panel_backlight_quirks.c
@@ -21,6 +21,15 @@ struct drm_get_panel_backlight_quirk {
 };
 
 static const struct drm_get_panel_backlight_quirk drm_panel_min_backlight_quirks[] = {
+	/* Lenovo Legion 5 15ARH05, AUX backlight non-functional, force PWM */
+	{
+		.dmi_match.field = DMI_SYS_VENDOR,
+		.dmi_match.value = "LENOVO",
+		.dmi_match_other.field = DMI_PRODUCT_VERSION,
+		.dmi_match_other.value = "Lenovo Legion 5 15ARH05",
+		.ident.panel_id = drm_edid_encode_panel_id('B', 'O', 'E', 0x08df),
+		.quirk = { .force_pwm = true, },
+	},
 	/* 13 inch matte panel */
 	{
 		.dmi_match.field = DMI_BOARD_VENDOR,
--- a/include/drm/drm_utils.h
+++ b/include/drm/drm_utils.h
@@ -19,6 +19,7 @@ int drm_get_panel_orientation_quirk(int
 struct drm_panel_backlight_quirk {
 	u16 min_brightness;
 	u32 brightness_mask;
+	bool force_pwm;
 };
 
 const struct drm_panel_backlight_quirk *


