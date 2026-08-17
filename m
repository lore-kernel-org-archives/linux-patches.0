Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28784442B06;
	Mon, 17 Aug 2026 15:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979788; cv=none; b=hDUSQBuEoyTAhu5UkdRoRDXRb6YbpcDPugiCckdPmLdga29jLoBUxVmPyxMx4s0ge0sCyfOBtmAiqMq3Wjo55O3LXWnnU0UqnnQC/ak1HlwkEqgEU6UuTg/fYwiHk2euW7xRdBQgCpVGVNkeQkMCOwfUVwQFnv3ARLb6m+c3qfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979788; c=relaxed/simple;
	bh=DNMUZqx4uQ1Qyff9u0ZTgGf602Slhad3LKy5+IecaFs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A6Am+vOhRKZEJU0N2hJFN/jiTfk8jTo481XsiNAiWUg8xUmCMKZ2am/bcZ8r2CMiGiFLXPeqDXmEDUrePqFZbXTafRkuwIlfKKapvnCBAf1X9zc5+GZe7s6oRLAjGpBtyY3c7OrtPcTyUukaWDU/CseKxH1LS5j1j+vjR7vv1/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qhRi7wux; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qhRi7wux"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32E001F000E9;
	Mon, 17 Aug 2026 15:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979785;
	bh=/UFYe3fkoH+DFJFKv5WaUvcF0ekVqhdoYZx606IYess=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qhRi7wuxgHUN5EPtMmPCMv8oh8jZ2f4p8+sFX4u7l2PpUlsp+k9MAgBrB+0aoNfq+
	 bPIGwOZpJNBmmLPpjg/nmxqkVLe88Jz5j1IThz1opU3BHyLzlzy5jZiLcRdm7iEuRS
	 gg413yAuU5ItdxJSHKKsl+aZryUb2/ZPHf9wFhCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Erhard Furtner <erhard_f@mailbox.org>,
	Ahmad Khalifa <ahmad@khalifa.ws>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 346/609] hwmon: (nct6775) Fix access to temperature configuration registers
