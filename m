Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1E172F549F;
	Thu, 28 May 2026 20:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780001352; cv=none; b=MKxTP3yd5sEp6PI0PZzfODOIwAzA3IGCgLH8SWMZ/elrmcjXcpakjwZUmTYFxDFGFsNoYTxuyMrQ3vOBZBI/AX5VzWCTthceXs9CU1HXO4UNJIxpyyTPKqVYIm4mnRXMXgrKmYB0ITq350DgI1Wa73Hrm8I/Iu96YgNImeqOGkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780001352; c=relaxed/simple;
	bh=eqR3tJM7YKcnf3Eoq9NcrqyCz2kztnPn7wn9pd8xp1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FvZCHcR+sQfJ3CaHXN/sr95PWNVwvEPJH+Dp3u8IDsyRw9BjTx0Wv4nTm9ZoSJxk20G1h8LsfOH6frO//NZ41xqllHM2oZKDULymfIfUjWAadbltd5futc67y64oFtmovqwCmCfbXLzVH9tV65VqZ0K+5wRVeneq3AvAbaAK7Vg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YRgal6NW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YRgal6NW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BB801F000E9;
	Thu, 28 May 2026 20:49:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780001351;
	bh=FxHRxiQ6XugTT/kkIQuSiEyyvOhSjW70075xXUvBVC0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YRgal6NWmS+3iDOKTxqlEZ1dGIcHTLWZ1SkNvaQsSGTW64SWrks/SPGMwTeDo/URr
	 23ZOrM3XzjqBs0Ff7sPevoDJHDAffGwjxQ40Lr074dJTSeA0imIKt+kZgIU0HE8xNU
	 whhlHT5LeK9sZVlkKMAEIwksPEw6x5KNdA8TO85I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdurrahman Hussain <abdurrahman@nexthop.ai>,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.6 096/186] hwmon: (pmbus/adm1266) reject short block-read responses in the GPIO accessors
Date: Thu, 28 May 2026 21:49:36 +0200
Message-ID: <20260528194931.526951477@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194928.941004471@linuxfoundation.org>
References: <20260528194928.941004471@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Abdurrahman Hussain <abdurrahman@nexthop.ai>

commit a7232f68c43ca62f545049b7f5fbfc75137b843b upstream.

adm1266_gpio_get() and adm1266_gpio_get_multiple() both compose the
pin-status word as

	pins_status = read_buf[0] + (read_buf[1] << 8);

right after i2c_smbus_read_block_data(), guarding only against an
error return.  A well-behaved device returns 2 bytes for
GPIO_STATUS/PDIO_STATUS, but the helper happily reports a 0- or
1-byte response too.  If the device returns 0 bytes, both read_buf
slots are uninitialized stack memory; if it returns 1 byte, read_buf[1]
is.

The composed value then flows through set_bit() into the caller's
*bits in adm1266_gpio_get_multiple(), or into the return value of
adm1266_gpio_get(), and ends up in userspace via gpiolib (sysfs and
the char-dev ioctls).  That leaks a few bits of kernel stack per
request on any device whose firmware glitch, bus error, or hostile
slave produces a short block-read response.

Add the missing length check to both call sites and surface a short
response as -EIO.

Fixes: d98dfad35c38 ("hwmon: (pmbus/adm1266) Add support for GPIOs")
Cc: stable@vger.kernel.org
Signed-off-by: Abdurrahman Hussain <abdurrahman@nexthop.ai>
Reviewed-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260518-adm1266-gpio-fixes-v3-3-e425e4f88139@nexthop.ai
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/pmbus/adm1266.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/hwmon/pmbus/adm1266.c
+++ b/drivers/hwmon/pmbus/adm1266.c
@@ -176,6 +176,8 @@ static int adm1266_gpio_get(struct gpio_
 	ret = i2c_smbus_read_block_data(data->client, pmbus_cmd, read_buf);
 	if (ret < 0)
 		return ret;
+	if (ret < 2)
+		return -EIO;
 
 	pins_status = read_buf[0] + (read_buf[1] << 8);
 	if (offset < ADM1266_GPIO_NR)
@@ -196,6 +198,8 @@ static int adm1266_gpio_get_multiple(str
 	ret = i2c_smbus_read_block_data(data->client, ADM1266_GPIO_STATUS, read_buf);
 	if (ret < 0)
 		return ret;
+	if (ret < 2)
+		return -EIO;
 
 	status = read_buf[0] + (read_buf[1] << 8);
 
@@ -208,6 +212,8 @@ static int adm1266_gpio_get_multiple(str
 	ret = i2c_smbus_read_block_data(data->client, ADM1266_PDIO_STATUS, read_buf);
 	if (ret < 0)
 		return ret;
+	if (ret < 2)
+		return -EIO;
 
 	status = read_buf[0] + (read_buf[1] << 8);
 


