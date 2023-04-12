Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE0322F24
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 08:53:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37E74C433D2;
	Wed, 12 Apr 2023 08:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681289590;
	bh=sly9/30YPyD0IWQ7vKmI4HP88XwqIsqNYaAo/q8a0HM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qvXDSJFPcePzNo675AjRb0KWhQd1g47OpI4nlAwnx7cs8lj1Eirrq1KYdREdw/4ib
	 IRGcjc0k3q+MDjw/CpNfxJlxwZlGIufMFpjFQro2qWdYOjpdj897l6nt43pqgzTC3l
	 j5Q/pHwtFZqND3yeUsfUT7Tn/McPLgXgToJH5cbc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Hans de Goede <hdegoede@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.2 118/173] ACPI: video: Add acpi_backlight=video quirk for Apple iMac14,1 and iMac14,2
Date: Wed, 12 Apr 2023 10:34:04 +0200
Message-Id: <20230412082842.870951516@linuxfoundation.org>
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

commit 2699107989431d6db44f8a9e809ea74c387336d1 upstream.

On the Apple iMac14,1 and iMac14,2 all-in-ones (monitors with builtin "PC")
the connection between the GPU and the panel is seen by the GPU driver as
regular DP instead of eDP, causing the GPU driver to never call
acpi_video_register_backlight().

(GPU drivers only call acpi_video_register_backlight() when an internal
 panel is detected, to avoid non working acpi_video# devices getting
 registered on desktops which unfortunately is a real issue.)

Fix the missing acpi_video# backlight device on these all-in-ones by
adding a acpi_backlight=video DMI quirk, so that video.ko will
immediately register the backlight device instead of waiting for
an acpi_video_register_backlight() call.

Fixes: 5aa9d943e9b6 ("ACPI: video: Don't enable fallback path for creating ACPI backlight by default")
Cc: All applicable <stable@vger.kernel.org>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/video_detect.c |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -277,6 +277,29 @@ static const struct dmi_system_id video_
 	},
 
 	/*
+	 * Models which need acpi_video backlight control where the GPU drivers
+	 * do not call acpi_video_register_backlight() because no internal panel
+	 * is detected. Typically these are all-in-ones (monitors with builtin
+	 * PC) where the panel connection shows up as regular DP instead of eDP.
+	 */
+	{
+	 .callback = video_detect_force_video,
+	 /* Apple iMac14,1 */
+	 .matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
+		DMI_MATCH(DMI_PRODUCT_NAME, "iMac14,1"),
+		},
+	},
+	{
+	 .callback = video_detect_force_video,
+	 /* Apple iMac14,2 */
+	 .matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "Apple Inc."),
+		DMI_MATCH(DMI_PRODUCT_NAME, "iMac14,2"),
+		},
+	},
+
+	/*
 	 * These models have a working acpi_video backlight control, and using
 	 * native backlight causes a regression where backlight does not work
 	 * when userspace is not handling brightness key events. Disable


