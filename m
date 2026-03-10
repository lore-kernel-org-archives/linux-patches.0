Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 794CA2BF3E2;
	Tue, 10 Mar 2026 11:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141177; cv=none; b=ajZTe/6TNjLq2EZ+bZlCvALSYY9JhGgIqbG+G5GaKvU2Wqg0VExW6gw3C5+kXcPDedQIH5sg8vkiHmADim+1MEGTEgv7d4yYNsCKtd3Bhntb86V6BJc+Aici/UOlq6AzG5Tnl7L5ot9drqAc5SCzPDutRxi9JotfTP68xmbhf6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141177; c=relaxed/simple;
	bh=CNC3Op4/omaK5ZnLxnohxH4MGYWeJH4cXMjxEI7wQII=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hzfv+Q92P8FI3NYphZRZ489SqPK9b3oXbQf6JDAu4BSkZ7GMzp3MvoS4u7iYTrc9Jd6sz7svGiONfPsT2SB75RUWMxZBTVcbZMXlDWHEngNvxbrHTcd3Mg23pcTVMHpKSX64VmE2ExEsw2Pwnq0kLsgb37KJDtsbNmKgbFkLOcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ar74Jgxt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ar74Jgxt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 816F4C19423;
	Tue, 10 Mar 2026 11:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141177;
	bh=CNC3Op4/omaK5ZnLxnohxH4MGYWeJH4cXMjxEI7wQII=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ar74JgxtjOMiOHMwVl43LYJsyTMdt93rtsl0ua+e3XfgMGRnbxfaXQgfYXL6dpxoQ
	 FuzV9qWzBfWw6BWRsxXHqXm9JruJY3iaWKIq4r1HHn4XnYQ4AxE57xjERf6onlBIGU
	 Pm/QIpFCR8kVMochVmOp/+L/STWWdcrJWFZ7J8o8+oVSAmY6WRziKvdnQSTaQHpKTQ
	 a+RUFlT8C27Xyre/sTvty6GaW+QjR4SZVL8JeGoxRClZQbgwHglpV20R7BQY9Z/swW
	 aLyB6To0Cw1y1wPETXgAPOOd3oMj3uF/wGiSD7rQazThU/7ukWkuHpNI+7//Xa1O4y
	 /zM3StN/jrBXA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Guenter Roeck <linux@roeck-us.net>,
	Nathan Chancellor <nathan@kernel.org>,
	James Calligeros <jcalligeros99@gmail.com>,
	Neal Gompa <neal@gompa.dev>,
	Janne Grunau <j@jannau.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 178/311] hwmon: (macsmc) Fix regressions in Apple Silicon SMC hwmon driver
Date: Tue, 10 Mar 2026 07:03:45 -0400
Message-ID: <4f2b394eabcf94ef8a92c0fc1580c2c46cf6b8ea.1773140655.git.sashal@kernel.org>
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

[ Upstream commit 5dd69b864911ae3847365e8bafe7854e79fbeecb ]

The recently added macsmc-hwmon driver contained several critical
bugs in its sensor population logic and float conversion routines.

Specifically:
- The voltage sensor population loop used the wrong prefix ("volt-"
  instead of "voltage-") and incorrectly assigned sensors to the
  temperature sensor array (hwmon->temp.sensors) instead of the
  voltage sensor array (hwmon->volt.sensors). This would lead to
  out-of-bounds memory access or data corruption when both temperature
  and voltage sensors were present.
- The float conversion in macsmc_hwmon_write_f32() had flawed exponent
  logic for values >= 2^24 and lacked masking for the mantissa, which
  could lead to incorrect values being written to the SMC.

Fix these issues to ensure correct sensor registration and reliable
manual fan control.

Confirm that the reported overflow in FIELD_PREP is fixed by declaring
macsmc_hwmon_write_f32() as __always_inline for a compile test.

Fixes: 785205fd8139 ("hwmon: Add Apple Silicon SMC hwmon driver")
Reported-by: Nathan Chancellor <nathan@kernel.org>
Closes: https://lore.kernel.org/linux-hwmon/20260119195817.GA1035354@ax162/
Cc: James Calligeros <jcalligeros99@gmail.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Neal Gompa <neal@gompa.dev>
Cc: Janne Grunau <j@jannau.net>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Tested-by: Nathan Chancellor <nathan@kernel.org> # build only
Link: https://lore.kernel.org/r/20260129175112.3751907-2-linux@roeck-us.net
Reviewed-by: James Calligeros <jcalligeros99@gmail.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/macsmc-hwmon.c | 25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff --git a/drivers/hwmon/macsmc-hwmon.c b/drivers/hwmon/macsmc-hwmon.c
index 1c0bbec7e8ebc..40d25c81b4435 100644
--- a/drivers/hwmon/macsmc-hwmon.c
+++ b/drivers/hwmon/macsmc-hwmon.c
@@ -228,25 +228,22 @@ static int macsmc_hwmon_write_f32(struct apple_smc *smc, smc_key key, int value)
 {
 	u64 val;
 	u32 fval = 0;
-	int exp = 0, neg;
+	int exp, neg;
 
+	neg = value < 0;
 	val = abs(value);
-	neg = val != value;
 
 	if (val) {
-		int msb = __fls(val) - exp;
-
-		if (msb > 23) {
-			val >>= msb - FLT_MANT_BIAS;
-			exp -= msb - FLT_MANT_BIAS;
-		} else if (msb < 23) {
-			val <<= FLT_MANT_BIAS - msb;
-			exp += msb;
-		}
+		exp = __fls(val);
+
+		if (exp > 23)
+			val >>= exp - 23;
+		else
+			val <<= 23 - exp;
 
 		fval = FIELD_PREP(FLT_SIGN_MASK, neg) |
 		       FIELD_PREP(FLT_EXP_MASK, exp + FLT_EXP_BIAS) |
-		       FIELD_PREP(FLT_MANT_MASK, val);
+		       FIELD_PREP(FLT_MANT_MASK, val & FLT_MANT_MASK);
 	}
 
 	return apple_smc_write_u32(smc, key, fval);
@@ -663,8 +660,8 @@ static int macsmc_hwmon_populate_sensors(struct macsmc_hwmon *hwmon,
 		if (!hwmon->volt.sensors)
 			return -ENOMEM;
 
-		for_each_child_of_node_with_prefix(hwmon_node, key_node, "volt-") {
-			sensor = &hwmon->temp.sensors[hwmon->temp.count];
+		for_each_child_of_node_with_prefix(hwmon_node, key_node, "voltage-") {
+			sensor = &hwmon->volt.sensors[hwmon->volt.count];
 			if (!macsmc_hwmon_create_sensor(hwmon->dev, hwmon->smc, key_node, sensor)) {
 				sensor->attrs = HWMON_I_INPUT;
 
-- 
2.51.0

