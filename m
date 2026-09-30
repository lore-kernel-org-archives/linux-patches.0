Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CACBE389104;
	Wed, 30 Sep 2026 17:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790787662; cv=none; b=rxjAD/WwbycoZMbOHVxlDxs5MLEPUSzFI5yjXTawjG3Td91VFVRsEDE6iOhDQeKKEThyniEFRUlqlB0n6J0J4TlFx0pG7ju2QxwdYlQTHPihIxfgIUVBKk4w27ltiJWU7b1+ZcQP9WwC4oKG40kY202r6+XZ7JJhmSmdyQ/Yooo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790787662; c=relaxed/simple;
	bh=kLcNHpcIzMP+mMQm2d1X01wV3gJVODgnI/WeculhEM0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DZLMVskm5U7/UxMVQeGfkaTv4E2IVdvcDcdbD1ws5P3H64VInH6MSKl6V0VmJT00smT19c98couWCrC8IpHcrU/akffL2iQwy1qQrSi/bt+ckEeZwSAlMGwsXrNIQ6xTuYSLHZqLxO5n/2iFa+rcwZVfyBWf4IiuW2KmzgZuHvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Us+H6RJ7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Us+H6RJ7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30B651F00898;
	Wed, 30 Sep 2026 17:01:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790787661;
	bh=JRYrshIRGQJpsbSF9Vj5Zahhxd5BoPnxkRl9izUsi2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Us+H6RJ7mgSja8KAcKQlKRwHpqExv+NhtgY590l6bjfUKvSRl/GQY4E9OO0FmXB5k
	 rf49SB6JT6ZPtVhZ3LuJshAtKjA9FwdtgyBGdpLLSz79hCsmNXeKr74c/srCWZbHMz
	 SvsjBmVDHvwJ9oTj6ifCxYZKSfmlvTEzvN8vorA0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 7.2 310/457] gpio: tps65219: Fix TPS65214 GPIO direction programming
Date: Wed, 30 Sep 2026 17:26:55 +0200
Message-ID: <20260930152352.717351308@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

commit 270437f3fe62516f16482742a7762a075e7a9457 upstream.

GPIO_LINE_DIRECTION_OUT and GPIO_LINE_DIRECTION_IN have the values 0
and 1, respectively, while the TPS65214 GPIO_CONFIG field is BIT(1).
regmap_update_bits() masks the supplied value, so passing either
direction value clears the field and selects input mode.

Translate the GPIO direction to the register encoding used by
tps65214_gpio_get_direction(), setting GPIO_CONFIG for output and
clearing it for input.

Fixes: 1b6ab07c0c80 ("gpio: tps65219: Add support for TI TPS65214 PMIC")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Link: https://patch.msgid.link/20260919171100.90430-4-kmehltretter@gmail.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-tps65219.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/gpio/gpio-tps65219.c
+++ b/drivers/gpio/gpio-tps65219.c
@@ -158,8 +158,10 @@ static int tps65214_gpio_change_directio
 	if (ret)
 		dev_err(dev, "GPIO%d configured as VSEL, not GPIO\n", offset);
 
+	val = direction == GPIO_LINE_DIRECTION_OUT ?
+		TPS65214_GPIO0_DIR_MASK : 0;
 	ret = regmap_update_bits(gpio->tps->regmap, TPS65219_REG_GENERAL_CONFIG,
-				 TPS65214_GPIO0_DIR_MASK, direction);
+				 TPS65214_GPIO0_DIR_MASK, val);
 	if (ret)
 		dev_err(dev, "Fail to change direction to %u for GPIO%d.\n", direction, offset);
 


