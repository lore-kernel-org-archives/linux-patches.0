Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80F441D0426;
	Wed,  2 Oct 2024 14:30:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879428; cv=none; b=NEfxkWVAKN6JLwYfF95ycP22EDfO9ePJCrMCjl+bCh5j2ka/eQ+hDbByUhPwjALIdQ11hQL/NOyAdgeBoRX2g2BDW/ZzZRiCbjDGrM9F12jIn4qR+gU103un/9wA0Xkip6EuwSbhwcCGqYVI/ca/rhCkhkZw/l6v+aZKNX/lLHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879428; c=relaxed/simple;
	bh=Fbk12ph1SJD1KP10ByQbDlPKRrnn1zvl0vqk9g/xbik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HebSz1LoRBanyJpzeRQEBZI82RJpR7bA/lQWk+INKTDKK6xckNr0Nxc/MDWywa2Jz0jeIj94O1jzFGJqel2tDcfhQhITmH8CN4pp+klBilLoXKtdfcEKzTRm1tKtm6vgbiE25r4VD2+EBb5QMlqGv8rKbW5l0HFSmEB9BeIDCcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XXM7Oj63; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XXM7Oj63"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D122AC4CEC2;
	Wed,  2 Oct 2024 14:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879428;
	bh=Fbk12ph1SJD1KP10ByQbDlPKRrnn1zvl0vqk9g/xbik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XXM7Oj638zmYWytaP1d5omLnxjaqU+M+EfOl03VGeLJPbMmPIDvcoBot4NaD+Yltx
	 dUG3FTnT9W68eCutQHtHR8Og76RMmaHBJHfFz7qnR4v2iZsUSNxlDBjkVtLQUXCqVP
	 +Kbn0mMtV5cufJcTIG9meyhIiIDK7G3dEYVLDHrM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linus.walleij@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 115/538] ASoC: tas2781-i2c: Get the right GPIO line
Date: Wed,  2 Oct 2024 14:55:54 +0200
Message-ID: <20241002125756.783954772@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit 1c4b509edad15192bfb64c81d3c305bbae8070db ]

The code is obtaining a GPIO reset using the reset GPIO
name "reset-gpios", but the gpiolib is already adding the
suffix "-gpios" to anything passed to this function and
will be looking for "reset-gpios-gpios" which is most
certainly not what the author desired.

Fix it up.

Fixes: ef3bcde75d06 ("ASoC: tas2781: Add tas2781 driver")
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://patch.msgid.link/20240807-asoc-tas-gpios-v2-2-bd0f2705d58b@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/tas2781-i2c.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/tas2781-i2c.c b/sound/soc/codecs/tas2781-i2c.c
index b25978f01cd2a..43775c1944452 100644
--- a/sound/soc/codecs/tas2781-i2c.c
+++ b/sound/soc/codecs/tas2781-i2c.c
@@ -653,7 +653,7 @@ static void tasdevice_parse_dt(struct tasdevice_priv *tas_priv)
 		tas_priv->tasdevice[i].dev_addr = dev_addrs[i];
 
 	tas_priv->reset = devm_gpiod_get_optional(&client->dev,
-			"reset-gpios", GPIOD_OUT_HIGH);
+			"reset", GPIOD_OUT_HIGH);
 	if (IS_ERR(tas_priv->reset))
 		dev_err(tas_priv->dev, "%s Can't get reset GPIO\n",
 			__func__);
-- 
2.43.0



