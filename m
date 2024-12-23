Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2999419E971;
	Mon, 23 Dec 2024 16:05:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734969954; cv=none; b=Ep2iaOkDQsCadP/UsZt6u16Bq1yIR/2mL9iB+6M4YQxz2UsX9emdZT1Flgp0qWtKuYk2WIYeLTPu+bkfHc14xPt6oqGBQvWnDMgmthiN25G25uk7rI3DWY7dWyTEeLDO/mTQgQ02qFo4Ckhmf8afi3hGeECF3FSgigfxTUa+ELc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734969954; c=relaxed/simple;
	bh=+BcYVThS4MoR0c8MRTmNATvdt0JoYu61GfXqloSnP/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b16ZVXJS3zAzlj6+WNphBv2aFlfSl4SQmL3MVFWU2PTT4LepPVw5dNNdb03tyhBa6DeqKJJxDneQyllUFI1ve/iTuTWS6V0Qekt/DY+54ViBXJv8k40Va1ulx6knn4SABGJ5HG4TvgeuE9WHvrY/dPTQ/9q+2gya3vNLe+frkug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tz+/AFzU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tz+/AFzU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A50B0C4CED4;
	Mon, 23 Dec 2024 16:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734969954;
	bh=+BcYVThS4MoR0c8MRTmNATvdt0JoYu61GfXqloSnP/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tz+/AFzUEigfIGV9YmZmMJc5xupodsmhJjI6TSHRxq38OO9TZFjaWuElpGT+D8chb
	 SS1NIADtmqbfoLkpr88PufSSMG3b4fzMYAcl3mhFLetsx36nlKJxLvL+OCR4AI8TSf
	 F+iTzX72vtJ+3vOFlVgcQy7hWf8d4DTFggxi6jXE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Murad Masimov <m.masimov@maxima.ru>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 101/160] hwmon: (tmp513) Fix interpretation of values of Shunt Voltage and Limit Registers
Date: Mon, 23 Dec 2024 16:58:32 +0100
Message-ID: <20241223155412.583330486@linuxfoundation.org>
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
index 926d28cd3fab..d87fcea3ef24 100644
--- a/drivers/hwmon/tmp513.c
+++ b/drivers/hwmon/tmp513.c
@@ -182,7 +182,7 @@ struct tmp51x_data {
 	struct regmap *regmap;
 };
 
-// Set the shift based on the gain 8=4, 4=3, 2=2, 1=1
+// Set the shift based on the gain: 8 -> 1, 4 -> 2, 2 -> 3, 1 -> 4
 static inline u8 tmp51x_get_pga_shift(struct tmp51x_data *data)
 {
 	return 5 - ffs(data->pga_gain);
@@ -204,7 +204,9 @@ static int tmp51x_get_value(struct tmp51x_data *data, u8 reg, u8 pos,
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



