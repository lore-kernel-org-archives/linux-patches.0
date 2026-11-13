Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591637;
	b=l77C2JO8++W0PmARS8V1YHU/wilA8bySBwSQ1sXWKjF9tV5WLqUIxge7k5WOaOdP1ttS
	 MY8gbHNZiaJiFKsu5TkptrJMrnCFXLiq4itnL7jLOha1xBbXo4bHE/grcuCNxSfD3b8ge
	 qCV0pxy4BTqKWgHROXx9j+bQ5PkEq6FvsKXTxypOiXu1R0R0UZkv8NEs+F6ouzbwd2HSW
	 U6ma5yuUYCfWxSaglPDPppmb4Ht7wDWn8ERvvAK85h5zCjeuOpnT26UiRZ/OwhUfHpNHk
	 nwLvyPvolakj1Gy6hW/+jfPJKHfv9OcgyC9NVUubgGtyfN9zzK/6E/PrvxqumAtjLtA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591637;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RbU61EvacC/nSt7pgXfaCp7ritX6Ry8oKKTpKSh+Tkc=;
	b=b7BTva3RCc/5b42MDtu5oq1a+39Q8hr3N7rY4gfQ1A47fd3cuVEwKzBLt7o4wYalcMag
	 dl69GKJMaOimb8pWZn8blemdG4WL+8Yq1NBOE2mgvqpOfOmm+NXkyv0dV22Fans53uU2q
	 llSNQHAQTSd1n2jc06p1AyC3x3mCa7Vyj0gCoJk9iKmm7N1i6StqEcQpY1MBZ0FwJtbGE
	 cvAYmDSFX9WKJ6aHdGYCb3Skkh4b+OqgSi72pWX5hECwTrsqTLp+RCfgn98De6SeNVGwL
	 QHxqLn86a8H4HB3FB63xvqz5fpg75rkseW4mRkXO6+a4/z0EQPCNQJiMbe5q8Y3gTAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=adstvvzy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAE71606B45C;
	Fri, 13 Nov 2026 17:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=adstvvzy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 674EE1F000C6;
	Fri, 13 Nov 2026 17:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591637;
	bh=RbU61EvacC/nSt7pgXfaCp7ritX6Ry8oKKTpKSh+Tkc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=adstvvzyS8bgr7n/FsU5t+0/TBMbr215axmE5OFUuc5PEamcQI+TN7/230J06pzXN
	 I2EC/3CJ8Bu7LB7FY6vWNETmaPJaa4nfVSFmDMOpgIpgvk6q1KrgT6ek9m4VV8sYdf
	 Of4LngrO/IvM3eN6Dw4JNeAbtYDp8neXqyocQwNI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 656/670] power: supply: ltc2941: Fix of_node reference leak in ltc294x_i2c_probe()
Date: Fri, 13 Nov 2026 10:53:40 -0500
Message-ID: <20261113153834.139457046@linuxfoundation.org>
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



