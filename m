Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF5237D411;
	Wed, 21 Feb 2024 14:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708524481; cv=none; b=fFpGo533Lrlw7ZW2Ma/gDaPjjC/eBBhX2Wth+fOJyNISmAuzXlzxfyCSqD7ywP2gyA3nGHvSxfHaft+rqRs8S+vLqSBA+r7IT772zA8MG/JreJzDNxFNx5tOe+LjGk3Xzgufr0ipcrX8n/Jskf61Lv0es3VafsKmRi2HtaTbLUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708524481; c=relaxed/simple;
	bh=SMzAhuqy6UTA0uKSv3L0rTW5VpaqGjHzK1ortTZBQvo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hPmq/32TXs5IiY/4+Q8qCQdaaOY+eY3gXx/wQuasrMg9OAs5BZ4bqiEVp/usY/PYHdaDOEdQVSGpql+h4IkmJYj8454/3PW0zSDSope+jI1A1x8S1zIg/u5XynuJVTArieZ9JIpqmfGzP3MIsNtjqEZjasscE9fgMb8bO/CdQm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gOp6spEX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gOp6spEX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4C66C433C7;
	Wed, 21 Feb 2024 14:08:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708524481;
	bh=SMzAhuqy6UTA0uKSv3L0rTW5VpaqGjHzK1ortTZBQvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gOp6spEXFxaa3TMaSupN93n/3V3BHSinBrlUk+H2AYXNlLdFdIviAMRqFVX9CQT6s
	 ZoxduKD/TygoFj+Byjoj73MsErRUSFFZd1YpNprvsKnCTDN8QdgB2jo+BJA56Fm7iT
	 0m/dGRZB51xyXOQbq4XQdr9ApHyrEKFRpmwMTtUc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Loic Prylli <lprylli@netflix.com>,
	Alexander Hansen <alexander.hansen@9elements.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 258/379] hwmon: (aspeed-pwm-tacho) mutex for tach reading
Date: Wed, 21 Feb 2024 14:07:17 +0100
Message-ID: <20240221130002.549861023@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125954.917878865@linuxfoundation.org>
References: <20240221125954.917878865@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 3d8239fd66ed..3dc97041a704 100644
--- a/drivers/hwmon/aspeed-pwm-tacho.c
+++ b/drivers/hwmon/aspeed-pwm-tacho.c
@@ -194,6 +194,8 @@ struct aspeed_pwm_tacho_data {
 	u8 fan_tach_ch_source[16];
 	struct aspeed_cooling_device *cdev[8];
 	const struct attribute_group *groups[3];
+	/* protects access to shared ASPEED_PTCR_RESULT */
+	struct mutex tach_lock;
 };
 
 enum type { TYPEM, TYPEN, TYPEO };
@@ -528,6 +530,8 @@ static int aspeed_get_fan_tach_ch_rpm(struct aspeed_pwm_tacho_data *priv,
 	u8 fan_tach_ch_source, type, mode, both;
 	int ret;
 
+	mutex_lock(&priv->tach_lock);
+
 	regmap_write(priv->regmap, ASPEED_PTCR_TRIGGER, 0);
 	regmap_write(priv->regmap, ASPEED_PTCR_TRIGGER, 0x1 << fan_tach_ch);
 
@@ -545,6 +549,8 @@ static int aspeed_get_fan_tach_ch_rpm(struct aspeed_pwm_tacho_data *priv,
 		ASPEED_RPM_STATUS_SLEEP_USEC,
 		usec);
 
+	mutex_unlock(&priv->tach_lock);
+
 	/* return -ETIMEDOUT if we didn't get an answer. */
 	if (ret)
 		return ret;
@@ -904,6 +910,7 @@ static int aspeed_pwm_tacho_probe(struct platform_device *pdev)
 	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
+	mutex_init(&priv->tach_lock);
 	priv->regmap = devm_regmap_init(dev, NULL, (__force void *)regs,
 			&aspeed_pwm_tacho_regmap_config);
 	if (IS_ERR(priv->regmap))
-- 
2.43.0



