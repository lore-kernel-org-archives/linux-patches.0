Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F40F81D14FB;
	Wed,  2 Oct 2024 14:42:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880141; cv=none; b=skm3/nbh1q6H33pUlOlwyjbV4qk6qz5fhm6RpBTvHZzthhyXIZPUcKJpyR/Px8L6X92mgMLY5lJ1KiK6WdnYJCWF2Q75emkc1G/nitIinWE3TC9zC0XrNYghXZV7wTaHxzUAx9NPzBLBQ42GoFJr6VNySDAjf+cE4dOM7l5w8uA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880141; c=relaxed/simple;
	bh=WgN/cm3DAajkXQG8n45jd4VhjXtpO1Ccv95aBEwdYWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FW1/kPPRmuxQDs31it+n4288k6Dvn29He+KIGTCxRzY0ZHEadlQxt7ckpHMfQ6svEvjsh8GhJFkTB2vNzxjX0xgq0/X/xbXNTWkrDK85UeeGv8NG2h1IZfm2q/uHkMoXWmx1WFlIn11TIjU5JTqdssPWhQEQPryDMz+Kb3egvVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hvh+4jPz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hvh+4jPz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A740C4CEC2;
	Wed,  2 Oct 2024 14:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880140;
	bh=WgN/cm3DAajkXQG8n45jd4VhjXtpO1Ccv95aBEwdYWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hvh+4jPziDh2jmnf72n+Ii74AfJkg9tjVhjdA2xejnrtWmxtFpPlqub7BVa4zYB8S
	 GVPdFbv5SzS+0nHx3Qvx5ppT7BhLpKf5l3iMYSaNNP5iUWOyhfaR4eBTk2YhJOowgq
	 C2RpXHCtFg89iZAAHB/T1W9mt4ZjBFcLN3CaFz2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasileios Amoiridis <vassilisamir@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 357/538] iio: chemical: bme680: Fix read/write ops to device by adding mutexes
Date: Wed,  2 Oct 2024 14:59:56 +0200
Message-ID: <20241002125806.518632714@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



