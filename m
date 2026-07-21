Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9325B388890;
	Tue, 21 Jul 2026 19:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662358; cv=none; b=pZwK0yWBNRcONoR9FKhY6m5Lurvz1tTc319+ru47sFqMnycDVjTMaGQJst4W8ZcVgeD5byoyQf9dAw4L+zTjDCXX7A80TtxXXBokKKsnRRQUzwLz/vtIX868m36C1yVB1Ca9RaFKZM19NeYYKS9Oev2QCFtzwVzQXC0ZDzDquwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662358; c=relaxed/simple;
	bh=suSSWUyDUJbuYjwXMa4omYUnDz93B+nci8CgDvXb60c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qr8kyzClQg/ccpar5ojL4ICaT1CPlsieHK9TOm7fG5PHlXIH6HKBo0+Zj4/Sget7+tYBR7PpPq+vMLRu7CRjD6DL2wcit7LsYiqaXRqQUno021rMPa6gDY9dZRBwDGZNXzShiowf+GO2b/4bz7bAfhHXer5ZafKyd53Rg/b1F8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UpVTj1fN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UpVTj1fN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDC2D1F000E9;
	Tue, 21 Jul 2026 19:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662357;
	bh=l742RGA8U0J5NWW6N/ZLL8oz/pgGGRShm+gzGxtqcwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UpVTj1fNUTvalRZCJ4FfJ9rz3lxZg3nsBh8qQHaQ7jmJttmoyFRhtSBEo1n/yhIZE
	 ACN2tHMh+MARY7sSVh9cDCxAzsoFraYZByeLe0u8L1IExYK0A/V1yusF7KZPf1gb4f
	 xfA+mJW4xQc/YRZrSuTqwuwmYQKVNBCFbWs4M4Aw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Lauritano <francesco.lauritano1@protonmail.com>,
	Marco Scardovi <mscardovi95@gmail.com>,
	Armin Wolf <W_Armin@gmx.de>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Hans de Goede <johannes.goede@oss.qualcomm.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0412/1276] gpiolib: acpi: Only trigger ActiveBoth interrupts on boot
Date: Tue, 21 Jul 2026 17:14:15 +0200
Message-ID: <20260721152455.315616173@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 3bb62e3f99a557d257e5f5a803200051b7de3afa ]

Commit ca876c7483b6 ("gpiolib-acpi: make sure we trigger edge events at
least once on boot") introduced logic to trigger edge-based GPIO
interrupts during initialization to ensure proper initial state setup
when firmware doesn't initialize it.

However, according to the Microsoft GPIO documentation, triggering GPIO
interrupts during initialization should only happen for interrupts
marked as ActiveBoth (both IRQF_TRIGGER_RISING and IRQF_TRIGGER_FALLING)
and only when the associated GPIO line is already asserted (logic level
low).

The current implementation incorrectly triggers:
1. Any edge-triggered interrupt (RISING-only or FALLING-only)
2. RISING interrupts when value is high and FALLING when value is low

This causes problems at bootup for single-edge interrupts that
don't follow the ActiveBoth pattern.

Fix this by:
- Only triggering when BOTH rising and falling edges are configured
- Only triggering when the GPIO line is asserted (value == 0)

Reported-by: Francesco Lauritano <francesco.lauritano1@protonmail.com>
Closes: https://lore.kernel.org/all/6iFCwGH2vssb7NRUTWGpkubGMNbgIlBHSz40z8ZsezjxngXpoiiRiJaijviNvhiDAGIr43bfUmdxLmxYoHDjyft4DgwFc3Pnu5hzPguTa0s=@protonmail.com/
Tested-by: Marco Scardovi <mscardovi95@gmail.com>
Fixes: ca876c7483b69 ("gpiolib-acpi: make sure we trigger edge events at least once on boot")
Link: https://learn.microsoft.com/en-us/windows-hardware/drivers/bringup/general-purpose-i-o--gpio-
Suggested-by: Armin Wolf <W_Armin@gmx.de>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Reviewed-by: Hans de Goede <johannes.goede@oss.qualcomm.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib-acpi-core.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/drivers/gpio/gpiolib-acpi-core.c b/drivers/gpio/gpiolib-acpi-core.c
index f6bec9d2fd2654..895b891f825dd9 100644
--- a/drivers/gpio/gpiolib-acpi-core.c
+++ b/drivers/gpio/gpiolib-acpi-core.c
@@ -233,12 +233,23 @@ static void acpi_gpiochip_request_irq(struct acpi_gpio_chip *acpi_gpio,
 
 	event->irq_requested = true;
 
-	/* Make sure we trigger the initial state of edge-triggered IRQs */
+	/*
+	 * Make sure we trigger the initial state of ActiveBoth IRQs.
+	 *
+	 * According to the Microsoft GPIO documentation, triggering GPIO
+	 * interrupts marked as ActiveBoth during initialization is correct
+	 * as long as the associated GPIO line is already "asserted"
+	 * (logic level low). We should not trigger edge-based GPIO
+	 * interrupts not marked as ActiveBoth.
+	 *
+	 * See: https://learn.microsoft.com/en-us/windows-hardware/drivers/bringup/general-purpose-i-o--gpio-
+	 * Section: "GPIO controllers and ActiveBoth interrupts"
+	 */
 	if (acpi_gpio_need_run_edge_events_on_boot() &&
-	    (event->irqflags & (IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING))) {
+	    ((event->irqflags & (IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING)) ==
+	     (IRQF_TRIGGER_RISING | IRQF_TRIGGER_FALLING))) {
 		value = gpiod_get_raw_value_cansleep(event->desc);
-		if (((event->irqflags & IRQF_TRIGGER_RISING) && value == 1) ||
-		    ((event->irqflags & IRQF_TRIGGER_FALLING) && value == 0))
+		if (value == 0)
 			event->handler(event->irq, event);
 	}
 }
-- 
2.53.0



