Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93BC72F7F00;
	Tue, 13 Oct 2026 12:47:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895630; cv=none; b=ZodmUk/IQ2f7BTwGIb1idbaac6ZSFMwSEbgZyQzMpuoHrk3Jtw3Ew5qv3PXwpTF3OviKtu+7/XwYpWzHEiBhgOJ6JJ7d9ZIE+5dwNyS914J8UlRpISIGBDRDYHiZgn3CD9prrNY7/ESj/l124Jde3q8Gwt+7jOqi4ltEbiDbM20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895630; c=relaxed/simple;
	bh=0l/iaYJzZnlZpAMVdUhrJ15A4FzzA+/FtyCHhHlT20E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dUqxdAQE4kkWMwAtQ9fZrpTlhyX08P0eh2Txl7jphH5msRCAXBJA5IxIkPr0m6P56u46VOqrmA/4DNxUFJFSk5BtlcilhlWKmtVDJ00o+pK5utHYmwNYWppzqkJx0wAOzomtfcdCJcqRX04E+BGGqcB5eiiuaR53cTqj+GyAR0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wp159+8K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wp159+8K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 939C31F000FF;
	Tue, 13 Oct 2026 12:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895629;
	bh=2zmIrt7F20gppHbBKczuDiv/5U+tdm9/0TlHxKIEiEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wp159+8Kp4GPdGp+PD9NNafnMYTLQudpuyU45Uf8SQEhejlKJZ7bw7rHY1aeDhXIc
	 3GK2adiRO5M/J/DZslq23xZb/91exSYKeUFVNqzYAap870uNHYdNNxDlTTnJoTmVwU
	 ZS4W6o1xWHHRRNQgECzUGORIn/5kKjfhcCvGL3Xs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Cameron <jic23@kernel.org>,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 339/497] iio: light: rohm-bu27034: Fix infinite delay on error
Date: Tue, 13 Oct 2026 13:38:26 +0200
Message-ID: <20261013112915.950364102@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matti Vaittinen <mazziesaccount@gmail.com>

[ Upstream commit 8065a6c02f629187131f3136bedb26f9080e3cca ]

When reading an integration-time fails, the code will use error code to
compute the sleep time.

Fix this by using the smallest integration time as a default if
reading fails.

Fixes: e52afbd61039 ("iio: light: ROHM BU27034 Ambient Light Sensor")
Suggested-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Matti Vaittinen <mazziesaccount@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/light/rohm-bu27034.c | 60 +++++++++++++++++++-------------
 1 file changed, 36 insertions(+), 24 deletions(-)

