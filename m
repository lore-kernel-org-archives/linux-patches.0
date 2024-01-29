Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7471215B98E;
	Mon, 29 Jan 2024 17:17:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548646; cv=none; b=UBg4A6MNFBCU4HGNu+LiIOQ7+DARvO9nK13k9wsX6oTYCBbYK06C5uKzt4Ebe5yHCOVvzL6zSIWQd7V8RT2hKj//Ny5z+VThvFZ8ibOA52vRY5bbiSeRjCozjfaqm1h2LJNeIFnUfK2KzRSV+NP4PZeJ5ldR+AUtLydD/gd+MuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548646; c=relaxed/simple;
	bh=n4wVGzuH7z2Lhmyk0DuqVFXcmdkn0mJudX5AGqipvFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YnLYdoDzpON8FeZmHVzWtKmx2GMfzooBRRlKuWWjAPZZ2cwNYkfSVLkXkx/2ldCQTGv3VAj4R1j7rBbPi40C0Ia+mrAEXsOTatgWSoQVUx2O3OG5ANvZ4Uxjcjnw/7agYL0rkwDLY/j7f1za58kRxeNVxyKOlZJbjQSUPUQgqp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YYu6+mDR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YYu6+mDR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F2F3C433C7;
	Mon, 29 Jan 2024 17:17:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548645;
	bh=n4wVGzuH7z2Lhmyk0DuqVFXcmdkn0mJudX5AGqipvFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YYu6+mDR5rS1Yhz8gQJjArtFhslsIclPHMfZM84K4dyVF2aaw6dBw1kIv3Q2FK5zm
	 4mddrDUh0MEIeG/1yVzfCqYyOw+SaSTgPcQgQz1EqDhXr2a3IOxmjdppwnaKU2XOyl
	 64dBzYn+Z+d3IOB04FfplgtM9KiTFZj0RRCCzUKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Walle <mwalle@kernel.org>,
	Inki Dae <inki.dae@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 323/331] drm: bridge: samsung-dsim: Dont use FORCE_STOP_STATE
Date: Mon, 29 Jan 2024 09:06:27 -0800
Message-ID: <20240129170024.323460067@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

From: Michael Walle <mwalle@kernel.org>

[ Upstream commit ff3d5d04db07e5374758baa7e877fde8d683ebab ]

The FORCE_STOP_STATE bit is unsuitable to force the DSI link into LP-11
mode. It seems the bridge internally queues DSI packets and when the
FORCE_STOP_STATE bit is cleared, they are sent in close succession
without any useful timing (this also means that the DSI lanes won't go
into LP-11 mode). The length of this gibberish varies between 1ms and
5ms. This sometimes breaks an attached bridge (TI SN65DSI84 in this
case). In our case, the bridge will fail in about 1 per 500 reboots.

