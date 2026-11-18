Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048211;
	b=MlYle5S+NbbuW0XdMSVlKXnro3WbU8nGAh3cYr3pZOK3w5GRlBruUFxkAq2kbaQlHFPO
	 J+cTqjCPe6khN7YTO+e5IN5xcxzBOV7BhtPIhb4GMTwY4mqFRI6b8DJ+XWaB+2L1cFF9g
	 CyU7voMqCNVowpnOAD4gegK3FDk7M4fkKyJctwYL8FK1M06uRno44nUuYJ+db7O7JDfww
	 PJvR2P6q3nswxtTKMi+38fnWGIa6VkYXoEnbbqWRxXp6itcIkuip6uiNaySDzDcpWgCgq
	 M9a4Yv/akITPCibdXaICBzL1qPxr7a9Ht4MeH7PXjtyasJ4RhIMbUV8nWaZMuTXqUPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048211;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xfRVHc44zD8SzxOmZ6TAulYILsBAmBVIC5ecvI2zX3I=;
	b=iXaVJSuEcvv86eTCC5luTyJW3Fb4znJiqXFcD2qN9jrejri8JvzUrhl+DhbK0HdOwlY7
	 rMs72Ed6TJhJPwT+WG0wequH2h04mShS4hVCnOnaYSvv5XxNGRJq2A+x46kmzvAu1xXv4
	 dpQ514chDY6V6A/+0CyZoY8MMZ+yGTMuz1vnsQNYOJNXOej3Ppjjo4Z70KU81OBu2Oivb
	 zATwEvZO7mcGTn8Vm1amG1gbd+7HZ3BAfKDWNN0SDFQCIEUJwhL+8ThXyLjGCBwkUniY9
	 X9rqwZZj6gEPGl2T2r2m4R0/CWxkDqSQ9x0VqztJ7R/2DMsk+HzWKoca/uFFmpxfZZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W+3Kg20v;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93909606A320;
	Thu, 19 Nov 2026 00:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=W+3Kg20v
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E19C31F000C5;
	Thu, 19 Nov 2026 00:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048211;
	bh=xfRVHc44zD8SzxOmZ6TAulYILsBAmBVIC5ecvI2zX3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W+3Kg20v7aQMB3VqJ1Fy1AGC5qg6yha6jZyMo8NiZ71CtM06Snq+uVOhXgMgLcSYY
	 CMAMIL/k/5mq1zc/5RuOYfSU7KFtJDMK1Pf87Env/hNs/zmQrzyuagORKn/feJhDkh
	 sA/qCZF7vjCpQmKryMdHKxqAVd0b6ZIIsWn51QOg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Armin Wolf <W_Armin@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1915/2857] ACPI: video: Fix backlight unregistration ordering
Date: Wed, 18 Nov 2026 15:49:09 +0100
Message-ID: <20261118150310.165887134@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 46577d36611953d1b99e86493289cfc824116ad2 ]

In acpi_video_dev_unregister_backlight(), the sysfs interface of the
cooling class device may access the brightness object under the
backlight device's ACPI companion, so that object cannot be freed
before unregistering the cooling class device.

Adjust the code to take that into account.

Fixes: 67b662e189f4 ("ACPI / video: seperate backlight control and event interface")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Armin Wolf <W_Armin@gmx.de>
[ rjw: Fixed the Fixes: tag ]
Link: https://patch.msgid.link/3429468.aeNJFYEL58@rafael.j.wysocki
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpi_video.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/acpi/acpi_video.c b/drivers/acpi/acpi_video.c
index 2f1a2ad4eb816..7b24e577c1ab8 100644
--- a/drivers/acpi/acpi_video.c
+++ b/drivers/acpi/acpi_video.c
@@ -1847,6 +1847,12 @@ static int acpi_video_bus_register_backlight(struct acpi_video_bus *video)
 
 static void acpi_video_dev_unregister_backlight(struct acpi_video_device *device)
 {
+	if (device->cooling_dev) {
+		sysfs_remove_link(&device->dev->dev.kobj, "thermal_cooling");
+		sysfs_remove_link(&device->cooling_dev->device.kobj, "device");
+		thermal_cooling_device_unregister(device->cooling_dev);
+		device->cooling_dev = NULL;
+	}
 	if (device->backlight) {
 		backlight_device_unregister(device->backlight);
 		device->backlight = NULL;
@@ -1856,12 +1862,6 @@ static void acpi_video_dev_unregister_backlight(struct acpi_video_device *device
 		kfree(device->brightness);
 		device->brightness = NULL;
 	}
-	if (device->cooling_dev) {
-		sysfs_remove_link(&device->dev->dev.kobj, "thermal_cooling");
-		sysfs_remove_link(&device->cooling_dev->device.kobj, "device");
-		thermal_cooling_device_unregister(device->cooling_dev);
-		device->cooling_dev = NULL;
-	}
 }
 
 static int acpi_video_bus_unregister_backlight(struct acpi_video_bus *video)
-- 
2.53.0



