Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0B69192591;
	Tue, 10 Sep 2024 10:02:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962562; cv=none; b=SSjR5jZ7g64ZRRE9pZD6kpvgnMOhtiKHR7+TzeaSSqnTaC7jFhg4lQmPTmI4DJcLWdYnBaWti2HCzS75uArhayr1uBIcpIg4mhtvMskuGj2XuqQM70SJqzd+XwKSXGDe66ZAhMSRcK6LUEeATDA+mSde2WkFoJozHO2T8YOPfoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962562; c=relaxed/simple;
	bh=zDtsRKqKtTLcqWHP0SD4/oYBRE9bcF3V4tNOhRFl1hw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fFRBLdb+69euly1ru536iQmlzFvzDll5XT5iz87jzgkkrJ61nr/0I/RYUs/PTiobkklPy3LRNi52suoSQr0g9BFaEcAiwRdzd5YgCrFttqucRGpLCInv8r+iZM6MYECQt7R2tPFLxFNtruoNp+Qw05trC3SX1jT+FEAi019YMtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aRkSe4JL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aRkSe4JL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20656C4CEC3;
	Tue, 10 Sep 2024 10:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962561;
	bh=zDtsRKqKtTLcqWHP0SD4/oYBRE9bcF3V4tNOhRFl1hw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aRkSe4JL9wuCEyzNPk9wtbWKeEIoyFVhMGgP0/LPiRpuXoA3XgioGILxE83ysMl8p
	 kn7aDK/OvOFqsV2z6/381UhAas8Wr5fwDY/YX+Dwryk+pPvWVOFrn+Qc7BLvPeDlmL
	 kjcutjWd9z043e4f/QymdnDmRrz9FcoJ0uv9/xBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 076/121] hwmon: (adc128d818) Fix underflows seen when writing limit attributes
Date: Tue, 10 Sep 2024 11:32:31 +0200
Message-ID: <20240910092549.517256470@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092545.737864202@linuxfoundation.org>
References: <20240910092545.737864202@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 8cad724c8537fe3e0da8004646abc00290adae40 ]

DIV_ROUND_CLOSEST() after kstrtol() results in an underflow if a large
negative number such as -9223372036854775808 is provided by the user.
Fix it by reordering clamp_val() and DIV_ROUND_CLOSEST() operations.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/adc128d818.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/adc128d818.c b/drivers/hwmon/adc128d818.c
index f9edec195c35..08d8bd72ec0e 100644
--- a/drivers/hwmon/adc128d818.c
+++ b/drivers/hwmon/adc128d818.c
@@ -176,7 +176,7 @@ static ssize_t adc128_in_store(struct device *dev,
 
 	mutex_lock(&data->update_lock);
 	/* 10 mV LSB on limit registers */
-	regval = clamp_val(DIV_ROUND_CLOSEST(val, 10), 0, 255);
+	regval = DIV_ROUND_CLOSEST(clamp_val(val, 0, 2550), 10);
 	data->in[index][nr] = regval << 4;
 	reg = index == 1 ? ADC128_REG_IN_MIN(nr) : ADC128_REG_IN_MAX(nr);
 	i2c_smbus_write_byte_data(data->client, reg, regval);
@@ -214,7 +214,7 @@ static ssize_t adc128_temp_store(struct device *dev,
 		return err;
 
 	mutex_lock(&data->update_lock);
-	regval = clamp_val(DIV_ROUND_CLOSEST(val, 1000), -128, 127);
+	regval = DIV_ROUND_CLOSEST(clamp_val(val, -128000, 127000), 1000);
 	data->temp[index] = regval << 1;
 	i2c_smbus_write_byte_data(data->client,
 				  index == 1 ? ADC128_REG_TEMP_MAX
-- 
2.43.0



