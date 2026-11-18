Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055057;
	b=huNsKyBd/QjNTBrbURL2IHc4YYJ6fWNJP+SXTaJCJovBcCsGIOO5P5Ow9c+v9m6LTzlq
	 OJ0zdq4NyT1trXiGhuWXTJHmqJgi3TM9LGQfpnPSNSEWgzeyPlDvgG7rS2KGuXoCrtfOu
	 8SR9EYN0Y8+c3reXHI+xa2eMlB7854CdqY6lndbQPA62qNO1yuIkSyk1x9a4LFaGvhrGk
	 OOflrRYvszAlgc4YCsWi1rVIlXl8xoNDnibBh8LBv0S9Y/WYJNuVYxgjjwi+QVvlL+hw1
	 nHZ8tzn0kss0mp99pB/yVBgSD/cG6MOBqSIsv1nbcZm+/eztd+HGBqCadhRironLSVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055057;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=E201jDvSor4r39iwzVIYOZGvOLYtlcf75dQ052MBw1o=;
	b=esf8lAuiIg9yjZ9WW9TMrHICbssZpEYjqSAR88MZKJm+LsXiQb0Ornrq1fTCiXiZZH+I
	 jDvxHH+RVBJp08tW4iKC8GCMqei8XpeA+NeeBI+mZx7clLUT+U6g4IFR+CfAp5Vl068f9
	 x+fh0mi+W8MyBfew1x1QT/zfjakGsb5vkribqQTv78r68/D1ZzC5gW/fvFIVnCOwtKrnK
	 Tzam5SBywOXexi0e2NPBPEAshW5pgzUwg5WoZTs9LsPbdSXShaSXOKgvMey5JVjzyzMoh
	 0B2wT5hWfvc2V4CsvOlV/BWbEEJlSULUqGi89brZx6J48nDOgBjsPQUUMaUT79QAUvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ACwmlbXJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2D70606A31C;
	Thu, 19 Nov 2026 02:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ACwmlbXJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44B231F000C4;
	Thu, 19 Nov 2026 02:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055056;
	bh=E201jDvSor4r39iwzVIYOZGvOLYtlcf75dQ052MBw1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ACwmlbXJp04xTTYi8GropQpSR5ne2eRNMgVQAySSsmOclQ7XOCfbXgf6TLXAcbJ3i
	 rC1G3WZowY6if5unwSsPf0H/2ZXl/vdppbMoDpq+Br7f6ocvjcJhIEub7XKrz7B9mA
	 AwnGdBGD8umc55BQVmQY2JVUJHhNTU0R/0JY1GVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Armin Wolf <W_Armin@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1494/2214] ACPI: video: Fix backlight unregistration ordering
Date: Wed, 18 Nov 2026 15:52:50 +0100
Message-ID: <20261118150111.262262946@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index d9c68fc74d611..473de787e8e82 100644
--- a/drivers/acpi/acpi_video.c
+++ b/drivers/acpi/acpi_video.c
@@ -1916,6 +1916,12 @@ static int acpi_video_bus_register_backlight(struct acpi_video_bus *video)
 
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
@@ -1925,12 +1931,6 @@ static void acpi_video_dev_unregister_backlight(struct acpi_video_device *device
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



