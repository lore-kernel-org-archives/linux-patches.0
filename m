Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA077149C57;
	Mon, 16 Sep 2024 12:08:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488506; cv=none; b=mh11RCceEGqt6bM5VJ2y0Mvdu+jvUwS3ysRnjUByZ6rwev6o0mOB5Ya1IjodmIPmJhPeh0sXGFb7VTOJ6xMt0O/aFS54UXdSv6KcuWExs+A5r+X7f2jZIZd9MrP+oWGOFq4hJE07zwikD4dS+0ARdzdur8vu5mUtMDf7QYTeX8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488506; c=relaxed/simple;
	bh=rawQqJgEh2BtVX+IS9/lh/MEJXZ61nHby/ei5ho3TLw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NoPpR9li0bgWVOOUNS0Mq0US1lCMpVXD7lKa7iZYfP9ENlXAg5AUo9KTkR+ZBk4XbmD39LF7HW5HWecOqeNhQ7WBWisV5oCnXDlom+k0b2GrLON1Z1Q3IGTk4FTgXUwN91oGGLrxuJlnBUl/maCeRQzF6bRae/GhhYWEMPLj1Gw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UBZr8hLb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UBZr8hLb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61D3EC4CEC4;
	Mon, 16 Sep 2024 12:08:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488506;
	bh=rawQqJgEh2BtVX+IS9/lh/MEJXZ61nHby/ei5ho3TLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UBZr8hLbH/iGlaC2mAnetpklzM+ODnBgEzsaOiM10rW08Lm/3hmcpkKPvthXS3ffJ
	 GPcnm9BtwCMHjrz5JMOf799kyUXVj2vlVm9aLfp+yUe8XAhanWHIiQTdP1CbMAFJAP
	 Eo5/eu40KCUypoVDddDSCxb2BnGTQx6mm1qfHewU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lars-Peter Clausen <lars@metafoo.de>,
	Michael Hennerich <Michael.Hennerich@analog.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 03/91] iio: adc: ad7124: Switch from of specific to fwnode based property handling
Date: Mon, 16 Sep 2024 13:43:39 +0200
Message-ID: <20240916114224.623822327@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114224.509743970@linuxfoundation.org>
References: <20240916114224.509743970@linuxfoundation.org>
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

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

[ Upstream commit a6eaf02b82744b424b9b2c74847282deb2c6f77b ]

Using the generic firmware data access functions from property.h
provides a number of advantages:
 1) Works with different firmware types.
 2) Doesn't provide a 'bad' example for new IIO drivers.
 3) Lets us use the new _scoped() loops with automatic reference count
    cleanup for fwnode_handle

Cc: Lars-Peter Clausen <lars@metafoo.de>
Cc: Michael Hennerich <Michael.Hennerich@analog.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20240218172731.1023367-4-jic23@kernel.org
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Stable-dep-of: 61cbfb5368dd ("iio: adc: ad7124: fix DT configuration parsing")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/ad7124.c | 55 +++++++++++++++++-----------------------
 1 file changed, 23 insertions(+), 32 deletions(-)

diff --git a/drivers/iio/adc/ad7124.c b/drivers/iio/adc/ad7124.c
index 2976c62b58c0..bd323c6bd756 100644
--- a/drivers/iio/adc/ad7124.c
+++ b/drivers/iio/adc/ad7124.c
@@ -14,7 +14,8 @@
 #include <linux/kernel.h>
 #include <linux/kfifo.h>
 #include <linux/module.h>
-#include <linux/of.h>
+#include <linux/mod_devicetable.h>
+#include <linux/property.h>
 #include <linux/regulator/consumer.h>
 #include <linux/spi/spi.h>
 
@@ -812,22 +813,19 @@ static int ad7124_check_chip_id(struct ad7124_state *st)
 	return 0;
 }
 
