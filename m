Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75D152584
	for <patches@lists.linux.dev>; Thu, 23 Feb 2023 13:10:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDDFDC4339C;
	Thu, 23 Feb 2023 13:10:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1677157826;
	bh=wWuF2RiU/Jx4joPyaylmuwmJNQqnww36DoAq1HiYwck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hgXveUz7Mg2KxNBrqf6Lc5xkrmbOg8Et04qjCKQ69BZH6NsJlJyHyZfjgb4DZnz/g
	 57mAveO97Bebh2BxZ265CGT1JmTJ/Hu5uFgjtabxthBzx6WMqYCB6o+jWqjZX7pt+P
	 QhR/Gy9I7v7Yt0C6qAPzc5Tsjus3SArLU64I2Lzs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Daniel Dadap <ddadap@nvidia.com>
Subject: [PATCH 6.1 44/46] platform/x86: nvidia-wmi-ec-backlight: Add force module parameter
Date: Thu, 23 Feb 2023 14:06:51 +0100
Message-Id: <20230223130433.646965185@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230223130431.553657459@linuxfoundation.org>
References: <20230223130431.553657459@linuxfoundation.org>
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

commit 0d9bdd8a550170306c2021b8d6766c5343b870c2 upstream.

On some Lenovo Legion models, the backlight might be driven by either
one of nvidia_wmi_ec_backlight or amdgpu_bl0 at different times.

When the Nvidia WMI EC backlight interface reports the backlight is
controlled by the EC, the current backlight handling only registers
nvidia_wmi_ec_backlight (and registers no other backlight interfaces).

This hides (never registers) the amdgpu_bl0 interface, where as prior
to 6.1.4 users would have both nvidia_wmi_ec_backlight and amdgpu_bl0
and could work around things in userspace.

Add a force module parameter which can be used with acpi_backlight=native
to restore the old behavior as a workound (for now) by passing:

"acpi_backlight=native nvidia-wmi-ec-backlight.force=1"

Fixes: 8d0ca287fd8c ("platform/x86: nvidia-wmi-ec-backlight: Use acpi_video_get_backlight_type()")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=217026
Cc: stable@vger.kernel.org
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Daniel Dadap <ddadap@nvidia.com>
Link: https://lore.kernel.org/r/20230217144208.5721-1-hdegoede@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/nvidia-wmi-ec-backlight.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/platform/x86/nvidia-wmi-ec-backlight.c
+++ b/drivers/platform/x86/nvidia-wmi-ec-backlight.c
@@ -12,6 +12,10 @@
 #include <linux/wmi.h>
 #include <acpi/video.h>
 
+static bool force;
+module_param(force, bool, 0444);
+MODULE_PARM_DESC(force, "Force loading (disable acpi_backlight=xxx checks");
+
 /**
  * wmi_brightness_notify() - helper function for calling WMI-wrapped ACPI method
  * @w:    Pointer to the struct wmi_device identified by %WMI_BRIGHTNESS_GUID
@@ -91,7 +95,7 @@ static int nvidia_wmi_ec_backlight_probe
 	int ret;
 
 	/* drivers/acpi/video_detect.c also checks that SOURCE == EC */
-	if (acpi_video_get_backlight_type() != acpi_backlight_nvidia_wmi_ec)
+	if (!force && acpi_video_get_backlight_type() != acpi_backlight_nvidia_wmi_ec)
 		return -ENODEV;
 
 	/*


