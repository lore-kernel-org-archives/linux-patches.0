Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8397B336888;
	Tue, 21 Jul 2026 17:09:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653772; cv=none; b=VXr84OhDBH+g31drnAdJyu1gGEHNTDJYD7rShIb/BgHDSIOxU3DtERzM8ylWzvzJlviuZYvgE4UivsATqKRN3AI6i27IuGNrS+24OTdpyjXWcXR1bG0nJTjRMc3noTJa1NZXSjMrYR6bHGbKNqY/htNIweIrrTDA2HGldrsxPsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653772; c=relaxed/simple;
	bh=vX9Yby3JdB3hZbvlCvIkjhNNnkcdw4QvOO8/ZgsuJa8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jUUMY6Zha8BSl94jYzhCRvTfK1nimyVCCE08g4EHkwwT3p50DtP7AAEDx7jNbsbSpNFoGlHMXOx2oGzrC6rJli9BpXKQmlVgMJsJGDPMQPX0dOlybt1CahHWt7P8aL3R7os0Ko9xUU/EMysKlomCIzierA1HTqJ36Gk+59WQUC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hexDSWZM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hexDSWZM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E476A1F00A3A;
	Tue, 21 Jul 2026 17:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653771;
	bh=oBMvlgCmPV2AReJ/Mxo5htfM4z9qgm7HHyAo7D0/WnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hexDSWZMR9Rs8PzDteHU5Yyp47cGnUtApdYXc9YY8sIRFn8piXA31nu5ZuHVPjcCu
	 TjZiyZGFvOXbrayj0Vf5vUau5FAYq96ZU5aNyjofN2S0a6Dt1EzOlwcDG8k+E7fzAz
	 /IWzc4aU0rSLAlLXpY+8zTaEBh5jrO32bMmfzIqE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@nabladev.com>,
	Linus Walleij <linusw@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1453/2077] gpio: shared: make the voting mechanism adaptable
Date: Tue, 21 Jul 2026 17:18:46 +0200
Message-ID: <20260721152627.071188600@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>

[ Upstream commit b30973e8c3920ddfa9255a959b19057515b4e5e8 ]

The current voting mechanism in GPIO shared proxy assumes that "low" is
always the default value and users can only vote for driving the GPIO
"high" in which case it will remain high as long as there's at least one
user voting.

This makes it impossible to use the automatic sharing management for
certain use-cases such as the write-protect GPIOs of EEPROMs which are
requested "high" and driven "low" to enable writing. In this case, if
the WP GPIO is shared by multiple EEPROMs, and at least one of them
wants to enable writing, the pin must be set to "low".

Modify the voting heuristic to assume the value set by the first user on
request to be the "default" and subseqent calls to gpiod_set_value()
will constitute votes for a change of the value to the opposite. In the
wp-gpios case it will mean that the nvmem core requests the GPIO as
"out-high" for all EEPROMs sharing the pin, and when one of them wants
to write, the pin will be driven low, enabling it.

Fixes: e992d54c6f97 ("gpio: shared-proxy: implement the shared GPIO proxy driver")
Reported-by: Marek Vasut <marex@nabladev.com>
Closes: https://lore.kernel.org/all/20260511163518.51104-1-marex@nabladev.com/
Reviewed-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260630-gpio-shared-dynamic-voting-v3-1-8ecf0542953b@oss.qualcomm.com
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpio-shared-proxy.c | 66 ++++++++++++++++----------------
 drivers/gpio/gpiolib-shared.h    |  3 +-
 2 files changed, 34 insertions(+), 35 deletions(-)

diff --git a/drivers/gpio/gpio-shared-proxy.c b/drivers/gpio/gpio-shared-proxy.c
index 10ca2ef77ef341..52a366f0ec4de7 100644
--- a/drivers/gpio/gpio-shared-proxy.c
+++ b/drivers/gpio/gpio-shared-proxy.c
@@ -22,7 +22,7 @@ struct gpio_shared_proxy_data {
 	struct gpio_chip gc;
 	struct gpio_shared_desc *shared_desc;
 	struct device *dev;
-	bool voted_high;
+	bool voted_change;
 };
 
 static int
@@ -34,52 +34,54 @@ gpio_shared_proxy_set_unlocked(struct gpio_shared_proxy_data *proxy, int value)
 
 	lockdep_assert_held(&shared_desc->mutex);
 
