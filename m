Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCEC030C368;
	Tue, 31 Mar 2026 16:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974894; cv=none; b=V3zE8S29XnDEx8hWWtLqwADz2TvvuLEGBRDdUxfWB+PpLw1TrkS1ZCoAAVGfZ7/7uc7ppxqjf4C4n6iE3Cix+W2x1IrW7a6kE/Kev0V4816ezHpsaUC+qpoV/w4g5+OUHHTECumxvt/iSzcxNUg0Vi1mtFIJlC32hmehndvAZHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974894; c=relaxed/simple;
	bh=HLo1KRcOHLVpD912X2udFEyGyHI7stJhT4w2j0RsR/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QwDrODiTtT+nVGFTJDF4YnCIXSKuoFZU79awz3DE7c1PG6k8UUU7RrDhlJorQyKVphsIdJvURUBzyVeDp4Dn/qMsyUxIdezYeAPUkzRVpLUq/rL56gLSjaPLoLzFmFwJp+0zUAOXUnET95qHtCngelhVJRSK5Dv+pNCD/aNaYIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tbcT7VgI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tbcT7VgI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 524CBC19423;
	Tue, 31 Mar 2026 16:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974894;
	bh=HLo1KRcOHLVpD912X2udFEyGyHI7stJhT4w2j0RsR/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tbcT7VgID+8mpm9oXZmQJAbCMg0INWZAmIHBUnFGBrgcd8oEFxlRScizFgluehpLV
	 ucqDN812NTCnen2zcPjwFhsEBOZD1abrpBwYMxNSEtvyHlHUFs/2z5NJiBkXkHD1Kc
	 UMlGc6ucihM8BDVnYPnM0onPspO9voqgq45Pg5w0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 084/342] pinctrl: qcom: spmi-gpio: implement .get_direction()
Date: Tue, 31 Mar 2026 18:18:37 +0200
Message-ID: <20260331161802.114144729@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Neil Armstrong <neil.armstrong@linaro.org>

[ Upstream commit 263447532463cf4444a3595e835b99a4e90952fa ]

GPIO controller driver should typically implement the .get_direction()
callback as GPIOLIB internals may try to use it to determine the state
of a pin. Since introduction of shared proxy, it prints a warning splat
when using a shared spmi gpio.

The implementation is not easy because the controller supports enabling
the input and output logic at the same time, so we aligns on the
behaviour of the .get() operation and return -EINVAL in other
situations.

Fixes: eadff3024472 ("pinctrl: Qualcomm SPMI PMIC GPIO pin controller driver")
Fixes: d7b5f5cc5eb4 ("pinctrl: qcom: spmi-gpio: Add support for GPIO LV/MV subtype")
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/qcom/pinctrl-spmi-gpio.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/pinctrl/qcom/pinctrl-spmi-gpio.c b/drivers/pinctrl/qcom/pinctrl-spmi-gpio.c
index 83f940fe30b26..d02d42513ebbc 100644
--- a/drivers/pinctrl/qcom/pinctrl-spmi-gpio.c
+++ b/drivers/pinctrl/qcom/pinctrl-spmi-gpio.c
@@ -723,6 +723,21 @@ static const struct pinconf_ops pmic_gpio_pinconf_ops = {
 	.pin_config_group_dbg_show	= pmic_gpio_config_dbg_show,
 };
 
+static int pmic_gpio_get_direction(struct gpio_chip *chip, unsigned pin)
+{
+	struct pmic_gpio_state *state = gpiochip_get_data(chip);
+	struct pmic_gpio_pad *pad;
+
+	pad = state->ctrl->desc->pins[pin].drv_data;
+
+	if (!pad->is_enabled || pad->analog_pass ||
+	    (!pad->input_enabled && !pad->output_enabled))
+		return -EINVAL;
+
+	/* Make sure the state is aligned on what pmic_gpio_get() returns */
+	return pad->input_enabled ? GPIO_LINE_DIRECTION_IN : GPIO_LINE_DIRECTION_OUT;
+}
+
 static int pmic_gpio_direction_input(struct gpio_chip *chip, unsigned pin)
 {
 	struct pmic_gpio_state *state = gpiochip_get_data(chip);
@@ -801,6 +816,7 @@ static void pmic_gpio_dbg_show(struct seq_file *s, struct gpio_chip *chip)
 }
 
 static const struct gpio_chip pmic_gpio_gpio_template = {
+	.get_direction		= pmic_gpio_get_direction,
 	.direction_input	= pmic_gpio_direction_input,
 	.direction_output	= pmic_gpio_direction_output,
 	.get			= pmic_gpio_get,
-- 
2.51.0



