Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FFE918C333;
	Wed,  3 Jul 2024 10:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720004231; cv=none; b=njfYx6AiMtGXDuV80F5sAOlMc/GTFlfgLajYU7zk1Q9+bC4J41rNQz/W8CfxkISBFtfqrJlD0BBemtLLendVYqjIMim5gedqsCw1+wkOYFrxUr9rZ7UlJmAvLsVCqRbMjWV2zpEqhEWez3k9YJkx2l9+e8nJ2mtuR9B5Kn20rmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720004231; c=relaxed/simple;
	bh=Ix6PxheuzTkQ5ExZCmtAiT2lAbKByuWpMEKL3Mv3zUk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h9X9CSPzFQ1eUhjfK4VKwfLohlL+x90ovrSkAyka8zC6C2DsE87rrlclLcRnL6cKTC6Ryo4NcQKRBUHb23LsE3J5L5q8O+b71W1qV+Y98/R1qT9WvKSuieWFAuJtYwfd3ARUcrunlv/fAj4sEtL3gC6v2p8iSGaPGkTX6XbLEgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HHb7DfzJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HHb7DfzJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA2B9C4AF0C;
	Wed,  3 Jul 2024 10:57:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720004231;
	bh=Ix6PxheuzTkQ5ExZCmtAiT2lAbKByuWpMEKL3Mv3zUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HHb7DfzJixoB3DsY01TdhQiJR2pbgjQiugDoB/pw4a+buJm88UirjzruEQHWzqKyY
	 E3Q76+0LnVK7e3VeuDrJp9gEiYFu31+6Y5il+jcFJwXBIRkyJGc0nNjoRHv6l+8Br5
	 14EAWcVZ8IPnyiBNdzMuK7zHCsUzXQfeb1iw367g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergiu Cuciurean <sergiu.cuciurean@analog.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 131/189] iio: dac: ad5592r-base: Replace indio_dev->mlock with own device lock
Date: Wed,  3 Jul 2024 12:39:52 +0200
Message-ID: <20240703102846.431988678@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240703102841.492044697@linuxfoundation.org>
References: <20240703102841.492044697@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sergiu Cuciurean <sergiu.cuciurean@analog.com>

[ Upstream commit 33c53cbf8f7bc8d62f6146a19da97c8594376ff0 ]

As part of the general cleanup of indio_dev->mlock, this change replaces
it with a local lock on the device's state structure.
This also removes unused iio_dev pointers.

Signed-off-by: Sergiu Cuciurean <sergiu.cuciurean@analog.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Stable-dep-of: 279428df8883 ("iio: dac: ad5592r: fix temperature channel scaling value")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/dac/ad5592r-base.c | 30 +++++++++++++++---------------
 drivers/iio/dac/ad5592r-base.h |  1 +
 2 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/iio/dac/ad5592r-base.c b/drivers/iio/dac/ad5592r-base.c
index 87a51a85a642d..d9c1242db99f1 100644
--- a/drivers/iio/dac/ad5592r-base.c
+++ b/drivers/iio/dac/ad5592r-base.c
@@ -157,7 +157,6 @@ static void ad5592r_gpio_cleanup(struct ad5592r_state *st)
 static int ad5592r_reset(struct ad5592r_state *st)
 {
 	struct gpio_desc *gpio;
-	struct iio_dev *iio_dev = iio_priv_to_dev(st);
 
 	gpio = devm_gpiod_get_optional(st->dev, "reset", GPIOD_OUT_LOW);
 	if (IS_ERR(gpio))
@@ -167,10 +166,10 @@ static int ad5592r_reset(struct ad5592r_state *st)
 		udelay(1);
 		gpiod_set_value(gpio, 1);
 	} else {
-		mutex_lock(&iio_dev->mlock);
+		mutex_lock(&st->lock);
 		/* Writing this magic value resets the device */
 		st->ops->reg_write(st, AD5592R_REG_RESET, 0xdac);
-		mutex_unlock(&iio_dev->mlock);
+		mutex_unlock(&st->lock);
 	}
 
 	udelay(250);
@@ -198,7 +197,6 @@ static int ad5592r_set_channel_modes(struct ad5592r_state *st)
 	const struct ad5592r_rw_ops *ops = st->ops;
 	int ret;
 	unsigned i;
-	struct iio_dev *iio_dev = iio_priv_to_dev(st);
 	u8 pulldown = 0, tristate = 0, dac = 0, adc = 0;
 	u16 read_back;
 
@@ -248,7 +246,7 @@ static int ad5592r_set_channel_modes(struct ad5592r_state *st)
 		}
 	}
 
