Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41E58522E
	for <patches@lists.linux.dev>; Sun,  9 Jul 2023 11:24:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AD8AC433C7;
	Sun,  9 Jul 2023 11:24:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688901870;
	bh=5aTeKyXvANEJZRkfhVinKmKB3XeZdIyA2OgfN2Jxnac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JpDPDjp/U0o/dSf1Z+w/xpy+e6m1j8c+2I82J7Us21biNJe2Qh8KZ3Ot2lJR2fitm
	 QcsTwG8yqMaC0f9bbNFuw40nb0mIdOc48FjmP3gE5AcO98eSkYQeyCb+J5ovcGD1c4
	 MllI8xA7/uB3MA4UwP8zeqhoWVVN9r6xbyL4q4Xk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Robert Foss <rfoss@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 173/431] drm/bridge: tc358768: fix TCLK_TRAILCNT computation
Date: Sun,  9 Jul 2023 13:12:01 +0200
Message-ID: <20230709111455.226993709@linuxfoundation.org>
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

From: Francesco Dolcini <francesco.dolcini@toradex.com>

[ Upstream commit ee18698e212b1659dd0850d7e2ae0f22e16ed3d3 ]

Correct computation of TCLK_TRAILCNT register.

The driver does not implement non-continuous clock mode, so the actual
value doesn't make a practical difference yet. However this change also
ensures that the value does not write to reserved registers bits in case
of under/overflow.

This register must be set to a value that ensures that

TCLK-TRAIL > 60ns
 and
TEOT <= (105 ns + 12 x UI)

with the actual value of TCLK-TRAIL being

(TCLK_TRAILCNT + (1 to 2)) xHSByteClkCycle +
 (2 + (1 to 2)) * HSBYTECLKCycle - (PHY output delay)

with PHY output delay being about

(2 to 3) x MIPIBitClk cycle in the BitClk conversion.

Fixes: ff1ca6397b1d ("drm/bridge: Add tc358768 driver")
Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Reviewed-by: Robert Foss <rfoss@kernel.org>
Signed-off-by: Robert Foss <rfoss@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20230427142934.55435-2-francesco@dolcini.it
Link: https://patchwork.freedesktop.org/patch/msgid/20230427142934.55435-3-francesco@dolcini.it
Link: https://patchwork.freedesktop.org/patch/msgid/20230427142934.55435-4-francesco@dolcini.it
Link: https://patchwork.freedesktop.org/patch/msgid/20230427142934.55435-5-francesco@dolcini.it
Link: https://patchwork.freedesktop.org/patch/msgid/20230427142934.55435-2-francesco@dolcini.it
Link: https://patchwork.freedesktop.org/patch/msgid/20230427142934.55435-3-francesco@dolcini.it
Link: https://patchwork.freedesktop.org/patch/msgid/20230427142934.55435-4-francesco@dolcini.it
Link: https://patchwork.freedesktop.org/patch/msgid/20230427142934.55435-5-francesco@dolcini.it
Link: https://patchwork.freedesktop.org/patch/msgid/20230427142934.55435-2-francesco@dolcini.it
Link: https://patchwork.freedesktop.org/patch/msgid/20230427142934.55435-3-francesco@dolcini.it
Link: https://patchwork.freedesktop.org/patch/msgid/20230427142934.55435-4-francesco@dolcini.it
Link: https://patchwork.freedesktop.org/patch/msgid/20230427142934.55435-5-francesco@dolcini.it
Link: https://patchwork.freedesktop.org/patch/msgid/20230427142934.55435-2-francesco@dolcini.it
Link: https://patchwork.freedesktop.org/patch/msgid/20230427142934.55435-3-francesco@dolcini.it
Link: https://patchwork.freedesktop.org/patch/msgid/20230427142934.55435-4-francesco@dolcini.it
Link: https://patchwork.freedesktop.org/patch/msgid/20230427142934.55435-5-francesco@dolcini.it
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/tc358768.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/bridge/tc358768.c b/drivers/gpu/drm/bridge/tc358768.c
index 487bfe33edc88..4cb46a3e6be8c 100644
--- a/drivers/gpu/drm/bridge/tc358768.c
+++ b/drivers/gpu/drm/bridge/tc358768.c
@@ -10,6 +10,7 @@
 #include <linux/i2c.h>
 #include <linux/kernel.h>
 #include <linux/media-bus-format.h>
+#include <linux/minmax.h>
 #include <linux/module.h>
 #include <linux/regmap.h>
 #include <linux/regulator/consumer.h>
@@ -639,6 +640,7 @@ static void tc358768_bridge_pre_enable(struct drm_bridge *bridge)
 	struct mipi_dsi_device *dsi_dev = priv->output.dev;
 	unsigned long mode_flags = dsi_dev->mode_flags;
 	u32 val, val2, lptxcnt, hact, data_type;
+	s32 raw_val;
 	const struct drm_display_mode *mode;
 	u32 dsibclk_nsk, dsiclk_nsk, ui_nsk, phy_delay_nsk;
 	u32 dsiclk, dsibclk, video_start;
@@ -750,9 +752,9 @@ static void tc358768_bridge_pre_enable(struct drm_bridge *bridge)
 	dev_dbg(priv->dev, "TCLK_HEADERCNT: 0x%x\n", val);
 	tc358768_write(priv, TC358768_TCLK_HEADERCNT, val);
 
-	/* TCLK_TRAIL > 60ns + 3*UI */
-	val = 60 + tc358768_to_ns(3 * ui_nsk);
-	val = tc358768_ns_to_cnt(val, dsibclk_nsk) - 5;
+	/* TCLK_TRAIL > 60ns AND TEOT <= 105 ns + 12*UI */
+	raw_val = tc358768_ns_to_cnt(60 + tc358768_to_ns(2 * ui_nsk), dsibclk_nsk) - 5;
+	val = clamp(raw_val, 0, 127);
 	dev_dbg(priv->dev, "TCLK_TRAILCNT: 0x%x\n", val);
 	tc358768_write(priv, TC358768_TCLK_TRAILCNT, val);
 
-- 
2.39.2



