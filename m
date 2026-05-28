Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8698318B9D;
	Thu, 28 May 2026 20:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780001152; cv=none; b=OyhtFOGs5mwnXMbaBqSQI8wiWFjY/6b0jcMQIfWA3dtCdaVrjo2OCvO6rDo3Cjto1xWZAPihR3bkXp4sXEI+ujmaqcwtWmviaB27lgfNRfWgK5umrmOb0PVqJfk4mvKO3Mv9X46EYpNgTHenOm9EnUo7ukUiAksK/Q/pi12fpzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780001152; c=relaxed/simple;
	bh=DQzYTUqKSp5KC6tXxY/5UMEA8ubGgp3QdI0rzAiof0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O/3tyFodSJ5eDaxmbud3XehsY86m7aPZNnrsmqJzHV53UmOHx35yYAqCqD4cySfCx+WMBA9EDK6tDvzNN/tVgWPBLGBbefQvj7RzEvKh7q6q4MnBnLGPKj5wslqN9ELk1my1oA85lW2vpsue1zSfXuxlgo9HK861bmLHakI78LY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZFxIEnyU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZFxIEnyU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 523921F000E9;
	Thu, 28 May 2026 20:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780001150;
	bh=3dglbacoThz2ufQzfu3Tr7osOxpOgjx7ZjQMl4V9bJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZFxIEnyUflZPga/n4gWe8u6riL51+WejTnhrTPH4wxslDY+d7ncS7KBKxE7w20uXq
	 hfhotcPBieSvCvMnsw3L999U0HV0k6lhI8ZU0XSOTIQbvug3DonhMJ/UDWer6E/ezr
	 0iM30A2K1WZdf8N9MulUt4C4ZNqzmkxlieJcJsAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabian Godehardt <fg@emlix.com>,
	Mark Brown <broonie@kernel.org>,
	Wenshan Lan <jetlan9@163.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 005/186] spi: spidev: fix lock inversion between spi_lock and buf_lock
Date: Thu, 28 May 2026 21:48:05 +0200
Message-ID: <20260528194929.093640436@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194928.941004471@linuxfoundation.org>
References: <20260528194928.941004471@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Fabian Godehardt <fg@emlix.com>

[ Upstream commit 40534d19ed2afb880ecf202dab26a8e7a5808d16 ]

The spidev driver previously used two mutexes, spi_lock and buf_lock,
but acquired them in different orders depending on the code path:

  write()/read(): buf_lock -> spi_lock
  ioctl():       spi_lock -> buf_lock

This AB-BA locking pattern triggers lockdep warnings and can
cause real deadlocks:

  WARNING: possible circular locking dependency detected
  spidev_ioctl() -> mutex_lock(&spidev->buf_lock)
  spidev_sync_write() -> mutex_lock(&spidev->spi_lock)
  *** DEADLOCK ***

The issue is reproducible with a simple userspace program that
performs write() and SPI_IOC_WR_MAX_SPEED_HZ ioctl() calls from
separate threads on the same spidev file descriptor.

Fix this by simplifying the locking model and removing the lock
inversion entirely. spidev_sync() no longer performs any locking,
and all callers serialize access using spi_lock.

buf_lock is removed since its functionality is fully covered by
spi_lock, eliminating the possibility of lock ordering issues.

This removes the lock inversion and prevents deadlocks without
changing userspace ABI or behaviour.

Signed-off-by: Fabian Godehardt <fg@emlix.com>
Link: https://patch.msgid.link/20260211072616.489522-1-fg@emlix.com
Signed-off-by: Mark Brown <broonie@kernel.org>
[ Minor context conflict resolved. ]
Signed-off-by: Wenshan Lan <jetlan9@163.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spidev.c | 63 ++++++++++++++++----------------------------
 1 file changed, 22 insertions(+), 41 deletions(-)

diff --git a/drivers/spi/spidev.c b/drivers/spi/spidev.c
index 16bb4fc3a4ba9..2024532dfc447 100644
--- a/drivers/spi/spidev.c
+++ b/drivers/spi/spidev.c
@@ -74,7 +74,6 @@ struct spidev_data {
 	struct list_head	device_entry;
 
 	/* TX/RX buffers are NULL unless this device is open (users > 0) */
-	struct mutex		buf_lock;
 	unsigned		users;
 	u8			*tx_buffer;
 	u8			*rx_buffer;
@@ -102,24 +101,6 @@ spidev_sync_unlocked(struct spi_device *spi, struct spi_message *message)
 	return status;
 }
 
-static ssize_t
-spidev_sync(struct spidev_data *spidev, struct spi_message *message)
-{
-	ssize_t status;
-	struct spi_device *spi;
-
-	mutex_lock(&spidev->spi_lock);
-	spi = spidev->spi;
-
-	if (spi == NULL)
-		status = -ESHUTDOWN;
-	else
-		status = spidev_sync_unlocked(spi, message);
-
-	mutex_unlock(&spidev->spi_lock);
-	return status;
-}
-
 static inline ssize_t
 spidev_sync_write(struct spidev_data *spidev, size_t len)
 {
@@ -132,7 +113,8 @@ spidev_sync_write(struct spidev_data *spidev, size_t len)
 
 	spi_message_init(&m);
 	spi_message_add_tail(&t, &m);
-	return spidev_sync(spidev, &m);
+
+	return spidev_sync_unlocked(spidev->spi, &m);
 }
 
 static inline ssize_t
