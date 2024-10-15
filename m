Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D26E91C57B1;
	Tue, 15 Oct 2024 12:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993842; cv=none; b=rBdPyT6mGZC5fxu/1193XA7kxKp2X3s0TMnZyiKYWKzfa0dGjo3Pz76uCCA6dkGubJyUQQ40WuLwXapYUgwHOUH9BxXUvHDGN+pYvHd9XflZZK/Ph3QU/s++bcdo6TIKhGZd6hJ3yX0E8AjpPFIN5AHJv7RMRAOFglMfa+kmqJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993842; c=relaxed/simple;
	bh=yG+Odjbv+m5ancare8By7nzGci5BiDnbhqwCPRn9ec4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ADbWNLvVeUBPsBrLfzEgV1OTz7eH6Rs7W6hCkaCQ8HvGkPDf8hIh/oPIYqcTr5dGvZEBM36rPPXuQmxTs23F2yUKae4CLpZnf+/3RaXstoU8cLMqXjStj07B+zZmG8TWvt38ODcMZW1eWdjdPvPgItFm+ESHumnKOBSES0aEQ/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=etqXF9xg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="etqXF9xg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56352C4CEC6;
	Tue, 15 Oct 2024 12:04:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993842;
	bh=yG+Odjbv+m5ancare8By7nzGci5BiDnbhqwCPRn9ec4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=etqXF9xgxXAY3tR/5zrSSIzAQ8RzxbVuM0mLnXzpOJmQCkF3Fu85kQcBYHyOlpZO7
	 Dp8ErzhSq7FOfx4TMiSZBxxP81/HeL2vn1r+fuMUic5Rd36R81VUIaCykHteN7neyT
	 zbJzqI3MoWRuotdoFJxp3uYxaPxOrrXxN3kiLtA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Barnab=C3=A1s=20Cz=C3=A9m=C3=A1n?= <barnabas.czeman@mainlining.org>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.15 533/691] iio: magnetometer: ak8975: Fix reading for ak099xx sensors
Date: Tue, 15 Oct 2024 13:28:01 +0200
Message-ID: <20241015112501.496159774@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Barnabás Czémán <barnabas.czeman@mainlining.org>

commit 129464e86c7445a858b790ac2d28d35f58256bbe upstream.

Move ST2 reading with overflow handling after measurement data
reading.
ST2 register read have to be read after read measurment data,
because it means end of the reading and realease the lock on the data.
Remove ST2 read skip on interrupt based waiting because ST2 required to
be read out at and of the axis read.

Fixes: 57e73a423b1e ("iio: ak8975: add ak09911 and ak09912 support")
Signed-off-by: Barnabás Czémán <barnabas.czeman@mainlining.org>
Link: https://patch.msgid.link/20240819-ak09918-v4-2-f0734d14cfb9@mainlining.org
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/magnetometer/ak8975.c |   32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

--- a/drivers/iio/magnetometer/ak8975.c
+++ b/drivers/iio/magnetometer/ak8975.c
@@ -661,22 +661,8 @@ static int ak8975_start_read_axis(struct
 	if (ret < 0)
 		return ret;
 
-	/* This will be executed only for non-interrupt based waiting case */
-	if (ret & data->def->ctrl_masks[ST1_DRDY]) {
-		ret = i2c_smbus_read_byte_data(client,
-					       data->def->ctrl_regs[ST2]);
-		if (ret < 0) {
-			dev_err(&client->dev, "Error in reading ST2\n");
-			return ret;
-		}
-		if (ret & (data->def->ctrl_masks[ST2_DERR] |
-			   data->def->ctrl_masks[ST2_HOFL])) {
-			dev_err(&client->dev, "ST2 status error 0x%x\n", ret);
-			return -EINVAL;
-		}
-	}
-
-	return 0;
+	/* Return with zero if the data is ready. */
+	return !data->def->ctrl_regs[ST1_DRDY];
 }
 
 /* Retrieve raw flux value for one of the x, y, or z axis.  */
@@ -703,6 +689,20 @@ static int ak8975_read_axis(struct iio_d
 	if (ret < 0)
 		goto exit;
 
+	/* Read out ST2 for release lock on measurment data. */
+	ret = i2c_smbus_read_byte_data(client, data->def->ctrl_regs[ST2]);
+	if (ret < 0) {
+		dev_err(&client->dev, "Error in reading ST2\n");
+		goto exit;
+	}
+
+	if (ret & (data->def->ctrl_masks[ST2_DERR] |
+		   data->def->ctrl_masks[ST2_HOFL])) {
+		dev_err(&client->dev, "ST2 status error 0x%x\n", ret);
+		ret = -EINVAL;
+		goto exit;
+	}
+
 	mutex_unlock(&data->lock);
 
 	pm_runtime_mark_last_busy(&data->client->dev);


