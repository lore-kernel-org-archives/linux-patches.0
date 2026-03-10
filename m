Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D88735AC23;
	Tue, 10 Mar 2026 11:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141178; cv=none; b=kujdV3XMu9oT4kpf0OD9gmjI25dcTDF08O5BIOISKcnEmXxOKbDhQ0eZGmZwzfCGlrttd+I9Me8s+GK6q18smRPXqnuiNKxM0VV2ouUthQVjQWT78vPJSUfgT34W0rY8qbYXJItL/nQXRpu0yRPYBy3HSXFky0i2jyQavQvTV1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141178; c=relaxed/simple;
	bh=Wxiaey9WybPipa/SCX1rtUYBlCP/8U7BCLtd+s5Ytr4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rFXCt+DAkpDBLil8lclVzOvyQPEdH6aLjIXsUqkAGzlE+UXbd67DzKbErSLvK5kmasQHo2TpxFF1q0Ukwqk3kRaZBkUdNpnB3ziIOZCItanbgI5EBmJ0mcZ9w1iZigWmE0JSDmD48EnHGdIgyIHrtnG4wt+rOwbJ14SxeAoeEsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LVslVslS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LVslVslS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E5A9C2BC86;
	Tue, 10 Mar 2026 11:12:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141178;
	bh=Wxiaey9WybPipa/SCX1rtUYBlCP/8U7BCLtd+s5Ytr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LVslVslSVQmkxW4/RePJIR/3HGTn664/rTLzDn3LjbbqdIhdH5CHzuYSt0PHXvubU
	 0U4zdpimz8TNvlr1yMRaHlrX3aQk2h8iBDIHhVSyj3pUYhxBcz8SDpXGD7YJmbdZ/F
	 QrWrHKhhZ0uz24oJ8J9iiNHqEH2Sf7gmJ75ALUeNl6VVGL4QMzPXTOBAm0/lEAVi5K
	 AGNs/AkbEksWXsp3HyWLSZlov3MZq5GvCmhh2flNS9EKFV+6tIc5Vdf2ke66YFqYru
	 MWu0gP2OD5CeDPjL1BxpWDU/ADXBlvq9pe0OgZMhiMxB765IiGua0s8Ru04LKwh2gv
	 lwSFp2VpBAGxw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Guenter Roeck <linux@roeck-us.net>,
	James Calligeros <jcalligeros99@gmail.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Neal Gompa <neal@gompa.dev>,
	Janne Grunau <j@jannau.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 179/311] hwmon: (macsmc) Fix overflows, underflows, and sign extension
Date: Tue, 10 Mar 2026 07:03:46 -0400
Message-ID: <f301e3217ef29d495cb5abf691b7ab6e507ae34b.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 579b86f3c26fee97996e68c1cbfb7461711f3de3 ]

The macsmc-hwmon driver experienced several issues related to value
scaling and type conversion:

1. macsmc_hwmon_read_f32_scaled() clipped values to INT_MAX/INT_MIN.
   On 64-bit systems, hwmon supports long values, so clipping to
   32-bit range was premature and caused loss of range for high-power
   sensors. Changed it to use long and clip to LONG_MAX/LONG_MIN.
2. The overflow check in macsmc_hwmon_read_f32_scaled() used 1UL,
   which is 32-bit on some platforms. Switched to 1ULL.
3. macsmc_hwmon_read_key() used a u32 temporary variable for f32
   values. When assigned to a 64-bit long, negative values were
   zero-extended instead of sign-extended, resulting in large
   positive numbers.
4. macsmc_hwmon_read_ioft_scaled() used mult_frac() which could
   overflow during intermediate multiplication. Switched to
   mul_u64_u32_div() to handle the 64-bit multiplication safely.
5. ioft values (unsigned 48.16) could overflow long when scaled
   by 1,000,000. Added explicit clipping to LONG_MAX in the caller.
6. macsmc_hwmon_write_f32() truncated its long argument to int,
   potentially causing issues for large values.

Fix these issues by using appropriate types and helper functions.

