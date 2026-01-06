Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F27902FD7C3;
	Tue,  6 Jan 2026 17:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721374; cv=none; b=FlcIWrlHxAHXaroBfrIJnwxxol/tyH2WCUshBzVfFTINVBRHgJtMUWFznYqq/W+9CdXsparene+jDYve4qXCjaK4ea4EGhY5xhyvNCD3HubOY15+JaI0pFHbP+Ra8+wiGY8SjJaxL65+sX2pX0ganChVgfGvASh5m9v3TU4B1Ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721374; c=relaxed/simple;
	bh=Qkmh3FBoey17/0Cn3R9A8zMdccy9DrwLtCfkunaSeUg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MhwLP/8la3W8qUYfQAJ+iDAQrc4ZV0P8tcbCwp911N2/D71A3V+8WlMGM0XZzunluyi6in9g5Y5mcRM0JbWL3Rh4D72VHchBMDD21ls19fI3cqllRPCXePjMCwvdq8TpQlI6zEnZ+E/AWosn/mIvLFRfFhAb+IMBxs56JTzv1m4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KBKKhjU4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KBKKhjU4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 684CEC116C6;
	Tue,  6 Jan 2026 17:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721373;
	bh=Qkmh3FBoey17/0Cn3R9A8zMdccy9DrwLtCfkunaSeUg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KBKKhjU4Na1qxzSwtPFUwHTKtWBjPtW3wb3mIC30E4O9f/DGtUBQU9rNyaKb/njC6
	 7GT0TD6IBmgAdNdjfUCT9cn98dbf/BNEi1ha0jB63Cfm0u0BfJ/tY7WjHf16thiH2V
	 ORIsh2pjA7wY1J7BLSHQUdKGbKLpZUbpIowtLUP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 517/567] gpiolib: acpi: Handle deferred list via new API
Date: Tue,  6 Jan 2026 18:04:59 +0100
Message-ID: <20260106170510.505523653@linuxfoundation.org>
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

[ Upstream commit a594877663d1e3d5cf57ec8af739582fc5c47cec ]

Introduce a new API and handle deferred list via it which moves
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
 drivers/gpio/gpiolib-acpi.c |   52 +++++++++++++++++++++++++++-----------------
 drivers/gpio/gpiolib-acpi.h |    5 ++++
 2 files changed, 37 insertions(+), 20 deletions(-)

--- a/drivers/gpio/gpiolib-acpi.c
+++ b/drivers/gpio/gpiolib-acpi.c
@@ -350,6 +350,27 @@ static struct gpio_desc *acpi_request_ow
 	return desc;
 }
 
+bool acpi_gpio_add_to_deferred_list(struct list_head *list)
+{
+	bool defer;
+
+	mutex_lock(&acpi_gpio_deferred_req_irqs_lock);
+	defer = !acpi_gpio_deferred_req_irqs_done;
+	if (defer)
+		list_add(list, &acpi_gpio_deferred_req_irqs_list);
+	mutex_unlock(&acpi_gpio_deferred_req_irqs_lock);
+
+	return defer;
+}
+
+void acpi_gpio_remove_from_deferred_list(struct list_head *list)
+{
+	mutex_lock(&acpi_gpio_deferred_req_irqs_lock);
+	if (!list_empty(list))
+		list_del_init(list);
+	mutex_unlock(&acpi_gpio_deferred_req_irqs_lock);
+}
+
 bool acpi_gpio_in_ignore_list(enum acpi_gpio_ignore_list list, const char *controller_in,
 			      unsigned int pin_in)
 {
@@ -536,7 +557,6 @@ void acpi_gpiochip_request_interrupts(st
 	struct acpi_gpio_chip *acpi_gpio;
 	acpi_handle handle;
 	acpi_status status;
-	bool defer;
 
 	if (!chip->parent || !chip->to_irq)
 		return;
@@ -555,14 +575,7 @@ void acpi_gpiochip_request_interrupts(st
 	acpi_walk_resources(handle, METHOD_NAME__AEI,
 			    acpi_gpiochip_alloc_event, acpi_gpio);
 
-	mutex_lock(&acpi_gpio_deferred_req_irqs_lock);
-	defer = !acpi_gpio_deferred_req_irqs_done;
-	if (defer)
-		list_add(&acpi_gpio->deferred_req_irqs_list_entry,
-			 &acpi_gpio_deferred_req_irqs_list);
-	mutex_unlock(&acpi_gpio_deferred_req_irqs_lock);
-
-	if (defer)
+	if (acpi_gpio_add_to_deferred_list(&acpi_gpio->deferred_req_irqs_list_entry))
 		return;
 
 	acpi_gpiochip_request_irqs(acpi_gpio);
@@ -594,10 +607,7 @@ void acpi_gpiochip_free_interrupts(struc
 	if (ACPI_FAILURE(status))
 		return;
 
-	mutex_lock(&acpi_gpio_deferred_req_irqs_lock);
-	if (!list_empty(&acpi_gpio->deferred_req_irqs_list_entry))
-		list_del_init(&acpi_gpio->deferred_req_irqs_list_entry);
-	mutex_unlock(&acpi_gpio_deferred_req_irqs_lock);
+	acpi_gpio_remove_from_deferred_list(&acpi_gpio->deferred_req_irqs_list_entry);
 
 	list_for_each_entry_safe_reverse(event, ep, &acpi_gpio->events, node) {
 		if (event->irq_requested) {
@@ -615,6 +625,14 @@ void acpi_gpiochip_free_interrupts(struc
 }
 EXPORT_SYMBOL_GPL(acpi_gpiochip_free_interrupts);
 
+void __init acpi_gpio_process_deferred_list(struct list_head *list)
+{
+	struct acpi_gpio_chip *acpi_gpio, *tmp;
+
+	list_for_each_entry_safe(acpi_gpio, tmp, list, deferred_req_irqs_list_entry)
+		acpi_gpiochip_request_irqs(acpi_gpio);
+}
+
 int acpi_dev_add_driver_gpios(struct acpi_device *adev,
 			      const struct acpi_gpio_mapping *gpios)
 {
@@ -1505,14 +1523,8 @@ int acpi_gpio_count(const struct fwnode_
 /* Run deferred acpi_gpiochip_request_irqs() */
 static int __init acpi_gpio_handle_deferred_request_irqs(void)
 {
-	struct acpi_gpio_chip *acpi_gpio, *tmp;
-
 	mutex_lock(&acpi_gpio_deferred_req_irqs_lock);
-	list_for_each_entry_safe(acpi_gpio, tmp,
-				 &acpi_gpio_deferred_req_irqs_list,
-				 deferred_req_irqs_list_entry)
-		acpi_gpiochip_request_irqs(acpi_gpio);
-
+	acpi_gpio_process_deferred_list(&acpi_gpio_deferred_req_irqs_list);
 	acpi_gpio_deferred_req_irqs_done = true;
 	mutex_unlock(&acpi_gpio_deferred_req_irqs_lock);
 
--- a/drivers/gpio/gpiolib-acpi.h
+++ b/drivers/gpio/gpiolib-acpi.h
@@ -58,6 +58,11 @@ static inline int acpi_gpio_count(const
 }
 #endif
 
+void acpi_gpio_process_deferred_list(struct list_head *list);
+
+bool acpi_gpio_add_to_deferred_list(struct list_head *list);
+void acpi_gpio_remove_from_deferred_list(struct list_head *list);
+
 enum acpi_gpio_ignore_list {
 	ACPI_GPIO_IGNORE_WAKE,
 	ACPI_GPIO_IGNORE_INTERRUPT,


