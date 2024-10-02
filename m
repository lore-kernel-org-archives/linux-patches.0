Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E0C61CF28B;
	Wed,  2 Oct 2024 13:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875620; cv=none; b=u6V1Wh9ODmcbUYnmq52K9KY+9xTyTUnv1FSCFiNWikVU9hhNnv40EmSKPP/RMReQ9HA4K3Jd/dVM4WMpbGDv1Dl4pavRJqchxt/7LVLI5XQUVhzfejmbyi5KiuTTvU7p+SUrd+cWfGQkdegNrP1NGpdqKpG8fNtwQfgjPEMM0ZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875620; c=relaxed/simple;
	bh=C3n+OMMLxjtmJZ7taEI5bRFTHiIE1e5l37uYIaBIeXY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ROQNnYIq1olup6Tc1xxEb93YLON3GjuIhPV9aWcsp0nJ4jnYihWgKEUzuXHt0suW0YMrhDWCvkjmOipcbcINR4cEb7MEtFE84K67R6RDBai8Vgu1HeeEYk8Ws4YqaFNzm2EgOW+rhO/XDFOCt5j2mcJLDziC0vvmBWCVLfmE0gY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UJ6DVOIo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UJ6DVOIo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98A50C4CEC5;
	Wed,  2 Oct 2024 13:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875620;
	bh=C3n+OMMLxjtmJZ7taEI5bRFTHiIE1e5l37uYIaBIeXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UJ6DVOIoNJLZlPmSvFnTXesY+lRabsYKs4SxnEy4mRdHq78Vt8qZCv3uKUxNd5DkN
	 QCmI/MPZbQ0rfFfRq1ilXEFnDcbC+Q6nm92OVhmyZcxc0aViBEy85+q7ZjuS4F5zxX
	 o+JAB8SCxTwk1fun2nRZaHXUzgJUgF50OEP8vXyA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linus.walleij@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 164/695] ASoC: tas2781-i2c: Get the right GPIO line
Date: Wed,  2 Oct 2024 14:52:42 +0200
Message-ID: <20241002125829.021789088@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 5856a68d60d39..ea9c6bafa1c3a 100644
--- a/sound/soc/codecs/tas2781-i2c.c
+++ b/sound/soc/codecs/tas2781-i2c.c
@@ -794,7 +794,7 @@ static void tasdevice_parse_dt(struct tasdevice_priv *tas_priv)
 		tas_priv->tasdevice[i].dev_addr = dev_addrs[i];
 
 	tas_priv->reset = devm_gpiod_get_optional(&client->dev,
-			"reset-gpios", GPIOD_OUT_HIGH);
+			"reset", GPIOD_OUT_HIGH);
 	if (IS_ERR(tas_priv->reset))
 		dev_err(tas_priv->dev, "%s Can't get reset GPIO\n",
 			__func__);
-- 
2.43.0



