Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6C65266B65;
	Tue, 30 Sep 2025 15:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244813; cv=none; b=iCjT4UGx1uz0CHyZw3JcB5zZ5c72tofuljy80zSxAdgCqgkMMKRfOn5C77cTmuyPJPm5HkbIpcAcWO6TkSenb9Huyuw/nlAFoll2fGLtmdT02HNa6s9L0P0b68OwQMmy42803IZkqbHjo57ypWD8HXNDFOS6RrdUYCV94a+5RfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244813; c=relaxed/simple;
	bh=dpJ1iJACEavZerUzgvbG6Dr5CPDxrmf+aqggLjIIVq0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iQJ6SkN5wCVbUTdnWJ534Sn0wTJK2qmIpQe2ITwrv6gNlNA/OvhMItf1Jj1iYhfUWph5AnYGQQPaW7Ew1TPAxsmh+0lf+4kNUwSqWVwzTwVLzNTfC0MdHpyD88xWmjw0Jg0g+Cdv/pvoAfmr0M4GXA4Uweege5jKY1dhfWs/BJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CVeK0Oyb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CVeK0Oyb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 286E8C4CEF0;
	Tue, 30 Sep 2025 15:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244812;
	bh=dpJ1iJACEavZerUzgvbG6Dr5CPDxrmf+aqggLjIIVq0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CVeK0Oybj3Lw1inc8TmNDBkLiRXZb4PZj+DQm9MegyfBd2INZesqSnUu+zDBeJHtl
	 c5bSBNKkpPHUl9Fdx8RAEDRGCx7i2zTRbvn8gzTh+/YNYBrY3lrx5kiTZs2I5wYk2b
	 xCQHkGDJ5HjwqzNFighVmvAPehj8uFe/8ZXTDa6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Schwartz <matthew.schwartz@linux.dev>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.16 120/143] drm/amd/display: Only restore backlight after amdgpu_dm_init or dm_resume
Date: Tue, 30 Sep 2025 16:47:24 +0200
Message-ID: <20250930143836.014468142@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143831.236060637@linuxfoundation.org>
References: <20250930143831.236060637@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Schwartz <matthew.schwartz@linux.dev>

commit 44b0fed0a5947f54fd14255cd0766df952267bc5 upstream.

On clients that utilize AMD_PRIVATE_COLOR properties for HDR support,
brightness sliders can include a hardware controlled portion and a
gamma-based portion. This is the case on the Steam Deck OLED when using
gamescope with Steam as a client.

When a user sets a brightness level while HDR is active, the gamma-based
portion and/or hardware portion are adjusted to achieve the desired
brightness. However, when a modeset takes place while the gamma-based
portion is in-use, restoring the hardware brightness level overrides the
user's overall brightness level and results in a mismatch between what
the slider reports and the display's current brightness.

To avoid overriding gamma-based brightness, only restore HW backlight
level after boot or resume. This ensures that the backlight level is
set correctly after the DC layer resets it while avoiding interference
with subsequent modesets.

Fixes: 7875afafba84 ("drm/amd/display: Fix brightness level not retained over reboot")
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4551
Signed-off-by: Matthew Schwartz <matthew.schwartz@linux.dev>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit a490c8d77d500b5981e739be3d59c60cfe382536)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |   12 ++++++++----
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h |    7 +++++++
 2 files changed, 15 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -2035,6 +2035,8 @@ static int amdgpu_dm_init(struct amdgpu_
 
 	dc_hardware_init(adev->dm.dc);
 
+	adev->dm.restore_backlight = true;
+
 	adev->dm.hpd_rx_offload_wq = hpd_rx_irq_create_workqueue(adev);
 	if (!adev->dm.hpd_rx_offload_wq) {
 		drm_err(adev_to_drm(adev), "amdgpu: failed to create hpd rx offload workqueue.\n");
@@ -3396,6 +3398,7 @@ static int dm_resume(struct amdgpu_ip_bl
 		dc_set_power_state(dm->dc, DC_ACPI_CM_POWER_STATE_D0);
 
 		dc_resume(dm->dc);
+		adev->dm.restore_backlight = true;
 
 		amdgpu_dm_irq_resume_early(adev);
 
@@ -9801,7 +9804,6 @@ static void amdgpu_dm_commit_streams(str
 	bool mode_set_reset_required = false;
 	u32 i;
 	struct dc_commit_streams_params params = {dc_state->streams, dc_state->stream_count};
-	bool set_backlight_level = false;
 
 	/* Disable writeback */
 	for_each_old_connector_in_state(state, connector, old_con_state, i) {
@@ -9921,7 +9923,6 @@ static void amdgpu_dm_commit_streams(str
 			acrtc->hw_mode = new_crtc_state->mode;
 			crtc->hwmode = new_crtc_state->mode;
 			mode_set_reset_required = true;
-			set_backlight_level = true;
 		} else if (modereset_required(new_crtc_state)) {
 			drm_dbg_atomic(dev,
 				       "Atomic commit: RESET. crtc id %d:[%p]\n",
@@ -9978,13 +9979,16 @@ static void amdgpu_dm_commit_streams(str
 	 * to fix a flicker issue.
 	 * It will cause the dm->actual_brightness is not the current panel brightness
 	 * level. (the dm->brightness is the correct panel level)
-	 * So we set the backlight level with dm->brightness value after set mode
+	 * So we set the backlight level with dm->brightness value after initial
+	 * set mode. Use restore_backlight flag to avoid setting backlight level
+	 * for every subsequent mode set.
 	 */
-	if (set_backlight_level) {
+	if (dm->restore_backlight) {
 		for (i = 0; i < dm->num_of_edps; i++) {
 			if (dm->backlight_dev[i])
 				amdgpu_dm_backlight_set_level(dm, i, dm->brightness[i]);
 		}
+		dm->restore_backlight = false;
 	}
 }
 
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
@@ -611,6 +611,13 @@ struct amdgpu_display_manager {
 	u32 actual_brightness[AMDGPU_DM_MAX_NUM_EDP];
 
 	/**
+	 * @restore_backlight:
+	 *
+	 * Flag to indicate whether to restore backlight after modeset.
+	 */
+	bool restore_backlight;
+
+	/**
 	 * @aux_hpd_discon_quirk:
 	 *
 	 * quirk for hpd discon while aux is on-going.