-static int ad7124_of_parse_channel_config(struct iio_dev *indio_dev,
-					  struct device_node *np)
+static int ad7124_parse_channel_config(struct iio_dev *indio_dev,
+				       struct device *dev)
 {
 	struct ad7124_state *st = iio_priv(indio_dev);
 	struct ad7124_channel_config *cfg;
 	struct ad7124_channel *channels;
-	struct device_node *child;
 	struct iio_chan_spec *chan;
 	unsigned int ain[2], channel = 0, tmp;
 	int ret;
 
-	st->num_channels = of_get_available_child_count(np);
-	if (!st->num_channels) {
-		dev_err(indio_dev->dev.parent, "no channel children\n");
-		return -ENODEV;
-	}
+	st->num_channels = device_get_child_node_count(dev);
+	if (!st->num_channels)
+		return dev_err_probe(dev, -ENODEV, "no channel children\n");
 
 	chan = devm_kcalloc(indio_dev->dev.parent, st->num_channels,
 			    sizeof(*chan), GFP_KERNEL);
@@ -843,39 +841,38 @@ static int ad7124_of_parse_channel_config(struct iio_dev *indio_dev,
 	indio_dev->num_channels = st->num_channels;
 	st->channels = channels;
 
-	for_each_available_child_of_node(np, child) {
+	device_for_each_child_node_scoped(dev, child) {
 		cfg = &st->channels[channel].cfg;
 
-		ret = of_property_read_u32(child, "reg", &channel);
+		ret = fwnode_property_read_u32(child, "reg", &channel);
 		if (ret)
-			goto err;
+			return ret;
 
-		if (channel >= indio_dev->num_channels) {
-			dev_err(indio_dev->dev.parent,
+		if (channel >= indio_dev->num_channels)
+			return dev_err_probe(dev, -EINVAL,
 				"Channel index >= number of channels\n");
-			ret = -EINVAL;
-			goto err;
-		}
 
-		ret = of_property_read_u32_array(child, "diff-channels",
-						 ain, 2);
+		ret = fwnode_property_read_u32_array(child, "diff-channels",
+						     ain, 2);
 		if (ret)
-			goto err;
+			return ret;
 
 		st->channels[channel].nr = channel;
 		st->channels[channel].ain = AD7124_CHANNEL_AINP(ain[0]) |
 						  AD7124_CHANNEL_AINM(ain[1]);
 
-		cfg->bipolar = of_property_read_bool(child, "bipolar");
+		cfg->bipolar = fwnode_property_read_bool(child, "bipolar");
 
-		ret = of_property_read_u32(child, "adi,reference-select", &tmp);
+		ret = fwnode_property_read_u32(child, "adi,reference-select", &tmp);
 		if (ret)
 			cfg->refsel = AD7124_INT_REF;
 		else
 			cfg->refsel = tmp;
 
-		cfg->buf_positive = of_property_read_bool(child, "adi,buffered-positive");
-		cfg->buf_negative = of_property_read_bool(child, "adi,buffered-negative");
+		cfg->buf_positive =
+			fwnode_property_read_bool(child, "adi,buffered-positive");
+		cfg->buf_negative =
+			fwnode_property_read_bool(child, "adi,buffered-negative");
 
 		chan[channel] = ad7124_channel_template;
 		chan[channel].address = channel;
@@ -885,10 +882,6 @@ static int ad7124_of_parse_channel_config(struct iio_dev *indio_dev,
 	}
 
 	return 0;
-err:
-	of_node_put(child);
-
-	return ret;
 }
 
 static int ad7124_setup(struct ad7124_state *st)
@@ -948,9 +941,7 @@ static int ad7124_probe(struct spi_device *spi)
 	struct iio_dev *indio_dev;
 	int i, ret;
 
-	info = of_device_get_match_data(&spi->dev);
-	if (!info)
-		info = (void *)spi_get_device_id(spi)->driver_data;
+	info = spi_get_device_match_data(spi);
 	if (!info)
 		return -ENODEV;
 
@@ -970,7 +961,7 @@ static int ad7124_probe(struct spi_device *spi)
 	if (ret < 0)
 		return ret;
 
-	ret = ad7124_of_parse_channel_config(indio_dev, spi->dev.of_node);
+	ret = ad7124_parse_channel_config(indio_dev, &spi->dev);
 	if (ret < 0)
 		return ret;
 
-- 
2.43.0



