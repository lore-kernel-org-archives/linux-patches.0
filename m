Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047710;
	b=ZXdZr+9INEp6qM0GDc7y0KfBWLkhuYUxd5tkvf/PnZ8f6ZA5i1m3IuqScz9XulpCV8DF
	 N0ZouSpXJungAEUMQsEPloB7PseL0HFjYf+XJZf57hbxegPvMmDakV3TVpNYmBEk3VhEM
	 x24K8j64qJKSoSSowy6pgaJxOG3yLCZLlOg1lTOf57R+KJv5/Ffk8d9bgquZZwUkEWWH1
	 AwPEGRpqhz7ATuCtox8XcXTfcJVJOsc+AO6lsMgxEtyj+RNwfUfaTRquTJ2pVcNQSa3KK
	 m07iyIMoSM9VC8FJc/7xx+rIEsK3NHbbdGGXaoIQineTTyezr+JEEFdPqLgXDcyqXkA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047710;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3GkQl5VQBZrWNSpgjk4+Vx44NVWtDsbI2Vrnqts4IvY=;
	b=f11RVGv9Oysz+jp4hMal2NZdEGJO37YNKW6QFikn/lXoRL7yo8AS5PhKOZgzSvrW17Cj
	 9INZWY4na9lkfIjmBuO/jzEZRVmGsy7kM1KuycmdYtSLrasn/ApNqvoxFjbXHvOjG8gsr
	 DyCQZR6oHHhm9A0bi9LV9xAriGpGQ3batWcMYUJZDSAVP6afh0PgBzBwUk6ZjPSybExsw
	 wcG3umfRzrIa1VERcLbz/PEaM0jSLBO/aZxcUr5zX1kn+zVMYLHqUdGFHwfVQjm6ceGzD
	 kYukSV2ZbgxMLyJtUfysjrVmA641VvbtTDU8kePKqWNKg1lSjwB84QFcQRDL83k4rjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rpMbFeiq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B148606A320;
	Thu, 19 Nov 2026 00:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rpMbFeiq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F03791F000CC;
	Thu, 19 Nov 2026 00:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047710;
	bh=3GkQl5VQBZrWNSpgjk4+Vx44NVWtDsbI2Vrnqts4IvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rpMbFeiqfP1z+V4XxD2vNAG3mPK1b8HvJjpQt79Cj3YL+Dn8nS24z+IgqjIcBYM4v
	 Zw6vwuRW7yd2D7yiE0/3WKg2otBgh4ov7cw7k+3/BHxfIKqylUYnO1jxPOmH7a443N
	 y1uc6pr7WsWpMS19VSlWaPd6IpTbZMvpzX7v9m+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Salah Triki <salah.triki@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1737/2857] iio: temperature: tmp117: fix calibbias cache update on I2C write failure
Date: Wed, 18 Nov 2026 15:46:11 +0100
Message-ID: <20261118150303.849918781@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Salah Triki <salah.triki@gmail.com>

[ Upstream commit 61fff9cebbfdf39bbd04d366882476d1def14047 ]

The calibbias cache (data->calibbias) was updated before the I2C
write to TMP117_REG_TEMP_OFFSET was known to succeed. If the write
failed, the function correctly returned an error, but the driver's
internal cache had already been updated to the new value.

This causes the cache and the actual hardware register to go out of
sync: a subsequent write of the same value would be silently
skipped by the early "if (off == data->calibbias) return 0;" check,
since the cache matches even though the register was never
successfully updated.

Update data->calibbias only after confirming the I2C write
succeeded, so the cache always reflects the actual state of the
device.

Found by code inspection.

Fixes: df041e737a38 ("iio: temperature: add driver support for ti tmp117")
Signed-off-by: Salah Triki <salah.triki@gmail.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/temperature/tmp117.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/temperature/tmp117.c b/drivers/iio/temperature/tmp117.c
index f9b8f2b570f6b..dfa6a381a3c41 100644
--- a/drivers/iio/temperature/tmp117.c
+++ b/drivers/iio/temperature/tmp117.c
@@ -85,15 +85,20 @@ static int tmp117_write_raw(struct iio_dev *indio_dev,
 {
 	struct tmp117_data *data = iio_priv(indio_dev);
 	s16 off;
+	int ret;
 
 	switch (mask) {
 	case IIO_CHAN_INFO_CALIBBIAS:
 		off = clamp_t(int, val, S16_MIN, S16_MAX);
 		if (off == data->calibbias)
 			return 0;
+
+		ret = i2c_smbus_write_word_swapped(data->client, TMP117_REG_TEMP_OFFSET, off);
+		if (ret)
+			return ret;
+
 		data->calibbias = off;
-		return i2c_smbus_write_word_swapped(data->client,
-						TMP117_REG_TEMP_OFFSET, off);
+		return 0;
 
 	default:
 		return -EINVAL;
-- 
2.53.0



