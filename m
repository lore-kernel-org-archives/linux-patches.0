Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46AAD1BC9E3;
	Tue, 27 Aug 2024 15:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771574; cv=none; b=aWjSF1F0oi7ANEA5V4xIZ0OdSa3pEyVL/0Iha+Hc/LuH2dB1f4nkYvGadyELgjrslf2VWzJchbHb1PvMZ1uOFfep+iztAgYVISD6gMgy/OiybM1n8guE/KHpeB9EoA1hcppEStRbC/vI5tunfs5mdFUqtnSOdr1BLt1vKKkEEhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771574; c=relaxed/simple;
	bh=2RP35QYCoBQ/LLiYlokbIvsFcaJkJm55gQHOFl39Aw0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F9Cb+kqIUsUe2MzZpu6IquBlW/E9NF7YStdvodYQ3R88IqS5hisyFPElj7jBNTRu8rJkV7/Ff1u9Zjhxo23b7SzFkv1POLWkwnhZFFNrky05hicZ9ZL2IEpRxIkJ4QTE5f1Egzk5EW1O+hhDP8ZLcWFTrmCbJruDajJ4qi1wGOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=llu1ABkd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="llu1ABkd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA6B8C61043;
	Tue, 27 Aug 2024 15:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771574;
	bh=2RP35QYCoBQ/LLiYlokbIvsFcaJkJm55gQHOFl39Aw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=llu1ABkd2PXJrH3TXJTC9mUGtYcnVeEOIlWJn/h/R/EquxNUCaZqTTnpwMJbhPPQi
	 F4543yvQ0XF+zfIDH3r3Ls3jVPeKIusRiKF/ypOgtPr3pKKB6pU5fQczFmgyrq6mpE
	 9k+US4vR+GIM9vsHsOQG+8RIE+gWZ5ut+jPpXMf0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Andy Shevchenko <andy@kernel.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.10 228/273] ACPI: video: Add Dell UART backlight controller detection
Date: Tue, 27 Aug 2024 16:39:12 +0200
Message-ID: <20240827143842.083681796@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143833.371588371@linuxfoundation.org>
References: <20240827143833.371588371@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit cd8e468efb4fb2742e06328a75b282c35c1abf8d upstream.

Dell All In One (AIO) models released after 2017 use a backlight
controller board connected to an UART.

In DSDT this uart port will be defined as:

   Name (_HID, "DELL0501")
   Name (_CID, EisaId ("PNP0501")

Commit 484bae9e4d6a ("platform/x86: Add new Dell UART backlight driver")
has added support for this, but I neglected to tie this into
acpi_video_get_backlight_type().

Now the first AIO has turned up which has not only the DSDT bits for this,
but also an actual controller attached to the UART, yet it is not using
this controller for backlight control.

Add support to acpi_video_get_backlight_type() for a new dell_uart
backlight type. So that the existing infra to override the backlight
control method on the commandline or with DMI quirks can be used.

Fixes: 484bae9e4d6a ("platform/x86: Add new Dell UART backlight driver")
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Andy Shevchenko <andy@kernel.org>
Link: https://patch.msgid.link/20240814190159.15650-2-hdegoede@redhat.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/video_detect.c |    7 +++++++
 include/acpi/video.h        |    1 +
 2 files changed, 8 insertions(+)

--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -54,6 +54,8 @@ static void acpi_video_parse_cmdline(voi
 		acpi_backlight_cmdline = acpi_backlight_nvidia_wmi_ec;
 	if (!strcmp("apple_gmux", acpi_video_backlight_string))
 		acpi_backlight_cmdline = acpi_backlight_apple_gmux;
+	if (!strcmp("dell_uart", acpi_video_backlight_string))
+		acpi_backlight_cmdline = acpi_backlight_dell_uart;
 	if (!strcmp("none", acpi_video_backlight_string))
 		acpi_backlight_cmdline = acpi_backlight_none;
 }
@@ -902,6 +904,7 @@ enum acpi_backlight_type __acpi_video_ge
 	static DEFINE_MUTEX(init_mutex);
 	static bool nvidia_wmi_ec_present;
 	static bool apple_gmux_present;
+	static bool dell_uart_present;
 	static bool native_available;
 	static bool init_done;
 	static long video_caps;
@@ -916,6 +919,7 @@ enum acpi_backlight_type __acpi_video_ge
 				    &video_caps, NULL);
 		nvidia_wmi_ec_present = nvidia_wmi_ec_supported();
 		apple_gmux_present = apple_gmux_detect(NULL, NULL);
+		dell_uart_present = acpi_dev_present("DELL0501", NULL, -1);
 		init_done = true;
 	}
 	if (native)
@@ -946,6 +950,9 @@ enum acpi_backlight_type __acpi_video_ge
 	if (apple_gmux_present)
 		return acpi_backlight_apple_gmux;
 
+	if (dell_uart_present)
+		return acpi_backlight_dell_uart;
+
 	/* Use ACPI video if available, except when native should be preferred. */
 	if ((video_caps & ACPI_VIDEO_BACKLIGHT) &&
 	     !(native_available && prefer_native_over_acpi_video()))
--- a/include/acpi/video.h
+++ b/include/acpi/video.h
@@ -50,6 +50,7 @@ enum acpi_backlight_type {
 	acpi_backlight_native,
 	acpi_backlight_nvidia_wmi_ec,
 	acpi_backlight_apple_gmux,
+	acpi_backlight_dell_uart,
 };
 
 #if IS_ENABLED(CONFIG_ACPI_VIDEO)


