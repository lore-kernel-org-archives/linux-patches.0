Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CAE03613C;
	Mon,  1 Apr 2024 16:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990110; cv=none; b=F5jCxSd8s8fwY5EMYeXjd7yxpaUyxYnHVT12vukdZltzviDhKC6QzbRm1b2mu++9P6FLD8zcDS7Kd1soSJk1pq8/N1inP0Xy0crP1Dtc24lo/IH5X0H6cyTVsIt+qeDWL8FkVSclo21OTYpdMyG+oaThb/Y5vG76xyv80x/seJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990110; c=relaxed/simple;
	bh=gWOdiABM0ZPlXsuQaWspwS5O5FfeJ81a0f3hG42LhqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f4hf1ruecJkJbVWaqt5yX6eWNoPK5YDeK6O8IihHbjf6A7l4rFQdMle5/mbUQn+A24gcuhWFB8zT7UZ6IHEEal/0PFrRC4TUF4S4REpIS7bz3PAp7fnACgsNbaClalRELWavp8AQt9k9YdUhJz2zwmWunfA54McMJO9JDhPHANo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jDi+/HKu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jDi+/HKu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6094C433F1;
	Mon,  1 Apr 2024 16:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990110;
	bh=gWOdiABM0ZPlXsuQaWspwS5O5FfeJ81a0f3hG42LhqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jDi+/HKui65hF4fpw508vhoPQbpG6VW+0MWQpuWQfzIqry6JYuRIKGZ7eRLqbVdUF
	 RgGEcQhMZmZz76yNDszogNWQI3Qd6bivF047p6lDol9rii369t6vKRdg+iT8GtI0ie
	 vPh3zj1dYFJGnQKdmu/iZYSe7Ex9L46/rclNK/jQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cosmin Tanislav <demonsingur@gmail.com>,
	Nuno Sa <nuno.sa@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.6 242/396] iio: accel: adxl367: fix DEVID read after reset
Date: Mon,  1 Apr 2024 17:44:51 +0200
Message-ID: <20240401152555.129118118@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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


