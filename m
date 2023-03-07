Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BACBDBA48
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:20:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0021C4339C;
	Tue,  7 Mar 2023 18:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678213223;
	bh=3rPI78Rna/M4IO1jepLaX6WMos6OzFgeOeCiKBqh6OY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=defCtm3bI6jO5jwwFrr3ZwRTX+EDR/qzkel+Y+pFhAbKVV/oh1gnAVF7yew68OdQq
	 5DRIZ00M6r9JbO/jMii5PgZDngHbNBAdK0VIbAzKgIeEFD1HVzG9KQZuAhVm7Z+Mp5
	 uNc9OmCwtiwE0cO3kIU2hVwgNMcU60BcEIOVVu8Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ferry Toth <ftoth@exalondelft.nl>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 408/885] iio: light: tsl2563: Do not hardcode interrupt trigger type
Date: Tue,  7 Mar 2023 17:55:42 +0100
Message-Id: <20230307170020.136939568@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ferry Toth <ftoth@exalondelft.nl>

[ Upstream commit 027641b52fe37b64af61025298ce160c8b9b7a73 ]

Instead of hardcoding IRQ trigger type to IRQF_TRIGGER_RAISING,
let's respect the settings specified in the firmware description.
To be compatible with the older firmware descriptions, if trigger
type is not set up there, we'll set it to default (raising edge).

Fixes: 388be4883952 ("staging:iio: tsl2563 abi fixes and interrupt handling")
Fixes: bdab1001738f ("staging:iio:light:tsl2563 remove old style event registration.")
Signed-off-by: Ferry Toth <ftoth@exalondelft.nl>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20221207190348.9347-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/light/tsl2563.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/light/tsl2563.c b/drivers/iio/light/tsl2563.c
index 951f35ef3f41d..47a4626e94610 100644
--- a/drivers/iio/light/tsl2563.c
+++ b/drivers/iio/light/tsl2563.c
@@ -705,6 +705,7 @@ static int tsl2563_probe(struct i2c_client *client,
 	struct iio_dev *indio_dev;
 	struct tsl2563_chip *chip;
 	struct tsl2563_platform_data *pdata = client->dev.platform_data;
+	unsigned long irq_flags;
 	int err = 0;
 	u8 id = 0;
 
@@ -760,10 +761,15 @@ static int tsl2563_probe(struct i2c_client *client,
 		indio_dev->info = &tsl2563_info_no_irq;
 
 	if (client->irq) {
+		irq_flags = irq_get_trigger_type(client->irq);
+		if (irq_flags == IRQF_TRIGGER_NONE)
+			irq_flags = IRQF_TRIGGER_RISING;
+		irq_flags |= IRQF_ONESHOT;
+
 		err = devm_request_threaded_irq(&client->dev, client->irq,
 					   NULL,
 					   &tsl2563_event_handler,
-					   IRQF_TRIGGER_RISING | IRQF_ONESHOT,
+					   irq_flags,
 					   "tsl2563_event",
 					   indio_dev);
 		if (err) {
-- 
2.39.2



