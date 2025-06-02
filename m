Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F368E226CF0;
	Mon,  2 Jun 2025 14:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875131; cv=none; b=ayNOF3HrnU0WSGh7+YXKK1Zvp6xfHCSs9Tov8dV+owqdeDQeOGOjiL55HTG2XxizRNDiFDnXKE5es7y5Ci3Bad7Z2JMN4CWCEu9niJuBkATBJI6ltXHHHxnGDu0zQQM+VzmmGYvKo/IcB8EMid603tsN5OnwPy/ptj1EqkriudA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875131; c=relaxed/simple;
	bh=GfVfA42sjQxJVgaWXGYONPVUCCQuUhtTWxfH+S4W/CI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m5am2qeHG/4dM0eF91MMG25YWYSWJ2N47bI/5cfTEx/47p36zCm3ewo+3LziYj5LE0zDOIGiYXH8y1GTS5pbFhcsmU57JYfJki1exDRnRkXn1/hK+CoChJKYtVQtgLK89ZfUOQOIvGn3R55ntK1ztu5+P7U9+94TaIaNuweUtng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=isYySwF/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="isYySwF/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECFD4C4CEEB;
	Mon,  2 Jun 2025 14:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875130;
	bh=GfVfA42sjQxJVgaWXGYONPVUCCQuUhtTWxfH+S4W/CI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=isYySwF/JcNEH3MnLtz/vFBzVmtV6BGVkv1ukDvy7ePOFswqoLH5DiCwf+17v7NbK
	 lxCTPBDMi07uQRdH3X0KaYicNJJg98B1ecVqfKJ2GtW9P0F2ZyvjK15vK3H78ACi5P
	 08Z2D3uPskG6eZa2u7em7BphyTAOeVkopAMJLKUQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Chen <peter.chen@kernel.org>,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 038/270] usb: chipidea: ci_hdrc_imx: use dev_err_probe()
Date: Mon,  2 Jun 2025 15:45:23 +0200
Message-ID: <20250602134308.746064022@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index a54c3cff6c28e..abe162cd729e9 100644
--- a/drivers/usb/chipidea/ci_hdrc_imx.c
+++ b/drivers/usb/chipidea/ci_hdrc_imx.c
@@ -360,25 +360,18 @@ static int ci_hdrc_imx_probe(struct platform_device *pdev)
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
 
 		data->hsic_pad_regulator =
 				devm_regulator_get_optional(dev, "hsic");
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
@@ -470,9 +463,7 @@ static int ci_hdrc_imx_probe(struct platform_device *pdev)
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



