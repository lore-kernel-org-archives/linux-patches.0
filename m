Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD5CA13B7A0;
	Tue, 27 Feb 2024 13:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042360; cv=none; b=Vvgu1/7s5n2yHjUGr5CMLbZAhtT0s1suKvJUWL7OFMG0u7jqGvx8OVcEnpbsCVjb5ttha/94SKR5JxjHv0UoXSj+zeDviapxeeLxbmV7Ez1VovtyVTSnP8dNhHua289XpXz6JDp67ekGFJoX+5pO+uoqFRmJGJiFKf/oMxlzuio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042360; c=relaxed/simple;
	bh=SqSKL7wUN0y1clpB+dPiPOgIQtlUs/BDQbJDxN97YCM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UGeVpnhswHaxytqBTBvkgjTYs8rvh4/lT6XMB7iF4RZlM1mCrSRwaHfsevVz6QDfbxMxeWnlXdP946/uk/ZIZjjO0N5YNUYK9mEhcSWzq2A6urNLT4+On0Pt2k5IDyq4J6R8EWWFWieILN4RlR90EK+9nfFlPBT6iZsQTeF3LH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iFgSIsSZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iFgSIsSZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B4EDC433F1;
	Tue, 27 Feb 2024 13:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042360;
	bh=SqSKL7wUN0y1clpB+dPiPOgIQtlUs/BDQbJDxN97YCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iFgSIsSZX67tLV6kQ31k1Bu8U7HJHVRYHlLXjQRtR6V409WwUJ/LhWS6bGlPsKjvS
	 sULvUr25cvEP47UWu0lGwfzpi+Q9CUlRq0QnkOZQBQZ6c7Q0FVHzLpR6TgM5T2mNan
	 CoYeRUPvR0U5UoRq4WnD/U5copOn3DAMYG/mKcBQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erhard Furtner <erhard_f@mailbox.org>,
	Ahmad Khalifa <ahmad@khalifa.ws>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 267/299] hwmon: (nct6775) Fix access to temperature configuration registers
Date: Tue, 27 Feb 2024 14:26:18 +0100
Message-ID: <20240227131634.280229182@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit d56e460e19ea8382f813eb489730248ec8d7eb73 ]

The number of temperature configuration registers does
not always match the total number of temperature registers.
This can result in access errors reported if KASAN is enabled.

BUG: KASAN: global-out-of-bounds in nct6775_probe+0x5654/0x6fe9 nct6775_core

