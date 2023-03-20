Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 052DF1C03
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 15:05:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A13DC433D2;
	Mon, 20 Mar 2023 15:05:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679324719;
	bh=aP6y2hN6PAY7YGc0CxiCgfE0vpfU317QYCs0eymaevg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1gsDVFYsPsYDV7mrwiAI41hQpMrP8Zrf/HY9ECUbcZGIwGgBbx6o2fO1s+loBkjOB
	 3sywyV3PA3ZbyVKw1kwe8p8YQ03xNZTjH7XbbQ9nwZX0Dm2z9UV+l9f5eC9efzsX2W
	 6MIXIAGyynOO37EMcv6TEhpjQ3y02N3vvwlxMJBI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lars-Peter Clausen <lars@metafoo.de>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 46/99] hwmon: (adm1266) Set `can_sleep` flag for GPIO chip
Date: Mon, 20 Mar 2023 15:54:24 +0100
Message-Id: <20230320145445.307251122@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145443.333824603@linuxfoundation.org>
References: <20230320145443.333824603@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Lars-Peter Clausen <lars@metafoo.de>

[ Upstream commit a5bb73b3f5db1a4e91402ad132b59b13d2651ed9 ]

The adm1266 driver uses I2C bus access in its GPIO chip `set` and `get`
implementation. This means these functions can sleep and the GPIO chip
should set the `can_sleep` property to true.

This will ensure that a warning is printed when trying to set or get the
GPIO value from a context that potentially can't sleep.

Fixes: d98dfad35c38 ("hwmon: (pmbus/adm1266) Add support for GPIOs")
Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Link: https://lore.kernel.org/r/20230314093146.2443845-1-lars@metafoo.de
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/pmbus/adm1266.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hwmon/pmbus/adm1266.c b/drivers/hwmon/pmbus/adm1266.c
index c7b373ba92f21..d1b2e936546fd 100644
--- a/drivers/hwmon/pmbus/adm1266.c
+++ b/drivers/hwmon/pmbus/adm1266.c
@@ -301,6 +301,7 @@ static int adm1266_config_gpio(struct adm1266_data *data)
 	data->gc.label = name;
 	data->gc.parent = &data->client->dev;
 	data->gc.owner = THIS_MODULE;
+	data->gc.can_sleep = true;
 	data->gc.base = -1;
 	data->gc.names = data->gpio_names;
 	data->gc.ngpio = ARRAY_SIZE(data->gpio_names);
-- 
2.39.2



