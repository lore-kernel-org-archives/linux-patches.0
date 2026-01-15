Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45F212C0F83;
	Thu, 15 Jan 2026 17:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499010; cv=none; b=Jx1s8IW20K9pNkBT3DAjTkZm0Rr51qPIECfG+3ZknpRAik8sMtz2MxJixVmeZXgc8sA9a6qFjSB6vaaTQ0HbSE3JmB+/cwA9JpKBII7a41BsT/sd3Q7cdJWzQ4uLTuBBhem1vblpnRgE2fjsFHAi3vEVvkjUiTEg6KT8e7jt2lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499010; c=relaxed/simple;
	bh=LpT2QNETDRqMzuOOHR08tNvLmujln28Jrqnsrh6UcGY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jULkQ2yybhEjKod9VWIRhk7A0WUwaAyswcGYyPTdyuc5/x8zcqP5Ns8YtGMSVeWMnUYMEjijYpJEobk5NfW8IyKapIHbNv5UZEM7B984U1oYjkTNl2yt/asgr5Tczm4MJqXl504UJYvhhKplDteTFFxmdbz809Yw3zXGOOeUS7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JQvULITz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JQvULITz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98680C116D0;
	Thu, 15 Jan 2026 17:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499010;
	bh=LpT2QNETDRqMzuOOHR08tNvLmujln28Jrqnsrh6UcGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JQvULITzBp7fmugt42uxp7oq0qgqbEiptvu++lH4my6wP4xWPml95D+TrEz9bpOST
	 XUyMkI/2ty8Mb4kDKQa489PR3rxmND29Nz12tWB5+yCAK72zrQhdBuyww51sTwk57V
	 GXICkO1z85C1DbL2AvfYiV2ORDpta7rh+9+lIozo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Markus Elfring <Markus.Elfring@web.de>,
	Haotian Zhang <vulab@iscas.ac.cn>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 076/451] leds: netxbig: Fix GPIO descriptor leak in error paths
Date: Thu, 15 Jan 2026 17:44:37 +0100
Message-ID: <20260115164233.663103812@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Haotian Zhang <vulab@iscas.ac.cn>

[ Upstream commit 03865dd8af52eb16c38062df2ed30a91b604780e ]

The function netxbig_gpio_ext_get() acquires GPIO descriptors but
fails to release them when errors occur mid-way through initialization.
The cleanup callback registered by devm_add_action_or_reset() only
runs on success, leaving acquired GPIOs leaked on error paths.

Add goto-based error handling to release all acquired GPIOs before
returning errors.

Fixes: 9af512e81964 ("leds: netxbig: Convert to use GPIO descriptors")
Suggested-by: Markus Elfring <Markus.Elfring@web.de>
Signed-off-by: Haotian Zhang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20251031021620.781-1-vulab@iscas.ac.cn
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/leds-netxbig.c | 36 ++++++++++++++++++++++++++----------
 1 file changed, 26 insertions(+), 10 deletions(-)

diff --git a/drivers/leds/leds-netxbig.c b/drivers/leds/leds-netxbig.c
index c2cc45e19c4b2..1083c71fe3bb2 100644
--- a/drivers/leds/leds-netxbig.c
+++ b/drivers/leds/leds-netxbig.c
@@ -364,6 +364,9 @@ static int netxbig_gpio_ext_get(struct device *dev,
 	if (!addr)
 		return -ENOMEM;
 
+	gpio_ext->addr = addr;
+	gpio_ext->num_addr = 0;
+
 	/*
 	 * We cannot use devm_ managed resources with these GPIO descriptors
 	 * since they are associated with the "GPIO extension device" which
@@ -375,45 +378,58 @@ static int netxbig_gpio_ext_get(struct device *dev,
 		gpiod = gpiod_get_index(gpio_ext_dev, "addr", i,
 					GPIOD_OUT_LOW);
 		if (IS_ERR(gpiod))
-			return PTR_ERR(gpiod);
+			goto err_set_code;
 		gpiod_set_consumer_name(gpiod, "GPIO extension addr");
 		addr[i] = gpiod;
+		gpio_ext->num_addr++;
 	}
-	gpio_ext->addr = addr;
-	gpio_ext->num_addr = num_addr;
 
 	ret = gpiod_count(gpio_ext_dev, "data");
 	if (ret < 0) {
 		dev_err(dev,
 			"Failed to count GPIOs in DT property data-gpios\n");
-		return ret;
+		goto err_free_addr;
 	}
 	num_data = ret;
 	data = devm_kcalloc(dev, num_data, sizeof(*data), GFP_KERNEL);
-	if (!data)
-		return -ENOMEM;
+	if (!data) {
+		ret = -ENOMEM;
+		goto err_free_addr;
+	}
+
+	gpio_ext->data = data;
+	gpio_ext->num_data = 0;
 
 	for (i = 0; i < num_data; i++) {
 		gpiod = gpiod_get_index(gpio_ext_dev, "data", i,
 					GPIOD_OUT_LOW);
 		if (IS_ERR(gpiod))
-			return PTR_ERR(gpiod);
+			goto err_free_data;
 		gpiod_set_consumer_name(gpiod, "GPIO extension data");
 		data[i] = gpiod;
+		gpio_ext->num_data++;
 	}
-	gpio_ext->data = data;
-	gpio_ext->num_data = num_data;
 
 	gpiod = gpiod_get(gpio_ext_dev, "enable", GPIOD_OUT_LOW);
 	if (IS_ERR(gpiod)) {
 		dev_err(dev,
 			"Failed to get GPIO from DT property enable-gpio\n");
-		return PTR_ERR(gpiod);
+		goto err_free_data;
 	}
 	gpiod_set_consumer_name(gpiod, "GPIO extension enable");
 	gpio_ext->enable = gpiod;
 
 	return devm_add_action_or_reset(dev, netxbig_gpio_ext_remove, gpio_ext);
+
+err_free_data:
+	for (i = 0; i < gpio_ext->num_data; i++)
+		gpiod_put(gpio_ext->data[i]);
+err_set_code:
+	ret = PTR_ERR(gpiod);
+err_free_addr:
+	for (i = 0; i < gpio_ext->num_addr; i++)
+		gpiod_put(gpio_ext->addr[i]);
+	return ret;
 }
 
 static int netxbig_leds_get_of_pdata(struct device *dev,
-- 
2.51.0



