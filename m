Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 772703451A7
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301764; cv=none; b=rTmSS9qAEVxhJHfqP9Dx1xzvzCkYrsUgq6Sh6hZCRlFyMAGSzlwgW3AUWcTtvUFls1hYYkj8K6yyh07WTXtynPkfw71Nuwm8T9Ij87L4KoGMUQkgdK1sSmCy5fpqWrqwP32iFkVBpuK60rS0m8hdwxfK6ATk02pFL810pIV9GY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301764; c=relaxed/simple;
	bh=4z9QCPLVeOyvTLmSe1M2CTGVnh7cEFNfHrC7lo2iTsk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UXgKyuEjQ6j79G0WlKFmfSLmkwkTExNtAqZo+7mhk2rx/GA0g8YMuiEpGvJhFgRWM0HumnOUXLnChIHZ9wlDQ243v/xscpQJEd15P4KYaDKJ0d287HSbVIodILYHkqINSmZyeLaIejp+rWZEBgFxajOtQ8no9XCY6vJOGzH7TWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hdSoivbW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hdSoivbW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5716C116D0;
	Sat, 28 Feb 2026 18:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301764;
	bh=4z9QCPLVeOyvTLmSe1M2CTGVnh7cEFNfHrC7lo2iTsk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hdSoivbWdd+QK7xbeP+iOs9bRHQjsOEYz6vVhR+/wjb5qj3aJl79H+xPnRAWIolKQ
	 DZGMo05InT6MFM4rTRdcAWZ0F12l5GEjCJh4NTmZvPqtwzfWCGib9sy5O1mvcYL0ke
	 Hq8DliyAT95s1pDZ8l65KZ7cbNQQ8DjlTfCtAO0W0P/MuKSeaHKxAv/PChXqQ/ZN84
	 jmshktqCqfZWQXQXkf3J4HfxbK9ENrUiGz4c6e4LWIxKGWIvzPtfXJs7wY66gG+F+m
	 TjreQ0uG0fzJjkWz7Ru7uylErSCUWfT/1IK93z/582PkCM6owK5PShhZX5eD9wQTsz
	 QDG0Evz9ItLoA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Pawel Dembicki <paweldembicki@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 170/385] hwmon: pmbus: mpq8785: Implement VOUT feedback resistor divider ratio configuration
Date: Sat, 28 Feb 2026 12:56:32 -0500
Message-ID: <20260228180011.1568201-170-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Pawel Dembicki <paweldembicki@gmail.com>

[ Upstream commit dc1a4bab48d513e426118e42b9c371d942ddb04b ]

Implement support for setting the VOUT_SCALE_LOOP PMBus register
based on an optional device tree property
"mps,vout-fb-divider-ratio-permille".

This allows the driver to provide the correct VOUT value depending
on the feedback voltage divider configuration for chips where the
bootloader does not configure the VOUT_SCALE_LOOP register.

Signed-off-by: Pawel Dembicki <paweldembicki@gmail.com>
Link: https://lore.kernel.org/r/20250511035701.2607947-4-paweldembicki@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Stable-dep-of: 9e33c1dba224 ("hwmon: (pmbus/mpq8785) fix VOUT_MODE mismatch during identification")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/pmbus/mpq8785.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/hwmon/pmbus/mpq8785.c b/drivers/hwmon/pmbus/mpq8785.c
index e260cb3b34c45..1f13959c381eb 100644
--- a/drivers/hwmon/pmbus/mpq8785.c
+++ b/drivers/hwmon/pmbus/mpq8785.c
@@ -5,11 +5,16 @@
 
 #include <linux/i2c.h>
 #include <linux/module.h>
+#include <linux/property.h>
 #include <linux/of_device.h>
 #include "pmbus.h"
 
 enum chips { mpq8785 };
 
+static u16 voltage_scale_loop_max_val[] = {
+	[mpq8785] = GENMASK(10, 0),
+};
+
 static int mpq8785_identify(struct i2c_client *client,
 			    struct pmbus_driver_info *info)
 {
@@ -74,6 +79,8 @@ static int mpq8785_probe(struct i2c_client *client)
 	struct device *dev = &client->dev;
 	struct pmbus_driver_info *info;
 	enum chips chip_id;
+	u32 voltage_scale;
+	int ret;
 
 	info = devm_kmemdup(dev, &mpq8785_info, sizeof(*info), GFP_KERNEL);
 	if (!info)
@@ -92,6 +99,17 @@ static int mpq8785_probe(struct i2c_client *client)
 		return -ENODEV;
 	}
 
+	if (!device_property_read_u32(dev, "mps,vout-fb-divider-ratio-permille",
+				      &voltage_scale)) {
+		if (voltage_scale > voltage_scale_loop_max_val[chip_id])
+			return -EINVAL;
+
+		ret = i2c_smbus_write_word_data(client, PMBUS_VOUT_SCALE_LOOP,
+						voltage_scale);
+		if (ret)
+			return ret;
+	}
+
 	return pmbus_do_probe(client, info);
 };
 
-- 
2.51.0

