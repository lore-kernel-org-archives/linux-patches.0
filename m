Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8239C19148D;
	Tue, 10 Sep 2024 10:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725965004; cv=none; b=ASXa+aMLpo1duD1CWd/6bTh5Fo4wtDDNmiS+krxqfcRNz66v1ddlTMlHuJRYdajyRDJF+laN2hEwF/DsUizg95fYLJ9On3jxiimfko4jJDt2jMexak+tPrUuBRxMcyzredAzcNYYQ3WvuUk1MuSjAkjHBVZMAsCchM23X2yfeS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725965004; c=relaxed/simple;
	bh=IsCdSFpDrhkXwqpXSXTL543kMcYwxA2JixTM7BZIN00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZQkVa9KhgR90hodOQY/RRvt60msyHvWbGOPWaR7FNx7AjgflDTQsN+wdOGyIpisSwBAXN7GfFAZK2OcSO66y8Hf4OdDQjOuflYIlcjVFNVupOyqFfZ417QjyKuJQACzwQ4yaQ+yFIIp/f16qmvZZdTSvBBQkJTh9tfEiOhvNZl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JF3KYPL3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JF3KYPL3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 093AAC4CEC3;
	Tue, 10 Sep 2024 10:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725965004;
	bh=IsCdSFpDrhkXwqpXSXTL543kMcYwxA2JixTM7BZIN00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JF3KYPL3Hdhq7MSra0mrKq1otLlhbrtYkhm0z1LHMuEcVmGt2bVXaJj0MXPDwyG5L
	 5cqLO3JggzybMK6OhKuUfQeaRVwQ1VnIqCcJGFr8DSokINeC16iAHKOOihrqgQL6lS
	 iX1NCE0ULG0YzTAej7/A3XZZpJ/9j9IqvCu7f69Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 105/186] leds: spi-byte: Call of_node_put() on error path
Date: Tue, 10 Sep 2024 11:33:20 +0200
Message-ID: <20240910092558.864611843@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092554.645718780@linuxfoundation.org>
References: <20240910092554.645718780@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 7f9ab862e05c5bc755f65bf6db7edcffb3b49dfc ]

Add a missing call to of_node_put(np) on error.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20240606173037.3091598-2-andriy.shevchenko@linux.intel.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/leds-spi-byte.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/leds/leds-spi-byte.c b/drivers/leds/leds-spi-byte.c
index f1964c96fb15..82696e0607a5 100644
--- a/drivers/leds/leds-spi-byte.c
+++ b/drivers/leds/leds-spi-byte.c
@@ -91,7 +91,6 @@ static int spi_byte_probe(struct spi_device *spi)
 		dev_err(dev, "Device must have exactly one LED sub-node.");
 		return -EINVAL;
 	}
-	child = of_get_next_available_child(dev_of_node(dev), NULL);
 
 	led = devm_kzalloc(dev, sizeof(*led), GFP_KERNEL);
 	if (!led)
@@ -107,11 +106,13 @@ static int spi_byte_probe(struct spi_device *spi)
 	led->ldev.max_brightness = led->cdef->max_value - led->cdef->off_value;
 	led->ldev.brightness_set_blocking = spi_byte_brightness_set_blocking;
 
+	child = of_get_next_available_child(dev_of_node(dev), NULL);
 	state = of_get_property(child, "default-state", NULL);
 	if (state) {
 		if (!strcmp(state, "on")) {
 			led->ldev.brightness = led->ldev.max_brightness;
 		} else if (strcmp(state, "off")) {
+			of_node_put(child);
 			/* all other cases except "off" */
 			dev_err(dev, "default-state can only be 'on' or 'off'");
 			return -EINVAL;
@@ -122,9 +123,12 @@ static int spi_byte_probe(struct spi_device *spi)
 
 	ret = devm_led_classdev_register(&spi->dev, &led->ldev);
 	if (ret) {
+		of_node_put(child);
 		mutex_destroy(&led->mutex);
 		return ret;
 	}
+
+	of_node_put(child);
 	spi_set_drvdata(spi, led);
 
 	return 0;
-- 
2.43.0



