Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B77E1314B6D;
	Fri,  7 Aug 2026 15:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116775; cv=none; b=neGEaJumi1neCNTS49hjR5t6pkWaCNojibmu6xe/lWO8JovgYWnqo8w/Cn41JGdr4ag36Z+8WHZxVtXfeUDKUwvZ1OZ92/SfSP+EiZJu3guAl7wRNjVST8Su5bIAEshR7mfiAc1VgQbbh6Dj/tUgb8fRgR4JDklD9ynjFVxuK/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116775; c=relaxed/simple;
	bh=qJ9zCgPGFB+9T/jAhO2GISfyyaHVOICB1t5A+AUosOo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GMh3eIYCd2qwwG+7QHenJ7mIzs2/Q7O3hkm3HWM4JEryvOAukpgIsMZRR88ybTggxou4oss1b2lOtWpA6hEukYGV5BDgb6luGabxj4t/BZ8Ix5CKS8tS0sVb4P1mxQd212j7pB3Up7DUGYnZkmowzvbIIOwcSbbkyaI5nLlkpF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0z7HKgID; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0z7HKgID"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 210F81F000E9;
	Fri,  7 Aug 2026 15:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116774;
	bh=DTNUHbtKCAE+khL4xmhKqTtkzCPwTfh+ha0EgsygNRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0z7HKgIDP9Ay/mE8Tq9LEYENiAnBgWeSVmrxrXzFRxR17xg4fVkQvn6EfV/dXLtQD
	 5QG68eOH5WWvCpKWen0Y0bF1BVZ5NXggzIlO0CsbGP82iTJ+eT9Pe7tCi/jav3NPhe
	 o9FD9lltuMQ5eTLrhUO+BCa+kSH932jCfZ0+smF0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Tran <alex.tran@oss.qualcomm.com>,
	Linus Walleij <linusw@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 086/438] gpio: gpio-by-pinctrl: Apply initial value in direction output wrapper
Date: Fri,  7 Aug 2026 16:34:42 +0200
Message-ID: <20260807143429.815101949@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

From: Alex Tran <alex.tran@oss.qualcomm.com>

[ Upstream commit 67ff4bf723c8bd1f1b10450fa3e8f55762418104 ]

After successfully configuring gpio pin as output, set the
requested initial output value via the existing gpio set
wrapper, so that the pin is not left at its previous level.

Fixes: 7671f4949a6c ("gpio: gpio-by-pinctrl: add pinctrl based generic GPIO driver")
Signed-off-by: Alex Tran <alex.tran@oss.qualcomm.com>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260724-gpio-pinctrl-output-set-val-v2-1-cad55d025636@oss.qualcomm.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-by-pinctrl.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/gpio/gpio-by-pinctrl.c b/drivers/gpio/gpio-by-pinctrl.c
index ddfdc479d38a8..b3b3c11376172 100644
--- a/drivers/gpio/gpio-by-pinctrl.c
+++ b/drivers/gpio/gpio-by-pinctrl.c
@@ -28,12 +28,6 @@ static int pin_control_gpio_get_direction(struct gpio_chip *gc, unsigned int off
 	return GPIO_LINE_DIRECTION_IN;
 }
 
-static int pin_control_gpio_direction_output(struct gpio_chip *chip,
-					     unsigned int offset, int val)
-{
-	return pinctrl_gpio_direction_output(chip, offset);
-}
-
 static int pin_control_gpio_get(struct gpio_chip *chip, unsigned int offset)
 {
 	unsigned long config;
@@ -56,6 +50,18 @@ static int pin_control_gpio_set(struct gpio_chip *chip, unsigned int offset,
 	return pinctrl_gpio_set_config(chip, offset, config);
 }
 
+static int pin_control_gpio_direction_output(struct gpio_chip *chip,
+					     unsigned int offset, int val)
+{
+	int ret;
+
+	ret = pinctrl_gpio_direction_output(chip, offset);
+	if (ret)
+		return ret;
+
+	return pin_control_gpio_set(chip, offset, val);
+}
+
 static int pin_control_gpio_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
-- 
2.53.0



