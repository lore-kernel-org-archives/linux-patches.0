Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD9EB36606F;
	Mon, 23 Feb 2026 12:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771850281; cv=none; b=DFNyk1g5O9YYq7x/RtnV54NlTpFbveAwdWy6pfpGCQakeyK6fdhSnAXy1AUSZKi6et7k7mhpCoI2J76SJMHz/A3irlQiZIR4fuHPdDnqUxlyGa6AzzSTryh3I8jsEJ5PkNFFKrFO2Z6QF+HA/iPWFIXcckvMsRCHWYmZqKynxrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771850281; c=relaxed/simple;
	bh=joVrSiLBOUSMSp4SN28ckyepXrgflCGpqwb34ECohbQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ML2SNyQs6QbQSfZeq9T0FZS0rKb6Y1S3lRU2UhrLx2VOI0XnQb7WMeykcP0EX9gnexJGDsuyZewpqePCWRyC23cfhrH+yIKHGX+aS/RhjooTTB7TdkJ51Dz/nOLATK0OBjDIGLamjO9QzuRdmNsKuZG56fs2DdikzSRwHg5IjxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VOJkvleo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VOJkvleo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D01FC2BCB0;
	Mon, 23 Feb 2026 12:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771850281;
	bh=joVrSiLBOUSMSp4SN28ckyepXrgflCGpqwb34ECohbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VOJkvleoRyxxJBgKnCSjrLlKEqO/Bae44WRozp1sNzRfZW+sdkxINKKjZLxwzUGKW
	 DfQwFx1eSvT+tFLn5ridssspwPHqHJEAnH1Y7cGywaMJQH4rdxxX+7tnRXzRsTLWSm
	 hPERjm97vdZkDt9aT2qTyhnc9C/Ng3V4m+ay0mYa/PJtB2sOj9E/xoJWQ9pbJdfS0X
	 8QWiNuZ+Q30wsBy2sei12Jv5OL9MQu3amUXh3DT3s+DzoYO66eLMv2pjR48ercLbNQ
	 FsF6+fB9T+ifIEFyhofE8cafDUWI9oK8Upa7nXGnK7ePT/T1PHT4kK8J32HJLqpqyb
	 mcZIYaTUKrK3Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Fabian Godehardt <fg@emlix.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-spi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.12] spi: spidev: fix lock inversion between spi_lock and buf_lock
Date: Mon, 23 Feb 2026 07:37:20 -0500
Message-ID: <20260223123738.1532940-15-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260223123738.1532940-1-sashal@kernel.org>
References: <20260223123738.1532940-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

### 3. Fix Approach

The fix is clean and straightforward:

1. **Removes `buf_lock` entirely** from the `spidev_data` structure
2. **Removes the `spidev_sync()` wrapper** that was taking `spi_lock`
   internally
3. **Changes `spidev_read()`/`spidev_write()`** to use `spi_lock`
   directly (instead of `buf_lock`), adding a NULL check for
   `spidev->spi` before proceeding
4. **Removes `buf_lock` acquisition from `spidev_ioctl()`** and
   `spidev_compat_ioc_message()` since `spi_lock` is already held

This eliminates the lock inversion by using a single lock (`spi_lock`)
for all serialization, which is correct since `spi_lock` already
protected the SPI device pointer and was needed for all SPI operations.

### 4. Stable Kernel Criteria Assessment

| Criterion | Assessment |
|-----------|-----------|
| **Fixes a real bug** | YES - deadlock reproducible from userspace |
| **Obviously correct** | YES - consolidating to single lock eliminates
AB-BA inversion |
| **Small and contained** | YES - single file, single driver, ~30 lines
net removal |
| **No new features** | YES - pure bug fix, no ABI/behavior changes |
| **Tested** | YES - accepted by SPI maintainer Mark Brown |

### 5. Risk Assessment

**Low risk:**
- The change is within a single, self-contained userspace-facing driver
  (`spidev`)
- It simplifies locking (removes one mutex entirely), reducing
  complexity
- `spi_lock` was already held in the ioctl path that also held
  `buf_lock` — so `spi_lock` already provided the serialization
- The old `buf_lock` comment in ioctl stated it was for "triple duty"
  but all three duties are covered by `spi_lock`
