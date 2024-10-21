Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39A271E4937;
	Mon, 21 Oct 2024 10:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729506605; cv=none; b=Yvwj5LuTblqO7EXNcO6CEA/W7yoxmqRShr0a8R9f9QO+ZhPO1QfgNJ+TO1iOOpNtA/T0ovB1YPL7MG7xVxb+OPAK8yg13xsliMApnlPNhjm0rcFYtiPDi8UP3QmPVHtqUhfZgGdFk1QzpSuX238WTyD6TZ3cQKgEUk4h5uqfWBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729506605; c=relaxed/simple;
	bh=PIKfwHzEWlm/6lyrTTt+cnhIUu/bAixWvdzBIhaJBMg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p349oEmn1FrXXPeJ/GdkW1AS/uedwI+1Gu7ToqC/AnZEifRCfm2nFINsZwHgQSiDtrLoPg56ZaB+eZyMU0yXFMXyTgi72uXzvN0ubS3oVa54QAtxIc7Gp0WUB5U6/i2RqqRhG7AhBlzf0plSMPWjiG3UUQttRKO2sN5g/uCqLxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D6fRoBDr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D6fRoBDr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADF22C4CEC7;
	Mon, 21 Oct 2024 10:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729506605;
	bh=PIKfwHzEWlm/6lyrTTt+cnhIUu/bAixWvdzBIhaJBMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D6fRoBDrj9QfGRDCe1cxYTFxwjdkgnSJ5dsCB+w44r1IdNq4/RPulpXeadWw3ghJT
	 SpLGYq/abhzZN4eWY9/fZoMLaUtfKNHce5OsYc5z0dMYdzx+7DcrUtSwY0QnCbXazE
	 tn79E7wXYMhABYZLsT40xzFCjk3bmWzwOTyHlt+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suraj Kandpal <suraj.kandpal@intel.com>,
	Imre Deak <imre.deak@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Subject: [PATCH 6.11 060/135] drm/i915/dp_mst: Handle error during DSC BW overhead/slice calculation
Date: Mon, 21 Oct 2024 12:23:36 +0200
Message-ID: <20241021102301.675497180@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102259.324175287@linuxfoundation.org>
References: <20241021102259.324175287@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Imre Deak <imre.deak@intel.com>

commit 69b3d87212676c4c22aa4660435e2066dc7d1311 upstream.

The MST branch device may not support the number of DSC slices a mode
requires, handle the error in this case.

Fixes: 4e0837a8d00a ("drm/i915/dp_mst: Account for FEC and DSC overhead during BW allocation")
Cc: stable@vger.kernel.org # v6.8+
Reviewed-by: Suraj Kandpal <suraj.kandpal@intel.com>
Signed-off-by: Imre Deak <imre.deak@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241009110135.1216498-1-imre.deak@intel.com
(cherry picked from commit 802a69b6b8a0502a9e2309afec7e1b77f67874f2)
Signed-off-by: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_dp_mst.c |   37 ++++++++++++++++++++--------
 1 file changed, 27 insertions(+), 10 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_dp_mst.c
+++ b/drivers/gpu/drm/i915/display/intel_dp_mst.c
@@ -88,25 +88,19 @@ static int intel_dp_mst_max_dpt_bpp(cons
 
 static int intel_dp_mst_bw_overhead(const struct intel_crtc_state *crtc_state,
 				    const struct intel_connector *connector,
-				    bool ssc, bool dsc, int bpp_x16)
+				    bool ssc, int dsc_slice_count, int bpp_x16)
 {
 	const struct drm_display_mode *adjusted_mode =
 		&crtc_state->hw.adjusted_mode;
 	unsigned long flags = DRM_DP_BW_OVERHEAD_MST;
-	int dsc_slice_count = 0;
 	int overhead;
 
 	flags |= intel_dp_is_uhbr(crtc_state) ? DRM_DP_BW_OVERHEAD_UHBR : 0;
 	flags |= ssc ? DRM_DP_BW_OVERHEAD_SSC_REF_CLK : 0;
 	flags |= crtc_state->fec_enable ? DRM_DP_BW_OVERHEAD_FEC : 0;
 
-	if (dsc) {
+	if (dsc_slice_count)
 		flags |= DRM_DP_BW_OVERHEAD_DSC;
-		dsc_slice_count = intel_dp_dsc_get_slice_count(connector,
-							       adjusted_mode->clock,
-							       adjusted_mode->hdisplay,
-							       crtc_state->joiner_pipes);
-	}
 
 	overhead = drm_dp_bw_overhead(crtc_state->lane_count,
 				      adjusted_mode->hdisplay,
@@ -152,6 +146,19 @@ static int intel_dp_mst_calc_pbn(int pix
 	return DIV_ROUND_UP(effective_data_rate * 64, 54 * 1000);
 }
 
+static int intel_dp_mst_dsc_get_slice_count(const struct intel_connector *connector,
+					    const struct intel_crtc_state *crtc_state)
+{
+	const struct drm_display_mode *adjusted_mode =
+		&crtc_state->hw.adjusted_mode;
+	int num_joined_pipes = crtc_state->joiner_pipes;
+
+	return intel_dp_dsc_get_slice_count(connector,
+					    adjusted_mode->clock,
+					    adjusted_mode->hdisplay,
+					    num_joined_pipes);
+}
+
 static int intel_dp_mst_find_vcpi_slots_for_bpp(struct intel_encoder *encoder,
 						struct intel_crtc_state *crtc_state,
 						int max_bpp,
@@ -171,6 +178,7 @@ static int intel_dp_mst_find_vcpi_slots_
 	const struct drm_display_mode *adjusted_mode =
 		&crtc_state->hw.adjusted_mode;
 	int bpp, slots = -EINVAL;
+	int dsc_slice_count = 0;
 	int max_dpt_bpp;
 	int ret = 0;
 
@@ -202,6 +210,15 @@ static int intel_dp_mst_find_vcpi_slots_
 	drm_dbg_kms(&i915->drm, "Looking for slots in range min bpp %d max bpp %d\n",
 		    min_bpp, max_bpp);
 
+	if (dsc) {
+		dsc_slice_count = intel_dp_mst_dsc_get_slice_count(connector, crtc_state);
+		if (!dsc_slice_count) {
+			drm_dbg_kms(&i915->drm, "Can't get valid DSC slice count\n");
+
+			return -ENOSPC;
+		}
+	}
+
 	for (bpp = max_bpp; bpp >= min_bpp; bpp -= step) {
 		int local_bw_overhead;
 		int remote_bw_overhead;
@@ -215,9 +232,9 @@ static int intel_dp_mst_find_vcpi_slots_
 					  intel_dp_output_bpp(crtc_state->output_format, bpp));
 
 		local_bw_overhead = intel_dp_mst_bw_overhead(crtc_state, connector,
-							     false, dsc, link_bpp_x16);
+							     false, dsc_slice_count, link_bpp_x16);
 		remote_bw_overhead = intel_dp_mst_bw_overhead(crtc_state, connector,
-							      true, dsc, link_bpp_x16);
+							      true, dsc_slice_count, link_bpp_x16);
 
 		intel_dp_mst_compute_m_n(crtc_state, connector,
 					 local_bw_overhead,


