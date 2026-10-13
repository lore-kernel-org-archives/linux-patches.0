Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E27D04EDCD0;
	Tue, 13 Oct 2026 12:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895724; cv=none; b=SxiSGzVX+J9ktjuLG+Wgn+VkV8cd0woOvLQ0r9WypR/gb3ERc3OifXIPuMjhPmNlqTj6KHpZh3yfJLHZ1p7jGR7IcD27PaT7+zN8CvVS2ol/lZU2wVkSOI20jLmiZL40SPB+UQdtQb32pi9yU3+gL17Juc2Q5O12ATEoaL5+STQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895724; c=relaxed/simple;
	bh=UKU8RLiJv8KWby13CC6QTTkADnofmDY0WUdNgZxNQtY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ax8VbXhviCfPNpk+OOpC0afr0BdXA7gzQQwRuWcJX2+PrcIW1tvbUnZehTP9IQ3s1mt4Rlvsovx3qk659I0aqlnhXB/lMAOI5fUQ945zsuKzj2cUsrhPjzr0e5nXUculidbfDp0O1ehWXJ5QDvGYdK7x6F89hU+TLFILx+fT62Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MaSkJ7MZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MaSkJ7MZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46E861F000FF;
	Tue, 13 Oct 2026 12:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895722;
	bh=0z9FB1Kuh6YrPrz48ps5tg5upuzZtZ2J0K7gg4v0MuE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MaSkJ7MZhNjed5I5dK690Dk4H6WogQG52HZDKjKSvBBw1/LLaC45z0Q1DvjMjmAZl
	 WV6nmL3GJ1r42fk+FAYOyb4AeyINk7GvDmaDFZWmN/nUgH//l44ReIEZPQCK4zJNmw
	 3FzXtOJTwIuFf8ZaCEQpLgPzrmtaTUSkoN1v6/KU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 327/497] iio: accel: kx022a: Use cleanup.h helpers
Date: Tue, 13 Oct 2026 13:38:14 +0200
Message-ID: <20261013112915.665458920@linuxfoundation.org>
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

[ Upstream commit 725521e1f485d4687790f2e459271f1ad6af64d5 ]

A few functions in KX022A need to use mutex for protecting the
enabling/disabling of the measurement while configurations are being
made. Some of the functions can be slightly simplified by using the
__cleanup based scoped mutexes, which allows dropping the goto based
unlocking at error path.

Simplify error paths using guard(mutex).

Signed-off-by: Matti Vaittinen <mazziesaccount@gmail.com>
Link: https://patch.msgid.link/4785f841ad5f131356ba78b4f3c76f676d86a2e8.1732783834.git.mazziesaccount@gmail.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Stable-dep-of: e65e128b51a3 ("iio: accel: kionix-kx022a: Prevent memory leak and fix state")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/accel/kionix-kx022a.c | 61 ++++++++++++-------------------
 1 file changed, 23 insertions(+), 38 deletions(-)

diff --git a/drivers/iio/accel/kionix-kx022a.c b/drivers/iio/accel/kionix-kx022a.c
index db78a1945956d..1e4ba5602dbf4 100644
--- a/drivers/iio/accel/kionix-kx022a.c
+++ b/drivers/iio/accel/kionix-kx022a.c
@@ -5,6 +5,7 @@
  * ROHM/KIONIX accelerometer driver
  */
 
+#include <linux/cleanup.h>
 #include <linux/delay.h>
 #include <linux/device.h>
 #include <linux/interrupt.h>
@@ -447,7 +448,7 @@ static void kx022a_reg2scale(unsigned int val, unsigned int *val1,
 	*val2 = kx022a_scale_table[val][1];
 }
 
