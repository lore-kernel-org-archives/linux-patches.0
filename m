Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CBFF26AA9E;
	Tue,  8 Apr 2025 12:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113721; cv=none; b=Z4UK4I6Xrvsz4fmOmKSMrM115xwH9omYt5SwdoqCUi5QoA/hdfziGdPD9V3GsXQkhfyvgnswhxvhCVQZ3LJXrXp1yWCmGw4Xfmbti9GzMpP86f9bZP8u/GRYOECxLYiUiohKxj0kAzNiTwfP4n+Lmx+1c1gxUTNIWPXxYq46JL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113721; c=relaxed/simple;
	bh=gsGivlZ8ToAElQDYtD1fUXR2NrofFh3UITId27dSyLI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RTsgMaYcoe8KuwHVUmwhKs6e7A7Hl7u91fMwjN8fxH5FD3kPKvPGJIwc7GR5aC+z7t+7FAAkwP0kfHOz8bgkPIAR/dWeKkj95fmJH/K4/oQbMgrpZZSQr2X87e7CU4UUOUi2SmQroI9e/nDXVCtpu27/at8dNpghI1hIyPxTpPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vzLRy6GW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vzLRy6GW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAC30C4CEE5;
	Tue,  8 Apr 2025 12:02:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113721;
	bh=gsGivlZ8ToAElQDYtD1fUXR2NrofFh3UITId27dSyLI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vzLRy6GWEdJx3PclEEH3L9Qt/YM/tAfQlTPDgJTNSVl1QUWZZIlEfeDbaYsfXbu1x
	 xB+AMI5U+V3610w+Pok7nepLdV9WwEFxATKmtdIGmrmeSX12BarSoL1jpfMmbIyS+4
	 P+YnFULF4hp4nI63ip4fpLndCwwGJ0EHlBBekr28=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Agoston Lorincz <pipacsba@gmail.com>,
	All applicable <stable@kernel.org>,
	Hans de Goede <hdegoede@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.6 237/268] ACPI: x86: Extend Lenovo Yoga Tab 3 quirk with skip GPIO event-handlers
Date: Tue,  8 Apr 2025 12:50:48 +0200
Message-ID: <20250408104834.980380370@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit 2fa87c71d2adb4b82c105f9191e6120340feff00 upstream.

Depending on the secureboot signature on EFI\BOOT\BOOTX86.EFI the
Lenovo Yoga Tab 3 UEFI will switch its OSID ACPI variable between
1 (Windows) and 4 (Android(GMIN)).

In Windows mode a GPIO event handler gets installed for GPO1 pin 5,
causing Linux' x86-android-tables code which deals with the general
brokenness of this device's ACPI tables to fail to probe with:

[   17.853705] x86_android_tablets: error -16 getting GPIO INT33FF:01 5
[   17.859623] x86_android_tablets x86_android_tablets: probe with driver

which renders sound, the touchscreen, charging-management,
battery-monitoring and more non functional.

Add ACPI_QUIRK_SKIP_GPIO_EVENT_HANDLERS to the existing quirks for this
device to fix this.

Reported-by: Agoston Lorincz <pipacsba@gmail.com>
Closes: https://lore.kernel.org/platform-driver-x86/CAMEzqD+DNXrAvUOHviB2O2bjtcbmo3xH=kunKr4nubuMLbb_0A@mail.gmail.com/
Cc: All applicable <stable@kernel.org>
Fixes: fe820db35275 ("ACPI: x86: Add skip i2c clients quirk for Lenovo Yoga Tab 3 Pro (YT3-X90F)")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://patch.msgid.link/20250325210450.358506-1-hdegoede@redhat.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/x86/utils.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/acpi/x86/utils.c
+++ b/drivers/acpi/x86/utils.c
@@ -367,7 +367,8 @@ static const struct dmi_system_id acpi_q
 			DMI_MATCH(DMI_PRODUCT_VERSION, "Blade3-10A-001"),
 		},
 		.driver_data = (void *)(ACPI_QUIRK_SKIP_I2C_CLIENTS |
-					ACPI_QUIRK_SKIP_ACPI_AC_AND_BATTERY),
+					ACPI_QUIRK_SKIP_ACPI_AC_AND_BATTERY |
+					ACPI_QUIRK_SKIP_GPIO_EVENT_HANDLERS),
 	},
 	{
 		/* Medion Lifetab S10346 */


