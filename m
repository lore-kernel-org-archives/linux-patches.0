Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C8739446
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:39:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84B39C433C8;
	Sun, 13 Aug 2023 21:39:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691962756;
	bh=wNRvscmA2Zxke4ubHVOHpXt0KjqJKn62DXB4yNNSvPY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VwMLGwJhD6zsZjF5x5XNmRe8PwGWRwHfYdCIuiZZQrAUh18eNt81ugawKF64xvxzD
	 SzpFqIUKzf2YP8ElVDoGhndYr+coX0fTzQPVkBbePLU78ytJvRoyPmIEJRzo4VQCDj
	 l2LTatD8/UYs7wX9smwMGzWiwSTf+X1RlJCph/LA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Trimmer <simont@opensource.cirrus.com>,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 6.1 146/149] ACPI: scan: Create platform device for CS35L56
Date: Sun, 13 Aug 2023 23:19:51 +0200
Message-ID: <20230813211723.060106273@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211718.757428827@linuxfoundation.org>
References: <20230813211718.757428827@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Simon Trimmer <simont@opensource.cirrus.com>

commit 1cd0302be5645420f73090aee26fa787287e1096 upstream.

The ACPI device CSC3556 is a Cirrus Logic CS35L56 mono amplifier which
is used in multiples, and can be connected either to I2C or SPI.

There will be multiple instances under the same Device() node. Add it
to ignore_serial_bus_ids and handle it in the serial-multi-instantiate
driver.

There can be a 5th I2cSerialBusV2, but this is an alias address and doesn't
represent a real device. Ignore this by having a dummy 5th entry in the
serial-multi-instantiate instance list with the name of a non-existent
driver, on the same pattern as done for bsg2150.

Signed-off-by: Simon Trimmer <simont@opensource.cirrus.com>
Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://lore.kernel.org/r/20230728111345.7224-1-rf@opensource.cirrus.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/scan.c                             |    1 +
 drivers/platform/x86/serial-multi-instantiate.c |   14 ++++++++++++++
 2 files changed, 15 insertions(+)

--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -1712,6 +1712,7 @@ static bool acpi_device_enumeration_by_p
 		{"BSG1160", },
 		{"BSG2150", },
 		{"CSC3551", },
+		{"CSC3556", },
 		{"INT33FE", },
 		{"INT3515", },
 		/* Non-conforming _HID for Cirrus Logic already released */
--- a/drivers/platform/x86/serial-multi-instantiate.c
+++ b/drivers/platform/x86/serial-multi-instantiate.c
@@ -330,6 +330,19 @@ static const struct smi_node cs35l41_hda
 	.bus_type = SMI_AUTO_DETECT,
 };
 
+static const struct smi_node cs35l56_hda = {
+	.instances = {
+		{ "cs35l56-hda", IRQ_RESOURCE_AUTO, 0 },
+		{ "cs35l56-hda", IRQ_RESOURCE_AUTO, 0 },
+		{ "cs35l56-hda", IRQ_RESOURCE_AUTO, 0 },
+		{ "cs35l56-hda", IRQ_RESOURCE_AUTO, 0 },
+		/* a 5th entry is an alias address, not a real device */
+		{ "cs35l56-hda_dummy_dev" },
+		{}
+	},
+	.bus_type = SMI_AUTO_DETECT,
+};
+
 /*
  * Note new device-ids must also be added to ignore_serial_bus_ids in
  * drivers/acpi/scan.c: acpi_device_enumeration_by_parent().
@@ -338,6 +351,7 @@ static const struct acpi_device_id smi_a
 	{ "BSG1160", (unsigned long)&bsg1160_data },
 	{ "BSG2150", (unsigned long)&bsg2150_data },
 	{ "CSC3551", (unsigned long)&cs35l41_hda },
+	{ "CSC3556", (unsigned long)&cs35l56_hda },
 	{ "INT3515", (unsigned long)&int3515_data },
 	/* Non-conforming _HID for Cirrus Logic already released */
 	{ "CLSA0100", (unsigned long)&cs35l41_hda },


