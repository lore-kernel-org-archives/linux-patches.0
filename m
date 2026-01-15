Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C816B3BF2E4;
	Thu, 15 Jan 2026 16:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496338; cv=none; b=GZnyjJm3WUSngLugeM7IpSEqjo6TS4VLQ4+EP5YABw7COM2VSqPvAqzv2wguEbnOSEBghxYpqVAD3nCV+WhKBw1aSOHk63W+mO5foLck15zHqd2CKcNdfv3+Uz/6axeGhwCrYYXucpdhaVwjjnrB6p9PCbeTXsPqyk/XgnpkWC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496338; c=relaxed/simple;
	bh=NDiVPOpYSguiNgGNzUkgFz3WfVKjprX62nc+8gKEuRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CcpmtxLORZDhPKyRswRXu6i3YGqDmSKBS2FloxYsCZfnzDWvws72TmT0v9Tn3+Xi/NMeguz8k1SYzUP3YNq0DyEbkIEUF7yp4pH+7azKi4iOkqwwzKwWTj9eiPbKaRK0749Lf6zskDcIGr1/BmQfUSeIVlk5WlERg6DVK3SnPPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rg2jDkYM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rg2jDkYM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50A54C16AAE;
	Thu, 15 Jan 2026 16:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496338;
	bh=NDiVPOpYSguiNgGNzUkgFz3WfVKjprX62nc+8gKEuRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rg2jDkYMzqXfZM0zn13S6sEFqcMP2GWSbh+Vys2l7v17a5KS3o2loOEjv3XmPoRM2
	 x5sieCGfennadpUBPJIqAWq+wCOly//Vccabeu8Q9HrUifCN/OXE/QJpQV4uBJSxuI
	 d3DwvjrisQ/II9aFwgGQ4YOx4KAwvg7Rpc6oslSA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mary Strodl <mstrodl@csh.rit.edu>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 161/181] gpio: mpsse: add quirk support
Date: Thu, 15 Jan 2026 17:48:18 +0100
Message-ID: <20260115164208.125399279@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mary Strodl <mstrodl@csh.rit.edu>

[ Upstream commit f13b0f72af238d63bb9a2e417657da8b45d72544 ]

Builds out a facility for specifying compatible lines directions and
labels for MPSSE-based devices.

* dir_in/out are bitmask of lines that can go in/out. 1 means
  compatible, 0 means incompatible.
* names is an array of line names which will be exposed to userspace.

Also changes the chip label format to include some more useful
information about the device to help identify it from userspace.

Signed-off-by: Mary Strodl <mstrodl@csh.rit.edu>
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20251014133530.3592716-4-mstrodl@csh.rit.edu
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Stable-dep-of: 1e876e5a0875 ("gpio: mpsse: fix reference leak in gpio_mpsse_probe() error paths")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpio-mpsse.c |  109 ++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 106 insertions(+), 3 deletions(-)

