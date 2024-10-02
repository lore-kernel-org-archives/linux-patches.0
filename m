Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A294D1D079E;
	Wed,  2 Oct 2024 13:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876559; cv=none; b=uTe0Cdfj7tw4/hEq5+6dg2sApN5tvglIncJoBBkGpbdVwmQxsPq2RpLYKfy4Qtl71vEgUDYWCXwv5YaXln+qIGQbUMiVZ0h0jGbI/yFkk/F239vjjjKuyqhoZ5MpAvYCM5+TU6MpDI2gGfnKsAmhJosJcx8Cm8fuhGFcsSDToJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876559; c=relaxed/simple;
	bh=HA7xc5AfffQB3FkV+e5B3G1WmfhSey8mtFvm6wDGsVk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tmaarQ2aUrq/MwOTKuSbGl2pqqKQyGievW4j31j1gV5gbS3h+kmeVzJpE3JPHkx8NP9fGJmm5H2R2Ua2yIjfLN5yzmDV6ws4xAFSdQ1IhEP5QQU4D7VB6uR0bp8exZO6En0bNzT+rPFzdrIkcRxQ86IUEQ/0930Vqp+Ov0Zrbqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a9V97djb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a9V97djb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A48CC4CEC5;
	Wed,  2 Oct 2024 13:42:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876559;
	bh=HA7xc5AfffQB3FkV+e5B3G1WmfhSey8mtFvm6wDGsVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a9V97djb+A3WofDWV5mP/bweAC4vSGfCnoo2dTqZFG74U4inHZeEy9EDdq96IiOB7
	 rPbpAvKf2pzQ4Lx9rDccbix6ltBq7S2PuJm5xMFH2t+tlez/YqQEjh7rKbySHzOnEP
	 WXsdtdxMdCmarhMSO8jJnq5dYnONUC9r7MZ1QHa4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasileios Amoiridis <vassilisamir@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 458/695] iio: chemical: bme680: Fix read/write ops to device by adding mutexes
Date: Wed,  2 Oct 2024 14:57:36 +0200
Message-ID: <20241002125840.738422719@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vasileios Amoiridis <vassilisamir@gmail.com>

[ Upstream commit 77641e5a477d428335cd094b88ac54e09ccb70f4 ]

Add mutexes in the {read/write}_raw() functions of the device to guard the
read/write of data from/to the device. This is necessary because for any
operation other than temperature, multiple reads need to take place from
the device. Even though regmap has a locking by itself, it won't protect us
from multiple applications trying to read at the same time temperature and
pressure since the pressure reading includes an internal temperature
reading and there is nothing to ensure that this temperature+pressure
reading will happen sequentially without any other operation interfering
in the meantime.

Fixes: 1b3bd8592780 ("iio: chemical: Add support for Bosch BME680 sensor")
Signed-off-by: Vasileios Amoiridis <vassilisamir@gmail.com>
Link: https://patch.msgid.link/20240609233826.330516-2-vassilisamir@gmail.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/chemical/bme680_core.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/iio/chemical/bme680_core.c b/drivers/iio/chemical/bme680_core.c
index 500f56834b01f..a6bf689833dad 100644
--- a/drivers/iio/chemical/bme680_core.c
+++ b/drivers/iio/chemical/bme680_core.c
@@ -10,6 +10,7 @@
  */
 #include <linux/acpi.h>
 #include <linux/bitfield.h>
+#include <linux/cleanup.h>
 #include <linux/delay.h>
 #include <linux/device.h>
 #include <linux/module.h>
@@ -52,6 +53,7 @@ struct bme680_calib {
 struct bme680_data {
 	struct regmap *regmap;
 	struct bme680_calib bme680;
+	struct mutex lock; /* Protect multiple serial R/W ops to device. */
 	u8 oversampling_temp;
 	u8 oversampling_press;
 	u8 oversampling_humid;
@@ -827,6 +829,8 @@ static int bme680_read_raw(struct iio_dev *indio_dev,
 {
 	struct bme680_data *data = iio_priv(indio_dev);
 
+	guard(mutex)(&data->lock);
+
 	switch (mask) {
 	case IIO_CHAN_INFO_PROCESSED:
 		switch (chan->type) {
@@ -871,6 +875,8 @@ static int bme680_write_raw(struct iio_dev *indio_dev,
 {
 	struct bme680_data *data = iio_priv(indio_dev);
 
+	guard(mutex)(&data->lock);
+
 	if (val2 != 0)
 		return -EINVAL;
 
@@ -967,6 +973,7 @@ int bme680_core_probe(struct device *dev, struct regmap *regmap,
 		name = bme680_match_acpi_device(dev);
 
 	data = iio_priv(indio_dev);
+	mutex_init(&data->lock);
 	dev_set_drvdata(dev, indio_dev);
 	data->regmap = regmap;
 	indio_dev->name = name;
-- 
2.43.0



