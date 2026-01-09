Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF0F62737EE;
	Fri,  9 Jan 2026 12:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961483; cv=none; b=qXy5ZJPZDD290LnoNmO1oyxmtKBliLyPMM6siR1kMkFqNzGDNsszeCYA81Zr3fluBVifI71AMjgMAyuDJW3X+DZdwOdJMxtu0eF1muD7eNSksqaeZ11GpBOj1WtPjD5HTroDM9Bdc4vuzy4fqrOKIJUCRC2l6HyFm6mLq/WSvEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961483; c=relaxed/simple;
	bh=F8K+mhDla6oCu39u3sW5m7WeBD12mkcztrmNHfTedsg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SbWZb9o43wIm47BWfHRZaZPR2HhI47oQAxLyBcyPfBWqSVZIeCAL6T303gEafB1hoqJvGpX8txIKjqsv/1OxFVPD8wbf3V5l+kJeSR+rBxJfCGP6ZS5n6uF7G/3SDBx0O7zgwUMAgo7pmRtqgX079oT3C2MZo3OejMjF8q4IteY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y8Bqg78s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y8Bqg78s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3617FC4CEF1;
	Fri,  9 Jan 2026 12:24:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961483;
	bh=F8K+mhDla6oCu39u3sW5m7WeBD12mkcztrmNHfTedsg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y8Bqg78saWgFlJvDE/NGbxTAObBacrThCuCfUIHdbv38DrRmMB4GHFEC27TbEk8IG
	 5gggCgISo2kgoZezBFhGeY5a5PoaFetpqOtdKXB1KBADB9yz2V1apuvy0f2la1wP3d
	 07SLCOR3VA6XS5Y9c8oUVPS8zAnhRzwlVt5fm5uA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Kalscheuer <stefan@stklcode.de>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 006/634] leds: spi-byte: Use devm_led_classdev_register_ext()
Date: Fri,  9 Jan 2026 12:34:44 +0100
Message-ID: <20260109112117.663064395@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 065a2bcb7c14b..eb6481df5997f 100644
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



