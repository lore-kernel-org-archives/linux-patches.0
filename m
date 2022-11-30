Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FBC26FA1
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:26:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5913C433D6;
	Wed, 30 Nov 2022 18:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669832779;
	bh=JT4/EOII5U4Vev/JsR9Uok1QnPBvVJU6qrAIcS1c8ko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G5dECcyT2txZ2ejiKWXskgCRC2X1ZQSW0ZMUjPvV2kD29WB5dVQdxHa3BmWGYgJTT
	 aLLhn3Fp1Qd3/wyEDAfKo6RTde7kNdKt1nYOPHJx0HzZYQsOMZcFqTEOKPGbXzJyaE
	 Spstm7GBGWNSQk178KPbjjfEeWpHC7KlV0YqfaRw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Detlev Casanova <detlev.casanova@collabora.com>,
	Fabio Estevam <festevam@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 037/162] ASoC: sgtl5000: Reset the CHIP_CLK_CTRL reg on remove
Date: Wed, 30 Nov 2022 19:21:58 +0100
Message-Id: <20221130180529.512167447@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180528.466039523@linuxfoundation.org>
References: <20221130180528.466039523@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Detlev Casanova <detlev.casanova@collabora.com>

[ Upstream commit 0bb8e9b36b5b7f2e77892981ff6c27ee831d8026 ]

Since commit bf2aebccddef ("ASoC: sgtl5000: Fix noise on shutdown/remove"),
the device power control registers are reset when the driver is
removed/shutdown.

This is an issue when the device is configured to use the PLL clock. The
device will stop responding if it is still configured to use the PLL
clock but the PLL clock is powered down.

When rebooting linux, the probe function will show:
sgtl5000 0-000a: Error reading chip id -11

Make sure that the CHIP_CLK_CTRL is reset to its default value before
powering down the device.

Fixes: bf2aebccddef ("ASoC: sgtl5000: Fix noise on shutdown/remove")
Signed-off-by: Detlev Casanova <detlev.casanova@collabora.com>
Reviewed-by: Fabio Estevam <festevam@gmail.com>
Link: https://lore.kernel.org/r/20221110190612.1341469-1-detlev.casanova@collabora.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/sgtl5000.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/codecs/sgtl5000.c b/sound/soc/codecs/sgtl5000.c
index f066e016a874..edde0323799a 100644
--- a/sound/soc/codecs/sgtl5000.c
+++ b/sound/soc/codecs/sgtl5000.c
@@ -1797,6 +1797,7 @@ static int sgtl5000_i2c_remove(struct i2c_client *client)
 {
 	struct sgtl5000_priv *sgtl5000 = i2c_get_clientdata(client);
 
+	regmap_write(sgtl5000->regmap, SGTL5000_CHIP_CLK_CTRL, SGTL5000_CHIP_CLK_CTRL_DEFAULT);
 	regmap_write(sgtl5000->regmap, SGTL5000_CHIP_DIG_POWER, SGTL5000_DIG_POWER_DEFAULT);
 	regmap_write(sgtl5000->regmap, SGTL5000_CHIP_ANA_POWER, SGTL5000_ANA_POWER_DEFAULT);
 
-- 
2.35.1



