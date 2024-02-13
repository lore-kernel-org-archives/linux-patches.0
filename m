Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 617C5AD55;
	Tue, 13 Feb 2024 17:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707845740; cv=none; b=Ue4NyFwTjhra9/7ch41tDF2yq2bd8j0waMW4ItcRaU/7vCYgOx63+2zcuLai5dVtZ44MX9VL1nbb1tws0TXFq5BfLDbOFJAVldvLF3bzLy5VLs/5PxKy9f57dsnJqlgGkN4Nc3y0TAp7tNxF9H81zzsdFuOCBlH53CmyLsb+OkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707845740; c=relaxed/simple;
	bh=SaOv5pqg6XCQEEjnO+4K8fSK/GoMYzKol24M1UjBB+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rz0EwLOA2/G3lLhFprZG7pAjLKyWoWt2i3QuHmkZh1DFJr9wLJYrVbObjXQnvB4lVmvOEHTv74ghsXGEdz7KkbtNfPmmnq0eKJVit3v0qrZrulqxtqqjVWg0koQJQNuL6zI2Dts5AIzqISG788FQNpfQgj5YgE41igLczjLhMjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oVHAFSDt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oVHAFSDt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA39AC433F1;
	Tue, 13 Feb 2024 17:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1707845740;
	bh=SaOv5pqg6XCQEEjnO+4K8fSK/GoMYzKol24M1UjBB+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oVHAFSDtD5cdM4WxYuwZyEDClSvCZ0234TPUAaxAKHxj/8LWXW15mpf/20zOHOcqA
	 0JxeNyFLLXFv0fDHSnRTkGJ/53vxI0oSSkG59TVXqPzUAvRFUh3LMi13aRrOA/Hi8a
	 QEJiloM9ji0YHS+YG6LCYgAdjfX+eUqKcKx8917Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Loic Prylli <lprylli@netflix.com>,
	Alexander Hansen <alexander.hansen@9elements.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 043/124] hwmon: (aspeed-pwm-tacho) mutex for tach reading
Date: Tue, 13 Feb 2024 18:21:05 +0100
Message-ID: <20240213171854.995599982@linuxfoundation.org>
X-Mailer: git-send-email 2.43.1
In-Reply-To: <20240213171853.722912593@linuxfoundation.org>
References: <20240213171853.722912593@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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



