Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7575D2F24
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 08:51:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBBD8C433EF;
	Wed, 12 Apr 2023 08:51:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681289509;
	bh=lvFSa5UtYCeK0PTqjImMgwr9fydJbYwZ4FO0sAbVKHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eqcHo/H/6i0qH3Xj1YX10a+y4eDouQU5xgrzqx48FCNXz/PiwCekx7UGPmnyom4Ub
	 dZ+Jmz3k7x8FhjYAMwjKGNoELWPouHsZEryhuB6d0gXKspMfzPS9oFa4vc7yQwkwpd
	 CEv9KamoyMnrZRfHUUl0Ssx6D/K4U7FrVRUVWqfs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Hans de Goede <hdegoede@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.2 119/173] ACPI: video: Add acpi_backlight=video quirk for Lenovo ThinkPad W530
Date: Wed, 12 Apr 2023 10:34:05 +0200
Message-Id: <20230412082842.907706556@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hans de Goede <hdegoede@redhat.com>

commit a5b2781dcab2c77979a4b8adda781d2543580901 upstream.

The Lenovo ThinkPad W530 uses a nvidia k1000m GPU. When this gets used
together with one of the older nvidia binary driver series (the latest
series does not support it), then backlight control does not work.

This is caused by commit 3dbc80a3e4c5 ("ACPI: video: Make backlight
class device registration a separate step (v2)") combined with
commit 5aa9d943e9b6 ("ACPI: video: Don't enable fallback path for
creating ACPI backlight by default").

After these changes the acpi_video# backlight device is only registered
when requested by a GPU driver calling acpi_video_register_backlight()
which the nvidia binary driver does not do.

I realize that using the nvidia binary driver is not a supported use-case
and users can workaround this by adding acpi_backlight=video on the kernel
commandline, but the ThinkPad W530 is a popular model under Linux users,
so it seems worthwhile to add a quirk for this.

I will also email Nvidia asking them to make the driver call
acpi_video_register_backlight() when an internal LCD panel is detected.
So maybe the next maintenance release of the drivers will fix this...

Fixes: 5aa9d943e9b6 ("ACPI: video: Don't enable fallback path for creating ACPI backlight by default")
Cc: All applicable <stable@vger.kernel.org>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/video_detect.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -300,6 +300,20 @@ static const struct dmi_system_id video_
 	},
 
 	/*
+	 * Older models with nvidia GPU which need acpi_video backlight
+	 * control and where the old nvidia binary driver series does not
+	 * call acpi_video_register_backlight().
+	 */
+	{
+	 .callback = video_detect_force_video,
+	 /* ThinkPad W530 */
+	 .matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+		DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad W530"),
+		},
+	},
+
+	/*
 	 * These models have a working acpi_video backlight control, and using
 	 * native backlight causes a regression where backlight does not work
 	 * when userspace is not handling brightness key events. Disable


