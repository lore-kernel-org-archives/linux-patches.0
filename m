Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2A96169AD2;
	Tue, 16 Jun 2026 17:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781632145; cv=none; b=NUnHBioVw0nHmM8wxwhtphNUPOdsFzBkUfQsLj2PXAQzl4FNoLIWdPs9Wqi0MiJFQi6XIemKXdNR+h7QqHbT59IFj1JKQKcT47X65aS2Itfrib6gB07n37XSCNOy5GbSe6bD45x+DyVbelYtHWrcxVUfguxPa8xtupmbd7K3D4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781632145; c=relaxed/simple;
	bh=IhRsPUVwviKF+5p8jNedPIGt1yGTukTFnRqz0WUxC/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dxs7lzxmP5qU8Rt8vs6qh3vLpXVFyCJDi7l00O7gGMajYK2hlqzPQjQpMcmuifjndYJpbgQxQct7h5/TEonHJ0fsc5l1m9wepLKQzQxY9dIToS22V+CmLDlYlcOVvxoSMf9PiHXe6nwldlZC6K3GBuUc+zAO9N6P0nJPKEzqR84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZzeFNGGL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZzeFNGGL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88E9E1F000E9;
	Tue, 16 Jun 2026 17:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781632144;
	bh=rOirTYkx8r0HGiVFykdHjI1fkf9SEmeNqL06dwH4S/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZzeFNGGLO3EDw6LGPuEFImmXj/hscTkBpYkgBUbKW1j6dyrSq2iBNhKTeWwO+SRHJ
	 bvBAT6V4Duz/wn9E+6KcNXQJpBKdEcRltcIf5emy5J9VEUNgjuKzMTZx/wxGHrPQR2
	 9866OGvWTLgEV4jA0t0EhPFu9vfV8DzHWZ6TyJOg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Saravana Kannan <saravanak@kernel.org>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 355/522] spi: fix resource leaks on device setup failure
Date: Tue, 16 Jun 2026 20:28:22 +0530
Message-ID: <20260616145142.402155913@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

[ Upstream commit db357034f7e0cf23f233f414a8508312dfe8fbbe ]

Make sure to call controller cleanup() if spi_setup() fails while
registering a device to avoid leaking any resources allocated by
setup().

Fixes: c7299fea6769 ("spi: Fix spi device unregister flow")
Cc: stable@vger.kernel.org	# 5.13
Cc: Saravana Kannan <saravanak@kernel.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260410154907.129248-2-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
[ adjusted context ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi.c |   61 ++++++++++++++++++++++++++++++++----------------------
 1 file changed, 37 insertions(+), 24 deletions(-)

--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -42,6 +42,8 @@ EXPORT_TRACEPOINT_SYMBOL(spi_transfer_st
 
 #include "internals.h"
 
+static int __spi_setup(struct spi_device *spi, bool initial_setup);
+
 static DEFINE_IDR(spi_master_idr);
 
 static void spidev_release(struct device *dev)
@@ -666,7 +668,7 @@ static int __spi_add_device(struct spi_d
 	 * normally rely on the device being setup.  Devices
 	 * using SPI_CS_HIGH can't coexist well otherwise...
 	 */
-	status = spi_setup(spi);
+	status = __spi_setup(spi, true);
 	if (status < 0) {
 		dev_err(dev, "can't setup %s, status %d\n",
 				dev_name(&spi->dev), status);
@@ -3688,27 +3690,7 @@ static int spi_set_cs_timing(struct spi_
 	return status;
 }
 
-/**
- * spi_setup - setup SPI mode and clock rate
- * @spi: the device whose settings are being modified
- * Context: can sleep, and no requests are queued to the device
- *
- * SPI protocol drivers may need to update the transfer mode if the
- * device doesn't work with its default.  They may likewise need
- * to update clock rates or word sizes from initial values.  This function
- * changes those settings, and must be called from a context that can sleep.
- * Except for SPI_CS_HIGH, which takes effect immediately, the changes take
- * effect the next time the device is selected and data is transferred to
- * or from it.  When this function returns, the spi device is deselected.
- *
- * Note that this call will fail if the protocol driver specifies an option
- * that the underlying controller or its driver does not support.  For
- * example, not all hardware supports wire transfers using nine bit words,
- * LSB-first wire encoding, or active-high chipselects.
- *
- * Return: zero on success, else a negative error code.
- */
-int spi_setup(struct spi_device *spi)
+static int __spi_setup(struct spi_device *spi, bool initial_setup)
 {
 	unsigned	bad_bits, ugly_bits;
 	int		status = 0;
@@ -3787,7 +3769,7 @@ int spi_setup(struct spi_device *spi)
 	status = spi_set_cs_timing(spi);
 	if (status) {
 		mutex_unlock(&spi->controller->io_mutex);
-		return status;
+		goto err_cleanup;
 	}
 
 	if (spi->controller->auto_runtime_pm && spi->controller->set_cs) {
@@ -3796,7 +3778,7 @@ int spi_setup(struct spi_device *spi)
 			mutex_unlock(&spi->controller->io_mutex);
 			dev_err(&spi->controller->dev, "Failed to power device: %d\n",
 				status);
-			return status;
+			goto err_cleanup;
 		}
 
 		/*
@@ -3833,6 +3815,37 @@ int spi_setup(struct spi_device *spi)
 			status);
 
 	return status;
+
+err_cleanup:
+	if (initial_setup)
+		spi_cleanup(spi);
+
+	return status;
+}
+
+/**
+ * spi_setup - setup SPI mode and clock rate
+ * @spi: the device whose settings are being modified
+ * Context: can sleep, and no requests are queued to the device
+ *
+ * SPI protocol drivers may need to update the transfer mode if the
+ * device doesn't work with its default.  They may likewise need
+ * to update clock rates or word sizes from initial values.  This function
+ * changes those settings, and must be called from a context that can sleep.
+ * Except for SPI_CS_HIGH, which takes effect immediately, the changes take
+ * effect the next time the device is selected and data is transferred to
+ * or from it.  When this function returns, the SPI device is deselected.
+ *
+ * Note that this call will fail if the protocol driver specifies an option
+ * that the underlying controller or its driver does not support.  For
+ * example, not all hardware supports wire transfers using nine bit words,
+ * LSB-first wire encoding, or active-high chipselects.
+ *
+ * Return: zero on success, else a negative error code.
+ */
+int spi_setup(struct spi_device *spi)
+{
+	return __spi_setup(spi, false);
 }
 EXPORT_SYMBOL_GPL(spi_setup);
 


