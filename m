Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 909342FFF9D;
	Sat, 12 Sep 2026 14:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222318; cv=none; b=NiF2NwlAnQcLbWWHnYcoxqI9EOXqz0a4Pqd6/PcDqHr81MgE65yFhHMsSh5IvuUaT8waly0o03J86pWlLA1z4PcNcOU9x9YC2b2c7499diyTRdS2KiVmqYH6k5B7mYIlJDfnehR85Ht/Xj2m6tLMOBOWOIxOMxhQbWcrvMlY8nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222318; c=relaxed/simple;
	bh=wikn+Ks8UnD5xXwDh+yWE3K9ucT+41tAVtc8kLlvTio=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LAhudAAXnc7ozT5NIx0XfVzvBkgk9LK7OS/F4v+PwlI+8uyFPSs1H+c0vTcIrrD+/0bPNKu/ftgNv6yB4l6W+buSkxJ6TYGEkqHVCSYTu3g3Lc3C6ZLyuSn6UH9zoGu/dLbNuX7bWpDZp6DeQlqprTnCZUCNu2gLoxbmOeYNyVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XQXLhzKl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XQXLhzKl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2490E1F000FF;
	Sat, 12 Sep 2026 14:11:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222317;
	bh=s1vnLRXuam7C53t77v4CvJZm9HRGICeGSthVllRArds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XQXLhzKlPA5++hGXb6bJkvj3UqPApi2kYWehwcXDGevugAt8XsQS6Vpw9/zarRYHP
	 /2j0hX7ofvQM54IvnV0dJoutV0RzxIWhagfpkFSewbCjkZZKL7zOR2ypE+TgntaQXe
	 b0XKsfCLJ88ZIUDBduJmZQuuLuSiJEfW2zbWDVc4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Kocialkowski <paulk@sys-base.io>,
	Frieder Schrempf <frieder.schrempf@kontron.de>,
	Liu Ying <victor.liu@nxp.com>,
	Lucas Stach <l.stach@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0562/1424] drm: lcdif: Wait for vblank before disabling DMA
Date: Sat, 12 Sep 2026 08:49:54 +0200
Message-ID: <20260912065619.891220468@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Kocialkowski <paulk@sys-base.io>

[ Upstream commit 351af554edd994898db12217c3be39979e168d35 ]

It is necessary to wait for the full frame to finish streaming
through the DMA engine before we can safely disable it by removing
the DISP_PARA_DISP_ON bit. Disabling it in-flight can leave the
hardware confused and unable to resume streaming for the next frame.

This causes the FIFO underrun and empty status bits to be set and
a single solid color to be shown on the display, coming from one of
the pixels of the previous frame. The issue occurs sporadically when
a new mode is set, which triggers the crtc disable and enable paths.

Setting the shadow load bit and waiting for it to be cleared by the
DMA engine allows waiting for completion.

The NXP BSP driver addresses this issue with a hardcoded 25 ms sleep.

Fixes: 9db35bb349a0 ("drm: lcdif: Add support for i.MX8MP LCDIF variant")
Signed-off-by: Paul Kocialkowski <paulk@sys-base.io>
Co-developed-by: Lucas Stach <l.stach@pengutronix.de>
Reviewed-by: Frieder Schrempf <frieder.schrempf@kontron.de>
Tested-by: Frieder Schrempf <frieder.schrempf@kontron.de>
Acked-by: Liu Ying <victor.liu@nxp.com>
Link: https://patch.msgid.link/20260402183351.3281123-3-paulk@sys-base.io
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mxsfb/lcdif_kms.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/mxsfb/lcdif_kms.c b/drivers/gpu/drm/mxsfb/lcdif_kms.c
index 2541d2de4e45f..16dd2957128eb 100644
--- a/drivers/gpu/drm/mxsfb/lcdif_kms.c
+++ b/drivers/gpu/drm/mxsfb/lcdif_kms.c
@@ -373,14 +373,23 @@ static void lcdif_disable_controller(struct lcdif_drm_private *lcdif)
 	int ret;
 
 	reg = readl(lcdif->base + LCDC_V8_CTRLDESCL0_5);
+	/* Disable the layer for DMA. */
 	reg &= ~CTRLDESCL0_5_EN;
+	/*
+	 * It is necessary to wait for the full frame to finish streaming
+	 * through the DMA engine before we can safely disable it by removing
+	 * the DISP_PARA_DISP_ON bit. Disabling it in-flight can leave the
+	 * hardware confused and unable to resume streaming for the next frame.
+	 */
+	reg |= CTRLDESCL0_5_SHADOW_LOAD_EN;
 	writel(reg, lcdif->base + LCDC_V8_CTRLDESCL0_5);
 
+	/* Wait for the frame to finish or timeout after 50 ms. */
 	ret = readl_poll_timeout(lcdif->base + LCDC_V8_CTRLDESCL0_5,
-				 reg, !(reg & CTRLDESCL0_5_EN),
-				 0, 36000);	/* Wait ~2 frame times max */
+				 reg, !(reg & CTRLDESCL0_5_SHADOW_LOAD_EN),
+				 200, 50000);
 	if (ret)
-		drm_err(lcdif->drm, "Failed to disable controller!\n");
+		drm_err(lcdif->drm, "Timed out waiting for final vblank!\n");
 
 	reg = readl(lcdif->base + LCDC_V8_DISP_PARA);
 	reg &= ~DISP_PARA_DISP_ON;
-- 
2.53.0



