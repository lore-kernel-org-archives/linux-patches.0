Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 589CD20A5F2;
	Sat,  7 Jun 2025 10:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749291000; cv=none; b=VOJbbb3t1yGJSQx/o2ZboQxMwyRsMqKe03nuT1xscd9gmvjAup2ohD202Y4nx6nxx2O1jzC48zaNG0YDPNadwyzvRyax1MLAKj8Nr8m7Eo4ubdY4Wr+X8vnX511Jdq5JlT9YdZHT0tz1n669C05D2elK1lQZFlscFqTh+ciV3VA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749291000; c=relaxed/simple;
	bh=8MW75Q1i/lPUrzJ+liWfmtvU2ZaXk6PtHIa9xS53G5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cBaUWZ8RDi5Ge+Th6dIOqpAfzt0AKFGZQojJSgQOOmWyDeI106qXmGzCyx3eaCJ/LynPDLGP/2vCpF6hTVGu6VC2stSA4Zh2+J8z9SFBrLa8Vr3TTUKbdAFyzVE/paadFtp7AfjpSBdmtU2GOz1EQNjVSwzDWVp1n4L2x/Haxrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uGLYebiK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uGLYebiK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA0CAC4CEE4;
	Sat,  7 Jun 2025 10:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1749291000;
	bh=8MW75Q1i/lPUrzJ+liWfmtvU2ZaXk6PtHIa9xS53G5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uGLYebiKWq4e9uCIlyX2MDFqTYzY49mfvqtEzQnUzp5M2XC9Ke8rK76rLhGNOuoaV
	 qZEDGXuk9QxNrsqHZmQKpmmRG2hJm2quSIOoJVnYdSRgOUFns5Z7SDL/x1zVFT4FR5
	 /lIBO+kvtpz4Nknjnlq+iNIrCiJ9qLzhJ6edNuJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.14 24/24] Revert "drm/amd/display: more liberal vmin/vmax update for freesync"
Date: Sat,  7 Jun 2025 12:08:04 +0200
Message-ID: <20250607100718.643894267@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250607100717.706871523@linuxfoundation.org>
References: <20250607100717.706871523@linuxfoundation.org>
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
@@ -670,21 +670,15 @@ static void dm_crtc_high_irq(void *inter
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


