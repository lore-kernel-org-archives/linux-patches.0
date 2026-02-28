Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1A7C344D9A
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301763; cv=none; b=KkwV4W5YSKBJ3kISxAhqS1FUdomVI6erDqj64kJhyEvyuJANItl4eIwRr4YUNOka0OVwBC5v7GK+krBIY31FVqVLLuyhKD6lArAB4sofgv1FCqq1jY0aJ4vupvTq9qWTc3kTWczsdSwSQ2e395v46lBII9b77PvgeMqa4buLSXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301763; c=relaxed/simple;
	bh=2jiGIVAlXZgcuNhab9qcwd4LBatCTbWVbaS/fe2HmvA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=urqZ655HJEcTlt5vHLwK/ovtvSBKx1EF80AdbJnTqyvR9hjgK6epMVUxdMo4T29/b4vEOpJ5BTfVux4AnFPKAMoEpUkkH5PeojY2Yhpegj9Pk4LzSSTDOfh0J6EB868tXlg5uNRnezxO5zPWHDq/6UOVN//g8ayBLu5VF3wNQ3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=czbYq+7u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="czbYq+7u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20AB4C19425;
	Sat, 28 Feb 2026 18:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301763;
	bh=2jiGIVAlXZgcuNhab9qcwd4LBatCTbWVbaS/fe2HmvA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=czbYq+7u5nI3t66iNqTst04wiIxeve0A1tchThNa8+YhINaffGWCozG4eDdzw14dS
	 C5SilNbHCI4jr1j7Vaty8kg/6t34LZwGJez4iX67jL8jEzACQSR/j9jze9I0rmaiSX
	 LZFJUU5sxBTdKFB3MruNP6CBMIDc0fLPd5H4mH1jiaZxWKspsnMEJYacYL2mL8v70D
	 g+M/GOHIS6dJJSLXYjJHBafuAT6I94BdxMSVxv07UZJeoakGCG+XNGtdLaJZwy8B3S
	 PJuPx7HvnYIyMCIp4Zu97fkxCmhHXOfYCckZioiLf2imDA68vFn1T5ok9MCeYeItHu
	 u8CfNZJ4IbA+Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Pawel Dembicki <paweldembicki@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 169/385] hwmon: pmbus: mpq8785: Prepare driver for multiple device support
Date: Sat, 28 Feb 2026 12:56:31 -0500
Message-ID: <20260228180011.1568201-169-sashal@kernel.org>
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

[ Upstream commit 1bc6020dc400ea8290a7b26aa4365d4568e23e27 ]

Refactor the driver to support multiple Monolithic Power Systems devices.
Introduce chip ID handling based on device tree matching.

No functional changes intended.

Signed-off-by: Pawel Dembicki <paweldembicki@gmail.com>
Link: https://lore.kernel.org/r/20250511035701.2607947-3-paweldembicki@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Stable-dep-of: 9e33c1dba224 ("hwmon: (pmbus/mpq8785) fix VOUT_MODE mismatch during identification")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/pmbus/mpq8785.c | 38 +++++++++++++++++++++++++++--------
 1 file changed, 30 insertions(+), 8 deletions(-)

diff --git a/drivers/hwmon/pmbus/mpq8785.c b/drivers/hwmon/pmbus/mpq8785.c
index 7f87e117b49de..e260cb3b34c45 100644
--- a/drivers/hwmon/pmbus/mpq8785.c
+++ b/drivers/hwmon/pmbus/mpq8785.c
@@ -8,6 +8,8 @@
 #include <linux/of_device.h>
 #include "pmbus.h"
 
+enum chips { mpq8785 };
+
 static int mpq8785_identify(struct i2c_client *client,
 			    struct pmbus_driver_info *info)
 {
@@ -53,26 +55,46 @@ static struct pmbus_driver_info mpq8785_info = {
 		PMBUS_HAVE_VOUT | PMBUS_HAVE_STATUS_VOUT |
 		PMBUS_HAVE_IOUT | PMBUS_HAVE_STATUS_IOUT |
 		PMBUS_HAVE_TEMP | PMBUS_HAVE_STATUS_TEMP,
-	.identify = mpq8785_identify,
-};
-
-static int mpq8785_probe(struct i2c_client *client)
-{
-	return pmbus_do_probe(client, &mpq8785_info);
 };
 
 static const struct i2c_device_id mpq8785_id[] = {
-	{ "mpq8785" },
+	{ "mpq8785", mpq8785 },
 	{ },
 };
 MODULE_DEVICE_TABLE(i2c, mpq8785_id);
 
 static const struct of_device_id __maybe_unused mpq8785_of_match[] = {
-	{ .compatible = "mps,mpq8785" },
+	{ .compatible = "mps,mpq8785", .data = (void *)mpq8785 },
 	{}
 };
 MODULE_DEVICE_TABLE(of, mpq8785_of_match);
 
+static int mpq8785_probe(struct i2c_client *client)
+{
+	struct device *dev = &client->dev;
+	struct pmbus_driver_info *info;
+	enum chips chip_id;
+
+	info = devm_kmemdup(dev, &mpq8785_info, sizeof(*info), GFP_KERNEL);
+	if (!info)
+		return -ENOMEM;
+
+	if (dev->of_node)
+		chip_id = (kernel_ulong_t)of_device_get_match_data(dev);
+	else
+		chip_id = (kernel_ulong_t)i2c_get_match_data(client);
+
+	switch (chip_id) {
+	case mpq8785:
+		info->identify = mpq8785_identify;
+		break;
+	default:
+		return -ENODEV;
+	}
+
+	return pmbus_do_probe(client, info);
+};
+
 static struct i2c_driver mpq8785_driver = {
 	.driver = {
 		   .name = "mpq8785",
-- 
2.51.0

