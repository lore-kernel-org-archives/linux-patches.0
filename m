Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBA95455610;
	Thu, 17 Sep 2026 16:05:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661154; cv=none; b=hPeIi9HffGqz1vAWn5AsRMDvocmXrIVRxvWY6QbfS7Maxc8KiAK4nuh6e3VJdPWq/TYQPcdnGilhI14oZ3X2yqKVbac5NnOCHHBIQJdMQ4s11SgKrHCzfTxtrPOwWkvw4/9iOTbAOsnKqhTWXXIAMQDkJ7wtMDvC7pue13ljAH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661154; c=relaxed/simple;
	bh=tt4gyebQjsHiuVexeEABjuZastvc0WppWJ6wmEqn/5Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ebwo+CFXs3W+Xn+7wvyD44ApMmlB0I0C/lK4NCCXUp1RrgK6sEFBwFXV6LSDT0mykwr1Y7Blom+gR8prFM8+aruQELdDnzdVFSKClISjLaNNGY3vgKtbOMRR37bYMaBG8NP/fLk+H9k/K8GxwGgDjaB0Im950v1s/ZgOk4kSyqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OmNRoObH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OmNRoObH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D7FE1F000FF;
	Thu, 17 Sep 2026 16:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789661152;
	bh=fSJpgSdffRkHAzKnCL1SNZb07STXcSEzaY1l1sAzGRA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OmNRoObHjMn9xfSlkuiYt8cfieCerXBkMHZWID7vgtIPy7m/NeLFxHwBwXKShe3GO
	 Ry2gqCyDHIFKbXyBoifNg8tv0I0du6RdFXILtmzvz/xIORTPMUP/LPyACuY0onIxu/
	 3vz29eLZ82ZzOLN4O8c2Fw8U/cvgGFsK2+HUl33g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0100/1250] pinctrl: mediatek: common-v1: bypass pinctrl GPIO layer in set GPIO direction
Date: Thu, 17 Sep 2026 15:58:15 +0100
Message-ID: <20260917151554.702524293@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Chen-Yu Tsai <wenst@chromium.org>

[ Upstream commit 3982db2df3ed4c195e5f0a9a4513545a15901107 ]

pinctrl_gpio_direction_input() / pinctrl_gpio_direction_output() take
the pinctrl mutex. This causes a gpiochip operations to need to sleep.
Worse yet, the .can_sleep field in the gpiochip is not set. This causes
the shared GPIO proxy to trip over, as it uses gpiod_cansleep() to check
whether it can use a spinlock or needs a mutex. In this case, it ends
up taking a spinlock, then calls pinctrl_gpio_direction_output(), which
takes a mutex. This causes a huge warning.

Since the Mediatek hardware has separate clear/set registers, there is
no risk of clobbering other bits like with a read-modify-write pattern.
Also, once the GPIO function is selected / muxed in, further GPIO
operations do not involve pinctrl operations or state. The GPIO direction
and level values do not require toggling the pinmux or any other pin config
options.

Switch to directly calling mtk_pmx_gpio_set_direction() in the GPIO set
direction callbacks to avoid taking the pinctrl mutex. Drop the
.gpio_set_direction field in mtk_pmx_ops to signal we are no longer using
the pinctrl GPIO layer for setting the direction.

Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/mediatek/pinctrl-mtk-common.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/pinctrl/mediatek/pinctrl-mtk-common.c b/drivers/pinctrl/mediatek/pinctrl-mtk-common.c
index 3f518dce6d23f..dd2c8aa039385 100644
--- a/drivers/pinctrl/mediatek/pinctrl-mtk-common.c
+++ b/drivers/pinctrl/mediatek/pinctrl-mtk-common.c
@@ -802,20 +802,27 @@ static const struct pinmux_ops mtk_pmx_ops = {
 	.get_function_name	= mtk_pmx_get_func_name,
 	.get_function_groups	= mtk_pmx_get_func_groups,
 	.set_mux		= mtk_pmx_set_mux,
-	.gpio_set_direction	= mtk_pmx_gpio_set_direction,
 	.gpio_request_enable	= mtk_pmx_gpio_request_enable,
 };
 
+static int mtk_gpio_direction_input(struct gpio_chip *chip, unsigned offset)
+{
+	struct mtk_pinctrl *pctl = gpiochip_get_data(chip);
+
+	return mtk_pmx_gpio_set_direction(pctl->pctl_dev, NULL, offset, true);
+}
+
 static int mtk_gpio_direction_output(struct gpio_chip *chip,
 					unsigned offset, int value)
 {
+	struct mtk_pinctrl *pctl = gpiochip_get_data(chip);
 	int ret;
 
 	ret = mtk_gpio_set(chip, offset, value);
 	if (ret)
 		return ret;
 
-	return pinctrl_gpio_direction_output(chip, offset);
+	return mtk_pmx_gpio_set_direction(pctl->pctl_dev, NULL, offset, false);
 }
 
 static int mtk_gpio_get_direction(struct gpio_chip *chip, unsigned offset)
@@ -895,7 +902,7 @@ static const struct gpio_chip mtk_gpio_chip = {
 	.request		= gpiochip_generic_request,
 	.free			= gpiochip_generic_free,
 	.get_direction		= mtk_gpio_get_direction,
-	.direction_input	= pinctrl_gpio_direction_input,
+	.direction_input	= mtk_gpio_direction_input,
 	.direction_output	= mtk_gpio_direction_output,
 	.get			= mtk_gpio_get,
 	.set			= mtk_gpio_set,
-- 
2.53.0



