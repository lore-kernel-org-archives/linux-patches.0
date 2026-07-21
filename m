Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9279F25228D;
	Tue, 21 Jul 2026 15:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648731; cv=none; b=eGuxDgI3SXTDZh/a9iNXdKludEyiUk2VS2XTaI5G0xa+xrQWLZ2NoV0MvnRVLpgf4XzmF/7r6v3xFf0+tOFzNCHWD8EEebgmVmHn5NF9IGTPQzu9wSeoypRIcEWrYWST0pLi0sM+/iEJwdZfQi28jsxTTPEaX26zAu88r4PBaCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648731; c=relaxed/simple;
	bh=wJs33Kq0YTbrJ/u2bHJbPw7jTsdG4zEEl5GKsn+1tQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lk+Xo26eu4tGOYqa5egAV5aNQhKf6mQhtviACMDRfmvC/+ER4C0OAXq3jQ4ODz1dj1EXJqqLK4cmVNUr676lq3OsSF7h5mFfoxivK9lfDfnpdGC1Aqkd9D7HlKURr5oLsH/U1Dap3pFdAGAsnK1ntj3btHw8HRzIQ7IZR59e2P4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QFOIo/XW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QFOIo/XW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 049141F000E9;
	Tue, 21 Jul 2026 15:45:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648730;
	bh=mRai6Rs82yTjHwz9riaALdyBjGkUbiBO52vJgNXMhVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QFOIo/XWzh8NyGnjvMo9fz29HLx5XmzUfuDiAIpafP/A/IcjlfcKmL1mZEhlD0tuM
	 ymCHkAuslaa5ejh+2IFIO+mZQLtNLzNMOxo0MXuHFdz+RMYlL3p3EBKfc40i6X6FP7
	 xAymgdsb8spRFH7D9JIUuyAgG6ojjdJCiNGu08/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xianwei Zhao <xianwei.zhao@amlogic.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0308/2077] pinctrl: meson: amlogic-a4: fix gpio output glitch
Date: Tue, 21 Jul 2026 16:59:41 +0200
Message-ID: <20260721152559.945022604@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xianwei Zhao <xianwei.zhao@amlogic.com>

[ Upstream commit 45ad4de324cb1bba88e568b5bef633a79d926aed ]

When the system transitions from bootloader to kernel, the GPIO is
expected to keep driving high.

However, the Linux kernel first configures the pin direction and then
sets the output value. This may cause a brief low-level glitch on the
GPIO line, which can be problematic for regulator control.

By configuring the output value before switching the pin direction to
output, the glitch can be avoided.

This commit fixes the issue by swapping the configuration order.

Fixes: 6e9be3abb78c ("pinctrl: Add driver support for Amlogic SoCs")
Signed-off-by: Xianwei Zhao <xianwei.zhao@amlogic.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/meson/pinctrl-amlogic-a4.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/pinctrl/meson/pinctrl-amlogic-a4.c b/drivers/pinctrl/meson/pinctrl-amlogic-a4.c
index 35d27626a336b7..1bd58fbbd26ac6 100644
--- a/drivers/pinctrl/meson/pinctrl-amlogic-a4.c
+++ b/drivers/pinctrl/meson/pinctrl-amlogic-a4.c
@@ -548,11 +548,11 @@ static int aml_pinconf_set_output_drive(struct aml_pinctrl *info,
 {
 	int ret;
 
-	ret = aml_pinconf_set_output(info, pin, true);
+	ret = aml_pinconf_set_drive(info, pin, high);
 	if (ret)
 		return ret;
 
-	return aml_pinconf_set_drive(info, pin, high);
+	return aml_pinconf_set_output(info, pin, true);
 }
 
 static int aml_pinconf_set(struct pinctrl_dev *pcdev, unsigned int pin,
@@ -921,15 +921,14 @@ static int aml_gpio_direction_output(struct gpio_chip *chip, unsigned int gpio,
 	unsigned int bit, reg;
 	int ret;
 
-	aml_gpio_calc_reg_and_bit(bank, AML_REG_DIR, gpio, &reg, &bit);
-	ret = regmap_update_bits(bank->reg_gpio, reg, BIT(bit), 0);
+	aml_gpio_calc_reg_and_bit(bank, AML_REG_OUT, gpio, &reg, &bit);
+	ret = regmap_update_bits(bank->reg_gpio, reg, BIT(bit),
+				 value ? BIT(bit) : 0);
 	if (ret < 0)
 		return ret;
 
-	aml_gpio_calc_reg_and_bit(bank, AML_REG_OUT, gpio, &reg, &bit);
-
-	return regmap_update_bits(bank->reg_gpio, reg, BIT(bit),
-				  value ? BIT(bit) : 0);
+	aml_gpio_calc_reg_and_bit(bank, AML_REG_DIR, gpio, &reg, &bit);
+	return regmap_update_bits(bank->reg_gpio, reg, BIT(bit), 0);
 }
 
 static int aml_gpio_set(struct gpio_chip *chip, unsigned int gpio, int value)
-- 
2.53.0



