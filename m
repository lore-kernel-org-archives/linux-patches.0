Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1C2729993E;
	Mon, 12 May 2025 18:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073339; cv=none; b=sOStgaYrlW5fmKUfrb6hg/B4RV6yoeQpXXf3y3qeyFNQTgmHHjqGZ0nPg8/qKbG+gJjQkw7hnUQLOqZRcfNPtgIJQsO1iU/NRW2rcQQ9cFh/di9mKI3fbKo5mF2bQ+vnNukZYXwBLcQYzmcMpXtZrC37iPW4DI1drSF8Yjp09mI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073339; c=relaxed/simple;
	bh=yQaqMIk0c/7Y3ivut5NyuuUehRw4eRZgolyj7Mr9MNM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JAOX/DuJSZZYb8btuA8P0cFd6nqpHtiq0YRYCbJzgWDPWtaMcXnWge8ZiWmNwQ04bSsbGKC5VkqkDnrLNkPIKgWznje6I06u2EP4pyj2jfQZ2dumlBr6BVoGrU8e8ojtZR3N9Z2cUuUQwSmbPz3ECSazkGlIdasvTFJXLd946QE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TuwpPEpR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TuwpPEpR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 774B6C4CEE9;
	Mon, 12 May 2025 18:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747073337;
	bh=yQaqMIk0c/7Y3ivut5NyuuUehRw4eRZgolyj7Mr9MNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TuwpPEpRUdpXPowdthERiVpDNLPN+2Gb1xr7cxsRI0d0Y8TuLd88CoZQE7OyG0e5n
	 vnithErfOklyKx+EQnSso9LDp6Q0vptmNOUiSGXT5Sl6igyI4rRfTCDEZ2oQtffgA8
	 MPsuz0ZiXr0sW69GtQTJsEy5jGitC96XDSE/NDYc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Xue <xxm@rock-chips.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.6 043/113] iio: adc: rockchip: Fix clock initialization sequence
Date: Mon, 12 May 2025 19:45:32 +0200
Message-ID: <20250512172029.422637805@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172027.691520737@linuxfoundation.org>
References: <20250512172027.691520737@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -485,15 +485,6 @@ static int rockchip_saradc_probe(struct
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
@@ -520,6 +511,14 @@ static int rockchip_saradc_probe(struct
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
 


