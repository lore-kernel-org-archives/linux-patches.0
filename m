Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585558;
	b=Q49HG1+jm/kBdoTlzKo4VdH9dgm7CHCBNkLoq/Pa+p+3AS7q/Oo+WfU8KarA1BM28nxE
	 acLeZtt2N/J/Vw/AbDhNGAF4Wbw02NmOjygdbhpphjmCFI2GQttwpu8qISJItODjzZOR7
	 /32g3cVBxsKcwiLNq1UHSssuj6Q/l0a4tSsCBEhpZeBx/WutukMK0iDsllAafUu9lfnU/
	 JzyUy8nlrcMDblR9M4d7qPnVx98lvmyt/GYXbLyfyICyi/+Q5qDz3Q8z3lpKbUMCsm8OX
	 O0wGmdOlt2xB39pEpTMNnNjr/yVo/BgtOmz1wyt6w8K8Rt9J1CcvKIzRSojZ+0hYAFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585558;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=joukBtmOo5wO4WaEzkdyZBVtF1SsAyo8mTnfhVPwGvQ=;
	b=TuczQmY18OHtAEFTjVzBKPIO9hWRb3aOvpdw0VfcZ7vAO1uC0aHesGoQjBTEaI3I1Hvj
	 JcqFsr81Wkk8pz8zb7wTs6Gl564uPXMzi1uAy8lFaFOf+pPsSpkDS2/GBGucO4+tvkseN
	 mjKlKwTdZBp3acRLHtiNC6b+CUjXpCmzW85hpxlYZoFjjqDrJJUd71N3HkhOr906a3kq+
	 U0F4gHzeVZMXW2Dc/xWM7+6Vf0YtHq32RQdKLTh3oabfGWryGwxrVYdPOn2VhAfpzxXWx
	 w+i+K1Ubg8ZGR/xlSYWaIRMXcGy/PtAFwkYUjab15rqeo1dKw2WrDUEpl+xCLD/6IdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YCsTJchY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F575606BAA2;
	Fri, 13 Nov 2026 15:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YCsTJchY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AED511F000C4;
	Fri, 13 Nov 2026 15:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585557;
	bh=joukBtmOo5wO4WaEzkdyZBVtF1SsAyo8mTnfhVPwGvQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YCsTJchYuAM+ukQsnBYRppvh0SCibqRDmjMB0V5jzkij0gdaX7uhOD+E3kL9JI2Td
	 w5XSW30EYKvlfWudgMho533OGvLtqG7dVT0oku8vp643suJSyBcK5as5c/I8iZ0hZ+
	 CckWh2uFnL35vWCYgK3xhXPBS4XGksyNMzeZEZ1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 195/507] hwmon: (lm75) Fix setting polarity mask for chips with 16-bit config register
Date: Fri, 13 Nov 2026 10:48:19 -0500
Message-ID: <20261113153801.103023485@linuxfoundation.org>
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

[ Upstream commit 3897309ede38d7f3ff34c4c4583b1dd345666988 ]

When probing a 16-bit compatible temperature sensor configured with the
"ti,alert-polarity-active-high" device property, lm75_generic_probe()
writes to a reserved bit instead of the alert polarity bit due to an
incorrect bit shift in the 16-bit polarity mask.
On 16-bit sensors, the polarity bit is physically located at bit 2 of the
MSByte. When accessed via i2c_smbus_read_word_data() or
i2c_smbus_write_word_data(), the SMBus protocol maps the first received
byte (the physical MSByte) to the lower 8 bits of the integer
representation. Consequently, the polarity bit is consistently mapped to
bit 2, identically to 8-bit sensors. However, the
LM75_ALERT_POLARITY_HIGH_16_BIT macro applies an 8-bit left shift,
erroneously targeting bit 10. This causes the driver to silently corrupt a
reserved bit in the configuration register while leaving the active-high
alert polarity unconfigured, breaking the polarity feature.

Use BIT(2) as polarity mask in the configuration register for all chips
to fix the problem.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Fixes: 1be4001d9b9b ("hwmon: (lm75) Support active-high alert polarity")
Cc: stable@vger.kernel.org
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/lm75.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/hwmon/lm75.c b/drivers/hwmon/lm75.c
index 2d2d752aeac9d..917ac250a648b 100644
--- a/drivers/hwmon/lm75.c
+++ b/drivers/hwmon/lm75.c
@@ -123,8 +123,7 @@ struct lm75_data {
 
 static const u8 lm75_sample_set_masks[] = { 0 << 5, 1 << 5, 2 << 5, 3 << 5 };
 
-#define LM75_ALERT_POLARITY_HIGH_8_BIT	(BIT(2))
-#define LM75_ALERT_POLARITY_HIGH_16_BIT	(BIT(2) << 8)
+#define LM75_ALERT_POLARITY_HIGH_BIT	BIT(2)
 #define LM75_SAMPLE_CLEAR_MASK		(3 << 5)
 
 /* The structure below stores the configuration values of the supported devices.
@@ -770,11 +769,7 @@ static int lm75_generic_probe(struct device *dev, const char *name,
 	data->orig_conf = status;
 
 	/* Enforce polarity active-low (default) or active-high (devicetree) */
-	if (!data->params->config_reg_16bits)
-		pol_mask = LM75_ALERT_POLARITY_HIGH_8_BIT;
-	else
-		pol_mask = LM75_ALERT_POLARITY_HIGH_16_BIT;
-
+	pol_mask = LM75_ALERT_POLARITY_HIGH_BIT;
 	clr_mask = data->params->clr_mask | pol_mask;
 	set_mask = data->params->set_mask & ~pol_mask;
 	if (device_property_read_bool(dev, "ti,alert-polarity-active-high"))
-- 
2.53.0



