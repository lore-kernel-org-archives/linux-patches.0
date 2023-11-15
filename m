Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C20B718C27
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wz74usg6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70AF9C4E779;
	Wed, 15 Nov 2023 20:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700081704;
	bh=Py0OSIczWiinkROuzJs26yhbf7RbCp46Cpbojrj+8cg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wz74usg6fQF/26ee7v3MXiZfEDX+AdzS/ppscEvjXHNJhKjoYTS7B4pPZZV5bzOH4
	 2fyR+31Dd7rLEUVy25U7MmcnoM78ZeU7HB+j1hFA60W6qgN7MRM3uIt8A5n6BAqNuv
	 1/WoZLBKtfK0NStFVzarG2Rpk9ITcWoOrT0ls7cI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Osipenko <digetx@gmail.com>,
	Robert Foss <robert.foss@linaro.org>,
	Sasha Levin <sashal@kernel.org>,
	Andreas Westman Dorcsak <hedmoo@yahoo.com>,
	Maxim Schwalm <maxim.schwalm@gmail.com>
Subject: [PATCH 5.10 073/191] drm/bridge: tc358768: Disable non-continuous clock mode
Date: Wed, 15 Nov 2023 15:45:48 -0500
Message-ID: <20231115204648.979911143@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115204644.490636297@linuxfoundation.org>
References: <20231115204644.490636297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Osipenko <digetx@gmail.com>

[ Upstream commit fbc5a90e82c1131869e76ce5b082693b8a75c121 ]

Non-continuous clock mode doesn't work because driver doesn't support it
properly. The bridge driver programs wrong bitfields that are required by
the non-continuous mode (BTACNTRL1 register bitfields are swapped in the
code), but fixing them doesn't help.

Display panel of ASUS Transformer TF700T tablet supports non-continuous
mode and display doesn't work at all using that mode. There are no
device-trees that are actively using this DSI bridge in upstream yet,
so clearly the broken mode wasn't ever tested properly. It's a bit too
difficult to get LP mode working, hence let's disable the offending mode
for now and fall back to continuous mode.

Tested-by: Andreas Westman Dorcsak <hedmoo@yahoo.com> # Asus TF700T
Tested-by: Maxim Schwalm <maxim.schwalm@gmail.com> #TF700T
Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
Reviewed-by: Robert Foss <robert.foss@linaro.org>
Signed-off-by: Robert Foss <robert.foss@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20211002233447.1105-5-digetx@gmail.com
Stable-dep-of: 66962d5c3c51 ("drm/bridge: tc358768: Fix bit updates")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/tc358768.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/bridge/tc358768.c b/drivers/gpu/drm/bridge/tc358768.c
index a5e7afa5e6275..8f7460f011aea 100644
--- a/drivers/gpu/drm/bridge/tc358768.c
+++ b/drivers/gpu/drm/bridge/tc358768.c
@@ -637,6 +637,7 @@ static void tc358768_bridge_pre_enable(struct drm_bridge *bridge)
 {
 	struct tc358768_priv *priv = bridge_to_tc358768(bridge);
 	struct mipi_dsi_device *dsi_dev = priv->output.dev;
+	unsigned long mode_flags = dsi_dev->mode_flags;
 	u32 val, val2, lptxcnt, hact, data_type;
 	s32 raw_val;
 	const struct drm_display_mode *mode;
@@ -644,6 +645,11 @@ static void tc358768_bridge_pre_enable(struct drm_bridge *bridge)
 	u32 dsiclk, dsibclk;
 	int ret, i;
 
+	if (mode_flags & MIPI_DSI_CLOCK_NON_CONTINUOUS) {
+		dev_warn_once(priv->dev, "Non-continuous mode unimplemented, falling back to continuous\n");
+		mode_flags &= ~MIPI_DSI_CLOCK_NON_CONTINUOUS;
+	}
+
 	tc358768_hw_enable(priv);
 
 	ret = tc358768_sw_reset(priv);
@@ -779,7 +785,7 @@ static void tc358768_bridge_pre_enable(struct drm_bridge *bridge)
 		val |= BIT(i + 1);
 	tc358768_write(priv, TC358768_HSTXVREGEN, val);
 
-	if (!(dsi_dev->mode_flags & MIPI_DSI_CLOCK_NON_CONTINUOUS))
+	if (!(mode_flags & MIPI_DSI_CLOCK_NON_CONTINUOUS))
 		tc358768_write(priv, TC358768_TXOPTIONCNTRL, 0x1);
 
 	/* TXTAGOCNT[26:16] RXTASURECNT[10:0] */
@@ -836,7 +842,7 @@ static void tc358768_bridge_pre_enable(struct drm_bridge *bridge)
 
 	val |= TC358768_DSI_CONTROL_TXMD;
 
-	if (!(dsi_dev->mode_flags & MIPI_DSI_CLOCK_NON_CONTINUOUS))
+	if (!(mode_flags & MIPI_DSI_CLOCK_NON_CONTINUOUS))
 		val |= TC358768_DSI_CONTROL_HSCKMD;
 
 	if (dsi_dev->mode_flags & MIPI_DSI_MODE_EOT_PACKET)
-- 
2.42.0



