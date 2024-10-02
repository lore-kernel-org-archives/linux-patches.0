Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E71571D1F4B;
	Wed,  2 Oct 2024 14:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878239; cv=none; b=Y8twbnBzZXfhjAWcJ0OELh9vPQo/+afvqXn9AWw74Gi6WkbdiABTSbofjQBWaO7B/21hVh8sKCbBIPzEXe6VwRxACZIFR6WF9G/aNxStPvs+lDmPoY9eiU6iOhml76mlCPdqCIEshiKhm9lvJbvwVmoqRPB4Cq13OnNnQ/FJ9MI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878239; c=relaxed/simple;
	bh=eumoM3OCXP9gWmh2gf1DDkVch5JAA50czBJ70ziETXg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZI3T1Or846+2XRINn7jfOXq0OVS4aQP6m/lPohCYBcHefm4RR05bwKeUAVeOvscd8PCOGDHSO6oDrnTL99ghfqHC6fXpu20bDnR7Tc9NSHWDl9ocCDAx4n0emRaGWbLqqNdtl2g6q5mishPO5iAX9yQ9FfEQ2ML+yvHMgfP24gA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ouL3iI00; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ouL3iI00"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F863C4CED4;
	Wed,  2 Oct 2024 14:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878238;
	bh=eumoM3OCXP9gWmh2gf1DDkVch5JAA50czBJ70ziETXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ouL3iI00bd18xnTWtKa8Z0DGx7eIYxK/EdaGMowRp14jyuR0gUJhyO+13RllN0rCL
	 iwi2xscD3wfyIxEAw7//x7WYyfaclSJnKNbJnSyBuE2rGd4LwwnEmkW/+jhYgQQY23
	 xsYHGyv7DyD0I1Y2GxN9Cd4UMAKav2uU79mr/Bzs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 346/634] leds: gpio: Set num_leds after allocation
Date: Wed,  2 Oct 2024 14:57:26 +0200
Message-ID: <20241002125824.757325269@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <kees@kernel.org>

[ Upstream commit 045391a02bd971d431c83ad03f7cc51b6e2fe331 ]

With the new __counted_by annotation, the "num_leds" variable needs to
valid for accesses to the "leds" array. This requirement is not met in
gpio_leds_create(), since "num_leds" starts at "0", so "leds" index "0"
will not be considered valid (num_leds would need to be "1" to access
index "0").

Fix this by setting the allocation size after allocation, and then update
the final count based on how many were actually added to the array.

Fixes: 52cd75108a42 ("leds: gpio: Annotate struct gpio_leds_priv with __counted_by")
Signed-off-by: Kees Cook <kees@kernel.org>
Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Link: https://lore.kernel.org/r/20240716212455.work.809-kees@kernel.org
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/leds-gpio.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/leds/leds-gpio.c b/drivers/leds/leds-gpio.c
index 83fcd7b6afff7..4d1612d557c84 100644
--- a/drivers/leds/leds-gpio.c
+++ b/drivers/leds/leds-gpio.c
@@ -150,7 +150,7 @@ static struct gpio_leds_priv *gpio_leds_create(struct device *dev)
 {
 	struct fwnode_handle *child;
 	struct gpio_leds_priv *priv;
-	int count, ret;
+	int count, used, ret;
 
 	count = device_get_child_node_count(dev);
 	if (!count)
@@ -159,9 +159,11 @@ static struct gpio_leds_priv *gpio_leds_create(struct device *dev)
 	priv = devm_kzalloc(dev, struct_size(priv, leds, count), GFP_KERNEL);
 	if (!priv)
 		return ERR_PTR(-ENOMEM);
+	priv->num_leds = count;
+	used = 0;
 
 	device_for_each_child_node(dev, child) {
-		struct gpio_led_data *led_dat = &priv->leds[priv->num_leds];
+		struct gpio_led_data *led_dat = &priv->leds[used];
 		struct gpio_led led = {};
 
 		/*
@@ -197,8 +199,9 @@ static struct gpio_leds_priv *gpio_leds_create(struct device *dev)
 		/* Set gpiod label to match the corresponding LED name. */
 		gpiod_set_consumer_name(led_dat->gpiod,
 					led_dat->cdev.dev->kobj.name);
-		priv->num_leds++;
+		used++;
 	}
+	priv->num_leds = used;
 
 	return priv;
 }
-- 
2.43.0



