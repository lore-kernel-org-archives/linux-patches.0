Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A17FC1D7E41;
	Mon, 12 May 2025 18:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072907; cv=none; b=YGuNgiigbsAahSG92x4VZM3WccOeXH9gzr7xXMYM2o4PfqHD/7TxOj5amP1l4N7axW7d4+QKf49WfSTK8l5LtuUyg7DAcdXbod2Ibc+1O64TgeynG2LBeIqZ64QvNEM3jNbXxovjr6p+etYna0Zb3IwMBq6GxXcqBAaxVaX1Pv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072907; c=relaxed/simple;
	bh=AFD3Iz8C/7yfKU5G7ULGY0gNyU3/plpnvfPcsrLHdfc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IKo82FqeWtlFz9IHHl9kX7lvQxjbSm4QIePwnoeSuOvqKy39eIBYq0MgZyVSN3R1Bf5BWOawAAxr58Pyio2meAlzTJgvOVCVTfXXswZIlSie4lthZundB1XAspqcwALjmKV+RcSipNAVfGQ8GRCtnZXVxUwdUSKVyfxSpPSEf3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D6hx+1UB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D6hx+1UB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30FA0C4CEE7;
	Mon, 12 May 2025 18:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072907;
	bh=AFD3Iz8C/7yfKU5G7ULGY0gNyU3/plpnvfPcsrLHdfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D6hx+1UBPB2Fj5PKATNni00XGirYeXedr8V6GofBwfI/3d5laFqXpfBruS3tfiBMk
	 36GjROuNXRGKu/DF40WWkrK1SBzhSqU1qZ7qNyrGAsH6CB1oEw2vpfobUmu21uyw7D
	 ywsM/bz+CgZyIFw59Y2pL+1DsPd8EAfqCg23SQQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChiaHsuan Chung <chiahsuan.chung@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Ray Wu <ray.wu@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.12 092/184] drm/amd/display: more liberal vmin/vmax update for freesync
Date: Mon, 12 May 2025 19:44:53 +0200
Message-ID: <20250512172045.575248967@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172041.624042835@linuxfoundation.org>
References: <20250512172041.624042835@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aurabindo Pillai <aurabindo.pillai@amd.com>

commit f1c6be3999d2be2673a51a9be0caf9348e254e52 upstream.

[Why]
FAMS2 expects vmin/vmax to be updated in the case when freesync is
off, but supported. But we only update it when freesync is enabled.

[How]
Change the vsync handler such that dc_stream_adjust_vmin_vmax() its called
irrespective of whether freesync is enabled. If freesync is supported,
then there is no harm in updating vmin/vmax registers.

Closes: https://gitlab.freedesktop.org/drm/amd/-/issues/3546
Reviewed-by: ChiaHsuan Chung <chiahsuan.chung@amd.com>
Signed-off-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Ray Wu <ray.wu@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit cfb2d41831ee5647a4ae0ea7c24971a92d5dfa0d)
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -666,15 +666,21 @@ static void dm_crtc_high_irq(void *inter
 	spin_lock_irqsave(&adev_to_drm(adev)->event_lock, flags);
 
 	if (acrtc->dm_irq_params.stream &&
-	    acrtc->dm_irq_params.vrr_params.supported &&
-	    acrtc->dm_irq_params.freesync_config.state ==
-		    VRR_STATE_ACTIVE_VARIABLE) {
+		acrtc->dm_irq_params.vrr_params.supported) {
+		bool replay_en = acrtc->dm_irq_params.stream->link->replay_settings.replay_feature_enabled;
+		bool psr_en = acrtc->dm_irq_params.stream->link->psr_settings.psr_feature_enabled;
+		bool fs_active_var_en = acrtc->dm_irq_params.freesync_config.state == VRR_STATE_ACTIVE_VARIABLE;
+
 		mod_freesync_handle_v_update(adev->dm.freesync_module,
 					     acrtc->dm_irq_params.stream,
 					     &acrtc->dm_irq_params.vrr_params);
 
-		dc_stream_adjust_vmin_vmax(adev->dm.dc, acrtc->dm_irq_params.stream,
-					   &acrtc->dm_irq_params.vrr_params.adjust);
+		/* update vmin_vmax only if freesync is enabled, or only if PSR and REPLAY are disabled */
+		if (fs_active_var_en || (!fs_active_var_en && !replay_en && !psr_en)) {
+			dc_stream_adjust_vmin_vmax(adev->dm.dc,
+					acrtc->dm_irq_params.stream,
+					&acrtc->dm_irq_params.vrr_params.adjust);
+		}
 	}
 
 	/*


