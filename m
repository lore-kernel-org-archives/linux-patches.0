Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF0BF1F470E;
	Mon, 21 Oct 2024 10:44:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507484; cv=none; b=l8kjocn+hTf0/ad4qJw9mE/Car1VFyIV8VMAaix6mNV1m85ECbvxtJH7GRd+7WfARrBcCU2/jUgmBITAptJocJ7+lYcN89pO+K+LcN59TpYOYeXMp3+LAxPBMq9Lr88QeBYDQ5PZiD+nWKYmDEHZ+kW+qe9xKdRJic/9r2thocQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507484; c=relaxed/simple;
	bh=ufOYtMKW+wqfvwtZcmR3wMPYqXtzd5bZxoX/43ZAh+I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gUlGPSjsU0L/oDN4duJ336Oo8QsKRxXFhNT0n7vGxY7TkYUnmyA6svFvmNmjS0rDKi/hYD1PCABHcqo/0fW8mQEdMFWIScueJGVvoc0EJBaCRU52irh3MYmOC/G4DHx/OX33VsegEZHbNfYHpvd/WWLtIbROMwebJ5aG8eAa32M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JC01RAK7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JC01RAK7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2E8AC4CEC3;
	Mon, 21 Oct 2024 10:44:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507484;
	bh=ufOYtMKW+wqfvwtZcmR3wMPYqXtzd5bZxoX/43ZAh+I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JC01RAK7Hx0wUYkAeczhE0doy0ZOFBsFM+llPwk9+E+KTCtBFMhT3yOwGme455eYI
	 ILRxOawTDjruXGeQtq3oNjTRO1BaFcDib0WXsPIDp4ZFuTWBdJLD76T0FOqT2BYDTY
	 VGTUi+GSeZetFPXczsAtHLsdrjV1Wz4ezEqaNGGU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.1 61/91] iio: light: veml6030: fix IIO device retrieval from embedded device
Date: Mon, 21 Oct 2024 12:25:15 +0200
Message-ID: <20241021102252.198547445@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102249.791942892@linuxfoundation.org>
References: <20241021102249.791942892@linuxfoundation.org>
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