Reported-by: Erhard Furtner <erhard_f@mailbox.org>
Closes: https://lore.kernel.org/linux-hwmon/d51181d1-d26b-42b2-b002-3f5a4037721f@roeck-us.net/
Fixes: b7f1f7b2523a ("hwmon: (nct6775) Additional TEMP registers for nct6799")
Cc: Ahmad Khalifa <ahmad@khalifa.ws>
Tested-by: Ahmad Khalifa <ahmad@khalifa.ws>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/nct6775-core.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/nct6775-core.c b/drivers/hwmon/nct6775-core.c
index 92a49fafe2c02..f3bf2e4701c38 100644
--- a/drivers/hwmon/nct6775-core.c
+++ b/drivers/hwmon/nct6775-core.c
@@ -3512,6 +3512,7 @@ int nct6775_probe(struct device *dev, struct nct6775_data *data,
 	const u16 *reg_temp_mon, *reg_temp_alternate, *reg_temp_crit;
 	const u16 *reg_temp_crit_l = NULL, *reg_temp_crit_h = NULL;
 	int num_reg_temp, num_reg_temp_mon, num_reg_tsi_temp;
+	int num_reg_temp_config;
 	struct device *hwmon_dev;
 	struct sensor_template_group tsi_temp_tg;
 
@@ -3594,6 +3595,7 @@ int nct6775_probe(struct device *dev, struct nct6775_data *data,
 		reg_temp_over = NCT6106_REG_TEMP_OVER;
 		reg_temp_hyst = NCT6106_REG_TEMP_HYST;
 		reg_temp_config = NCT6106_REG_TEMP_CONFIG;
+		num_reg_temp_config = ARRAY_SIZE(NCT6106_REG_TEMP_CONFIG);
 		reg_temp_alternate = NCT6106_REG_TEMP_ALTERNATE;
 		reg_temp_crit = NCT6106_REG_TEMP_CRIT;
 		reg_temp_crit_l = NCT6106_REG_TEMP_CRIT_L;
@@ -3669,6 +3671,7 @@ int nct6775_probe(struct device *dev, struct nct6775_data *data,
 		reg_temp_over = NCT6106_REG_TEMP_OVER;
 		reg_temp_hyst = NCT6106_REG_TEMP_HYST;
 		reg_temp_config = NCT6106_REG_TEMP_CONFIG;
+		num_reg_temp_config = ARRAY_SIZE(NCT6106_REG_TEMP_CONFIG);
 		reg_temp_alternate = NCT6106_REG_TEMP_ALTERNATE;
 		reg_temp_crit = NCT6106_REG_TEMP_CRIT;
 		reg_temp_crit_l = NCT6106_REG_TEMP_CRIT_L;
@@ -3746,6 +3749,7 @@ int nct6775_probe(struct device *dev, struct nct6775_data *data,
 		reg_temp_over = NCT6775_REG_TEMP_OVER;
 		reg_temp_hyst = NCT6775_REG_TEMP_HYST;
 		reg_temp_config = NCT6775_REG_TEMP_CONFIG;
+		num_reg_temp_config = ARRAY_SIZE(NCT6775_REG_TEMP_CONFIG);
 		reg_temp_alternate = NCT6775_REG_TEMP_ALTERNATE;
 		reg_temp_crit = NCT6775_REG_TEMP_CRIT;
 
@@ -3821,6 +3825,7 @@ int nct6775_probe(struct device *dev, struct nct6775_data *data,
 		reg_temp_over = NCT6775_REG_TEMP_OVER;
 		reg_temp_hyst = NCT6775_REG_TEMP_HYST;
 		reg_temp_config = NCT6776_REG_TEMP_CONFIG;
+		num_reg_temp_config = ARRAY_SIZE(NCT6776_REG_TEMP_CONFIG);
 		reg_temp_alternate = NCT6776_REG_TEMP_ALTERNATE;
 		reg_temp_crit = NCT6776_REG_TEMP_CRIT;
 
@@ -3900,6 +3905,7 @@ int nct6775_probe(struct device *dev, struct nct6775_data *data,
 		reg_temp_over = NCT6779_REG_TEMP_OVER;
 		reg_temp_hyst = NCT6779_REG_TEMP_HYST;
 		reg_temp_config = NCT6779_REG_TEMP_CONFIG;
+		num_reg_temp_config = ARRAY_SIZE(NCT6779_REG_TEMP_CONFIG);
 		reg_temp_alternate = NCT6779_REG_TEMP_ALTERNATE;
 		reg_temp_crit = NCT6779_REG_TEMP_CRIT;
 
@@ -4034,6 +4040,7 @@ int nct6775_probe(struct device *dev, struct nct6775_data *data,
 		reg_temp_over = NCT6779_REG_TEMP_OVER;
 		reg_temp_hyst = NCT6779_REG_TEMP_HYST;
 		reg_temp_config = NCT6779_REG_TEMP_CONFIG;
+		num_reg_temp_config = ARRAY_SIZE(NCT6779_REG_TEMP_CONFIG);
 		reg_temp_alternate = NCT6779_REG_TEMP_ALTERNATE;
 		reg_temp_crit = NCT6779_REG_TEMP_CRIT;
 
@@ -4123,6 +4130,7 @@ int nct6775_probe(struct device *dev, struct nct6775_data *data,
 		reg_temp_over = NCT6798_REG_TEMP_OVER;
 		reg_temp_hyst = NCT6798_REG_TEMP_HYST;
 		reg_temp_config = NCT6779_REG_TEMP_CONFIG;
+		num_reg_temp_config = ARRAY_SIZE(NCT6779_REG_TEMP_CONFIG);
 		reg_temp_alternate = NCT6798_REG_TEMP_ALTERNATE;
 		reg_temp_crit = NCT6798_REG_TEMP_CRIT;
 
@@ -4204,7 +4212,8 @@ int nct6775_probe(struct device *dev, struct nct6775_data *data,
 				  = reg_temp_crit[src - 1];
 			if (reg_temp_crit_l && reg_temp_crit_l[i])
 				data->reg_temp[4][src - 1] = reg_temp_crit_l[i];
-			data->reg_temp_config[src - 1] = reg_temp_config[i];
+			if (i < num_reg_temp_config)
+				data->reg_temp_config[src - 1] = reg_temp_config[i];
 			data->temp_src[src - 1] = src;
 			continue;
 		}
@@ -4217,7 +4226,8 @@ int nct6775_probe(struct device *dev, struct nct6775_data *data,
 		data->reg_temp[0][s] = reg_temp[i];
 		data->reg_temp[1][s] = reg_temp_over[i];
 		data->reg_temp[2][s] = reg_temp_hyst[i];
-		data->reg_temp_config[s] = reg_temp_config[i];
+		if (i < num_reg_temp_config)
+			data->reg_temp_config[s] = reg_temp_config[i];
 		if (reg_temp_crit_h && reg_temp_crit_h[i])
 			data->reg_temp[3][s] = reg_temp_crit_h[i];
 		else if (reg_temp_crit[src - 1])
-- 
2.43.0



