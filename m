Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F4D42222BA;
	Tue, 26 Aug 2025 12:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756212849; cv=none; b=spsLWIJUO2Iyg8ZYhmxE98L3J2f0mVmbF+0v4x+aA5jC5KMLZWTZWoo1lkG6j9m1lTqtB04vQkY5lDWSob2vhR6TK4IPJY+ZrhbVcLNCSVKVUCofzrVHU6dPyRylWoM4ViDCCUfsFSgYA1ArSUxmpvSeEAF1qkuwwtZR+yQfb7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756212849; c=relaxed/simple;
	bh=IZWEiLrz2CNhB59RSFbH2/t3UhZs3hvZaknL6Cs7Itw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=feTJM8ntZKITDAHH1RbBwLXWcdDm8ReQtrtDaftMdLWpwgJoIFzOY0B+kL5qDeFHY/NE82J0cqUAyxno0ei5+pUaPIr2z/QlfC6l+wDQ61sMfSg7aQLKkGI2Ulp1RQOUHl2NtkLnwuIHyEfx4JLB6uTvVGCSDI/Q6ZrkDX68Avo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bPgHegfY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bPgHegfY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32C81C4CEF1;
	Tue, 26 Aug 2025 12:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756212849;
	bh=IZWEiLrz2CNhB59RSFbH2/t3UhZs3hvZaknL6Cs7Itw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bPgHegfYTtdkuYiZuEV3+c9LtB4CRSXA5rqKO6e8VLoeWj1jwjFS1JO+RDBT4g3u3
	 v1IW97aWMaM6nwRUWesiV6vEvfmbuf+WrGszu37tMZVI3AdFHvzvoiwZqpnh1WES6R
	 KAxEw8ni0b3UBSclnJbaWPFZ05DagDVC0RKmo6qo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 094/587] gpio: wcd934x: check the return value of regmap_update_bits()
Date: Tue, 26 Aug 2025 13:04:03 +0200
Message-ID: <20250826110955.331640492@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 2bba27b13947..cfa7b0a50c8e 100644
--- a/drivers/gpio/gpio-wcd934x.c
+++ b/drivers/gpio/gpio-wcd934x.c
@@ -46,9 +46,12 @@ static int wcd_gpio_direction_output(struct gpio_chip *chip, unsigned int pin,
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



