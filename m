Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704803;
	b=lOB/lcY8aSmN5Sk8BsREwrkJkB3Kclsn83ZFzH7/nCN/AkfdYa7A2nmRpgnX/6X+CaMs
	 y++iYzGgyYTSKV3NUSi/oKlQ+TgMZnsKTgoMCkjPAQzS0VVYHL1zD/2d2gvAY3Kbdo1R0
	 zIoH5kPHprxPL31heD+burNZDDC/gVEJ5ZLSYoRMdtxS/CtT4ClwS5jurh0Caux2m4HQZ
	 XylsTaPCw+7IMUX6gQbnP+tDUZbhySFEqdOHlJoksjIFXtpToo1gRWypHLWakDAiaFhKy
	 BtMcGaqnWPmNWrdRhHzq3AcfjOQS7Y5xFlz1OAaWpjbbI+WirZ7CByyAtWym0hTfPBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704803;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rVKzbzpC8lysuj1aPRcztok7T4GLtPdLGWxqnt8AEfs=;
	b=qS5JINsL+wqu/yWLgVS7Y4ZWrLU4lBqZMGDS8rylaUj2aZCNtkx9P/ORdsMa2FAfCV7V
	 xy9DvtcF+3t8Oo7r+bDAqLh3L7iqSw9ejkMKTtV/3AdguEZCofEmrkz91k/rMb/cQSxfN
	 lKp3PZWnJUDl9WQ+0xX4wZuTXPVuvokk5a2Ap9u2i7FsYQ3Q89sqslg/tG+hTXskbamWU
	 np+yvCU5TnfNQQ2TIBz4TiXmuM9H5tTgp4UxMQHz1nHwSm+Vf75YSGjnoHfCw01kcNtio
	 q1zJ92l4EyjVkp83gUdlFta7dk32/V/D/wZc7RosEuY3b+Ty7+d9GbBwYuOKEQHt42A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rwmkNBpe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D539E606A337;
	Thu, 26 Nov 2026 14:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rwmkNBpe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD49F1F000CF;
	Thu, 26 Nov 2026 14:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704803;
	bh=rVKzbzpC8lysuj1aPRcztok7T4GLtPdLGWxqnt8AEfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rwmkNBpey10QVn/5P6OS7u62XexZUuIwHiNqDK85vDVh7SK5XHSLYRxMuj/Zo9ub1
	 4W6i6cZOpznPHEZXZLu2qqwJKykusNIxut9khI0JvMS/Cx/JAcy5sPBzzIyR0O96wr
	 t2IYcPfSTCqKS53EkKD039TGQ89TNKo3tqqKhDEI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vidhu Sarwal <vidhu.linux@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 5.10 249/265] iio: humidity: am2315: fix negative temperature decoding
Date: Thu, 26 Nov 2026 15:39:39 +0100
Message-ID: <20261126143622.651912866@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -114,6 +114,7 @@ static int am2315_read_data(struct am231
 	 */
 	u8 rx_buf[8];
 	u16 crc;
+	u16 temp_raw;
 
 	/* First wake up the device. */
 	am2315_ping(data->client);
@@ -145,8 +146,15 @@ static int am2315_read_data(struct am231
 
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
 


