Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F8B13BB2C
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eEh2aufV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0072AC433C8;
	Wed, 15 Nov 2023 19:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700078007;
	bh=wB0IdGWF3ct1xrYs6fsjNUBzbWV3lmusDMtnrV7dNGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eEh2aufVwd0RGvcJdIuKFapmSq6HqS765bFwUHArTQPWaNbC4rerni1a2MC1QUbdn
	 hLQmgVEAUa32HZLKySa2IsCir1D2oaoqfvSfeWnVQnnJodc1EGxCEfE0fa+XnrahV/
	 Pvldt45v1l+M2jFfQTn/+br+1F/huy5TwR0lIqGc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ondrej Zary <linux@zary.sk>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: =?UTF-8?q?=5BPATCH=206=2E1=20052/379=5D=20=3D=3FUTF-8=3Fq=3FACPI=3A=3D20video=3A=3D20Add=3D20acpi=3D5Fbacklight=3D3Dvendor=3D20quir=3F=3D=20=3D=3FUTF-8=3Fq=3Fk=3D20for=3D20Toshiba=3D20Port=3DC3=3DA9g=3DC3=3DA9=3D20R100=3F=3D?=
Date: Wed, 15 Nov 2023 14:22:07 -0500
Message-ID: <20231115192648.239544306@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115192645.143643130@linuxfoundation.org>
References: <20231115192645.143643130@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ondrej Zary <linux@zary.sk>

[ Upstream commit 35a341c9b25da6a479bd8013bcb11a680a7233e3 ]

Toshiba Portégé R100 has both acpi_video and toshiba_acpi vendor
backlight driver working. But none of them gets activated as it has
a VGA with no kernel driver (Trident CyberBlade XP4m32).

The DMI strings are very generic ("Portable PC") so add a custom
callback function to check for Trident CyberBlade XP4m32 PCI device
before enabling the vendor backlight driver (better than acpi_video
as it has more brightness steps).

Fixes: 5aa9d943e9b6 ("ACPI: video: Don't enable fallback path for creating ACPI backlight by default")
Signed-off-by: Ondrej Zary <linux@zary.sk>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/video_detect.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
index 073d26ddb6c21..60b0128a10e86 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -130,6 +130,16 @@ static int video_detect_force_native(const struct dmi_system_id *d)
 	return 0;
 }
 
+static int video_detect_portege_r100(const struct dmi_system_id *d)
+{
+	struct pci_dev *dev;
+	/* Search for Trident CyberBlade XP4m32 to confirm Portégé R100 */
+	dev = pci_get_device(PCI_VENDOR_ID_TRIDENT, 0x2100, NULL);
+	if (dev)
+		acpi_backlight_dmi = acpi_backlight_vendor;
+	return 0;
+}
+
 static const struct dmi_system_id video_detect_dmi_table[] = {
 	/*
 	 * Models which should use the vendor backlight interface,
@@ -268,6 +278,22 @@ static const struct dmi_system_id video_detect_dmi_table[] = {
 		},
 	},
 
+	/*
+	 * Toshiba Portégé R100 has working both acpi_video and toshiba_acpi
+	 * vendor driver. But none of them gets activated as it has a VGA with
+	 * no kernel driver (Trident CyberBlade XP4m32).
+	 * The DMI strings are generic so check for the VGA chip in callback.
+	 */
+	{
+	 .callback = video_detect_portege_r100,
+	 .matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "TOSHIBA"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "Portable PC"),
+		DMI_MATCH(DMI_PRODUCT_VERSION, "Version 1.0"),
+		DMI_MATCH(DMI_BOARD_NAME, "Portable PC")
+		},
+	},
+
 	/*
 	 * Models which need acpi_video backlight control where the GPU drivers
 	 * do not call acpi_video_register_backlight() because no internal panel
-- 
2.42.0



