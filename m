Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 120432EFD95;
	Tue,  6 Jan 2026 17:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721377; cv=none; b=SwtQIG2UcFaG8lFcG0Bu/irWFSxXep2h6m3ih9h7uiW1v/IK1+L2H8FqIWG1se641n3shzVChgBNKQhOPCAAwuAvHWDWKqFGPFjvMuf+M1eYxS1ho+0hsrNElZmiSiVD714o4UM18QtW4qzGyuGPjlKn7i8O3LQp2qCQRuA3NXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721377; c=relaxed/simple;
	bh=85LdQLz1kXLrWOv6eYUHoHr4pZ8eNwOCck0hRirchs8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QEoVUOzFFgN56f/G7mYOC7YNPSmWtqba10qAisp+Vmh0MFfp+5TY0aYLCGIFGgNAHN0ONr3WNjPWZo6w6Md+UC0ndxQyDRkf+kOiN42NQDDpbGKWuyme8JEe/gOuuGkaImYIH2xn7sYu2DamRNMAtMZKhrVZmjL22exMQbozO3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=niWaVSm5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="niWaVSm5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A7C3C116C6;
	Tue,  6 Jan 2026 17:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721376;
	bh=85LdQLz1kXLrWOv6eYUHoHr4pZ8eNwOCck0hRirchs8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=niWaVSm55T3PVtpLnL0h0acc/3ZLJC68OIMaUZkDXaMbbxwsEGT8/8eOfWmzi07cE
	 OZoTyYQP9UnpuJlgIFnkxBv+nLpXXefIl247q6n/6VXqAHdaQwDy/A/05RQEq+XDIA
	 4Fm+0k1NdOVtMhb5W8ysMS1pkFDKvQNoLVd7WKMo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 518/567] gpiolib: acpi: Add acpi_gpio_need_run_edge_events_on_boot() getter
Date: Tue,  6 Jan 2026 18:05:00 +0100
Message-ID: <20260106170510.543181168@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 5666a8777add09d1167de308df2147983486a0af ]

Add acpi_gpio_need_run_edge_events_on_boot() getter which moves
towards isolating the GPIO ACPI and quirk APIs. It will helps
splitting them completely in the next changes.

No functional changes.

Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Stable-dep-of: 2d967310c49e ("gpiolib: acpi: Add quirk for Dell Precision 7780")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpiolib-acpi.c |    7 ++++++-
 drivers/gpio/gpiolib-acpi.h |    2 ++
 2 files changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/gpio/gpiolib-acpi.c
+++ b/drivers/gpio/gpiolib-acpi.c
@@ -268,7 +268,7 @@ static void acpi_gpiochip_request_irq(st
 	event->irq_requested = true;
 
 	/* Make sure we trigger the initial state of edge-triggered IRQs */
-	if (run_edge_events_on_boot &&
+	if (acpi_gpio_need_run_edge_events_on_boot() &&
 	    (event->irqflags & (IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING))) {
 		value = gpiod_get_raw_value_cansleep(event->desc);
 		if (((event->irqflags & IRQF_TRIGGER_RISING) && value == 1) ||
@@ -371,6 +371,11 @@ void acpi_gpio_remove_from_deferred_list
 	mutex_unlock(&acpi_gpio_deferred_req_irqs_lock);
 }
 
+int acpi_gpio_need_run_edge_events_on_boot(void)
+{
+	return run_edge_events_on_boot;
+}
+
 bool acpi_gpio_in_ignore_list(enum acpi_gpio_ignore_list list, const char *controller_in,
 			      unsigned int pin_in)
 {
--- a/drivers/gpio/gpiolib-acpi.h
+++ b/drivers/gpio/gpiolib-acpi.h
@@ -63,6 +63,8 @@ void acpi_gpio_process_deferred_list(str
 bool acpi_gpio_add_to_deferred_list(struct list_head *list);
 void acpi_gpio_remove_from_deferred_list(struct list_head *list);
 
+int acpi_gpio_need_run_edge_events_on_boot(void);
+
 enum acpi_gpio_ignore_list {
 	ACPI_GPIO_IGNORE_WAKE,
 	ACPI_GPIO_IGNORE_INTERRUPT,


