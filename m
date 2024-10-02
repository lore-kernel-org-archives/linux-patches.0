Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE1241D049F;
	Wed,  2 Oct 2024 14:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878452; cv=none; b=tr74K+9jTGPCeqST0qVOAJIcyRC7UmTpv3gHliz8aR9Rd1zXdSv9qdFkw4mntn/i7kx+6DOKuZ3WRR0EarzQAqWTFKDUpIXYjI9NW2/ReAs+kHF5orr7YhAw+ocD05Enwd1V63LxTSysokcPgbaqM21x0mx2f9VDRL7+euURgY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878452; c=relaxed/simple;
	bh=5qcxnM9uEqEBmGb22koaQ6ihcXN0CB/o7lsAEe7w0BY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RmL1MsAF6kf1IBerF24xERBF2l2YyqJrAXW9P6w0ie3fIH/RribwgD7oRpd+G9p1M/BgETBa4S6Xvy46ZP+qDz8/xqTZtDV4Z8H+EsxB703HsuGrhiCmUCH9vi/8M2Iq7QCWS0I63TFUUxYb2WfNgZwLCVk7Duj9z9FrPGHcgZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bLV42XIF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bLV42XIF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E3F5C4CEC2;
	Wed,  2 Oct 2024 14:14:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878452;
	bh=5qcxnM9uEqEBmGb22koaQ6ihcXN0CB/o7lsAEe7w0BY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bLV42XIFkmshdcy54/ROhDwBQQkTrfY2wEwq3m1OgZKat7bdRkg5EuUU69crIH1ph
	 Q8Qd2bucMLviOmYeAqj5G5np5H43YcFI+ljaFH+dfCwXnBduerWRA5OQlo3ayJQuke
	 AmLI8HI4AMgnpDuC9BdYQhsfeZbU4kVi+HryhmVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasileios Amoiridis <vassilisamir@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 419/634] iio: chemical: bme680: Fix read/write ops to device by adding mutexes
Date: Wed,  2 Oct 2024 14:58:39 +0200
Message-ID: <20241002125827.641488969@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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