-	mutex_lock(&iio_dev->mlock);
+	mutex_lock(&st->lock);
 
 	/* Pull down unused pins to GND */
 	ret = ops->reg_write(st, AD5592R_REG_PULLDOWN, pulldown);
@@ -286,7 +284,7 @@ static int ad5592r_set_channel_modes(struct ad5592r_state *st)
 		ret = -EIO;
 
 err_unlock:
-	mutex_unlock(&iio_dev->mlock);
+	mutex_unlock(&st->lock);
 	return ret;
 }
 
@@ -315,11 +313,11 @@ static int ad5592r_write_raw(struct iio_dev *iio_dev,
 		if (!chan->output)
 			return -EINVAL;
 
-		mutex_lock(&iio_dev->mlock);
+		mutex_lock(&st->lock);
 		ret = st->ops->write_dac(st, chan->channel, val);
 		if (!ret)
 			st->cached_dac[chan->channel] = val;
-		mutex_unlock(&iio_dev->mlock);
+		mutex_unlock(&st->lock);
 		return ret;
 	case IIO_CHAN_INFO_SCALE:
 		if (chan->type == IIO_VOLTAGE) {
@@ -334,12 +332,12 @@ static int ad5592r_write_raw(struct iio_dev *iio_dev,
 			else
 				return -EINVAL;
 
-			mutex_lock(&iio_dev->mlock);
+			mutex_lock(&st->lock);
 
 			ret = st->ops->reg_read(st, AD5592R_REG_CTRL,
 						&st->cached_gp_ctrl);
 			if (ret < 0) {
-				mutex_unlock(&iio_dev->mlock);
+				mutex_unlock(&st->lock);
 				return ret;
 			}
 
@@ -361,7 +359,7 @@ static int ad5592r_write_raw(struct iio_dev *iio_dev,
 
 			ret = st->ops->reg_write(st, AD5592R_REG_CTRL,
 						 st->cached_gp_ctrl);
-			mutex_unlock(&iio_dev->mlock);
+			mutex_unlock(&st->lock);
 
 			return ret;
 		}
@@ -383,7 +381,7 @@ static int ad5592r_read_raw(struct iio_dev *iio_dev,
 
 	switch (m) {
 	case IIO_CHAN_INFO_RAW:
-		mutex_lock(&iio_dev->mlock);
+		mutex_lock(&st->lock);
 
 		if (!chan->output) {
 			ret = st->ops->read_adc(st, chan->channel, &read_val);
@@ -420,7 +418,7 @@ static int ad5592r_read_raw(struct iio_dev *iio_dev,
 		} else {
 			int mult;
 
-			mutex_lock(&iio_dev->mlock);
+			mutex_lock(&st->lock);
 
 			if (chan->output)
 				mult = !!(st->cached_gp_ctrl &
@@ -438,7 +436,7 @@ static int ad5592r_read_raw(struct iio_dev *iio_dev,
 	case IIO_CHAN_INFO_OFFSET:
 		ret = ad5592r_get_vref(st);
 
-		mutex_lock(&iio_dev->mlock);
+		mutex_lock(&st->lock);
 
 		if (st->cached_gp_ctrl & AD5592R_REG_CTRL_ADC_RANGE)
 			*val = (-34365 * 25) / ret;
@@ -451,7 +449,7 @@ static int ad5592r_read_raw(struct iio_dev *iio_dev,
 	}
 
 unlock:
-	mutex_unlock(&iio_dev->mlock);
+	mutex_unlock(&st->lock);
 	return ret;
 }
 
@@ -626,6 +624,8 @@ int ad5592r_probe(struct device *dev, const char *name,
 	iio_dev->info = &ad5592r_info;
 	iio_dev->modes = INDIO_DIRECT_MODE;
 
+	mutex_init(&st->lock);
+
 	ad5592r_init_scales(st, ad5592r_get_vref(st));
 
 	ret = ad5592r_reset(st);
diff --git a/drivers/iio/dac/ad5592r-base.h b/drivers/iio/dac/ad5592r-base.h
index 4774e4cd9c114..23dac2f1ff8a1 100644
--- a/drivers/iio/dac/ad5592r-base.h
+++ b/drivers/iio/dac/ad5592r-base.h
@@ -52,6 +52,7 @@ struct ad5592r_state {
 	struct regulator *reg;
 	struct gpio_chip gpiochip;
 	struct mutex gpio_lock;	/* Protect cached gpio_out, gpio_val, etc. */
+	struct mutex lock;
 	unsigned int num_channels;
 	const struct ad5592r_rw_ops *ops;
 	int scale_avail[2][2];
-- 
2.43.0



