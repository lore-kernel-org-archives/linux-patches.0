Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB2761991CD;
	Thu,  6 Jun 2024 14:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683661; cv=none; b=hU0BHfQB3IneDE5O6TQrRrDI71n+za8mcddJrmiuuU8B8q0h1rdXuh5QkrOa5owhhjtelJFYb0ATftV0X1vNNWaz8hdR1S9LmHe7RNzx+iNNEYxuQcdcFRPEF8H0if4r4Jc4C+R+6hY5ehgpvjxYnCPQzFrFdRu3lUEyOrAncyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683661; c=relaxed/simple;
	bh=ioeqVuBCoDDOcewBIoHEdWQ9afa5nwgjKxGLueZmL68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FLJ2CQriktnPIMgPHJ4u+ShccqDJd/9wMK1pVJwk8zA0nHPJNXvAakZHM9B7LUYT/Y4bGRizwXn7CjjZRG8QmpTVWk/jvmHYHXazKnttrbQUV63556+Ip687i8iX0AQbL7LugVkq+GguBymVxwFOV6sjN66CRdHTZufIjjgdMiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nQgG8087; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nQgG8087"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABC81C32786;
	Thu,  6 Jun 2024 14:21:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683661;
	bh=ioeqVuBCoDDOcewBIoHEdWQ9afa5nwgjKxGLueZmL68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nQgG8087AQAjf0WbT+Xxvc1Gie3urne/0EFwIWOsIKKkALue2bPdz0nU48g6Zt9IE
	 nRl9vpQ5XtZHSjZysYNv2rnZ1H5L5MwP+KeD5ikvWSfeQzYxHw9NppCldbpMUgvV3O
	 CmZh/S8/PBTBqno0vawbzKa+WM+ewdLNb5zVWXoo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Devyn Liu <liudingyuan@huawei.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 543/744] gpiolib: acpi: Fix failed in acpi_gpiochip_find() by adding parent node match
Date: Thu,  6 Jun 2024 16:03:35 +0200
Message-ID: <20240606131749.871039839@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Devyn Liu <liudingyuan@huawei.com>

[ Upstream commit adbc49a5a8c6fcf7be154c2e30213bbf472940da ]

Previous patch modified the standard used by acpi_gpiochip_find()
to match device nodes. Using the device node set in gc->gpiodev->d-
ev instead of gc->parent.

However, there is a situation in gpio-dwapb where the GPIO device
driver will set gc->fwnode for each port corresponding to a child
node under a GPIO device, so gc->gpiodev->dev will be assigned the
value of each child node in gpiochip_add_data().

gpio-dwapb.c:
128,31 static int dwapb_gpio_add_port(struct dwapb_gpio *gpio,
			       struct dwapb_port_property *pp,
			       unsigned int offs);
port->gc.fwnode = pp->fwnode;

693,39 static int dwapb_gpio_probe;
err = dwapb_gpio_add_port(gpio, &pdata->properties[i], i);

When other drivers request GPIO pin resources through the GPIO device
node provided by ACPI (corresponding to the parent node), the change
of the matching object to gc->gpiodev->dev in acpi_gpiochip_find()
only allows finding the value of each port (child node), resulting
in a failed request.

Reapply the condition of using gc->parent for match in acpi_gpio-
chip_find() in the code can compatible with the problem of gpio-dwapb,
and will not affect the two cases mentioned in the patch:
1. There is no setting for gc->fwnode.
2. The case that depends on using gc->fwnode for match.

Fixes: 5062e4c14b75 ("gpiolib: acpi: use the fwnode in acpi_gpiochip_find()")
Fixes: 067dbc1ea5ce ("gpiolib: acpi: Don't use GPIO chip fwnode in acpi_gpiochip_find()")
Signed-off-by: Devyn Liu <liudingyuan@huawei.com>
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Tested-by: Benjamin Tissoires <bentiss@kernel.org>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib-acpi.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/gpio/gpiolib-acpi.c b/drivers/gpio/gpiolib-acpi.c
index 4ab33d55aec47..b366b4ca4c40e 100644
--- a/drivers/gpio/gpiolib-acpi.c
+++ b/drivers/gpio/gpiolib-acpi.c
@@ -128,7 +128,24 @@ static bool acpi_gpio_deferred_req_irqs_done;
 
 static int acpi_gpiochip_find(struct gpio_chip *gc, void *data)
 {
-	return device_match_acpi_handle(&gc->gpiodev->dev, data);
+	/* First check the actual GPIO device */
+	if (device_match_acpi_handle(&gc->gpiodev->dev, data))
+		return true;
+
+	/*
+	 * When the ACPI device is artificially split to the banks of GPIOs,
+	 * where each of them is represented by a separate GPIO device,
+	 * the firmware node of the physical device may not be shared among
+	 * the banks as they may require different values for the same property,
+	 * e.g., number of GPIOs in a certain bank. In such case the ACPI handle
+	 * of a GPIO device is NULL and can not be used. Hence we have to check
+	 * the parent device to be sure that there is no match before bailing
+	 * out.
+	 */
+	if (gc->parent)
+		return device_match_acpi_handle(gc->parent, data);
+
+	return false;
 }
 
 /**
-- 
2.43.0



