Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 455EE347FCF;
	Tue, 16 Dec 2025 11:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885701; cv=none; b=PpfbKBNKOrslixSqXXuzSwe/OeC5lZaEjV9v5a0mvhDY0SD6BZqq91ALzAb/Qmjmw/i3ORLIuCkME+R8GpO6HuCK99vUQxgz2gV2AYtBjLFawyGgZCMwswQKjwok5ryqbEj95GkiGETGaLba61w7wSTbN9gHRmQHmRp099NvzFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885701; c=relaxed/simple;
	bh=d/mmYL8G972WuWNXwL+55mWCPb+Ul4L5AOWfmEGeuOE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DwNyB9evPdj9Yrvcj5FZcU4M5LTLFpZIkAAQJi26I2UGIMygZj0Bu+OdV+UrAGPf0FO1M7fO3DfLIuAkl4w38znkpBnNTk/IKHgnPtjGZsRAZg53xNTSJeEKtcFP1q/kvl7O0yC76T9fm+K16C8Z4stHjWo6i2vY6p/Os7Keq08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZOJwLiEM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZOJwLiEM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8910C4CEF1;
	Tue, 16 Dec 2025 11:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885701;
	bh=d/mmYL8G972WuWNXwL+55mWCPb+Ul4L5AOWfmEGeuOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZOJwLiEMuMQ3zNVfW+x9h7NWnkR0VJXwHkvmftBohBAgUOg/HHj8b39mukWDWyotK
	 s/dP2r22Ci0ZUynaQ0yWe/f5arle0kk5xaW0hk26fRw4sCLL4APYbDwFgVNeQm0P3M
	 Uzgrx6KTz308Fs9ETylbQhP1R+EYKQA7/I81oNQ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Walle <mwalle@kernel.org>,
	Devarsh Thakkar <devarsht@ti.com>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Jayesh Choudhary <j-choudhary@ti.com>,
	Swamil Jain <s-jain1@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 219/507] drm/tidss: Remove max_pclk_khz and min_pclk_khz from tidss display features
Date: Tue, 16 Dec 2025 12:11:00 +0100
Message-ID: <20251216111353.442218592@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jayesh Choudhary <j-choudhary@ti.com>

[ Upstream commit 527e132573dfa793818a536b18eec49598a6f6f5 ]

The TIDSS hardware does not have independent maximum or minimum pixel
clock limits for each video port. Instead, these limits are determined
by the SoC's clock architecture. Previously, this constraint was
modeled using the 'max_pclk_khz' and 'min_pclk_khz' fields in
'dispc_features', but this approach is static and does not account for
the dynamic behavior of PLLs.

This patch removes the 'max_pclk_khz' and 'min_pclk_khz' fields from
'dispc_features'. The correct way to check if a requested mode's pixel
clock is supported is by using 'clk_round_rate()' in the 'mode_valid()'
hook. If the best frequency match for the mode clock falls within the
supported tolerance, it is approved. TIDSS supports a 5% pixel clock
tolerance, which is now reflected in the validation logic.

This change allows existing DSS-compatible drivers to be reused across
SoCs that only differ in their pixel clock characteristics. The
validation uses 'clk_round_rate()' for each mode, which may introduce
additional delay (about 3.5 ms for 30 modes), but this is generally
negligible. Users desiring faster validation may bypass these calls
selectively, for example, checking only the highest resolution mode,
as shown here[1].

[1]: https://lore.kernel.org/all/20250704094851.182131-3-j-choudhary@ti.com/

Tested-by: Michael Walle <mwalle@kernel.org>
Reviewed-by: Devarsh Thakkar <devarsht@ti.com>
Reviewed-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Signed-off-by: Jayesh Choudhary <j-choudhary@ti.com>
Signed-off-by: Swamil Jain <s-jain1@ti.com>
Link: https://patch.msgid.link/20251104151422.307162-2-s-jain1@ti.com
[Tomi: dropped 'inline' from check_pixel_clock]
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Stable-dep-of: 86db652fc22f ("drm/tidss: Move OLDI mode validation to OLDI bridge mode_valid hook")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tidss/tidss_dispc.c | 86 +++++++++++------------------
 drivers/gpu/drm/tidss/tidss_dispc.h |  3 -
 2 files changed, 31 insertions(+), 58 deletions(-)

