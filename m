Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038725;
	b=kWoOGjWfn8BcjPnTfaVojZmhbm9XXQvOT0qYxZ1JKxVXH8vLZRJrYwQXP6u5gXxkBpXl
	 /KfrMv3xqyHuBgtmVIte+5Lwpa2CLgW1VkEBSFt+1jfizh3V/cTuFgmvp6f0Ez5NSmgYQ
	 tN++S2UADMTMNTjzLtVmpbsQM2kOwn/w3jq3hSC9bDofBL/+c1eNmqKH6626ZAVR5W1+s
	 uoCXHGEhAJcndaFXToUMUK4rcNK7czzsY1xk64AfTo67ElUlh6Q/ey1gyqbjionxaWcWH
	 dj6lg3Iv09P5cQ9c0TfLt7QU7VxQuTn1K1150GhaPcfAUgYDI4Q1BaOdlV0k4R9EtZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038725;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=naMnKUMZOtTtff9K21T2YrUTln79QetUoIhc6u20ZqY=;
	b=GdRw6Abb3iE4aCEvo80NXHOo47HZXgGGh1md0FRJ3S7OrIPwfEiosj+kL+qIwljJdD8r
	 ZmfJP2PGHW/+o3iDNUxg02WYLI+IaCdFC6zlKPsAZbQ5ZfX/NvzFADS57k4Su/dJgX69E
	 2daibLFLVt+jWANLAHyUA5LeUSReq5mfvVcQAe9R4GL7ctQiFAeceOW7+D5Z6corsNT6c
	 OCvKlov8+wTa4tO18r88Lf5oOicZGNm3fVQh/BmzjCW8dpveeKTx0eyat+PlsQiRs2ydf
	 CsmWlmJVXSSfwnh2nt6VLNjO3l7+/DGiAvoHsDaaR821h/bxCLz4T6NNtEfVmGXEsAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E1vsNxE0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1DC7606A32A;
	Wed, 18 Nov 2026 21:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E1vsNxE0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E6651F000C4;
	Wed, 18 Nov 2026 21:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038725;
	bh=naMnKUMZOtTtff9K21T2YrUTln79QetUoIhc6u20ZqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E1vsNxE0yFekdAjyneKf9E3vbnZEUMykUZe7Iazsk+xSjQVPBRXwQWdg11uMsroGn
	 JRWoJ/vlxS/xt7xZMuLi1BQ+kPf4rmlPu8TpFryTNY7QwQrg/+FykRBOIszjAdq1qs
	 GBCnzB5JOJGBe1inMTH0+iPEwfcHNza0PsQzMbKw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1828/3318] power: supply: ltc2941: Fix of_node reference leak in ltc294x_i2c_probe()
Date: Wed, 18 Nov 2026 15:40:50 +0100
Message-ID: <20261118150416.702323086@linuxfoundation.org>
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

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit 09a29213bf15630e85a375478832b074b2cfc5c8 ]

ltc294x_i2c_probe() takes a reference on the device node with
of_node_get(), but never drops it, so the reference leaks on every
return path, including the success path.

The node is only used to read the battery properties and to set
info->supply_desc.name, so release it after its last use and also on
the lltc,resistor-sense error path.

Fixes: 085bc24d1553 ("Add LTC2941/LTC2943 Battery Gauge Driver")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Link: https://patch.msgid.link/20260917142127.2156568-1-vulab@iscas.ac.cn
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
[ sashal: adjusted context for of_property_read_u32() instead of of_property_read_s32() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/ltc2941-battery-gauge.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/power/supply/ltc2941-battery-gauge.c b/drivers/power/supply/ltc2941-battery-gauge.c
index a1ddc4b060ce4..bf0b268b10bfb 100644
--- a/drivers/power/supply/ltc2941-battery-gauge.c
+++ b/drivers/power/supply/ltc2941-battery-gauge.c
@@ -464,9 +464,11 @@ static int ltc294x_i2c_probe(struct i2c_client *client)
 	/* r_sense can be negative, when sense+ is connected to the battery
 	 * instead of the sense-. This results in reversed measurements. */
 	ret = of_property_read_u32(np, "lltc,resistor-sense", &r_sense);
-	if (ret < 0)
+	if (ret < 0) {
+		of_node_put(np);
 		return dev_err_probe(&client->dev, ret,
 			"Could not find lltc,resistor-sense in devicetree\n");
+	}
 	info->r_sense = r_sense;
 
 	ret = of_property_read_u32(np, "lltc,prescaler-exponent",
@@ -477,6 +479,8 @@ static int ltc294x_i2c_probe(struct i2c_client *client)
 		prescaler_exp = LTC2941_MAX_PRESCALER_EXP;
 	}
 
+	of_node_put(np);
+
 	if (info->id == LTC2943_ID) {
 		if (prescaler_exp > LTC2943_MAX_PRESCALER_EXP)
 			prescaler_exp = LTC2943_MAX_PRESCALER_EXP;
-- 
2.53.0



