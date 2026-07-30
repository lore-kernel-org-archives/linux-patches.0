Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79B10432E98;
	Thu, 30 Jul 2026 14:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422650; cv=none; b=iLimk+sU2hyuz2aqARIlNjSTMOkf0Ywv0kOxHsvqQX+dbsGKBadlfKNzKe+E2rbddKrAqdtiPaxBzxUL4j2xE0OCmcfT2dgK/HxiimrFgdwNEZDQhQaH2KW0jCDVW7qdTCMp8CMTb9icxQ/a1+LCw3JR1c/lqHuNdlnNzRVphag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422650; c=relaxed/simple;
	bh=LEl8ZPVfSSVL727qEL2W5qGCwuoOB17ndrgtWNvMjZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=od1VgO2rTWQ5jvxdem6xxEALwo6eMzHOWZQkztSfSLDTCmkG6fVYfEmsTRCsp5w413gB+GiiPnHm363aSQQGPNyt4/ISIuRhY7jDMynAheWrDoGlcb66VQo0oUj0fdirxBlGu+kOZglsgnvERVzljtNLp9KKP0qN6lWNWg/wMX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s2WJ8Tw+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s2WJ8Tw+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D56E31F000E9;
	Thu, 30 Jul 2026 14:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422649;
	bh=n6caYpcn5cKjwoKmbETQ0O3dmKnZGLC9wLr1A4jMU00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s2WJ8Tw+dbqFfr8eYqCu/luRv3LXl4+dQwc6MnEHtCHRTTtaxOvBzQ5D74/gNw5ES
	 ONka4kSg+yVKCd3W5jmRwEKQW5d1AqKzKeNPF5qo0Plws6qTrXCfmgc+KU/rkaRz0F
	 vQaUTvqdhbTALmJwvgWYCPNvISteIzumxNBjznzs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alessandro Rinaldi <ale@alerinaldi.it>,
	George Zhang <george.zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 7.1 457/744] drm/amd/display: Force PWM backlight on Lenovo Legion 5 15ARH05
Date: Thu, 30 Jul 2026 16:12:10 +0200
Message-ID: <20260730141454.011616295@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3984,6 +3984,8 @@ static void update_connector_ext_caps(st
 	caps->ext_caps = &aconnector->dc_link->dpcd_sink_ext_caps;
 	caps->aux_support = false;
 
+	panel_backlight_quirk = drm_get_panel_backlight_quirk(aconnector->drm_edid);
+
 	if (caps->ext_caps->bits.oled == 1
 	    /*
 	     * ||
@@ -3996,6 +3998,9 @@ static void update_connector_ext_caps(st
 		caps->aux_support = false;
 	else if (amdgpu_backlight == 1)
 		caps->aux_support = true;
+	else if (!IS_ERR_OR_NULL(panel_backlight_quirk) &&
+		 panel_backlight_quirk->force_pwm)
+		caps->aux_support = false;
 	if (caps->aux_support)
 		aconnector->dc_link->backlight_control_type = BACKLIGHT_CONTROL_AMD_AUX;
 
@@ -4011,8 +4016,6 @@ static void update_connector_ext_caps(st
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


