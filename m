Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D506B196C7C;
	Tue, 26 Aug 2025 13:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756214265; cv=none; b=D2uGi9w7zuf1UtpOzDbBUWTeRr4EZyAd2EILD1OQA/dl8Ku9QIPtZkxsoG7ZYSv+AcDGJla2/l/BH5w8Rxs2/7R2YUZG7kMbAHCd/oSuBUf948jQHz5WbrQkhsCNqQOnz0ppNmIKb9/HjYN7nYcMiI3++F7iuEmItqCP2ZYYn9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756214265; c=relaxed/simple;
	bh=GOTfFHXAD8fo36C+M+zI7MUpFno2tSRGB4xP7K6rlZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Le1blbe7imMdNQ0fcf7GlzgVABO6x0EBmlJqNvsraDoLiAI1AMyQuyrS//pxsmyiwijwGcfojyyFMPv44PMp82+6aCRfemqnYTC1/aVlcVwQkMFTdUrXHbf9VrWjfEvlcArNANGmfIN+Niy+EEnsTb/+c6sYgflxGIeKsYnq55Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BuSBAzsS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BuSBAzsS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B1C6C4CEF1;
	Tue, 26 Aug 2025 13:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756214265;
	bh=GOTfFHXAD8fo36C+M+zI7MUpFno2tSRGB4xP7K6rlZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BuSBAzsScH62H3DJvUA6p/udOvgYOiZ7Ivr9LaSNiWfneI2+M/JzqGSLNcdXpQ2+h
	 TRgu5ejuhywY3s7q31AtUoMbdDsvUXf/DTvcCKx/CckyGaCawqXOrLhJIc07Uwc2mf
	 5lWM1tzLVxaanhbq6BEDvWY6GGIIxRq7lm+iqD5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 073/482] gpio: wcd934x: check the return value of regmap_update_bits()
Date: Tue, 26 Aug 2025 13:05:26 +0200
Message-ID: <20250826110932.638910460@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

[ Upstream commit ff0f0d7c6587e38c308be9905e36f86e98fb9c1f ]

regmap_update_bits() can fail so check its return value in
wcd_gpio_direction_output() for consistency with the rest of the code
and propagate any errors.

Link: https://lore.kernel.org/r/20250709-gpiochip-set-rv-gpio-remaining-v1-2-b8950f69618d@linaro.org
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-wcd934x.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpio-wcd934x.c b/drivers/gpio/gpio-wcd934x.c
index 97e6caedf1f3..c00968ce7a56 100644
--- a/drivers/gpio/gpio-wcd934x.c
+++ b/drivers/gpio/gpio-wcd934x.c
@@ -45,9 +45,12 @@ static int wcd_gpio_direction_output(struct gpio_chip *chip, unsigned int pin,
 				     int val)
 {
 	struct wcd_gpio_data *data = gpiochip_get_data(chip);
+	int ret;
 
-	regmap_update_bits(data->map, WCD_REG_DIR_CTL_OFFSET,
-			   WCD_PIN_MASK(pin), WCD_PIN_MASK(pin));
+	ret = regmap_update_bits(data->map, WCD_REG_DIR_CTL_OFFSET,
+				 WCD_PIN_MASK(pin), WCD_PIN_MASK(pin));
+	if (ret)
+		return ret;
 
 	return regmap_update_bits(data->map, WCD_REG_VAL_CTL_OFFSET,
 				  WCD_PIN_MASK(pin),
-- 
2.39.5



