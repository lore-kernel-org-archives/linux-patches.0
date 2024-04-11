Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 232D613B5B9;
	Thu, 11 Apr 2024 10:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830108; cv=none; b=Wms/mB+mLSommapho2ROZzySs0tWk8KbZ2UYfgv8qCnSo2YZyBrHTUkWXGMRr1n4/x/XZ4XFNmtMtaVwqPCphEmpVtQn6RlaYHGE4zyW+0pgHvDnTK8AMGazRW1y90g99h6gft3/IOoSoZj4fAI1ZaHq65zaLkZMrYDXQ8sHUEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830108; c=relaxed/simple;
	bh=7q9fZThaEXYNcB3jQUHqempUIahxqZBS0uh24bNhbu8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QDpd8XzZM/9kKus2D0CW7FJh/CI0VozXuWe1Y5vi4DsgnYB0gnpSrp4GIMn5c5bCsRubwv0P1sfNUGqf9M7/7YSLNBd9KwsiAfeEuZmXGsNtzJqxYD7LFcy6A5oO6TC4AW6VMxumPjl7zPL9z0Iis2yTDkpj9hMtBP+be2870DU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aseznwd8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aseznwd8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DA5BC433F1;
	Thu, 11 Apr 2024 10:08:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830108;
	bh=7q9fZThaEXYNcB3jQUHqempUIahxqZBS0uh24bNhbu8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aseznwd8uceiikpKQmO4lYIDwtVXFnjXU2hHtx4mxFEhMTgNoZB+4p4h2euvYD8bC
	 AVb8vFA3eu2VdZbk6zB7/P/+9bOPtRalEmSH26XBJE89MYg1bU7EwgqfUAWt94QIn8
	 YygEkStyan6z2E56vh0juhcNYv/5Ct8oJndxmkIA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 037/143] ACPI: x86: Add DELL0501 handling to acpi_quirk_skip_serdev_enumeration()
Date: Thu, 11 Apr 2024 11:55:05 +0200
Message-ID: <20240411095422.028801950@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095420.903937140@linuxfoundation.org>
References: <20240411095420.903937140@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 99b572e6136eab69a8c91d72cf8595b256e304b5 ]

Some recent(ish) Dell AIO devices have a backlight controller board
connected to an UART.

This UART has a DELL0501 HID with CID set to PNP0501 so that the UART is
still handled by 8250_pnp.c. Unfortunately there is no separate ACPI device
with an UartSerialBusV2() resource to model the backlight-controller.
This causes the kernel to create a /dev/ttyS0 char-device for the UART
instead of creating an in kernel serdev-controller + serdev-device pair
for a kernel backlight driver.

Use the existing acpi_quirk_skip_serdev_enumeration() mechanism to work
around this by returning skip=true for tty-ctrl parents with a HID
of DELL0501.

Like other cases where the UartSerialBusV2() resource is missing or broken
this will only create the serdev-controller device and the serdev-device
itself will need to be instantiated by platform code.

Unfortunately in this case there is no device for the platform-code
instantiating the serdev-device to bind to. So also create
a platform_device for this.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/x86/utils.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/acpi/x86/utils.c b/drivers/acpi/x86/utils.c
index 8829a907eee02..90c3d2eab9e99 100644
--- a/drivers/acpi/x86/utils.c
+++ b/drivers/acpi/x86/utils.c
@@ -484,8 +484,28 @@ static int acpi_dmi_skip_serdev_enumeration(struct device *controller_parent, bo
 
 int acpi_quirk_skip_serdev_enumeration(struct device *controller_parent, bool *skip)
 {
+	struct acpi_device *adev = ACPI_COMPANION(controller_parent);
+
 	*skip = false;
 
+	/*
+	 * The DELL0501 ACPI HID represents an UART (CID is set to PNP0501) with
+	 * a backlight-controller attached. There is no separate ACPI device with
+	 * an UartSerialBusV2() resource to model the backlight-controller.
+	 * Set skip to true so that the tty core creates a serdev ctrl device.
+	 * The backlight driver will manually create the serdev client device.
+	 */
+	if (acpi_dev_hid_match(adev, "DELL0501")) {
+		*skip = true;
+		/*
+		 * Create a platform dev for dell-uart-backlight to bind to.
+		 * This is a static device, so no need to store the result.
+		 */
+		platform_device_register_simple("dell-uart-backlight", PLATFORM_DEVID_NONE,
+						NULL, 0);
+		return 0;
+	}
+
 	return acpi_dmi_skip_serdev_enumeration(controller_parent, skip);
 }
 EXPORT_SYMBOL_GPL(acpi_quirk_skip_serdev_enumeration);
-- 
2.43.0



