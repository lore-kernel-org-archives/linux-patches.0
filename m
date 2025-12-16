Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0FAA349B02;
	Tue, 16 Dec 2025 11:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885704; cv=none; b=q13iY5tMh+nBywUoaE+iRW8Ueowmt8IN66+rlh0p+Vyni/DCJh5l11WcX/KSNfYsbcPQ+TyzUwNktlsqvQ/juO4R/G++CP+Em14riCmfpn5OYjGzVlfN17enZlQbZl7IrQbprXG94TC8//j8Nh7LMPecllRM7sB3HPO5ZMPQX2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885704; c=relaxed/simple;
	bh=7zQg8F1K1+irZJT/5QQNK5v+RHdlXidMaPneXRkjWoA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HZh+iMm4CJYlCO33v3AEsj28gZkx4196w3kY3JdYeS9hi0zTYEBFTjjbnoDggGq1hdd4lHLAcTYVDxwf/rmb9lALUPZadlsqnYjogc1Y0tijPWOPdn+k+nycJbcW87/0ZaAogjR/5v3ZtoDcwr1VVA97nv1ASyjq8Hxj7M2qssk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pyljuL99; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pyljuL99"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10705C4CEF1;
	Tue, 16 Dec 2025 11:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885704;
	bh=7zQg8F1K1+irZJT/5QQNK5v+RHdlXidMaPneXRkjWoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pyljuL99jUGLnDFZI+JzZmUwOqC3q21T9FnHsAnuWZF/bsFB2NuAH7xNDE/vwlrFc
	 UutH/Vs4utwO+XdpAOgCOCLS1Q8/3PpfpNyGn9aACYG9qr2hCQSX4bbNgtn49S2xFI
	 bnO5yg0sAp2Iuk1gPaC/Eqkgheq/qduRB+xWo6F4=
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
Subject: [PATCH 6.17 220/507] drm/tidss: Move OLDI mode validation to OLDI bridge mode_valid hook
Date: Tue, 16 Dec 2025 12:11:01 +0100
Message-ID: <20251216111353.477439952@linuxfoundation.org>
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

[ Upstream commit 86db652fc22f5674ffe3b1f7c91c397c69d26d94 ]

After integrating OLDI support[0], it is necessary to identify which VP
instances use OLDI, since the OLDI driver owns the video port clock
(as a serial clock). Clock operations on these VPs must be delegated to
the OLDI driver, not handled by the TIDSS driver. This issue also
emerged in upstream discussions when DSI-related clock management was
attempted in the TIDSS driver[1].

To address this, add an 'is_ext_vp_clk' array to the 'tidss_device'
structure, marking a VP as 'true' during 'tidss_oldi_init()' and as
'false' during 'tidss_oldi_deinit()'. TIDSS then uses 'is_ext_vp_clk'
to skip clock validation checks in 'dispc_vp_mode_valid()' for VPs
under OLDI control.

Since OLDI uses the DSS VP clock directly as a serial interface and
manages its own rate, mode validation should be implemented in the OLDI
bridge's 'mode_valid' hook. This patch adds that logic, ensuring proper
delegation and avoiding spurious clock handling in the TIDSS driver.

[0]: https://lore.kernel.org/all/20250528122544.817829-1-aradhya.bhatia@linux.dev/
[1]: https://lore.kernel.org/all/DA6TT575Z82D.3MPK8HG5GRL8U@kernel.org/

Fixes: 7246e0929945 ("drm/tidss: Add OLDI bridge support")
Tested-by: Michael Walle <mwalle@kernel.org>
Reviewed-by: Devarsh Thakkar <devarsht@ti.com>
Reviewed-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Signed-off-by: Jayesh Choudhary <j-choudhary@ti.com>
Signed-off-by: Swamil Jain <s-jain1@ti.com>
Link: https://patch.msgid.link/20251104151422.307162-3-s-jain1@ti.com
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Link: https://patch.msgid.link/ffd5ebe03391b3c01e616c0c844a4b8ddecede36.1762513240.git.jani.nikula@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tidss/tidss_dispc.c |  7 +++++++
 drivers/gpu/drm/tidss/tidss_drv.h   |  2 ++
 drivers/gpu/drm/tidss/tidss_oldi.c  | 22 ++++++++++++++++++++++
 3 files changed, 31 insertions(+)

