Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADAA815E83
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SCWXjiT2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25446C433C7;
	Mon, 23 Oct 2023 11:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698061124;
	bh=jxQl9areu2bWOUCk6kSqI2qJNTCiFW5paUanNR45IQM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SCWXjiT2ip2g19ZEMSE0iHVhGj7wmwaFymlnH2QivcnGNbupgZV2sgY1WUWzobDWK
	 uMgQX3Rxysxwqndd32YPMCnjp1WaNyQzOdjjRLOp7RJpWp0yHKlgxK6SAEET1R/ZL+
	 chP22DOptDxY4SwRmDqqeeF5PPcxNxZecpsfKxsg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eugen Hristev <eugen.hristev@microchip.com>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Ludovic Desroches <ludovic.desroches@microchip.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 053/137] iio: core: Hide read accesses to iio_dev->currentmode
Date: Mon, 23 Oct 2023 12:56:50 +0200
Message-ID: <20231023104822.788704443@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104820.849461819@linuxfoundation.org>
References: <20231023104820.849461819@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miquel Raynal <miquel.raynal@bootlin.com>

[ Upstream commit 8c576f87ad7eb639b8bd4472a9bb830e0696dda5 ]

In order to later move this variable within the opaque structure, let's
create a helper for accessing it in read-only mode. This helper will be
exposed to device drivers and kept accessible for the few that could need
it. The write access to this variable however should be fully reserved to
the core so in a second step we will hide this variable into the opaque
structure.

Cc: Eugen Hristev <eugen.hristev@microchip.com>
Cc: Nicolas Ferre <nicolas.ferre@microchip.com>
Cc: Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc: Ludovic Desroches <ludovic.desroches@microchip.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/r/20220207143840.707510-11-miquel.raynal@bootlin.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Stable-dep-of: 7771c8c80d62 ("iio: cros_ec: fix an use-after-free in cros_ec_sensors_push_data()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/accel/bmc150-accel-core.c |  4 ++--
 drivers/iio/adc/at91-sama5d2_adc.c    |  4 ++--
 drivers/iio/industrialio-core.c       | 11 +++++++++++
 include/linux/iio/iio.h               |  1 +
 4 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/drivers/iio/accel/bmc150-accel-core.c b/drivers/iio/accel/bmc150-accel-core.c
index 3af763b4a9737..9eabc4d1dd0f2 100644
--- a/drivers/iio/accel/bmc150-accel-core.c
+++ b/drivers/iio/accel/bmc150-accel-core.c
@@ -1525,7 +1525,7 @@ static int bmc150_accel_buffer_postenable(struct iio_dev *indio_dev)
 	struct bmc150_accel_data *data = iio_priv(indio_dev);
 	int ret = 0;
 
-	if (indio_dev->currentmode == INDIO_BUFFER_TRIGGERED)
+	if (iio_device_get_current_mode(indio_dev) == INDIO_BUFFER_TRIGGERED)
 		return 0;
 
 	mutex_lock(&data->mutex);
@@ -1557,7 +1557,7 @@ static int bmc150_accel_buffer_predisable(struct iio_dev *indio_dev)
 {
 	struct bmc150_accel_data *data = iio_priv(indio_dev);
 
-	if (indio_dev->currentmode == INDIO_BUFFER_TRIGGERED)
+	if (iio_device_get_current_mode(indio_dev) == INDIO_BUFFER_TRIGGERED)
 		return 0;
 
 	mutex_lock(&data->mutex);
diff --git a/drivers/iio/adc/at91-sama5d2_adc.c b/drivers/iio/adc/at91-sama5d2_adc.c
index ecb49bc452ae6..806fdcd79e64d 100644
--- a/drivers/iio/adc/at91-sama5d2_adc.c
+++ b/drivers/iio/adc/at91-sama5d2_adc.c
@@ -894,7 +894,7 @@ static int at91_adc_buffer_prepare(struct iio_dev *indio_dev)
 		return at91_adc_configure_touch(st, true);
 
 	/* if we are not in triggered mode, we cannot enable the buffer. */
-	if (!(indio_dev->currentmode & INDIO_ALL_TRIGGERED_MODES))
+	if (!(iio_device_get_current_mode(indio_dev) & INDIO_ALL_TRIGGERED_MODES))
 		return -EINVAL;
 
 	/* we continue with the triggered buffer */
@@ -947,7 +947,7 @@ static int at91_adc_buffer_postdisable(struct iio_dev *indio_dev)
 		return at91_adc_configure_touch(st, false);
 
 	/* if we are not in triggered mode, nothing to do here */
-	if (!(indio_dev->currentmode & INDIO_ALL_TRIGGERED_MODES))
+	if (!(iio_device_get_current_mode(indio_dev) & INDIO_ALL_TRIGGERED_MODES))
 		return -EINVAL;
 
 	/*
diff --git a/drivers/iio/industrialio-core.c b/drivers/iio/industrialio-core.c
index f95a95fd9d0a5..6145e6e4f0ffd 100644
--- a/drivers/iio/industrialio-core.c
+++ b/drivers/iio/industrialio-core.c
@@ -2084,6 +2084,17 @@ void iio_device_release_direct_mode(struct iio_dev *indio_dev)
 }
 EXPORT_SYMBOL_GPL(iio_device_release_direct_mode);
 
+/**
+ * iio_device_get_current_mode() - helper function providing read-only access to
+ *				   the @currentmode variable
+ * @indio_dev:			   IIO device structure for device
+ */
+int iio_device_get_current_mode(struct iio_dev *indio_dev)
+{
+	return indio_dev->currentmode;
+}
+EXPORT_SYMBOL_GPL(iio_device_get_current_mode);
+
 subsys_initcall(iio_init);
 module_exit(iio_exit);
 
diff --git a/include/linux/iio/iio.h b/include/linux/iio/iio.h
index 0346acbbed2ee..0cac05d5ef1c3 100644
--- a/include/linux/iio/iio.h
+++ b/include/linux/iio/iio.h
@@ -542,6 +542,7 @@ struct iio_dev {
 };
 
 int iio_device_id(struct iio_dev *indio_dev);
+int iio_device_get_current_mode(struct iio_dev *indio_dev);
 bool iio_buffer_enabled(struct iio_dev *indio_dev);
 
 const struct iio_chan_spec
-- 
2.40.1



