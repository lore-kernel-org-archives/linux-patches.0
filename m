Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054709;
	b=CPDCMRo7ijRmLUutG/A19sXs7dCSn+MgQ8GJzuPKJGv/CTQtfXQLU/76m4tfewCbjXRX
	 gO5vgop6iQHO9baBnb0mb9oDOnuJNY3WLfTUGbdBwleVF5vdaoL9v2ZWpHh2wyidqjGkn
	 qU2SJjQh/OjlMmeLhHWt6rfeD7N0da/ZOEhVF8Y0MSncpzmsbYY9K0u8z/ce+fQ/jADuM
	 mIbCwNosIwDZycpqnMTvqE5ins4hrHD12i5nkWlhI6FPHmZAC8c2VBFp5FCkbp5oN4xds
	 9+lBVJDsd7ykgjvxmSC7BxpTiGDZHbm9AyfvHeouAf2IxnpXM3Ghm20Y9EcYtj2U+Gw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054709;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=O+x3rCjm8qQL2v3bM9UcPjvm5kGlU0hOptwKLv3Ixs4=;
	b=4TD3AoxPH/n2Z4Wy+rHaezKP/LyIT8fKPP17HtjL6v+PkNBT/Si5c//cNyu6tMLuw88M
	 mDBXPK8c93rMFIO6+Ut/NORLBDtTquskys6f1qh+/w1IwSyYRhigjZqHuGFOzIWvbC9Ft
	 T9CMacYqymAwO+0JvBVmNrzEagjwveNXod8LlnZ3w6dMJHIcob+3GvhDkcQvGxvqvBxb0
	 O1XJ7rGNdP6H4iYAlV1zCWmXWpJuFtbjrjs4prQmJTCkOjKUYapjfTfOShgSvFR5von9e
	 G+jbAmmsqHXbiMaJMJdW+Gbm9RK/IaRA9R1xJ58ChC1Br2TNjCiK8/rpsvBvSCybMbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vEj83Xph;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1A1C606A320;
	Thu, 19 Nov 2026 02:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vEj83Xph
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F07C41F000C4;
	Thu, 19 Nov 2026 02:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054709;
	bh=O+x3rCjm8qQL2v3bM9UcPjvm5kGlU0hOptwKLv3Ixs4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vEj83Xph2XTSLZMwTYxpcp/sTrxrdq39aT5IuIEMilM1+HD/DP0tywzkyAWBwINy4
	 6cr6waW3XqqH3a5AtoouyPkmgRrAM0ZElwpN2btc+Fe2dy0yB3CaRBP252v1dmpzu5
	 b8MW/ABCtmmYb81mVYkcEtgcn3iYBbuSMC6nShOY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Salah Triki <salah.triki@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1334/2214] iio: temperature: tmp117: fix calibbias cache update on I2C write failure
Date: Wed, 18 Nov 2026 15:50:10 +0100
Message-ID: <20261118150104.755873166@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



