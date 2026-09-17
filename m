Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7AC63BAD81;
	Thu, 17 Sep 2026 17:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665134; cv=none; b=BNy1qPtB+CzIwh5HBi+xnHjQiprbzktu0Rm2bubje1/pFlufm5ZIDZDaNtbBYYy1yF3BhfawSB5tPpupDBhbtI6j33pDec6mx3mKSKey9AiOpxu4HIS7if0c/mUJrLPlCYfbl+YBLTOk730Cmup4q9GCpyn7V3v9XGGtg9nXKWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665134; c=relaxed/simple;
	bh=h5mcHOT7sAJveR/NKxLlU4MUbc1qLLR1s4GwmKDNfMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UlpFq7Z0/a9N/3KMVL4hPaQwshcgP347kwqoYeSsnEFyCTlrqw/zhQuq65iFQyfGHYxGvIdewNr1IFKdYDuu6+g86goHkZXoFRJNNSyMNdDROBa/anN6SEpJi/yhllJsRReDmMNs5h+vFqIUVark0NfczzkTv6Qd7DTl6+BC4lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MLI2uVpV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MLI2uVpV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA7BA1F000FF;
	Thu, 17 Sep 2026 17:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665132;
	bh=Ys9yvrEXqzoWnEO31qhEsRGwYytEWVDO04XpOMDXA3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MLI2uVpVfdvB0ZgVAWBGuRrHEI0XBPpy9OHQS8j4pPlo9iyC+inbmTKXmVOqHw/lF
	 ViVaO+xbys5itZHQqCrRjAUf8wdVZYx8yrCD+pUJPtJ3SGx+JdT8GIsmZGkNoi5OAx
	 xusRCqQSNZsNJk+96QDP3SoDIKQF5tcFDXZq+LI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Wilken Gottwalt <wilken.gottwalt@posteo.net>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0560/1250] hwmon: (corsair-psu) Fix linear11 calculation
Date: Thu, 17 Sep 2026 16:05:55 +0100
Message-ID: <20260917151607.108259083@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit c6c4234928d2eb4f61fecb61067e612d9bdbd2ff ]

In corsairpsu_linear11_to_int(), the mantissa is extracted using bitwise
operations and cast to s16 before being shifted left:

static int corsairpsu_linear11_to_int(const u16 val, const int scale)
{
    ...
    const int mant = (((s16)(val & 0x7ff)) << 5) >> 5;
    ...
}

Due to C integer promotion rules, the masked value (which is always
positive) is promoted to a 32-bit integer before the left shift. As a
result, the sign bit is never extended to bit 31 of the promoted integer.

When the device hardware reports a negative temperature in Linear11 format
(such as an ambient temperature probe reporting sub-zero), the negative
mantissa is parsed incorrectly as a massive positive value. For example,
-1 becomes 2047, which scales to 2047 degrees Celsius.

Fix the problem by type casting the result of the left shift operation
to s16.

Another problem is left-shifting of negative values. In C, the result of
left-shifting negative values is undefined. Use a multiplication instead
to avoid the problem.

Also use a local s64 variable to store temporary results, change
the return value type from int to long, and clamp the final value
to LONG_MIN and LONG_MAX to avoid under- and overflow issues while
retaining as much information as possible.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Cc: Wilken Gottwalt <wilken.gottwalt@posteo.net>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Tested-by: Wilken Gottwalt <wilken.gottwalt@posteo.net>
Link: https://lore.kernel.org/r/20260804034811.2385506-1-linux@roeck-us.net
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/corsair-psu.c | 23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

diff --git a/drivers/hwmon/corsair-psu.c b/drivers/hwmon/corsair-psu.c
index 679fb30983465..01f6dfbf65da9 100644
--- a/drivers/hwmon/corsair-psu.c
+++ b/drivers/hwmon/corsair-psu.c
@@ -140,13 +140,18 @@ struct corsairpsu_data {
 };
 
 /* some values are SMBus LINEAR11 data which need a conversion */
-static int corsairpsu_linear11_to_int(const u16 val, const int scale)
+static long corsairpsu_linear11_to_long(const u16 val, const int scale)
 {
 	const int exp = ((s16)val) >> 11;
-	const int mant = (((s16)(val & 0x7ff)) << 5) >> 5;
-	const int result = mant * scale;
+	const int mant = ((s16)((val & 0x7ff) << 5)) >> 5;
+	s64 result = mant * scale;
 
-	return (exp >= 0) ? (result << exp) : (result >> -exp);
+	if (exp >= 0)
+		result *= (int)(1UL << exp);
+	else
+		result >>= -exp;
+
+	return clamp(result, LONG_MIN, LONG_MAX);
 }
 
 /* the micro-controller uses percentage values to control pwm */
@@ -271,13 +276,13 @@ static int corsairpsu_get_value(struct corsairpsu_data *priv, u8 cmd, u8 rail, l
 	case PSU_CMD_RAIL_AMPS:
 	case PSU_CMD_TEMP0:
 	case PSU_CMD_TEMP1:
-		*val = corsairpsu_linear11_to_int(tmp & 0xFFFF, 1000);
+		*val = corsairpsu_linear11_to_long(tmp & 0xFFFF, 1000);
 		break;
 	case PSU_CMD_FAN:
-		*val = corsairpsu_linear11_to_int(tmp & 0xFFFF, 1);
+		*val = corsairpsu_linear11_to_long(tmp & 0xFFFF, 1);
 		break;
 	case PSU_CMD_FAN_PWM_ENABLE:
-		*val = corsairpsu_linear11_to_int(tmp & 0xFFFF, 1);
+		*val = corsairpsu_linear11_to_long(tmp & 0xFFFF, 1);
 		/*
 		 * 0 = automatic mode, means the micro-controller controls the fan using a plan
 		 *     which can be modified, but changing this plan is not supported by this
@@ -291,12 +296,12 @@ static int corsairpsu_get_value(struct corsairpsu_data *priv, u8 cmd, u8 rail, l
 			*val = 2;
 		break;
 	case PSU_CMD_FAN_PWM:
-		*val = corsairpsu_linear11_to_int(tmp & 0xFFFF, 1);
+		*val = corsairpsu_linear11_to_long(tmp & 0xFFFF, 1);
 		*val = corsairpsu_dutycycle_to_pwm(*val);
 		break;
 	case PSU_CMD_RAIL_WATTS:
 	case PSU_CMD_TOTAL_WATTS:
-		*val = corsairpsu_linear11_to_int(tmp & 0xFFFF, 1000000);
+		*val = corsairpsu_linear11_to_long(tmp & 0xFFFF, 1000000);
 		break;
 	case PSU_CMD_TOTAL_UPTIME:
 	case PSU_CMD_UPTIME:
-- 
2.53.0



