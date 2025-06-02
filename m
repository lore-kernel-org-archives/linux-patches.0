Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A827C1CBA18;
	Mon,  2 Jun 2025 14:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874453; cv=none; b=R/jdA+DDmRZk6it5oEAz0UEw6QnujCeMglL/peZVOe9rshxlwaIxzqNT4iTPe4Q8WRShW+MdNRQct4HamEXa1ZuA/yG49vwcYGbaw0+1Roj9kJxdCTh56bC+4C33O9Knp64EfwTwRuY+XAj8Glp0+Yq8Bh90CNBsigbHoINP9w8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874453; c=relaxed/simple;
	bh=Aequtit8cCk3Wwwfdcj0pJJVQc6wUQjEDncnhK6TmxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jX0yTRC5BWMAZyKi63zdKjN1qB2m/IASQvOrbRRo85Ir/YO+3rJk+RElBpe/gSMgA3jKqxYoop4T/WTB8jtaw0JjPbUvCFmDezpwcPb5ypZop95MnagyrUHbDrvFxkHBcEVtWqsdrfiq6w8VrzAWa50KOhEcdV2xx9DGzc8MVH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z5+IAWr1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z5+IAWr1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 173BCC4CEEB;
	Mon,  2 Jun 2025 14:27:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874453;
	bh=Aequtit8cCk3Wwwfdcj0pJJVQc6wUQjEDncnhK6TmxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z5+IAWr1tDbst/vr6SHBXkS6VvPawOMb5UZbtheyCRHiCsPguy8leOofFeARvC0yO
	 11gCDLK5kMUURSUNlavpiWrLleLumAgLX2ZO0f5+pd0UCzW80h8BWTP2nRTY2QhZP3
	 LjHMk2lT4OSaXzEXqyCrLNe7ZjpEue1fSzYc4RlY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Chen <peter.chen@kernel.org>,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 028/204] usb: chipidea: ci_hdrc_imx: use dev_err_probe()
Date: Mon,  2 Jun 2025 15:46:01 +0200
Message-ID: <20250602134256.788877722@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134255.449974357@linuxfoundation.org>
References: <20250602134255.449974357@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit 18171cfc3c236a1587dcad9adc27c6e781af4438 ]

Use dev_err_probe() to simplify handling errors in ci_hdrc_imx_probe()

Acked-by: Peter Chen <peter.chen@kernel.org>
Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Link: https://lore.kernel.org/r/20220614120522.1469957-1-alexander.stein@ew.tq-group.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 8c531e0a8c2d ("usb: chipidea: ci_hdrc_imx: implement usb_phy_init() error handling")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/chipidea/ci_hdrc_imx.c | 23 +++++++----------------
 1 file changed, 7 insertions(+), 16 deletions(-)

diff --git a/drivers/usb/chipidea/ci_hdrc_imx.c b/drivers/usb/chipidea/ci_hdrc_imx.c
index 034de11a1ac11..0fd860da9267d 100644
--- a/drivers/usb/chipidea/ci_hdrc_imx.c
+++ b/drivers/usb/chipidea/ci_hdrc_imx.c
@@ -342,12 +342,9 @@ static int ci_hdrc_imx_probe(struct platform_device *pdev)
 		data->pinctrl = devm_pinctrl_get(dev);
 		if (PTR_ERR(data->pinctrl) == -ENODEV)
 			data->pinctrl = NULL;
-		else if (IS_ERR(data->pinctrl)) {
-			if (PTR_ERR(data->pinctrl) != -EPROBE_DEFER)
-				dev_err(dev, "pinctrl get failed, err=%ld\n",
-					PTR_ERR(data->pinctrl));
-			return PTR_ERR(data->pinctrl);
-		}
+		else if (IS_ERR(data->pinctrl))
+			return dev_err_probe(dev, PTR_ERR(data->pinctrl),
+					     "pinctrl get failed\n");
 
 		pinctrl_hsic_idle = pinctrl_lookup_state(data->pinctrl, "idle");
 		if (IS_ERR(pinctrl_hsic_idle)) {
@@ -377,13 +374,9 @@ static int ci_hdrc_imx_probe(struct platform_device *pdev)
 		if (PTR_ERR(data->hsic_pad_regulator) == -ENODEV) {
 			/* no pad regualator is needed */
 			data->hsic_pad_regulator = NULL;
-		} else if (IS_ERR(data->hsic_pad_regulator)) {
-			if (PTR_ERR(data->hsic_pad_regulator) != -EPROBE_DEFER)
-				dev_err(dev,
-					"Get HSIC pad regulator error: %ld\n",
-					PTR_ERR(data->hsic_pad_regulator));
-			return PTR_ERR(data->hsic_pad_regulator);
-		}
+		} else if (IS_ERR(data->hsic_pad_regulator))
+			return dev_err_probe(dev, PTR_ERR(data->hsic_pad_regulator),
+					     "Get HSIC pad regulator error\n");
 
 		if (data->hsic_pad_regulator) {
 			ret = regulator_enable(data->hsic_pad_regulator);
@@ -441,9 +434,7 @@ static int ci_hdrc_imx_probe(struct platform_device *pdev)
 				&pdata);
 	if (IS_ERR(data->ci_pdev)) {
 		ret = PTR_ERR(data->ci_pdev);
-		if (ret != -EPROBE_DEFER)
-			dev_err(dev, "ci_hdrc_add_device failed, err=%d\n",
-					ret);
+		dev_err_probe(dev, ret, "ci_hdrc_add_device failed\n");
 		goto err_clk;
 	}
 
-- 
2.39.5