@@ -147,7 +129,8 @@ spidev_sync_read(struct spidev_data *spidev, size_t len)
 
 	spi_message_init(&m);
 	spi_message_add_tail(&t, &m);
-	return spidev_sync(spidev, &m);
+
+	return spidev_sync_unlocked(spidev->spi, &m);
 }
 
 /*-------------------------------------------------------------------------*/
@@ -157,7 +140,7 @@ static ssize_t
 spidev_read(struct file *filp, char __user *buf, size_t count, loff_t *f_pos)
 {
 	struct spidev_data	*spidev;
-	ssize_t			status;
+	ssize_t			status = -ESHUTDOWN;
 
 	/* chipselect only toggles at start or end of operation */
 	if (count > bufsiz)
@@ -165,7 +148,11 @@ spidev_read(struct file *filp, char __user *buf, size_t count, loff_t *f_pos)
 
 	spidev = filp->private_data;
 
-	mutex_lock(&spidev->buf_lock);
+	mutex_lock(&spidev->spi_lock);
+
+	if (spidev->spi == NULL)
+		goto err_spi_removed;
+
 	status = spidev_sync_read(spidev, count);
 	if (status > 0) {
 		unsigned long	missing;
@@ -176,7 +163,9 @@ spidev_read(struct file *filp, char __user *buf, size_t count, loff_t *f_pos)
 		else
 			status = status - missing;
 	}
-	mutex_unlock(&spidev->buf_lock);
+
+err_spi_removed:
+	mutex_unlock(&spidev->spi_lock);
 
 	return status;
 }
@@ -187,7 +176,7 @@ spidev_write(struct file *filp, const char __user *buf,
 		size_t count, loff_t *f_pos)
 {
 	struct spidev_data	*spidev;
-	ssize_t			status;
+	ssize_t			status = -ESHUTDOWN;
 	unsigned long		missing;
 
 	/* chipselect only toggles at start or end of operation */
@@ -196,13 +185,19 @@ spidev_write(struct file *filp, const char __user *buf,
 
 	spidev = filp->private_data;
 
-	mutex_lock(&spidev->buf_lock);
+	mutex_lock(&spidev->spi_lock);
+
+	if (spidev->spi == NULL)
+		goto err_spi_removed;
+
 	missing = copy_from_user(spidev->tx_buffer, buf, count);
 	if (missing == 0)
 		status = spidev_sync_write(spidev, count);
 	else
 		status = -EFAULT;
-	mutex_unlock(&spidev->buf_lock);
+
+err_spi_removed:
+	mutex_unlock(&spidev->spi_lock);
 
 	return status;
 }
@@ -376,14 +371,6 @@ spidev_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		return -ESHUTDOWN;
 	}
 
-	/* use the buffer lock here for triple duty:
-	 *  - prevent I/O (from us) so calling spi_setup() is safe;
-	 *  - prevent concurrent SPI_IOC_WR_* from morphing
-	 *    data fields while SPI_IOC_RD_* reads them;
-	 *  - SPI_IOC_MESSAGE needs the buffer locked "normally".
-	 */
-	mutex_lock(&spidev->buf_lock);
-
 	switch (cmd) {
 	/* read requests */
 	case SPI_IOC_RD_MODE:
@@ -516,7 +503,6 @@ spidev_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		break;
 	}
 
-	mutex_unlock(&spidev->buf_lock);
 	spi_dev_put(spi);
 	mutex_unlock(&spidev->spi_lock);
 	return retval;
@@ -547,9 +533,6 @@ spidev_compat_ioc_message(struct file *filp, unsigned int cmd,
 		return -ESHUTDOWN;
 	}
 
-	/* SPI_IOC_MESSAGE needs the buffer locked "normally" */
-	mutex_lock(&spidev->buf_lock);
-
 	/* Check message and copy into scratch area */
 	ioc = spidev_get_ioc_message(cmd, u_ioc, &n_ioc);
 	if (IS_ERR(ioc)) {
@@ -570,7 +553,6 @@ spidev_compat_ioc_message(struct file *filp, unsigned int cmd,
 	kfree(ioc);
 
 done:
-	mutex_unlock(&spidev->buf_lock);
 	spi_dev_put(spi);
 	mutex_unlock(&spidev->spi_lock);
 	return retval;
@@ -795,7 +777,6 @@ static int spidev_probe(struct spi_device *spi)
 	/* Initialize the driver data */
 	spidev->spi = spi;
 	mutex_init(&spidev->spi_lock);
-	mutex_init(&spidev->buf_lock);
 
 	INIT_LIST_HEAD(&spidev->device_entry);
 
-- 
2.53.0



