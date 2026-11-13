Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591109;
	b=1w0BVdC3TtRroXtIBrjrwZugZ7alBhWN/iosSvx96MPVsoIfc1tgfFSERw9vDYu8ZhXE
	 rupHarPXzLzYLKq6CNkl/7DkFW9S7ru+1undBRtfmg3lXkW82GRB92pJa/oilSYFGkGiW
	 RGKKXDfiVW6B3uo7eUqIX33JBDvkg6WAmCmPCXhVg8eG7RTGJGZEylnCbMAxOPMiyfHI7
	 Zmosi47+XsQ0llaQrW4PIutQgxE/nZGPd1el1c1qdNoILAFDF94dwse2qi5NLsZ+1XLUG
	 KE0YnPCZ8twJsZr+yiQi/hQWamji+D1XK+roRjFendvtstAZy2PrncDJmr1z57fiAPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591109;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Hu4CSkp4CXuJm0/BfJaED2yxIf4+S10FkN9uZIVRsrI=;
	b=cKBCrbzMRRAzniFTSDHrHHprZGvKhhfhG5Alm4bs16PFufLTo81yZm5gGihCjJ1n8IVA
	 dfqKqW2j80cfAMn7dF0Vzvo6PmTORQM57SoMBSi7om2tia9dtgiDokCB0D905UVWXPjdm
	 jZC8kcv8bjqYLYBkYN6QRE+KODEnGPokTQhJI4TTaHpyje4YQvdCqjwQlZ/PhCg+TvHqM
	 DowVmqWO2JIczfT7FscuyynSD0zVLHABkTYFzS6+UF//NZmG5dmgfAOMnkvyRDhBp3tIL
	 yqv5DRE6hwykVc/ai3UOQUx9DJUI5tmX9o5Cct4UqXbgsRKlLGzQ8cTbsWwBM1WIJgw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SQR1dfit;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D819A606B36D;
	Fri, 13 Nov 2026 17:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SQR1dfit
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8400F1F000C4;
	Fri, 13 Nov 2026 17:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591109;
	bh=Hu4CSkp4CXuJm0/BfJaED2yxIf4+S10FkN9uZIVRsrI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SQR1dfitQkqybfKKFDw7Pm9JTjq1iz5Owv5o2dNvqduFM6oXJWMiOSFcsOH8Su7mR
	 gb/zp9CgqVjLMQtIsBhiFJ9pAF4lRD5mMjtRQtm+giJV92SyDV+mdjxl5NL4NBsUTw
	 9MoX8wVU+tXP6Kw1WVFGNoEp37iAtl9Zx1aaZQs0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 262/670] hwmon: (pmbus) Release devres allocated memory after devm_thermal_of_zone_register error
Date: Fri, 13 Nov 2026 10:47:06 -0500
Message-ID: <20261113153820.713155535@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 9aa6cc563e881c3cad96ea36926cadceee151f32 ]

In pmbus_thermal_add_sensor(), a devres memory leak occurs when a PMBus
temperature sensor is initialized but no thermal zone is configured for
it.
The function allocates a pmbus_thermal_data structure using
devm_kzalloc(). It then attempts to register the sensor with the thermal
subsystem via devm_thermal_of_zone_register(). If this registration
returns -ENODEV (e.g., when no thermal zone is mapped in the Device Tree
or CONFIG_THERMAL_OF is disabled), the function intentionally catches the
error and returns 0 to allow device probing to continue.

Because devm_kfree() is not called on the -ENODEV path, the unused tdata
structure remains allocated on the device's managed resource list. Since
most PMBus temperature sensors are not attached to thermal zones, this
results in an accumulation of unused objects that needlessly consume kernel
memory for the lifetime of the PMBus device.

Add the missing call to devm_kfree() to fix the problem.

Fixes: 3aa74796cfd0 ("hwmon: (pmbus) Register with thermal for PSC_TEMPERATURE")
Cc: stable@vger.kernel.org
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/pmbus/pmbus_core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/hwmon/pmbus/pmbus_core.c b/drivers/hwmon/pmbus/pmbus_core.c
index 989e861aaad65..d56173c00ada9 100644
--- a/drivers/hwmon/pmbus/pmbus_core.c
+++ b/drivers/hwmon/pmbus/pmbus_core.c
@@ -1423,8 +1423,10 @@ static int pmbus_thermal_add_sensor(struct pmbus_data *pmbus_data,
 	 * If CONFIG_THERMAL_OF is disabled, this returns -ENODEV,
 	 * so ignore that error but forward any other error.
 	 */
-	if (IS_ERR(tzd) && (PTR_ERR(tzd) != -ENODEV))
+	if (IS_ERR(tzd) && (PTR_ERR(tzd) != -ENODEV)) {
+		devm_kfree(dev, tdata);
 		return PTR_ERR(tzd);
+	}
 
 	return 0;
 }
-- 
2.53.0



