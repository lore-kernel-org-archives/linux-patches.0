Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8773B21770B;
	Mon, 12 May 2025 17:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072004; cv=none; b=md+WYnarolIx/c/fByjLytZH+embqfRAt0X8QHzSbgOI107e7s4apni3q1enWdAmYBzMyAQhHR9vL05id09m9fiMFojCTIMh5LXW6lkPzW0cTffNFXofVQwWI0RRg05Q/9QhQaA5up1HcPnWAmIXPFq6hKdSVz2E0TEjx2X+KX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072004; c=relaxed/simple;
	bh=iW8OVfVWZjHE5CK03RHehkeN2DYgJ1Xwa9lcSxqV1o4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DLRbWoLeSGLoBuk22ynRBK118b98fTHAZiDUvVXiSjeAYipiztgw0XHD2xxAOt/gOPpGHchQo3deJifmNMI9wyQCmNIuPWfQKKtI1Rtl3LwHVGDJm6XOz4mxfE9vnRWbtwFODDV0hm+cauzelo6GXMYDwKHhlItSXLIWup+bvao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nTy6gz1R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nTy6gz1R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEF29C4CEE7;
	Mon, 12 May 2025 17:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072004;
	bh=iW8OVfVWZjHE5CK03RHehkeN2DYgJ1Xwa9lcSxqV1o4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nTy6gz1R9dQoQ39mY4bAhITNuPXOHiqkKhMwMTt3vFd42MZhTvvsonh4NinvGfvfi
	 aOik2BjK2u/frPlCD/kVmVW4k3S9lJRphK3v9yuzigijG0d+xVVehkFO2QcV43RJk/
	 uOqtJQ2aBgZPfPqq+lXSCr+4hQj2fvvIBwzZO6cU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ChiaHsuan Chung <chiahsuan.chung@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Ray Wu <ray.wu@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.14 107/197] drm/amd/display: more liberal vmin/vmax update for freesync
Date: Mon, 12 May 2025 19:39:17 +0200
Message-ID: <20250512172048.737012458@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172044.326436266@linuxfoundation.org>
References: <20250512172044.326436266@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
@@ -668,15 +668,21 @@ static void dm_crtc_high_irq(void *inter
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


