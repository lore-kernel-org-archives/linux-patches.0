Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26FB527732;
	Thu, 16 Jul 2026 14:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211712; cv=none; b=S9unTSWeEw50+/xDKYpch+bkHD4brjjX4OKq8jfMVAcnLZOXnK2MfkiLAh89Jj08LpY/GoLcinvaFJ/48bVap7OSdlTyP2e5kX/QS0ddQlFVWSDmPlCPKt3f3SmXiAOrONhpJ2sLxUqo2wOTH4rZ9qFDIC6paAoWhbfTsGNfmuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211712; c=relaxed/simple;
	bh=sLS1QvFsAE7EnT1UMF+E1z7Iz7WIZmrUaaynhrN5Ohw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FHEfuBoohnHVFBw0nWnbcXBhTCn3K2tvMwy3wmWMQ39Fn8a6egnBpwpKGxlSjYF40KpgGW6ttmxJE2Yl8Umn9D40lu28oOFf0dFTF86tP+WJxi0Hs/OoCr3AOYpibuth6yp4POnRqzYLREGQbsA1T3YA1payRTybJZ7EdkXNXeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W6zawdoG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W6zawdoG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92EF11F000E9;
	Thu, 16 Jul 2026 14:21:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211711;
	bh=dfnMHycPCKUTjbB4UfFu9MCeY5JPmR3A415/d3M5dHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W6zawdoGFxsJXSwIDFwxisEY7ELe8nrEvLer2F3/XzKNGXohOpfsf1MDmuVAyj6Oh
	 ENsDod3yT8T10BYYn/t+jOn6RfoQc0VqdqY+snNASm3m1WUWiZCOqd7yrfU2dSVcXZ
	 qIMI1kOTa1akXI1+pYQn0LpCok7yc1UuxRjti26k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ye Zhang <ye.zhang@rock-chips.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Heiko Stuebner <heiko.stuebner@cherry.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 008/349] gpio: rockchip: change the GPIO version judgment logic
Date: Thu, 16 Jul 2026 15:29:02 +0200
Message-ID: <20260716133033.478172171@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ye Zhang <ye.zhang@rock-chips.com>

[ Upstream commit 41209307cad7f14c387c68375a93b50e54261a53 ]

Have a list of valid IDs and default to -ENODEV.

Signed-off-by: Ye Zhang <ye.zhang@rock-chips.com>
Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20241112015408.3139996-3-ye.zhang@rock-chips.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Heiko Stuebner <heiko.stuebner@cherry.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-rockchip.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/gpio/gpio-rockchip.c b/drivers/gpio/gpio-rockchip.c
index 052713bd8d07a9..16c1ec3a5d0e79 100644
--- a/drivers/gpio/gpio-rockchip.c
+++ b/drivers/gpio/gpio-rockchip.c
@@ -653,8 +653,9 @@ static int rockchip_get_bank_data(struct rockchip_pin_bank *bank)
 
 	id = readl(bank->reg_base + gpio_regs_v2.version_id);
 
-	/* If not gpio v2, that is default to v1. */
-	if (id == GPIO_TYPE_V2 || id == GPIO_TYPE_V2_1) {
+	switch (id) {
+	case GPIO_TYPE_V2:
+	case GPIO_TYPE_V2_1:
 		bank->gpio_regs = &gpio_regs_v2;
 		bank->gpio_type = GPIO_TYPE_V2;
 		bank->db_clk = of_clk_get(bank->of_node, 1);
@@ -662,9 +663,14 @@ static int rockchip_get_bank_data(struct rockchip_pin_bank *bank)
 			dev_err(bank->dev, "cannot find debounce clk\n");
 			return -EINVAL;
 		}
-	} else {
+		break;
+	case GPIO_TYPE_V1:
 		bank->gpio_regs = &gpio_regs_v1;
 		bank->gpio_type = GPIO_TYPE_V1;
+		break;
+	default:
+		dev_err(bank->dev, "unsupported version ID: 0x%08x\n", id);
+		return -ENODEV;
 	}
 
 	return 0;
-- 
2.53.0



