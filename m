Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5455D528;
	Sun,  7 Sep 2025 20:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276692; cv=none; b=FcuiNDihTfWzAS3du5igQrOV3NueK9O0tXV5d5WmhUPSnTl71egsZkrMO9PG//uVk2D9IFtLwg8O4vwpxeh+UruxR0A14N2jBJ2rrqZbSmpVjmkvDS+ZbE0HsyTVOYZQD1CuAlya5wJzE2w5hXgGTma952HmYgXxkEErfovmrF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276692; c=relaxed/simple;
	bh=/kLlgMRyzUtOV8/txC7im5T3XMH2h+VxvLygdamFdMg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FTuQnvpfbwR9KIKnkBC1v4UAdt/d8rmyWA5qGPeFylOTvxEihJ+aoWi+wuF8P3T/MkqVTaN9BxYo30VXkQp7DPPA+rlyhZZqqixEeRrTM6PZ97Xn6+wlOhhepC6kbEfc8Se+mf48ooaObmwzC573N1GLpSaC2CP+v5Ba8z+ysRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VHezfaOR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VHezfaOR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 013F4C4CEF0;
	Sun,  7 Sep 2025 20:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276692;
	bh=/kLlgMRyzUtOV8/txC7im5T3XMH2h+VxvLygdamFdMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VHezfaORME1qucohXaY6MjajajwL4F7+MmAhmITI/eqmYb4Ro7Yt8l8ISBvTkNK3I
	 o0CYJMY9mdgyaheXl2vh0tmnJrtrPO/bUC4/+NBAJElcav/fRuVkWThqRDJBuv1CBS
	 eZgxR2L/FFNdo3/MUBdEiHZ9Tgby1kYfr76orpSo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	"=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" <nfraprado@collabora.com>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 079/121] thermal/drivers/mediatek/lvts: Disable low offset IRQ for minimum threshold
Date: Sun,  7 Sep 2025 21:58:35 +0200
Message-ID: <20250907195611.864977778@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195609.817339617@linuxfoundation.org>
References: <20250907195609.817339617@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nícolas F. R. A. Prado <nfraprado@collabora.com>

[ Upstream commit fa17ff8e325a657c84be1083f06e54ee7eea82e4 ]

In order to get working interrupts, a low offset value needs to be
configured. The minimum value for it is 20 Celsius, which is what is
configured when there's no lower thermal trip (ie the thermal core
passes -INT_MAX as low trip temperature). However, when the temperature
gets that low and fluctuates around that value it causes an interrupt
storm.

Prevent that interrupt storm by not enabling the low offset interrupt if
the low threshold is the minimum one.

Cc: stable@vger.kernel.org
Fixes: 77354eaef821 ("thermal/drivers/mediatek/lvts_thermal: Don't leave threshold zeroed")
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Link: https://lore.kernel.org/r/20250113-mt8192-lvts-filtered-suspend-fix-v2-3-07a25200c7c6@collabora.com
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
[ Adapted interrupt mask definitions ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thermal/mediatek/lvts_thermal.c |   50 +++++++++++++++++++++++---------
 1 file changed, 36 insertions(+), 14 deletions(-)

--- a/drivers/thermal/mediatek/lvts_thermal.c
+++ b/drivers/thermal/mediatek/lvts_thermal.c
@@ -67,10 +67,14 @@
 #define LVTS_CALSCALE_CONF			0x300
 #define LVTS_MONINT_CONF			0x8300318C
 
-#define LVTS_MONINT_OFFSET_SENSOR0		0xC
-#define LVTS_MONINT_OFFSET_SENSOR1		0x180
-#define LVTS_MONINT_OFFSET_SENSOR2		0x3000
-#define LVTS_MONINT_OFFSET_SENSOR3		0x3000000
+#define LVTS_MONINT_OFFSET_HIGH_INTEN_SENSOR0		BIT(3)
+#define LVTS_MONINT_OFFSET_HIGH_INTEN_SENSOR1		BIT(8)
+#define LVTS_MONINT_OFFSET_HIGH_INTEN_SENSOR2		BIT(13)
+#define LVTS_MONINT_OFFSET_HIGH_INTEN_SENSOR3		BIT(25)
+#define LVTS_MONINT_OFFSET_LOW_INTEN_SENSOR0		BIT(2)
+#define LVTS_MONINT_OFFSET_LOW_INTEN_SENSOR1		BIT(7)
+#define LVTS_MONINT_OFFSET_LOW_INTEN_SENSOR2		BIT(12)
+#define LVTS_MONINT_OFFSET_LOW_INTEN_SENSOR3		BIT(24)
 
 #define LVTS_INT_SENSOR0			0x0009001F
 #define LVTS_INT_SENSOR1			0x001203E0
@@ -308,23 +312,41 @@ static int lvts_get_temp(struct thermal_
 
 static void lvts_update_irq_mask(struct lvts_ctrl *lvts_ctrl)
 {
-	u32 masks[] = {
-		LVTS_MONINT_OFFSET_SENSOR0,
-		LVTS_MONINT_OFFSET_SENSOR1,
-		LVTS_MONINT_OFFSET_SENSOR2,
-		LVTS_MONINT_OFFSET_SENSOR3,
+	static const u32 high_offset_inten_masks[] = {
+		LVTS_MONINT_OFFSET_HIGH_INTEN_SENSOR0,
+		LVTS_MONINT_OFFSET_HIGH_INTEN_SENSOR1,
+		LVTS_MONINT_OFFSET_HIGH_INTEN_SENSOR2,
+		LVTS_MONINT_OFFSET_HIGH_INTEN_SENSOR3,
+	};
+	static const u32 low_offset_inten_masks[] = {
+		LVTS_MONINT_OFFSET_LOW_INTEN_SENSOR0,
+		LVTS_MONINT_OFFSET_LOW_INTEN_SENSOR1,
+		LVTS_MONINT_OFFSET_LOW_INTEN_SENSOR2,
+		LVTS_MONINT_OFFSET_LOW_INTEN_SENSOR3,
 	};
 	u32 value = 0;
 	int i;
 
 	value = readl(LVTS_MONINT(lvts_ctrl->base));
 
-	for (i = 0; i < ARRAY_SIZE(masks); i++) {
+	for (i = 0; i < ARRAY_SIZE(high_offset_inten_masks); i++) {
 		if (lvts_ctrl->sensors[i].high_thresh == lvts_ctrl->high_thresh
-		    && lvts_ctrl->sensors[i].low_thresh == lvts_ctrl->low_thresh)
-			value |= masks[i];
-		else
-			value &= ~masks[i];
+		    && lvts_ctrl->sensors[i].low_thresh == lvts_ctrl->low_thresh) {
+			/*
+			 * The minimum threshold needs to be configured in the
+			 * OFFSETL register to get working interrupts, but we
+			 * don't actually want to generate interrupts when
+			 * crossing it.
+			 */
+			if (lvts_ctrl->low_thresh == -INT_MAX) {
+				value &= ~low_offset_inten_masks[i];
+				value |= high_offset_inten_masks[i];
+			} else {
+				value |= low_offset_inten_masks[i] | high_offset_inten_masks[i];
+			}
+		} else {
+			value &= ~(low_offset_inten_masks[i] | high_offset_inten_masks[i]);
+		}
 	}
 
 	writel(value, LVTS_MONINT(lvts_ctrl->base));


