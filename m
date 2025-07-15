Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF9392EB5BB;
	Tue, 15 Jul 2025 13:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587592; cv=none; b=AdrGSCzZZHOGX0XogKcD4Zo8a9U8MdF5an7FJ8lcWtkkXHVP7aaX/6peZdgh8M4IScXiJ2lLnfL4Ss1ImprzlxZ/psROvmc8m+JlBwckF1HdkCLFi50O+Q4MVuj/9UCNPdVC1p6i1Ou4MgdT64Pf4qomqELjoY9vOjYCq/h3HGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587592; c=relaxed/simple;
	bh=fjH4yyKp0QdvNe95iT4SW2VFUkaa7bZh9ovTYi1qpoo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sBdnHAKSYNzJc6im3dlVGxND18xu+Znq3x0F+Ymbqx0594XKMhF8iiEVAFbS4XkiO21/GLCyR+iF8KlTKrkKiYnGSBDfGJevJHORwZS6EINk8lYg3M8WiHCkxvCw7awBdxGvPq9ujJIYxsKc7c3nEaml+ANGd2LzSGDf4u48670=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mv7gCRBb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mv7gCRBb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EE10C4CEE3;
	Tue, 15 Jul 2025 13:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587591;
	bh=fjH4yyKp0QdvNe95iT4SW2VFUkaa7bZh9ovTYi1qpoo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mv7gCRBb0tE5dMxSCpqiXHhAJ/T5rpkikPnAYcz3IF4g8WG9PpGoXa4UT1cO9q0cW
	 RZpR12o/kMG0CIT0QnxgJgW0ayanFJ2O1ocYVKucm28i256Z+KRW6I1ixUN1lIEi9z
	 VClY+BvNAYjYFD4N+Jf8znBQ8B+XXDKjwPW9TC24=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dominik Haller <d.haller@phytec.de>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Aradhya Bhatia <a-bhatia1@ti.com>,
	Aradhya Bhatia <aradhya.bhatia@linux.dev>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Subject: [PATCH 5.10 070/208] drm/bridge: cdns-dsi: Wait for Clk and Data Lanes to be ready
Date: Tue, 15 Jul 2025 15:12:59 +0200
Message-ID: <20250715130813.755900065@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130810.830580412@linuxfoundation.org>
References: <20250715130810.830580412@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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


