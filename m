Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7386417756
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:21:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4342C433C9;
	Wed,  9 Aug 2023 11:21:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691580069;
	bh=A8h31/oX3dqLXdzJMAQvlBClgdzboMUqP23qpJXtQ5U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=axckv4owrTwp5AAwu/dLN7MOd0ggZpRIz7g3hbTGb9eLPjdXG8TEpCfCJXcNoSW2C
	 d9hAW10oUKcMmEwtcCZOyYw4a5vW87Vz/9EazLuHrd0B+G2DFnSLjyitj/0YnppEpi
	 dNkBCo6VGcN3kTL7mANcOCDU6Q0a7swAWm4E45Fc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Daniel Scally <dan.scally@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 217/323] gpio: tps68470: Make tps68470_gpio_output() always set the initial value
Date: Wed,  9 Aug 2023 12:40:55 +0200
Message-ID: <20230809103708.035101638@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103658.104386911@linuxfoundation.org>
References: <20230809103658.104386911@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 5a7adc6c1069ce31ef4f606ae9c05592c80a6ab5 ]

Make tps68470_gpio_output() call tps68470_gpio_set() for output-only pins
too, so that the initial value passed to gpiod_direction_output() is
honored for these pins too.

Fixes: 275b13a65547 ("gpio: Add support for TPS68470 GPIOs")
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Reviewed-by: Daniel Scally <dan.scally@ideasonboard.com>
Tested-by: Daniel Scally <dan.scally@ideasonboard.com>
Reviewed-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-tps68470.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpio/gpio-tps68470.c b/drivers/gpio/gpio-tps68470.c
index aff6e504c6668..9704cff9b4aa3 100644
--- a/drivers/gpio/gpio-tps68470.c
+++ b/drivers/gpio/gpio-tps68470.c
@@ -91,13 +91,13 @@ static int tps68470_gpio_output(struct gpio_chip *gc, unsigned int offset,
 	struct tps68470_gpio_data *tps68470_gpio = gpiochip_get_data(gc);
 	struct regmap *regmap = tps68470_gpio->tps68470_regmap;
 
+	/* Set the initial value */
+	tps68470_gpio_set(gc, offset, value);
+
 	/* rest are always outputs */
 	if (offset >= TPS68470_N_REGULAR_GPIO)
 		return 0;
 
-	/* Set the initial value */
-	tps68470_gpio_set(gc, offset, value);
-
 	return regmap_update_bits(regmap, TPS68470_GPIO_CTL_REG_A(offset),
 				 TPS68470_GPIO_MODE_MASK,
 				 TPS68470_GPIO_MODE_OUT_CMOS);
-- 
2.39.2



