Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D544A3AA1BA;
	Tue, 16 Jun 2026 17:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781632705; cv=none; b=rtQZbK91tOpY8w9Y8VJcJC3HZxZqz+j77fvVZxHQCLpPiFQG9c4qAaZuL79tfU0w7/bTDDThKiYhMh9z2frcCbdopEGt4fPGiv1ZDaH+YOsbFoKwAZ7i7nmtsYdgzeg0u+MbjguerxsrM75QrDQKxTKIgStxflbxFSLCPXbJad4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781632705; c=relaxed/simple;
	bh=E628LGQghnQD/eVos0yMstz/QdhJzuBuRBsh39M+Spw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iatASqfZEvXnt3JWxhbjYIekikEPLPGrCleFIdQIcrhvjGFIq9WL53Yyv1uWyA8IoDZ0Ceas1JOPbTiJTwUEkAOmmDlu6qKTYVV4TeDo3C3apnj80oGN7J/+693XxyFXvmJJogJ3287hU9gsHEi/7pnnzH9+NNCTg74zVVCMU7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x5F/FpTO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x5F/FpTO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D51351F000E9;
	Tue, 16 Jun 2026 17:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781632704;
	bh=EDz5kPl+a0UihrdqFVWvuAVqblGQov6o6oQE0B0b1M0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x5F/FpTOSPXCAFE63YfCz17dwpB6HcybpwSs6J4ba+CYDgAWVOjI8//aWwDU4/6nX
	 WhiF0sr/ac3/8MHplA5e8EKnS0eNOP8JcZUQJWARIi1lw6O+e8ayVC+6pt2tYICGHS
	 cprchA5kPDraTqXIxgDwW1ld8DHblBDtQbPoxBlw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Tomasz Duszynski <tomasz.duszynski@octakon.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 461/522] iio: chemical: scd30: Use guard(mutex) to allow early returns
Date: Tue, 16 Jun 2026 20:30:08 +0530
Message-ID: <20260616145147.456064859@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Cameron <Jonathan.Cameron@huawei.com>

[ Upstream commit 5feb5532870fbced5d6f450b8061a33f461b88ca ]

Auto cleanup based release of the lock allows for simpler code flow in a
few functions with large multiplexing style switch statements and no
common operations following the switch.

Suggested-by: David Lechner <dlechner@baylibre.com>
Cc: Tomasz Duszynski <tomasz.duszynski@octakon.com>
Reviewed-by: David Lechner <dlechner@baylibre.com>
Link: https://patch.msgid.link/20250209180624.701140-3-jic23@kernel.org
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Stable-dep-of: 5aba4f94b225 ("iio: chemical: scd30: fix division by zero in write_raw")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/chemical/scd30_core.c |   63 ++++++++++++++++----------------------
 1 file changed, 28 insertions(+), 35 deletions(-)

--- a/drivers/iio/chemical/scd30_core.c
+++ b/drivers/iio/chemical/scd30_core.c
@@ -5,6 +5,7 @@
  * Copyright (c) 2020 Tomasz Duszynski <tomasz.duszynski@octakon.com>
  */
 #include <linux/bits.h>
+#include <linux/cleanup.h>
 #include <linux/completion.h>
 #include <linux/delay.h>
 #include <linux/device.h>
