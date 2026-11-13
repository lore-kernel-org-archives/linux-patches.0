Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585613;
	b=MSCSnNoFsYrW9x7WX9xUOYrGUTJQa5Z0sj6n3FpMQoerBDnyFF9sU2mRf5K8alqEilCp
	 Wyzcwq45DkJNdDFhYrpPgAgzPj9uRGbV+Gw4Xh1dp1yy6VjEAfh/5wkOPAnSNABh7PeFu
	 sfvjSvFNhpMzhRLhp8l+JuDuHg+5YB2Rv9fgSgWZQWVK2Uh1d66fdwbpyIGr/I7q9pMGh
	 UZUE7ke3e5CmKqJS1BMVJIlmkTNwrytgKDcFU+isRzMtyAcaRMES/1MAnWCm5dEM5bdqU
	 oJQwN0kJWDuakatW0YykMgqx1xR59LGqahchMcevLR50Aheropyx8mV7cl724e3FcFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585613;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=04g4gHtrU8l5WibCSZicGsP+jHDs+SRIzdpxb2zVRLI=;
	b=2+2zdWMkqYALZDgM2Qt0gD2pn/DIzHDC/lp2raUJVkf38rJNacG5P5v1utE3yijKKXgP
	 LnlzMuNpDUPOj5cSmWvQ/DF4KLRkSoRmNfrTVsa9LVyQZHczOWdfftI83jrplrd660RaS
	 WNEydEF/qDXO2tgoJ0FMJuaO4YcQ07nSaB/MmquAYRDvZvN4sc0wWRsXBJF6r7IRFAb/z
	 uCh5bgJGvoAEMSekK+cQAmG8xSy388UnpT/bww1j3moDPAJxya9RaTC/V8rsXfPlO+a6s
	 F+gT0gMzin9EW9FAhIxASW1mTS8DXHXFZwtOLuHWOOHnYXE1rvL1bxPCO3cmuz601DQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DEQorcl5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E45A6070221;
	Fri, 13 Nov 2026 16:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DEQorcl5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE40F1F000C4;
	Fri, 13 Nov 2026 16:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585613;
	bh=04g4gHtrU8l5WibCSZicGsP+jHDs+SRIzdpxb2zVRLI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DEQorcl5nEE6lANJ79sQFWICtNkVludys4G54XcKvsGIQDMngpkyCsuBMbI4vC3BG
	 XqWscibsC8T7iCU4AWkdVCspzPwEqX3tquG3BAeOy/jXNdCmcikdvo4oMxOXUmfG/S
	 v4TlY4NHnw+Wza762ky+84tmYJyFFcuxwZJkZayA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 194/507] hwmon: (pmbus) Fix return value check from thermal zone registration
Date: Fri, 13 Nov 2026 10:48:18 -0500
Message-ID: <20261113153801.075771526@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 5534717ba5f7a..b033bd3b1527b 100644
--- a/drivers/hwmon/pmbus/pmbus_core.c
+++ b/drivers/hwmon/pmbus/pmbus_core.c
@@ -1507,10 +1507,11 @@ static int pmbus_thermal_add_sensor(struct pmbus_data *pmbus_data,
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



