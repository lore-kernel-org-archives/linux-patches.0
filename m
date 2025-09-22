Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 482251F91E3;
	Mon, 22 Sep 2025 19:45:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570347; cv=none; b=ZOwLqxl88EdFvn2ilpu2wvP/6LhPD3kT/LIScmSnQvZtmlDz1IXuiDUHB2tAL/UmG8bMkI4OkPu/dYFMYV1gcb6IbvK0pUvR9y+BkFB0APqQ3WrSysFQHCDblCU5WNcp5or9ExCqLVScwxDIb7DJKDwXS6xqB5ZetqHagRGZlxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570347; c=relaxed/simple;
	bh=7NEpnA/f7cM1HUEQQFJJAIHWT0/v6Ec0BC+XeROY7K4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=avfNq/hJ/UyfSoDB4UMrhtLzNUw6RW4/Hjcx77WjqBeJ4yp5lFnToFvLRcoC/V93xir92WSF2mImhmUpISZZC0qK3t+vFrxtwcfFzsMQ9Ja1hz/1EeulnzhaZRVxBTVG5gkN2TXV+cjVT22TQQPxO26waxrZVbIPyH8yMp96zD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xmN6SXUf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xmN6SXUf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7B8CC4CEF0;
	Mon, 22 Sep 2025 19:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758570347;
	bh=7NEpnA/f7cM1HUEQQFJJAIHWT0/v6Ec0BC+XeROY7K4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xmN6SXUfY6E82pBZo2YEFy3tb52RmFxFUkVqUJMdQMqqAIM7erN6yL8mvu07TC3kc
	 Rtt6E2+rlLP8hpWROHyVL6AADBxmZbyByklNB4bDNTK4afQ2Uif+C4+TifUji6QrHj
	 PjT/DMcbt/IYkpCud25r71/Fca0CMDlX0VdnaVTU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?S=C3=A9bastien=20Szymanski?= <sebastien.szymanski@armadeus.com>,
	Hans de Goede <hansg@kernel.org>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Calvin Owens <calvin@wbinvd.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 6.16 101/149] gpiolib: acpi: initialize acpi_gpio_info struct
Date: Mon, 22 Sep 2025 21:30:01 +0200
Message-ID: <20250922192415.434516925@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192412.885919229@linuxfoundation.org>
References: <20250922192412.885919229@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sébastien Szymanski <sebastien.szymanski@armadeus.com>

commit 19c839a98c731169f06d32e7c9e00c78a0086ebe upstream.

Since commit 7c010d463372 ("gpiolib: acpi: Make sure we fill struct
acpi_gpio_info"), uninitialized acpi_gpio_info struct are passed to
__acpi_find_gpio() and later in the call stack info->quirks is used in
acpi_populate_gpio_lookup. This breaks the i2c_hid_cpi driver:

[   58.122916] i2c_hid_acpi i2c-UNIW0001:00: HID over i2c has not been provided an Int IRQ
[   58.123097] i2c_hid_acpi i2c-UNIW0001:00: probe with driver i2c_hid_acpi failed with error -22

Fix this by initializing the acpi_gpio_info pass to __acpi_find_gpio()

Closes: https://bugzilla.kernel.org/show_bug.cgi?id=220388
Fixes: 7c010d463372 ("gpiolib: acpi: Make sure we fill struct acpi_gpio_info")
Signed-off-by: Sébastien Szymanski <sebastien.szymanski@armadeus.com>
Tested-by: Hans de Goede <hansg@kernel.org>
Reviewed-by: Hans de Goede <hansg@kernel.org>
Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Tested-By: Calvin Owens <calvin@wbinvd.org>
Cc: stable@vger.kernel.org
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpiolib-acpi-core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpio/gpiolib-acpi-core.c
+++ b/drivers/gpio/gpiolib-acpi-core.c
@@ -942,7 +942,7 @@ struct gpio_desc *acpi_find_gpio(struct
 {
 	struct acpi_device *adev = to_acpi_device_node(fwnode);
 	bool can_fallback = acpi_can_fallback_to_crs(adev, con_id);
-	struct acpi_gpio_info info;
+	struct acpi_gpio_info info = {};
 	struct gpio_desc *desc;
 
 	desc = __acpi_find_gpio(fwnode, con_id, idx, can_fallback, &info);
@@ -992,7 +992,7 @@ int acpi_dev_gpio_irq_wake_get_by(struct
 	int ret;
 
 	for (i = 0, idx = 0; idx <= index; i++) {
-		struct acpi_gpio_info info;
+		struct acpi_gpio_info info = {};
 		struct gpio_desc *desc;
 
 		/* Ignore -EPROBE_DEFER, it only matters if idx matches */