-	if (value) {
-	       /* User wants to set value to high. */
-		if (proxy->voted_high)
-			/* Already voted for high, nothing to do. */
+	if (value != shared_desc->def_val) {
+	       /* User wants to vote for a value change. */
+		if (proxy->voted_change)
+			/* Already voted for a change, nothing to do. */
 			goto out;
 
-		/* Haven't voted for high yet. */
-		if (!shared_desc->highcnt) {
+		/* Haven't voted for a value change yet. */
+		if (!shared_desc->votecnt) {
 			/*
-			 * Current value is low, need to actually set value
-			 * to high.
+			 * Current value is default, need to actually set value
+			 * to the opposite.
 			 */
-			ret = gpiod_set_value_cansleep(desc, 1);
+			ret = gpiod_set_value_cansleep(desc, value);
 			if (ret)
 				goto out;
 		}
 
-		shared_desc->highcnt++;
-		proxy->voted_high = true;
+		shared_desc->votecnt++;
+		proxy->voted_change = true;
 
 		goto out;
 	}
 
-	/* Desired value is low. */
-	if (!proxy->voted_high)
-		/* We didn't vote for high, nothing to do. */
+	/* Desired value is the default. */
+	if (!proxy->voted_change)
+		/* We didn't vote for change previously, nothing to do. */
 		goto out;
 
-	/* We previously voted for high. */
-	if (shared_desc->highcnt == 1) {
-		/* This is the last remaining vote for high, set value  to low. */
-		ret = gpiod_set_value_cansleep(desc, 0);
+	/* We previously voted for change. */
+	if (shared_desc->votecnt == 1) {
+		/* This is the last remaining vote for change, set value to default. */
+		ret = gpiod_set_value_cansleep(desc, shared_desc->def_val);
 		if (ret)
 			goto out;
 	}
 
-	shared_desc->highcnt--;
-	proxy->voted_high = false;
+	shared_desc->votecnt--;
+	proxy->voted_change = false;
 
 out:
-	if (shared_desc->highcnt)
+	if (shared_desc->votecnt)
 		dev_dbg(proxy->dev,
-			"Voted for value '%s', effective value is 'high', number of votes for 'high': %u\n",
-			str_high_low(value), shared_desc->highcnt);
+			"Voted for value '%s', effective value is '%s', number of votes: %u\n",
+			str_high_low(value), str_high_low(!shared_desc->def_val),
+			shared_desc->votecnt);
 	else
-		dev_dbg(proxy->dev, "Voted for value 'low', effective value is 'low'\n");
+		dev_dbg(proxy->dev, "Voted for value '%s', effective value is '%s'\n",
+			str_high_low(value), str_high_low(shared_desc->def_val));
 
 	return ret;
 }
@@ -107,8 +109,8 @@ static void gpio_shared_proxy_free(struct gpio_chip *gc, unsigned int offset)
 
 	guard(mutex)(&shared_desc->mutex);
 
-	if (proxy->voted_high) {
-		ret = gpio_shared_proxy_set_unlocked(proxy, 0);
+	if (proxy->voted_change) {
+		ret = gpio_shared_proxy_set_unlocked(proxy, shared_desc->def_val);
 		if (ret)
 			dev_err(proxy->dev,
 				"Failed to unset the shared GPIO value on release: %d\n", ret);
@@ -197,13 +199,9 @@ static int gpio_shared_proxy_direction_output(struct gpio_chip *gc,
 		if (ret)
 			return ret;
 
-		if (value) {
-			proxy->voted_high = true;
-			shared_desc->highcnt = 1;
-		} else {
-			proxy->voted_high = false;
-			shared_desc->highcnt = 0;
-		}
+		shared_desc->def_val = value;
+		shared_desc->votecnt = 0;
+		proxy->voted_change = false;
 
 		return 0;
 	}
diff --git a/drivers/gpio/gpiolib-shared.h b/drivers/gpio/gpiolib-shared.h
index bbdc0ab7b647a4..618756f6c6aafd 100644
--- a/drivers/gpio/gpiolib-shared.h
+++ b/drivers/gpio/gpiolib-shared.h
@@ -41,7 +41,8 @@ struct gpio_shared_desc {
 	struct gpio_desc *desc;
 	unsigned long cfg;
 	unsigned int usecnt;
-	unsigned int highcnt;
+	unsigned int votecnt;
+	int def_val;
 	struct mutex mutex; /* serializes all proxy operations on this descriptor */
 };
 
-- 
2.53.0



