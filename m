Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8AF3522E
	for <patches@lists.linux.dev>; Sun,  9 Jul 2023 11:28:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66CE7C433C7;
	Sun,  9 Jul 2023 11:28:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688902117;
	bh=3Vs9vC1eq+5bYJrCFzoFOmD29/h8CB7Nr4yaYfMXMgM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QtPMHdvOc4njZ1Z9Q5v/OqTtCj57xeY510gqw/c/YTnNwvLGJ35q5REUuafT6ZmK/
	 KvpFJ/6daAYsO2CVWjdH0q+I5nJPLcgBDfVwot9UvSnDw1WLlncxrAEQFwL4VA9AFk
	 Y/rZZE2h5raOl2C4j7LWsAuTF9Cc8bYBXqfqq59U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frieder Schrempf <frieder.schrempf@kontron.de>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>,
	Alexander Stein <alexander.stein@ew.tq-group.com>
Subject: [PATCH 6.3 244/431] drm/bridge: ti-sn65dsi83: Fix enable/disable flow to meet spec
Date: Sun,  9 Jul 2023 13:13:12 +0200
Message-ID: <20230709111456.876096502@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230709111451.101012554@linuxfoundation.org>
References: <20230709111451.101012554@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Frieder Schrempf <frieder.schrempf@kontron.de>

[ Upstream commit dd9e329af7236e34c566d3705ea32a63069b9b13 ]

The datasheet describes the following initialization flow including
minimum delay times between each step:

1. DSI data lanes need to be in LP-11 and the clock lane in HS mode
2. toggle EN signal
3. initialize registers
4. enable PLL
5. soft reset
6. enable DSI stream
7. check error status register

To meet this requirement we need to make sure the host bridge's
pre_enable() is called first by using the pre_enable_prev_first
flag.

Furthermore we need to split enable() into pre_enable() which covers
steps 2-5 from above and enable() which covers step 7 and is called
after the host bridge's enable().

Signed-off-by: Frieder Schrempf <frieder.schrempf@kontron.de>
Fixes: ceb515ba29ba ("drm/bridge: ti-sn65dsi83: Add TI SN65DSI83 and SN65DSI84 driver")
Tested-by: Alexander Stein <alexander.stein@ew.tq-group.com> #TQMa8MxML/MBa8Mx
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20230503163313.2640898-3-frieder@fris.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/ti-sn65dsi83.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/bridge/ti-sn65dsi83.c b/drivers/gpu/drm/bridge/ti-sn65dsi83.c
index a6534011c9214..e4ee2904d0893 100644
--- a/drivers/gpu/drm/bridge/ti-sn65dsi83.c
+++ b/drivers/gpu/drm/bridge/ti-sn65dsi83.c
@@ -321,8 +321,8 @@ static u8 sn65dsi83_get_dsi_div(struct sn65dsi83 *ctx)
 	return dsi_div - 1;
 }
 
-static void sn65dsi83_atomic_enable(struct drm_bridge *bridge,
-				    struct drm_bridge_state *old_bridge_state)
+static void sn65dsi83_atomic_pre_enable(struct drm_bridge *bridge,
+					struct drm_bridge_state *old_bridge_state)
 {
 	struct sn65dsi83 *ctx = bridge_to_sn65dsi83(bridge);
 	struct drm_atomic_state *state = old_bridge_state->base.state;
@@ -485,11 +485,22 @@ static void sn65dsi83_atomic_enable(struct drm_bridge *bridge,
 	/* Trigger reset after CSR register update. */
 	regmap_write(ctx->regmap, REG_RC_RESET, REG_RC_RESET_SOFT_RESET);
 
+	/* Wait for 10ms after soft reset as specified in datasheet */
+	usleep_range(10000, 12000);
+}
+
+static void sn65dsi83_atomic_enable(struct drm_bridge *bridge,
+				    struct drm_bridge_state *old_bridge_state)
+{
+	struct sn65dsi83 *ctx = bridge_to_sn65dsi83(bridge);
+	unsigned int pval;
+
 	/* Clear all errors that got asserted during initialization. */
 	regmap_read(ctx->regmap, REG_IRQ_STAT, &pval);
 	regmap_write(ctx->regmap, REG_IRQ_STAT, pval);
 
-	usleep_range(10000, 12000);
+	/* Wait for 1ms and check for errors in status register */
+	usleep_range(1000, 1100);
 	regmap_read(ctx->regmap, REG_IRQ_STAT, &pval);
 	if (pval)
 		dev_err(ctx->dev, "Unexpected link status 0x%02x\n", pval);
@@ -556,6 +567,7 @@ static const struct drm_bridge_funcs sn65dsi83_funcs = {
 	.attach			= sn65dsi83_attach,
 	.detach			= sn65dsi83_detach,
 	.atomic_enable		= sn65dsi83_atomic_enable,
+	.atomic_pre_enable	= sn65dsi83_atomic_pre_enable,
 	.atomic_disable		= sn65dsi83_atomic_disable,
 	.mode_valid		= sn65dsi83_mode_valid,
 
@@ -696,6 +708,7 @@ static int sn65dsi83_probe(struct i2c_client *client)
 
 	ctx->bridge.funcs = &sn65dsi83_funcs;
 	ctx->bridge.of_node = dev->of_node;
+	ctx->bridge.pre_enable_prev_first = true;
 	drm_bridge_add(&ctx->bridge);
 
 	ret = sn65dsi83_host_attach(ctx);
-- 
2.39.2



