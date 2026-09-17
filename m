Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0F634ABBD4;
	Thu, 17 Sep 2026 16:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661116; cv=none; b=Bj6o8npZHcJd6TjUDznZQToyutUGD1CpMDD06ovszDDtyjnXTBmReW5qM/PtUQ2AV8Cwu0f/nBuvbZipd09BbhadBuBQUM/wL+LYlkqCeTKY477Qcca5exxrlYm9+/rKyiEZzivlDcsUgrBP5tJstw/aeBqDII+pjEOpo3RRysw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661116; c=relaxed/simple;
	bh=nXUfXtF9jFbVNkjQOsM17dguV3WROzMEEKqZaHoPy0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cyhe4ZtflMLEvlOG3UdYV2mFdgnT7pQW1OmNPjAbVCLZ7sYYd4Tkdq6Yu1B5q6PifRk5TZig+GYTDef9QAKuI9P4AaA3i5MhId364+TiCOVJEb0VIC6zbFJSTh1yuOSZBGub8pu2KgACaApC0G/FdPH9bcSyiAIkDMkFOevHlJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qSnJehHd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qSnJehHd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDD1D1F000FF;
	Thu, 17 Sep 2026 16:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789661114;
	bh=YF2QaR0mSxSuLJJPjrIQigjTs5Zp3bfB/rl14X99sHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qSnJehHdQ63bA2wDRsyaHBxVP9B/TAxzR7K8Hk0x4Io/GBElzldQMmEYy2OoLqEp8
	 Pgf3Uvgog6mlUlqITJRVD7zewxiJY6uDIezkMjhQiBOGERahixXW+7S3jlg6+cN430
	 JqsrX3zAR4tWfhR2Rf+7m3rcEP2Yjq+oKVBjSQvI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Pearson <mpearson-lenovo@squebb.ca>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0088/1250] watchdog: lenovo_se10_wdt: Fix use-after-free and resource leak risk
Date: Thu, 17 Sep 2026 15:58:03 +0100
Message-ID: <20260917151554.367929570@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Pearson <mpearson-lenovo@squebb.ca>

[ Upstream commit 3394e894880a60338a2981dd688fd25e88d79667 ]

Review by sashiko.dev highlighted potential use after free and resource
leak instances.

Set se10_pdev to null to prevent use after free

Remove DMI call back and instead directly call
se10_create_platform_device. Handle error cases appropriately

Link: https://sashiko.dev/#/patchset/20260428124954.1193450-1-mpearson-lenovo%40squebb.ca

Signed-off-by: Mark Pearson <mpearson-lenovo@squebb.ca>
Link: https://lore.kernel.org/r/20260504180159.999189-1-mpearson-lenovo@squebb.ca
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/lenovo_se10_wdt.c | 32 ++++++++++++++----------------
 1 file changed, 15 insertions(+), 17 deletions(-)

diff --git a/drivers/watchdog/lenovo_se10_wdt.c b/drivers/watchdog/lenovo_se10_wdt.c
index 99ff01af41243..503e220263f95 100644
--- a/drivers/watchdog/lenovo_se10_wdt.c
+++ b/drivers/watchdog/lenovo_se10_wdt.c
@@ -224,7 +224,7 @@ static struct platform_driver se10_wdt_driver = {
 	.probe  = se10_wdt_probe,
 };
 
-static int se10_create_platform_device(const struct dmi_system_id *id)
+static int se10_create_platform_device(void)
 {
 	int err;
 
@@ -233,9 +233,10 @@ static int se10_create_platform_device(const struct dmi_system_id *id)
 		return -ENOMEM;
 
 	err = platform_device_add(se10_pdev);
-	if (err)
+	if (err) {
 		platform_device_put(se10_pdev);
-
+		se10_pdev = NULL;
+	}
 	return err;
 }
 
@@ -246,7 +247,6 @@ static const struct dmi_system_id se10_dmi_table[] __initconst = {
 			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "12NH"),
 		},
