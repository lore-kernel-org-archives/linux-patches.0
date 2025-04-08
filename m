Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DEDF268FF1;
	Tue,  8 Apr 2025 11:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113417; cv=none; b=hrS8620+DbWCNEtvvQI+8gDx13HtOJ+JIqXi/HNdxrWREPoFENXiRlp6mEdMrPMjWa2CIPXvqLA8wP0hm3R+x4HJ4S9ru3FPbULlq4IqYThqLtcUYeV5BEQepPikKGbxbWk4FSzIIn52zRCDFFwHvvjlhTvf/VY5pDpweHeS6v4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113417; c=relaxed/simple;
	bh=dG3mLK6r/aPABl8+ArgVBmV7zLlkblInUXcqRutkk/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EYArJmIYR8lEFVjzisqCjVoPz6+mIb/DQ4d73a5mSAne3DmqSpgpOVonOjhBt1GNogZd4MqukOi1TRNkJySzOVe627bT3LHOicN86np8iHFKqqCtDIj9D1hQBh9mB8yvjkHqff8SB82HWaLB8wG1SAso5fKiTnKt8LtZDCnO8LA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zKh9zY6j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zKh9zY6j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A830AC4CEE5;
	Tue,  8 Apr 2025 11:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113417;
	bh=dG3mLK6r/aPABl8+ArgVBmV7zLlkblInUXcqRutkk/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zKh9zY6jeslU/iOkp00+2mpSzeuadkY5UEj1HdoT3N6UXAH27DQQVryE5laZwQHNn
	 fFllIRBszls5ucl1SnGS+z2GwfWcRCAgAsBMc4hphHZDNIlpsLNGOAswCTL7TUz9pM
	 TroBdL3dkb2+RLf4NJt7zwGkRWIsBpiSQESXFQqc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 112/268] iio: accel: msa311: Fix failure to release runtime pm if direct mode claim fails.
Date: Tue,  8 Apr 2025 12:48:43 +0200
Message-ID: <20250408104831.521586595@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
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
index 6ddcc3c2f8409..5927df633e1f9 100644
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



