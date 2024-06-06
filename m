Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC22E196D8E;
	Thu,  6 Jun 2024 14:09:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682983; cv=none; b=iydxqtdrvToQxSkTCFo9A5cXRF1vzWjCq2gnE3cwRSgiLpU8fiDG2+GdF9ecq1BkQw8m3NvY04KeyewN3JWcGAoj/VhoA9a22A0WMrACE+NSgMZLazSTTdAVmxZXTTE358Oo1pUDEAeL+Aq81425ivCCdG0zzE26xw6dTrdK2w4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682983; c=relaxed/simple;
	bh=TfSpLpSC++aT0MV69eBPIRKn9HUV3JyiojgAO/VXVv8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fnzrq8F8BvgLRog5pDJ8s2TeVWFHOdgRhaJpKUuSleKyDbovYFZoaIbx956jVJNQC2tuvFzUJ5MEfyfno6IeRNJQrxDfWZWIz1k9rMG+ikayUzNswtBi2HcLLCC6Ld6VX/KqKyvOqfUc9IuGUSR62AzmQWNfDCikaan1T7ND3qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G8yoWxXF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G8yoWxXF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB105C32781;
	Thu,  6 Jun 2024 14:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682982;
	bh=TfSpLpSC++aT0MV69eBPIRKn9HUV3JyiojgAO/VXVv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G8yoWxXFM4TVTTufeAv96gNYJasEBKZV4g5CLPUYNV03nNH6iyvl7yelhmGq5ZBRL
	 HRj5b2/vyu2LhZfc/iTikha27Zr+8HXXu/BCKOQcpyGS/dGQpAfN5EVXB2p0ximPdp
	 aLlnF+5GqZN5PzT+o9Q6jhX8Y3usZfnr2Uf5K8MU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Belin <nbelin@baylibre.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 166/374] drm/meson: gate px_clk when setting rate
Date: Thu,  6 Jun 2024 16:02:25 +0200
Message-ID: <20240606131657.470868595@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Neil Armstrong <neil.armstrong@linaro.org>

[ Upstream commit 5c9837374ecf55a1fa3b7622d365a0456960270f ]

Disable the px_clk when setting the rate to recover a fully
configured and correctly reset VCLK clock tree after the rate
is set.

Fixes: 77d9e1e6b846 ("drm/meson: add support for MIPI-DSI transceiver")
Reviewed-by: Nicolas Belin <nbelin@baylibre.com>
Link: https://lore.kernel.org/r/20240403-amlogic-v6-4-upstream-dsi-ccf-vim3-v12-4-99ecdfdc87fc@linaro.org
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240403-amlogic-v6-4-upstream-dsi-ccf-vim3-v12-4-99ecdfdc87fc@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/meson/meson_dw_mipi_dsi.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/gpu/drm/meson/meson_dw_mipi_dsi.c b/drivers/gpu/drm/meson/meson_dw_mipi_dsi.c
index a6bc1bdb3d0d8..a10cff3ca1fef 100644
--- a/drivers/gpu/drm/meson/meson_dw_mipi_dsi.c
+++ b/drivers/gpu/drm/meson/meson_dw_mipi_dsi.c
@@ -95,6 +95,7 @@ static int dw_mipi_dsi_phy_init(void *priv_data)
 		return ret;
 	}
 
+	clk_disable_unprepare(mipi_dsi->px_clk);
 	ret = clk_set_rate(mipi_dsi->px_clk, mipi_dsi->mode->clock * 1000);
 
 	if (ret) {
@@ -103,6 +104,12 @@ static int dw_mipi_dsi_phy_init(void *priv_data)
 		return ret;
 	}
 
+	ret = clk_prepare_enable(mipi_dsi->px_clk);
+	if (ret) {
+		dev_err(mipi_dsi->dev, "Failed to enable DSI Pixel clock (ret %d)\n", ret);
+		return ret;
+	}
+
 	switch (mipi_dsi->dsi_device->format) {
 	case MIPI_DSI_FMT_RGB888:
 		dpi_data_format = DPI_COLOR_24BIT;
-- 
2.43.0



