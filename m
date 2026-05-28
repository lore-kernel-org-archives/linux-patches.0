Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 225A82D9787;
	Thu, 28 May 2026 20:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999743; cv=none; b=d21TpCLVX7FQeV9A58pA/U55gGP1DcIHOgImkHhwXs5ikTU6Dvl1FDYuh1BEz5jj7XVrs5ZQd467iITJP8ozy1se4Rs7GQDg35LoxaZJJ1VhY4KwT8zvSdPog7ANhqhwpZHEpuIJcUCMhnEFVMjeA2yXa2A9toayqzwSJEfohFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999743; c=relaxed/simple;
	bh=y6+FKr6AOwywxoafvAO+yESYtQXdTo0rBvQ6AES7vQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tjBqrRcgujbCl3VUjAf67r4GYNbSrEdpvR1ggqRVLBF9coVsvlubq/w62o5r3Sh4/dXsT5rsR7Zp+50Mw8oVT9k6ImDm5EZ3qqd2UtTlYOLJDkQw5Gl0HRXNfKn3tywyxN+K1AnYZb+yTOVMNo7fRXw1T+cFHDlajWC1Zm/ibdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D1bn5arA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D1bn5arA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80D3B1F000E9;
	Thu, 28 May 2026 20:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999742;
	bh=RKCVD79Yg5EJwRMl/7XppFfk6WvAPdoQHUGV2AXikRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D1bn5arAfa6vSUzSfuM92cQn1o+i4J0DVhaE4WsDeklaLMS1VCOolXae+mxPC9H1a
	 6BCBi6y/OUF1nuCTD1tMm0rs49BLz5XdDDYrF5kKD/JTNzjTCu2PARETr4kjQZFApz
	 HCnRg6HtYYb64Cc3e4KdKnBsgOSVRGISaBZf9TIY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xianwei Zhao <xianwei.zhao@amlogic.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 175/377] pinctrl: meson: amlogic-a4: fix deadlock issue
Date: Thu, 28 May 2026 21:46:53 +0200
Message-ID: <20260528194643.491835958@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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



