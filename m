Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590777;
	b=O16SUWcPFNpyEp0yscz1VvbgHjAFLhMg0GGbdkjXsMfdDHHtbVrkV9TwfwgHBwEoGp07
	 vCes+i4uZLMLGNxHZRLoOcxcE6x95b52sZeXX4fa+vLHOhlZKUnOpPxcmFs+Yv3Muna9x
	 zIFnSA38RfxPr2bFrZlO7ewI2P8HWpmivSgnrhPS06qRxMtYlOJHPYH2TVNEOBjRyDFMK
	 NTBrWoIXhFbx4Knb5Q+zChwhARAVFZ9YdPM8qKcXzJktFE/I7UXdSahTc0iwak+dKBxWi
	 KDROalkG+J9wdfW76GX99O2dybn4akrsoDM4Ca72pn8DCBES2dylXsBzNdoEomz272w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590777;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YfFQqfX/X3rPTgBcrydV2FQrc1GkG04x5oZZM9ubzxc=;
	b=z2JPYD1UdBJ15p17Qw7E6LtXccVeNW03AlFhOrQ0JMXC1VPZts0ZvydPz9n2x2zNyjNN
	 1JF+e7gvajT4kXM8hKH8cli4BymnkWPl4nonM/OunvqxXmosI32W3ov+RnqjVvVR1rQOg
	 A87qptwh5DUGBXiUCSoafrW1Yu7WfcBKi36LcLR7gciC991NnCajVZSMqji5Sm8s3ZWCa
	 FNQMGdG6wJvemK/qZ7fRckeRtjm7cKjPXVg2A3Zvb0FIHTxvTpwSXHp+okJ9TjrYDAj41
	 KC+bmB30yxQBl2KjOiceAO7aaHZSlg/bNdvbZQ8mkBtn7KSxFIIcEIEh4pQ3d7RJQhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CJdmu2wQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59EF3607C356;
	Fri, 13 Nov 2026 17:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CJdmu2wQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0639F1F000C4;
	Fri, 13 Nov 2026 17:26:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590777;
	bh=YfFQqfX/X3rPTgBcrydV2FQrc1GkG04x5oZZM9ubzxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CJdmu2wQL9Gf89zNN/9nXcY0oxzcBVt7tnIEpLdxI7ClAloyGchRvHmcXgc2YxTSV
	 VKNtx4dspT0oEFyLYpU0ppTUWY3CaPM/ke3TLCyurQDEgBfitkqwNYPwofHNQqy27P
	 DVL5jdhRFJell3NOc4EgscUp/bMz4fYVNrF2/UWw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 673/686] power: supply: ltc2941: Fix of_node reference leak in ltc294x_i2c_probe()
Date: Fri, 13 Nov 2026 10:53:26 -0500
Message-ID: <20261113153844.476532243@linuxfoundation.org>
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
[ sashal: adjusted context to preserve of_property_read_u32() instead of upstream's of_property_read_s32() ]
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



