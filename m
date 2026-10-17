Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A672E3C13F9;
	Sat, 17 Oct 2026 17:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258404; cv=none; b=rp5XwSVD6uXLMgFg0VLGXErKAs8wmPjsMHFwbLYkBRQi8UzS1Yp84cM9wi1nW4AblhK00bbHsI52cUkYNa8SSx/cOWO/xbgbavQfkfsIb6GcKggGGBMl3nkglhKebNa5b+STUuAfLn+AWLIMp4T3E1IsOHIlLixigEnxpEEyZqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258404; c=relaxed/simple;
	bh=4DgFbDUjsBWJuAEg9fYl35dEJYjpsGvufNoLvssP/0w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U3UEDMm87c6Zjb/CTsHfVoqqXZK94uNhs2d5BchHiVsYvYR/mL3eXFCl6QEzifQ+tB1eWLcRul6t3lxJxAgvyIMCn6rbbfaEhJr7JKt0J18uE4dwYUG7DRu1NJyWPm8oSKWnZhq6QLNKigb752hDyAhXdXs4RMs45aWwOeJ2b8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tPIJFgiA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tPIJFgiA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08F781F000C5;
	Sat, 17 Oct 2026 17:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258403;
	bh=lEVSIk0VE1SBjlIPVznWjNBZGladKC4pBre0eW+r37s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tPIJFgiARBnkH7T+D3L6NTR6q6uPlvBfhLxW5YpD1l7O6zcJcIYKxxhCcfK51PrUa
	 fVNzMj2/jFOQg3xCDjl4Tl9i2ye2P9PINQXSa1UG3Hkm5qSda1YoCp9n8TmzsZZfG0
	 GCmViN/yre/yALwFMHBzc/sN2ZTM1VQJjH3mhRP8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gui-Dong Han <hanguidong02@gmail.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0872/1674] spi: use generic driver_override infrastructure
Date: Sat, 17 Oct 2026 17:52:24 +0200
Message-ID: <20261017160453.492967508@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Danilo Krummrich <dakr@kernel.org>

[ Upstream commit cc34d77dd48708d810c12bfd6f5bf03304f6c824 ]

When a driver is probed through __driver_attach(), the bus' match()
callback is called without the device lock held, thus accessing the
driver_override field without a lock, which can cause a UAF.

Fix this by using the driver-core driver_override infrastructure taking
care of proper locking internally.

Note that calling match() from __driver_attach() without the device lock
held is intentional. [1]

Also note that we do not enable the driver_override feature of struct
bus_type, as SPI - in contrast to most other buses - passes "" to
sysfs_emit() when the driver_override pointer is NULL. Thus, printing
"\n" instead of "(null)\n".

Link: https://lore.kernel.org/driver-core/DGRGTIRHA62X.3RY09D9SOK77P@kernel.org/ [1]
Reported-by: Gui-Dong Han <hanguidong02@gmail.com>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=220789
Fixes: 5039563e7c25 ("spi: Add driver_override SPI device attribute")
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Link: https://patch.msgid.link/20260324005919.2408620-12-dakr@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi.c       | 19 +++++++------------
 include/linux/spi/spi.h |  5 -----
 2 files changed, 7 insertions(+), 17 deletions(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 79e68b97dfecd..9a011544d1544 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -51,7 +51,6 @@ static void spidev_release(struct device *dev)
 	struct spi_device	*spi = to_spi_device(dev);
 
 	spi_controller_put(spi->controller);
-	kfree(spi->driver_override);
 	free_percpu(spi->pcpu_statistics);
 	kfree(spi);
 }
@@ -74,10 +73,9 @@ static ssize_t driver_override_store(struct device *dev,
 				     struct device_attribute *a,
 				     const char *buf, size_t count)
 {
-	struct spi_device *spi = to_spi_device(dev);
 	int ret;
 
-	ret = driver_set_override(dev, &spi->driver_override, buf, count);
+	ret = __device_set_driver_override(dev, buf, count);
 	if (ret)
 		return ret;
 
@@ -87,13 +85,8 @@ static ssize_t driver_override_store(struct device *dev,
 static ssize_t driver_override_show(struct device *dev,
 				    struct device_attribute *a, char *buf)
 {
-	const struct spi_device *spi = to_spi_device(dev);
-	ssize_t len;
-
-	device_lock(dev);
-	len = sysfs_emit(buf, "%s\n", spi->driver_override ? : "");
-	device_unlock(dev);
-	return len;
+	guard(spinlock)(&dev->driver_override.lock);
+	return sysfs_emit(buf, "%s\n", dev->driver_override.name ?: "");
 }
 static DEVICE_ATTR_RW(driver_override);
 
@@ -383,10 +376,12 @@ static int spi_match_device(struct device *dev, struct device_driver *drv)
 {
 	const struct spi_device	*spi = to_spi_device(dev);
 	const struct spi_driver	*sdrv = to_spi_driver(drv);
+	int ret;
 
 	/* Check override first, and if set, only use the named driver */
-	if (spi->driver_override)
-		return strcmp(spi->driver_override, drv->name) == 0;
+	ret = device_match_driver_override(dev, drv);
+	if (ret >= 0)
+		return ret;
 
 	/* Attempt an OF style match */
 	if (of_driver_match_device(dev, drv))
diff --git a/include/linux/spi/spi.h b/include/linux/spi/spi.h
index e5baf43bcfbb6..3f6ca8052f634 100644
--- a/include/linux/spi/spi.h
+++ b/include/linux/spi/spi.h
@@ -153,10 +153,6 @@ extern void spi_transfer_cs_change_delay_exec(struct spi_message *msg,
  * @modalias: Name of the driver to use with this device, or an alias
  *	for that name.  This appears in the sysfs "modalias" attribute
  *	for driver coldplugging, and in uevents used for hotplugging
- * @driver_override: If the name of a driver is written to this attribute, then
- *	the device will bind to the named driver and only the named driver.
- *	Do not set directly, because core frees it; use driver_set_override() to
- *	set or clear it.
  * @cs_gpiod: GPIO descriptor of the chipselect line (optional, NULL when
  *	not using a GPIO line)
  * @word_delay: delay to be inserted between consecutive
@@ -212,7 +208,6 @@ struct spi_device {
 	void			*controller_state;
 	void			*controller_data;
 	char			modalias[SPI_NAME_SIZE];
-	const char		*driver_override;
 	struct gpio_desc	*cs_gpiod;	/* Chip select GPIO descriptor */
 	struct spi_delay	word_delay; /* Inter-word delay */
 	/* CS delays */
-- 
2.53.0