-static int kx022a_turn_on_off_unlocked(struct kx022a_data *data, bool on)
+static int __kx022a_turn_on_off(struct kx022a_data *data, bool on)
 {
 	int ret;
 
@@ -468,7 +469,7 @@ static int kx022a_turn_off_lock(struct kx022a_data *data)
 	int ret;
 
 	mutex_lock(&data->mutex);
-	ret = kx022a_turn_on_off_unlocked(data, false);
+	ret = __kx022a_turn_on_off(data, false);
 	if (ret)
 		mutex_unlock(&data->mutex);
 
@@ -479,7 +480,7 @@ static int kx022a_turn_on_unlock(struct kx022a_data *data)
 {
 	int ret;
 
-	ret = kx022a_turn_on_off_unlocked(data, true);
+	ret = __kx022a_turn_on_off(data, true);
 	mutex_unlock(&data->mutex);
 
 	return ret;
@@ -911,18 +912,19 @@ static int kx022a_fifo_disable(struct kx022a_data *data)
 {
 	int ret = 0;
 
-	ret = kx022a_turn_off_lock(data);
+	guard(mutex)(&data->mutex);
+	ret = __kx022a_turn_on_off(data, false);
 	if (ret)
 		return ret;
 
 	ret = regmap_clear_bits(data->regmap, data->ien_reg, KX022A_MASK_WMI);
 	if (ret)
-		goto unlock_out;
+		return ret;
 
 	ret = regmap_clear_bits(data->regmap, data->chip_info->buf_cntl2,
 				KX022A_MASK_BUF_EN);
 	if (ret)
-		goto unlock_out;
+		return ret;
 
 	data->state &= ~KX022A_STATE_FIFO;
 
@@ -930,12 +932,7 @@ static int kx022a_fifo_disable(struct kx022a_data *data)
 
 	kfree(data->fifo_buffer);
 
-	return kx022a_turn_on_unlock(data);
-
-unlock_out:
-	mutex_unlock(&data->mutex);
-
-	return ret;
+	return __kx022a_turn_on_off(data, true);
 }
 
 static int kx022a_buffer_predisable(struct iio_dev *idev)
@@ -958,33 +955,29 @@ static int kx022a_fifo_enable(struct kx022a_data *data)
 	if (!data->fifo_buffer)
 		return -ENOMEM;
 
-	ret = kx022a_turn_off_lock(data);
+	guard(mutex)(&data->mutex);
+	ret = __kx022a_turn_on_off(data, false);
 	if (ret)
 		return ret;
 
 	/* Update watermark to HW */
 	ret = kx022a_fifo_set_wmi(data);
 	if (ret)
-		goto unlock_out;
+		return ret;
 
 	/* Enable buffer */
 	ret = regmap_set_bits(data->regmap, data->chip_info->buf_cntl2,
 			      KX022A_MASK_BUF_EN);
 	if (ret)
-		goto unlock_out;
+		return ret;
 
 	data->state |= KX022A_STATE_FIFO;
 	ret = regmap_set_bits(data->regmap, data->ien_reg,
 			      KX022A_MASK_WMI);
 	if (ret)
-		goto unlock_out;
-
-	return kx022a_turn_on_unlock(data);
-
-unlock_out:
-	mutex_unlock(&data->mutex);
+		return ret;
 
-	return ret;
+	return __kx022a_turn_on_off(data, true);
 }
 
 static int kx022a_buffer_postenable(struct iio_dev *idev)
@@ -1052,7 +1045,7 @@ static irqreturn_t kx022a_irq_thread_handler(int irq, void *private)
 	struct kx022a_data *data = iio_priv(idev);
 	irqreturn_t ret = IRQ_NONE;
 
-	mutex_lock(&data->mutex);
+	guard(mutex)(&data->mutex);
 
 	if (data->trigger_enabled) {
 		iio_trigger_poll_nested(data->trig);
@@ -1067,8 +1060,6 @@ static irqreturn_t kx022a_irq_thread_handler(int irq, void *private)
 			ret = IRQ_HANDLED;
 	}
 
-	mutex_unlock(&data->mutex);
-
 	return ret;
 }
 
@@ -1078,32 +1069,26 @@ static int kx022a_trigger_set_state(struct iio_trigger *trig,
 	struct kx022a_data *data = iio_trigger_get_drvdata(trig);
 	int ret = 0;
 
-	mutex_lock(&data->mutex);
+	guard(mutex)(&data->mutex);
 
 	if (data->trigger_enabled == state)
-		goto unlock_out;
+		return 0;
 
 	if (data->state & KX022A_STATE_FIFO) {
 		dev_warn(data->dev, "Can't set trigger when FIFO enabled\n");
-		ret = -EBUSY;
-		goto unlock_out;
+		return -EBUSY;
 	}
 
-	ret = kx022a_turn_on_off_unlocked(data, false);
+	ret = __kx022a_turn_on_off(data, false);
 	if (ret)
-		goto unlock_out;
+		return ret;
 
 	data->trigger_enabled = state;
 	ret = kx022a_set_drdy_irq(data, state);
 	if (ret)
-		goto unlock_out;
-
-	ret = kx022a_turn_on_off_unlocked(data, true);
-
-unlock_out:
-	mutex_unlock(&data->mutex);
+		return ret;
 
-	return ret;
+	return __kx022a_turn_on_off(data, true);
 }
 
 static const struct iio_trigger_ops kx022a_trigger_ops = {
-- 
2.53.0



