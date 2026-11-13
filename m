Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585538;
	b=Osu07ulvUBhvGb+drDfF1lIdJXxy4ZixAHkJ1VPu5JpA7SjzNeC9LCrvfvweX2rVjvF2
	 KPeJXzCwxVwVQeL/YVSk/8XFQ2nO6SjOYY58zI02m/cp9eEmww01THnKQwBzWd/wxkG5p
	 +z/RQJpsjbnLmYVP5It+XVX7vI0A80pFlkJjbdS4a/vYnpy9X6ntwIfreKJin92euaqOz
	 9pGLIaQ3XUx9tcTTWeDEXdtWxOXNUVtcKJ+gLbZQE9uTVBNVcuL4g2KJvkUm7fovuep0H
	 mN4Rb31Iu5+vpNZjfzD1uM3XpRLGTgvkTwMGFAMX0I+yQCbjLRJjsmCjIIMIfl/uuLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585538;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ycFk7pkVpZoaVk+2qeKwh61Hsp8IuwQEGBRKmM/phug=;
	b=F9LRsFlgiCvoRHM9ZlAzxVq8UNiEwteZFL1xxGFUmpAkWtV0qoheZmtEis7ISpGPTe+V
	 Gj2jXY2crsMpKV3hoz7358iOBUx7MxOcMvHA3hh+kel/9V0r2yHdxU9ceWhjVZw68q3Na
	 2A//W2emR1u5w8uBbmrr+PpiEcFRwWk+SktY6BypNipffZLM77rWOo+Rr/jDEtpwjSgvI
	 VVWWgPPOb+9NRsCO6lpD2/1pUkicqQE35HPTD6omAMT+ErEWkJLv73ssBu6rgD3U2LCsS
	 mVnq7X/WAGbXJ2xlL5jG7swwP/Xz93P2nqPmDiiG2WwXfyAQtI7X7XmouvKLtULo2hw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jyaTna+5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60C13606D45F;
	Fri, 13 Nov 2026 15:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jyaTna+5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D1381F000C7;
	Fri, 13 Nov 2026 15:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585538;
	bh=ycFk7pkVpZoaVk+2qeKwh61Hsp8IuwQEGBRKmM/phug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jyaTna+5E4nuKcgZbv9F1jZZfXzfT7eT0wgHdpY1me3GdACgOtQhExh/EB3fGEEev
	 Cvb6/1qF6wQjoGHrb7N86vSZhDN3TCW/9Q9xMXi/WbmLvCeRyRGxe/giXj+k1KLNUH
	 YYsepMRAsLWNpZXm0LTQuqdqHwRReLOtnKTY77nU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 177/507] hwmon: chipcap2: fix IRQ teardown ordering
Date: Fri, 13 Nov 2026 10:48:01 -0500
Message-ID: <20261113153800.481884956@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

[ Upstream commit d2a66c515d7730fd453485ffb306c412f1f46d72 ]

The threaded IRQs are currently requested before the hwmon device
is registered. Since devres releases resources in reverse order,
the hwmon device is unregistered before the IRQs are freed during
driver teardown. An IRQ may therefore still run after the hwmon
device has been released and access the stale data->hwmon pointer.

Separate IRQ discovery from IRQ registration so that the IRQ numbers
and alarm visibility flags are initialized before registering the
hwmon device while the IRQs are released before the hwmon device
during devres cleanup.

Fixes: 3af350929e75 ("hwmon: Add support for Amphenol ChipCap 2")
Cc: stable@vger.kernel.org
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Link: https://patch.msgid.link/20261014-chipcap2_locks-v3-5-27ebfc2c5b9e@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/chipcap2.c | 52 ++++++++++++++++++++++++----------------
 1 file changed, 32 insertions(+), 20 deletions(-)

diff --git a/drivers/hwmon/chipcap2.c b/drivers/hwmon/chipcap2.c
index 37dbf6a76fbce..21dc6db27c401 100644
--- a/drivers/hwmon/chipcap2.c
+++ b/drivers/hwmon/chipcap2.c
@@ -631,32 +631,47 @@ static int cc2_write(struct device *dev, enum hwmon_sensor_types type, u32 attr,
 	}
 }
 
