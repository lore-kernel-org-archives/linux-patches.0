Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037637;
	b=xDh6SzJpycnhkMa89KXgNMdWe6SH2bF09G0bMZj+aM+G7g3JdI2NhJXv+FPTBizxFtGL
	 5Fi+rziuy5R3c5Q6VG/JIfbppOD2vyZl07wsUOylMk+961jPcHu2dkMJR7y7Lm+npfUkn
	 3CfITCakgdCRB+0Ia00Gv8rdJlJTibBYPZcOjMaSH0oNckVysY11BIMNLxYK5JX9yrAw2
	 b10Pgwx/BKskerJmVCJWMBw1nrgVsiTpIR08IZ6cdR/rWC0TQ+zxaGnIBH62uM0qvDWQD
	 X9qR6nuWSPlBtTRIsrjNLKo+1v1/UkX9v737Cp0huH/brp8kdZ9X95z+XRgQYU7bwEg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037637;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/JVcSnLZaIeKEyKeCtxgbbjCrlNqUxKCDMGPL+MXy30=;
	b=3JI/c7WwnOmusDiZdKMDXa3FYY/+YT58n+EgtHC/OiYiWkQnwdRtNRJy3lTwm4LEKTwT
	 +xBxc7sOt307dbSJ79YbaRndWi66ziATjQZixBaKHbRj4OGreLn7D0ZwAvGV8jPFUe5L6
	 JZWAh8lecX2dPtadT7yY/8VOPRk/qlSmSQrKrh0Mod1cNURQLiwaFnPkpnEBmMhWBg9SJ
	 cx6pM8f+16lPFRX4+t9+4CBrPenPFn2VBWdKwsIMVLMwd9wxaYWnOkk/dKYj9n8PIyrdS
	 nZB/G9CNtzq+QlSKQ+rWuzF+tyGm9nii9896ASa4RBIOHnLzM1hB5Z9Y751Oabv/D8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="t7e/rhJo";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAA24606A31C;
	Wed, 18 Nov 2026 21:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t7e/rhJo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4612B1F000C4;
	Wed, 18 Nov 2026 21:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037637;
	bh=/JVcSnLZaIeKEyKeCtxgbbjCrlNqUxKCDMGPL+MXy30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t7e/rhJoxfEHS4rCQMwZGhgS0CSp2I9p2pvvvzaa4HD+bIdoitr/vsWEdblbHknUJ
	 CYqtpGPUgY7gK5Msn6BI25PdU4khaJndQwPiO/uyYzoGSWqXR/zMWQqIfu4OknRj77
	 Pb1Jt/ejseIvZO/7DzM10bpVHJDFeOxn+ByGDujo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1465/3318] hwmon: (pmbus) Fix return value check from thermal zone registration
Date: Wed, 18 Nov 2026 15:34:47 +0100
Message-ID: <20261118150404.841707524@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 4fc79634af8cdf734e0a633923ba4817e30d29ad ]

The PMBus core used to call devm_thermal_zone_of_sensor_register()
to register thermal zones. Commit 613ed3f676092 ("hwmon: pm_bus: core:
Switch to new of thermal API") changed this to call
devm_thermal_of_zone_register() instead. The code subsequently checks if
the call failed because the thermal subsystem is not configured.
devm_thermal_zone_of_sensor_register() used to return -ENODEV in this
case. devm_thermal_of_zone_register() returns -ENOTSUPP. The code currently
still checks for -ENOVEV. This results in driver instantiation failures if
the thermal subsystem is disabled.

Check for -ENOTSUPP to fix the problem. Keep checking for -ENODEV because
this indicates that no thermal zone is configured for the sensor, which is
acceptable for the driver and must not cause a registration failure.

Fixes: 613ed3f676092 ("hwmon: pm_bus: core: Switch to new of thermal API")
Cc: stable@vger.kernel.org
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/pmbus/pmbus_core.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/hwmon/pmbus/pmbus_core.c b/drivers/hwmon/pmbus/pmbus_core.c
index 4212fbd63e7bd..5500f1827ae68 100644
--- a/drivers/hwmon/pmbus/pmbus_core.c
+++ b/drivers/hwmon/pmbus/pmbus_core.c
@@ -1352,10 +1352,11 @@ static int pmbus_thermal_add_sensor(struct pmbus_data *pmbus_data,
 	tzd = devm_thermal_of_zone_register(dev, index, tdata,
 					    &pmbus_thermal_ops);
 	/*
-	 * If CONFIG_THERMAL_OF is disabled, this returns -ENODEV,
-	 * so ignore that error but forward any other error.
+	 * If CONFIG_THERMAL_OF is disabled, devm_thermal_of_zone_register()
+	 * returns -ENOTSUPP. If no thermal zone is configured for the sensor,
+	 * it returns -ENODEV. Ignore those errors but forward any other error.
 	 */
-	if (IS_ERR(tzd) && (PTR_ERR(tzd) != -ENODEV)) {
+	if (IS_ERR(tzd) && PTR_ERR(tzd) !=  -ENODEV && PTR_ERR(tzd) != -ENOTSUPP) {
 		devm_kfree(dev, tdata);
 		return PTR_ERR(tzd);
 	}
-- 
2.53.0



