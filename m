Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24BCE1519B8;
	Mon, 12 May 2025 18:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072877; cv=none; b=sgfAzP8p0EYMisu8xemdMSby48fhL2OHpH1EHF27hobzPh74OD/00M/zLgxACSvXxXpNQq8lj5+bG/bU3OPN97vP1WVEqxATyeFaFTilxfGmzs0+ZAi/L7+9iYRzudpYFudIMusxpohPysecv7uGPHVCvjf5ciSQY6mcQjT+eYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072877; c=relaxed/simple;
	bh=jjdMqora2e5tWmSINpzoSveeEhBXhuIdIs9VAcrbm2c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dJTcF5bT88sbb0l8J4S5bKIDoLVsUWP4/Puy1hIY0PrE2jZPnLoY4Z9FNvSjmF8yMKEs5xUQgdI5UWUNT6SOueDZvlQyuPkKV/P3u2TPc9YIcwUTUygv7rqqPRmtXVkVkdwSFfGgQLlFM1CP8WBBeL705jwx+effB7EKhIS+Cd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UmKNXiMS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UmKNXiMS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AD17C4CEE7;
	Mon, 12 May 2025 18:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072876;
	bh=jjdMqora2e5tWmSINpzoSveeEhBXhuIdIs9VAcrbm2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UmKNXiMSujJ5OLWyNQQnNWUvWgMgCT50OCDhAbGFTu9Un78zswa9gdzqr/78yb864
	 +QSUL6a6KW9E8sC8h1ORfuI1g1ihfDHZtuWaU2kzISMFh4BJBlhq34Hxt8D9fLQpyU
	 8jiyOwccBqUPQtVfEcTduxlszxvT4R+xoSFjQscU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Xue <xxm@rock-chips.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.12 083/184] iio: adc: rockchip: Fix clock initialization sequence
Date: Mon, 12 May 2025 19:44:44 +0200
Message-ID: <20250512172045.205855047@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172041.624042835@linuxfoundation.org>
References: <20250512172041.624042835@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Simon Xue <xxm@rock-chips.com>

commit 839f81de397019f55161c5982d670ac19d836173 upstream.

clock_set_rate should be executed after devm_clk_get_enabled.

Fixes: 97ad10bb2901 ("iio: adc: rockchip_saradc: Make use of devm_clk_get_enabled")
Signed-off-by: Simon Xue <xxm@rock-chips.com>
Reviewed-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patch.msgid.link/20250312062016.137821-1-xxm@rock-chips.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/rockchip_saradc.c |   17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

--- a/drivers/iio/adc/rockchip_saradc.c
+++ b/drivers/iio/adc/rockchip_saradc.c
@@ -480,15 +480,6 @@ static int rockchip_saradc_probe(struct
 	if (info->reset)
 		rockchip_saradc_reset_controller(info->reset);
 
-	/*
-	 * Use a default value for the converter clock.
-	 * This may become user-configurable in the future.
-	 */
-	ret = clk_set_rate(info->clk, info->data->clk_rate);
-	if (ret < 0)
-		return dev_err_probe(&pdev->dev, ret,
-				     "failed to set adc clk rate\n");
-
 	ret = regulator_enable(info->vref);
 	if (ret < 0)
 		return dev_err_probe(&pdev->dev, ret,
@@ -515,6 +506,14 @@ static int rockchip_saradc_probe(struct
 	if (IS_ERR(info->clk))
 		return dev_err_probe(&pdev->dev, PTR_ERR(info->clk),
 				     "failed to get adc clock\n");
+	/*
+	 * Use a default value for the converter clock.
+	 * This may become user-configurable in the future.
+	 */
+	ret = clk_set_rate(info->clk, info->data->clk_rate);
+	if (ret < 0)
+		return dev_err_probe(&pdev->dev, ret,
+				     "failed to set adc clk rate\n");
 
 	platform_set_drvdata(pdev, indio_dev);
 


