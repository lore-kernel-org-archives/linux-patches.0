Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 235B2269AE8;
	Tue,  8 Apr 2025 12:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115750; cv=none; b=jf9uKPydWAXUco9pOxGi0b3AGWShdkVTZLWVXUbkL54pMcxOCTHd4G39z1Ew0KnIEEnqjiNYxAbE5Y/uPpo8MVpFxu+e/7S9F+V4j4FQIPjDQRdeYXQuF3OjfFyK8tMy9KIRtKmrYYnembVz8qJcoJLnanPlI5yLZS/SVZBxvQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115750; c=relaxed/simple;
	bh=hzA0J1x6dfRyqc3/eUZQSGtdus2TxhaaLZWk826buys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WerbH+8TzcUT8Ux4DsPF04r/fgaIEBXzh9ldvzzvsWKfWg/GbvZNXszb06+hzPuLBylmtQXUrv7w2Aec9d/PGsCu1PjLZLOJ4Zh7B4pxlNMcjJDlvnAvIuNtTqT/hc+p0JAJQH/9cNLyjvWSdAtX0q49KRpa6yygKtJ4fbPcX14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mFhqHwI7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mFhqHwI7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D378C4CEE5;
	Tue,  8 Apr 2025 12:35:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115750;
	bh=hzA0J1x6dfRyqc3/eUZQSGtdus2TxhaaLZWk826buys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mFhqHwI78V76xSjO7Z3Y2HYsjvTauHgjvovXCoCid8aOBXh0+MKAO0GIzucS5YHBJ
	 BZTmsFDagIUZSEutCv8gpM2V0PEQLb21hgp3GtvVjlZXJ4dfDH374OVBBop19lzbIz
	 9pWCdklP6ogwKtIxf3AAvpkn/LikqoauOYW5HgJM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 091/204] iio: accel: msa311: Fix failure to release runtime pm if direct mode claim fails.
Date: Tue,  8 Apr 2025 12:50:21 +0200
Message-ID: <20250408104823.016632149@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.266892317@linuxfoundation.org>
References: <20250408104820.266892317@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 2fded37591717..9b5c36f2322f1 100644
--- a/drivers/iio/accel/msa311.c
+++ b/drivers/iio/accel/msa311.c
@@ -595,23 +595,25 @@ static int msa311_read_raw_data(struct iio_dev *indio_dev,
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
@@ -757,10 +759,6 @@ static int msa311_write_samp_freq(struct iio_dev *indio_dev, int val, int val2)
 	unsigned int odr;
 	int err;
 
-	err = pm_runtime_resume_and_get(dev);
-	if (err)
-		return err;
-
 	/*
 	 * Sampling frequency changing is prohibited when buffer mode is
 	 * enabled, because sometimes MSA311 chip returns outliers during
@@ -770,6 +768,12 @@ static int msa311_write_samp_freq(struct iio_dev *indio_dev, int val, int val2)
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
@@ -780,11 +784,11 @@ static int msa311_write_samp_freq(struct iio_dev *indio_dev, int val, int val2)
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



