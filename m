Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95AF431A7EA;
	Fri,  9 Jan 2026 11:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959393; cv=none; b=cXux/kDa0pwDl+095kKRD8tgkr779SZOB9IKfIVHKuIi/+BLYEcNqLvjPvENxjgXQjSY+DlvdFoCsJArsicONqqVF+Eli9C9PmS5VUauam5ZVkzaH6U99G2S42ohVQQXMbxjGfZzQofQQc+R56g5GZljSRWq20laTnunTCxnTTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959393; c=relaxed/simple;
	bh=CbQ2M9gAReujrXQkAZXJpfyz24xL/QKa3U72k7iSlU8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VQChSWm8m7mO2gGHif8Ulu1pL0GiSBZnMMPvYtihZyCtimWYmPw/GSfDGrIUL/Gg/wETTKSYgVoKjVuSDI491WAMnWlfhXPB8fKTXeqmT3LW8Vsc7XGjRmBVjZkdFBRbAZYGzwrW+JJKKxNzbslDBtEDnIeV+Xt/93eqM/inEEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A3Ru53tP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A3Ru53tP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD72FC16AAE;
	Fri,  9 Jan 2026 11:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959393;
	bh=CbQ2M9gAReujrXQkAZXJpfyz24xL/QKa3U72k7iSlU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A3Ru53tPg76C0InwcVDiJq/9HyYmi0M6+PNtksAY61U32nvY4I2SxYjfuZFosaW1I
	 hoEBdyWaSrunpOcW7OXERsobfbkdgsiObQOBtflC5Tps1nLN73wmqrmnBlhMBKothV
	 3oKLRtF6P2ZLNQwrqnUGrbo98o5H5ZVjP1RNZsF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Kalscheuer <stefan@stklcode.de>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 005/737] leds: spi-byte: Use devm_led_classdev_register_ext()
Date: Fri,  9 Jan 2026 12:32:24 +0100
Message-ID: <20260109112134.193645403@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Kalscheuer <stefan@stklcode.de>

[ Upstream commit ccc35ff2fd2911986b716a87fe65e03fac2312c9 ]

Use extended classdev registration to generate generic device names from
color and function enums instead of reading only the label from the
device tree.

Signed-off-by: Stefan Kalscheuer <stefan@stklcode.de>
Link: https://lore.kernel.org/r/20240204150726.29783-1-stefan@stklcode.de
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/leds-spi-byte.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/leds/leds-spi-byte.c b/drivers/leds/leds-spi-byte.c
index afe9bff7c7c16..b04cf502e6035 100644
--- a/drivers/leds/leds-spi-byte.c
+++ b/drivers/leds/leds-spi-byte.c
@@ -83,7 +83,7 @@ static int spi_byte_probe(struct spi_device *spi)
 	struct device_node *child;
 	struct device *dev = &spi->dev;
 	struct spi_byte_led *led;
-	const char *name = "leds-spi-byte::";
+	struct led_init_data init_data = {};
 	const char *state;
 	int ret;
 
@@ -96,12 +96,9 @@ static int spi_byte_probe(struct spi_device *spi)
 	if (!led)
 		return -ENOMEM;
 
-	of_property_read_string(child, "label", &name);
-	strscpy(led->name, name, sizeof(led->name));
 	led->spi = spi;
 	mutex_init(&led->mutex);
 	led->cdef = device_get_match_data(dev);
-	led->ldev.name = led->name;
 	led->ldev.brightness = LED_OFF;
 	led->ldev.max_brightness = led->cdef->max_value - led->cdef->off_value;
 	led->ldev.brightness_set_blocking = spi_byte_brightness_set_blocking;
@@ -121,7 +118,11 @@ static int spi_byte_probe(struct spi_device *spi)
 	spi_byte_brightness_set_blocking(&led->ldev,
 					 led->ldev.brightness);
 
-	ret = devm_led_classdev_register(&spi->dev, &led->ldev);
+	init_data.fwnode = of_fwnode_handle(child);
+	init_data.devicename = "leds-spi-byte";
+	init_data.default_label = ":";
+
+	ret = devm_led_classdev_register_ext(&spi->dev, &led->ldev, &init_data);
 	if (ret) {
 		of_node_put(child);
 		mutex_destroy(&led->mutex);
-- 
2.51.0



