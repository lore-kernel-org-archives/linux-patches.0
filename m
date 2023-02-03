Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 325441FB4
	for <patches@lists.linux.dev>; Fri,  3 Feb 2023 10:22:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99930C433EF;
	Fri,  3 Feb 2023 10:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675419749;
	bh=30/fEIyNjO78NLd5i12CCS3QFu3r/KSi4jfHb1LtoB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CkjmOged+dFfo6MLtIGvv+Ueh0qNmul/P5TxMMLFu+sFaTgfx6LWFT2p2oJoAdxPC
	 +n+C2zya+KuQ/TRi5gxzhcl7Ioe3q24xHrXvLhBbKNE+HzTsk22K3DSQgd0YNxgd+h
	 CtoIeKSbESh2JoPLlhHEyToUOSPz3mpfbm3jO27Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Werner Sembach <wse@tuxedocomputers.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 24/28] gpiolib: acpi: Add a ignore wakeup quirk for Clevo NL5xRU
Date: Fri,  3 Feb 2023 11:13:12 +0100
Message-Id: <20230203101010.993729441@linuxfoundation.org>
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

[ Upstream commit 4cb786180dfb5258ff3111181b5e4ecb1d4a297b ]

commit 1796f808e4bb ("HID: i2c-hid: acpi: Stop setting wakeup_capable")
changed the policy such that I2C touchpads may be able to wake up the
system by default if the system is configured as such.

However on Clevo NL5xRU there is a mistake in the ACPI tables that the
TP_ATTN# signal connected to GPIO 9 is configured as ActiveLow and level
triggered but connected to a pull up. As soon as the system suspends the
touchpad loses power and then the system wakes up.

To avoid this problem, introduce a quirk for this model that will prevent
the wakeup capability for being set for GPIO 9.

Fixes: 1796f808e4bb ("HID: i2c-hid: acpi: Stop setting wakeup_capable")
Reported-by: Werner Sembach <wse@tuxedocomputers.com>
Link: https://gitlab.freedesktop.org/drm/amd/-/issues/1722#note_1720627
Co-developed-by: Werner Sembach <wse@tuxedocomputers.com>
Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpio/gpiolib-acpi.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/gpio/gpiolib-acpi.c b/drivers/gpio/gpiolib-acpi.c
index 27f234637a15..e2ab4d5253be 100644
--- a/drivers/gpio/gpiolib-acpi.c
+++ b/drivers/gpio/gpiolib-acpi.c
@@ -1599,6 +1599,19 @@ static const struct dmi_system_id gpiolib_acpi_quirks[] __initconst = {
 			.ignore_interrupt = "AMDI0030:00@18",
 		},
 	},
+	{
+		/*
+		 * Spurious wakeups from TP_ATTN# pin
+		 * Found in BIOS 1.7.8
+		 * https://gitlab.freedesktop.org/drm/amd/-/issues/1722#note_1720627
+		 */
+		.matches = {
+			DMI_MATCH(DMI_BOARD_NAME, "NL5xRU"),
+		},
+		.driver_data = &(struct acpi_gpiolib_dmi_quirk) {
+			.ignore_wake = "ELAN0415:00@9",
+		},
+	},
 	{} /* Terminating entry */
 };
 
-- 
2.39.0



