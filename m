Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623735;
	b=fj4sIrzJMUnNwBO2lPJUQMVpylfC2cH3vtoXJQ2Z0YNeirDL3aMG48tpH5ZHhj1Pjwjt
	 zabiGBIirkZpKQIL3zB1Cso4KGp839sRhkTdD3Df1tnvld5hE31kfODKtwhkKgwxBM1Dm
	 C8kjs/elNl5fsV7wI/HxLQPMBsvpp1+QfTjfttZV/ZwzXM6TxD49MRqDBaxkAVJb/Fy18
	 Oy3LBAAWRBgByXvjVHkLLp4U5vBcObto1CRaDk/KoBR07bSdTi+c3ONYrkChKHRS5zyfC
	 wBuBVk0ssH7EVTbRmeEdFUk8eqKXNCv8iK9w/I7cBH9Ihd/VtQoPP3fpuA7a346XFkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623735;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=G/jx/dK7VICEJROACspLH8FnJkOV2o6wNH7nJUTS50w=;
	b=4Fd5R5xA1C03shY3qBgKb/ZBxiPjhJQKjt2X3fV8g8LTTUbq9V2da9VyBQTu7cwsrHUx
	 cI9mLa0TbxqEW5ShznF/060V7ncJk3i8Zxn3hpNSpeNihlfU5kk9hCqkPv76XXjYMed6f
	 CV+qWFWWeha45KqPfTSww+f6R74J7v+pj+sp7CGp9Lqhf+dWAyQdtEvHP8648skh37jmf
	 1H5BRKq+rkyrdSUKRqsoHirrjyLAu5bxy7syIdNuT20rK6A54VKMT+YxeDob/3GtAcrAS
	 QrSonprQN+yN7jr/LdWra2katJl2vBbAzwvcMPipL4Vz6XoEeT2Z/LOIhlKa4MMsrOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nRK6VOop;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E775606A327;
	Wed, 25 Nov 2026 16:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nRK6VOop
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77AA91F000CF;
	Wed, 25 Nov 2026 16:22:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623735;
	bh=G/jx/dK7VICEJROACspLH8FnJkOV2o6wNH7nJUTS50w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nRK6VOopSRaFnGdx/oVRJK9HwFd2Ud2Rdgxfz2S++qAOlCiABNmKopDKJCJ22Xgee
	 jf1RAiS0TOflAiMkF8s8ZXw3GMj3DAGOBwKFR6Q/mknVdpRoZ6MJKo844DpIn/r7DL
	 1+YGu2BPaYoK33hod5UoMkXDd7d7XRR+CRxqeqbM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vidhu Sarwal <vidhu.linux@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.18 954/990] iio: humidity: am2315: fix negative temperature decoding
Date: Wed, 25 Nov 2026 15:38:41 +0100
Message-ID: <20261125143844.335136795@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 