diff --git a/drivers/gpu/drm/tidss/tidss_dispc.c b/drivers/gpu/drm/tidss/tidss_dispc.c
index 85048ac44608a..50ccf48ed492c 100644
--- a/drivers/gpu/drm/tidss/tidss_dispc.c
+++ b/drivers/gpu/drm/tidss/tidss_dispc.c
@@ -1329,6 +1329,13 @@ static int check_pixel_clock(struct dispc_device *dispc, u32 hw_videoport,
 {
 	unsigned long round_clock;
 
+	/*
+	 * For VP's with external clocking, clock operations must be
+	 * delegated to respective driver, so we skip the check here.
+	 */
+	if (dispc->tidss->is_ext_vp_clk[hw_videoport])
+		return 0;
+
 	round_clock = clk_round_rate(dispc->vp_clk[hw_videoport], clock);
 	/*
 	 * To keep the check consistent with dispc_vp_set_clk_rate(), we
diff --git a/drivers/gpu/drm/tidss/tidss_drv.h b/drivers/gpu/drm/tidss/tidss_drv.h
index d14d5d28f0a33..4e38cfa99e840 100644
--- a/drivers/gpu/drm/tidss/tidss_drv.h
+++ b/drivers/gpu/drm/tidss/tidss_drv.h
@@ -22,6 +22,8 @@ struct tidss_device {
 
 	const struct dispc_features *feat;
 	struct dispc_device *dispc;
+	bool is_ext_vp_clk[TIDSS_MAX_PORTS];
+
 
 	unsigned int num_crtcs;
 	struct drm_crtc *crtcs[TIDSS_MAX_PORTS];
diff --git a/drivers/gpu/drm/tidss/tidss_oldi.c b/drivers/gpu/drm/tidss/tidss_oldi.c
index 8f25159d0666a..d24b1e3cdce01 100644
--- a/drivers/gpu/drm/tidss/tidss_oldi.c
+++ b/drivers/gpu/drm/tidss/tidss_oldi.c
@@ -309,6 +309,25 @@ static u32 *tidss_oldi_atomic_get_input_bus_fmts(struct drm_bridge *bridge,
 	return input_fmts;
 }
 
+static enum drm_mode_status
+tidss_oldi_mode_valid(struct drm_bridge *bridge,
+		      const struct drm_display_info *info,
+		      const struct drm_display_mode *mode)
+{
+	struct tidss_oldi *oldi = drm_bridge_to_tidss_oldi(bridge);
+	unsigned long round_clock;
+
+	round_clock = clk_round_rate(oldi->serial, mode->clock * 7 * 1000);
+	/*
+	 * To keep the check consistent with dispc_vp_set_clk_rate(),
+	 * we use the same 5% check here.
+	 */
+	if (dispc_pclk_diff(mode->clock * 7 * 1000, round_clock) > 5)
+		return -EINVAL;
+
+	return 0;
+}
+
 static const struct drm_bridge_funcs tidss_oldi_bridge_funcs = {
 	.attach	= tidss_oldi_bridge_attach,
 	.atomic_pre_enable = tidss_oldi_atomic_pre_enable,
@@ -317,6 +336,7 @@ static const struct drm_bridge_funcs tidss_oldi_bridge_funcs = {
 	.atomic_duplicate_state = drm_atomic_helper_bridge_duplicate_state,
 	.atomic_destroy_state = drm_atomic_helper_bridge_destroy_state,
 	.atomic_reset = drm_atomic_helper_bridge_reset,
+	.mode_valid = tidss_oldi_mode_valid,
 };
 
 static int get_oldi_mode(struct device_node *oldi_tx, int *companion_instance)
@@ -430,6 +450,7 @@ void tidss_oldi_deinit(struct tidss_device *tidss)
 	for (int i = 0; i < tidss->num_oldis; i++) {
 		if (tidss->oldis[i]) {
 			drm_bridge_remove(&tidss->oldis[i]->bridge);
+			tidss->is_ext_vp_clk[tidss->oldis[i]->parent_vp] = false;
 			tidss->oldis[i] = NULL;
 		}
 	}
@@ -581,6 +602,7 @@ int tidss_oldi_init(struct tidss_device *tidss)
 		oldi->bridge.timings = &default_tidss_oldi_timings;
 
 		tidss->oldis[tidss->num_oldis++] = oldi;
+		tidss->is_ext_vp_clk[oldi->parent_vp] = true;
 		oldi->tidss = tidss;
 
 		drm_bridge_add(&oldi->bridge);
-- 
2.51.0



