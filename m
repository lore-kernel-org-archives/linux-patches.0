Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E021A61674;
	Tue, 14 May 2024 11:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686356; cv=none; b=XQozHT+55Y3SYcisSjnyjEKM1RHxRfBW97Hckzu+mqyDSQ6jmgWVZ9o3WxSQTQMyn7w0Xc6a2cqdIZ1mnpDONEMqr3MWvCV2GSvcu6xf0NxWMr/bzVi4xh18n+V0cQOzLxM2AXWySG/2vhWYP8YUJ+nMACBx/sTry0b6/xQDeyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686356; c=relaxed/simple;
	bh=9K0Qxqhg0mqmkISy610FMYzNoxCizTQV2HS7OiKEwCA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g8UkKUbgIUvLkQlWAzRtOqb+kO+S7Prf72Coh4ljPtBn+8PQMsJPEitDD6tTSqcNE4M4EKW9lweZPiaZ67fKSVgDOVAS7UsTc2BDhDpRLPMfRDx0cEjP4Qp3lNQXC35+Skob8Uf6hWeNV5CVDJ6LOhAY+2TlXu6QJy95GUNIaUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nba9QwIu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nba9QwIu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6865EC2BD10;
	Tue, 14 May 2024 11:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686355;
	bh=9K0Qxqhg0mqmkISy610FMYzNoxCizTQV2HS7OiKEwCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nba9QwIu/eHXczQ7Nr5qvWYXsWpBuRn+sbvqUqtPmZMZIBTNj5ZeZZ/Mj0+vbN5ZI
	 urIfj09129/8/Hm2zMHXVqwGB7uJRiY7Ll588mtLncvps/36qAkv1lxOCLpmwt7FZz
	 5UkUK42EjWYvQilh/wbr5Na8q5kLIVL8b7MrFz2g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sui Jingfeng <sui.jingfeng@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 082/236] drm/panel: ili9341: Respect deferred probe
Date: Tue, 14 May 2024 12:17:24 +0200
Message-ID: <20240514101023.483648743@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 740fc1e0509be3f7e2207e89125b06119ed62943 ]

GPIO controller might not be available when driver is being probed.
There are plenty of reasons why, one of which is deferred probe.

Since GPIOs are optional, return any error code we got to the upper
layer, including deferred probe. With that in mind, use dev_err_probe()
in order to avoid spamming the logs.

Fixes: 5a04227326b0 ("drm/panel: Add ilitek ili9341 panel driver")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Reviewed-by: Sui Jingfeng <sui.jingfeng@linux.dev>
Link: https://lore.kernel.org/r/20240425142706.2440113-3-andriy.shevchenko@linux.intel.com
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20240425142706.2440113-3-andriy.shevchenko@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-ilitek-ili9341.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/panel/panel-ilitek-ili9341.c b/drivers/gpu/drm/panel/panel-ilitek-ili9341.c
index 39dc40cf681f0..c46b5d820f5a0 100644
--- a/drivers/gpu/drm/panel/panel-ilitek-ili9341.c
+++ b/drivers/gpu/drm/panel/panel-ilitek-ili9341.c
@@ -717,11 +717,11 @@ static int ili9341_probe(struct spi_device *spi)
 
 	reset = devm_gpiod_get_optional(dev, "reset", GPIOD_OUT_HIGH);
 	if (IS_ERR(reset))
-		dev_err(dev, "Failed to get gpio 'reset'\n");
+		return dev_err_probe(dev, PTR_ERR(reset), "Failed to get gpio 'reset'\n");
 
 	dc = devm_gpiod_get_optional(dev, "dc", GPIOD_OUT_LOW);
 	if (IS_ERR(dc))
-		dev_err(dev, "Failed to get gpio 'dc'\n");
+		return dev_err_probe(dev, PTR_ERR(dc), "Failed to get gpio 'dc'\n");
 
 	if (!strcmp(id->name, "sf-tc240t-9370-t"))
 		return ili9341_dpi_probe(spi, dc, reset);
-- 
2.43.0