Date: Mon, 17 Aug 2026 15:30:42 +0200
Message-ID: <20260817132555.845393557@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
Stable-dep-of: b0e8adb2ccb4 ("hwmon: (nct6775-core) Fix number of temperature registers for NCT6116")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/nct6775-core.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/nct6775-core.c b/drivers/hwmon/nct6775-core.c
index acb0fbb0eabca..c7b3961e189ce 100644
--- a/drivers/hwmon/nct6775-core.c
+++ b/drivers/hwmon/nct6775-core.c
@@ -3506,6 +3506,7 @@ int nct6775_probe(struct device *dev, struct nct6775_data *data,
 	const u16 *reg_temp_mon, *reg_temp_alternate, *reg_temp_crit;
 	const u16 *reg_temp_crit_l = NULL, *reg_temp_crit_h = NULL;
 	int num_reg_temp, num_reg_temp_mon, num_reg_tsi_temp;
+	int num_reg_temp_config;
 	struct device *hwmon_dev;
 	struct sensor_template_group tsi_temp_tg;
 
@@ -3588,6 +3589,7 @@ int nct6775_probe(struct device *dev, struct nct6775_data *data,
 		reg_temp_over = NCT6106_REG_TEMP_OVER;
 		reg_temp_hyst = NCT6106_REG_TEMP_HYST;
 		reg_temp_config = NCT6106_REG_TEMP_CONFIG;
+		num_reg_temp_config = ARRAY_SIZE(NCT6106_REG_TEMP_CONFIG);
 		reg_temp_alternate = NCT6106_REG_TEMP_ALTERNATE;
 		reg_temp_crit = NCT6106_REG_TEMP_CRIT;
 		reg_temp_crit_l = NCT6106_REG_TEMP_CRIT_L;
@@ -3663,6 +3665,7 @@ int nct6775_probe(struct device *dev, struct nct6775_data *data,
 		reg_temp_over = NCT6106_REG_TEMP_OVER;
 		reg_temp_hyst = NCT6106_REG_TEMP_HYST;
 		reg_temp_config = NCT6106_REG_TEMP_CONFIG;
+		num_reg_temp_config = ARRAY_SIZE(NCT6106_REG_TEMP_CONFIG);
 		reg_temp_alternate = NCT6106_REG_TEMP_ALTERNATE;
 		reg_temp_crit = NCT6106_REG_TEMP_CRIT;
 		reg_temp_crit_l = NCT6106_REG_TEMP_CRIT_L;
@@ -3740,6 +3743,7 @@ int nct6775_probe(struct device *dev, struct nct6775_data *data,
 		reg_temp_over = NCT6775_REG_TEMP_OVER;
 		reg_temp_hyst = NCT6775_REG_TEMP_HYST;
 		reg_temp_config = NCT6775_REG_TEMP_CONFIG;
+		num_reg_temp_config = ARRAY_SIZE(NCT6775_REG_TEMP_CONFIG);
 		reg_temp_alternate = NCT6775_REG_TEMP_ALTERNATE;
 		reg_temp_crit = NCT6775_REG_TEMP_CRIT;
 
@@ -3815,6 +3819,7 @@ int nct6775_probe(struct device *dev, struct nct6775_data *data,
 		reg_temp_over = NCT6775_REG_TEMP_OVER;
 		reg_temp_hyst = NCT6775_REG_TEMP_HYST;
 		reg_temp_config = NCT6776_REG_TEMP_CONFIG;
+		num_reg_temp_config = ARRAY_SIZE(NCT6776_REG_TEMP_CONFIG);
 		reg_temp_alternate = NCT6776_REG_TEMP_ALTERNATE;
 		reg_temp_crit = NCT6776_REG_TEMP_CRIT;
 
@@ -3894,6 +3899,7 @@ int nct6775_probe(struct device *dev, struct nct6775_data *data,
 		reg_temp_over = NCT6779_REG_TEMP_OVER;
 		reg_temp_hyst = NCT6779_REG_TEMP_HYST;
 		reg_temp_config = NCT6779_REG_TEMP_CONFIG;
+		num_reg_temp_config = ARRAY_SIZE(NCT6779_REG_TEMP_CONFIG);
 		reg_temp_alternate = NCT6779_REG_TEMP_ALTERNATE;
 		reg_temp_crit = NCT6779_REG_TEMP_CRIT;
 
@@ -4028,6 +4034,7 @@ int nct6775_probe(struct device *dev, struct nct6775_data *data,
 		reg_temp_over = NCT6779_REG_TEMP_OVER;
 		reg_temp_hyst = NCT6779_REG_TEMP_HYST;
 		reg_temp_config = NCT6779_REG_TEMP_CONFIG;
+		num_reg_temp_config = ARRAY_SIZE(NCT6779_REG_TEMP_CONFIG);
 		reg_temp_alternate = NCT6779_REG_TEMP_ALTERNATE;
 		reg_temp_crit = NCT6779_REG_TEMP_CRIT;
 
@@ -4117,6 +4124,7 @@ int nct6775_probe(struct device *dev, struct nct6775_data *data,
 		reg_temp_over = NCT6798_REG_TEMP_OVER;
 		reg_temp_hyst = NCT6798_REG_TEMP_HYST;
 		reg_temp_config = NCT6779_REG_TEMP_CONFIG;
+		num_reg_temp_config = ARRAY_SIZE(NCT6779_REG_TEMP_CONFIG);
 		reg_temp_alternate = NCT6798_REG_TEMP_ALTERNATE;
 		reg_temp_crit = NCT6798_REG_TEMP_CRIT;
 
@@ -4198,7 +4206,8 @@ int nct6775_probe(struct device *dev, struct nct6775_data *data,
 				  = reg_temp_crit[src - 1];
 			if (reg_temp_crit_l && reg_temp_crit_l[i])
 				data->reg_temp[4][src - 1] = reg_temp_crit_l[i];
-			data->reg_temp_config[src - 1] = reg_temp_config[i];
+			if (i < num_reg_temp_config)
+				data->reg_temp_config[src - 1] = reg_temp_config[i];
 			data->temp_src[src - 1] = src;
 			continue;
 		}
@@ -4211,7 +4220,8 @@ int nct6775_probe(struct device *dev, struct nct6775_data *data,
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
2.53.0



