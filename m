Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77B6C55762;
	Thu, 30 Nov 2023 16:32:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IFbwHgyb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3F96C433C8;
	Thu, 30 Nov 2023 16:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701361936;
	bh=N7JAx6i0yauVK+9SQ/NjITlUc5ErfgirHep5xDrfxfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IFbwHgybtvD4jJlUs54POSNCzOIBToTsh//pA6EjT3pFds0Sq+ydsX9xI0Si+qU77
	 YE7p5FWheYnlmvvvH5M8nyP5v7NfgoDa+XhiLGFxGzliWDfuofrAbJf9mKWJoT7zHa
	 7mSDqB0cmf4VaR2QbhB0LMdUsWl8FMqfJRm1hNnw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuijing Li <shuijing.li@mediatek.com>,
	Xinlei Lee <xinlei.lee@mediatek.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 03/69] drm/panel: boe-tv101wum-nl6: Fine tune the panel power sequence
Date: Thu, 30 Nov 2023 16:22:00 +0000
Message-ID: <20231130162133.159160028@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231130162133.035359406@linuxfoundation.org>
References: <20231130162133.035359406@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuijing Li <shuijing.li@mediatek.com>

[ Upstream commit 812562b8d881ce6d33fed8052b3a10b718430fb5 ]

For "boe,tv105wum-nw0" this special panel, it is stipulated in
the panel spec that MIPI needs to keep the LP11 state before
the lcm_reset pin is pulled high.

Signed-off-by: Shuijing Li <shuijing.li@mediatek.com>
Signed-off-by: Xinlei Lee <xinlei.lee@mediatek.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20230515094955.15982-3-shuijing.li@mediatek.com
Stable-dep-of: 6965809e5269 ("drm/panel: auo,b101uan08.3: Fine tune the panel power sequence")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-boe-tv101wum-nl6.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/panel/panel-boe-tv101wum-nl6.c b/drivers/gpu/drm/panel/panel-boe-tv101wum-nl6.c
index db9d0b86d5428..3229e5eabbd21 100644
--- a/drivers/gpu/drm/panel/panel-boe-tv101wum-nl6.c
+++ b/drivers/gpu/drm/panel/panel-boe-tv101wum-nl6.c
@@ -36,6 +36,7 @@ struct panel_desc {
 	const struct panel_init_cmd *init_cmds;
 	unsigned int lanes;
 	bool discharge_on_disable;
+	bool lp11_before_reset;
 };
 
 struct boe_panel {
@@ -551,6 +552,10 @@ static int boe_panel_prepare(struct drm_panel *panel)
 
 	usleep_range(5000, 10000);
 
+	if (boe->desc->lp11_before_reset) {
+		mipi_dsi_dcs_nop(boe->dsi);
+		usleep_range(1000, 2000);
+	}
 	gpiod_set_value(boe->enable_gpio, 1);
 	usleep_range(1000, 2000);
 	gpiod_set_value(boe->enable_gpio, 0);
@@ -719,6 +724,7 @@ static const struct panel_desc boe_tv105wum_nw0_desc = {
 	.mode_flags = MIPI_DSI_MODE_VIDEO | MIPI_DSI_MODE_VIDEO_SYNC_PULSE |
 		      MIPI_DSI_MODE_LPM,
 	.init_cmds = boe_init_cmd,
+	.lp11_before_reset = true,
 };
 
 static int boe_panel_get_modes(struct drm_panel *panel,
-- 
2.42.0