--- a/drivers/gpio/gpio-mpsse.c
+++ b/drivers/gpio/gpio-mpsse.c
@@ -29,6 +29,9 @@ struct mpsse_priv {
 	u8 gpio_outputs[2];	     /* Output states for GPIOs [L, H] */
 	u8 gpio_dir[2];		     /* Directions for GPIOs [L, H] */
 
+	unsigned long dir_in;        /* Bitmask of valid input pins  */
+	unsigned long dir_out;       /* Bitmask of valid output pins */
+
 	u8 *bulk_in_buf;	     /* Extra recv buffer to grab status bytes */
 
 	struct usb_endpoint_descriptor *bulk_in;
@@ -54,6 +57,14 @@ struct bulk_desc {
 	int timeout;
 };
 
+#define MPSSE_NGPIO 16
+
+struct mpsse_quirk {
+	const char   *names[MPSSE_NGPIO]; /* Pin names, if applicable     */
+	unsigned long dir_in;             /* Bitmask of valid input pins  */
+	unsigned long dir_out;            /* Bitmask of valid output pins */
+};
+
 static const struct usb_device_id gpio_mpsse_table[] = {
 	{ USB_DEVICE(0x0c52, 0xa064) },   /* SeaLevel Systems, Inc. */
 	{ }                               /* Terminating entry */
@@ -171,6 +182,32 @@ static int gpio_mpsse_get_bank(struct mp
 	return buf;
 }
 
+static int mpsse_ensure_supported(struct gpio_chip *chip,
+				  unsigned long mask, int direction)
+{
+	unsigned long supported, unsupported;
+	char *type = "input";
+	struct mpsse_priv *priv = gpiochip_get_data(chip);
+
+	supported = priv->dir_in;
+	if (direction == GPIO_LINE_DIRECTION_OUT) {
+		supported = priv->dir_out;
+		type = "output";
+	}
+
+	/* An invalid bit was in the provided mask */
+	unsupported = mask & ~supported;
+	if (unsupported) {
+		dev_err(&priv->udev->dev,
+			"mpsse: GPIO %lu doesn't support %s\n",
+			find_first_bit(&unsupported, sizeof(unsupported) * 8),
+			type);
+		return -EOPNOTSUPP;
+	}
+
+	return 0;
+}
+
 static int gpio_mpsse_set_multiple(struct gpio_chip *chip, unsigned long *mask,
 				   unsigned long *bits)
 {
@@ -178,6 +215,10 @@ static int gpio_mpsse_set_multiple(struc
 	int ret;
 	struct mpsse_priv *priv = gpiochip_get_data(chip);
 
+	ret = mpsse_ensure_supported(chip, *mask, GPIO_LINE_DIRECTION_OUT);
+	if (ret)
+		return ret;
+
 	guard(mutex)(&priv->io_mutex);
 	for_each_set_clump8(i, bank_mask, mask, chip->ngpio) {
 		bank = i / 8;
@@ -205,6 +246,10 @@ static int gpio_mpsse_get_multiple(struc
 	int ret;
 	struct mpsse_priv *priv = gpiochip_get_data(chip);
 
+	ret = mpsse_ensure_supported(chip, *mask, GPIO_LINE_DIRECTION_IN);
+	if (ret)
+		return ret;
+
 	guard(mutex)(&priv->io_mutex);
 	for_each_set_clump8(i, bank_mask, mask, chip->ngpio) {
 		bank = i / 8;
@@ -253,10 +298,15 @@ static int gpio_mpsse_gpio_set(struct gp
 static int gpio_mpsse_direction_output(struct gpio_chip *chip,
 				       unsigned int offset, int value)
 {
+	int ret;
 	struct mpsse_priv *priv = gpiochip_get_data(chip);
 	int bank = (offset & 8) >> 3;
 	int bank_offset = offset & 7;
 
+	ret = mpsse_ensure_supported(chip, BIT(offset), GPIO_LINE_DIRECTION_OUT);
+	if (ret)
+		return ret;
+
 	scoped_guard(mutex, &priv->io_mutex)
 		priv->gpio_dir[bank] |= BIT(bank_offset);
 
@@ -266,10 +316,15 @@ static int gpio_mpsse_direction_output(s
 static int gpio_mpsse_direction_input(struct gpio_chip *chip,
 				      unsigned int offset)
 {
+	int ret;
 	struct mpsse_priv *priv = gpiochip_get_data(chip);
 	int bank = (offset & 8) >> 3;
 	int bank_offset = offset & 7;
 
+	ret = mpsse_ensure_supported(chip, BIT(offset), GPIO_LINE_DIRECTION_IN);
+	if (ret)
+		return ret;
+
 	guard(mutex)(&priv->io_mutex);
 	priv->gpio_dir[bank] &= ~BIT(bank_offset);
 	gpio_mpsse_set_bank(priv, bank);
@@ -483,18 +538,49 @@ static void gpio_mpsse_ida_remove(void *
 	ida_free(&gpio_mpsse_ida, priv->id);
 }
 
+static int mpsse_init_valid_mask(struct gpio_chip *chip,
+				 unsigned long *valid_mask,
+				 unsigned int ngpios)
+{
+	struct mpsse_priv *priv = gpiochip_get_data(chip);
+
+	if (WARN_ON(priv == NULL))
+		return -ENODEV;
+
+	*valid_mask = priv->dir_in | priv->dir_out;
+
+	return 0;
+}
+
+static void mpsse_irq_init_valid_mask(struct gpio_chip *chip,
+				      unsigned long *valid_mask,
+				      unsigned int ngpios)
+{
+	struct mpsse_priv *priv = gpiochip_get_data(chip);
+
+	if (WARN_ON(priv == NULL))
+		return;
+
+	/* Can only use IRQ on input capable pins */
+	*valid_mask = priv->dir_in;
+}
+
 static int gpio_mpsse_probe(struct usb_interface *interface,
 			    const struct usb_device_id *id)
 {
 	struct mpsse_priv *priv;
 	struct device *dev;
+	char *serial;
 	int err;
+	struct mpsse_quirk *quirk = (void *)id->driver_info;
 
 	dev = &interface->dev;
 	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
 
+	INIT_LIST_HEAD(&priv->workers);
+
 	priv->udev = usb_get_dev(interface_to_usbdev(interface));
 	priv->intf = interface;
 	priv->intf_id = interface->cur_altsetting->desc.bInterfaceNumber;
@@ -521,9 +607,15 @@ static int gpio_mpsse_probe(struct usb_i
 
 	raw_spin_lock_init(&priv->irq_spin);
 
+	serial = priv->udev->serial;
+	if (!serial)
+		serial = "NONE";
+
 	priv->gpio.label = devm_kasprintf(dev, GFP_KERNEL,
-					  "gpio-mpsse.%d.%d",
-					  priv->id, priv->intf_id);
+					  "MPSSE%04x:%04x.%d.%d.%s",
+					  id->idVendor, id->idProduct,
+					  priv->intf_id, priv->id,
+					  serial);
 	if (!priv->gpio.label)
 		return -ENOMEM;
 
@@ -537,10 +629,20 @@ static int gpio_mpsse_probe(struct usb_i
 	priv->gpio.get_multiple = gpio_mpsse_get_multiple;
 	priv->gpio.set_multiple = gpio_mpsse_set_multiple;
 	priv->gpio.base = -1;
-	priv->gpio.ngpio = 16;
+	priv->gpio.ngpio = MPSSE_NGPIO;
 	priv->gpio.offset = priv->intf_id * priv->gpio.ngpio;
 	priv->gpio.can_sleep = 1;
 
+	if (quirk) {
+		priv->dir_out = quirk->dir_out;
+		priv->dir_in = quirk->dir_in;
+		priv->gpio.names = quirk->names;
+		priv->gpio.init_valid_mask = mpsse_init_valid_mask;
+	} else {
+		priv->dir_in = U16_MAX;
+		priv->dir_out = U16_MAX;
+	}
+
 	err = usb_find_common_endpoints(interface->cur_altsetting,
 					&priv->bulk_in, &priv->bulk_out,
 					NULL, NULL);
@@ -579,6 +681,7 @@ static int gpio_mpsse_probe(struct usb_i
 	priv->gpio.irq.parents = NULL;
 	priv->gpio.irq.default_type = IRQ_TYPE_NONE;
 	priv->gpio.irq.handler = handle_simple_irq;
+	priv->gpio.irq.init_valid_mask = mpsse_irq_init_valid_mask;
 
 	err = devm_gpiochip_add_data(dev, &priv->gpio, priv);
 	if (err)


