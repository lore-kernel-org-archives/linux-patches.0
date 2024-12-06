Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5748D32C8B;
	Fri,  6 Dec 2024 14:51:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496692; cv=none; b=phoJKqT5I3Rewrvo4xl46tFi12N4EpI/eseLcIs1HxP0Ac56UAQAtx4GczkMYBJAcDMSilqXdYnz0whE/TOGnnbEMHVJRRgenr3Rd7D4XnkamyIGqdTsrmqLqfb7Poic9xgGCw5itlirSit8qNx6rEirawcjGLCY/0tRfY6Sxhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496692; c=relaxed/simple;
	bh=//mjzP98P3c9WXDyvl+H1755Zd3cjAAfHoXp5NQtIWY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KR1bzjHy9IDEDNuYSMEVi75hGOixc2RY7Z0XlR1/UtiTYJj0oSoKKVtkhbdGSalSrBMSRvt66bxA96YpK/F0k03gtPCCgVOdqU75WgnKvn9gd2Y8XseEFLyQVrV7ec713Y0hJu6gWgThj7tuMlod3lwyxBKi42dYW9V0B+UvWTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e6Nn2bP5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e6Nn2bP5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDA58C4CED1;
	Fri,  6 Dec 2024 14:51:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496692;
	bh=//mjzP98P3c9WXDyvl+H1755Zd3cjAAfHoXp5NQtIWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e6Nn2bP5vzPt+KKAHgNQlAVz+uZZkZ3DxpN4qghaEIL55v3jvYnQzTcDZ3yo5zNRw
	 bdRhyYxlhxCXXCmnczOVX29p1uZEBDeK1ehI86v6a0u+gPC2F6OxwPDTwkHfeRPkLT
	 3343B/nb4LPmCRMWsLVDqcjhzH4qHYQKhN/fzvFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Bin Lan <bin.lan.cn@windriver.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 045/676] platform/x86: x86-android-tablets: Unregister devices in reverse order
Date: Fri,  6 Dec 2024 15:27:44 +0100
Message-ID: <20241206143655.114897494@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

[ Upstream commit 3de0f2627ef849735f155c1818247f58404dddfe ]

Not all subsystems support a device getting removed while there are
still consumers of the device with a reference to the device.

One example of this is the regulator subsystem. If a regulator gets
unregistered while there are still drivers holding a reference
a WARN() at drivers/regulator/core.c:5829 triggers, e.g.:

 WARNING: CPU: 1 PID: 1587 at drivers/regulator/core.c:5829 regulator_unregister
 Hardware name: Intel Corp. VALLEYVIEW C0 PLATFORM/BYT-T FFD8, BIOS BLADE_21.X64.0005.R00.1504101516 FFD8_X64_R_2015_04_10_1516 04/10/2015
 RIP: 0010:regulator_unregister
 Call Trace:
  <TASK>
  regulator_unregister
  devres_release_group
  i2c_device_remove
  device_release_driver_internal
  bus_remove_device
  device_del
  device_unregister
  x86_android_tablet_remove

On the Lenovo Yoga Tablet 2 series the bq24190 charger chip also provides
a 5V boost converter output for powering USB devices connected to the micro
USB port, the bq24190-charger driver exports this as a Vbus regulator.

On the 830 (8") and 1050 ("10") models this regulator is controlled by
a platform_device and x86_android_tablet_remove() removes platform_device-s
before i2c_clients so the consumer gets removed first.

But on the 1380 (13") model there is a lc824206xa micro-USB switch
connected over I2C and the extcon driver for that controls the regulator.
The bq24190 i2c-client *must* be registered first, because that creates
the regulator with the lc824206xa listed as its consumer. If the regulator
has not been registered yet the lc824206xa driver will end up getting
a dummy regulator.

Since in this case both the regulator provider and consumer are I2C
devices, the only way to ensure that the consumer is unregistered first
is to unregister the I2C devices in reverse order of in which they were
created.

For consistency and to avoid similar problems in the future change
x86_android_tablet_remove() to unregister all device types in reverse
order.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20240406125058.13624-1-hdegoede@redhat.com
[ Resolve minor conflicts ]
Signed-off-by: Bin Lan <bin.lan.cn@windriver.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/x86-android-tablets/core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/platform/x86/x86-android-tablets/core.c b/drivers/platform/x86/x86-android-tablets/core.c
index a0fa0b6859c9c..63a348af83db1 100644
--- a/drivers/platform/x86/x86-android-tablets/core.c
+++ b/drivers/platform/x86/x86-android-tablets/core.c
@@ -230,20 +230,20 @@ static void x86_android_tablet_remove(struct platform_device *pdev)
 {
 	int i;
 
-	for (i = 0; i < serdev_count; i++) {
+	for (i = serdev_count - 1; i >= 0; i--) {
 		if (serdevs[i])
 			serdev_device_remove(serdevs[i]);
 	}
 
 	kfree(serdevs);
 
-	for (i = 0; i < pdev_count; i++)
+	for (i = pdev_count - 1; i >= 0; i--)
 		platform_device_unregister(pdevs[i]);
 
 	kfree(pdevs);
 	kfree(buttons);
 
-	for (i = 0; i < i2c_client_count; i++)
+	for (i = i2c_client_count - 1; i >= 0; i--)
 		i2c_unregister_device(i2c_clients[i]);
 
 	kfree(i2c_clients);
-- 
2.43.0



