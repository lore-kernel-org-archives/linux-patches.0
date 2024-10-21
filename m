Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F4111F4279;
	Mon, 21 Oct 2024 10:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729507061; cv=none; b=B9xY5FpuRMk7HVNwKwyoEVbj7G2kA7l/kCjMPnvGP5S28GbSIrhgMqf5Uuw6O3pAt9rwYHc4j5yrN0AtICgnf9R/a/b5dTbTcteb6oLkpukgf3GwLHv6/lrQ2eW4AI7I2vkmlj+disug42m080V115EJEJFPaG6YqA/khowz4TA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729507061; c=relaxed/simple;
	bh=h3vSOnfTvsWZ42kD+72wp4L9LNOENvP+zXvyC2VbuQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T0lve7Mv0LmC/XA461SPkC+7UBl5UBIKkARlJkysrVHzc+cnofmvrDgToZD0px0Y++fPO4k/lA9UH9noF3fV3/Aninpg9+ni3XX1WnfwaTwS0cK42iqMumDpoBg9lIzIxo6q2s15tIjImRiuh+6kfVRPSh831gJfXWU39+g3ipg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rLogsZvm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rLogsZvm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C53BEC4CEC3;
	Mon, 21 Oct 2024 10:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729507061;
	bh=h3vSOnfTvsWZ42kD+72wp4L9LNOENvP+zXvyC2VbuQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rLogsZvmxghLFBSpKBzl3I2LhMd9JSNTXzLXORQACnQScIIcNfn/8fVFr6TJo/X5W
	 weUlvuKN6nJx4X8SlYJKnD45/VtkRuKlmtVSmC10in92WXBRqT4DexTXdkWBHGekEF
	 frg8XeensHpkl57kuamQEw/4Y8SmX1tLz+bSwFYM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.6 076/124] iio: light: veml6030: fix IIO device retrieval from embedded device
Date: Mon, 21 Oct 2024 12:24:40 +0200
Message-ID: <20241021102259.672820401@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241021102256.706334758@linuxfoundation.org>
References: <20241021102256.706334758@linuxfoundation.org>
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


