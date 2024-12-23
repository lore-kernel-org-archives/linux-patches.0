Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F11D98827;
	Mon, 23 Dec 2024 16:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970735; cv=none; b=hOnx+Xe4ZWhsdOu6KJEr0hPyPUSYoH26ZRApLi1qOOK/D/ZNgsyQSgOsBVQpfofaNp/nPtCdrgsXF8sgdTxaFNjDJRyvbIJmOiv1GzBcMIGGjf22A3qE7/l4iA1r+wi1DM/MNQbGWX5Yq4I2sxCbyAY3MaNjZtAAra4+wvVt0rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970735; c=relaxed/simple;
	bh=S93rCKqklmsiFSFSTyq+x4olwWgsiXla3y3UMRlI/io=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aLDj84cXCZwqcqA7L1uMMvrFTh7b3WYX0sPOb1b5srVZkRIPhi4YvClzcghCDCSIeIKwta/K6eU2Z9BZy/wjAafuTX1AkZYbnwWjgSHNzuRbNzTZYPXYIo2NkdwZcdSE0D9kAuilDFcK9y71lzynjmwRnnUrsW3hFQR5bQ/MbUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OL//GsNv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OL//GsNv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 783D6C4CED3;
	Mon, 23 Dec 2024 16:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970734;
	bh=S93rCKqklmsiFSFSTyq+x4olwWgsiXla3y3UMRlI/io=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OL//GsNvwDpJJTnc2LL6z/A6IdfnTghXy87XK2xEADfSj8wB6DG70/un55kylXweV
	 geE66nEai9GB1O8Q/bnxCSjoWCeiUXvSoF+XLGE8zVMcJJNNNMZVBlNRJAuAwz/WKO
	 1b0VvMCG4jeIj/qjQ+f1nDFloGHPgBL3foAKNxOA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Murad Masimov <m.masimov@maxima.ru>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 53/83] hwmon: (tmp513) Fix interpretation of values of Shunt Voltage and Limit Registers
Date: Mon, 23 Dec 2024 16:59:32 +0100
Message-ID: <20241223155355.684733927@linuxfoundation.org>
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

[ Upstream commit 74d7e038fd072635d21e4734e3223378e09168d3 ]

The values returned by the driver after processing the contents of the
Shunt Voltage Register and the Shunt Limit Registers do not correspond to
the TMP512/TMP513 specifications. A raw register value is converted to a
signed integer value by a sign extension in accordance with the algorithm
provided in the specification, but due to the off-by-one error in the sign
bit index, the result is incorrect. Moreover, the PGA shift calculated with
the tmp51x_get_pga_shift function is relevant only to the Shunt Voltage
Register, but is also applied to the Shunt Limit Registers.

According to the TMP512 and TMP513 datasheets, the Shunt Voltage Register
(04h) is 13 to 16 bit two's complement integer value, depending on the PGA
setting.  The Shunt Positive (0Ch) and Negative (0Dh) Limit Registers are
16-bit two's complement integer values. Below are some examples:

* Shunt Voltage Register
If PGA = 8, and regval = 1000 0011 0000 0000, then the decimal value must
be -32000, but the value calculated by the driver will be 33536.

* Shunt Limit Register
If regval = 1000 0011 0000 0000, then the decimal value must be -32000, but
the value calculated by the driver will be 768, if PGA = 1.

Fix sign bit index, and also correct misleading comment describing the
tmp51x_get_pga_shift function.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 59dfa75e5d82 ("hwmon: Add driver for Texas Instruments TMP512/513 sensor chips.")
Signed-off-by: Murad Masimov <m.masimov@maxima.ru>
Link: https://lore.kernel.org/r/20241216173648.526-2-m.masimov@maxima.ru
[groeck: Fixed description and multi-line alignments]
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/tmp513.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/tmp513.c b/drivers/hwmon/tmp513.c
index 589982c92190..23f7fb7fab8c 100644
--- a/drivers/hwmon/tmp513.c
+++ b/drivers/hwmon/tmp513.c
@@ -178,7 +178,7 @@ struct tmp51x_data {
 	struct regmap *regmap;
 };
 
-// Set the shift based on the gain 8=4, 4=3, 2=2, 1=1
+// Set the shift based on the gain: 8 -> 1, 4 -> 2, 2 -> 3, 1 -> 4
 static inline u8 tmp51x_get_pga_shift(struct tmp51x_data *data)
 {
 	return 5 - ffs(data->pga_gain);
@@ -200,7 +200,9 @@ static int tmp51x_get_value(struct tmp51x_data *data, u8 reg, u8 pos,
 		 * 2's complement number shifted by one to four depending
 		 * on the pga gain setting. 1lsb = 10uV
 		 */
-		*val = sign_extend32(regval, 17 - tmp51x_get_pga_shift(data));
+		*val = sign_extend32(regval,
+				     reg == TMP51X_SHUNT_CURRENT_RESULT ?
+				     16 - tmp51x_get_pga_shift(data) : 15);
 		*val = DIV_ROUND_CLOSEST(*val * 10 * MILLI, data->shunt_uohms);
 		break;
 	case TMP51X_BUS_VOLTAGE_RESULT:
-- 
2.39.5



