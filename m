Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 767B22737EB;
	Mon, 23 Mar 2026 14:57:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277855; cv=none; b=FIP8Gn+DF2hhgpH5JlMY2pynLCMXA57qY4bHLg4yJ3XctaH69M9m2p0etJXcNRMQZuqbVoDoTCdaf0wwwfiv8RlQBxUGPyDKGsyRqA85ZFK4S+M+4PUa2c9w1Jc1O8dcIP3thVrTiaYL1e7jxzjAIZdQJ9EOb5vujjt5defbF+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277855; c=relaxed/simple;
	bh=K+INmJzC9CUbHF3cGCEAmUBSOdojpsGkqhCPlzEhnSk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gJMoVs1Iot8ftOycgkPUI119RI5a62TiBEhIg3AaIrWzQU3f3nv/L1u0tr9tcavT84N8FTap0j2PWEdlkgOhwfM1AUG9DiXFZl0ZzkmacC8KXQrvY9U27vB0QuYrGIyKfQ20mQXTL8tOfW5HoAuLSB8EZuqTf9sfwdHzPAUaMIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XGxMiuf1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XGxMiuf1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3180C4CEF7;
	Mon, 23 Mar 2026 14:57:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277855;
	bh=K+INmJzC9CUbHF3cGCEAmUBSOdojpsGkqhCPlzEhnSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XGxMiuf1X9Xkr5ByTZQL45FTuMbuT1zydfkYYHP8/FmQro9PRruBezElBrkYFwPIq
	 TGeYXFyZ9vjF2w0h9qfkioTGanAnjwCVsW5VKRIkN202UdFNDlI4AmFwwVj78aEr8u
	 7U/Qkro7cm7YYbxrY5ilx9yfIulOA+3G+0ysXAKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hao Yu <haoyufine@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 123/567] hwmon: (aht10) Fix initialization commands for AHT20
Date: Mon, 23 Mar 2026 14:40:43 +0100
Message-ID: <20260323134536.847931934@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hao Yu <haoyufine@gmail.com>

[ Upstream commit b7497b5a99f54ab8dcda5b14a308385b2fb03d8d ]

According to the AHT20 datasheet (updated to V1.0 after the 2023.09
version), the initialization command for AHT20 is 0b10111110 (0xBE).
The previous sequence (0xE1) used in earlier versions is no longer
compatible with newer AHT20 sensors. Update the initialization
command to ensure the sensor is properly initialized.

While at it, use binary notation for DHT20_CMD_INIT to match the notation
used in the datasheet.

Fixes: d2abcb5cc885 ("hwmon: (aht10) Add support for compatible aht20")
Signed-off-by: Hao Yu <haoyufine@gmail.com>
Link: https://lore.kernel.org/r/20260222170332.1616-3-haoyufine@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/aht10.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/aht10.c b/drivers/hwmon/aht10.c
index 4f235dfb260f8..aa116957d9c96 100644
--- a/drivers/hwmon/aht10.c
+++ b/drivers/hwmon/aht10.c
@@ -37,7 +37,9 @@
 #define AHT10_CMD_MEAS	0b10101100
 #define AHT10_CMD_RST	0b10111010
 
-#define DHT20_CMD_INIT	0x71
+#define AHT20_CMD_INIT	0b10111110
+
+#define DHT20_CMD_INIT	0b01110001
 
 /*
  * Flags in the answer byte/command
@@ -358,7 +360,7 @@ static int aht10_probe(struct i2c_client *client)
 		data->meas_size = AHT20_MEAS_SIZE;
 		data->crc8 = true;
 		crc8_populate_msb(crc8_table, AHT20_CRC8_POLY);
-		data->init_cmd = AHT10_CMD_INIT;
+		data->init_cmd = AHT20_CMD_INIT;
 		break;
 	case dht20:
 		data->meas_size = AHT20_MEAS_SIZE;
-- 
2.51.0