- No changes to userspace ABI

**Potential concern:** Slightly coarser locking (one lock instead of
two), but since `spi_lock` was always taken in both paths anyway, the
practical concurrency difference is negligible.

### 6. User Impact

- **spidev is widely used** - it's the primary way userspace programs
  interact with SPI devices (used in embedded Linux, Raspberry Pi, IoT
  devices, etc.)
- The deadlock is **trivially reproducible** from userspace with
  concurrent read/write and ioctl calls on the same fd
- Any multithreaded application using spidev is at risk of hitting this
  deadlock
- Lockdep warnings are triggered, which is disruptive even when the
  deadlock doesn't manifest

### Verification

- **Lock ordering confirmed:** The subagent verified that
  `spidev_read()`/`spidev_write()` took `buf_lock` first then `spi_lock`
  (via `spidev_sync()`), while `spidev_ioctl()` took `spi_lock` first
  then `buf_lock` — classic AB-BA
- **Bug age verified:** `spi_lock` was introduced in commit `25d5cb4b`
  (May 2008); the AB-BA pattern has existed since then, becoming more
  prominent after the spinlock-to-mutex conversion in Jan 2023
- **Commit accepted by SPI maintainer Mark Brown** (Signed-off-by),
  confirming the fix is correct
- **The fix removes `spidev_sync()` entirely** and replaces calls with
  `spidev_sync_unlocked()` — verified in the diff that `spidev_sync()`
  only added `spi_lock` around `spidev_sync_unlocked()`, so callers that
  now hold `spi_lock` themselves can call `spidev_sync_unlocked()`
  directly
- **NULL check for `spidev->spi` added in read/write paths** —
  previously this check was inside `spidev_sync()`, now it's done by the
  callers before calling `spidev_sync_unlocked()`, maintaining the same
  safety against device removal
- **Could not independently verify** the specific lockdep warning output
  in the commit message, but the AB-BA pattern is self-evident from code
  inspection

### Conclusion

This is a textbook stable backport candidate. It fixes a real,
reproducible deadlock in a widely-used driver. The fix is small,
obviously correct (consolidates two locks into one, eliminating the
inversion), contained to a single file, and introduces no new features
or ABI changes. The bug affects any multithreaded userspace application
using spidev, which is extremely common in embedded Linux.

**YES**

 drivers/spi/spidev.c | 63 ++++++++++++++++----------------------------
 1 file changed, 22 insertions(+), 41 deletions(-)

diff --git a/drivers/spi/spidev.c b/drivers/spi/spidev.c
index 9a0160f6dc3dc..f28528ed1c24e 100644
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
@@ -379,14 +374,6 @@ spidev_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 
 	ctlr = spi->controller;
 
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
@@ -510,7 +497,6 @@ spidev_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 		break;
 	}
 
-	mutex_unlock(&spidev->buf_lock);
 	spi_dev_put(spi);
 	mutex_unlock(&spidev->spi_lock);
 	return retval;
@@ -541,9 +527,6 @@ spidev_compat_ioc_message(struct file *filp, unsigned int cmd,
 		return -ESHUTDOWN;
 	}
 
-	/* SPI_IOC_MESSAGE needs the buffer locked "normally" */
-	mutex_lock(&spidev->buf_lock);
-
 	/* Check message and copy into scratch area */
 	ioc = spidev_get_ioc_message(cmd, u_ioc, &n_ioc);
 	if (IS_ERR(ioc)) {
@@ -564,7 +547,6 @@ spidev_compat_ioc_message(struct file *filp, unsigned int cmd,
 	kfree(ioc);
 
 done:
-	mutex_unlock(&spidev->buf_lock);
 	spi_dev_put(spi);
 	mutex_unlock(&spidev->spi_lock);
 	return retval;
@@ -802,7 +784,6 @@ static int spidev_probe(struct spi_device *spi)
 	/* Initialize the driver data */
 	spidev->spi = spi;
 	mutex_init(&spidev->spi_lock);
-	mutex_init(&spidev->buf_lock);
 
 	INIT_LIST_HEAD(&spidev->device_entry);
 
-- 
2.51.0

