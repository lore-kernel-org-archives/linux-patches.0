Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B73A1D5ABA;
	Wed, 25 Feb 2026 01:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983143; cv=none; b=EbW1e/xaOkC/P2Eftrynh9FnW4nY1p3nA58/EZ1SKVSjuk7JkDUv3OkFcHHqtMDnkN76axnmw7DT9JJ9S/izGD5yn4wRTjoXb1gMEaUML81OnpOBsGIYRbVrv6NqtJiIp/6MiPZe1e0F2phpsDNFaExvZQlLG0zVrO+QaaxT/DQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983143; c=relaxed/simple;
	bh=arfcpn1l/DK1bmG8h6fcWiBemxbFOkFbVtlLSjQJAaM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lj6i0ZNpGcELyFv+gsvSuKHIUjHegG8IEpSlQP8yxnRJSpGGDVd0ESVJ3xty1NgQ/YefuH+uZR5cUjvexKqv8mvJJjkhakYGJmBaY3XItgOyf3yoiv+tUVrKQ2kKFu+6TyGpLI22rYN94X9CWLIZGata9Q7+JWIukbsDTROr6Fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SUK+/sG3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SUK+/sG3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F2D9C19423;
	Wed, 25 Feb 2026 01:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983142;
	bh=arfcpn1l/DK1bmG8h6fcWiBemxbFOkFbVtlLSjQJAaM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SUK+/sG3fkcnnPVs90WRg8s8aDqxvgqYMdhX12T+f4PLt96nrTGXIySTIeoSjshC2
	 rGZH7uLWoU66L/6sP0TVSBJcGhEnkFpp9ranp4LM9qQ/r7vRERYCm5aYGbSJ3/tDNM
	 xFwKwkF0iR6PNKSi0d+SZ1bOraXElLJoc03Ge5wk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vinod Govindapillai <vinod.govindapillai@intel.com>,
	Uma Shankar <uma.shankar@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 296/781] drm/i915/display: fix the pixel normalization handling for xe3p_lpd
Date: Tue, 24 Feb 2026 17:16:45 -0800
Message-ID: <20260225012406.968584260@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vinod Govindapillai <vinod.govindapillai@intel.com>

[ Upstream commit 3e28a67a85f9b569066f6dfcddadb39294c0c9d4 ]

Pixel normalizer is enabled with normalization factor as 1.0 for
FP16 formats in order to support FBC for those formats in xe3p_lpd.
Previously pixel normalizer gets disabled during the plane disable
routine. But there could be plane format settings without explicitly
calling the plane disable in-between and we could endup keeping the
pixel normalizer enabled for formats which we don't require that.
This is causing crc mismatches in yuv formats and FIFO underruns in
planar formats like NV12. Fix this by updating the pixel normalizer
configuration based on the pixel formats explicitly during the plane
settings arm calls itself - enable it for FP16 and disable it for
other formats in HDR capable planes.

v2: avoid redundant pixel normalization setting updates

v3: moved the normalization factor definition to intel_fbc.c and some
    updates to comments

v4: simplified the pixel normalizer setting handling

Fixes: 5298eea7ed20 ("drm/i915/xe3p_lpd: use pixel normalizer for fp16 formats for FBC")
Signed-off-by: Vinod Govindapillai <vinod.govindapillai@intel.com>
Reviewed-by: Uma Shankar <uma.shankar@intel.com>
Link: https://patch.msgid.link/20260130095919.107805-1-vinod.govindapillai@intel.com
(cherry picked from commit c0dc68f4e2aa7eddb9ec6d95931f9576d8fe7334)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../drm/i915/display/intel_display_device.h   |  1 +
 drivers/gpu/drm/i915/display/intel_fbc.c      | 10 +++---
 drivers/gpu/drm/i915/display/intel_fbc.h      |  3 +-
 .../drm/i915/display/skl_universal_plane.c    | 36 +++++++++----------
 4 files changed, 26 insertions(+), 24 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_display_device.h b/drivers/gpu/drm/i915/display/intel_display_device.h
index b559ef43d5470..6944d081f0ad3 100644
--- a/drivers/gpu/drm/i915/display/intel_display_device.h
+++ b/drivers/gpu/drm/i915/display/intel_display_device.h
@@ -189,6 +189,7 @@ struct intel_display_platforms {
 #define HAS_MSO(__display)		(DISPLAY_VER(__display) >= 12)
 #define HAS_OVERLAY(__display)		(DISPLAY_INFO(__display)->has_overlay)
 #define HAS_PIPEDMC(__display)		(DISPLAY_VER(__display) >= 12)
+#define HAS_PIXEL_NORMALIZER(__display)	(DISPLAY_VER(__display) >= 35)
 #define HAS_PSR(__display)		(DISPLAY_INFO(__display)->has_psr)
 #define HAS_PSR_HW_TRACKING(__display)	(DISPLAY_INFO(__display)->has_psr_hw_tracking)
 #define HAS_PSR2_SEL_FETCH(__display)	(DISPLAY_VER(__display) >= 12)
diff --git a/drivers/gpu/drm/i915/display/intel_fbc.c b/drivers/gpu/drm/i915/display/intel_fbc.c
index 437d2fda20a7e..8d387709f25cc 100644
--- a/drivers/gpu/drm/i915/display/intel_fbc.c
+++ b/drivers/gpu/drm/i915/display/intel_fbc.c
@@ -1120,13 +1120,15 @@ static bool xe3p_lpd_fbc_pixel_format_is_valid(const struct intel_plane_state *p
 	}
 }
 
