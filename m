Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A4112E717D;
	Tue,  8 Jul 2025 16:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993987; cv=none; b=ZaHl/YSqdWoOvUXslNUsv6/ExoASWopwBsU56Bc4TeNtqdXh1zXYLYHuWJ7SDx8AuWgvupx2VGpe6JG7TKBOkv1cXmiXpN4hcnCBmrjwdpj9ZrGshvSvzPbo+JFiAiTmIJyHKY+D41eeekKUoEb/UFA76Yrt3por3eOe+IG0QVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993987; c=relaxed/simple;
	bh=c65BjlxBNW3pUYdFx5xyfhdFkiUHkK3MFflOq0oTRD4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eghf+i5/OeeOAqEr31erOGheejCLmgtYNLtoZdfH4wg5HpxotcdyNZtmT3rHUnR67oXfS2un78QyLcmZaUz30xM/CVurEHPVM3bBf264/8EDoG10gg3vbI28JHlfKsekZK8Ktr1UrbcCXTJRc1gLKliNIRkg9Lwx26U0Sm6pfPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PvmJ5TMs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PvmJ5TMs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B6EDC4CEED;
	Tue,  8 Jul 2025 16:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993986;
	bh=c65BjlxBNW3pUYdFx5xyfhdFkiUHkK3MFflOq0oTRD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PvmJ5TMska0hdWczdurtNR64J42PMIEXXuvbPrOFkFgAuvVgxi/ajvSyxmxFiT62j
	 /7svoEVyGN8O5o1NqtD89ud1s0KN9qy+UQRwuTOuRrY1bTw/oqw6aruUtdimSExFaX
	 g/sJn3MIoYLHOegsi9dfieh8T/7gkfBQ4LKESLJU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dominik Haller <d.haller@phytec.de>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Aradhya Bhatia <a-bhatia1@ti.com>,
	Aradhya Bhatia <aradhya.bhatia@linux.dev>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Subject: [PATCH 5.15 087/160] drm/bridge: cdns-dsi: Wait for Clk and Data Lanes to be ready
Date: Tue,  8 Jul 2025 18:22:04 +0200
Message-ID: <20250708162233.929413249@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162231.503362020@linuxfoundation.org>
References: <20250708162231.503362020@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aradhya Bhatia <a-bhatia1@ti.com>

commit 47c03e6660e96cbba0239125b1d4a9db3c724b1d upstream.

Once the DSI Link and DSI Phy are initialized, the code needs to wait
for Clk and Data Lanes to be ready, before continuing configuration.
This is in accordance with the DSI Start-up procedure, found in the
Technical Reference Manual of Texas Instrument's J721E SoC[0] which
houses this DSI TX controller.

If the previous bridge (or crtc/encoder) are configured pre-maturely,
the input signal FIFO gets corrupt. This introduces a color-shift on the
display.

Allow the driver to wait for the clk and data lanes to get ready during
DSI enable.

[0]: See section 12.6.5.7.3 "Start-up Procedure" in J721E SoC TRM
     TRM Link: http://www.ti.com/lit/pdf/spruil1

Fixes: e19233955d9e ("drm/bridge: Add Cadence DSI driver")
Cc: stable@vger.kernel.org
Tested-by: Dominik Haller <d.haller@phytec.de>
Reviewed-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Tested-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Signed-off-by: Aradhya Bhatia <a-bhatia1@ti.com>
Signed-off-by: Aradhya Bhatia <aradhya.bhatia@linux.dev>
Link: https://lore.kernel.org/r/20250329113925.68204-6-aradhya.bhatia@linux.dev
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/bridge/cdns-dsi.c |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/bridge/cdns-dsi.c
+++ b/drivers/gpu/drm/bridge/cdns-dsi.c
@@ -789,8 +789,9 @@ static void cdns_dsi_bridge_enable(struc
 	struct phy_configure_opts_mipi_dphy *phy_cfg = &output->phy_opts.mipi_dphy;
 	unsigned long tx_byte_period;
 	struct cdns_dsi_cfg dsi_cfg;
-	u32 tmp, reg_wakeup, div;
+	u32 tmp, reg_wakeup, div, status;
 	int nlanes;
+	int i;
 
 	if (WARN_ON(pm_runtime_get_sync(dsi->base.dev) < 0))
 		return;
@@ -803,6 +804,19 @@ static void cdns_dsi_bridge_enable(struc
 	cdns_dsi_hs_init(dsi);
 	cdns_dsi_init_link(dsi);
 
+	/*
+	 * Now that the DSI Link and DSI Phy are initialized,
+	 * wait for the CLK and Data Lanes to be ready.
+	 */
+	tmp = CLK_LANE_RDY;
+	for (i = 0; i < nlanes; i++)
+		tmp |= DATA_LANE_RDY(i);
+
+	if (readl_poll_timeout(dsi->regs + MCTL_MAIN_STS, status,
+			       (tmp == (status & tmp)), 100, 500000))
+		dev_err(dsi->base.dev,
+			"Timed Out: DSI-DPhy Clock and Data Lanes not ready.\n");
+
 	writel(HBP_LEN(dsi_cfg.hbp) | HSA_LEN(dsi_cfg.hsa),
 	       dsi->regs + VID_HSIZE1);
 	writel(HFP_LEN(dsi_cfg.hfp) | HACT_LEN(dsi_cfg.hact),


