Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAE2D1CC89D;
	Wed,  6 Nov 2024 13:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730899122; cv=none; b=Fb42d6zx85Izc6j1WzdLx6fkiAIn/E7gkstO1Ev5hhG0SZo6nFOT/JUiHAzvki1JZjGEjy+ggnNRwPxUmqAYVgwq32BaFNNEv81IEvKzOuq4IEU4tAJL03PExsqXOiud0NPO3z/rFI8jxDcTjizFZp5/yTTdfyTkBaejjN3hkNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730899122; c=relaxed/simple;
	bh=x9of6KxYTPzmdwtdYZH9TgbSUOmqczw4hoPWzRrh7BI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L6fPG/O9ZWL7sY48mBrCHW+kIRmyQuCDgUAwLX7r2MAlemVRQ8Lpe6RIPo0hCMCdqUy23VPP1JrZ/BS8neGJchd457WPL1uYY5jxqHj5/pNTo+tsO0PR5u8JFLqq5plXonheW3ozh4V9jr0oo53nd5lmyTF5foGohyoYJkGdl60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bl49O8Tw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bl49O8Tw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05EEDC4CECD;
	Wed,  6 Nov 2024 13:18:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730899120;
	bh=x9of6KxYTPzmdwtdYZH9TgbSUOmqczw4hoPWzRrh7BI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bl49O8Tw21BE/1qzzOV+eEcXs/v9zke/RGG8uYVJyhvYgbLH6Sx8vwr+++ruCGAdC
	 Nud2IFh+UrjU0TmhHEfnZTKP5kx2mjnBFzy9hVXzgsj+OJsX4A7D+ShuLRs/MRwv8y
	 Zfo+gnvaNH+74m2w8xZMoOCbkB2O/22X44S5X1G8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 432/462] ASoC: cs42l51: Fix some error handling paths in cs42l51_probe()
Date: Wed,  6 Nov 2024 13:05:25 +0100
Message-ID: <20241106120342.179466650@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit d221b844ee79823ffc29b7badc4010bdb0960224 ]

If devm_gpiod_get_optional() fails, we need to disable previously enabled
regulators, as done in the other error handling path of the function.

Also, gpiod_set_value_cansleep(, 1) needs to be called to undo a
potential gpiod_set_value_cansleep(, 0).
If the "reset" gpio is not defined, this additional call is just a no-op.

This behavior is the same as the one already in the .remove() function.

Fixes: 11b9cd748e31 ("ASoC: cs42l51: add reset management")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/a5e5f4b9fb03f46abd2c93ed94b5c395972ce0d1.1729975570.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs42l51.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/cs42l51.c b/sound/soc/codecs/cs42l51.c
index 07371e32167c8..7fa0a849e65f4 100644
--- a/sound/soc/codecs/cs42l51.c
+++ b/sound/soc/codecs/cs42l51.c
@@ -740,8 +740,10 @@ int cs42l51_probe(struct device *dev, struct regmap *regmap)
 
 	cs42l51->reset_gpio = devm_gpiod_get_optional(dev, "reset",
 						      GPIOD_OUT_LOW);
-	if (IS_ERR(cs42l51->reset_gpio))
-		return PTR_ERR(cs42l51->reset_gpio);
+	if (IS_ERR(cs42l51->reset_gpio)) {
+		ret = PTR_ERR(cs42l51->reset_gpio);
+		goto error;
+	}
 
 	if (cs42l51->reset_gpio) {
 		dev_dbg(dev, "Release reset gpio\n");
@@ -773,6 +775,7 @@ int cs42l51_probe(struct device *dev, struct regmap *regmap)
 	return 0;
 
 error:
+	gpiod_set_value_cansleep(cs42l51->reset_gpio, 1);
 	regulator_bulk_disable(ARRAY_SIZE(cs42l51->supplies),
 			       cs42l51->supplies);
 	return ret;
-- 
2.43.0



