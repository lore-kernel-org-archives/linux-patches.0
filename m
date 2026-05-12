Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 594F43DD874;
	Tue, 12 May 2026 17:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608515; cv=none; b=qoBGnLHn7oUcOy4oah7OQruPLCjPyk2QscE4ol2/kzHrVmaprMe2zpejC2D6iGSPMgp544gG5otqoCQCchtvSdY1xzf7hc67L5+FQj1SXZfGM/4lnkWFpHWiztxMbUlpDvUCTAVsdFK73Le0bXweiGmuGL6F4OzeQ+tEMZnJtDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608515; c=relaxed/simple;
	bh=Vwbc3bc0fvDKKjQPgDEEhVohjb626rmlJ/fb6KqdRUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eJlokSfNWbt/gJJJO8foQnVWJRKsgUMKd51nIsjAWIpzEl5Yc9XRJ+aqNmNDCDvxXbxGBSSAom8As5WaUUcCtIjxRPH3e1hD7NfIR8yWuj6Mrf5SHBlRALl1Qg8+CeB3fRn9WZGKmatCCZEjyhM+g9FCb9DgOi6XCsM9pJCd23E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jyj/SA5W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jyj/SA5W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E48F2C2BCB0;
	Tue, 12 May 2026 17:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608515;
	bh=Vwbc3bc0fvDKKjQPgDEEhVohjb626rmlJ/fb6KqdRUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jyj/SA5WOBIqC6HSmWBL1SgNWvPttjBUuqcB1ciHmxTapdiYtheXpH9TohLLsast1
	 MHz2cN7BQJrc49l8mOGeM8Luap2u4Q/ZwuV8omAGmgk7DFgV77jhvkmhyS7OAXsDX8
	 3myg5otXzTT2kPB06xf23CaP4OC5WAm1k9IhNf1Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanman Pradhan <psanman@juniper.net>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.18 108/270] hwmon: (ltc2992) Clamp threshold writes to hardware range
Date: Tue, 12 May 2026 19:38:29 +0200
Message-ID: <20260512173940.732360734@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -431,10 +431,16 @@ static int ltc2992_get_voltage(struct lt
 
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
@@ -559,9 +565,15 @@ static int ltc2992_get_current(struct lt
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
@@ -634,9 +646,18 @@ static int ltc2992_get_power(struct ltc2
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


