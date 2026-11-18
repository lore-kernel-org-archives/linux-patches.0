Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060687;
	b=c+kBI/fQph8LchoaiCmyNk+DtWLmWaXsCoCNWaRW495HP2G8aRR2QndGW+sfjMGluKK6
	 Cpa4xykj/53AcAtXqX7sT15/sxZyAKaIq5OH1akflghXE997ZBDI1qeLVK8/MMHKjwQyt
	 yBn85YGw5V6cCaLwQQ4U6zp/MHw5wj7HRH/4PTJnPpeAJFFyi952x8KyNeBVOOZ6dzDYN
	 puqtd/WiyMjq3bBak9HrMungq0KPKI0YCn5s++rYX8IOAPrM8nn/6wYu3PcmnXAmbPLE6
	 A559NecQ9vaGXpIWN1VOAejaXhoLIlagYIImsdBIT7AJEmYhHItJx3kgctxDjTr5WMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060687;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xFRx7oL8iSxHodKhMwNheGRSIJbSY44aUw/Dpz39UTs=;
	b=UtmZsnTQVg0jQ1++Fck/DpnJf969aBbH/sWOlqDWUhO0jSiV9s1Iuiuis56pw0oJ0U4j
	 YRb1KVqErN2vmlkWT95g+B0yo3IJ9CCU4stp++cSdAfXY4Am2e8daK9JcK3PhUtoyT9IR
	 Y18KBeikIjA+uq8F/Es2eAIiptLhhQc5BXRRlOn/RLlU324y5YJmz7OXzSegWgPxm8nHR
	 uxvQHcY3zPs/HX28o4RC6BhJrAUaL4WzZibH+8yDLfwhRC9RwRVcTCbI6FUmUaOhRRlB3
	 mA04Few0qyUYVuGpg6/tHsuZz1//boJSuhWCnaY8hPi7Oo9IWRW7w8tqBYdtJPTDecA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=seF4WNQD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F20E7606A326;
	Thu, 19 Nov 2026 03:58:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=seF4WNQD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C4FD1F000C4;
	Thu, 19 Nov 2026 03:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060686;
	bh=xFRx7oL8iSxHodKhMwNheGRSIJbSY44aUw/Dpz39UTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=seF4WNQDRpj9n+Y58/q2A06npWY/IQ7YcvMREs0zSCJGwtcOTdR0pWn2PhDBWluzC
	 suhvpw8yMWHdJ51jOih4/OcVWK/D18U+GWuED+z2CXwnMuhX0n+VyAVSB2nzd4Vnwi
	 Mn98D3aP32mZoXf/21HBQf9Ja6seoZvGHmH5fwi4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Armin Wolf <W_Armin@gmx.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1246/1848] ACPI: video: Fix backlight unregistration ordering
Date: Wed, 18 Nov 2026 15:54:44 +0100
Message-ID: <20261118150011.977972370@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index f67871e8f3832..3e363a7ab99c2 100644
--- a/drivers/acpi/acpi_video.c
+++ b/drivers/acpi/acpi_video.c
@@ -1910,6 +1910,12 @@ static int acpi_video_bus_register_backlight(struct acpi_video_bus *video)
 
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
@@ -1919,12 +1925,6 @@ static void acpi_video_dev_unregister_backlight(struct acpi_video_device *device
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



