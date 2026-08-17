Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EB86175A99;
	Mon, 17 Aug 2026 14:55:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978509; cv=none; b=JWUdwBH18WkKQPdEUNcssqLeodg2K6KoJ9WYxlgyZkBVM2dkV4qYXvx7AFa95nnwff554w9zHTbPW/3m+fdzR7hF4n0NfzxsvGCsNve11Iydd3GeSmIdHNDRKvPv4gvHkfDsb0AJu2hgBOCk6yPTI3sR2QMrzsrji16Vb2edH48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978509; c=relaxed/simple;
	bh=VgCkmhjkQN/Rx9DZ1NOS7ggbLrAlnEVbNw7NeVS9WFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BXmFGwyOty+PZVdGvyrYcH1pccZ/phd9vm64Tqirasks4ECjFj7N+T5lH+IVoIq0P8s+S/jSEZy8cR/GmWtwYlt53GWoNDzrMxRv60TFx5WchLlgYuHLXC98yflYyUQ3RJ5CHYJ2azivN9cKwdY4N1uhVQINcqQ2RoZQB4B8Tj8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v0ew9be5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v0ew9be5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B67D11F000E9;
	Mon, 17 Aug 2026 14:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978508;
	bh=4T+TGiHWM67TCdxbM2h5nI2J+6ZhRTLW1e4GQvsIJq0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v0ew9be5ECzC3Iy4CtksPyndK9me8yUgjjL8wR6+lq6g5zWPXbNSvZZ6Sjn9Sw+2g
	 2rYIcM8Se/mfR4kKKKC5AVm13YJE/2oOLVq8wmqt6Iu9zwNGyF06QgO8qWqJiYORsJ
	 xiTRECtMjiz/na45yB/gvzwApKDVwCq2jOMzWeww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qingshuang Fu <fuqingshuang@kylinos.cn>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 061/156] hwmon: (ads7828) Fix external VREF regulator handling
Date: Mon, 17 Aug 2026 15:33:15 +0200
Message-ID: <20260817132536.977123035@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132534.666299318@linuxfoundation.org>
References: <20260817132534.666299318@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qingshuang Fu <fuqingshuang@kylinos.cn>

[ Upstream commit fddb5ceaf901b050ed2a1a7deeecbf97e003435a ]

The driver currently has two issues with the external VREF regulator
handling in ads7828_probe():

1. All errors from devm_regulator_get_optional() are ignored, causing the
   driver to incorrectly fall back to internal VREF even for transient
   errors like -EPROBE_DEFER or genuine failures like -ENOMEM.

2. The external regulator is never enabled. The driver calls
   regulator_get_voltage() without first calling regulator_enable(),
   so the VREF pin may remain unpowered if the regulator is not
   configured as always-on.

Fix both issues by switching to devm_regulator_get_enable_read_voltage(),
which handles regulator get, enable, and voltage read in one call.
Only -ENODEV (no regulator specified in device tree) should trigger the
fallback to internal VREF. All other errors are propagated to the caller.

Fixes: a8ddfea09566 ("hwmon: (ads7828) Accept optional parameters from device tree")
Signed-off-by: Qingshuang Fu <fuqingshuang@kylinos.cn>
Link: https://lore.kernel.org/r/20260805061645.1331652-1-fffsqian@163.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/ads7828.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/hwmon/ads7828.c b/drivers/hwmon/ads7828.c
index 809e830f52a6b..b9ed146a24cc1 100644
--- a/drivers/hwmon/ads7828.c
+++ b/drivers/hwmon/ads7828.c
@@ -108,12 +108,11 @@ static int ads7828_probe(struct i2c_client *client)
 	struct ads7828_data *data;
 	struct device *hwmon_dev;
 	unsigned int vref_mv = ADS7828_INT_VREF_MV;
-	unsigned int vref_uv;
+	int vref_uv;
 	bool diff_input = false;
 	bool ext_vref = false;
 	unsigned int regval;
 	enum ads7828_chips chip;
-	struct regulator *reg;
 
 	data = devm_kzalloc(dev, sizeof(struct ads7828_data), GFP_KERNEL);
 	if (!data)
@@ -127,9 +126,11 @@ static int ads7828_probe(struct i2c_client *client)
 	} else if (dev->of_node) {
 		diff_input = of_property_read_bool(dev->of_node,
 						   "ti,differential-input");
-		reg = devm_regulator_get_optional(dev, "vref");
-		if (!IS_ERR(reg)) {
-			vref_uv = regulator_get_voltage(reg);
+		vref_uv = devm_regulator_get_enable_read_voltage(dev, "vref");
+		if (vref_uv < 0) {
+			if (vref_uv != -ENODEV)
+				return vref_uv;
+		} else {
 			vref_mv = DIV_ROUND_CLOSEST(vref_uv, 1000);
 			if (vref_mv < ADS7828_EXT_VREF_MV_MIN ||
 			    vref_mv > ADS7828_EXT_VREF_MV_MAX)
-- 
2.53.0



