Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A9DE14A99
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:13:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ddFLIwGV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77418C433C7;
	Mon, 23 Oct 2023 11:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698059624;
	bh=Dy7q+UQ5XbyJyajfp57OtgYRZZLBXuQkInhaWiULnsI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ddFLIwGVS4JwCvN+H9BhJxe94Enz0w0f4QUYMHTS++H+XBVofsnViV9n2Ok2ZO4bZ
	 mpqqkJZqy5PfIisoo5OlTUtcV3Yd85sQZubCvWyd8pvs6ozIkVT8hzCNA0wpn9tmZX
	 UKXe4NoR9cDMQmGILaKLxPXLKyJBCVhHkCkp7fSk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karsten Leipold <poldi@dfn.de>,
	Orlando Chamberlain <orlandoch.dev@gmail.com>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 6.5 203/241] apple-gmux: Hard Code max brightness for MMIO gmux
Date: Mon, 23 Oct 2023 12:56:29 +0200
Message-ID: <20231023104838.809067383@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104833.832874523@linuxfoundation.org>
References: <20231023104833.832874523@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Orlando Chamberlain <orlandoch.dev@gmail.com>

commit 0e51cb42438b8754d8f4cee4c802a8c5bb2cd5e0 upstream.

The data in the max brightness port for iMacs with MMIO gmux incorrectly
reports 0x03ff, but it should be 0xffff. As all other MMIO gmux models
have 0xffff, hard code this for all MMIO gmux's so they all have the
proper brightness range accessible.

Fixes: 0c18184de990 ("platform/x86: apple-gmux: support MMIO gmux on T2 Macs")
Reported-by: Karsten Leipold <poldi@dfn.de>
Signed-off-by: Orlando Chamberlain <orlandoch.dev@gmail.com>
Link: https://lore.kernel.org/r/20231017111444.19304-2-orlandoch.dev@gmail.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/apple-gmux.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/drivers/platform/x86/apple-gmux.c
+++ b/drivers/platform/x86/apple-gmux.c
@@ -105,6 +105,8 @@ struct apple_gmux_config {
 #define GMUX_BRIGHTNESS_MASK		0x00ffffff
 #define GMUX_MAX_BRIGHTNESS		GMUX_BRIGHTNESS_MASK
 
+# define MMIO_GMUX_MAX_BRIGHTNESS	0xffff
+
 static u8 gmux_pio_read8(struct apple_gmux_data *gmux_data, int port)
 {
 	return inb(gmux_data->iostart + port);
@@ -857,7 +859,17 @@ get_version:
 
 	memset(&props, 0, sizeof(props));
 	props.type = BACKLIGHT_PLATFORM;
-	props.max_brightness = gmux_read32(gmux_data, GMUX_PORT_MAX_BRIGHTNESS);
+
+	/*
+	 * All MMIO gmux's have 0xffff as max brightness, but some iMacs incorrectly
+	 * report 0x03ff, despite the firmware being happy to set 0xffff as the brightness
+	 * at boot. Force 0xffff for all MMIO gmux's so they all have the correct brightness
+	 * range.
+	 */
+	if (type == APPLE_GMUX_TYPE_MMIO)
+		props.max_brightness = MMIO_GMUX_MAX_BRIGHTNESS;
+	else
+		props.max_brightness = gmux_read32(gmux_data, GMUX_PORT_MAX_BRIGHTNESS);
 
 #if IS_REACHABLE(CONFIG_ACPI_VIDEO)
 	register_bdev = acpi_video_get_backlight_type() == acpi_backlight_apple_gmux;


