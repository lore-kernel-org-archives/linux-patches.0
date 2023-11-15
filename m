Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18EED3A8F2
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uV1ba0YY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C142DC433C9;
	Wed, 15 Nov 2023 19:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077848;
	bh=kkUhoKOPjqVrw3JURDbyklWE42AI7aXk+h3qZOEmAXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uV1ba0YYMzhDEoMS/2VslbsgcjHZyNjGXhMtSQKCMdSw543gdc4FF4p4cPm/JQYem
	 XIzaGxxA2KmKas4OVpyq/Ca9idsWCjjVTSPfT8KK7qAn6lHapVsjdDfsbwn19iptF3
	 KY2jHX/E9FquoC7kG35Yshfh9tCz3bEzG/9VZsUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linus.walleij@linaro.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Wim Van Sebroeck <wim@linux-watchdog.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 540/603] watchdog: ixp4xx: Make sure restart always works
Date: Wed, 15 Nov 2023 14:18:05 -0500
Message-ID: <20231115191649.183935257@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit b4075ecfe348a44209534c75ad72392c63a489a6 ]

The IXP4xx watchdog in early "A0" silicon is unreliable and
cannot be registered, however for some systems such as the
USRobotics USR8200 the watchdog is the only restart option,
so implement a "dummy" watchdog that can only support restart
in this case.

Fixes: 1aea522809e6 ("watchdog: ixp4xx: Implement restart")
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20230926-ixp4xx-wdt-restart-v2-1-15cf4639b423@linaro.org
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/watchdog/ixp4xx_wdt.c | 28 +++++++++++++++++++++++++---
 1 file changed, 25 insertions(+), 3 deletions(-)

diff --git a/drivers/watchdog/ixp4xx_wdt.c b/drivers/watchdog/ixp4xx_wdt.c
index 607ce4b8df574..ec0c08652ec2f 100644
--- a/drivers/watchdog/ixp4xx_wdt.c
+++ b/drivers/watchdog/ixp4xx_wdt.c
@@ -105,6 +105,25 @@ static const struct watchdog_ops ixp4xx_wdt_ops = {
 	.owner = THIS_MODULE,
 };
 
+/*
+ * The A0 version of the IXP422 had a bug in the watchdog making
+ * is useless, but we still need to use it to restart the system
+ * as it is the only way, so in this special case we register a
+ * "dummy" watchdog that doesn't really work, but will support
+ * the restart operation.
+ */
+static int ixp4xx_wdt_dummy(struct watchdog_device *wdd)
+{
+	return 0;
+}
+
+static const struct watchdog_ops ixp4xx_wdt_restart_only_ops = {
+	.start = ixp4xx_wdt_dummy,
+	.stop = ixp4xx_wdt_dummy,
+	.restart = ixp4xx_wdt_restart,
+	.owner = THIS_MODULE,
+};
+
 static const struct watchdog_info ixp4xx_wdt_info = {
 	.options = WDIOF_KEEPALIVEPING
 		| WDIOF_MAGICCLOSE
@@ -114,14 +133,17 @@ static const struct watchdog_info ixp4xx_wdt_info = {
 
 static int ixp4xx_wdt_probe(struct platform_device *pdev)
 {
+	static const struct watchdog_ops *iwdt_ops;
 	struct device *dev = &pdev->dev;
 	struct ixp4xx_wdt *iwdt;
 	struct clk *clk;
 	int ret;
 
 	if (!(read_cpuid_id() & 0xf) && !cpu_is_ixp46x()) {
-		dev_err(dev, "Rev. A0 IXP42x CPU detected - watchdog disabled\n");
-		return -ENODEV;
+		dev_info(dev, "Rev. A0 IXP42x CPU detected - only restart supported\n");
+		iwdt_ops = &ixp4xx_wdt_restart_only_ops;
+	} else {
+		iwdt_ops = &ixp4xx_wdt_ops;
 	}
 
 	iwdt = devm_kzalloc(dev, sizeof(*iwdt), GFP_KERNEL);
@@ -141,7 +163,7 @@ static int ixp4xx_wdt_probe(struct platform_device *pdev)
 		iwdt->rate = IXP4XX_TIMER_FREQ;
 
 	iwdt->wdd.info = &ixp4xx_wdt_info;
-	iwdt->wdd.ops = &ixp4xx_wdt_ops;
+	iwdt->wdd.ops = iwdt_ops;
 	iwdt->wdd.min_timeout = 1;
 	iwdt->wdd.max_timeout = U32_MAX / iwdt->rate;
 	iwdt->wdd.parent = dev;
-- 
2.42.0



