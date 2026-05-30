Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23BBA320CAD;
	Sat, 30 May 2026 17:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163627; cv=none; b=imSyVAEBpcpI9dwRBUy7djzgJ61ZqBjAiDnCLsewT4+ov4V6d+8RZ3ejqf0GvNJ13lacr3JK/S1rJ5I6eHp7+SN4sOkbEc4RGFAzXGbZ+Ms3dQ8fJCGg5SB/FZR8/cLAr2KdG69OuRXIdxXn852clQ5Y8EuZEuNEQz2ng5ilmpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163627; c=relaxed/simple;
	bh=nwgrrCyOW5Qa9SfByWM0kmDM9o7iA8mZkpB8ap4CrSw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tM0EOCllnsmVdW6IUKQaeoUQks2jDfqf1UsBuSKaZRy01U+0gbKhdZ2edmu+X+mUV8lRgX/IImHMX0D6Ez9uHvw9y7kcHkSJuXEUgB+lKm1cSUxu68Ej78Y2O8BJE7MlbCW1k0I3YYwyJ/A+0iAhmfQ/36cV/hAROK0PDqmsuDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qkSMSEmt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qkSMSEmt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 689A91F00893;
	Sat, 30 May 2026 17:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163626;
	bh=citVyiVQXZAXSkg0fp0w11Y0m26hGSF1XBz1htDLMjE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qkSMSEmtfflZjxVvHxi/9Y2jo9aaRUXTYz1lrUftO88k12Udt5DA7wNk8wscT9EXk
	 VygyVxuSrHU3FVNGABHX5iEF9eqAaFYrfxKlmPMzkCQq7KZjKrq5oF095T18Pa3SdE
	 0gSlJfliyFZhiZZjm1zOThOZpt9haP4Kiyk1PvpA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanman Pradhan <psanman@juniper.net>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.15 314/776] hwmon: (ltc2992) Clamp threshold writes to hardware range
Date: Sat, 30 May 2026 18:00:28 +0200
Message-ID: <20260530160248.684159488@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sanman Pradhan <psanman@juniper.net>

commit d6cc7c99bf1f73eda7d565d224d791d16239bb41 upstream.

ltc2992_set_voltage(), ltc2992_set_current(), and ltc2992_set_power()
do not validate the user-supplied value before converting it to a
register value. This can result in:

1. Negative input values wrapping to large positive register values.
   For power, the negative long is implicitly cast to u64 in
   mul_u64_u32_div(), producing an incorrect value. For voltage and
   current, the negative converted value wraps when passed to
   ltc2992_write_reg() as a u32.

2. Intermediate arithmetic exceeding the range representable in u64 on
   64-bit platforms. In ltc2992_set_voltage(), (u64)val * 1000 can
   exceed U64_MAX when val is a large positive long. In
   ltc2992_set_current(), (u64)val * r_sense_uohm can overflow
   similarly. In ltc2992_set_power(), the computed value may not fit
   in u64.

3. Register values exceeding the hardware field width. Voltage and
   current threshold registers are 12-bit (stored left-justified in
   16 bits), and power threshold registers are 24-bit. Without
   clamping, bits above the field width are truncated in
   ltc2992_write_reg().

Fix by clamping negative values to zero, clamping positive values to
the rounded hardware-representable maximum (the value returned by the
read path for a full-scale register) to prevent intermediate overflow,
and clamping the converted register value to the hardware field width
before writing. The existing conversion formula and rounding behavior
are preserved.

In the power write path, cancel the factor of 1000 from both the
numerator (r_sense_uohm * 1000) and the denominator
(VADC_UV_LSB * IADC_NANOV_LSB) to also eliminate a u32 overflow of
r_sense_uohm * 1000 when r_sense_uohm exceeds about 4.29 ohms.

Fixes: b0bd407e94b03 ("hwmon: (ltc2992) Add support")
Cc: stable@vger.kernel.org
Signed-off-by: Sanman Pradhan <psanman@juniper.net>
Link: https://lore.kernel.org/r/20260416215904.101969-2-sanman.pradhan@hpe.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/ltc2992.c |   35 ++++++++++++++++++++++++++++-------
 1 file changed, 28 insertions(+), 7 deletions(-)

--- a/drivers/hwmon/ltc2992.c
+++ b/drivers/hwmon/ltc2992.c
@@ -422,10 +422,16 @@ static int ltc2992_get_voltage(struct lt
 
 static int ltc2992_set_voltage(struct ltc2992_state *st, u32 reg, u32 scale, long val)
 {
-	val = DIV_ROUND_CLOSEST(val * 1000, scale);
-	val = val << 4;
+	u32 reg_val;
+	long vmax;
+
+	vmax = DIV_ROUND_CLOSEST_ULL(0xFFFULL * scale, 1000);
+	val = max(val, 0L);
+	val = min(val, vmax);
+	reg_val = min(DIV_ROUND_CLOSEST_ULL((u64)val * 1000, scale),
+		      0xFFFULL) << 4;
 
-	return ltc2992_write_reg(st, reg, 2, val);
+	return ltc2992_write_reg(st, reg, 2, reg_val);
 }
 
 static int ltc2992_read_gpio_alarm(struct ltc2992_state *st, int nr_gpio, u32 attr, long *val)
@@ -550,9 +556,15 @@ static int ltc2992_get_current(struct lt
 static int ltc2992_set_current(struct ltc2992_state *st, u32 reg, u32 channel, long val)
 {
 	u32 reg_val;
+	long cmax;
 
-	reg_val = DIV_ROUND_CLOSEST(val * st->r_sense_uohm[channel], LTC2992_IADC_NANOV_LSB);
-	reg_val = reg_val << 4;
+	cmax = DIV_ROUND_CLOSEST_ULL(0xFFFULL * LTC2992_IADC_NANOV_LSB,
+				     st->r_sense_uohm[channel]);
+	val = max(val, 0L);
+	val = min(val, cmax);
+	reg_val = min(DIV_ROUND_CLOSEST_ULL((u64)val * st->r_sense_uohm[channel],
+					    LTC2992_IADC_NANOV_LSB),
+		      0xFFFULL) << 4;
 
 	return ltc2992_write_reg(st, reg, 2, reg_val);
 }
@@ -625,9 +637,18 @@ static int ltc2992_get_power(struct ltc2
 static int ltc2992_set_power(struct ltc2992_state *st, u32 reg, u32 channel, long val)
 {
 	u32 reg_val;
+	u64 pmax, uval;
 
-	reg_val = mul_u64_u32_div(val, st->r_sense_uohm[channel] * 1000,
-				  LTC2992_VADC_UV_LSB * LTC2992_IADC_NANOV_LSB);
+	uval = max(val, 0L);
+	pmax = mul_u64_u32_div(0xFFFFFFULL,
+			       LTC2992_VADC_UV_LSB / 1000 *
+			       LTC2992_IADC_NANOV_LSB,
+			       st->r_sense_uohm[channel]);
+	uval = min(uval, pmax);
+	reg_val = min(mul_u64_u32_div(uval, st->r_sense_uohm[channel],
+				      LTC2992_VADC_UV_LSB / 1000 *
+				      LTC2992_IADC_NANOV_LSB),
+		      0xFFFFFFULL);
 
 	return ltc2992_write_reg(st, reg, 3, reg_val);
 }


