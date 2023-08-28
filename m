Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DB64469F
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:35:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55E27C433C8;
	Mon, 28 Aug 2023 10:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693218911;
	bh=F86vrD8I+sQP5e40iuNceCqRxUj4mWrLpSdpeIlAHGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bq8Ul26ngbaJG+BjnD/Ejj+NAklpMX7xjWU3Yowi4NMoOaybJH3Pr/cO7Vr2aZsdW
	 RXes66v/y7nww7Bmhgmqv7RfGY1WbdVNYDbSgglF1FqHUOWMWYPnlLhKhu0KwKW0hR
	 8YZk4zlC0qLI+9AZsKWZ/vSJh9mtHs773wAUOGAs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 118/122] gpio: sim: dispose of irq mappings before destroying the irq_sim domain
Date: Mon, 28 Aug 2023 12:13:53 +0200
Message-ID: <20230828101200.352990407@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101156.480754469@linuxfoundation.org>
References: <20230828101156.480754469@linuxfoundation.org>
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

From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>

[ Upstream commit ab4109f91b328ff5cb5e1279f64d443241add2d1 ]

If a GPIO simulator device is unbound with interrupts still requested,
we will hit a use-after-free issue in __irq_domain_deactivate_irq(). The
owner of the irq domain must dispose of all mappings before destroying
the domain object.

Fixes: cb8c474e79be ("gpio: sim: new testing module")
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-sim.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/gpio/gpio-sim.c b/drivers/gpio/gpio-sim.c
index fef12e57b1f13..3fa123bb72ee1 100644
--- a/drivers/gpio/gpio-sim.c
+++ b/drivers/gpio/gpio-sim.c
@@ -290,6 +290,15 @@ static void gpio_sim_mutex_destroy(void *data)
 	mutex_destroy(lock);
 }
 
+static void gpio_sim_dispose_mappings(void *data)
+{
+	struct gpio_sim_chip *chip = data;
+	unsigned int i;
+
+	for (i = 0; i < chip->gc.ngpio; i++)
+		irq_dispose_mapping(irq_find_mapping(chip->irq_sim, i));
+}
+
 static void gpio_sim_sysfs_remove(void *data)
 {
 	struct gpio_sim_chip *chip = data;
@@ -402,6 +411,10 @@ static int gpio_sim_add_bank(struct fwnode_handle *swnode, struct device *dev)
 	if (IS_ERR(chip->irq_sim))
 		return PTR_ERR(chip->irq_sim);
 
+	ret = devm_add_action_or_reset(dev, gpio_sim_dispose_mappings, chip);
+	if (ret)
+		return ret;
+
 	mutex_init(&chip->lock);
 	ret = devm_add_action_or_reset(dev, gpio_sim_mutex_destroy,
 				       &chip->lock);
-- 
2.40.1



