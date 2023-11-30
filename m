Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51B9E54F87;
	Thu, 30 Nov 2023 16:28:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1rU8fyZ8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3AB1C433C8;
	Thu, 30 Nov 2023 16:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701361721;
	bh=HZnNybWZboq8ui578CNlEkl8PGyewW2wWggpmUXsfgc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1rU8fyZ8ha/4dUWqVQNpojrC3+dcPnVClggIcMj7059sC2pMGfugTaA8qziMQFhWh
	 lpjJT0rfDCZN+6eJ5xTdPpZD5Xf9yl13e8KyZ1J4stl5hFzSoreKe8TCyLRMbvbfMi
	 uYYMX4QFr6tBdcKsE/HqsH0lR55anvJtlFGvFwk4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuijing Li <shuijing.li@mediatek.com>,
	Xinlei Lee <xinlei.lee@mediatek.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 03/82] drm/panel: boe-tv101wum-nl6: Fine tune the panel power sequence
Date: Thu, 30 Nov 2023 16:21:34 +0000
Message-ID: <20231130162136.088364988@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231130162135.977485944@linuxfoundation.org>
References: <20231130162135.977485944@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index c924f1124ebca..733e28a2536a4 100644
--- a/drivers/gpu/drm/panel/panel-boe-tv101wum-nl6.c
+++ b/drivers/gpu/drm/panel/panel-boe-tv101wum-nl6.c
@@ -36,6 +36,7 @@ struct panel_desc {
 	const struct panel_init_cmd *init_cmds;
 	unsigned int lanes;
 	bool discharge_on_disable;
+	bool lp11_before_reset;
 };
 
 struct boe_panel {
@@ -1269,6 +1270,10 @@ static int boe_panel_prepare(struct drm_panel *panel)
 
 	usleep_range(10000, 11000);
 
+	if (boe->desc->lp11_before_reset) {
+		mipi_dsi_dcs_nop(boe->dsi);
+		usleep_range(1000, 2000);
+	}
 	gpiod_set_value(boe->enable_gpio, 1);
 	usleep_range(1000, 2000);
 	gpiod_set_value(boe->enable_gpio, 0);
@@ -1495,6 +1500,7 @@ static const struct panel_desc boe_tv105wum_nw0_desc = {
 	.mode_flags = MIPI_DSI_MODE_VIDEO | MIPI_DSI_MODE_VIDEO_SYNC_PULSE |
 		      MIPI_DSI_MODE_LPM,
 	.init_cmds = boe_init_cmd,
+	.lp11_before_reset = true,
 };
 
 static int boe_panel_get_modes(struct drm_panel *panel,
-- 
2.42.0



