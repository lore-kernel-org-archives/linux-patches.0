Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6206039FD9;
	Fri, 24 Nov 2023 18:26:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E506tNI3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6AB1C433C8;
	Fri, 24 Nov 2023 18:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700850417;
	bh=MbtdrZomPyBlWz/YaQwE7DWbfzS+qnQv1SjVDqLfneM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E506tNI3inFV/RXGzRSOiEofPcXFxKw7/yo7xcErCRBfzfAcSOc7EJdmXV7IMAho+
	 hc2ovmt4MI8qemqZ565AZ+byzvm7s5jxExZMISNefYAZox8XSwHNqAVXJDl6QZxCmA
	 H7bUqJY51+NNrIFitZdof4GtFPOIWlPyBISjg9CI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Andy Shevchenko <andy.shevchenko@gmail.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 041/491] gpiolib: acpi: Add a ignore interrupt quirk for Peaq C1010
Date: Fri, 24 Nov 2023 17:44:37 +0000
Message-ID: <20231124172025.920528624@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172024.664207345@linuxfoundation.org>
References: <20231124172024.664207345@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 6cc64f6173751d212c9833bde39e856b4f585a3e ]

On the Peaq C1010 2-in-1 INT33FC:00 pin 3 is connected to
a "dolby" button. At the ACPI level an _AEI event-handler
is connected which sets an ACPI variable to 1 on both
edges. This variable can be polled + cleared to 0 using WMI.

Since the variable is set on both edges the WMI interface is pretty
useless even when polling. So instead of writing a custom WMI
driver for this the x86-android-tablets code instantiates
a gpio-keys platform device for the "dolby" button.

Add an ignore_interrupt quirk for INT33FC:00 pin 3 on the Peaq C1010,
so that it is not seen as busy when the gpio-keys driver requests it.

Note this replaces a hack in x86-android-tablets where it would
call acpi_gpiochip_free_interrupts() on the INT33FC:00 GPIO
controller. acpi_gpiochip_free_interrupts() is considered private
(internal) gpiolib API so x86-android-tablets should stop using it.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Acked-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Link: https://lore.kernel.org/r/20230909141816.58358-3-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib-acpi.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/gpio/gpiolib-acpi.c b/drivers/gpio/gpiolib-acpi.c
index a775d2bdac94f..980ec04892173 100644
--- a/drivers/gpio/gpiolib-acpi.c
+++ b/drivers/gpio/gpiolib-acpi.c
@@ -1655,6 +1655,26 @@ static const struct dmi_system_id gpiolib_acpi_quirks[] __initconst = {
 			.ignore_wake = "SYNA1202:00@16",
 		},
 	},
+	{
+		/*
+		 * On the Peaq C1010 2-in-1 INT33FC:00 pin 3 is connected to
+		 * a "dolby" button. At the ACPI level an _AEI event-handler
+		 * is connected which sets an ACPI variable to 1 on both
+		 * edges. This variable can be polled + cleared to 0 using
+		 * WMI. But since the variable is set on both edges the WMI
+		 * interface is pretty useless even when polling.
+		 * So instead the x86-android-tablets code instantiates
+		 * a gpio-keys platform device for it.
+		 * Ignore the _AEI handler for the pin, so that it is not busy.
+		 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "PEAQ"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "PEAQ PMM C1010 MD99187"),
+		},
+		.driver_data = &(struct acpi_gpiolib_dmi_quirk) {
+			.ignore_interrupt = "INT33FC:00@3",
+		},
+	},
 	{} /* Terminating entry */
 };
 
-- 
2.42.0



