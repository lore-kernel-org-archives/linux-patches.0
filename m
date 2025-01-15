Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A26E71E98E6;
	Wed, 15 Jan 2025 10:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938737; cv=none; b=uSv8xV1Jf8P7vE10hxOjJ6h+4U/5aeIxyTBywJM/sEUKsFNIWKAYz7LfKa+eUgaIpYpctxb0g38af1YlQgWlnnRBY7MdgBvYy63EbP/0V/BWpzZTR07SL+f19jwq63VMlT96p8JlRQ1ecgMTcv/txy+hexoIfz/OzmS6WXrVTiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938737; c=relaxed/simple;
	bh=mqFW0Z5EYA6yX36df4gCeQ33SGQF4MAIp35TmgYtzTA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tzpqYRygaT8yywUtr2KsXjq51p+IrGxPPr16f0T/j7Pye6EexKKEMUMr80KIGVoQ0iGfcgad5bhmDcBOxQ+Ok5urB6xTs5ejocSpFMnfsRgkV8mJc8zQQEAvAtJWp9Ta8eF1933bmTJdHi2Q3d7rELUOc6W6kqnKUPYKRzP0NeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LI4nsdJm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LI4nsdJm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29BA3C4CEE4;
	Wed, 15 Jan 2025 10:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938737;
	bh=mqFW0Z5EYA6yX36df4gCeQ33SGQF4MAIp35TmgYtzTA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LI4nsdJms/PKA7+iFOrRB06fM7GFGNiOzT07RmdBaCpSb9NFyjXfdxYc3AWyhvaAM
	 y+CkaOBejOZa9zAGDIv6la/scj3jcu1GqAlzibHmF4jiEoopqQXL5ImlpY9s0kvwHQ
	 sSepRQBJgpsxxlVdRl2nx+aeON2lHKUbpArGJpGI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.6 041/129] iio: imu: inv_icm42600: fix timestamps after suspend if sensor is on
Date: Wed, 15 Jan 2025 11:36:56 +0100
Message-ID: <20250115103556.012875347@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103554.357917208@linuxfoundation.org>
References: <20250115103554.357917208@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>

commit 65a60a590142c54a3f3be11ff162db2d5b0e1e06 upstream.

Currently suspending while sensors are one will result in timestamping
continuing without gap at resume. It can work with monotonic clock but
not with other clocks. Fix that by resetting timestamping.

Fixes: ec74ae9fd37c ("iio: imu: inv_icm42600: add accurate timestamping")
Cc: stable@vger.kernel.org
Signed-off-by: Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>
Link: https://patch.msgid.link/20241113-inv_icm42600-fix-timestamps-after-suspend-v1-1-dfc77c394173@tdk.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/imu/inv_icm42600/inv_icm42600_core.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/iio/imu/inv_icm42600/inv_icm42600_core.c
+++ b/drivers/iio/imu/inv_icm42600/inv_icm42600_core.c
@@ -17,6 +17,7 @@
 #include <linux/regmap.h>
 
 #include <linux/iio/iio.h>
+#include <linux/iio/common/inv_sensors_timestamp.h>
 
 #include "inv_icm42600.h"
 #include "inv_icm42600_buffer.h"
@@ -725,6 +726,8 @@ out_unlock:
 static int inv_icm42600_resume(struct device *dev)
 {
 	struct inv_icm42600_state *st = dev_get_drvdata(dev);
+	struct inv_sensors_timestamp *gyro_ts = iio_priv(st->indio_gyro);
+	struct inv_sensors_timestamp *accel_ts = iio_priv(st->indio_accel);
 	int ret;
 
 	mutex_lock(&st->lock);
@@ -745,9 +748,12 @@ static int inv_icm42600_resume(struct de
 		goto out_unlock;
 
 	/* restore FIFO data streaming */
-	if (st->fifo.on)
+	if (st->fifo.on) {
+		inv_sensors_timestamp_reset(gyro_ts);
+		inv_sensors_timestamp_reset(accel_ts);
 		ret = regmap_write(st->map, INV_ICM42600_REG_FIFO_CONFIG,
 				   INV_ICM42600_FIFO_CONFIG_STREAM);
+	}
 
 out_unlock:
 	mutex_unlock(&st->lock);


