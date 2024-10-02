Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7242D1D0429;
	Wed,  2 Oct 2024 13:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876252; cv=none; b=lvppvVbAyMh5YJz709waWA+wGPbopYAxFTRytS73F1EgMCFw/MmU7irVArSWT/NLRvBo1JO3P4+hyxbuBhr17nODpiQI0owDC/vQfdTrPpfXmK6zZ0wNlV9ziR806yXsV+Ul32G1821YYiTb2WpceNsMbGvT9l37UYohhYnkPYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876252; c=relaxed/simple;
	bh=WmFsG3xcl+EGv244YNBvmBU7trj5CkGEXgcQpCU+DBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q8z9P0mkA3krFKVOj4mZIy9EkM1t8kwSV8tsIZ7TrQwVVxQUZEcX8ykL937rj1eHgRcQ7PaGdN/WRt/qA+Z3MgTZExBKUO0aIx3NXvmg7XJj4Tbv0emBiGQgPm5OKeichtwOrg0DmxEa6aX6tweJC19JuWbHwXM5SAyjOkrnWRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SPS18yLD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SPS18yLD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECBBCC4CECD;
	Wed,  2 Oct 2024 13:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876252;
	bh=WmFsG3xcl+EGv244YNBvmBU7trj5CkGEXgcQpCU+DBs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SPS18yLD/BXn/8ZkNo4DlI2mxyr5Qj8MzRkNwL79dendeGF9I3SPwFaOL2fbiYicx
	 7LaFY8+gGjFDixCvizpWrDbrWJl3FvDVxOYSKerCCdd86ffPIETdsM+wJkuDQp78yC
	 1aYFNO0ZnWxQbMTBlMWXBHAmOBVJSLf0kaPH/GwE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 380/695] leds: gpio: Set num_leds after allocation
Date: Wed,  2 Oct 2024 14:56:18 +0200
Message-ID: <20241002125837.628010896@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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



