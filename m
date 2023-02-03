Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 344051FB4
	for <patches@lists.linux.dev>; Fri,  3 Feb 2023 10:22:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DBF0C433D2;
	Fri,  3 Feb 2023 10:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675419752;
	bh=Q7qWOqn0uiYG3USKw39AvmFMkIF2KP0q1VKW1kHFr/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GSyGmzbRFWIusLe4bJAxEY5LYf380nWuxR+dEIWFQHRcBdrAbewSsami9zU3Dfy4Q
	 0Hv8FbCHrVGYSnvMSVscAhZZHpWDY50Atd8TQ/jIq4+iXLf25NCgyPTOHB5/na58bA
	 Wp6gi5dF3EiWlHMbyCghlmOLQ7NnOEoSrqb7/yFQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Smythe <ncsmythe@scruboak.org>,
	Raul Rangel <rrangel@chromium.org>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 25/28] gpiolib-acpi: Dont set GPIOs for wakeup in S3 mode
Date: Fri,  3 Feb 2023 11:13:13 +0100
Message-Id: <20230203101011.032529307@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101009.946745030@linuxfoundation.org>
References: <20230203101009.946745030@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit d63f11c02b8d3e54bdb65d8c309f73b7f474aec4 ]

commit 1796f808e4bb ("HID: i2c-hid: acpi: Stop setting wakeup_capable")
adjusted the policy to enable wakeup by default if the ACPI tables
indicated that a device was wake capable.

It was reported however that this broke suspend on at least two System76
systems in S3 mode and two Lenovo Gen2a systems, but only with S3.
When the machines are set to s2idle, wakeup behaves properly.

Configuring the GPIOs for wakeup with S3 doesn't work properly, so only
set it when the system supports low power idle.

Fixes: 1796f808e4bb ("HID: i2c-hid: acpi: Stop setting wakeup_capable")
Fixes: b38f2d5d9615c ("i2c: acpi: Use ACPI wake capability bit to set wake_irq")
Link: https://gitlab.freedesktop.org/drm/amd/-/issues/2357
Link: https://bugzilla.redhat.com/show_bug.cgi?id=2162013
Reported-by: Nathan Smythe <ncsmythe@scruboak.org>
Tested-by: Nathan Smythe <ncsmythe@scruboak.org>
Suggested-by: Raul Rangel <rrangel@chromium.org>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Acked-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib-acpi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpio/gpiolib-acpi.c b/drivers/gpio/gpiolib-acpi.c
index e2ab4d5253be..fa3de3c3010c 100644
--- a/drivers/gpio/gpiolib-acpi.c
+++ b/drivers/gpio/gpiolib-acpi.c
@@ -1080,7 +1080,8 @@ int acpi_dev_gpio_irq_wake_get_by(struct acpi_device *adev, const char *name, in
 				dev_dbg(&adev->dev, "IRQ %d already in use\n", irq);
 			}
 
-			if (wake_capable)
+			/* avoid suspend issues with GPIOs when systems are using S3 */
+			if (wake_capable && acpi_gbl_FADT.flags & ACPI_FADT_LOW_POWER_S0)
 				*wake_capable = info.wake_capable;
 
 			return irq;
-- 
2.39.0



