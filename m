Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 245C631076C;
	Mon, 13 Oct 2025 15:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369027; cv=none; b=Dcq79EMGHcMYawNgA8mshFRSiIkdoqV+g2EECy8YQlagdmi/r0PfEA5WYPApuuWYY8QjUnsPFwRbq28OwxtIayO+d5OdKNUqfjp6nplBM73UqDs7PH5ooVORMFLh2hHNRjSYn6sBxHeGSuuEK+6Tvj7khXauNKP6wAOGLJ4hq7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369027; c=relaxed/simple;
	bh=bKpdGkHDNMJ4nU6Q0ctE8ZEPrDRdXHFDU94xXQsDWQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hkUqmOJw7sRKovJt3YZbVRU5dx3fX+sHLhR7367r/a7gS6W65r9ijgqEL9dYYrQ/e59pvL11KnUazrZ58oYFYD26a/dNagetxR619vIRVWG96yd/gMv8A/C5SAssKS1C0g3/pv3kbDisvrvm41iZuQ53R2yYYrP4cW4dUK9cQso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XaYwu5Od; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XaYwu5Od"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9458EC4CEE7;
	Mon, 13 Oct 2025 15:23:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369027;
	bh=bKpdGkHDNMJ4nU6Q0ctE8ZEPrDRdXHFDU94xXQsDWQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XaYwu5Oduzek/MdlFDw4nG3GS3Rnr3IIk+A3HXPjZZfLhfu++qbnEKq7xgVabSd62
	 5NMAJefrReEwV4f7bk1P9JCK22MQIFbC0aDm3lsknx5+1VqNx4XyxvIqv0V3MK9+df
	 TMXFF1M+PhxkTun13AYclNRtrHZCJVbaU2xHNxuQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Yulin Lu <luyulin@eswincomputing.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 103/563] pinctrl: eswin: Fix regulator error check and Kconfig dependency
Date: Mon, 13 Oct 2025 16:39:24 +0200
Message-ID: <20251013144415.026900314@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yulin Lu <luyulin@eswincomputing.com>

[ Upstream commit a6a2f50ab1721343ee2d5d2be888709aa886e3aa ]

Smatch reported the following warning in eic7700_pinctrl_probe():

  drivers/pinctrl/pinctrl-eic7700.c:638 eic7700_pinctrl_probe()
  warn: passing zero to 'PTR_ERR'

The root cause is that devm_regulator_get() may return NULL when
CONFIG_REGULATOR is disabled. In such case, IS_ERR_OR_NULL() triggers
PTR_ERR(NULL) which evaluates to 0, leading to passing a success code
as an error.

However, this driver cannot work without a regulator. To fix this:

 - Change the check from IS_ERR_OR_NULL() to IS_ERR()
 - Update Kconfig to explicitly select REGULATOR and
   REGULATOR_FIXED_VOLTAGE, ensuring that the regulator framework is
   always available.

This resolves the Smatch warning and enforces the correct dependency.

Suggested-by: Dan Carpenter <dan.carpenter@linaro.org>
Fixes: 5b797bcc00ef ("pinctrl: eswin: Add EIC7700 pinctrl driver")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/linux-gpio/aKRGiZ-fai0bv0tG@stanley.mountain/
Signed-off-by: Yulin Lu <luyulin@eswincomputing.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/Kconfig           | 2 ++
 drivers/pinctrl/pinctrl-eic7700.c | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/Kconfig b/drivers/pinctrl/Kconfig
index be1ca8e85754b..0402626c4b98b 100644
--- a/drivers/pinctrl/Kconfig
+++ b/drivers/pinctrl/Kconfig
@@ -211,6 +211,8 @@ config PINCTRL_EIC7700
 	depends on ARCH_ESWIN || COMPILE_TEST
 	select PINMUX
 	select GENERIC_PINCONF
+	select REGULATOR
+	select REGULATOR_FIXED_VOLTAGE
 	help
 	  This driver support for the pin controller in ESWIN's EIC7700 SoC,
 	  which supports pin multiplexing, pin configuration,and rgmii voltage
diff --git a/drivers/pinctrl/pinctrl-eic7700.c b/drivers/pinctrl/pinctrl-eic7700.c
index 4874b55323439..ffcd0ec5c2dc6 100644
--- a/drivers/pinctrl/pinctrl-eic7700.c
+++ b/drivers/pinctrl/pinctrl-eic7700.c
@@ -634,7 +634,7 @@ static int eic7700_pinctrl_probe(struct platform_device *pdev)
 		return PTR_ERR(pc->base);
 
 	regulator = devm_regulator_get(dev, "vrgmii");
-	if (IS_ERR_OR_NULL(regulator)) {
+	if (IS_ERR(regulator)) {
 		return dev_err_probe(dev, PTR_ERR(regulator),
 					 "failed to get vrgmii regulator\n");
 	}
-- 
2.51.0



