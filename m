Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC3D15F54E;
	Tue, 13 Feb 2024 17:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845370; cv=none; b=VaycIj4w5TJQK2MkQNkrz5Aatv9NemOuJgaKttIAWwEVL09+G0l8f4hRY0fWZAYz++dB/1u89s8iPajikE4nDFYJduahdBTD+79QTK8u669VpVjUf1o9nfTUAOfYjiUvNcHAe4p1gkDjxKI9FjMYqpFq80ixvvEba8h0Pv6wuOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845370; c=relaxed/simple;
	bh=llKe5h3+dPIwblvvUSUdYEgvpJlbocVaPYjSIbmE8So=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gESG5F4wFEli0lQxoSjvBuUPr4cuTxrjIScjVOwFX8Vo/O1/N7G2PTJtL6rsizd3cfpt2Dx5r34IcH8t11TKwHtSwhBPbg8+DSQCFq+RnpI1zNcH2mRmmBIoOY8+p1b34uc29GXCaeKUNTnDApF0F11CoR1vR5pWgvJ2Qr/jwDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PH7DplKZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PH7DplKZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EB7FC433F1;
	Tue, 13 Feb 2024 17:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845370;
	bh=llKe5h3+dPIwblvvUSUdYEgvpJlbocVaPYjSIbmE8So=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PH7DplKZrgHRiAowSD3ifFCwHkQjzrkcUNfrlJgvH+l4vfNH3b8cR+aYOMZQxvIEC
	 cljbdrk+n7uClPYLnMzCGxWRd+Mho8Rm+OB1+9bZyhI7ovyZERZfC5rE2QnXUF3Amg
	 QC5GvstMQV4M+wWDN7ksVLw6yLjHFo4FiBK/u5sg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Loic Prylli <lprylli@netflix.com>,
	Alexander Hansen <alexander.hansen@9elements.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 060/121] hwmon: (aspeed-pwm-tacho) mutex for tach reading
Date: Tue, 13 Feb 2024 18:21:09 +0100
Message-ID: <20240213171854.746214180@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171852.948844634@linuxfoundation.org>
References: <20240213171852.948844634@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Loic Prylli <lprylli@netflix.com>

[ Upstream commit 1168491e7f53581ba7b6014a39a49cfbbb722feb ]

the ASPEED_PTCR_RESULT Register can only hold the result for a
single fan input. Adding a mutex to protect the register until the
reading is done.

Signed-off-by: Loic Prylli <lprylli@netflix.com>
Signed-off-by: Alexander Hansen <alexander.hansen@9elements.com>
Fixes: 2d7a548a3eff ("drivers: hwmon: Support for ASPEED PWM/Fan tach")
Link: https://lore.kernel.org/r/121d888762a1232ef403cf35230ccf7b3887083a.1699007401.git.alexander.hansen@9elements.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/aspeed-pwm-tacho.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/hwmon/aspeed-pwm-tacho.c b/drivers/hwmon/aspeed-pwm-tacho.c
index 997df4b40509..b2ae2176f11f 100644
--- a/drivers/hwmon/aspeed-pwm-tacho.c
+++ b/drivers/hwmon/aspeed-pwm-tacho.c
@@ -193,6 +193,8 @@ struct aspeed_pwm_tacho_data {
 	u8 fan_tach_ch_source[16];
 	struct aspeed_cooling_device *cdev[8];
 	const struct attribute_group *groups[3];
+	/* protects access to shared ASPEED_PTCR_RESULT */
+	struct mutex tach_lock;
 };
 
 enum type { TYPEM, TYPEN, TYPEO };
@@ -527,6 +529,8 @@ static int aspeed_get_fan_tach_ch_rpm(struct aspeed_pwm_tacho_data *priv,
 	u8 fan_tach_ch_source, type, mode, both;
 	int ret;
 
+	mutex_lock(&priv->tach_lock);
+
 	regmap_write(priv->regmap, ASPEED_PTCR_TRIGGER, 0);
 	regmap_write(priv->regmap, ASPEED_PTCR_TRIGGER, 0x1 << fan_tach_ch);
 
@@ -544,6 +548,8 @@ static int aspeed_get_fan_tach_ch_rpm(struct aspeed_pwm_tacho_data *priv,
 		ASPEED_RPM_STATUS_SLEEP_USEC,
 		usec);
 
+	mutex_unlock(&priv->tach_lock);
+
 	/* return -ETIMEDOUT if we didn't get an answer. */
 	if (ret)
 		return ret;
@@ -903,6 +909,7 @@ static int aspeed_pwm_tacho_probe(struct platform_device *pdev)
 	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
+	mutex_init(&priv->tach_lock);
 	priv->regmap = devm_regmap_init(dev, NULL, (__force void *)regs,
 			&aspeed_pwm_tacho_regmap_config);
 	if (IS_ERR(priv->regmap))
-- 
2.43.0



