Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50F011CA8F;
	Mon,  1 Apr 2024 16:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988768; cv=none; b=Y1EwSl0JFYMSGA6KYs9BuKZb0h/7vc+Io7gsy1KGTS8rU2UyzWU73StQVhufCHpuzGSnVMHdkJ5J7fnVdhT5W4HzbxfzG8nkwhYr/8suuxMNYrcfTpe31NULhTxXCIn2g8CObb0DhFl/Y+tQdUfjvIFcyk6MDhUnYhOpFAdw3Fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988768; c=relaxed/simple;
	bh=XXgdSpDoWhEFKeSLmM/1QIU/4CeCBzWVDUxWWo4BcCg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LpR5fXkD5YMhz7TzfmPtbW6Ctq22rxWulxogzaWNBXTV0IVKq9Pum80Vregec7KfRd7PFSu+gB4YFMpNROs5/kJuJnRDeKHZrq+hjzNHMyaSeH1oUyAc5tv7xSrgRAy1i0cWxX8W/tQhFKhp2Gtr8I4yz7hnVLPS2Lqx1IX6LkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=egZdm3xd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="egZdm3xd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B17AAC433C7;
	Mon,  1 Apr 2024 16:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988768;
	bh=XXgdSpDoWhEFKeSLmM/1QIU/4CeCBzWVDUxWWo4BcCg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=egZdm3xdbis0vwIH4L/Q3DbPtDqgsyHA49dJ7X14nsFSRX4MnvWb97JOHeCSdC6iV
	 XSm74rEeIPzWIJC7IbXPy4jZAJRR9G0xYNJk6VGLQ/Jqwir3tzARTbRgnj7/uVkRCd
	 DnHeOwjJiPeflV+C6herEwcF6RwbB+yYxqRw+FkM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cosmin Tanislav <demonsingur@gmail.com>,
	Nuno Sa <nuno.sa@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.7 282/432] iio: accel: adxl367: fix DEVID read after reset
Date: Mon,  1 Apr 2024 17:44:29 +0200
Message-ID: <20240401152601.585434617@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cosmin Tanislav <demonsingur@gmail.com>

commit 1b926914bbe4e30cb32f268893ef7d82a85275b8 upstream.

regmap_read_poll_timeout() will not sleep before reading,
causing the first read to return -ENXIO on I2C, since the
chip does not respond to it while it is being reset.

The datasheet specifies that a soft reset operation has a
latency of 7.5ms.

Add a 15ms sleep between reset and reading the DEVID register,
and switch to a simple regmap_read() call.

Fixes: cbab791c5e2a ("iio: accel: add ADXL367 driver")
Signed-off-by: Cosmin Tanislav <demonsingur@gmail.com>
Reviewed-by: Nuno Sa <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20240207033657.206171-1-demonsingur@gmail.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/accel/adxl367.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/iio/accel/adxl367.c
+++ b/drivers/iio/accel/adxl367.c
@@ -1429,9 +1429,11 @@ static int adxl367_verify_devid(struct a
 	unsigned int val;
 	int ret;
 
-	ret = regmap_read_poll_timeout(st->regmap, ADXL367_REG_DEVID, val,
-				       val == ADXL367_DEVID_AD, 1000, 10000);
+	ret = regmap_read(st->regmap, ADXL367_REG_DEVID, &val);
 	if (ret)
+		return dev_err_probe(st->dev, ret, "Failed to read dev id\n");
+
+	if (val != ADXL367_DEVID_AD)
 		return dev_err_probe(st->dev, -ENODEV,
 				     "Invalid dev id 0x%02X, expected 0x%02X\n",
 				     val, ADXL367_DEVID_AD);
@@ -1510,6 +1512,8 @@ int adxl367_probe(struct device *dev, co
 	if (ret)
 		return ret;
 
+	fsleep(15000);
+
 	ret = adxl367_verify_devid(st);
 	if (ret)
 		return ret;


