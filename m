Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054180;
	b=adyQXMyvbY1ST1m2VcibDh0Qb9dZTs8yIzgceXEPqWDM9c6BEGIBhbeWzGMTZ1BaOHPL
	 rT7cEa3+0Of0Qb3Q8f3Uiq5F3xn3MTNIINGcNedX1WQKW8N041yKWqHiqjZ4YUwD8/AsI
	 WJfwtDug1umRvv75jxMqcvKYNSIk0Hwi+n3le1YuQp1ZJGfXKN4HG+g6/blcByzc5/lBo
	 RjeckoVAGQMspaQlOtGfUhzYlN6PUOp1TK8VKQm5Qm4xxtg4mB2RvnCGab/UfBQ4BJtjU
	 yIyr7cRQhWkjz+2dDAyRjCz63mhvO7DqqOz5kmHEuX9oNpIsjs/zxjww2XnsWrIX/ZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054180;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=i1jIySBxM/iwtk7yX4KCjc4sQbueV1YA4yvYqj73vCU=;
	b=IwzRrC4cUvnXAXEhD10GQUcdg3rLKcaQ9W8zZswY5GTD5fqIVHJ3VQryXlpieJ5ZGX1F
	 CDuwzHLov2oW746a/qT8jEdCxn2gPnyqic+spD+td+vOTdvuq2glsSmJs57fzsOw4VL/d
	 UZzPw9OtETnG68mFiZL0slqdpVnNVlfHsDUn8kQtga3ZgZxG8/4St7RuYgNbb1qBPcjnt
	 M2l+fI3ME8UNNpRvohcKvzrbdSH65bU4KtLBnExDSyS0wdqnkkVKztXHZwWN46BuDL5mi
	 /tovxPRB/ESSCxEA2dZnZTtnWA+SF9E9nS1b6ZofP9Pa1mkySmhdM5BMiQgdEUOizew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=syG5AXdy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDEE8606A320;
	Thu, 19 Nov 2026 02:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=syG5AXdy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F0F91F000C5;
	Thu, 19 Nov 2026 02:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054180;
	bh=i1jIySBxM/iwtk7yX4KCjc4sQbueV1YA4yvYqj73vCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=syG5AXdy9+Rqmr86vSWTZVtvcQVD5Wj+34ArJBGs0YUHqgEMi8sGkaYKxtvJRBVZi
	 3G1TCAJo9Nqpk8EOdTeRoSQ3/gngg2C36Q4KWE8oo2/FwzlZArfqb1wO8ALR8aKdS1
	 bXQQEgF9SDlGORFOYeHWVOCf48T0LJJfjF1VCPBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1183/2214] power: supply: ltc2941: Fix of_node reference leak in ltc294x_i2c_probe()
Date: Wed, 18 Nov 2026 15:47:39 +0100
Message-ID: <20261118150059.260073790@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Adjusted context to retain of_property_read_u32() and separate dev_err() logging and return statements. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/ltc2941-battery-gauge.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/power/supply/ltc2941-battery-gauge.c b/drivers/power/supply/ltc2941-battery-gauge.c
index 09f3e78af4e01..5df89557456aa 100644
--- a/drivers/power/supply/ltc2941-battery-gauge.c
+++ b/drivers/power/supply/ltc2941-battery-gauge.c
@@ -473,6 +473,7 @@ static int ltc294x_i2c_probe(struct i2c_client *client,
 	 * instead of the sense-. This results in reversed measurements. */
 	ret = of_property_read_u32(np, "lltc,resistor-sense", &r_sense);
 	if (ret < 0) {
+		of_node_put(np);
 		dev_err(&client->dev,
 			"Could not find lltc,resistor-sense in devicetree\n");
 		return ret;
@@ -487,6 +488,8 @@ static int ltc294x_i2c_probe(struct i2c_client *client,
 		prescaler_exp = LTC2941_MAX_PRESCALER_EXP;
 	}
 
+	of_node_put(np);
+
 	if (info->id == LTC2943_ID) {
 		if (prescaler_exp > LTC2943_MAX_PRESCALER_EXP)
 			prescaler_exp = LTC2943_MAX_PRESCALER_EXP;
-- 
2.53.0



