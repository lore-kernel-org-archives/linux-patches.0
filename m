Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705755;
	b=gNe+w9V0DrZINtpURQyY/AROKxosRvErGl0L+uwtWZMmkXhYRG7KtYYDk93eJp9TgJBM
	 fvdkwWxACl0I+imsrCEy8ZVJOf+zfEJ8/UVwPWl7dLILhJU8mbZjGraXs6V2Llu40xyeh
	 xPoR2Zsr3err4+drwIDZ0hjEurZWtJ72ZVIK+Vr3LIjrHGHjyzp7ExtoDllfUavxlsd9Q
	 SQXRjQ9HXx/EnZCmB3rnB1kyKbtNeH9FuI5FfWZm4ltXGC6XNlq39CQdyXlXfqwpl2ZQD
	 ZwaMssto+ekkApgHKopuZOKLzZgwxIGgYoOQ4sKC15Z9KqoLnJMVgngreqI4eYlkiog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705755;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+yaIl6r0VZDCA6uon6d+9v7B8o2EvtEJh+ZOGfDgCTU=;
	b=PMr2rp+nRRwTW3MAsjSyJVlOKKYUh4cUovfd/AdQqndrxMJ+oEFKOv313BzNasBtqwKU
	 leC7r1qT5l63Y8bUxdLsPaqmX7t0xgHQjDL7JokYwWVkTqK7klZDhYfvWtBuPyTxECuZJ
	 JtclAcyPwLk6il/c1Y+ia2nj9Kbtb30SCiUokm4Y8zUJIpln0MyhacsIP7F98Ce+LKedF
	 WN9MrIrfjZI2g0uapQ7XdEuZoUpJw6DsNKBIDY5dX+YQvGiEV4cGRaZ4g5FX20VH/Y9D1
	 srnYCEOs4bMtqI6pawaEnQwFRhiZzJrhMiQn1ElxCaNldTkkw+/3ZVt7Mi8K8swe36w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u635wBPb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58CEE606A687;
	Thu, 26 Nov 2026 15:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u635wBPb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9551E1F000D0;
	Thu, 26 Nov 2026 15:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705755;
	bh=+yaIl6r0VZDCA6uon6d+9v7B8o2EvtEJh+ZOGfDgCTU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u635wBPbojnxjtYNqX9bXehHoHlv7RPoLsf1nyfgg+DAqJzJ2QApi1OOju2zS5diK
	 GRvWL+n7icG2/8P+Es3iFlB5KF3IOSZLdIGUuGxiaSngls1quY5eavmiPrDWD1AqPy
	 UzHxgRDDGWtIYXLeSDiCFqFpKJ2+6EhueRLX0ldE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vidhu Sarwal <vidhu.linux@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 5.15 303/319] iio: humidity: am2315: fix negative temperature decoding
Date: Thu, 26 Nov 2026 15:41:11 +0100
Message-ID: <20261126144013.597168746@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

From: Vidhu Sarwal <vidhu.linux@gmail.com>

commit 0a570feeca37d85fbfd6b4f6e3d9f33e1461c634 upstream.

The AM2315/AM2320 report temperature as a sign-magnitude value,
with bit 15 as the sign and bits 14-0 as the magnitude.
am2315_read_data() stores the raw value directly in an s16, causing
negative temperatures to be interpreted as two's complement. Both the
read_raw and the triggered buffer paths are affected.

Decode the sign bit before storing the temperature value. Positive
readings are unaffected.

Fixes: 366a3270c1c5 ("iio: humidity: Add support for AM2315")
Signed-off-by: Vidhu Sarwal <vidhu.linux@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/humidity/am2315.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/drivers/iio/humidity/am2315.c
+++ b/drivers/iio/humidity/am2315.c
@@ -113,6 +113,7 @@ static int am2315_read_data(struct am231
 	 */
 	u8 rx_buf[8];
 	u16 crc;
+	u16 temp_raw;
 
 	/* First wake up the device. */
 	am2315_ping(data->client);
@@ -144,8 +145,15 @@ static int am2315_read_data(struct am231
 
 	sensor_data->hum_data = (rx_buf[AM2315_HUM_OFFSET] << 8) |
 				 rx_buf[AM2315_HUM_OFFSET + 1];
-	sensor_data->temp_data = (rx_buf[AM2315_TEMP_OFFSET] << 8) |
-				  rx_buf[AM2315_TEMP_OFFSET + 1];
+
+	/*
+	 * Temperature is sign-magnitude, not two's complement:
+	 * bit 15 is the sign, bits 14-0 are the magnitude (x0.1 degC).
+	 */
+	temp_raw = (rx_buf[AM2315_TEMP_OFFSET] << 8) |
+		   rx_buf[AM2315_TEMP_OFFSET + 1];
+	sensor_data->temp_data = (temp_raw & 0x8000) ?
+				  -(temp_raw & 0x7fff) : temp_raw;
 
 	return ret;
 