diff --git a/drivers/iio/light/rohm-bu27034.c b/drivers/iio/light/rohm-bu27034.c
index be3895a9da70c..439815c3c15dd 100644
--- a/drivers/iio/light/rohm-bu27034.c
+++ b/drivers/iio/light/rohm-bu27034.c
@@ -137,6 +137,7 @@ static const struct iio_gain_sel_pair bu27034_gains[] = {
 #define BU27034_MEAS_MODE_200MS		2
 #define BU27034_MEAS_MODE_400MS		4
 
+#define BU27034_INT_TIME_US_MIN (55 * USEC_PER_MSEC)
 static const struct iio_itime_sel_mul bu27034_itimes[] = {
 	GAIN_SCALE_ITIME_US(400000, BU27034_MEAS_MODE_400MS, 8),
 	GAIN_SCALE_ITIME_US(200000, BU27034_MEAS_MODE_200MS, 4),
@@ -296,7 +297,7 @@ static int bu27034_get_gain(struct bu27034_data *data, int chan, int *gain)
 	return 0;
 }
 
-static int bu27034_get_int_time(struct bu27034_data *data)
+static int bu27034_get_int_time(struct bu27034_data *data, int *itime)
 {
 	int ret, sel;
 
@@ -304,24 +305,30 @@ static int bu27034_get_int_time(struct bu27034_data *data)
 	if (ret)
 		return ret;
 
-	return iio_gts_find_int_time_by_sel(&data->gts,
-					    sel & BU27034_MASK_MEAS_MODE);
+	ret = iio_gts_find_int_time_by_sel(&data->gts,
+					   sel & BU27034_MASK_MEAS_MODE);
+	if (ret < 0)
+		return ret;
+
+	*itime = ret;
+
+	return 0;
 }
 
 static int _bu27034_get_scale(struct bu27034_data *data, int channel, int *val,
 			      int *val2)
 {
-	int gain, ret;
+	int gain, itime, ret;
 
 	ret = bu27034_get_gain(data, channel, &gain);
 	if (ret)
 		return ret;
 
-	ret = bu27034_get_int_time(data);
-	if (ret < 0)
+	ret = bu27034_get_int_time(data, &itime);
+	if (ret)
 		return ret;
 
-	return iio_gts_get_scale(&data->gts, gain, ret, val, val2);
+	return iio_gts_get_scale(&data->gts, gain, itime, val, val2);
 }
 
 static int bu27034_get_scale(struct bu27034_data *data, int channel, int *val,
@@ -397,12 +404,10 @@ static int bu27034_try_set_int_time(struct bu27034_data *data, int time_us)
 	int ret, int_time_old, i;
 
 	guard(mutex)(&data->mutex);
-	ret = bu27034_get_int_time(data);
-	if (ret < 0)
+	ret = bu27034_get_int_time(data, &int_time_old);
+	if (ret)
 		return ret;
 
-	int_time_old = ret;
-
 	if (!iio_gts_valid_time(&data->gts, time_us)) {
 		dev_err(data->dev, "Unsupported integration time %u\n",
 			time_us);
@@ -841,7 +846,7 @@ static int bu27034_meas_set(struct bu27034_data *data, bool en)
 static int bu27034_get_single_result(struct bu27034_data *data, int chan,
 				     int *val)
 {
-	int ret;
+	int ret, itime;
 
 	if (chan < BU27034_CHAN_DATA0 || chan > BU27034_CHAN_DATA1)
 		return -EINVAL;
@@ -850,11 +855,11 @@ static int bu27034_get_single_result(struct bu27034_data *data, int chan,
 	if (ret)
 		return ret;
 
-	ret = bu27034_get_int_time(data);
-	if (ret < 0)
+	ret = bu27034_get_int_time(data, &itime);
+	if (ret)
 		return ret;
 
-	msleep(ret / 1000);
+	msleep(itime / 1000);
 
 	return bu27034_read_result(data, chan, val);
 }
@@ -904,12 +909,10 @@ static int bu27034_calc_mlux(struct bu27034_data *data, __le16 *res, int *val)
 	if (ret)
 		return ret;
 
-	ret = bu27034_get_int_time(data);
-	if (ret < 0)
+	ret = bu27034_get_int_time(data, &meastime);
+	if (ret)
 		return ret;
 
-	meastime = ret;
-
 	d1_d0_ratio_scaled = (unsigned int)ch1 * (unsigned int)gain0 * 100;
 	helper64 = (u64)ch1 * (u64)gain0 * 100LLU;
 
@@ -970,9 +973,9 @@ static int bu27034_read_raw(struct iio_dev *idev,
 	switch (mask) {
 	case IIO_CHAN_INFO_INT_TIME:
 		*val = 0;
-		*val2 = bu27034_get_int_time(data);
-		if (*val2 < 0)
-			return *val2;
+		ret = bu27034_get_int_time(data, val2);
+		if (ret)
+			return ret;
 
 		return IIO_VAL_INT_PLUS_MICRO;
 
@@ -1159,11 +1162,20 @@ static int bu27034_buffer_thread(void *arg)
 {
 	struct iio_dev *idev = arg;
 	struct bu27034_data *data;
-	int wait_ms;
+	int wait_ms, ret;
 
 	data = iio_priv(idev);
 
-	wait_ms = bu27034_get_int_time(data);
+	/*
+	 * If reading the integration time fails, default to the minimum so we
+	 * don't lose samples. This may waste CPU cycles, but as a hardening
+	 * against theoretical, once-in-a-blue-moon error, this should be Ok.
+	 */
+	wait_ms = BU27034_INT_TIME_US_MIN;
+	ret = bu27034_get_int_time(data, &wait_ms);
+	if (ret)
+		dev_warn(data->dev, "Failed to get integration time\n");
+
 	wait_ms /= 1000;
 
 	wait_ms -= BU27034_MEAS_WAIT_PREMATURE_MS;
-- 
2.53.0



