Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0B7A8C1D
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:32:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71697C433C0;
	Mon, 26 Jun 2023 18:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687804362;
	bh=p2c/fsZVR1q17O9Mbz59vsNHZuabw0cBqcIoKlMHk7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L7oGtYrkHYALmiRYP5+2vCHGR/gYGTU2IFvoC7jEKC1VCBHVPY3H58Ze6KozNdDzq
	 lnkj+pu/t6H1CEoIpHOEXio0wmbPi92W9XN2QFKtKGwe2l1XBDSINJrPM3J9R/b56n
	 fPN8/1QIB0PKFXOe277R1Xq7/CumGjvPg282hWtg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiasheng@iscas.ac.cn>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 130/170] gpio: sifive: add missing check for platform_get_irq
Date: Mon, 26 Jun 2023 20:11:39 +0200
Message-ID: <20230626180806.405691454@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180800.476539630@linuxfoundation.org>
References: <20230626180800.476539630@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit c1bcb976d8feb107ff2c12caaf12ac5e70f44d5f ]

Add the missing check for platform_get_irq() and return error code
if it fails.

The returned error code will be dealed with in
builtin_platform_driver(sifive_gpio_driver) and the driver will not
be registered.

Fixes: f52d6d8b43e5 ("gpio: sifive: To get gpio irq offset from device tree data")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-sifive.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpio-sifive.c b/drivers/gpio/gpio-sifive.c
index bc5660f61c570..0f1e1226ebbe8 100644
--- a/drivers/gpio/gpio-sifive.c
+++ b/drivers/gpio/gpio-sifive.c
@@ -221,8 +221,12 @@ static int sifive_gpio_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
-	for (i = 0; i < ngpio; i++)
-		chip->irq_number[i] = platform_get_irq(pdev, i);
+	for (i = 0; i < ngpio; i++) {
+		ret = platform_get_irq(pdev, i);
+		if (ret < 0)
+			return ret;
+		chip->irq_number[i] = ret;
+	}
 
 	ret = bgpio_init(&chip->gc, dev, 4,
 			 chip->base + SIFIVE_GPIO_INPUT_VAL,
-- 
2.39.2



