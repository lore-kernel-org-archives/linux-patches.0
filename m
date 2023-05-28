Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DF2E611B
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:38:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFB2DC433D2;
	Sun, 28 May 2023 19:38:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685302685;
	bh=hrgivyb+sD5/81uys1LLnydphck7HBVNV63SYJ2emn0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F8jLbczeGNFfUsWt59XHTrZIHU8M/P9bQwefx9U5zOMcQCcC4sQCURcwEa6YZgtZB
	 Krckh4eQx9mQvBCbMH1mIYmDz5Imqq/nSL3YJtxF0ap+juebHHG2IjT+V4NgIk3yi5
	 +FSI/71baCwKL1vXaYUn5Zph+N3aj2i/+LEKVgJQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 6.1 076/119] power: supply: bq27xxx: Fix I2C IRQ race on remove
Date: Sun, 28 May 2023 20:11:16 +0100
Message-Id: <20230528190838.047196273@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190835.386670951@linuxfoundation.org>
References: <20230528190835.386670951@linuxfoundation.org>
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

commit 444ff00734f3878cd54ddd1ed5e2e6dbea9326d5 upstream.

devm_request_threaded_irq() requested IRQs are only free-ed after
the driver's remove function has ran. So the IRQ could trigger and
call bq27xxx_battery_update() after bq27xxx_battery_teardown() has
already run.

Switch to explicitly free-ing the IRQ in bq27xxx_battery_i2c_remove()
to fix this.

Fixes: 8807feb91b76 ("power: bq27xxx_battery: Add interrupt handling support")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/power/supply/bq27xxx_battery_i2c.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/power/supply/bq27xxx_battery_i2c.c
+++ b/drivers/power/supply/bq27xxx_battery_i2c.c
@@ -179,7 +179,7 @@ static int bq27xxx_battery_i2c_probe(str
 	i2c_set_clientdata(client, di);
 
 	if (client->irq) {
-		ret = devm_request_threaded_irq(&client->dev, client->irq,
+		ret = request_threaded_irq(client->irq,
 				NULL, bq27xxx_battery_irq_handler_thread,
 				IRQF_ONESHOT,
 				di->name, di);
@@ -209,6 +209,7 @@ static void bq27xxx_battery_i2c_remove(s
 {
 	struct bq27xxx_device_info *di = i2c_get_clientdata(client);
 
+	free_irq(client->irq, di);
 	bq27xxx_battery_teardown(di);
 
 	mutex_lock(&battery_mutex);


