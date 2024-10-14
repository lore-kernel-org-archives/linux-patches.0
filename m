Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E1B11ADFE6;
	Mon, 14 Oct 2024 15:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918193; cv=none; b=Q0BP7Hq2P4uvim/9jaRX+WoUOxlyCY+afGpcDLSFGV0xlNJ85S4ixzUBrAh64hLbmNBDqKLk2T0Wx2VXKIZ4i3+LJj/2v3ovSN/393Ys5GekSW8zTGrw7faJ0GqTgzhuqPWXu2UVXHpHfUYHevRQ3A+G6FHg6dG32IheZABRWHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918193; c=relaxed/simple;
	bh=4Z1ZV3ydXAbJ5nUuhq9XwCDyLXD/jWywcuRhCEuhanM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MDydxR8BVJx+u9dIw3Q5hsUiaoQV0toTYkB290lgpvD8MG/adQNU1zXM+5rES8LXNSVDfTjpas/2qxIT3ScAvySMRDxqQynIa8JKkTvHlEemGaLlS2tgW8yjP/Q2kcFQYm3yma5lLLwhBJ5RpusTyn1VHocvRnQ3PXRgJnH7rYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fl/D0ant; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fl/D0ant"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84D29C4CECF;
	Mon, 14 Oct 2024 15:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918193;
	bh=4Z1ZV3ydXAbJ5nUuhq9XwCDyLXD/jWywcuRhCEuhanM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fl/D0antd1dBRL7QJJbOXPZ+G3SgM8a75o3QK9Y8vMUpUapHOTwsnvTnr1um/OVGi
	 RscMXxYBCx8hwvmJQlFOtsJZPmc8ODEj30qxeUohmJLZwE7kT3QZpngZYtlNyv820y
	 X1KKa9hHUI+/IxzPtjrbjIx6ksS+5au4xrEfyQ4k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasileios Amoiridis <vassilisamir@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 250/798] iio: chemical: bme680: Fix read/write ops to device by adding mutexes
Date: Mon, 14 Oct 2024 16:13:24 +0200
Message-ID: <20241014141227.758395400@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



