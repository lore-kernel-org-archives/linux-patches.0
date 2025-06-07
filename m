Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FA0715D1;
	Sat,  7 Jun 2025 10:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749290966; cv=none; b=dO1sVr9smRRh6XPbfpLLb87SnODXQWjACsPtlAJKX3NI4FJ7Qthg3GUSZUnLi1Nc+NalJb4M4ksDY3QQm0z5/fJFCPuGcfMRiaRBf/QHL19Qxg2f79Ce3VPZ6Szg8DnurWjEC8r+pb5OegddGp34VZ6fl3yyu1kxNUSI/klzoZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749290966; c=relaxed/simple;
	bh=1p6tAc0zKqUlOmTe5z9RHLAhEDmRoD3XGqqXgbTpFjs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gYZbf/HFw7VT5ChYnny2rHNGiv0+3cpI5vRZRXVAwGd/OYIJHUXFaAXTSUx9epuYFfPzxMmu0MS2+qFndAuhuC9ulpMA3SzcZAwmO2iM2KFopY4P4Ii4SXORuhSjbbZXuT9AfhZ1iVxaOHEV1HJ0VnIzrjPm4ijOjiPAXmMfL3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JtUZdgKS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JtUZdgKS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1B93C4CEE4;
	Sat,  7 Jun 2025 10:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1749290966;
	bh=1p6tAc0zKqUlOmTe5z9RHLAhEDmRoD3XGqqXgbTpFjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JtUZdgKS0QGtJp8xt6CObtzVKkQPbkkKPpCn9eID26u05CSyGiQe2uSWcoAMG2pfZ
	 n/0vytympBELollpjsPk2qP8/4NF6fXm4mgrWQ511ouuxmoUr28ZXIYpDvcDlChDjm
	 sr5icwk/A9WL5ynKDVlgpSyafqnPIh/dA2U5CUv0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Imre Kaloz <kaloz@openwrt.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Gabor Juhos <j4g8y7@gmail.com>,
	Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 6.14 02/24] pinctrl: armada-37xx: use correct OUTPUT_VAL register for GPIOs > 31
Date: Sat,  7 Jun 2025 12:07:42 +0200
Message-ID: <20250607100717.803884635@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250607100717.706871523@linuxfoundation.org>
References: <20250607100717.706871523@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gabor Juhos <j4g8y7@gmail.com>

commit 947c93eb29c2a581c0b0b6d5f21af3c2b7ff6d25 upstream.

The controller has two consecutive OUTPUT_VAL registers and both
holds output value for 32 GPIOs. Due to a missing adjustment, the
current code always uses the first register while setting the
output value whereas it should use the second one for GPIOs > 31.

Add the missing armada_37xx_update_reg() call to adjust the register
according to the 'offset' parameter of the function to fix the issue.

Cc: stable@vger.kernel.org
Fixes: 6702abb3bf23 ("pinctrl: armada-37xx: Fix direction_output() callback behavior")
Signed-off-by: Imre Kaloz <kaloz@openwrt.org>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Gabor Juhos <j4g8y7@gmail.com>
Link: https://lore.kernel.org/20250514-pinctrl-a37xx-fixes-v2-1-07e9ac1ab737@gmail.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pinctrl/mvebu/pinctrl-armada-37xx.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c
+++ b/drivers/pinctrl/mvebu/pinctrl-armada-37xx.c
@@ -417,6 +417,7 @@ static int armada_37xx_gpio_direction_ou
 					     unsigned int offset, int value)
 {
 	struct armada_37xx_pinctrl *info = gpiochip_get_data(chip);
+	unsigned int val_offset = offset;
 	unsigned int reg = OUTPUT_EN;
 	unsigned int mask, val, ret;
 
@@ -429,6 +430,8 @@ static int armada_37xx_gpio_direction_ou
 		return ret;
 
 	reg = OUTPUT_VAL;
+	armada_37xx_update_reg(&reg, &val_offset);
+
 	val = value ? mask : 0;
 	regmap_update_bits(info->regmap, reg, mask, val);
 


