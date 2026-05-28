Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAC5926B973;
	Thu, 28 May 2026 20:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998460; cv=none; b=mdGtPQAgglqtcXLZxmDd6tHVXQDCmO1KLIoGVwhiIYYtGLt42z6cyxrGFT14B2vEGZFcPP6Xd5zB8n7ifnHyvgmFBWHOHGGrXOpDabe4hfYIS2GZt0u7tmUgAoPVvclpsAEQSmm6zh7t++yzuddt1xrzbfJaKCsnvb+yLUEyi8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998460; c=relaxed/simple;
	bh=qSMEBh7K4FvVN7DZX6fWHS666Bm4g/PNb3c3eN8wuOY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TDsNbWCTN0EVxW/Qe90gZE3iGveXu2PudUv516G3e+4psMxyDjJhjMYqkTlPLfjgDqVxWPmdkBK86kcNGJtmZmJ2Hi2pXdXN6JUcZQB7dfleQF3f5VTNXibwx4PqNIYqpoeLt9kxPf/L6MCj2aVi/BUZ2H62xJZj+6hQ7OYb3Ao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kVbx1PUS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kVbx1PUS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F7C91F000E9;
	Thu, 28 May 2026 20:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998459;
	bh=tfyY893uwoSph5S/cwcZ74rctLC1UDVQRFOgeaqDNpE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kVbx1PUSkvpVPPnzxebyacFOvuwNuCV5VAmezRjFIRtI+2AkbmBlYHpGWn57HV828
	 xkNRCcy7msKGqpgTNzYvCJZSD1zA07SivR+C/MyJSz1mMgQlCnsO7rHQy9cGnq5iIZ
	 R9k8uKDzM7Uynf48toJuVMpCrF7L4Dmwnwu/kQoY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xianwei Zhao <xianwei.zhao@amlogic.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 181/461] pinctrl: meson: amlogic-a4: fix deadlock issue
Date: Thu, 28 May 2026 21:45:10 +0200
Message-ID: <20260528194652.312389312@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xianwei Zhao <xianwei.zhao@amlogic.com>

[ Upstream commit e72ce029810390eb987a036fb2c8a5da9a23b685 ]

Accessing the pinconf-pins sysfs node may deadlock.

pinconf_pins_show() holds pctldev->mutex, and the platform driver
calls pinctrl_find_gpio_range_from_pin(), which tries to acquire
the same mutex again, leading to a deadlock.

Use pinctrl_find_gpio_range_from_pin_nolock() to fix this issue.

Fixes: 6e9be3abb78c ("pinctrl: Add driver support for Amlogic SoCs")
Signed-off-by: Xianwei Zhao <xianwei.zhao@amlogic.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/meson/pinctrl-amlogic-a4.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/pinctrl/meson/pinctrl-amlogic-a4.c b/drivers/pinctrl/meson/pinctrl-amlogic-a4.c
index e2293a872dcb7..35d27626a336b 100644
--- a/drivers/pinctrl/meson/pinctrl-amlogic-a4.c
+++ b/drivers/pinctrl/meson/pinctrl-amlogic-a4.c
@@ -292,7 +292,7 @@ static int aml_calc_reg_and_bit(struct pinctrl_gpio_range *range,
 static int aml_pinconf_get_pull(struct aml_pinctrl *info, unsigned int pin)
 {
 	struct pinctrl_gpio_range *range =
-			 pinctrl_find_gpio_range_from_pin(info->pctl, pin);
+			 pinctrl_find_gpio_range_from_pin_nolock(info->pctl, pin);
 	struct aml_gpio_bank *bank = gpio_chip_to_bank(range->gc);
 	unsigned int reg, bit, val;
 	int ret, conf;
@@ -326,7 +326,7 @@ static int aml_pinconf_get_drive_strength(struct aml_pinctrl *info,
 					  u16 *drive_strength_ua)
 {
 	struct pinctrl_gpio_range *range =
-			 pinctrl_find_gpio_range_from_pin(info->pctl, pin);
+			 pinctrl_find_gpio_range_from_pin_nolock(info->pctl, pin);
 	struct aml_gpio_bank *bank = gpio_chip_to_bank(range->gc);
 	unsigned int reg, bit;
 	unsigned int val;
@@ -365,7 +365,7 @@ static int aml_pinconf_get_gpio_bit(struct aml_pinctrl *info,
 				    unsigned int reg_type)
 {
 	struct pinctrl_gpio_range *range =
-			 pinctrl_find_gpio_range_from_pin(info->pctl, pin);
+			 pinctrl_find_gpio_range_from_pin_nolock(info->pctl, pin);
 	struct aml_gpio_bank *bank = gpio_chip_to_bank(range->gc);
 	unsigned int reg, bit, val;
 	int ret;
-- 
2.53.0