-bool
-intel_fbc_is_enable_pixel_normalizer(const struct intel_plane_state *plane_state)
+bool intel_fbc_need_pixel_normalizer(const struct intel_plane_state *plane_state)
 {
 	struct intel_display *display = to_intel_display(plane_state);
 
-	return DISPLAY_VER(display) >= 35 &&
-	       xe3p_lpd_fbc_fp16_format_is_valid(plane_state);
+	if (HAS_PIXEL_NORMALIZER(display) &&
+	    xe3p_lpd_fbc_fp16_format_is_valid(plane_state))
+		return true;
+
+	return false;
 }
 
 static bool pixel_format_is_valid(const struct intel_plane_state *plane_state)
diff --git a/drivers/gpu/drm/i915/display/intel_fbc.h b/drivers/gpu/drm/i915/display/intel_fbc.h
index 91424563206a3..7e2416b29a0ea 100644
--- a/drivers/gpu/drm/i915/display/intel_fbc.h
+++ b/drivers/gpu/drm/i915/display/intel_fbc.h
@@ -53,7 +53,6 @@ void intel_fbc_prepare_dirty_rect(struct intel_atomic_state *state,
 				  struct intel_crtc *crtc);
 void intel_fbc_dirty_rect_update_noarm(struct intel_dsb *dsb,
 				       struct intel_plane *plane);
-bool
-intel_fbc_is_enable_pixel_normalizer(const struct intel_plane_state *plane_state);
+bool intel_fbc_need_pixel_normalizer(const struct intel_plane_state *plane_state);
 
 #endif /* __INTEL_FBC_H__ */
diff --git a/drivers/gpu/drm/i915/display/skl_universal_plane.c b/drivers/gpu/drm/i915/display/skl_universal_plane.c
index ee8e24497d2cf..ed14b9ea2ad2d 100644
--- a/drivers/gpu/drm/i915/display/skl_universal_plane.c
+++ b/drivers/gpu/drm/i915/display/skl_universal_plane.c
@@ -892,23 +892,20 @@ static void icl_plane_disable_sel_fetch_arm(struct intel_dsb *dsb,
 	intel_de_write_dsb(display, dsb, SEL_FETCH_PLANE_CTL(pipe, plane->id), 0);
 }
 
-static void x3p_lpd_plane_update_pixel_normalizer(struct intel_dsb *dsb,
-						  struct intel_plane *plane,
-						  bool enable)
+static bool plane_has_normalizer(struct intel_plane *plane)
 {
 	struct intel_display *display = to_intel_display(plane);
-	enum intel_fbc_id fbc_id = skl_fbc_id_for_pipe(plane->pipe);
-	u32 val;
 
-	/* Only HDR planes have pixel normalizer and don't matter if no FBC */
-	if (!skl_plane_has_fbc(display, fbc_id, plane->id))
-		return;
+	return HAS_PIXEL_NORMALIZER(display) && icl_is_hdr_plane(display, plane->id);
+}
 
-	val = enable ? PLANE_PIXEL_NORMALIZE_NORM_FACTOR(PLANE_PIXEL_NORMALIZE_NORM_FACTOR_1_0) |
-		       PLANE_PIXEL_NORMALIZE_ENABLE : 0;
+static u32 pixel_normalizer_value(const struct intel_plane_state *plane_state)
+{
+	if (!intel_fbc_need_pixel_normalizer(plane_state))
+		return 0;
 
-	intel_de_write_dsb(display, dsb,
-			   PLANE_PIXEL_NORMALIZE(plane->pipe, plane->id), val);
+	return PLANE_PIXEL_NORMALIZE_ENABLE |
+	       PLANE_PIXEL_NORMALIZE_NORM_FACTOR(PLANE_PIXEL_NORMALIZE_NORM_FACTOR_1_0);
 }
 
 static void
@@ -927,8 +924,9 @@ icl_plane_disable_arm(struct intel_dsb *dsb,
 
 	icl_plane_disable_sel_fetch_arm(dsb, plane, crtc_state);
 
-	if (DISPLAY_VER(display) >= 35)
-		x3p_lpd_plane_update_pixel_normalizer(dsb, plane, false);
+	if (plane_has_normalizer(plane))
+		intel_de_write_dsb(display, dsb,
+				   PLANE_PIXEL_NORMALIZE(plane->pipe, plane->id), 0);
 
 	intel_de_write_dsb(display, dsb, PLANE_CTL(pipe, plane_id), 0);
 	intel_de_write_dsb(display, dsb, PLANE_SURF(pipe, plane_id), 0);
@@ -1677,11 +1675,13 @@ icl_plane_update_arm(struct intel_dsb *dsb,
 
 	/*
 	 * In order to have FBC for fp16 formats pixel normalizer block must be
-	 * active. Check if pixel normalizer block need to be enabled for FBC.
-	 * If needed, use normalization factor as 1.0 and enable the block.
+	 * active. For FP16 formats, use normalization factor as 1.0 and enable
+	 * the block.
 	 */
-	if (intel_fbc_is_enable_pixel_normalizer(plane_state))
-		x3p_lpd_plane_update_pixel_normalizer(dsb, plane, true);
+	if (plane_has_normalizer(plane))
+		intel_de_write_dsb(display, dsb,
+				   PLANE_PIXEL_NORMALIZE(plane->pipe, plane->id),
+				   pixel_normalizer_value(plane_state));
 
 	/*
 	 * The control register self-arms if the plane was previously
-- 
2.51.0



