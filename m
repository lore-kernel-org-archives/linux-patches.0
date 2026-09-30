Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA3B63AD539;
	Wed, 30 Sep 2026 18:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793464; cv=none; b=T9LfsubkY+h15kpnYCqtenNRCdD71f0tS5aLfvzaZqu/GRABpJlXAnhqhiF/wTUbwiPOx6GV1dGmRT/X1NJahbreqruL5NvNcxuz303xrUt/R5GLzOT0vbSv/bnFgI72RDlzB1RI96VvFhUxHblbuyEXikqGuL9u9Hj0PWqVgiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793464; c=relaxed/simple;
	bh=6+5fa7ID/bWUIiK9+tr1cvxXpCfo5VGrzf00f434gjU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FUNZcTQkf0sa1Yj7BCt80JrCAYbN/ALrRHW3SALwTYTD2MK9WucHvtS6nax0vACOtL5k4Y6Olg4tCUywAPvlMX6qvzMXCwHK5wAnlToOVEwnm/ZBoG3qBztU3wM0y9ZhQ9k1Ibw2XuLTBfiXrnDZ5QUjtKO3wre1n/cxxCQKqQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EwXnA9Qz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EwXnA9Qz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 311951F000FF;
	Wed, 30 Sep 2026 18:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793463;
	bh=cUux/DCScA2wT8C4gaaEnJbtaWV9+PUUTVIDt83Ij6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EwXnA9Qzxr3G84W2HcwpECjvrwug2qDnXA1v6a/RukUrOkzcSF3vb3bIfF4Ke91Xh
	 RDd+DGsOWvL1ypWfClbADUE0niJEdsPKu4tsYwM0UgBP7Rkw7ptDkwD0wfxEtl+IoC
	 uNg45O7f5Bs03Cd9Q68j6zzvmkYo6tOncVEq/UoQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Subject: [PATCH 6.18 262/395] gpio: tps65219: Fix TPS65214 GPIO direction programming
Date: Wed, 30 Sep 2026 17:28:44 +0200
Message-ID: <20260930152346.338965483@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 


