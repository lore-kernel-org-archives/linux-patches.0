Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8A8E2FD689;
	Tue,  6 Jan 2026 17:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721370; cv=none; b=O5lLHBzHw3VHqg/CZnq9VkXzsmkc8VfcCxDRPE/7ZL3EQSZBWSMQjngmmKruqSlpj6dQCVhKNuUzz/W+lWEZB+jp+1ngqaFBbGtK7wE792AAJhmFEm/QcynKjdjY3H6sCMfYVMhCFKh3GNKU0HymZukksMus2FEb1pAXc4ctMgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721370; c=relaxed/simple;
	bh=Kw9TPlqbPdoske09aSoa0xgcea9iPh6fvOX62a5V8TA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oLdwGsayh8fmFN89zHcaFJXYg6jfEwZ8ETHdLbTw0QhLbRff0CoIC8Fg2XtC/k44XTRmqVYoHdJgR7oLHt4YrnlEXufl9yQGccZyu/74vdhTPrIfs6RcN8+gy5NmUhtruXfGPg6WOTGIwuatTCPeySVE23ooMRNrA9dQ+gfI0/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=No7LJOB2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="No7LJOB2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31198C116C6;
	Tue,  6 Jan 2026 17:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721370;
	bh=Kw9TPlqbPdoske09aSoa0xgcea9iPh6fvOX62a5V8TA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=No7LJOB2YXSPKydEDdU+/KEJGoFbUF9uk9eDDNd/DdP39oZN0ejNs4bYtTaHaI9/3
	 9qDHIKH/XUh1Gc01GBMzdi0uK7w3OqlIDsDD4czg9tRU5OaFOveak6nD3OAfRDpXuH
	 ccyKWWkx2I6Bm3YqzThpmkS0drMJjXpHBtGbQgQI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 516/567] gpiolib: acpi: Switch to use enum in acpi_gpio_in_ignore_list()
Date: Tue,  6 Jan 2026 18:04:58 +0100
Message-ID: <20260106170510.467898358@linuxfoundation.org>
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

[ Upstream commit b24fd5bc8e6d6b6006db65b5956c2c2cd0ee5a7b ]

Switch to use enum instead of pointers in acpi_gpio_in_ignore_list()
which moves towards isolating the GPIO ACPI and quirk APIs. It will
helps splitting them completely in the next changes.

No functional changes.

Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Stable-dep-of: 2d967310c49e ("gpiolib: acpi: Add quirk for Dell Precision 7780")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpiolib-acpi.c |   21 ++++++++++++++++-----
 drivers/gpio/gpiolib-acpi.h |    8 ++++++++
 2 files changed, 24 insertions(+), 5 deletions(-)

--- a/drivers/gpio/gpiolib-acpi.c
+++ b/drivers/gpio/gpiolib-acpi.c
@@ -350,14 +350,25 @@ static struct gpio_desc *acpi_request_ow
 	return desc;
 }
 
-static bool acpi_gpio_in_ignore_list(const char *ignore_list, const char *controller_in,
-				     unsigned int pin_in)
+bool acpi_gpio_in_ignore_list(enum acpi_gpio_ignore_list list, const char *controller_in,
+			      unsigned int pin_in)
 {
-	const char *controller, *pin_str;
+	const char *ignore_list, *controller, *pin_str;
 	unsigned int pin;
 	char *endp;
 	int len;
 
+	switch (list) {
+	case ACPI_GPIO_IGNORE_WAKE:
+		ignore_list = ignore_wake;
+		break;
+	case ACPI_GPIO_IGNORE_INTERRUPT:
+		ignore_list = ignore_interrupt;
+		break;
+	default:
+		return false;
+	}
+
 	controller = ignore_list;
 	while (controller) {
 		pin_str = strchr(controller, '@');
@@ -394,7 +405,7 @@ static bool acpi_gpio_irq_is_wake(struct
 	if (agpio->wake_capable != ACPI_WAKE_CAPABLE)
 		return false;
 
-	if (acpi_gpio_in_ignore_list(ignore_wake, dev_name(parent), pin)) {
+	if (acpi_gpio_in_ignore_list(ACPI_GPIO_IGNORE_WAKE, dev_name(parent), pin)) {
 		dev_info(parent, "Ignoring wakeup on pin %u\n", pin);
 		return false;
 	}
@@ -437,7 +448,7 @@ static acpi_status acpi_gpiochip_alloc_e
 	if (!handler)
 		return AE_OK;
 
-	if (acpi_gpio_in_ignore_list(ignore_interrupt, dev_name(chip->parent), pin)) {
+	if (acpi_gpio_in_ignore_list(ACPI_GPIO_IGNORE_INTERRUPT, dev_name(chip->parent), pin)) {
 		dev_info(chip->parent, "Ignoring interrupt on pin %u\n", pin);
 		return AE_OK;
 	}
--- a/drivers/gpio/gpiolib-acpi.h
+++ b/drivers/gpio/gpiolib-acpi.h
@@ -58,4 +58,12 @@ static inline int acpi_gpio_count(const
 }
 #endif
 
+enum acpi_gpio_ignore_list {
+	ACPI_GPIO_IGNORE_WAKE,
+	ACPI_GPIO_IGNORE_INTERRUPT,
+};
+
+bool acpi_gpio_in_ignore_list(enum acpi_gpio_ignore_list list,
+			      const char *controller_in, unsigned int pin_in);
+
 #endif /* GPIOLIB_ACPI_H */


