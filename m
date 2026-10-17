Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C93023B2FCA;
	Sat, 17 Oct 2026 17:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258464; cv=none; b=n+Qt6Cxym2hQXAdojJ2jqaPZ2IbxJfn0dS4VVZ6NUlytiRP9R/TVRWx5zbv0zmNvZxHmzE2GxtQfIBrYK09MCIqwt3n6l1jD/BBotIdWitqGp6o+GGtXJDSrWkx0nC4i8AHcdtel+QAmd/fX+NVXmQKbQNFlM/JTrVCtm4DIf1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258464; c=relaxed/simple;
	bh=hOqSmpjJ3icdvafCb93HQLU5S/E4PKrYCoBdqf830+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=q6WU7lHL7nUPGlxaIL2XeHtz9ZD//7OrFJvnocNUicS/BA06PEx1hMmAG9hZMHCzfhaiDSnFlhAK/QmleFI29PAdfPFvZN+wIhaJxJ9MI6BHtjHqxeDogKgd2OmskD4ehZIyecTI9m2AT0DpNis/vVltgtwMZM7etKB/vWOsZWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F6kJNZKY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F6kJNZKY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 200521F000C4;
	Sat, 17 Oct 2026 17:34:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258463;
	bh=ep59H79bEbD143ctLrTD4lZKu6cFX6ZdT458hbT45L4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F6kJNZKYrgugJziD4RZoyoylkVuKaP/OzSI/vKy3qxrI4eeL6P9ispS0Tvp+64bm0
	 Ou5P/qtD4AuAyaEtF4FiJ6DeeEGyHNOBd9RbQG7eDX8LmjKdw/zTDYPHVTsQ2/16+3
	 YHReFWzNwkKZpFOcMLOU+STNOUDiIUGJbhqf0v8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0894/1674] drm/i915/dsi: Dont do DSC horizontal timing adjustments in command mode
Date: Sat, 17 Oct 2026 17:52:46 +0200
Message-ID: <20261017160454.079120945@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

[ Upstream commit 4dfce79e098915d8e5fc2b9e1d980bc3251dd32c ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/icl_dsi.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/icl_dsi.c b/drivers/gpu/drm/i915/display/icl_dsi.c
index 0a0efeeb790e2..1b11df1814f41 100644
--- a/drivers/gpu/drm/i915/display/icl_dsi.c
+++ b/drivers/gpu/drm/i915/display/icl_dsi.c
@@ -859,7 +859,7 @@ gen11_dsi_set_transcoder_timings(struct intel_encoder *encoder,
 	 * non-compressed link speeds, and simplifies down to the ratio between
 	 * compressed and non-compressed bpp.
 	 */
-	if (crtc_state->dsc.compression_enable) {
+	if (is_vid_mode(intel_dsi) && crtc_state->dsc.compression_enable) {
 		mul = crtc_state->dsc.compressed_bpp;
 		div = mipi_dsi_pixel_format_to_bpp(intel_dsi->pixel_format);
 	}
@@ -1458,7 +1458,7 @@ static void gen11_dsi_get_timings(struct intel_encoder *encoder,
 	struct drm_display_mode *adjusted_mode =
 					&pipe_config->hw.adjusted_mode;
 
-	if (pipe_config->dsc.compressed_bpp) {
+	if (is_vid_mode(intel_dsi) && pipe_config->dsc.compressed_bpp) {
 		int div = pipe_config->dsc.compressed_bpp;
 		int mul = mipi_dsi_pixel_format_to_bpp(intel_dsi->pixel_format);
 
-- 
2.53.0