Fixes: 785205fd8139 ("hwmon: Add Apple Silicon SMC hwmon driver")
Cc: James Calligeros <jcalligeros99@gmail.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Neal Gompa <neal@gompa.dev>
Cc: Janne Grunau <j@jannau.net>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20260129175112.3751907-3-linux@roeck-us.net
Reviewed-by: James Calligeros <jcalligeros99@gmail.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/macsmc-hwmon.c | 28 ++++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

diff --git a/drivers/hwmon/macsmc-hwmon.c b/drivers/hwmon/macsmc-hwmon.c
index 40d25c81b4435..1500ec2cc9f83 100644
--- a/drivers/hwmon/macsmc-hwmon.c
+++ b/drivers/hwmon/macsmc-hwmon.c
@@ -22,6 +22,7 @@
 
 #include <linux/bitfield.h>
 #include <linux/hwmon.h>
+#include <linux/math64.h>
 #include <linux/mfd/macsmc.h>
 #include <linux/module.h>
 #include <linux/of.h>
@@ -130,7 +131,7 @@ static int macsmc_hwmon_read_ioft_scaled(struct apple_smc *smc, smc_key key,
 	if (ret < 0)
 		return ret;
 
-	*p = mult_frac(val, scale, 65536);
+	*p = mul_u64_u32_div(val, scale, 65536);
 
 	return 0;
 }
@@ -140,7 +141,7 @@ static int macsmc_hwmon_read_ioft_scaled(struct apple_smc *smc, smc_key key,
  * them.
  */
 static int macsmc_hwmon_read_f32_scaled(struct apple_smc *smc, smc_key key,
-					int *p, int scale)
+					long *p, int scale)
 {
 	u32 fval;
 	u64 val;
@@ -162,21 +163,21 @@ static int macsmc_hwmon_read_f32_scaled(struct apple_smc *smc, smc_key key,
 		val = 0;
 	else if (exp < 0)
 		val >>= -exp;
-	else if (exp != 0 && (val & ~((1UL << (64 - exp)) - 1))) /* overflow */
+	else if (exp != 0 && (val & ~((1ULL << (64 - exp)) - 1))) /* overflow */
 		val = U64_MAX;
 	else
 		val <<= exp;
 
 	if (fval & FLT_SIGN_MASK) {
-		if (val > (-(s64)INT_MIN))
-			*p = INT_MIN;
+		if (val > (u64)LONG_MAX + 1)
+			*p = LONG_MIN;
 		else
-			*p = -val;
+			*p = -(long)val;
 	} else {
-		if (val > INT_MAX)
-			*p = INT_MAX;
+		if (val > (u64)LONG_MAX)
+			*p = LONG_MAX;
 		else
-			*p = val;
+			*p = (long)val;
 	}
 
 	return 0;
@@ -195,7 +196,7 @@ static int macsmc_hwmon_read_key(struct apple_smc *smc,
 	switch (sensor->info.type_code) {
 	/* 32-bit IEEE 754 float */
 	case __SMC_KEY('f', 'l', 't', ' '): {
-		u32 flt_ = 0;
+		long flt_ = 0;
 
 		ret = macsmc_hwmon_read_f32_scaled(smc, sensor->macsmc_key,
 						   &flt_, scale);
@@ -214,7 +215,10 @@ static int macsmc_hwmon_read_key(struct apple_smc *smc,
 		if (ret)
 			return ret;
 
-		*val = (long)ioft;
+		if (ioft > LONG_MAX)
+			*val = LONG_MAX;
+		else
+			*val = (long)ioft;
 		break;
 	}
 	default:
@@ -224,7 +228,7 @@ static int macsmc_hwmon_read_key(struct apple_smc *smc,
 	return 0;
 }
 
-static int macsmc_hwmon_write_f32(struct apple_smc *smc, smc_key key, int value)
+static int macsmc_hwmon_write_f32(struct apple_smc *smc, smc_key key, long value)
 {
 	u64 val;
 	u32 fval = 0;
-- 
2.51.0

