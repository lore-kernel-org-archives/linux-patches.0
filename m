Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4855199FB5;
	Tue, 10 Sep 2024 10:19:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963596; cv=none; b=p28JXknW73eUgicLIIvtIhQ8aed6TFuGNuy26QiQg6zEs5NYFZYDBayPsy4w8sqY1l2ihlz/1WdRJxqokXBHtVLo3VqxyjIKGfHa6//nLAiLXzaT96uqckeISTdmw3HNc+v8BCK7ioN7JdJ9CN1HOj6f+SDBjwNoa/E8V+WsLOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963596; c=relaxed/simple;
	bh=RCsXbUCkLWC9E8dZLnnnAj2d2bw7XDJCPnIqD+gQueQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eNFRYdkgf+Q0tluZkjeZuN0Cx+pjoCSH6ID5mjbxErsUHM1Wcs6hMeexu77bis1FESKI36TSLEtAxXPWaXbbnRdRqpplD0kXqIQLfw4vf+iTzYkn/MtbO7+O8M7qMfpzsZQyo8Vic0FpgFBJRJSnOz/musOX7i3bRikBiNe9DsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z5P+EW2z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z5P+EW2z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FA4EC4CEC6;
	Tue, 10 Sep 2024 10:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963596;
	bh=RCsXbUCkLWC9E8dZLnnnAj2d2bw7XDJCPnIqD+gQueQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z5P+EW2zA2EnMNgBHf2oPku5UfL6YkrFEivA3G5VSf87oQu+e/OmgHs6hQHhaer1x
	 5S/+yntB7l5VUKlxXWysAjkkUAN0McBjHUfiUfgbUuJJdciY+KgUa/vha0s1bJnwpk
	 425CtJ4hQPy2VzWkB7eEapN28HwB9th4OiKEvXOo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 111/214] leds: spi-byte: Call of_node_put() on error path
Date: Tue, 10 Sep 2024 11:32:13 +0200
Message-ID: <20240910092603.345792975@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
References: <20240910092558.714365667@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



