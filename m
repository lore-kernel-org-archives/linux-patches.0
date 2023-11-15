Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB0EF41757
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UqwIscWQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F3D4C433C8;
	Wed, 15 Nov 2023 19:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076905;
	bh=nL4c9clThsMp8acee4GUj9KWEjxoat7N2qyUdRclRFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UqwIscWQJAyj+qrFkZEk4cG4D2OE2ykY5r/UkPkSamFRvXEf1GOV0vxlo6c/nL692
	 WwWghnUUbtmkJIAjj8JlEB+l1ms/Lx1guL1kVxsfOr9hiNYwQkUeG/AGyE+5aMCejw
	 jTjA7Y6BKp0pueild0HucWVKDXyAWp2BimtKR5cI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Looijmans <mike.looijmans@topic.nl>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 459/550] rtc: pcf85363: Allow to wake up system without IRQ
Date: Wed, 15 Nov 2023 14:17:23 -0500
Message-ID: <20231115191632.671769063@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Looijmans <mike.looijmans@topic.nl>

[ Upstream commit 1e786b03705938870dafb629f2248f88d507a0ff ]

When wakeup-source is set in the devicetree, set up the device for
using the output as interrupt instead of clock. This is similar to
how other RTC devices handle this.

This allows the clock chip to turn on the board when wired to do
so in hardware.

Signed-off-by: Mike Looijmans <mike.looijmans@topic.nl>
Link: https://lore.kernel.org/r/20230821072013.7072-1-mike.looijmans@topic.nl
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Stable-dep-of: 2be36c09b6b0 ("rtc: pcf85363: fix wrong mask/val parameters in regmap_update_bits call")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-pcf85363.c | 30 +++++++++++++++++++++---------
 1 file changed, 21 insertions(+), 9 deletions(-)

diff --git a/drivers/rtc/rtc-pcf85363.c b/drivers/rtc/rtc-pcf85363.c
index 65b8b1338dbb0..b2b7ea32b961f 100644
--- a/drivers/rtc/rtc-pcf85363.c
+++ b/drivers/rtc/rtc-pcf85363.c
@@ -403,6 +403,7 @@ static int pcf85363_probe(struct i2c_client *client)
 		},
 	};
 	int ret, i, err;
+	bool wakeup_source;
 
 	if (data)
 		config = data;
@@ -432,25 +433,36 @@ static int pcf85363_probe(struct i2c_client *client)
 	pcf85363->rtc->ops = &rtc_ops;
 	pcf85363->rtc->range_min = RTC_TIMESTAMP_BEGIN_2000;
 	pcf85363->rtc->range_max = RTC_TIMESTAMP_END_2099;
-	clear_bit(RTC_FEATURE_ALARM, pcf85363->rtc->features);
+
+	wakeup_source = device_property_read_bool(&client->dev,
+						  "wakeup-source");
+	if (client->irq > 0 || wakeup_source) {
+		regmap_write(pcf85363->regmap, CTRL_FLAGS, 0);
+		regmap_update_bits(pcf85363->regmap, CTRL_PIN_IO,
+				   PIN_IO_INTA_OUT, PIN_IO_INTAPM);
+	}
 
 	if (client->irq > 0) {
 		unsigned long irqflags = IRQF_TRIGGER_LOW;
 
 		if (dev_fwnode(&client->dev))
 			irqflags = 0;
-
-		regmap_write(pcf85363->regmap, CTRL_FLAGS, 0);
-		regmap_update_bits(pcf85363->regmap, CTRL_PIN_IO,
-				   PIN_IO_INTA_OUT, PIN_IO_INTAPM);
 		ret = devm_request_threaded_irq(&client->dev, client->irq,
 						NULL, pcf85363_rtc_handle_irq,
 						irqflags | IRQF_ONESHOT,
 						"pcf85363", client);
-		if (ret)
-			dev_warn(&client->dev, "unable to request IRQ, alarms disabled\n");
-		else
-			set_bit(RTC_FEATURE_ALARM, pcf85363->rtc->features);
+		if (ret) {
+			dev_warn(&client->dev,
+				 "unable to request IRQ, alarms disabled\n");
+			client->irq = 0;
+		}
+	}
+
+	if (client->irq > 0 || wakeup_source) {
+		device_init_wakeup(&client->dev, true);
+		set_bit(RTC_FEATURE_ALARM, pcf85363->rtc->features);
+	} else {
+		clear_bit(RTC_FEATURE_ALARM, pcf85363->rtc->features);
 	}
 
 	ret = devm_rtc_register_device(pcf85363->rtc);
-- 
2.42.0



