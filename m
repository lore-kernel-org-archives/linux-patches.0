Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B155A1A00CE;
	Tue, 21 Oct 2025 20:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077151; cv=none; b=shouhOdKr4wUFhGvdG6hmELAGEJtsvk3/kNSFDreuGkvjlnHblYvJnE6yHsdrBVQxOAIEFHtB+gg8sDw7UgfI1pgu2ACdkf3tlbHTXFJ8OmXpt1W+U2HlpgN1CBzw3oe6FaKWydVTE+XFwcuJ9eO26/YBWFJlHmfrRNnA83CyQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077151; c=relaxed/simple;
	bh=sQiQETzCoi1y5tehBYjmzFVgwhnf83PMH3/CYvmnHWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KknhrRaSeq+NRAP7jL7rICJsha4x9M5Jix5QCd97ZV6mGtKdNoJau5BYeapYccivxR59BcO8TuYmFQIpkebvgPFuoLI6c6+8edN56d8RuUzrISYx75MDUm16g/FFWmkr+mKD1SEKQnMF8V3N7b6e/YFnKuWXKiXSR6t4r/lQkuM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ye1OtcQI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ye1OtcQI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D00AC4CEF1;
	Tue, 21 Oct 2025 20:05:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077151;
	bh=sQiQETzCoi1y5tehBYjmzFVgwhnf83PMH3/CYvmnHWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ye1OtcQIC60TBTtayQOgcDiuwpsyN8C9WVPZh/3vCY4tuivYNq4g7LAl3B169AJS1
	 uE+kYP/5u82l7eaCZaQ1TWng1Ty+F56LIoO8aU6DjBB4w8gNz/sISYZdDbwUun4z/l
	 Q4MUyakkjf9nVJHFzxqsuqiL7fwon3FlTWZf0Gtw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Schwartz <matthew.schwartz@linux.dev>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.17 016/159] Revert "drm/amd/display: Only restore backlight after amdgpu_dm_init or dm_resume"
Date: Tue, 21 Oct 2025 21:49:53 +0200
Message-ID: <20251021195043.577257065@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
References: <20251021195043.182511864@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Schwartz <matthew.schwartz@linux.dev>

commit 9858ea4c29c283f0a8a3cdbb42108d464ece90a8 upstream.

This fix regressed the original issue that commit 7875afafba84
("drm/amd/display: Fix brightness level not retained over reboot") solved,
so revert it until a different approach to solve the regression that
it caused with AMD_PRIVATE_COLOR is found.

Fixes: a490c8d77d50 ("drm/amd/display: Only restore backlight after amdgpu_dm_init or dm_resume")
Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4620
Cc: stable@vger.kernel.org
Signed-off-by: Matthew Schwartz <matthew.schwartz@linux.dev>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |   12 ++++--------
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h |    7 -------
 2 files changed, 4 insertions(+), 15 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -2041,8 +2041,6 @@ static int amdgpu_dm_init(struct amdgpu_
 
 	dc_hardware_init(adev->dm.dc);
 
-	adev->dm.restore_backlight = true;
-
 	adev->dm.hpd_rx_offload_wq = hpd_rx_irq_create_workqueue(adev);
 	if (!adev->dm.hpd_rx_offload_wq) {
 		drm_err(adev_to_drm(adev), "failed to create hpd rx offload workqueue.\n");
@@ -3405,7 +3403,6 @@ static int dm_resume(struct amdgpu_ip_bl
 		dc_set_power_state(dm->dc, DC_ACPI_CM_POWER_STATE_D0);
 
 		dc_resume(dm->dc);
-		adev->dm.restore_backlight = true;
 
 		amdgpu_dm_irq_resume_early(adev);
 
@@ -9836,6 +9833,7 @@ static void amdgpu_dm_commit_streams(str
 	bool mode_set_reset_required = false;
 	u32 i;
 	struct dc_commit_streams_params params = {dc_state->streams, dc_state->stream_count};
+	bool set_backlight_level = false;
 
 	/* Disable writeback */
 	for_each_old_connector_in_state(state, connector, old_con_state, i) {
@@ -9955,6 +9953,7 @@ static void amdgpu_dm_commit_streams(str
 			acrtc->hw_mode = new_crtc_state->mode;
 			crtc->hwmode = new_crtc_state->mode;
 			mode_set_reset_required = true;
+			set_backlight_level = true;
 		} else if (modereset_required(new_crtc_state)) {
 			drm_dbg_atomic(dev,
 				       "Atomic commit: RESET. crtc id %d:[%p]\n",
@@ -10011,16 +10010,13 @@ static void amdgpu_dm_commit_streams(str
 	 * to fix a flicker issue.
 	 * It will cause the dm->actual_brightness is not the current panel brightness
 	 * level. (the dm->brightness is the correct panel level)
-	 * So we set the backlight level with dm->brightness value after initial
-	 * set mode. Use restore_backlight flag to avoid setting backlight level
-	 * for every subsequent mode set.
+	 * So we set the backlight level with dm->brightness value after set mode
 	 */
-	if (dm->restore_backlight) {
+	if (set_backlight_level) {
 		for (i = 0; i < dm->num_of_edps; i++) {
 			if (dm->backlight_dev[i])
 				amdgpu_dm_backlight_set_level(dm, i, dm->brightness[i]);
 		}
-		dm->restore_backlight = false;
 	}
 }
 
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h
@@ -611,13 +611,6 @@ struct amdgpu_display_manager {
 	u32 actual_brightness[AMDGPU_DM_MAX_NUM_EDP];
 
 	/**
-	 * @restore_backlight:
-	 *
-	 * Flag to indicate whether to restore backlight after modeset.
-	 */
-	bool restore_backlight;
-
-	/**
 	 * @aux_hpd_discon_quirk:
 	 *
 	 * quirk for hpd discon while aux is on-going.


