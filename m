Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 454AC4F68B4;
	Tue, 13 Oct 2026 12:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895624; cv=none; b=mkuPYT+H3lEiPJfd35O9faSSnyiOJov5Zn2bcF8UrQDJMnfRRPQXJuJf9c4ovIhyBy+Ocd7AVWbSEbKNGrvLKaSkmbnvOwwwap5QnEEFhy7O3lnvOpHPevmUzvEIuaUfiynzeD4m1tiF163g9JF1FgQPiQcE0qnZNjOd0PzJ+5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895624; c=relaxed/simple;
	bh=6ockP+1DmxqXnoj+GUIC0kl/WO1mCVR1Ck1KzqVkOeU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VzBdh4vdogQIUhS8SVKDQpr4iPNK0UbGezMVp8v+uW16XRGr+NHynBJNFzDQkfLRCm6I8vPGReGLybEgT59JtnlUgSBZS78vSfeQkw92GhAA2M3bFv8v7mb2cMRVFhX+VjtjAobGmW60W2jgRQWGUxyHn24/EX6Q7JAU0tQejV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OCrxC5lI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OCrxC5lI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC34F1F000FF;
	Tue, 13 Oct 2026 12:47:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895623;
	bh=cf1joUnjcUpt9tzaBjY9HzWe3jMbGI4rpTBYQB9m/pI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OCrxC5lIgDQTTk1V+qqdB2ztGJirI7gakpwbn/kv7MQktceyiHPoIwCgnMvJAcRk+
	 44q9uzeGxCJeyl63uViOHCz+aXyGIhzKMx4HAogdsUrRKICBk29bMZFmZTlOEi8JDp
	 G6dP2NzTi01wl0umt2mRUCBX0vey04V2EbpbM9dI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 338/497] iio: bu27034: simplify using guard(mutex)
Date: Tue, 13 Oct 2026 13:38:25 +0200
Message-ID: <20261013112915.927277111@linuxfoundation.org>
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

[ Upstream commit 439c2cef8157bd3856200effdf4bb4ce3ff8e774 ]

The BU27034 uses mutex for protecting the gain / time / scale changes.
The clean-up for a few of the functions can be slightly simplified by
removing the goto-based error handling/unlocking and by utilizing the
guard(mutex) scoped mutex handling instead.

Simplify driver by using the scoped mutexes.

Signed-off-by: Matti Vaittinen <mazziesaccount@gmail.com>
Reviewed-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Link: https://patch.msgid.link/4e65a4725c211b166906f70fdb5ba90f2af0f570.1732193263.git.mazziesaccount@gmail.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Stable-dep-of: 8065a6c02f62 ("iio: light: rohm-bu27034: Fix infinite delay on error")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/light/rohm-bu27034.c | 73 +++++++++++---------------------
 1 file changed, 25 insertions(+), 48 deletions(-)

diff --git a/drivers/iio/light/rohm-bu27034.c b/drivers/iio/light/rohm-bu27034.c
index 29da3313addbd..be3895a9da70c 100644
--- a/drivers/iio/light/rohm-bu27034.c
+++ b/drivers/iio/light/rohm-bu27034.c
@@ -7,6 +7,7 @@
 
 #include <linux/bitfield.h>
 #include <linux/bits.h>
+#include <linux/cleanup.h>
 #include <linux/device.h>
 #include <linux/i2c.h>
 #include <linux/module.h>
@@ -395,30 +396,26 @@ static int bu27034_try_set_int_time(struct bu27034_data *data, int time_us)
 	int numg = ARRAY_SIZE(gains);
 	int ret, int_time_old, i;
 
-	mutex_lock(&data->mutex);
+	guard(mutex)(&data->mutex);
 	ret = bu27034_get_int_time(data);
 	if (ret < 0)
-		goto unlock_out;
+		return ret;
 
 	int_time_old = ret;
 
 	if (!iio_gts_valid_time(&data->gts, time_us)) {
 		dev_err(data->dev, "Unsupported integration time %u\n",
 			time_us);
-		ret = -EINVAL;
-
-		goto unlock_out;
+		return -EINVAL;
 	}
 
