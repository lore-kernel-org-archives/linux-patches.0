Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA1E829B775;
	Wed, 17 Sep 2025 12:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758112847; cv=none; b=Fb+HNU3eMZnkctXDAgTcyxj2GNwz2DhhTC4AQh7dgLPpPOgjynB75+lVAxxuttjwdh7angWTxKNr6CdajCJSIHipU+CtXnIUrbVN8OePR5hSRxf1g2aDnNpdXSg7DSQ8/M8gqAqnLHMVQHCpwtJVzkTlVK/7+PGReet2r8fmVIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758112847; c=relaxed/simple;
	bh=XLNH/zPmyNATGkYUHP0OQYbDTkKCzVIVGiw2l/c6J9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Mem4oSl1VvVAIFGZDmMl9FGAi4wLSqENmpZr0QExbq3/hHaT51Dh8c7zYfftKrx+NmuPBZslIrS2VEn9XvxAETQf6ryQwQpSJLkn/jxtyCuny466Byo+ORrnuABhWosyawUWveLVd8d3sc5tOSngoQsuFEcgnGUCqMcTSxh+HV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GYeQBR1h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GYeQBR1h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 179CBC4CEF0;
	Wed, 17 Sep 2025 12:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758112847;
	bh=XLNH/zPmyNATGkYUHP0OQYbDTkKCzVIVGiw2l/c6J9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GYeQBR1hDFjyNgX5AUgEUup9ROL2K4v1q9NDe9G+8i2UozwQK9cpVQiTHaxsTk1Pc
	 BhL65sm8ZujSjP+lWvUeGtHornruOJOgKIBjNBp3bbQ1WMmKNAE/wxgm6M5A/oKqn5
	 N1dfsTeMyJA0I9GJmPkTCLtMALIJtfFCRpjZGsfg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Jani Nikula <jani.nikula@intel.com>,
	Imre Deak <imre.deak@intel.com>
Subject: [PATCH 6.16 094/189] drm/edid: Add support for quirks visible to DRM core and drivers
Date: Wed, 17 Sep 2025 14:33:24 +0200
Message-ID: <20250917123354.152198209@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Imre Deak <imre.deak@intel.com>

commit 0b4aa85e8981198e23a68d50ee3c490ccd7f8311 upstream.

Add support for EDID based quirks which can be queried outside of the
EDID parser iteself by DRM core and drivers. There are at least two such
quirks applicable to all drivers: the DPCD register access probe quirk
and the 128b/132b DPRX Lane Count Conversion quirk (see 3.5.2.16.3 in
the v2.1a DP Standard). The latter quirk applies to panels with specific
EDID panel names, support for defining a quirk this way will be added as
a follow-up.

v2: Reset global_quirks in drm_reset_display_info().
v3: (Jani)
- Use one list for both the global and internal quirks.
- Drop change for panel name specific quirks.
- Add comment about the way quirks should be queried.

Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Imre Deak <imre.deak@intel.com>
Link: https://lore.kernel.org/r/20250605082850.65136-4-imre.deak@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_edid.c  |    8 +++++++-
 include/drm/drm_connector.h |    4 +++-
 include/drm/drm_edid.h      |    5 +++++
 3 files changed, 15 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -68,7 +68,7 @@ static int oui(u8 first, u8 second, u8 t
 
 enum drm_edid_internal_quirk {
 	/* First detailed mode wrong, use largest 60Hz mode */
-	EDID_QUIRK_PREFER_LARGE_60,
+	EDID_QUIRK_PREFER_LARGE_60 = DRM_EDID_QUIRK_NUM,
 	/* Reported 135MHz pixel clock is too high, needs adjustment */
 	EDID_QUIRK_135_CLOCK_TOO_HIGH,
 	/* Prefer the largest mode at 75 Hz */
@@ -2959,6 +2959,12 @@ static bool drm_edid_has_internal_quirk(
 	return connector->display_info.quirks & BIT(quirk);
 }
 
+bool drm_edid_has_quirk(struct drm_connector *connector, enum drm_edid_quirk quirk)
+{
+	return connector->display_info.quirks & BIT(quirk);
+}
+EXPORT_SYMBOL(drm_edid_has_quirk);
+
 #define MODE_SIZE(m) ((m)->hdisplay * (m)->vdisplay)
 #define MODE_REFRESH_DIFF(c,t) (abs((c) - (t)))
 
--- a/include/drm/drm_connector.h
+++ b/include/drm/drm_connector.h
@@ -843,7 +843,9 @@ struct drm_display_info {
 	int vics_len;
 
 	/**
-	 * @quirks: EDID based quirks. Internal to EDID parsing.
+	 * @quirks: EDID based quirks. DRM core and drivers can query the
+	 * @drm_edid_quirk quirks using drm_edid_has_quirk(), the rest of
+	 * the quirks also tracked here are internal to EDID parsing.
 	 */
 	u32 quirks;
 
--- a/include/drm/drm_edid.h
+++ b/include/drm/drm_edid.h
@@ -109,6 +109,10 @@ struct detailed_data_string {
 #define DRM_EDID_CVT_FLAGS_STANDARD_BLANKING (1 << 3)
 #define DRM_EDID_CVT_FLAGS_REDUCED_BLANKING  (1 << 4)
 
+enum drm_edid_quirk {
+	DRM_EDID_QUIRK_NUM,
+};
+
 struct detailed_data_monitor_range {
 	u8 min_vfreq;
 	u8 max_vfreq;
@@ -476,5 +480,6 @@ void drm_edid_print_product_id(struct dr
 u32 drm_edid_get_panel_id(const struct drm_edid *drm_edid);
 bool drm_edid_match(const struct drm_edid *drm_edid,
 		    const struct drm_edid_ident *ident);
+bool drm_edid_has_quirk(struct drm_connector *connector, enum drm_edid_quirk quirk);
 
 #endif /* __DRM_EDID_H__ */


