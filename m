Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36057194C8B;
	Tue, 10 Sep 2024 10:08:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962940; cv=none; b=YQdj7R3Rb/z+zPkkqFNEK7atnIcadR67sFg8T8EbEc/3C85AUJ/2k6TAXDQdwCdoLlnxCSPdd2MQ6XL8hq0nbi46I4+j6vuPCsAYiXE4u9QXZ1mRKV9AcJM5UewiIjljGqgMwxJwcV035rvuoVJIma2Q6bHwU+tpH2LBbmM7mnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962940; c=relaxed/simple;
	bh=OT6gIzIuSp6zIzSvFj3Nxad2hg3cYhH7b2l+i6o8SuY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BXApgPD7nYZ8ksHfZ77s0Ye5mCI7dcpcuPhVs2Q7T/qRcycf5IQPpuQhVLK9z3SF8SFZwCTprgj2W5bZQoixrQTD56WvNpm0tUw47DxcUh+HF0yFdfOL9Id9I9eL55lT+N1ZI7gzFo0OtbImov9WKq8a+KSg51aeVimO29EvRkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m4wvBBAs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m4wvBBAs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FCFDC4CEC3;
	Tue, 10 Sep 2024 10:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962939;
	bh=OT6gIzIuSp6zIzSvFj3Nxad2hg3cYhH7b2l+i6o8SuY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m4wvBBAs4jicIFblKiGKx6ENbMppAUKDy8MPld+ca/OKLWaAQ8T4H2K2sazFbgLpo
	 F587tlyn2hiKd4dFbyFt6z9YjnmoTosRKltZRQXwJovDxGOWVwwROphgF738DfV1et
	 3yeN5mJlBZuVsJkRiLh9ViuaBpHa/p7hq520FXhY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 054/192] leds: spi-byte: Call of_node_put() on error path
Date: Tue, 10 Sep 2024 11:31:18 +0200
Message-ID: <20240910092600.211418747@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092557.876094467@linuxfoundation.org>
References: <20240910092557.876094467@linuxfoundation.org>
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
index 2bc5c99daf51..6883d3ba382f 100644
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



