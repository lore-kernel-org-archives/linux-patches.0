Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 575FD4418D7;
	Tue, 16 Jun 2026 17:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781630080; cv=none; b=OFEzTgry7cMMHzvgAh3vwA6rNKTb0BQ7wzoNj1m2JQnfZyR7Gmi7qkVtM0KJZ41qpIhknnfOWTKA5Ef5tM0W4d8l7DOr9p3Zy3p11jwXkLezJIn59L0yfKL0vxIuwJsPS4n/CtmKVseAKHl0atqyqDTIWBcsn5oDLujvn4NTu4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781630080; c=relaxed/simple;
	bh=cRWU+JODcB3Xd9Gn31IEeU7Fn4Cd5hnP15wfXkF0gmc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qkRCtshRIWXoo3+5AXyT3oyv26W9rffcyl/SxhiEbQQswaqfOrpsMF5NcTExw9+Jy9eBo0LpWHR17oRMoLsYCeqF4ZEd2zW/NThqAfM396RFXkp0DF3KRG40bBm2hc5Hbiw+F4cZqRkam2OmC1iwadO3t9a7V46ceAu1KgTYSrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wr0qn1z5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wr0qn1z5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EACBE1F000E9;
	Tue, 16 Jun 2026 17:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781630079;
	bh=JZZtLdcyoTHBveXlOFuItnPB5c+DYj95zJs85X0FJgc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wr0qn1z5mHewV3ctApzfZZZ3Do4bT0l/+EDTABSfyjrwpndXY08CGN4xf9BnKPgsR
	 8IKelNhx6WWayaQKE5Hqp4bfLsW+1AEH9QG5AztPk57DmRowWyoVnNNnXTV2JUZYqJ
	 mk2HyDiM/UQ0zwVVs9KDG3JYKtxVEaM10eAjr4sM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 405/452] serdev: Provide a bustype shutdown function
Date: Tue, 16 Jun 2026 20:30:32 +0530
Message-ID: <20260616145138.097610084@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@baylibre.com>

[ Upstream commit 6d71c62b13c33ea858ab298fe20beaec5736edc7 ]

To prepare serdev driver to migrate away from struct device_driver::shutdown
(and then eventually remove that callback) create a serdev driver shutdown
callback and migration code to keep the existing behaviour. Note this
introduces a warning for each driver at register time that isn't converted
yet to that callback.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
Link: https://patch.msgid.link/ab518883e3ed0976a19cb5b5b5faf42bd3a655b7.1765526117.git.u.kleine-koenig@baylibre.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 375ba7484132 ("Bluetooth: hci_qca: Convert timeout from jiffies to ms")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serdev/core.c |   21 +++++++++++++++++++++
 include/linux/serdev.h    |    1 +
 2 files changed, 22 insertions(+)

--- a/drivers/tty/serdev/core.c
+++ b/drivers/tty/serdev/core.c
@@ -441,11 +441,21 @@ static void serdev_drv_remove(struct dev
 	dev_pm_domain_detach(dev, true);
 }
 
+static void serdev_drv_shutdown(struct device *dev)
+{
+	const struct serdev_device_driver *sdrv =
+		to_serdev_device_driver(dev->driver);
+
+	if (dev->driver && sdrv->shutdown)
+		sdrv->shutdown(to_serdev_device(dev));
+}
+
 static const struct bus_type serdev_bus_type = {
 	.name		= "serial",
 	.match		= serdev_device_match,
 	.probe		= serdev_drv_probe,
 	.remove		= serdev_drv_remove,
+	.shutdown	= serdev_drv_shutdown,
 };
 
 /**
@@ -839,6 +849,14 @@ void serdev_controller_remove(struct ser
 }
 EXPORT_SYMBOL_GPL(serdev_controller_remove);
 
+static void serdev_legacy_shutdown(struct serdev_device *serdev)
+{
+	struct device *dev = &serdev->dev;
+	struct device_driver *driver = dev->driver;
+
+	driver->shutdown(dev);
+}
+
 /**
  * __serdev_device_driver_register() - Register client driver with serdev core
  * @sdrv:	client driver to be associated with client-device.
@@ -855,6 +873,9 @@ int __serdev_device_driver_register(stru
 	/* force drivers to async probe so I/O is possible in probe */
         sdrv->driver.probe_type = PROBE_PREFER_ASYNCHRONOUS;
 
+	if (!sdrv->shutdown && sdrv->driver.shutdown)
+		sdrv->shutdown = serdev_legacy_shutdown;
+
 	return driver_register(&sdrv->driver);
 }
 EXPORT_SYMBOL_GPL(__serdev_device_driver_register);
--- a/include/linux/serdev.h
+++ b/include/linux/serdev.h
@@ -65,6 +65,7 @@ struct serdev_device_driver {
 	struct device_driver driver;
 	int	(*probe)(struct serdev_device *);
 	void	(*remove)(struct serdev_device *);
+	void	(*shutdown)(struct serdev_device *);
 };
 
 static inline struct serdev_device_driver *to_serdev_device_driver(struct device_driver *d)


