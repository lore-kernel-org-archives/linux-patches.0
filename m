Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46EC71991D3;
	Thu,  6 Jun 2024 14:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683677; cv=none; b=WdnQoU1cwh5ldrRJDy6rSlW/KnMvKj1Cmrp4Xty8b3nc1IGDkE9bHsa2fFyjsAWfPX7SOs2Dbyg0moSRIrDwMGDEEbDY/wGMsAjtW+N/QqKKlMgsDqx/3OlB8F8ObgfMSaisrD5GFGllT7QoIbPmKoWSRH8fnh86hQmcDHMaw20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683677; c=relaxed/simple;
	bh=un5pqYhvZ7UDRIydyq57Yh68vrxnrZie5J/DAN5k0i8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tHt0AlkpKuLcrQTlR7Tdso6mbGf8iTUi4akhsLHsylJmNPBQgYUQsHYBWSk03Z64sL/b4mE5gevlwgTnfBlVjZNiMX9pZY3saqDHU9eOEEuZrjGGXH7j2JGG1C/EqepWJIg3PoPRiEDGlMlCK1dmg0hc4yFxfmW4E0/aiVZc+xc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HZg5gghp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HZg5gghp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 281EFC2BD10;
	Thu,  6 Jun 2024 14:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683677;
	bh=un5pqYhvZ7UDRIydyq57Yh68vrxnrZie5J/DAN5k0i8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HZg5gghpbc7INmpu05dPk810+hO5o+tB5MCV8wRxfza4Nh4eWvcVq5hbvMllj9pHH
	 qVf3ytShsgVvr0Cuh5ZLGHDpN6JWjMbYiGEk522YeyT69bB1kbTlsE+HGOZ3/cWYvK
	 ZPZR1g+k9kApoDBy04w/n2Sdq4fQ8B7ORw7Gf074=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolas Belin <nbelin@baylibre.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 575/744] drm/meson: gate px_clk when setting rate
Date: Thu,  6 Jun 2024 16:04:07 +0200
Message-ID: <20240606131750.903596699@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index e5fe4e994f43b..72abe2057ec31 100644
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