diff --git a/drivers/gpu/drm/tidss/tidss_dispc.c b/drivers/gpu/drm/tidss/tidss_dispc.c
index 3f6cff2ab1b29..85048ac44608a 100644
--- a/drivers/gpu/drm/tidss/tidss_dispc.c
+++ b/drivers/gpu/drm/tidss/tidss_dispc.c
@@ -56,12 +56,6 @@ static const u16 tidss_k2g_common_regs[DISPC_COMMON_REG_TABLE_LEN] = {
 };
 
 const struct dispc_features dispc_k2g_feats = {
-	.min_pclk_khz = 4375,
-
-	.max_pclk_khz = {
-		[DISPC_VP_DPI] = 150000,
-	},
-
 	/*
 	 * XXX According TRM the RGB input buffer width up to 2560 should
 	 *     work on 3 taps, but in practice it only works up to 1280.
@@ -144,11 +138,6 @@ static const u16 tidss_am65x_common_regs[DISPC_COMMON_REG_TABLE_LEN] = {
 };
 
 const struct dispc_features dispc_am65x_feats = {
-	.max_pclk_khz = {
-		[DISPC_VP_DPI] = 165000,
-		[DISPC_VP_OLDI_AM65X] = 165000,
-	},
-
 	.scaling = {
 		.in_width_max_5tap_rgb = 1280,
 		.in_width_max_3tap_rgb = 2560,
@@ -244,11 +233,6 @@ static const u16 tidss_j721e_common_regs[DISPC_COMMON_REG_TABLE_LEN] = {
 };
 
 const struct dispc_features dispc_j721e_feats = {
-	.max_pclk_khz = {
-		[DISPC_VP_DPI] = 170000,
-		[DISPC_VP_INTERNAL] = 600000,
-	},
-
 	.scaling = {
 		.in_width_max_5tap_rgb = 2048,
 		.in_width_max_3tap_rgb = 4096,
@@ -315,11 +299,6 @@ const struct dispc_features dispc_j721e_feats = {
 };
 
 const struct dispc_features dispc_am625_feats = {
-	.max_pclk_khz = {
-		[DISPC_VP_DPI] = 165000,
-		[DISPC_VP_INTERNAL] = 170000,
-	},
-
 	.scaling = {
 		.in_width_max_5tap_rgb = 1280,
 		.in_width_max_3tap_rgb = 2560,
@@ -376,15 +355,6 @@ const struct dispc_features dispc_am625_feats = {
 };
 
 const struct dispc_features dispc_am62a7_feats = {
-	/*
-	 * if the code reaches dispc_mode_valid with VP1,
-	 * it should return MODE_BAD.
-	 */
-	.max_pclk_khz = {
-		[DISPC_VP_TIED_OFF] = 0,
-		[DISPC_VP_DPI] = 165000,
-	},
-
 	.scaling = {
 		.in_width_max_5tap_rgb = 1280,
 		.in_width_max_3tap_rgb = 2560,
@@ -441,10 +411,6 @@ const struct dispc_features dispc_am62a7_feats = {
 };
 
 const struct dispc_features dispc_am62l_feats = {
-	.max_pclk_khz = {
-		[DISPC_VP_DPI] = 165000,
-	},
-
 	.subrev = DISPC_AM62L,
 
 	.common = "common",
@@ -1347,33 +1313,54 @@ static void dispc_vp_set_default_color(struct dispc_device *dispc,
 			DISPC_OVR_DEFAULT_COLOR2, (v >> 32) & 0xffff);
 }
 
+/*
+ * Calculate the percentage difference between the requested pixel clock rate
+ * and the effective rate resulting from calculating the clock divider value.
+ */
+unsigned int dispc_pclk_diff(unsigned long rate, unsigned long real_rate)
+{
+	int r = rate / 100, rr = real_rate / 100;
+
+	return (unsigned int)(abs(((rr - r) * 100) / r));
+}
+
+static int check_pixel_clock(struct dispc_device *dispc, u32 hw_videoport,
+			     unsigned long clock)
+{
+	unsigned long round_clock;
+
+	round_clock = clk_round_rate(dispc->vp_clk[hw_videoport], clock);
+	/*
+	 * To keep the check consistent with dispc_vp_set_clk_rate(), we
+	 * use the same 5% check here.
+	 */
+	if (dispc_pclk_diff(clock, round_clock) > 5)
+		return -EINVAL;
+
+	return 0;
+}
+
 enum drm_mode_status dispc_vp_mode_valid(struct dispc_device *dispc,
 					 u32 hw_videoport,
 					 const struct drm_display_mode *mode)
 {
 	u32 hsw, hfp, hbp, vsw, vfp, vbp;
 	enum dispc_vp_bus_type bus_type;
-	int max_pclk;
 
 	bus_type = dispc->feat->vp_bus_type[hw_videoport];
 
-	max_pclk = dispc->feat->max_pclk_khz[bus_type];
-
-	if (WARN_ON(max_pclk == 0))
+	if (WARN_ON(bus_type == DISPC_VP_TIED_OFF))
 		return MODE_BAD;
 
-	if (mode->clock < dispc->feat->min_pclk_khz)
-		return MODE_CLOCK_LOW;
-
-	if (mode->clock > max_pclk)
-		return MODE_CLOCK_HIGH;
-
 	if (mode->hdisplay > 4096)
 		return MODE_BAD;
 
 	if (mode->vdisplay > 4096)
 		return MODE_BAD;
 
+	if (check_pixel_clock(dispc, hw_videoport, mode->clock * 1000))
+		return MODE_CLOCK_RANGE;
+
 	/* TODO: add interlace support */
 	if (mode->flags & DRM_MODE_FLAG_INTERLACE)
 		return MODE_NO_INTERLACE;
@@ -1437,17 +1424,6 @@ void dispc_vp_disable_clk(struct dispc_device *dispc, u32 hw_videoport)
 	clk_disable_unprepare(dispc->vp_clk[hw_videoport]);
 }
 
-/*
- * Calculate the percentage difference between the requested pixel clock rate
- * and the effective rate resulting from calculating the clock divider value.
- */
-unsigned int dispc_pclk_diff(unsigned long rate, unsigned long real_rate)
-{
-	int r = rate / 100, rr = real_rate / 100;
-
-	return (unsigned int)(abs(((rr - r) * 100) / r));
-}
-
 int dispc_vp_set_clk_rate(struct dispc_device *dispc, u32 hw_videoport,
 			  unsigned long rate)
 {
diff --git a/drivers/gpu/drm/tidss/tidss_dispc.h b/drivers/gpu/drm/tidss/tidss_dispc.h
index b8614f62186ce..3979aed6413ba 100644
--- a/drivers/gpu/drm/tidss/tidss_dispc.h
+++ b/drivers/gpu/drm/tidss/tidss_dispc.h
@@ -74,9 +74,6 @@ enum dispc_dss_subrevision {
 };
 
 struct dispc_features {
-	int min_pclk_khz;
-	int max_pclk_khz[DISPC_VP_MAX_BUS_TYPE];
-
 	struct dispc_features_scaling scaling;
 
 	enum dispc_dss_subrevision subrev;
-- 
2.51.0



