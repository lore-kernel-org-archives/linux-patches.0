Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C66F121CA03;
	Sat,  7 Jun 2025 10:11:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749291092; cv=none; b=CZmJIjPRoTyGWC8wBJDPZ6lVjJ2Q9bHP81TOVJbJDjkO8y3kAzOGrY3PFqGohCCdmPbHCMsfe4AnW5NNINBsHn7Pl/j1wLgxShcgw1YNYvEyIor8BtCfar1p2KbMgRr0ZGdvf6dwf6AlaMjnvqVbEdaqGjfoURcJ1TmFTngDzOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749291092; c=relaxed/simple;
	bh=pxN7evBAbLEH/0Z7T7GebuYa0q+w0KsoL+UNX95O1Zo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WEExuGm3WcJaBj5mznHJiib2B663vA1RWoxlonpsOPU7tUuYyzFXWMEXQL/YwUWP8SmwnvXS93D4g3FoicKBQVtV81xmL+LBwcdjhLt9O8ARvt6e1Kdp/jR6LWUwpv9ocB4ck/1zalV0EPNcQukFqAHqZNC9DLS40Pog/Q2OuA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=klupyk14; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="klupyk14"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 597F6C4CEE4;
	Sat,  7 Jun 2025 10:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1749291092;
	bh=pxN7evBAbLEH/0Z7T7GebuYa0q+w0KsoL+UNX95O1Zo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=klupyk142Cwx13z9BuNIUgNbmR3rh7Y+Ctx+ZkuYTELW02YtErHJPdpfnSofu4kl0
	 5aJhZlKxLp5SclixCUi5hsi1Tk1eNEmx74j3EyjAG4un9d9sRaoZGkgt2miOG0dzF1
	 efDsQs6HsO0kLICy1MZurnFmv8fD1LCIRDxfJuUg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.15 34/34] Revert "drm/amd/display: more liberal vmin/vmax update for freesync"
Date: Sat,  7 Jun 2025 12:08:15 +0200
Message-ID: <20250607100721.057977700@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250607100719.711372213@linuxfoundation.org>
References: <20250607100719.711372213@linuxfoundation.org>
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

From: Aurabindo Pillai <aurabindo.pillai@amd.com>

commit 1b824eef269db44d068bbc0de74c94a8e8f9ce02 upstream.

This reverts commit cfb2d41831ee5647a4ae0ea7c24971a92d5dfa0d since it
causes regressions on certain configs. Revert until the issue can be
isolated and debugged.

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/4238
Signed-off-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |   16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -675,21 +675,15 @@ static void dm_crtc_high_irq(void *inter
 	spin_lock_irqsave(&adev_to_drm(adev)->event_lock, flags);
 
 	if (acrtc->dm_irq_params.stream &&
-		acrtc->dm_irq_params.vrr_params.supported) {
-		bool replay_en = acrtc->dm_irq_params.stream->link->replay_settings.replay_feature_enabled;
-		bool psr_en = acrtc->dm_irq_params.stream->link->psr_settings.psr_feature_enabled;
-		bool fs_active_var_en = acrtc->dm_irq_params.freesync_config.state == VRR_STATE_ACTIVE_VARIABLE;
-
+	    acrtc->dm_irq_params.vrr_params.supported &&
+	    acrtc->dm_irq_params.freesync_config.state ==
+		    VRR_STATE_ACTIVE_VARIABLE) {
 		mod_freesync_handle_v_update(adev->dm.freesync_module,
 					     acrtc->dm_irq_params.stream,
 					     &acrtc->dm_irq_params.vrr_params);
 
-		/* update vmin_vmax only if freesync is enabled, or only if PSR and REPLAY are disabled */
-		if (fs_active_var_en || (!fs_active_var_en && !replay_en && !psr_en)) {
-			dc_stream_adjust_vmin_vmax(adev->dm.dc,
-					acrtc->dm_irq_params.stream,
-					&acrtc->dm_irq_params.vrr_params.adjust);
-		}
+		dc_stream_adjust_vmin_vmax(adev->dm.dc, acrtc->dm_irq_params.stream,
+					   &acrtc->dm_irq_params.vrr_params.adjust);
 	}
 
 	/*


