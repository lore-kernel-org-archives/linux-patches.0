Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 059C81E47A6;
	Mon, 21 Oct 2024 10:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507906; cv=none; b=ptr0BkIaSUCB7Rv4B69loooUQVn8BA0+8wvyd1dxRgbK4PiY2EsgV/L59di0y0MFd7/V5kGk4qLBt+PvADYrfe1Vbs9aXHVBIIk2LR8BvqYrZfVFaR6LRZwontCY/KtfYotgDxZcsWBpCT/rN9aB25qggXwbNRIV2xj40UPSrKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507906; c=relaxed/simple;
	bh=AE9zmayRwiUGFcZVjk60D8lqUEqqS1jSBi3ijyLwigY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aAD/d3oEYPC/zzLAGgD0vZT5iWZJVsuFkeG0flGTBa+fU1GZQ6NeCsicF3XiQO3Ma3wrVw+g5ANje98wBHmc8gy7c+yv7Z5HLG5GAsO1FQAqe8aCrUGUb3ySiKVnFjYgV/mTynwMWigVsZyjs+5HSbiXjCzsCFbZbTkXDbnFO/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ovuzgtg6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ovuzgtg6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 717CEC4CEC7;
	Mon, 21 Oct 2024 10:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507905;
	bh=AE9zmayRwiUGFcZVjk60D8lqUEqqS1jSBi3ijyLwigY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ovuzgtg6lE8CgwySlxKrGSbETompoP56wyjQYC4s8zjgYBnJQkw5lZZ9xCpVqP8mB
	 zh3LiXKNoeh9V6VqGmLkojOgag5DYVAkldtWKb6PVSZJHa6FDn10OZgEPQsinHj6xz
	 bd+8+wkGBpa8htuwjeMWCbt2/g/PEIxl1Z4VIyJA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.10 32/52] iio: light: veml6030: fix IIO device retrieval from embedded device
Date: Mon, 21 Oct 2024 12:25:53 +0200
Message-ID: <20241021102242.884981428@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102241.624153108@linuxfoundation.org>
References: <20241021102241.624153108@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

commit c7c44e57750c31de43906d97813273fdffcf7d02 upstream.

The dev pointer that is received as an argument in the
in_illuminance_period_available_show function references the device
embedded in the IIO device, not in the i2c client.

dev_to_iio_dev() must be used to accessthe right data. The current
implementation leads to a segmentation fault on every attempt to read
the attribute because indio_dev gets a NULL assignment.

This bug has been present since the first appearance of the driver,
apparently since the last version (V6) before getting applied. A
constant attribute was used until then, and the last modifications might
have not been tested again.

Cc: stable@vger.kernel.org
Fixes: 7b779f573c48 ("iio: light: add driver for veml6030 ambient light sensor")
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Link: https://patch.msgid.link/20240913-veml6035-v1-3-0b09c0c90418@gmail.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/light/veml6030.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/iio/light/veml6030.c
+++ b/drivers/iio/light/veml6030.c
@@ -99,9 +99,8 @@ static const char * const period_values[
 static ssize_t in_illuminance_period_available_show(struct device *dev,
 				struct device_attribute *attr, char *buf)
 {
+	struct veml6030_data *data = iio_priv(dev_to_iio_dev(dev));
 	int ret, reg, x;
-	struct iio_dev *indio_dev = i2c_get_clientdata(to_i2c_client(dev));
-	struct veml6030_data *data = iio_priv(indio_dev);
 
 	ret = regmap_read(data->regmap, VEML6030_REG_ALS_CONF, &reg);
 	if (ret) {


