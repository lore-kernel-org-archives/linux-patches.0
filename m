Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81EC5285073;
	Mon,  9 Feb 2026 14:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648471; cv=none; b=uiPSPIJ3CnNYbg8u1fKQCkyrHxxd0+pAvVmkU2PAPZYDMN/5liutO751HLF/FpxIyNmTreNIxN59RxEhxeHxYlBv2FiB768PYoETaZy4oT8RhWxdZaE2IMriuOB8J045kHJf1pShxGuxk1OrjTs7cAnpBQ115ysXiohI80Syl/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648471; c=relaxed/simple;
	bh=DIqYog7VmhpNlEIsk6veYqFBf8DpCh12RihqyyhqtlE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SLiX5wo+KImk7L954iy0eMuNNb40EV162KaKPv5+IdY1YzsKLYoiT/AXWCoWAuBLPjjpCbYHTr4jaxjuNYbCMOK/kGf+G93mzf04acCLwqlGrE3ZF0sCRGvwv11fug6BtQUwB3xsNVJX5tatl5GZQ7+dmeeBx+sdeguPPwBzS10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FxWwE6Wk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FxWwE6Wk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4DC4C116C6;
	Mon,  9 Feb 2026 14:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648471;
	bh=DIqYog7VmhpNlEIsk6veYqFBf8DpCh12RihqyyhqtlE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FxWwE6WkLFGfHgVLABT9j8VUvP6L5pdZxy/puS3nQ9rr7YGpeKunpL7DE93O37dJg
	 n8XZc7yH5WY3nejLy0n8xwjialzgbqbAcD5dV7KvHJgqvUfwRjmhpv23rFBgBmPo/F
	 pxI+ayXmVjsGkn06Y+V394yknKMFLAe/EZ/ogpmo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dimitrios Katsaros <patcherwork@gmail.com>,
	Sascha Hauer <s.hauer@pengutronix.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 47/86] ASoC: tlv320adcx140: Propagate error codes during probe
Date: Mon,  9 Feb 2026 15:24:10 +0100
Message-ID: <20260209142306.475711566@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142304.770150175@linuxfoundation.org>
References: <20260209142304.770150175@linuxfoundation.org>
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

From: Dimitrios Katsaros <patcherwork@gmail.com>

[ Upstream commit d89aad92cfd15edbd704746f44c98fe687f9366f ]

When scanning for the reset pin, we could get an -EPROBE_DEFER.
The driver would assume that no reset pin had been defined,
which would mean that the chip would never be powered.

Now we both respect any error we get from devm_gpiod_get_optional.
We also now properly report the missing GPIO definition when
'gpio_reset' is NULL.

Signed-off-by: Dimitrios Katsaros <patcherwork@gmail.com>
Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Link: https://patch.msgid.link/20260113-sound-soc-codecs-tvl320adcx140-v4-3-8f7ecec525c8@pengutronix.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/tlv320adcx140.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/soc/codecs/tlv320adcx140.c b/sound/soc/codecs/tlv320adcx140.c
index 78d95b8be2f29..c4ffbc573412e 100644
--- a/sound/soc/codecs/tlv320adcx140.c
+++ b/sound/soc/codecs/tlv320adcx140.c
@@ -1157,6 +1157,9 @@ static int adcx140_i2c_probe(struct i2c_client *i2c)
 	adcx140->gpio_reset = devm_gpiod_get_optional(adcx140->dev,
 						      "reset", GPIOD_OUT_LOW);
 	if (IS_ERR(adcx140->gpio_reset))
+		return dev_err_probe(&i2c->dev, PTR_ERR(adcx140->gpio_reset),
+				     "Failed to get Reset GPIO\n");
+	if (!adcx140->gpio_reset)
 		dev_info(&i2c->dev, "Reset GPIO not defined\n");
 
 	adcx140->supply_areg = devm_regulator_get_optional(adcx140->dev,
-- 
2.51.0



