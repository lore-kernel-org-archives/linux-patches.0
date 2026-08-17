Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0741E315D5D;
	Mon, 17 Aug 2026 13:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974185; cv=none; b=jS1q2TKKE/k29SHvcJQxEE0pi36fN4NnMHGHeWSHa0HdbF0t3j5iELVAFod/4+5GADLBie3CCR2l/dprSE7hHe1nD3tvJSFWlUdjhllKUQgDnf5NOFDVAORcBma8diz3p01qpIYYBoa0xklpLAKvP2GkM4Z9dQc09MmJKXxXAko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974185; c=relaxed/simple;
	bh=qWpOw4Kio+nwhJY7tQb8xbq0GxcuVJ9Rf9RPcFC9R1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vo7/C13JTOV3vreYFy1qtW0NphjVOIdUD5sE6d5ePvhgbzeZ9JhfosUcsWArsZ0p8B16tlIl0Y4wvDfZz7OCfstRcJo8VL3EbZBn7g8iFyS39t4S/Z9MQKjjxCPMLtFNvmaCXmY/Dzo5DAcxRiZ9idqR/71GfEa6qNOxsgOzGIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D/P8vO12; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D/P8vO12"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ED6F1F000E9;
	Mon, 17 Aug 2026 13:43:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974183;
	bh=Lf+xOkkkDw70ozGSRdiLyiNGUzwfA9u9UL/cAh6+SaM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D/P8vO12AHw6MmgYV4RwOKikh655MxAynnxqTsFeHEuAL1dWuXuLJsUf54PWGGpW6
	 pGjQklbdG/SUpBfY15d3IiH/eYwRWGDHgRiBDCkN1t/WFOSZm08SwzkG+FZvLnUy6d
	 c2f6SzcEzmjNJ87tB5zCDtW5yyAZ8y3jmHR0iO1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qingshuang Fu <fuqingshuang@kylinos.cn>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 117/271] hwmon: (ads7828) Fix external VREF regulator handling
Date: Mon, 17 Aug 2026 15:30:42 +0200
Message-ID: <20260817132541.692354055@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 149cfcec78dcc..f8f2f621dfeaf 100644
--- a/drivers/hwmon/ads7828.c
+++ b/drivers/hwmon/ads7828.c
@@ -106,12 +106,11 @@ static int ads7828_probe(struct i2c_client *client)
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
@@ -125,9 +124,11 @@ static int ads7828_probe(struct i2c_client *client)
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



