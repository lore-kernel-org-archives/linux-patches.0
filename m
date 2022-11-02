Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 281F67E
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 02:59:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23A66C433C1;
	Wed,  2 Nov 2022 02:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667357990;
	bh=7TpWGaSSnfb4VvfJN18uJ736Am1D1eC9A9UNJRPcBU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KH1mqONz/wcovqlmreBTG6w8ndzuqVDIrA/PUW6OtS1jAFMfSoKnRPYe12g9pzkHr
	 hrgcoHK9twgCR7aulzGbNWzuzsTMyYh68UAoitXT5BagSQId5Tipc6PldEYVadTR7t
	 VqS9Z+HIHKRW0E5yOQ1/vH49JbuXkyWESLx7Q+uw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.15 023/132] iio: adxl372: Fix unsafe buffer attributes
Date: Wed,  2 Nov 2022 03:32:09 +0100
Message-Id: <20221102022100.236864143@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022059.593236470@linuxfoundation.org>
References: <20221102022059.593236470@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Matti Vaittinen <mazziesaccount@gmail.com>

commit ab0ee36e90f611f32c3a53afe9dc743de48138e2 upstream.

The iio_triggered_buffer_setup_ext() was changed by
commit 15097c7a1adc ("iio: buffer: wrap all buffer attributes into iio_dev_attr")
to silently expect that all attributes given in buffer_attrs array are
device-attributes. This expectation was not forced by the API - and some
drivers did register attributes created by IIO_CONST_ATTR().

The added attribute "wrapping" does not copy the pointer to stored
string constant and when the sysfs file is read the kernel will access
to invalid location.

Change the IIO_CONST_ATTRs from the driver to IIO_DEVICE_ATTR in order
to prevent the invalid memory access.

Signed-off-by: Matti Vaittinen <mazziesaccount@gmail.com>
Fixes: 15097c7a1adc ("iio: buffer: wrap all buffer attributes into iio_dev_attr")
Cc: <Stable@vger.kernel.org>
Link: https://lore.kernel.org/r/19158499623cdf7f9c5efae1f13c9f1a918ff75f.1664782676.git.mazziesaccount@gmail.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/accel/adxl372.c | 23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

diff --git a/drivers/iio/accel/adxl372.c b/drivers/iio/accel/adxl372.c
index e3ecbaee61f7..bc53af809d5d 100644
--- a/drivers/iio/accel/adxl372.c
+++ b/drivers/iio/accel/adxl372.c
@@ -998,17 +998,30 @@ static ssize_t adxl372_get_fifo_watermark(struct device *dev,
 	return sprintf(buf, "%d\n", st->watermark);
 }
 
-static IIO_CONST_ATTR(hwfifo_watermark_min, "1");
-static IIO_CONST_ATTR(hwfifo_watermark_max,
-		      __stringify(ADXL372_FIFO_SIZE));
+static ssize_t hwfifo_watermark_min_show(struct device *dev,
+					 struct device_attribute *attr,
+					 char *buf)
+{
+	return sysfs_emit(buf, "%s\n", "1");
+}
+
+static ssize_t hwfifo_watermark_max_show(struct device *dev,
+					 struct device_attribute *attr,
+					 char *buf)
+{
+	return sysfs_emit(buf, "%s\n", __stringify(ADXL372_FIFO_SIZE));
+}
+
+static IIO_DEVICE_ATTR_RO(hwfifo_watermark_min, 0);
+static IIO_DEVICE_ATTR_RO(hwfifo_watermark_max, 0);
 static IIO_DEVICE_ATTR(hwfifo_watermark, 0444,
 		       adxl372_get_fifo_watermark, NULL, 0);
 static IIO_DEVICE_ATTR(hwfifo_enabled, 0444,
 		       adxl372_get_fifo_enabled, NULL, 0);
 
 static const struct attribute *adxl372_fifo_attributes[] = {
-	&iio_const_attr_hwfifo_watermark_min.dev_attr.attr,
-	&iio_const_attr_hwfifo_watermark_max.dev_attr.attr,
+	&iio_dev_attr_hwfifo_watermark_min.dev_attr.attr,
+	&iio_dev_attr_hwfifo_watermark_max.dev_attr.attr,
 	&iio_dev_attr_hwfifo_watermark.dev_attr.attr,
 	&iio_dev_attr_hwfifo_enabled.dev_attr.attr,
 	NULL,
-- 
2.38.1



