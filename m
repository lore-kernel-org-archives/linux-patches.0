Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795626275;
	b=1QykGnwNwUyOSFhzp8OluCzz2HIlbIsu/wV6/U62Q3GVuGvowzoosLR+ZsQZMXPF/Xx2
	 dcCbwsrcrfYvs4NURcW6UdF1ivlZKz7/JG85FFm5r6ZqAzSso4tzQ0j7ZHv3TkeBPboFu
	 g27A7OQ7zdqywyo7b6bW0ySL7yKcEvQiR0btiOqzVu1nx6EuzPZEtjzJoKzr0071ZUZSx
	 tHOumZx/E0T+P7+pbWFk3HbSfmW0yy7hEsmvOtYhbsYzyj0fpq7YcoE5lYJp5H9hWyieN
	 FYqAM5mfZipTjVEovDLsiXaPlMfwfcvqWz8DtRLjYr7kog5gZGFcyDcGgMGPrgPkGHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795626275;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Adut9Sb8B3d3XzYuS6DxjBuWwQsxYvdjm4J3W74y9mk=;
	b=LVj0g/Dn3+sC+sYZmBXXSbJ+z+1/pCdahRyzxk+L0hQRgBVILqolWGCCZxNMPZyXzUuL
	 GeiNTxleahmmYdmAjgqN28CPuffhWrGnV0NrRoZtGDZz82lo8IY5My2YtnADaNge9/X9g
	 3btK0YVF2piw+ZP24DnLwUXMzhtEB/vG7lQAraaZDsDeQ4DXicSJQVakfyd+dEvpVaP+G
	 scFl/GU4N+c7C2r1bY9g2HfVefhVVM75+N9XRJpeEtMWbZTdBdBPgZwAvf0oXW7rW41F4
	 diZBmrPxO1YIjKXWOUpZBxZHoT69Tu+md52nqk1qL9KJJ7ISEj552DAqvp/fjpLwkxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RCYbeZzj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 844BB606A31E;
	Wed, 25 Nov 2026 17:04:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RCYbeZzj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D57EE1F000C4;
	Wed, 25 Nov 2026 17:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795626275;
	bh=Adut9Sb8B3d3XzYuS6DxjBuWwQsxYvdjm4J3W74y9mk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RCYbeZzjjQ5iB5jkzlMVqMrIZPjW6Z5SJhX8T18qawDQgCRjh9Fn1gcLOnA7h7KZX
	 SPxwGKY/WEI7ZB6tM5c7xPdud4Q2bBZI7aQpLpX1bSFDt+/fPGJrt0lNrW4I8ocEI7
	 aP2isVgBmMEf5E9gExZCDb8qWEYadYQtubc6RQFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vidhu Sarwal <vidhu.linux@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.12 789/816] iio: humidity: am2315: fix negative temperature decoding
Date: Wed, 25 Nov 2026 15:38:57 +0100
Message-ID: <20261125143907.435963185@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 