The FORCE_STOP_STATE handling was introduced to have the DSI lanes in
LP-11 state during the .pre_enable phase. But as it turns out, none of
this is needed at all. Between samsung_dsim_init() and
samsung_dsim_set_display_enable() the lanes are already in LP-11 mode.
The code as it was before commit 20c827683de0 ("drm: bridge:
samsung-dsim: Fix init during host transfer") and 0c14d3130654 ("drm:
bridge: samsung-dsim: Fix i.MX8M enable flow to meet spec") was correct
in this regard.

This patch basically reverts both commits. It was tested on an i.MX8M
SoC with an SN65DSI84 bridge. The signals were probed and the DSI
packets were decoded during initialization and link start-up. After this
patch the first DSI packet on the link is a VSYNC packet and the timing
is correct.

Command mode between .pre_enable and .enable was also briefly tested by
a quick hack. There was no DSI link partner which would have responded,
but it was made sure the DSI packet was send on the link. As a side
note, the command mode seems to just work in HS mode. I couldn't find
that the bridge will handle commands in LP mode.

Fixes: 20c827683de0 ("drm: bridge: samsung-dsim: Fix init during host transfer")
Fixes: 0c14d3130654 ("drm: bridge: samsung-dsim: Fix i.MX8M enable flow to meet spec")
Signed-off-by: Michael Walle <mwalle@kernel.org>
Signed-off-by: Inki Dae <inki.dae@samsung.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20231113164344.1612602-1-mwalle@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/samsung-dsim.c | 32 ++-------------------------
 1 file changed, 2 insertions(+), 30 deletions(-)

diff --git a/drivers/gpu/drm/bridge/samsung-dsim.c b/drivers/gpu/drm/bridge/samsung-dsim.c
index 19bdb32dbc9a..f24666b48193 100644
--- a/drivers/gpu/drm/bridge/samsung-dsim.c
+++ b/drivers/gpu/drm/bridge/samsung-dsim.c
@@ -941,10 +941,6 @@ static int samsung_dsim_init_link(struct samsung_dsim *dsi)
 	reg = samsung_dsim_read(dsi, DSIM_ESCMODE_REG);
 	reg &= ~DSIM_STOP_STATE_CNT_MASK;
 	reg |= DSIM_STOP_STATE_CNT(driver_data->reg_values[STOP_STATE_CNT]);
-
-	if (!samsung_dsim_hw_is_exynos(dsi->plat_data->hw_type))
-		reg |= DSIM_FORCE_STOP_STATE;
-
 	samsung_dsim_write(dsi, DSIM_ESCMODE_REG, reg);
 
 	reg = DSIM_BTA_TIMEOUT(0xff) | DSIM_LPDR_TIMEOUT(0xffff);
@@ -1401,18 +1397,6 @@ static void samsung_dsim_disable_irq(struct samsung_dsim *dsi)
 	disable_irq(dsi->irq);
 }
 
-static void samsung_dsim_set_stop_state(struct samsung_dsim *dsi, bool enable)
-{
-	u32 reg = samsung_dsim_read(dsi, DSIM_ESCMODE_REG);
-
-	if (enable)
-		reg |= DSIM_FORCE_STOP_STATE;
-	else
-		reg &= ~DSIM_FORCE_STOP_STATE;
-
-	samsung_dsim_write(dsi, DSIM_ESCMODE_REG, reg);
-}
-
 static int samsung_dsim_init(struct samsung_dsim *dsi)
 {
 	const struct samsung_dsim_driver_data *driver_data = dsi->driver_data;
@@ -1462,9 +1446,6 @@ static void samsung_dsim_atomic_pre_enable(struct drm_bridge *bridge,
 		ret = samsung_dsim_init(dsi);
 		if (ret)
 			return;
-
-		samsung_dsim_set_display_mode(dsi);
-		samsung_dsim_set_display_enable(dsi, true);
 	}
 }
 
@@ -1473,12 +1454,8 @@ static void samsung_dsim_atomic_enable(struct drm_bridge *bridge,
 {
 	struct samsung_dsim *dsi = bridge_to_dsi(bridge);
 
-	if (samsung_dsim_hw_is_exynos(dsi->plat_data->hw_type)) {
-		samsung_dsim_set_display_mode(dsi);
-		samsung_dsim_set_display_enable(dsi, true);
-	} else {
-		samsung_dsim_set_stop_state(dsi, false);
-	}
+	samsung_dsim_set_display_mode(dsi);
+	samsung_dsim_set_display_enable(dsi, true);
 
 	dsi->state |= DSIM_STATE_VIDOUT_AVAILABLE;
 }
@@ -1491,9 +1468,6 @@ static void samsung_dsim_atomic_disable(struct drm_bridge *bridge,
 	if (!(dsi->state & DSIM_STATE_ENABLED))
 		return;
 
-	if (!samsung_dsim_hw_is_exynos(dsi->plat_data->hw_type))
-		samsung_dsim_set_stop_state(dsi, true);
-
 	dsi->state &= ~DSIM_STATE_VIDOUT_AVAILABLE;
 }
 
@@ -1795,8 +1769,6 @@ static ssize_t samsung_dsim_host_transfer(struct mipi_dsi_host *host,
 	if (ret)
 		return ret;
 
-	samsung_dsim_set_stop_state(dsi, false);
-
 	ret = mipi_dsi_create_packet(&xfer.packet, msg);
 	if (ret < 0)
 		return ret;
-- 
2.43.0



