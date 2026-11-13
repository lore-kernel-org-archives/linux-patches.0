Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590302;
	b=G1ghtZccNawqaqBbUvYFQt0mGU3qPQ5UZOoPeq4sRgqGVxiesLLBXcithB8FyybqhIq3
	 wZak6GqqoXMEiYEmrRIFrJtSzPF/IjuE23uekEZ4IVACUlMJx7Fp4i1TEkmpv2/r07bNK
	 9QIUyclwRRVNQsVVCGBm0HJxc8bn5xjeVSTnMxLsl9yf2qccTegL7sjDGEYOD9rrghOo0
	 dM26ETHYHP+euuvuXRauqi86/Fnxj+JPa7IbTfQaa8KyJ3Iekyd9UqPAgN2VTVdlHKThI
	 p3uWFX6n/KEZRETD/Bw1ywFIqmL664zxQSaFvVSM6EIOG3Q/onHo9pb3txJob+ZYihA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590302;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wLfD57pCQKpC8aPfvQq892VNclxbZbkzizYIvtUp80g=;
	b=LHGJkBQM5U4n1/MziiS0rANSUrFzYbP5/QhUPWppM9WFrRExia05zthB0wiUKlp1S9xO
	 r2HWNSPmFzDYA1r+N7y9MiBV9PCVchJJOYS03YlKkggMoxrlTxSONIdpjgUfdi2A06CbP
	 Y91sdtMLeBwfJnPxLYgw/uOrXgZwKBXlwP/GUgxSZpPdB+fjdyBSmXR27Qa2ZX1Mkayt/
	 55c2FBa6DMU/GhPPKPSXgvhuo7FtiSUMtNEfXRkp/DEj5aNeLMumzquxGxRsnbvv77Xf+
	 2ebxVSjmIphcS1ydxDaN0IB5ajU4NDcF0xIOVhUubt5ToSmuBUIB/2gn/4ndw6Duiqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=brW5yzn8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8068060A5BE8;
	Fri, 13 Nov 2026 17:18:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=brW5yzn8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 138BC1F000C7;
	Fri, 13 Nov 2026 17:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590302;
	bh=wLfD57pCQKpC8aPfvQq892VNclxbZbkzizYIvtUp80g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=brW5yzn8ghKOkv6l9fQQwkuqjWFZ+5yZzZGoz6CXfe2jS9DWATgY7pxWNJoXv+apx
	 lOLXf6Jrm6YFkiGm05Yvx4j197fChsMzQvqEtyrf46n/BJ/BZcFKnMXGsSGtC9ZjVv
	 ZIgxxNyvj/kfqooRYvFdw6XYn+BlAnZ0WR2BEdvY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 289/686] hwmon: (pmbus) Fix return value check from thermal zone registration
Date: Fri, 13 Nov 2026 10:47:02 -0500
Message-ID: <20261113153830.773137933@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 3f310c8e97012..acab5fdf108e7 100644
--- a/drivers/hwmon/pmbus/pmbus_core.c
+++ b/drivers/hwmon/pmbus/pmbus_core.c
@@ -1401,10 +1401,11 @@ static int pmbus_thermal_add_sensor(struct pmbus_data *pmbus_data,
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



