Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B25D26A09F;
	Tue,  8 Apr 2025 12:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116650; cv=none; b=cULYrnz4jzERmIo2k4KLfgwWZZnOjZcTZHwFHkipSKAYMLth2lyDT/CJ+VKZ23hY/fHtq1zsNuQ+UL+8wP0wfFBgUoEDj8ehirQ1/Ekf935QgLUxVbcIZA04A5xlilfs/pVUGi0y5FE8lgk52k13LqYhno+ny3M03j8BVAmqTpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116650; c=relaxed/simple;
	bh=tTzGgPfkedKB5Uv5AsmNkaIV4PqwKKAQS9UaHgAHuik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UxKHRuG7oD84mcMLTzsPs/wagxFvOLf83nrablfN07XO9V29RiRng91iyTgads4xA5i/CyrN49r71AjHHnqgjqiQr5baE595xVGcv4WpoepXVuYI+c+HYUqBEe9SrecMCkLrabsrUtDZGMn0ciCkNnoG/05/xxH/ZOBikqRBwBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RzWUTsJf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RzWUTsJf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0DF4C4CEE5;
	Tue,  8 Apr 2025 12:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116650;
	bh=tTzGgPfkedKB5Uv5AsmNkaIV4PqwKKAQS9UaHgAHuik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RzWUTsJfOMLZTsLHHM2OsSs6G37qVVX0PAB1qDd5rlRd6FcRRa1qhBCE+IikwM2tc
	 zLAUPYx9Khbea/1QEd3HFMl8OtLgwjK4xeMqtbttaYwmvOxU30GAcXJxmCIvWxDHa1
	 WqpF/agKZBM7BT4Pgei4RhT+gq9G0j6j8LSTS5VI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 179/423] iio: accel: msa311: Fix failure to release runtime pm if direct mode claim fails.
Date: Tue,  8 Apr 2025 12:48:25 +0200
Message-ID: <20250408104849.911796697@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

[ Upstream commit 60a0cf2ebab92011055ab7db6553c0fc3c546938 ]

Reorder the claiming of direct mode and runtime pm calls to simplify
handling a little.  For correct error handling, after the reorder
iio_device_release_direct_mode() must be claimed in an error occurs
in pm_runtime_resume_and_get()

Fixes: 1ca2cfbc0c33 ("iio: add MEMSensing MSA311 3-axis accelerometer driver")
Reviewed-by: David Lechner <dlechner@baylibre.com>
Link: https://patch.msgid.link/20250217140135.896574-7-jic23@kernel.org
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/accel/msa311.c | 26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

diff --git a/drivers/iio/accel/msa311.c b/drivers/iio/accel/msa311.c
index 57025354c7cd5..f484be27058d9 100644
--- a/drivers/iio/accel/msa311.c
+++ b/drivers/iio/accel/msa311.c
@@ -593,23 +593,25 @@ static int msa311_read_raw_data(struct iio_dev *indio_dev,
 	__le16 axis;
 	int err;
 
-	err = pm_runtime_resume_and_get(dev);
+	err = iio_device_claim_direct_mode(indio_dev);
 	if (err)
 		return err;
 
-	err = iio_device_claim_direct_mode(indio_dev);
-	if (err)
+	err = pm_runtime_resume_and_get(dev);
+	if (err) {
+		iio_device_release_direct_mode(indio_dev);
 		return err;
+	}
 
 	mutex_lock(&msa311->lock);
 	err = msa311_get_axis(msa311, chan, &axis);
 	mutex_unlock(&msa311->lock);
 
-	iio_device_release_direct_mode(indio_dev);
-
 	pm_runtime_mark_last_busy(dev);
 	pm_runtime_put_autosuspend(dev);
 
+	iio_device_release_direct_mode(indio_dev);
+
 	if (err) {
 		dev_err(dev, "can't get axis %s (%pe)\n",
 			chan->datasheet_name, ERR_PTR(err));
@@ -755,10 +757,6 @@ static int msa311_write_samp_freq(struct iio_dev *indio_dev, int val, int val2)
 	unsigned int odr;
 	int err;
 
-	err = pm_runtime_resume_and_get(dev);
-	if (err)
-		return err;
-
 	/*
 	 * Sampling frequency changing is prohibited when buffer mode is
 	 * enabled, because sometimes MSA311 chip returns outliers during
@@ -768,6 +766,12 @@ static int msa311_write_samp_freq(struct iio_dev *indio_dev, int val, int val2)
 	if (err)
 		return err;
 
+	err = pm_runtime_resume_and_get(dev);
+	if (err) {
+		iio_device_release_direct_mode(indio_dev);
+		return err;
+	}
+
 	err = -EINVAL;
 	for (odr = 0; odr < ARRAY_SIZE(msa311_odr_table); odr++)
 		if (val == msa311_odr_table[odr].integral &&
@@ -778,11 +782,11 @@ static int msa311_write_samp_freq(struct iio_dev *indio_dev, int val, int val2)
 			break;
 		}
 
-	iio_device_release_direct_mode(indio_dev);
-
 	pm_runtime_mark_last_busy(dev);
 	pm_runtime_put_autosuspend(dev);
 
+	iio_device_release_direct_mode(indio_dev);
+
 	if (err)
 		dev_err(dev, "can't update frequency (%pe)\n", ERR_PTR(err));
 
-- 
2.39.5



