Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ADFE8827;
	Mon, 23 Dec 2024 16:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970741; cv=none; b=MQDjZMY3OByYH3DxwdzYG/hkNs0Lyrw+gx98fo666cw3lg7gF8lcGqHs9n5GQtzTRCeNoGzxm7X15m1ITLsBSk6l1p8BKi9tDSQl1DV39wk+yeLzlt8AX86Dm1TXHFlE3IMbVRXFNAz1ubvSkuA+7YYn4ff2zdLPdEQ46+davYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970741; c=relaxed/simple;
	bh=DQtWxMIRMW5PRw/q4yfbUw+FcH7frn1wrKXx6ehdJpM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m85bIiJCY0Xp/HtqUBbUJ1+ZATVeDCXP+V28FLd7CyNARPdUXAxjfezNSDLyChz3ANi6WfcjqPx5f0fKVleuP3MWLwyye9ctbXD7ZzgC/DMer5W7mCktujJOZoPTbC0C0Zr5z9Hgd9c4+icfky1bggaVrim35u4T8ZXSLlH6vPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gyKEil38; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gyKEil38"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D035FC4CED3;
	Mon, 23 Dec 2024 16:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970741;
	bh=DQtWxMIRMW5PRw/q4yfbUw+FcH7frn1wrKXx6ehdJpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gyKEil38XNVewj6u25EJrBQk2GMnuu4ZqDEeaG++Y4Xuv12+sRZ8gQ9gMyAaeH/WW
	 lREX2BKdE+ZmaeoFOZrzyLDGUefXF9Gy7cDCbi4PJf1PZa/VJjZmi+XaJ8K5HoBq+j
	 Hkool+uADo7axzLst0ipeuG+X1LHVZTlLHkEpImI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Murad Masimov <m.masimov@maxima.ru>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 55/83] hwmon: (tmp513) Fix interpretation of values of Temperature Result and Limit Registers
Date: Mon, 23 Dec 2024 16:59:34 +0100
Message-ID: <20241223155355.759291490@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155353.641267612@linuxfoundation.org>
References: <20241223155353.641267612@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Murad Masimov <m.masimov@maxima.ru>

[ Upstream commit dd471e25770e7e632f736b90db1e2080b2171668 ]

The values returned by the driver after processing the contents of the
Temperature Result and the Temperature Limit Registers do not correspond to
the TMP512/TMP513 specifications. A raw register value is converted to a
signed integer value by a sign extension in accordance with the algorithm
provided in the specification, but due to the off-by-one error in the sign
bit index, the result is incorrect.

According to the TMP512 and TMP513 datasheets, the Temperature Result (08h
to 0Bh) and Limit (11h to 14h) Registers are 13-bit two's complement
integer values, shifted left by 3 bits. The value is scaled by 0.0625
degrees Celsius per bit.  E.g., if regval = 1 1110 0111 0000 000, the
output should be -25 degrees, but the driver will return +487 degrees.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 59dfa75e5d82 ("hwmon: Add driver for Texas Instruments TMP512/513 sensor chips.")
Signed-off-by: Murad Masimov <m.masimov@maxima.ru>
Link: https://lore.kernel.org/r/20241216173648.526-4-m.masimov@maxima.ru
[groeck: fixed description line length]
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/tmp513.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/tmp513.c b/drivers/hwmon/tmp513.c
index 4ab06852efd9..aaba9521ebef 100644
--- a/drivers/hwmon/tmp513.c
+++ b/drivers/hwmon/tmp513.c
@@ -230,7 +230,7 @@ static int tmp51x_get_value(struct tmp51x_data *data, u8 reg, u8 pos,
 	case TMP51X_REMOTE_TEMP_LIMIT_2:
 	case TMP513_REMOTE_TEMP_LIMIT_3:
 		// 1lsb = 0.0625 degrees centigrade
-		*val = sign_extend32(regval, 16) >> TMP51X_TEMP_SHIFT;
+		*val = sign_extend32(regval, 15) >> TMP51X_TEMP_SHIFT;
 		*val = DIV_ROUND_CLOSEST(*val * 625, 10);
 		break;
 	case TMP51X_N_FACTOR_AND_HYST_1:
-- 
2.39.5



