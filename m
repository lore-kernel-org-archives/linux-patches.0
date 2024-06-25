Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76112148315;
	Tue, 25 Jun 2024 09:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308247; cv=none; b=seN9WAlhS2OhMRbq3JS+1dEJzqdAPpSfjuK0hLrZB+U3HE8jHkxXa1RPP3+UjUdmFPEqil7VZxrAJxW+BCZG2ry6KMFUnn/U/YHKv8E/L4/Z/0u4eadDMW3/zunOjZb0zJ3AnTKM1jr3BhjnjG/27mTxTG7tVmNPA/8gParbJz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308247; c=relaxed/simple;
	bh=g6mdoN4pv64Oc5vIkLFqJVqFiLPVBFvju/SGVvcUuDU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UeRkI7QbH/oi0nIMUtxQAU8UHRSvMEHYHSQBrBIzvSrKS7w1zVsaNaXYdyh6yOLj4RVpOZN6y1rFAGJOiJqxcQjhdE+KLpwXKKjQlRHR+qMZEV+694e4/pAlTZEW7Vdm5bnjL19GFNDK/oxYQVu962y3823vRwxTlV+eLdILTnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oAi+pjSO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oAi+pjSO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6334C32781;
	Tue, 25 Jun 2024 09:37:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308247;
	bh=g6mdoN4pv64Oc5vIkLFqJVqFiLPVBFvju/SGVvcUuDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oAi+pjSO0gbWiP0YBYx+1t2NPKHZf4gk+zjku5B1hJDMbwlSLKJrO1xGLzICxwLZh
	 EnkVLPM7/6IauhmfktpYTt4jrdLxiOLQS6hgPR802mz1TTs16QyLla3R78Z0+U9oXb
	 VQL5wIZ9VCefPVC0qeM2NcckfMG5VlToHDSUmoB0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 056/250] platform/x86: x86-android-tablets: Unregister devices in reverse order
Date: Tue, 25 Jun 2024 11:30:14 +0200
Message-ID: <20240625085550.212858924@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/x86-android-tablets/core.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/platform/x86/x86-android-tablets/core.c b/drivers/platform/x86/x86-android-tablets/core.c
index a3415f1c0b5f8..6559bb4ea7305 100644
--- a/drivers/platform/x86/x86-android-tablets/core.c
+++ b/drivers/platform/x86/x86-android-tablets/core.c
@@ -278,25 +278,25 @@ static void x86_android_tablet_remove(struct platform_device *pdev)
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
 
-	for (i = 0; i < spi_dev_count; i++)
+	for (i = spi_dev_count - 1; i >= 0; i--)
 		spi_unregister_device(spi_devs[i]);
 
 	kfree(spi_devs);
 
-	for (i = 0; i < i2c_client_count; i++)
+	for (i = i2c_client_count - 1; i >= 0; i--)
 		i2c_unregister_device(i2c_clients[i]);
 
 	kfree(i2c_clients);
-- 
2.43.0



