Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1452A290A
	for <patches@lists.linux.dev>; Fri, 28 Apr 2023 11:28:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CC2BC433EF;
	Fri, 28 Apr 2023 11:28:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1682681290;
	bh=0DsxCSbGbC9gI6BouZZXD/ALBonxx1qWLe0ITHZCZ8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d6512+kpc1gxInAuxGZxVeSa/jFUibxwxImi1U5GaoM2GHpknPR5ybqMglEmbLs2p
	 BNszLY1tQKL9R7FMX2DSc+5N8EoLpMamgMq9Fq864v6BrB79EOWqW6HPah6WM0GkXK
	 00jpaz8pOs8Jj5sQ9lkndmTW/HpmsUo+7E3wZ2L4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Werner Sembach <wse@tuxedocomputers.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 6.3 05/11] gpiolib: acpi: Add a ignore wakeup quirk for Clevo NL5xNU
Date: Fri, 28 Apr 2023 13:27:40 +0200
Message-Id: <20230428112040.076293369@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230428112039.886496777@linuxfoundation.org>
References: <20230428112039.886496777@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Werner Sembach <wse@tuxedocomputers.com>

commit 782eea0c89f7d071d6b56ecfa1b8b0c81164b9be upstream.

commit 1796f808e4bb ("HID: i2c-hid: acpi: Stop setting wakeup_capable")
changed the policy such that I2C touchpads may be able to wake up the
system by default if the system is configured as such.

However on Clevo NL5xNU there is a mistake in the ACPI tables that the
TP_ATTN# signal connected to GPIO 9 is configured as ActiveLow and level
triggered but connected to a pull up. As soon as the system suspends the
touchpad loses power and then the system wakes up.

To avoid this problem, introduce a quirk for this model that will prevent
the wakeup capability for being set for GPIO 9.

This patch is analoge to a very similar patch for NL5xRU, just the DMI
string changed.

Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Cc: stable@vger.kernel.org
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpio/gpiolib-acpi.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/drivers/gpio/gpiolib-acpi.c
+++ b/drivers/gpio/gpiolib-acpi.c
@@ -1624,6 +1624,19 @@ static const struct dmi_system_id gpioli
 		 * https://gitlab.freedesktop.org/drm/amd/-/issues/1722#note_1720627
 		 */
 		.matches = {
+			DMI_MATCH(DMI_BOARD_NAME, "NL5xNU"),
+		},
+		.driver_data = &(struct acpi_gpiolib_dmi_quirk) {
+			.ignore_wake = "ELAN0415:00@9",
+		},
+	},
+	{
+		/*
+		 * Spurious wakeups from TP_ATTN# pin
+		 * Found in BIOS 1.7.8
+		 * https://gitlab.freedesktop.org/drm/amd/-/issues/1722#note_1720627
+		 */
+		.matches = {
 			DMI_MATCH(DMI_BOARD_NAME, "NL5xRU"),
 		},
 		.driver_data = &(struct acpi_gpiolib_dmi_quirk) {


