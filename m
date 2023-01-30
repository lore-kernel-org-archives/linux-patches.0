Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8788628EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:07:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D921C433D2;
	Mon, 30 Jan 2023 14:07:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675087650;
	bh=j2G78z+Y1KOFVIoWkBc1EqYnWCP7Dq5tP3tPumRzF9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yChmz7XjnjF6hQWsyXmkmZ18S1Uzi8BP5L6pmgFrRjCM9vZqgjJm0CxlMElp4JWrs
	 nZhWigsc1xisGJxBpkNOrtozKbmohapn2YRpzwKZue6qsRzgscArFV+pjZkksR0XuV
	 sOq//B/QNX5/SdqXJUwqU1RDrvyQhL19eabUdVo0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emmanouil Kouroupakis <kartebi@gmail.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 279/313] ACPI: video: Fix apple gmux detection
Date: Mon, 30 Jan 2023 14:51:54 +0100
Message-Id: <20230130134349.725318598@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
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

[ Upstream commit b0935f110cff5d70da05c5cb1670bee0b07b631c ]

Some apple laptop models have an ACPI device with a HID of APP000B
and that device has an IO resource (so it does not describe the new
unsupported MMIO based gmux type), but there actually is no gmux
in the laptop at all.

The gmux_probe() function of the actual apple-gmux driver has code
to detect this, this code has been factored out into a new
apple_gmux_detect() helper in apple-gmux.h.

Use this new function to fix acpi_video_get_backlight_type() wrongly
returning apple_gmux as type on the following laptops:

MacBookPro5,4
https://pastebin.com/8Xjq7RhS

MacBookPro8,1
https://linux-hardware.org/?probe=e513cfbadb&log=dmesg

MacBookPro9,2
https://bugzilla.kernel.org/attachment.cgi?id=278961

MacBookPro10,2
https://lkml.org/lkml/2014/9/22/657

MacBookPro11,2
https://forums.fedora-fr.org/viewtopic.php?id=70142

MacBookPro11,4
https://raw.githubusercontent.com/im-0/investigate-card-reader-suspend-problem-on-mbp11.4/mast

Fixes: 21245df307cb ("ACPI: video: Add Apple GMUX brightness control detection")
Link: https://lore.kernel.org/platform-driver-x86/20230123113750.462144-1-hdegoede@redhat.com/
Reported-by: Emmanouil Kouroupakis <kartebi@gmail.com>
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20230124105754.62167-4-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/video_detect.c | 24 +++---------------------
 1 file changed, 3 insertions(+), 21 deletions(-)

diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
index 04f3b26e3a75..5c32b318c173 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -110,26 +110,6 @@ static bool nvidia_wmi_ec_supported(void)
 }
 #endif
 
-static bool apple_gmux_backlight_present(void)
-{
-	struct acpi_device *adev;
-	struct device *dev;
-
-	adev = acpi_dev_get_first_match_dev(GMUX_ACPI_HID, NULL, -1);
-	if (!adev)
-		return false;
-
-	dev = acpi_get_first_physical_node(adev);
-	if (!dev)
-		return false;
-
-	/*
-	 * drivers/platform/x86/apple-gmux.c only supports old style
-	 * Apple GMUX with an IO-resource.
-	 */
-	return pnp_get_resource(to_pnp_dev(dev), IORESOURCE_IO, 0) != NULL;
-}
-
 /* Force to use vendor driver when the ACPI device is known to be
  * buggy */
 static int video_detect_force_vendor(const struct dmi_system_id *d)
@@ -781,6 +761,7 @@ static enum acpi_backlight_type __acpi_video_get_backlight_type(bool native)
 {
 	static DEFINE_MUTEX(init_mutex);
 	static bool nvidia_wmi_ec_present;
+	static bool apple_gmux_present;
 	static bool native_available;
 	static bool init_done;
 	static long video_caps;
@@ -794,6 +775,7 @@ static enum acpi_backlight_type __acpi_video_get_backlight_type(bool native)
 				    ACPI_UINT32_MAX, find_video, NULL,
 				    &video_caps, NULL);
 		nvidia_wmi_ec_present = nvidia_wmi_ec_supported();
+		apple_gmux_present = apple_gmux_detect(NULL, NULL);
 		init_done = true;
 	}
 	if (native)
@@ -815,7 +797,7 @@ static enum acpi_backlight_type __acpi_video_get_backlight_type(bool native)
 	if (nvidia_wmi_ec_present)
 		return acpi_backlight_nvidia_wmi_ec;
 
-	if (apple_gmux_backlight_present())
+	if (apple_gmux_present)
 		return acpi_backlight_apple_gmux;
 
 	/* Use ACPI video if available, except when native should be preferred. */
-- 
2.39.0



