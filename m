Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DACF7E0E4;
	Mon,  8 Apr 2024 13:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582008; cv=none; b=Z4qqa87rlE8WarY5nEQGeiyjw8XtuJLatGTfdcWIONT8rzPjzjPncfEWj8DzlPQKW7ylRRTvNx0/cIefbbNlk+znWXMeoIbaok2ydKS4rY+OSAdXaJu02cgoha9TzyLLIvxFcHXi4bZwfk4sWI5GtwmBUEyYiGUwZTQwKcCJBn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582008; c=relaxed/simple;
	bh=i0EhxiBI+UMasAsJOwXCWRkP+pxjm/TmSgMhxQJ7w1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FPBciubHS/z0OueE6fOZVT3C4vyI4HnNO73Q/iplrIl/ZShQL2VIHSItK5BhqXkASBrnQCsUJ+UWo+hI6J4F/3fbL1s+2xodfWFXU+1mPSUsir0uSSOFP3TpEe7A8xyVLFO+1kDaPqzAfTJANQiu3l9pAogsSICnUsJyf+8c0Fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GGnZzxEK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GGnZzxEK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4F9DC433F1;
	Mon,  8 Apr 2024 13:13:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582008;
	bh=i0EhxiBI+UMasAsJOwXCWRkP+pxjm/TmSgMhxQJ7w1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GGnZzxEKNwWIvno2eWe8QsuJxjZGhQoMY6MTx43GGfk+gr/cVvKuecOjmRgKu5i4d
	 jvo5lUl1Futw3q75H/0QQcwBKnlPLxcOOUdBkv2upg7+bLETBunpq9fIsTapZkXsYJ
	 7rxYHDrOovKNdOqRgMNPDqd2/MFTrR21Fn7fT3jo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ferry Toth <ftoth@exalondelft.nl>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 032/273] gpiolib: Fix debug messaging in gpiod_find_and_request()
Date: Mon,  8 Apr 2024 14:55:07 +0200
Message-ID: <20240408125310.293501768@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 5c887b65bbd1a3fc28e2e20399acede0baa83edb ]

When consolidating GPIO lookups in ACPI code, the debug messaging
had been reworked that the user may see

  [   13.401147] (NULL device *): using ACPI '\_SB.LEDS.led-0' for '(null)' GPIO lookup
  [   13.401378] gpio gpiochip0: Persistence not supported for GPIO 40
  [   13.401402] gpio-40 (?): no flags found for (null)

instead of

  [   14.182962] gpio gpiochip0: Persistence not supported for GPIO 40
  [   14.182994] gpio-40 (?): no flags found for gpios

The '(null)' parts are less informative and likely scare the users.
Replace them by '(default)' which can point out to the default connection
IDs, such as 'gpios'.

While at it, amend other places where con_id is used in the messages.

Reported-by: Ferry Toth <ftoth@exalondelft.nl>
Fixes: 8eb1f71e7acc ("gpiolib: consolidate GPIO lookups")
Suggested-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Tested-by: Ferry Toth <ftoth@exalondelft.nl>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib.c |   31 ++++++++++++++++++-------------
 1 file changed, 18 insertions(+), 13 deletions(-)

--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -2402,6 +2402,11 @@ char *gpiochip_dup_line_label(struct gpi
 }
 EXPORT_SYMBOL_GPL(gpiochip_dup_line_label);
 
