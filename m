Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F0A528CF62;
	Wed, 23 Apr 2025 15:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421384; cv=none; b=lop3K9i/DCN3dvBfbb5IvPYQ1TMICT2LxbtwpOzkPkwdYsO5+ZLMY0GHxSilDtx1OWd+nK1oVTo7B0QN4OeFGnheSugtQi11iTv06MpPsrIJwpws+I4DQ+OF69D7jAAjrypyXDS3BoktgBhH3+8owDFY/KT+Z2D+ojYS8iCRge4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421384; c=relaxed/simple;
	bh=gkJLNdIPnVXChRB8wY+7/o3W4Hqiy29Cxj1YEIVjlUw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uIlN6dyoUTX0/uJfnXvdrPOwUKuIiYqqlYRBwc0Dgz9anvQ6lhcnj1Hwe//sBrpirK4lY5rBRpGaH2zNZaHRkNwfC56uzRjbtJiXog9t8J/yWlaIAEwmBOe4bzMkTyq4QWa/5K4sHoHsF2bChG6sBVApTHFsFAscZkSZ9KOia5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ofxj5tEk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ofxj5tEk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2F42C4CEE2;
	Wed, 23 Apr 2025 15:16:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421384;
	bh=gkJLNdIPnVXChRB8wY+7/o3W4Hqiy29Cxj1YEIVjlUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ofxj5tEkmt6x1j3MxnaczfVkVqbWhVFAyeuaXHLx6fJAbIfNjpuCS0Dn4VO0vkEFq
	 LE+NrS/kPHc1Mzv0wvL97mJ68POlQzv/gHo82Z4nSNWCWrmLhinFh6gY89Pu0LXUTV
	 h1T6E1HzGedQr6SwSB5r9eLo9ghfxYM+/kDPAWu4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Leo Li <sunpeng.li@amd.com>,
	Aurabindo Pillai <aurabindo.pillai@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.14 180/241] drm/amd/display: Increase vblank offdelay for PSR panels
Date: Wed, 23 Apr 2025 16:44:04 +0200
Message-ID: <20250423142627.876024324@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
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

From: Leo Li <sunpeng.li@amd.com>

commit f21e6d149b49c92f9e68aa0c76033e1e13d9f5da upstream.

[Why]

Depending on when the HW latching event (vupdate) of double-buffered
registers happen relative to the PSR SDP (signals panel psr enter/exit)
deadline, and how bad the Panel clock has drifted since the last ALPM
off event, there can be up to 3 frames of delay between sending the PSR
exit cmd to DMUB fw, and when the panel starts displaying live frames.
This can manifest as micro-stuttering when userspace commit patterns
cause rapid toggling of the DRM vblank counter, since PSR enter/exit is
hooked up to DRM vblank disable/enable respectively.

In the ideal world, the panel should present the live frame immediately
on PSR exit cmd. But due to HW design and PSR limitations, immediate
exit can only happen by chance, when:

1. PSR exit cmd is ack'd by FW before HW latching (vupdate) event, and
2. Panel's SDP deadline -- determined by it's PSR Start Delay in DPCD
  71h -- is after the vupdate event. The PSR exit SDP can then be sent
  immediately after HW latches. Otherwise, we have to wait 1 frame. And
3. There is negligible drift between the panel's clock and source clock.
  Otherwise, there can be up to 1 frame of drift.

Note that this delay is not expected with Panel Replay.

[How]

Since PSR power savings can be quite substantial, and there are a lot of
systems in the wild with PSR panels, It'll be nice to have a middle
ground that balances user experience with power savings.

A simple way to achieve this is by extending the vblank offdelay, such
that additional PSR exit delays will be less perceivable.

We can set:

   20/100 * offdelay_ms = 3_frames_ms
=> offdelay_ms = 5 * 3_frames_ms

This ensures that `3_frames_ms` will only be experienced as a 20% delay
on top how long the panel has been static, and thus make the delay
less perceivable.

If this ends up being too high of a percentage, it can be dropped
further in a future change.

Fixes: 537ef0f88897 ("drm/amd/display: use new vblank enable policy for DCN35+")
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Leo Li <sunpeng.li@amd.com>
Signed-off-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |   39 ++++++++++++++++++----
 1 file changed, 32 insertions(+), 7 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -8577,14 +8577,39 @@ static void manage_dm_interrupts(struct
 	int offdelay;
 
 	if (acrtc_state) {
-		if (amdgpu_ip_version(adev, DCE_HWIP, 0) <
-		    IP_VERSION(3, 5, 0) ||
-		    acrtc_state->stream->link->psr_settings.psr_version <
-		    DC_PSR_VERSION_UNSUPPORTED ||
-		    !(adev->flags & AMD_IS_APU)) {
-			timing = &acrtc_state->stream->timing;
+		timing = &acrtc_state->stream->timing;
 
-			/* at least 2 frames */
+		/*
+		 * Depending on when the HW latching event of double-buffered
+		 * registers happen relative to the PSR SDP deadline, and how
+		 * bad the Panel clock has drifted since the last ALPM off
+		 * event, there can be up to 3 frames of delay between sending
+		 * the PSR exit cmd to DMUB fw, and when the panel starts
+		 * displaying live frames.
+		 *
+		 * We can set:
+		 *
+		 * 20/100 * offdelay_ms = 3_frames_ms
+		 * => offdelay_ms = 5 * 3_frames_ms
+		 *
+		 * This ensures that `3_frames_ms` will only be experienced as a
+		 * 20% delay on top how long the display has been static, and
+		 * thus make the delay less perceivable.
+		 */
+		if (acrtc_state->stream->link->psr_settings.psr_version <
+		    DC_PSR_VERSION_UNSUPPORTED) {
+			offdelay = DIV64_U64_ROUND_UP((u64)5 * 3 * 10 *
+						      timing->v_total *
+						      timing->h_total,
+						      timing->pix_clk_100hz);
+			config.offdelay_ms = offdelay ?: 30;
+		} else if (amdgpu_ip_version(adev, DCE_HWIP, 0) <
+			   IP_VERSION(3, 5, 0) ||
+			   !(adev->flags & AMD_IS_APU)) {
+			/*
+			 * Older HW and DGPU have issues with instant off;
+			 * use a 2 frame offdelay.
+			 */
 			offdelay = DIV64_U64_ROUND_UP((u64)20 *
 						      timing->v_total *
 						      timing->h_total,


