Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F2CA35CB6F;
	Wed,  8 Apr 2026 18:34:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673256; cv=none; b=HX+5LrwxintacpbqTbmcFW4pwrpoy1NCQpIOjM4Fm+vKnA/DFok4tOKnBvEhxDaCYRzihZfbo1WssQtCrMwqXf5TqPaErIkeWO6OrUeLAy5J36JV0F1QVwVMzEnxSgItBBSZH9nUAJtMcCDDwYYYC3tSmO6xwnSLdH7krzNo10g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673256; c=relaxed/simple;
	bh=kOZyaYqR3YnrynECefudQbGII0EYEBeKRJIMWPuatTc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NhGs0jWP8HiYFECFxGwEBhsmri/65nIYAdUBhY4n2AuKIdUNI20RPPoiWEmh3W5p8kypqIlCLxqjYfWAAQwH9KZutbJyfCYLUYwFCNyKao6itEoSeKnP1nOUIzOoLWw+r5subQ/RHYM5gz4I90fTv8xrsSZkOEh8oZkWRzdkiUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UC0dGx3v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UC0dGx3v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06D4EC19421;
	Wed,  8 Apr 2026 18:34:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673256;
	bh=kOZyaYqR3YnrynECefudQbGII0EYEBeKRJIMWPuatTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UC0dGx3vubimlUy0erbbxfQWeBpny8RoOkyY0I3gV16moJ6FeEwBBfS03DAzTHTSB
	 DmQqWggcpBbtLhA2BfG3axn3FzBsyNc8cAMycfu5WtgXQWvtEgjQGBpkwQTLeU5Oc9
	 pqBSjI1f+ef3T8gSIBOhNKrBm/z7E53RDFPRUqeo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Subject: [PATCH 6.18 162/277] drm/i915/dsi: Dont do DSC horizontal timing adjustments in command mode
Date: Wed,  8 Apr 2026 20:02:27 +0200
Message-ID: <20260408175939.920357321@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit 4dfce79e098915d8e5fc2b9e1d980bc3251dd32c upstream.

Stop adjusting the horizontal timing values based on the
compression ratio in command mode. Bspec seems to be telling
us to do this only in video mode, and this is also how the
Windows driver does things.

This should also fix a div-by-zero on some machines because
the adjusted htotal ends up being so small that we end up with
line_time_us==0 when trying to determine the vtotal value in
command mode.

Note that this doesn't actually make the display on the
Huawei Matebook E work, but at least the kernel no longer
explodes when the driver loads.

Cc: stable@vger.kernel.org
Closes: https://gitlab.freedesktop.org/drm/i915/kernel/-/issues/12045
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patch.msgid.link/20260326111814.9800-2-ville.syrjala@linux.intel.com
Fixes: 53693f02d80e ("drm/i915/dsi: account for DSC in horizontal timings")
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
(cherry picked from commit 0b475e91ecc2313207196c6d7fd5c53e1a878525)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/icl_dsi.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/display/icl_dsi.c
+++ b/drivers/gpu/drm/i915/display/icl_dsi.c
@@ -890,7 +890,7 @@ gen11_dsi_set_transcoder_timings(struct
 	 * non-compressed link speeds, and simplifies down to the ratio between
 	 * compressed and non-compressed bpp.
 	 */
-	if (crtc_state->dsc.compression_enable) {
+	if (is_vid_mode(intel_dsi) && crtc_state->dsc.compression_enable) {
 		mul = fxp_q4_to_int(crtc_state->dsc.compressed_bpp_x16);
 		div = mipi_dsi_pixel_format_to_bpp(intel_dsi->pixel_format);
 	}
@@ -1506,7 +1506,7 @@ static void gen11_dsi_get_timings(struct
 	struct drm_display_mode *adjusted_mode =
 					&pipe_config->hw.adjusted_mode;
 
-	if (pipe_config->dsc.compressed_bpp_x16) {
+	if (is_vid_mode(intel_dsi) && pipe_config->dsc.compressed_bpp_x16) {
 		int div = fxp_q4_to_int(pipe_config->dsc.compressed_bpp_x16);
 		int mul = mipi_dsi_pixel_format_to_bpp(intel_dsi->pixel_format);
 


