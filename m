Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E55C7BAF7;
	Wed, 21 Feb 2024 13:19:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521576; cv=none; b=HGiZvD2Us2xyUBunW6uTs0mdhTVuW39ovEBBwbxaDSkNmkycP6hAGvwn7VurjVAJ2MT+sKhPAThwgWmpG+vZnev+cY3IZWi1elhIP/wIr5lJwVvNjvyKDXhM2tmDFNeuaMorB4uPC/MqgbSYeyrFD2h4G2dvN6jf4/ITCz5EOzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521576; c=relaxed/simple;
	bh=UvPzTnaQgYXvP3gn6QHcatCcwRTKoGRvG8fgfdZHzwA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BSYSsC9VR2pNqG/PVQJgFpJzQU3u53gzFh9pKfGDyRQFoUXdc8FZEFJG7gW4UlKyBtqSaaARtHTdBBxYyGawJe/CMRKuqVDcW29P75xHmYNi06+mZoLgf08W3DtBCQ0xc6oU5wozMQse0Vg/0IIaBVtSYTvyD9qbgD+FxS3pfY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DJcGzjWR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DJcGzjWR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DF01C433F1;
	Wed, 21 Feb 2024 13:19:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521576;
	bh=UvPzTnaQgYXvP3gn6QHcatCcwRTKoGRvG8fgfdZHzwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DJcGzjWR12RsUdeVHSOZZgNfbE3w7kg6dJMb1Tx+qfOPJXV0HGqB0ZlDP4y1bgkLB
	 jtqn6BxiXaaCHsFui38YOuCqynJS9/YaG2H8e21UVm79i4jOJe0kh5FYHKEYk8dM5G
	 8oYr/8cG+StWglRv9FzLcMTTQiq3Bq3UnY3fCqL8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Loic Prylli <lprylli@netflix.com>,
	Alexander Hansen <alexander.hansen@9elements.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 149/202] hwmon: (aspeed-pwm-tacho) mutex for tach reading
Date: Wed, 21 Feb 2024 14:07:30 +0100
Message-ID: <20240221125936.517518944@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125931.742034354@linuxfoundation.org>
References: <20240221125931.742034354@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index a43fa730a513..4097ae62e9a4 100644
--- a/drivers/hwmon/aspeed-pwm-tacho.c
+++ b/drivers/hwmon/aspeed-pwm-tacho.c
@@ -197,6 +197,8 @@ struct aspeed_pwm_tacho_data {
 	u8 fan_tach_ch_source[16];
 	struct aspeed_cooling_device *cdev[8];
 	const struct attribute_group *groups[3];
+	/* protects access to shared ASPEED_PTCR_RESULT */
+	struct mutex tach_lock;
 };
 
 enum type { TYPEM, TYPEN, TYPEO };
@@ -531,6 +533,8 @@ static int aspeed_get_fan_tach_ch_rpm(struct aspeed_pwm_tacho_data *priv,
 	u8 fan_tach_ch_source, type, mode, both;
 	int ret;
 
+	mutex_lock(&priv->tach_lock);
+
 	regmap_write(priv->regmap, ASPEED_PTCR_TRIGGER, 0);
 	regmap_write(priv->regmap, ASPEED_PTCR_TRIGGER, 0x1 << fan_tach_ch);
 
@@ -548,6 +552,8 @@ static int aspeed_get_fan_tach_ch_rpm(struct aspeed_pwm_tacho_data *priv,
 		ASPEED_RPM_STATUS_SLEEP_USEC,
 		usec);
 
+	mutex_unlock(&priv->tach_lock);
+
 	/* return -ETIMEDOUT if we didn't get an answer. */
 	if (ret)
 		return ret;
@@ -938,6 +944,7 @@ static int aspeed_pwm_tacho_probe(struct platform_device *pdev)
 	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
+	mutex_init(&priv->tach_lock);
 	priv->regmap = devm_regmap_init(dev, NULL, (__force void *)regs,
 			&aspeed_pwm_tacho_regmap_config);
 	if (IS_ERR(priv->regmap))
-- 
2.43.0



