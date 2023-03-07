Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D91ADBA48
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:17:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C9B8C4339E;
	Tue,  7 Mar 2023 18:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678213067;
	bh=/A9/zjeFXgxBwSBXH7SjEL0UTW3/o7r19KzxqbI9GWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o/E7KBErcbumgse7PTVVItBvy2mT3KrE6W1vkqClTVzOUeD46QHPeOdS4pCevfFZe
	 whERU1Zvc/39c7BUzKNx5OXx01vANam7+UiaZyoIHdK+Xliz08p2wu+J94m3YeIOTW
	 wG14GJ1cEuxuDimyRyOSRvCxNDLhRf7cOiLGv0Dg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henning Schild <henning.schild@siemens.com>,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 388/885] leds: simatic-ipc-leds-gpio: Make sure we have the GPIO providing driver
Date: Tue,  7 Mar 2023 17:55:22 +0100
Message-Id: <20230307170019.210224143@linuxfoundation.org>
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

From: Henning Schild <henning.schild@siemens.com>

[ Upstream commit c64964ebee2a415384385205950ee7a05f78451e ]

If we register a "leds-gpio" platform device for GPIO pins that do not
exist we get a -EPROBE_DEFER and the probe will be tried again later.
If there is no driver to provide that pin we will poll forever and also
create a lot of log messages.

So check if that GPIO driver is configured, if so it will come up
eventually. If not, we exit our probe function early and do not even
bother registering the "leds-gpio". This method was chosen over "Kconfig
depends" since this way we can add support for more devices and GPIO
backends more easily without "depends":ing on all GPIO backends.

Fixes: a6c80bec3c93 ("leds: simatic-ipc-leds-gpio: Add GPIO version of Siemens driver")
Signed-off-by: Henning Schild <henning.schild@siemens.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Lee Jones <lee@kernel.org>
Link: https://lore.kernel.org/r/20221007153323.1326-1-henning.schild@siemens.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/simple/simatic-ipc-leds-gpio.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/leds/simple/simatic-ipc-leds-gpio.c b/drivers/leds/simple/simatic-ipc-leds-gpio.c
index 07f0d79d604d4..e8d329b5a68c3 100644
--- a/drivers/leds/simple/simatic-ipc-leds-gpio.c
+++ b/drivers/leds/simple/simatic-ipc-leds-gpio.c
@@ -77,6 +77,8 @@ static int simatic_ipc_leds_gpio_probe(struct platform_device *pdev)
 
 	switch (plat->devmode) {
 	case SIMATIC_IPC_DEVICE_127E:
+		if (!IS_ENABLED(CONFIG_PINCTRL_BROXTON))
+			return -ENODEV;
 		simatic_ipc_led_gpio_table = &simatic_ipc_led_gpio_table_127e;
 		break;
 	case SIMATIC_IPC_DEVICE_227G:
-- 
2.39.2



