Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0184849659;
	Mon, 14 Oct 2024 15:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728919386; cv=none; b=U2dsX/y2Xn2AqJgeMDI2YqjAkhyD+Hh0PL27jxpBmTVJs05rUmSWv8198txhB42IFjlL6Br8Fa3tO4TqxaiP4tw6aRoGP26jmk1ohPO8TRyZEovHJn6Iwj7rQgdttHTcmw/ZMJ9VgAOeCpgSY5N0qTCSMldF+m++aqhJ48SgQXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728919386; c=relaxed/simple;
	bh=XelvvyGMpBt/9P7agpwmQvArXPzr7ov02ZD7a3NzHC8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GIwkPxl85kPUVFyKAL738bv1GJhZ8Y/5QvPhISCaghYIs3cZT2qAjf+aisSnlR3iEfXFFGDmaj8dBb0x4FBU5yU2iMwBuLf5M5Y2uytdeARmIEEd5Z1qJci5IQ6KKMhRwHHTxQmXzWg2R6u8XiVNNgEJJVbUpRJDoIrZppnQDEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I1SHk4/C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I1SHk4/C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 667DDC4CEC3;
	Mon, 14 Oct 2024 15:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728919385;
	bh=XelvvyGMpBt/9P7agpwmQvArXPzr7ov02ZD7a3NzHC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I1SHk4/CxcssprPQxn+QQVb8R/vyl9wL7TDuKv4BxxJQPiqdAzLKHccuTgCvZ8dgC
	 a0gBboTEsM/AoXd+O5lh4pORXraYOq4EGW5WFVLNchc0gh78Nl4znf/MB29hBXM1Xn
	 tbJ/EvWTEbvO9j7Jz3GVDrThWcP5L+netUf+XFm0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Barnab=C3=A1s=20Cz=C3=A9m=C3=A1n?= <barnabas.czeman@mainlining.org>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.1 594/798] iio: magnetometer: ak8975: Fix reading for ak099xx sensors
Date: Mon, 14 Oct 2024 16:19:08 +0200
Message-ID: <20241014141241.340930790@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -692,22 +692,8 @@ static int ak8975_start_read_axis(struct
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
@@ -734,6 +720,20 @@ static int ak8975_read_axis(struct iio_d
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


