Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F82F3F7884;
	Wed, 20 May 2026 16:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295250; cv=none; b=R8jZM+re+W28T3MpaRxsK+p2K4hqgsIvqygbiFagzSqaOgVylFf99MVkGKAXcBKY0vP5c/o6fT/JS/rO4MfSjhXv6BMIrBXGVfdCi0mWh/YKkELU7GP8XsxlMCPb2qO6x694GWZfIfcodtIILS2h2BSaYoUPGu4ofXm7ne+4rNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295250; c=relaxed/simple;
	bh=UhjtGArI0vnLgqKMDzmpV0cum73ynWraGi5ndqEVqHA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kd6+jrF3jpeDcatr/XO9a5GiBj4pMVRr4nh1N/Kyrz8d8zKHyJlPG/2IjVH5NifVVJVy7iiBhk6eoMq/MFlPtuAA5Y2YOKWlfpReu9Phv0xqqIuRbeOatKw9xhbOEJePb5+0c0n4RV0FYCKAZBjQZrZ/e9PZaQiE8BW7Z5k8eCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u/XsTZF8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u/XsTZF8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A458D1F00893;
	Wed, 20 May 2026 16:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295248;
	bh=o16cjMQgYyuZiREbMJTmDhpaYdH1q5XmaBtSFabe4Mw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u/XsTZF8ytdYFVcETF0AOf7+xT47/e8hnUOSl6vgkEYLv1yYIZ/xbcQjqjapHkSBc
	 FNweDBukSLs14bz1i5EcHIOMLoAnzxMGS5AxfxhCX37zy7Qpc14+Pm1unXE76Ws9fz
	 HQ6Smjb2y4FXArOAP0JU1s2+3TA3fKlI85tpW+Fk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robby Cai <robby.cai@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0297/1146] regulator: fp9931: Fix handling of mandatory "vin" supply
Date: Wed, 20 May 2026 18:09:07 +0200
Message-ID: <20260520162154.933815696@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robby Cai <robby.cai@nxp.com>

[ Upstream commit 58068932402c7f5bf26489e01ae8e8bb89802d1e ]

The FP9931 requires a mandatory "vin" power supply to operate.
Replace devm_regulator_get_optional() with devm_regulator_get() to
enforce this mandatory dependency.

Fixes: 12d821bd13d42 ("regulator: Add FP9931/JD9930 driver")
Signed-off-by: Robby Cai <robby.cai@nxp.com>
Link: https://patch.msgid.link/20260313133102.2749890-3-robby.cai@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/fp9931.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/fp9931.c b/drivers/regulator/fp9931.c
index abea3b69d8a08..002b41f53eff8 100644
--- a/drivers/regulator/fp9931.c
+++ b/drivers/regulator/fp9931.c
@@ -446,7 +446,7 @@ static int fp9931_probe(struct i2c_client *client)
 		return dev_err_probe(&client->dev, PTR_ERR(data->regmap),
 				     "failed to allocate regmap!\n");
 
-	data->vin_reg = devm_regulator_get_optional(&client->dev, "vin");
+	data->vin_reg = devm_regulator_get(&client->dev, "vin");
 	if (IS_ERR(data->vin_reg))
 		return dev_err_probe(&client->dev, PTR_ERR(data->vin_reg),
 				     "failed to get vin regulator\n");
-- 
2.53.0