-	if (time_us == int_time_old) {
-		ret = 0;
-		goto unlock_out;
-	}
+	if (time_us == int_time_old)
+		return 0;
 
 	for (i = 0; i < numg; i++) {
 		ret = bu27034_get_gain(data, gains[i].chan, &gains[i].old_gain);
 		if (ret)
-			goto unlock_out;
+			return 0;
 
 		ret = iio_gts_find_new_gain_by_old_gain_time(&data->gts,
 							     gains[i].old_gain,
@@ -434,7 +431,7 @@ static int bu27034_try_set_int_time(struct bu27034_data *data, int time_us)
 				gains[i].chan, time_us, scale1, scale2);
 
 			if (gains[i].new_gain < 0)
-				goto unlock_out;
+				return ret;
 
 			/*
 			 * If caller requests for integration time change and we
@@ -455,7 +452,7 @@ static int bu27034_try_set_int_time(struct bu27034_data *data, int time_us)
 					 "Total gain increase. Risk of saturation");
 				ret = iio_gts_get_min_gain(&data->gts);
 				if (ret < 0)
-					goto unlock_out;
+					return ret;
 			}
 			dev_dbg(data->dev, "chan %u scale changed\n",
 				 gains[i].chan);
@@ -468,15 +465,10 @@ static int bu27034_try_set_int_time(struct bu27034_data *data, int time_us)
 	for (i = 0; i < numg; i++) {
 		ret = bu27034_set_gain(data, gains[i].chan, gains[i].new_gain);
 		if (ret)
-			goto unlock_out;
+			return ret;
 	}
 
-	ret = bu27034_set_int_time(data, time_us);
-
-unlock_out:
-	mutex_unlock(&data->mutex);
-
-	return ret;
+	return bu27034_set_int_time(data, time_us);
 }
 
 static int bu27034_set_scale(struct bu27034_data *data, int chan,
@@ -492,10 +484,10 @@ static int bu27034_set_scale(struct bu27034_data *data, int chan,
 		return -EINVAL;
 	}
 
-	mutex_lock(&data->mutex);
+	guard(mutex)(&data->mutex);
 	ret = regmap_read(data->regmap, BU27034_REG_MODE_CONTROL1, &time_sel);
 	if (ret)
-		goto unlock_out;
+		return ret;
 
 	ret = iio_gts_find_gain_sel_for_scale_using_time(&data->gts, time_sel,
 						val, val2, &gain_sel);
@@ -518,7 +510,7 @@ static int bu27034_set_scale(struct bu27034_data *data, int chan,
 
 		ret = bu27034_get_gain(data, gain.chan, &gain.old_gain);
 		if (ret)
-			goto unlock_out;
+			return ret;
 
 		/*
 		 * Iterate through all the times to see if we find one which
@@ -551,26 +543,20 @@ static int bu27034_set_scale(struct bu27034_data *data, int chan,
 		if (!found) {
 			dev_dbg(data->dev,
 				"Can't set scale maintaining other channel\n");
-			ret = -EINVAL;
-
-			goto unlock_out;
+			return -EINVAL;
 		}
 
 		ret = bu27034_set_gain(data, gain.chan, gain.new_gain);
 		if (ret)
-			goto unlock_out;
+			return ret;
 
 		ret = regmap_update_bits(data->regmap, BU27034_REG_MODE_CONTROL1,
 				  BU27034_MASK_MEAS_MODE, new_time_sel);
 		if (ret)
-			goto unlock_out;
+			return ret;
 	}
 
-	ret = bu27034_write_gain_sel(data, chan, gain_sel);
-unlock_out:
-	mutex_unlock(&data->mutex);
-
-	return ret;
+	return bu27034_write_gain_sel(data, chan, gain_sel);
 }
 
 /*
@@ -1221,42 +1207,33 @@ static int bu27034_buffer_enable(struct iio_dev *idev)
 	struct task_struct *task;
 	int ret;
 
-	mutex_lock(&data->mutex);
+	guard(mutex)(&data->mutex);
 	ret = bu27034_meas_set(data, true);
 	if (ret)
-		goto unlock_out;
+		return ret;
 
 	task = kthread_run(bu27034_buffer_thread, idev,
 				 "bu27034-buffering-%u",
 				 iio_device_id(idev));
-	if (IS_ERR(task)) {
-		ret = PTR_ERR(task);
-		goto unlock_out;
-	}
+	if (IS_ERR(task))
+		return PTR_ERR(task);
 
 	data->task = task;
 
-unlock_out:
-	mutex_unlock(&data->mutex);
-
-	return ret;
+	return 0;
 }
 
 static int bu27034_buffer_disable(struct iio_dev *idev)
 {
 	struct bu27034_data *data = iio_priv(idev);
-	int ret;
 
-	mutex_lock(&data->mutex);
+	guard(mutex)(&data->mutex);
 	if (data->task) {
 		kthread_stop(data->task);
 		data->task = NULL;
 	}
 
-	ret = bu27034_meas_set(data, false);
-	mutex_unlock(&data->mutex);
-
-	return ret;
+	return bu27034_meas_set(data, false);
 }
 
 static const struct iio_buffer_setup_ops bu27034_buffer_ops = {
-- 
2.53.0



