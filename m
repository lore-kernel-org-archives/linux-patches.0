Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9C7A13AA2F;
	Tue, 12 Aug 2025 18:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024183; cv=none; b=NZu4RFBr0WyJKZvsbvZ/7hF+btfbhi7168/BYfU+/4y+jW4Sjo0yoCGNuERcqbCDrkOoCnRxiC4kcFlcC68k+V7F04QcDlCY13DnPs5mLpksH9xcAsqeo8LJ+kmzDSSdYQpdRlS7e1sxWRSAlIIz6tgtG/zdsLrUXCexhpKlz+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024183; c=relaxed/simple;
	bh=bE2qh0NULCFF4/g6Fqz4N+tZcNlTuCG9hTFtCqncdzQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qan4XbZW0SocliTQuhDINbp71oOk/ps5R6sRNwSXmBmQlBlUBDJXc2j4haPJArh0xTIjaipVOs5IaiqK5drdUcOZhndCbpgspNnX9VNZ/wmE/aN6XeZz7UPyfOeHHp1WNNB8OvaeoPi9mMsDs43A+wpkhA4hFab6w04woeiBQg8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nGW3GARn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nGW3GARn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDE4DC4CEF0;
	Tue, 12 Aug 2025 18:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024183;
	bh=bE2qh0NULCFF4/g6Fqz4N+tZcNlTuCG9hTFtCqncdzQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nGW3GARnVpiffs8juFVnsjJwRnHwadG3KTnfCoB4gW6RhcNa0FiJR3Nu2FnBKO2Wu
	 AXeyz1+avRVxuCQovFMyhNOdQuHkI6tEPgFGqU3nSU2ctxgm21AqF3RpbyvQQQKLK2
	 I96yQQWmjRrrdyKRC72c+lsAah+GmMRrT/KT9br8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Richard <thomas.richard@bootlin.com>,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 298/627] pinctrl: cirrus: madera-core: Use devm_pinctrl_register_mappings()
Date: Tue, 12 Aug 2025 19:29:53 +0200
Message-ID: <20250812173430.641780740@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Richard <thomas.richard@bootlin.com>

[ Upstream commit 90256033c11028a57437b145449c0dab196183b9 ]

Use devm_pinctrl_register_mappings(), so the mappings are automatically
unregistered by the core. If pinctrl_enable() failed during the probe,
pinctrl_mappings were not freed. Now it is done by the core.

Fixes: 218d72a77b0b ("pinctrl: madera: Add driver for Cirrus Logic Madera codecs")
Signed-off-by: Thomas Richard <thomas.richard@bootlin.com>
Reviewed-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Link: https://lore.kernel.org/20250609-pinctrl-madera-devm-pinctrl-register-mappings-v1-1-ba2c2822cf6c@bootlin.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/cirrus/pinctrl-madera-core.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/drivers/pinctrl/cirrus/pinctrl-madera-core.c b/drivers/pinctrl/cirrus/pinctrl-madera-core.c
index 73ec5b9beb49..d19ef13224cc 100644
--- a/drivers/pinctrl/cirrus/pinctrl-madera-core.c
+++ b/drivers/pinctrl/cirrus/pinctrl-madera-core.c
@@ -1061,8 +1061,9 @@ static int madera_pin_probe(struct platform_device *pdev)
 
 	/* if the configuration is provided through pdata, apply it */
 	if (pdata->gpio_configs) {
-		ret = pinctrl_register_mappings(pdata->gpio_configs,
-						pdata->n_gpio_configs);
+		ret = devm_pinctrl_register_mappings(priv->dev,
+						     pdata->gpio_configs,
+						     pdata->n_gpio_configs);
 		if (ret)
 			return dev_err_probe(priv->dev, ret,
 						"Failed to register pdata mappings\n");
@@ -1081,17 +1082,8 @@ static int madera_pin_probe(struct platform_device *pdev)
 	return 0;
 }
 
-static void madera_pin_remove(struct platform_device *pdev)
-{
-	struct madera_pin_private *priv = platform_get_drvdata(pdev);
-
-	if (priv->madera->pdata.gpio_configs)
-		pinctrl_unregister_mappings(priv->madera->pdata.gpio_configs);
-}
-
 static struct platform_driver madera_pin_driver = {
 	.probe = madera_pin_probe,
-	.remove = madera_pin_remove,
 	.driver = {
 		.name = "madera-pinctrl",
 	},
-- 
2.39.5



