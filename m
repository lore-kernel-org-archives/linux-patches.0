Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046340;
	b=tOxfDfBTcZouRBghfPPe081q83uTr8fUQADg/V3U7cfMid2Iy9hPhqf1TRE5JNsTZNIW
	 P/PjYKvpO5jxSCPLiRE4EFgR+U/EaniYVq5hj2+mpNYBKGrfNG0Lm8kRPGiOSQ/wszXQO
	 HxxcX15rTgGbyV15Fq9Wyx33IbEdsgnVR1457DrWRk14GpXf3kbBRcQWBzGOOXTA8Npkg
	 NaqeN27hPv0d/fpquT1saKoy51K29Gf08xTCXJzuyoSD4BzJxkcsafm/1dj+63OBUsI1s
	 QjKXyQZXI7dMKow2Y48Y34Nt1lXido/+SCDug869NBjD63dtHt7/I4CSeK3xY1JFYJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046340;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3pWkQFiTMQdLD8G0qXCMgqIV49fen6os+JKFVZMNDN4=;
	b=cTy+7J84EMiokvNuaHHR+HVA3hyCNZ/zJ7N/nX9b432Sdej6F9yEDuwEOHB0OcFsSobh
	 OEMGJpoSiOOwdfSdBov9FpQ4sjrAI4JXf9Wwo+sdS8kMDYEZCiWXzMYmKQHTbTPu/Uylr
	 1u+GCBmbHBX19pZH1/1Nj1BLpUOidkhMf05ld7gJoTzYMyY6Bm5z0p2NwNAnYtyVOlHtR
	 A4XuGdsGLrbsJ5d/FKwU3CkUkvqpp20yNF859L0h92Lz84vvyVTQPCJAVsWQJ8DZqzWQn
	 4CydgBrIR3EOSVAY63ygr6jHTtm6Cx0BkaEaYi36f2NjQL5Vuh7kfa57glEstLn5XGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eAQiKJxS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06C30606A31C;
	Wed, 18 Nov 2026 23:58:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eAQiKJxS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 227B61F000C4;
	Wed, 18 Nov 2026 23:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046339;
	bh=3pWkQFiTMQdLD8G0qXCMgqIV49fen6os+JKFVZMNDN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eAQiKJxSvrT/gMcd6KddBkpw+3t9J8yU9vBxBsQ7OBXUOK6XaXBptVl4vDx8R4HYx
	 oM/hJ8OWpZaTMFh86MdgzDRALSJmV93MWLja5eSeGHENJwuu5PlPfj9TyCY4VTBIdG
	 Am8/5XS50KIO492sPgPP6lgWPIT0Je6ukhiYH86M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1244/2857] hwmon: (pmbus) Fix return value check from thermal zone registration
Date: Wed, 18 Nov 2026 15:37:58 +0100
Message-ID: <20261118150246.339288667@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index fd7d353e99762..4328978228c18 100644
--- a/drivers/hwmon/pmbus/pmbus_core.c
+++ b/drivers/hwmon/pmbus/pmbus_core.c
@@ -1325,10 +1325,11 @@ static int pmbus_thermal_add_sensor(struct pmbus_data *pmbus_data,
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



