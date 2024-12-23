Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEF0212D1F1;
	Mon, 23 Dec 2024 16:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734969961; cv=none; b=BBRyWbQ5DCft03DVeIpCwtDwW1EeHJo0SBOqS0cPcbVkACASvWZGmnePamfDeGwiLdbWO3tEHZ9ltb+r/dPovbSka5Npue2WYebWywKHmkpcPnXrHEUWcuNRJr+GvYpFG//sYPLgbAZCXYitU1DKtB3ycDkQ49HrzEmskE13A0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734969961; c=relaxed/simple;
	bh=dzAx4GWQHzqgDOdkFbZ/yPvSVdwmBq8BTVLhkOGVhDI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fS//ss6AkJ7bPxEes77zjXKz/JtRn3W8EBRxwS/RBBhWFQg0rMz1kbm8Tv+mWcxoYeDVWyAy7ZBVF3ZP5zswXYdoJW3+7/0qDSdDPE89Berrw82SzHtFdyqxYKQXPt6ge+JnrSveoQQt1ChSNmf/9wGUjir4rk/8twc2+LSqeF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WaBTqItv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WaBTqItv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D971C4CED4;
	Mon, 23 Dec 2024 16:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734969960;
	bh=dzAx4GWQHzqgDOdkFbZ/yPvSVdwmBq8BTVLhkOGVhDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WaBTqItvAZPEMaDVqNIaxGeoA7bwKQ2nQhuLeAnF4om9u7tH+jhcohyMGCEEwFZ/+
	 EqsP50Nh2FjhpT5ROiGIm6neLSCuuK98LvMEGe/JcgI58xzaKgU/lCsxmlo2QIxl1F
	 TH2W0aPQMP85TID8Y3I1Yd6/rx/KFun7bzdtdfKQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Murad Masimov <m.masimov@maxima.ru>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 103/160] hwmon: (tmp513) Fix interpretation of values of Temperature Result and Limit Registers
Date: Mon, 23 Dec 2024 16:58:34 +0100
Message-ID: <20241223155412.656750747@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 2846b1cc515d..1c2cb12071b8 100644
--- a/drivers/hwmon/tmp513.c
+++ b/drivers/hwmon/tmp513.c
@@ -234,7 +234,7 @@ static int tmp51x_get_value(struct tmp51x_data *data, u8 reg, u8 pos,
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