@@ -198,112 +199,104 @@ static int scd30_read_raw(struct iio_dev
 			  int *val, int *val2, long mask)
 {
 	struct scd30_state *state = iio_priv(indio_dev);
-	int ret = -EINVAL;
+	int ret;
 	u16 tmp;
 
-	mutex_lock(&state->lock);
+	guard(mutex)(&state->lock);
 	switch (mask) {
 	case IIO_CHAN_INFO_RAW:
 	case IIO_CHAN_INFO_PROCESSED:
 		if (chan->output) {
 			*val = state->pressure_comp;
-			ret = IIO_VAL_INT;
-			break;
+			return IIO_VAL_INT;
 		}
 
 		ret = iio_device_claim_direct_mode(indio_dev);
 		if (ret)
-			break;
+			return ret;
 
 		ret = scd30_read(state);
 		if (ret) {
 			iio_device_release_direct_mode(indio_dev);
-			break;
+			return ret;
 		}
 
 		*val = state->meas[chan->address];
 		iio_device_release_direct_mode(indio_dev);
-		ret = IIO_VAL_INT;
-		break;
+		return IIO_VAL_INT;
 	case IIO_CHAN_INFO_SCALE:
 		*val = 0;
 		*val2 = 1;
-		ret = IIO_VAL_INT_PLUS_MICRO;
-		break;
+		return IIO_VAL_INT_PLUS_MICRO;
 	case IIO_CHAN_INFO_SAMP_FREQ:
 		ret = scd30_command_read(state, CMD_MEAS_INTERVAL, &tmp);
 		if (ret)
-			break;
+			return ret;
 
 		*val = 0;
 		*val2 = 1000000000 / tmp;
-		ret = IIO_VAL_INT_PLUS_NANO;
-		break;
+		return IIO_VAL_INT_PLUS_NANO;
 	case IIO_CHAN_INFO_CALIBBIAS:
 		ret = scd30_command_read(state, CMD_TEMP_OFFSET, &tmp);
 		if (ret)
-			break;
+			return ret;
 
 		*val = tmp;
-		ret = IIO_VAL_INT;
-		break;
+		return IIO_VAL_INT;
+	default:
+		return -EINVAL;
 	}
-	mutex_unlock(&state->lock);
-
-	return ret;
 }
 
 static int scd30_write_raw(struct iio_dev *indio_dev, struct iio_chan_spec const *chan,
 			   int val, int val2, long mask)
 {
 	struct scd30_state *state = iio_priv(indio_dev);
-	int ret = -EINVAL;
+	int ret;
 
-	mutex_lock(&state->lock);
+	guard(mutex)(&state->lock);
 	switch (mask) {
 	case IIO_CHAN_INFO_SAMP_FREQ:
 		if (val)
-			break;
+			return -EINVAL;
 
 		val = 1000000000 / val2;
 		if (val < SCD30_MEAS_INTERVAL_MIN_S || val > SCD30_MEAS_INTERVAL_MAX_S)
-			break;
+			return -EINVAL;
 
 		ret = scd30_command_write(state, CMD_MEAS_INTERVAL, val);
 		if (ret)
-			break;
+			return ret;
 
 		state->meas_interval = val;
-		break;
+		return 0;
 	case IIO_CHAN_INFO_RAW:
 		switch (chan->type) {
 		case IIO_PRESSURE:
 			if (val < SCD30_PRESSURE_COMP_MIN_MBAR ||
 			    val > SCD30_PRESSURE_COMP_MAX_MBAR)
-				break;
+				return -EINVAL;
 
 			ret = scd30_command_write(state, CMD_START_MEAS, val);
 			if (ret)
-				break;
+				return ret;
 
 			state->pressure_comp = val;
-			break;
+			return 0;
 		default:
-			break;
+			return -EINVAL;
 		}
-		break;
 	case IIO_CHAN_INFO_CALIBBIAS:
 		if (val < 0 || val > SCD30_TEMP_OFFSET_MAX)
-			break;
+			return -EINVAL;
 		/*
 		 * Manufacturer does not explicitly specify min/max sensible
 		 * values hence check is omitted for simplicity.
 		 */
-		ret = scd30_command_write(state, CMD_TEMP_OFFSET / 10, val);
+		return scd30_command_write(state, CMD_TEMP_OFFSET / 10, val);
+	default:
+		return -EINVAL;
 	}
-	mutex_unlock(&state->lock);
-
-	return ret;
 }
 
 static int scd30_write_raw_get_fmt(struct iio_dev *indio_dev, struct iio_chan_spec const *chan,


