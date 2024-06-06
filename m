Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DD0B19925A;
	Thu,  6 Jun 2024 14:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682993; cv=none; b=T+SYpGkSTk3Ao+b41X3hCZ0LroIpbOWJ6+nsN2Fgzn+Uvwo0I2uWtrymSnOv0x0Yk3HznHA1eAb5ttUnxCPsFRjYIhffiA23w+8RU6v/5OTeXqpZ9WsLYCBhfvrJL7fMtKlgGhAXttyfpP0z+pqSfgruSVO3f6nS1QEKZa6UKy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682993; c=relaxed/simple;
	bh=obTpoU3wKrgPjKAvLVBgqm9DVcAe3E3g3Tht6nqHTDA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WaUQ8JcvSLj58Y+vhR/MxzszuewZDRZkGRP9vgbvV0RWatB9JXhn9Za2Fen8I3MFRb6pT7ihDWFTNtuTxKghKSLnVRo+XKKMcLbx71dqxUrT8DWyzwMTIjMw6tATUzGfE4dJ4gnEcA4wJJIO6LkII8jEk2L6qvXJ3tFiXcmHfxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YkGfpLwF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YkGfpLwF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4C36C32782;
	Thu,  6 Jun 2024 14:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682992;
	bh=obTpoU3wKrgPjKAvLVBgqm9DVcAe3E3g3Tht6nqHTDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YkGfpLwFhHDES1a0VdUTR6l/ZPgRLFPynZ3LsRp7x9hkAbmGjf0WN8CwdGzXKu4uQ
	 8Aicr4YK71KCMlEXxVaGFfqELZ1CB/iXatn7wOydUnLCuyWw3qV8+o7N3SDKSnhpoA
	 3X6zD4YUyXDVHjOILQMW86qsK8wxZJgtJH7uN1mU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Devyn Liu <liudingyuan@huawei.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Benjamin Tissoires <bentiss@kernel.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 145/374] gpiolib: acpi: Fix failed in acpi_gpiochip_find() by adding parent node match
Date: Thu,  6 Jun 2024 16:02:04 +0200
Message-ID: <20240606131656.772785441@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index 7f140df40f35b..c1e190d3ea244 100644
--- a/drivers/gpio/gpiolib-acpi.c
+++ b/drivers/gpio/gpiolib-acpi.c
@@ -128,7 +128,24 @@ static bool acpi_gpio_deferred_req_irqs_done;
 
 static int acpi_gpiochip_find(struct gpio_chip *gc, const void *data)
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