-static int cc2_request_ready_irq(struct cc2_data *data, struct device *dev)
+static int cc2_get_irqs(struct cc2_data *data, struct device *dev)
 {
-	int ret = 0;
-
 	data->irq_ready = fwnode_irq_get_byname(dev_fwnode(dev), "ready");
 	if (data->irq_ready == -EPROBE_DEFER)
 		return data->irq_ready;
-	if (data->irq_ready > 0) {
+	if (data->irq_ready > 0)
 		init_completion(&data->complete);
+
+	data->irq_low = fwnode_irq_get_byname(dev_fwnode(dev), "low");
+	if (data->irq_low == -EPROBE_DEFER)
+		return data->irq_low;
+	if (data->irq_low > 0)
+		data->rh_alarm.low_alarm_visible = true;
+
+	data->irq_high = fwnode_irq_get_byname(dev_fwnode(dev), "high");
+	if (data->irq_high == -EPROBE_DEFER)
+		return data->irq_high;
+	if (data->irq_high > 0)
+		data->rh_alarm.high_alarm_visible = true;
+
+	return 0;
+}
+
+static int cc2_request_data_ready(struct cc2_data *data, struct device *dev)
+{
+	int ret = 0;
+
+	if (data->irq_ready > 0)
 		ret = devm_request_threaded_irq(dev, data->irq_ready, NULL,
 						cc2_ready_interrupt,
 						IRQF_ONESHOT |
 						IRQF_TRIGGER_RISING,
 						dev_name(dev), data);
-	}
 
 	return ret;
 }
 
-static int cc2_request_alarm_irqs(struct cc2_data *data, struct device *dev)
+static int cc2_request_alarms(struct cc2_data *data, struct device *dev)
 {
 	int ret = 0;
 
-	data->irq_low = fwnode_irq_get_byname(dev_fwnode(dev), "low");
-	if (data->irq_low == -EPROBE_DEFER)
-		return data->irq_low;
 	if (data->irq_low > 0) {
 		ret = devm_request_threaded_irq(dev, data->irq_low, NULL,
 						cc2_low_interrupt,
@@ -665,13 +680,8 @@ static int cc2_request_alarm_irqs(struct cc2_data *data, struct device *dev)
 						dev_name(dev), data);
 		if (ret)
 			return ret;
-
-		data->rh_alarm.low_alarm_visible = true;
 	}
 
-	data->irq_high = fwnode_irq_get_byname(dev_fwnode(dev), "high");
-	if (data->irq_high == -EPROBE_DEFER)
-		return data->irq_high;
 	if (data->irq_high > 0) {
 		ret = devm_request_threaded_irq(dev, data->irq_high, NULL,
 						cc2_high_interrupt,
@@ -680,8 +690,6 @@ static int cc2_request_alarm_irqs(struct cc2_data *data, struct device *dev)
 						dev_name(dev), data);
 		if (ret)
 			return ret;
-
-		data->rh_alarm.high_alarm_visible = true;
 	}
 
 	return ret;
@@ -732,13 +740,13 @@ static int cc2_probe(struct i2c_client *client)
 
 	device_property_read_string(dev, "label", &data->label);
 
-	ret = cc2_request_ready_irq(data, dev);
+	ret = cc2_get_irqs(data, dev);
 	if (ret)
-		return dev_err_probe(dev, ret, "Failed to request ready irq\n");
+		return dev_err_probe(dev, ret, "Failed to get IRQs\n");
 
-	ret = cc2_request_alarm_irqs(data, dev);
+	ret = cc2_request_data_ready(data, dev);
 	if (ret)
-		return dev_err_probe(dev, ret, "Failed to request alarm irqs\n");
+		return dev_err_probe(dev, ret, "Failed to request ready irq\n");
 
 	data->hwmon = devm_hwmon_device_register_with_info(dev, client->name,
 							   data, &cc2_chip_info,
@@ -747,6 +755,10 @@ static int cc2_probe(struct i2c_client *client)
 		return dev_err_probe(dev, PTR_ERR(data->hwmon),
 				     "Failed to register hwmon device\n");
 
+	ret = cc2_request_alarms(data, dev);
+	if (ret)
+		return dev_err_probe(dev, ret, "Failed to request alarm irqs\n");
+
 	return 0;
 }
 
-- 
2.53.0