+static inline const char *function_name_or_default(const char *con_id)
+{
+	return con_id ?: "(default)";
+}
+
 /**
  * gpiochip_request_own_desc - Allow GPIO chip to request its own descriptor
  * @gc: GPIO chip
@@ -2430,10 +2435,11 @@ struct gpio_desc *gpiochip_request_own_d
 					    enum gpiod_flags dflags)
 {
 	struct gpio_desc *desc = gpiochip_get_desc(gc, hwnum);
+	const char *name = function_name_or_default(label);
 	int ret;
 
 	if (IS_ERR(desc)) {
-		chip_err(gc, "failed to get GPIO descriptor\n");
+		chip_err(gc, "failed to get GPIO %s descriptor\n", name);
 		return desc;
 	}
 
@@ -2443,8 +2449,8 @@ struct gpio_desc *gpiochip_request_own_d
 
 	ret = gpiod_configure_flags(desc, label, lflags, dflags);
 	if (ret) {
-		chip_err(gc, "setup of own GPIO %s failed\n", label);
 		gpiod_free_commit(desc);
+		chip_err(gc, "setup of own GPIO %s failed\n", name);
 		return ERR_PTR(ret);
 	}
 
@@ -4119,19 +4125,17 @@ static struct gpio_desc *gpiod_find_by_f
 					      enum gpiod_flags *flags,
 					      unsigned long *lookupflags)
 {
+	const char *name = function_name_or_default(con_id);
 	struct gpio_desc *desc = ERR_PTR(-ENOENT);
 
 	if (is_of_node(fwnode)) {
-		dev_dbg(consumer, "using DT '%pfw' for '%s' GPIO lookup\n",
-			fwnode, con_id);
+		dev_dbg(consumer, "using DT '%pfw' for '%s' GPIO lookup\n", fwnode, name);
 		desc = of_find_gpio(to_of_node(fwnode), con_id, idx, lookupflags);
 	} else if (is_acpi_node(fwnode)) {
-		dev_dbg(consumer, "using ACPI '%pfw' for '%s' GPIO lookup\n",
-			fwnode, con_id);
+		dev_dbg(consumer, "using ACPI '%pfw' for '%s' GPIO lookup\n", fwnode, name);
 		desc = acpi_find_gpio(fwnode, con_id, idx, flags, lookupflags);
 	} else if (is_software_node(fwnode)) {
-		dev_dbg(consumer, "using swnode '%pfw' for '%s' GPIO lookup\n",
-			fwnode, con_id);
+		dev_dbg(consumer, "using swnode '%pfw' for '%s' GPIO lookup\n", fwnode, name);
 		desc = swnode_find_gpio(fwnode, con_id, idx, lookupflags);
 	}
 
@@ -4147,6 +4151,7 @@ struct gpio_desc *gpiod_find_and_request
 					 bool platform_lookup_allowed)
 {
 	unsigned long lookupflags = GPIO_LOOKUP_FLAGS_DEFAULT;
+	const char *name = function_name_or_default(con_id);
 	struct gpio_desc *desc;
 	int ret;
 
@@ -4162,7 +4167,7 @@ struct gpio_desc *gpiod_find_and_request
 	}
 
 	if (IS_ERR(desc)) {
-		dev_dbg(consumer, "No GPIO consumer %s found\n", con_id);
+		dev_dbg(consumer, "No GPIO consumer %s found\n", name);
 		return desc;
 	}
 
@@ -4183,15 +4188,14 @@ struct gpio_desc *gpiod_find_and_request
 		 *
 		 * FIXME: Make this more sane and safe.
 		 */
-		dev_info(consumer,
-			 "nonexclusive access to GPIO for %s\n", con_id);
+		dev_info(consumer, "nonexclusive access to GPIO for %s\n", name);
 		return desc;
 	}
 
 	ret = gpiod_configure_flags(desc, con_id, lookupflags, flags);
 	if (ret < 0) {
-		dev_dbg(consumer, "setup of GPIO %s failed\n", con_id);
 		gpiod_put(desc);
+		dev_dbg(consumer, "setup of GPIO %s failed\n", name);
 		return ERR_PTR(ret);
 	}
 
@@ -4307,6 +4311,7 @@ EXPORT_SYMBOL_GPL(gpiod_get_optional);
 int gpiod_configure_flags(struct gpio_desc *desc, const char *con_id,
 		unsigned long lflags, enum gpiod_flags dflags)
 {
+	const char *name = function_name_or_default(con_id);
 	int ret;
 
 	if (lflags & GPIO_ACTIVE_LOW)
@@ -4350,7 +4355,7 @@ int gpiod_configure_flags(struct gpio_de
 
 	/* No particular flag request, return here... */
 	if (!(dflags & GPIOD_FLAGS_BIT_DIR_SET)) {
-		gpiod_dbg(desc, "no flags found for %s\n", con_id);
+		gpiod_dbg(desc, "no flags found for GPIO %s\n", name);
 		return 0;
 	}
 


