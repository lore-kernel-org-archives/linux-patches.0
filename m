Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BF1B1863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:38:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 137B6C433D2;
	Wed, 28 Dec 2022 15:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672241926;
	bh=9x8K+ZDgF+rIxwLRPezL21+j8zdaxC1xR6bRxeweS7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qh19FmWs9wMuE8pR/3tEo9Hzt2/1JzA/00D95w02X0FCOb4aFweKh3SKjBH5WNhLu
	 Q2muKZfjs7PgYmFFDLsohGSKmaG2NJeniYbucgI41x1img/bGXilcIQkcfytjPJ3S7
	 1CKZMuvk2ROzieFaUNf/ujig5OgidusbqVgPNmNo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Zhang Rui <rui.zhang@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 543/731] rtc: cmos: Call rtc_wake_setup() from cmos_do_probe()
Date: Wed, 28 Dec 2022 15:40:50 +0100
Message-Id: <20221228144312.284156250@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit 375bbba09692fe4c5218eddee8e312dd733fa846 ]

To reduce code duplication, move the invocation of rtc_wake_setup()
into cmos_do_probe() and simplify the callers of the latter.

No intentional functional impact.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Zhang Rui <rui.zhang@intel.com>
Tested-by: Zhang Rui <rui.zhang@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/2143522.irdbgypaU6@kreacher
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Stable-dep-of: 83ebb7b3036d ("rtc: cmos: Disable ACPI RTC event on removal")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-cmos.c | 28 ++++++++++++----------------
 1 file changed, 12 insertions(+), 16 deletions(-)

diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index a84262265d6d..583116994a37 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -744,6 +744,7 @@ static irqreturn_t cmos_interrupt(int irq, void *p)
 		return IRQ_NONE;
 }
 
+static inline void rtc_wake_setup(struct device *dev);
 static void cmos_wake_setup(struct device *dev);
 
 #ifdef	CONFIG_PNP
@@ -938,6 +939,13 @@ cmos_do_probe(struct device *dev, struct resource *ports, int rtc_irq)
 	nvmem_cfg.size = address_space - NVRAM_OFFSET;
 	devm_rtc_nvmem_register(cmos_rtc.rtc, &nvmem_cfg);
 
+	/*
+	 * Everything has gone well so far, so by default register a handler for
+	 * the ACPI RTC fixed event.
+	 */
+	if (!info)
+		rtc_wake_setup(dev);
+
 	dev_info(dev, "%s%s, %d bytes nvram%s\n",
 		 !is_valid_irq(rtc_irq) ? "no alarms" :
 		 cmos_rtc.mon_alrm ? "alarms up to one year" :
@@ -1357,7 +1365,7 @@ static void rtc_wake_setup(struct device *dev)
 
 static int cmos_pnp_probe(struct pnp_dev *pnp, const struct pnp_device_id *id)
 {
-	int irq, ret;
+	int irq;
 
 	if (pnp_port_start(pnp, 0) == 0x70 && !pnp_irq_valid(pnp, 0)) {
 		irq = 0;
@@ -1373,13 +1381,7 @@ static int cmos_pnp_probe(struct pnp_dev *pnp, const struct pnp_device_id *id)
 		irq = pnp_irq(pnp, 0);
 	}
 
-	ret = cmos_do_probe(&pnp->dev, pnp_get_resource(pnp, IORESOURCE_IO, 0), irq);
-	if (ret)
-		return ret;
-
-	rtc_wake_setup(&pnp->dev);
-
-	return 0;
+	return cmos_do_probe(&pnp->dev, pnp_get_resource(pnp, IORESOURCE_IO, 0), irq);
 }
 
 static void cmos_pnp_remove(struct pnp_dev *pnp)
@@ -1463,7 +1465,7 @@ static inline void cmos_of_init(struct platform_device *pdev) {}
 static int __init cmos_platform_probe(struct platform_device *pdev)
 {
 	struct resource *resource;
-	int irq, ret;
+	int irq;
 
 	cmos_of_init(pdev);
 
@@ -1475,13 +1477,7 @@ static int __init cmos_platform_probe(struct platform_device *pdev)
 	if (irq < 0)
 		irq = -1;
 
-	ret = cmos_do_probe(&pdev->dev, resource, irq);
-	if (ret)
-		return ret;
-
-	rtc_wake_setup(&pdev->dev);
-
-	return 0;
+	return cmos_do_probe(&pdev->dev, resource, irq);
 }
 
 static int cmos_platform_remove(struct platform_device *pdev)
-- 
2.35.1



