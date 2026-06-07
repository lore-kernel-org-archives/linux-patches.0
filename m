Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3E03524F;
	Sun,  7 Jun 2026 11:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780830160; cv=none; b=KQWEeZqdV9MsRopIZDLLOQ3LCNL7V4f+UbHNaiyrs6VvA6+XQhu+vTQmz4P1XzzsE0G5qpbRByo2553ccDgbygmH2+01Re8k6VAA8WqQOZXZOpDMy6LNNNk8nNHbYEm8j8oUBN6xpra/BchswYLwOmTxl1mM/AktgqfrQmT0nng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780830160; c=relaxed/simple;
	bh=Fk7h1y1u+5E0RZrOZs0Na4VchIJW8X0s3/IbPu/cD7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nI18oERgC8ZCrKUcdxVnWbbIexzXgCQ7hdGe4bLMMrpiiggpM6O80u62NBCkn07qHA3f5MBwkWJzMjwhq1OJ04kzw7vXXBeSNK6dx18F91mBwAF2Z/RKjHBllgVxZ9r+uRhH8VfQhrShjlH7jwuM+DTj+vyiy5tArD15Kuf2C84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NfXulBwO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NfXulBwO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E0321F00893;
	Sun,  7 Jun 2026 11:02:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780830159;
	bh=ZtR8H50f5BzBufwQd8VFx1xnAFuEUNj/NkkXklb1GDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NfXulBwOGUl4YY3IuWZXyMTyXbna1LxrSdxcGroLyI+7oA9r3QRmDo6rvPZvr30eJ
	 kuvlUChsodXmpmnjM4wbaSxI+FsHojKqNJGDH/Ne0rGhrhy9y70JQRikuJ5V9kun2K
	 4f1Av989aDF5HyZUi8LlIf1yHt43BAun26J0o3U4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 288/315] serdev: Provide a bustype shutdown function
Date: Sun,  7 Jun 2026 12:01:15 +0200
Message-ID: <20260607095738.172324104@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -414,11 +414,21 @@ static void serdev_drv_remove(struct dev
 		sdrv->remove(to_serdev_device(dev));
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
@@ -814,6 +824,14 @@ void serdev_controller_remove(struct ser
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
@@ -830,6 +848,9 @@ int __serdev_device_driver_register(stru
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


