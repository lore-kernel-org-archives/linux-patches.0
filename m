Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 055812E63B
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:13:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E451C433C8;
	Wed, 20 Sep 2023 12:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695212030;
	bh=D8FQM2B5gtcVg83pNj6wDnXrxfCCZDu0OHqxk+xocn4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r17Vz9YxYR/dTAiQYotc2/+pie7/DOlxLeBJbkZ4LOV6pbxlhid5C4GJoCAZm6DoK
	 Ltgao1iANDNna8nRJimUQ2mKci7LLRfRbxH7n06NmLvahCZPWb9G2DZFC1mwbmR4kd
	 LM3Z9vlL47lYzVqMzLGzSDxEgZlXmc1qvndF2ezY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Foss <rfoss@kernel.org>,
	Nuno Sa <nuno.sa@analog.com>,
	Bogdan Togorean <bogdan.togorean@analog.com>,
	Alexandru Ardelean <alex@shruggie.ro>,
	Frieder Schrempf <frieder.schrempf@kontron.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 095/273] drm: adv7511: Fix low refresh rate register for ADV7533/5
Date: Wed, 20 Sep 2023 13:28:55 +0200
Message-ID: <20230920112849.376810127@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112846.440597133@linuxfoundation.org>
References: <20230920112846.440597133@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bogdan Togorean <bogdan.togorean@analog.com>

[ Upstream commit d281eeaa4de2636ff0c8e6ae387bb07b50e5fcbb ]

For ADV7533 and ADV7535 low refresh rate is selected using
bits [3:2] of 0x4a main register.
So depending on ADV model write 0xfb or 0x4a register.

Fixes: 2437e7cd88e8 ("drm/bridge: adv7533: Initial support for ADV7533")
Reviewed-by: Robert Foss <rfoss@kernel.org>
Reviewed-by: Nuno Sa <nuno.sa@analog.com>
Signed-off-by: Bogdan Togorean <bogdan.togorean@analog.com>
Signed-off-by: Alexandru Ardelean <alex@shruggie.ro>
Reviewed-by: Frieder Schrempf <frieder.schrempf@kontron.de>
Signed-off-by: Robert Foss <rfoss@kernel.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20230719060143.63649-1-alex@shruggie.ro
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/adv7511/adv7511_drv.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/bridge/adv7511/adv7511_drv.c b/drivers/gpu/drm/bridge/adv7511/adv7511_drv.c
index 31b75d3ca6e90..85aba4c38dc00 100644
--- a/drivers/gpu/drm/bridge/adv7511/adv7511_drv.c
+++ b/drivers/gpu/drm/bridge/adv7511/adv7511_drv.c
@@ -756,8 +756,13 @@ static void adv7511_mode_set(struct adv7511 *adv7511,
 	else
 		low_refresh_rate = ADV7511_LOW_REFRESH_RATE_NONE;
 
-	regmap_update_bits(adv7511->regmap, 0xfb,
-		0x6, low_refresh_rate << 1);
+	if (adv7511->type == ADV7511)
+		regmap_update_bits(adv7511->regmap, 0xfb,
+				   0x6, low_refresh_rate << 1);
+	else
+		regmap_update_bits(adv7511->regmap, 0x4a,
+				   0xc, low_refresh_rate << 2);
+
 	regmap_update_bits(adv7511->regmap, 0x17,
 		0x60, (vsync_polarity << 6) | (hsync_polarity << 5));
 
-- 
2.40.1