-		.callback = se10_create_platform_device,
 	},
 	{
 		.ident = "LENOVO-SE10",
@@ -254,7 +254,6 @@ static const struct dmi_system_id se10_dmi_table[] __initconst = {
 			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "12NJ"),
 		},
-		.callback = se10_create_platform_device,
 	},
 	{
 		.ident = "LENOVO-SE10",
@@ -262,7 +261,6 @@ static const struct dmi_system_id se10_dmi_table[] __initconst = {
 			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "12NK"),
 		},
-		.callback = se10_create_platform_device,
 	},
 	{
 		.ident = "LENOVO-SE10",
@@ -270,7 +268,6 @@ static const struct dmi_system_id se10_dmi_table[] __initconst = {
 			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "12NL"),
 		},
-		.callback = se10_create_platform_device,
 	},
 	{
 		.ident = "LENOVO-SE10",
@@ -278,7 +275,6 @@ static const struct dmi_system_id se10_dmi_table[] __initconst = {
 			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "12NM"),
 		},
-		.callback = se10_create_platform_device,
 	},
 	{
 		.ident = "LENOVO-SE10-G2",
@@ -286,7 +282,6 @@ static const struct dmi_system_id se10_dmi_table[] __initconst = {
 			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "13LJ"),
 		},
-		.callback = se10_create_platform_device,
 	},
 	{
 		.ident = "LENOVO-SE10-G2",
@@ -294,7 +289,6 @@ static const struct dmi_system_id se10_dmi_table[] __initconst = {
 			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "13LK"),
 		},
-		.callback = se10_create_platform_device,
 	},
 	{
 		.ident = "LENOVO-SE10-G2",
@@ -302,7 +296,6 @@ static const struct dmi_system_id se10_dmi_table[] __initconst = {
 			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "13S1"),
 		},
-		.callback = se10_create_platform_device,
 	},
 	{
 		.ident = "LENOVO-SE10-G2",
@@ -310,7 +303,6 @@ static const struct dmi_system_id se10_dmi_table[] __initconst = {
 			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "13S2"),
 		},
-		.callback = se10_create_platform_device,
 	},
 	{
 		.ident = "LENOVO-SE10-G2",
@@ -318,7 +310,6 @@ static const struct dmi_system_id se10_dmi_table[] __initconst = {
 			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "13S3"),
 		},
-		.callback = se10_create_platform_device,
 	},
 	{
 		.ident = "LENOVO-SE10-G2",
@@ -326,7 +317,6 @@ static const struct dmi_system_id se10_dmi_table[] __initconst = {
 			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "13S4"),
 		},
-		.callback = se10_create_platform_device,
 	},
 	{
 		.ident = "LENOVO-SE10-G2",
@@ -334,7 +324,6 @@ static const struct dmi_system_id se10_dmi_table[] __initconst = {
 			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "13S5"),
 		},
-		.callback = se10_create_platform_device,
 	},
 	{
 		.ident = "LENOVO-SE10-G2",
@@ -342,7 +331,6 @@ static const struct dmi_system_id se10_dmi_table[] __initconst = {
 			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
 			DMI_MATCH(DMI_PRODUCT_NAME, "13S6"),
 		},
-		.callback = se10_create_platform_device,
 	},
 	{}
 };
@@ -350,10 +338,20 @@ MODULE_DEVICE_TABLE(dmi, se10_dmi_table);
 
 static int __init se10_wdt_init(void)
 {
+	int err;
+
 	if (!dmi_check_system(se10_dmi_table))
 		return -ENODEV;
 
-	return platform_driver_register(&se10_wdt_driver);
+	err = platform_driver_register(&se10_wdt_driver);
+	if (err)
+		return err;
+
+	err = se10_create_platform_device();
+	if (err)
+		platform_driver_unregister(&se10_wdt_driver);
+
+	return err;
 }
 
 static void __exit se10_wdt_exit(void)
-- 
2.53.0



