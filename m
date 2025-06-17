Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C10952ECD1B;
	Tue, 17 Jun 2025 15:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174209; cv=none; b=EePq+a6bjzFYOlZX9QoKJsGlzWYRAHkrGFQ6RoSw8Y4MM4K9hHMvaE+40EaSrmELNLaaFe+p/wfg3jew/0t7OX1+exKp9QxbEmAv6GlGO0CTkN9TRf5y+Gq7u4cMsh6dD/RYhE7Fr+EAcBbPAZViRL0b+hjt9WREgBghGrPRmMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174209; c=relaxed/simple;
	bh=BkuCVsM25fLJUOTTVwXsbfo06TNlBmb3XZbvUql53xY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=acYnN6R7/iqFmlqb28TZ6rSTRcJfuj/YgtkAo3erlX4KuH7BFhuMWucsQdI7w3602E4SpBdwpMUOkdSkSo1+48NtKqOkQz6FEjN0uQoQnhwdpFSolRRSXsavb+rcQKu0qgym2UYOhTiskD3o4UAVV3xVvhUi9QXIKfPK2+hp2f4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2ROqxLYh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2ROqxLYh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2B04C4CEE3;
	Tue, 17 Jun 2025 15:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174209;
	bh=BkuCVsM25fLJUOTTVwXsbfo06TNlBmb3XZbvUql53xY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2ROqxLYhlRt1DEKCoR4jY9V4kPm+u7sUQfFulAbNaUUW6QCYv4f/1PlCfSgT8rB3X
	 opO8wpFQ5J6C7TsjuO2seQLXy/j0N8AKIybXGCZdrpR2YgaeMwkLlqceSqzM6p+6qD
	 0tEkq9WTLItYFRgVzwT/09anx7fd21XQxr56/RYU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.6 017/356] Revert "drm/amd/display: more liberal vmin/vmax update for freesync"
Date: Tue, 17 Jun 2025 17:22:12 +0200
Message-ID: <20250617152338.933383957@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -610,21 +610,15 @@ static void dm_crtc_high_irq(void *inter
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


