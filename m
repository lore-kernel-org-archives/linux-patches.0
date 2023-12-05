Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF6A66AA0;
	Tue,  5 Dec 2023 03:21:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F62ilL4P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42644C433C8;
	Tue,  5 Dec 2023 03:21:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701746486;
	bh=LcM6gpOvIAmccLQ2m+yb+d+rHxgSs6vbbOIpfjAxte0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F62ilL4PIJ4/8r3OSsNpxMo6Y2D1PSwrIUOts6B5Q81EFP0ftqoZgkoaWjqCmY5Rd
	 QNdRn5xHf/X7aFmQLNm/RfxiJM7ldwRs/kruIiOZB+qGm1+H1f9vD4Zrz/CdL3QmZc
	 pHugyzU/8dOb+ZyrO/VI+gIMHVfIFFyPohRP9Rnc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.6 041/134] ACPI: video: Use acpi_video_device for cooling-dev driver data
Date: Tue,  5 Dec 2023 12:15:13 +0900
Message-ID: <20231205031538.136810378@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031535.163661217@linuxfoundation.org>
References: <20231205031535.163661217@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

commit 172c48caed91a978bca078042222d09baea13717 upstream.

The acpi_video code was storing the acpi_video_device as driver_data
in the acpi_device children of the acpi_video_bus acpi_device.

But the acpi_video driver only binds to the bus acpi_device.
It uses, but does not bind to, the children. Since it is not
the driver it should not be using the driver_data of the children's
acpi_device-s.

Since commit 0d16710146a1 ("ACPI: bus: Set driver_data to NULL every
time .add() fails") the childen's driver_data ends up getting set
to NULL after a driver fails to bind to the children leading to a NULL
pointer deref in video_get_max_state when registering the cooling-dev:

[    3.148958] BUG: kernel NULL pointer dereference, address: 0000000000000090
<snip>
[    3.149015] Hardware name: Sony Corporation VPCSB2X9R/VAIO, BIOS R2087H4 06/15/2012
[    3.149021] RIP: 0010:video_get_max_state+0x17/0x30 [video]
<snip>
[    3.149105] Call Trace:
[    3.149110]  <TASK>
[    3.149114]  ? __die+0x23/0x70
[    3.149126]  ? page_fault_oops+0x171/0x4e0
[    3.149137]  ? exc_page_fault+0x7f/0x180
[    3.149147]  ? asm_exc_page_fault+0x26/0x30
[    3.149158]  ? video_get_max_state+0x17/0x30 [video 9b6f3f0d19d7b4a0e2df17a2d8b43bc19c2ed71f]
[    3.149176]  ? __pfx_video_get_max_state+0x10/0x10 [video 9b6f3f0d19d7b4a0e2df17a2d8b43bc19c2ed71f]
[    3.149192]  __thermal_cooling_device_register.part.0+0xf2/0x2f0
[    3.149205]  acpi_video_bus_register_backlight.part.0.isra.0+0x414/0x570 [video 9b6f3f0d19d7b4a0e2df17a2d8b43bc19c2ed71f]
[    3.149227]  acpi_video_register_backlight+0x57/0x80 [video 9b6f3f0d19d7b4a0e2df17a2d8b43bc19c2ed71f]
[    3.149245]  intel_acpi_video_register+0x68/0x90 [i915 1f3a758130b32ef13d301d4f8f78c7d766d57f2a]
[    3.149669]  intel_display_driver_register+0x28/0x50 [i915 1f3a758130b32ef13d301d4f8f78c7d766d57f2a]
[    3.150064]  i915_driver_probe+0x790/0xb90 [i915 1f3a758130b32ef13d301d4f8f78c7d766d57f2a]
[    3.150402]  local_pci_probe+0x45/0xa0
[    3.150412]  pci_device_probe+0xc1/0x260
<snip>

Fix this by directly using the acpi_video_device as devdata for
the cooling-device, which avoids the need to set driver-data on
the children at all.

Fixes: 0d16710146a1 ("ACPI: bus: Set driver_data to NULL every time .add() fails")
Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/9718
Cc: 6.6+ <stable@vger.kernel.org> # 6.6+
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/acpi_video.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/acpi/acpi_video.c b/drivers/acpi/acpi_video.c
index d321ca7160d9..6cee536c229a 100644
--- a/drivers/acpi/acpi_video.c
+++ b/drivers/acpi/acpi_video.c
@@ -253,8 +253,7 @@ static const struct backlight_ops acpi_backlight_ops = {
 static int video_get_max_state(struct thermal_cooling_device *cooling_dev,
 			       unsigned long *state)
 {
-	struct acpi_device *device = cooling_dev->devdata;
-	struct acpi_video_device *video = acpi_driver_data(device);
+	struct acpi_video_device *video = cooling_dev->devdata;
 
 	*state = video->brightness->count - ACPI_VIDEO_FIRST_LEVEL - 1;
 	return 0;
@@ -263,8 +262,7 @@ static int video_get_max_state(struct thermal_cooling_device *cooling_dev,
 static int video_get_cur_state(struct thermal_cooling_device *cooling_dev,
 			       unsigned long *state)
 {
-	struct acpi_device *device = cooling_dev->devdata;
-	struct acpi_video_device *video = acpi_driver_data(device);
+	struct acpi_video_device *video = cooling_dev->devdata;
 	unsigned long long level;
 	int offset;
 
@@ -283,8 +281,7 @@ static int video_get_cur_state(struct thermal_cooling_device *cooling_dev,
 static int
 video_set_cur_state(struct thermal_cooling_device *cooling_dev, unsigned long state)
 {
-	struct acpi_device *device = cooling_dev->devdata;
-	struct acpi_video_device *video = acpi_driver_data(device);
+	struct acpi_video_device *video = cooling_dev->devdata;
 	int level;
 
 	if (state >= video->brightness->count - ACPI_VIDEO_FIRST_LEVEL)
@@ -1125,7 +1122,6 @@ static int acpi_video_bus_get_one_device(struct acpi_device *device, void *arg)
 
 	strcpy(acpi_device_name(device), ACPI_VIDEO_DEVICE_NAME);
 	strcpy(acpi_device_class(device), ACPI_VIDEO_CLASS);
-	device->driver_data = data;
 
 	data->device_id = device_id;
 	data->video = video;
@@ -1747,8 +1743,8 @@ static void acpi_video_dev_register_backlight(struct acpi_video_device *device)
 	device->backlight->props.brightness =
 			acpi_video_get_brightness(device->backlight);
 
-	device->cooling_dev = thermal_cooling_device_register("LCD",
-				device->dev, &video_cooling_ops);
+	device->cooling_dev = thermal_cooling_device_register("LCD", device,
+							      &video_cooling_ops);
 	if (IS_ERR(device->cooling_dev)) {
 		/*
 		 * Set cooling_dev to NULL so we don't crash trying to free it.
-- 
2.43.0



