Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29B7415A842;
	Mon,  6 Jan 2025 15:51:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178717; cv=none; b=IBJ+66jMd2xPXe/PowxKPtQrr5Dsivh7YGTs+mx/CPFjT9O464ZFLlI3vKRCVhAf0J6DU9nu9A/6hgmc8Yc/9QGyvxDerOGY68nxKec/WLXXS4kdolZPchkHVvYo0x4cXanFYbQkvE4LPTnWCPuf4XQ0tuebqOBi1agIT7/aL4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178717; c=relaxed/simple;
	bh=Ep0XRBek6nv45cB8G4qARC2iCQJe67xq176for1FvKc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dCbUaDy4Tdit/qoHBKtYYCjDp0uPNnTOLvkR+n/zPYJG/B3NKOXRbFj+5fcMXfETvigjTrjb9MQyiiwVDbJAnP4TUmufSrr7vcKJfWNecC6npFzEAkZKHhnbWcHs1yew+ektlvFQ+k+0SLXWCbmayrnSUYXPPsh/6/8APYlYp7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D3ISBa/p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D3ISBa/p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E756C4CEDF;
	Mon,  6 Jan 2025 15:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178717;
	bh=Ep0XRBek6nv45cB8G4qARC2iCQJe67xq176for1FvKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D3ISBa/pHNb4cv1bQEesNTkNNseXl4JI7iSHa/AfVkTmSjGtR1V9Yl5mMG1Pps7gk
	 /hJ6B8mj+5EW/g2ODuhNoc256p6rgSr3F9qqJznOpsg5LQC+8hrdjeMAXFb72UT5ve
	 UKWc+Zw42wByyQjKvh33uwtt68Xp33u/iKfLw9Tk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Murad Masimov <m.masimov@maxima.ru>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 037/168] hwmon: (tmp513) Fix interpretation of values of Shunt Voltage and Limit Registers
Date: Mon,  6 Jan 2025 16:15:45 +0100
Message-ID: <20250106151139.864173193@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151138.451846855@linuxfoundation.org>
References: <20250106151138.451846855@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

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



