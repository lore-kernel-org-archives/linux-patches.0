Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F4C36FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:50:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14AA3C433D2;
	Mon, 16 Jan 2023 16:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673887831;
	bh=yxEXryx1ynYHLIoPetSylwy7bCEhzogdxA7y0PL1MgA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q97G44R8hQS+gYFK9G2IoGwmVhdnYGw27zWM9jieMjnPKtFO0iuNdhIu0vRdfMnQx
	 LqqDTk8SszU6SU2dVI5h9NOjWmDVu3Xb7zeCqqgc+w/FOmtwD8JQex1I433kQSPdPw
	 IjvTzDcr0MgNLiFQNxee5hyYlH5zdwnQ+MAZ2PAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Rui <rui.zhang@intel.com>,
	Todd Brandt <todd.e.brandt@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 268/521] rtc: cmos: Fix wake alarm breakage
Date: Mon, 16 Jan 2023 16:48:50 +0100
Message-Id: <20230116154859.144942165@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
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

[ Upstream commit 0782b66ed2fbb035dda76111df0954515e417b24 ]

Commit 4919d3eb2ec0 ("rtc: cmos: Fix event handler registration
ordering issue") overlooked the fact that cmos_do_probe() depended
on the preparations carried out by cmos_wake_setup() and the wake
alarm stopped working after the ordering of them had been changed.

Address this by partially reverting commit 4919d3eb2ec0 so that
cmos_wake_setup() is called before cmos_do_probe() again and moving
the rtc_wake_setup() invocation from cmos_wake_setup() directly to the
callers of cmos_do_probe() where it will happen after a successful
completion of the latter.

Fixes: 4919d3eb2ec0 ("rtc: cmos: Fix event handler registration ordering issue")
Reported-by: Zhang Rui <rui.zhang@intel.com>
Reported-by: Todd Brandt <todd.e.brandt@linux.intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://lore.kernel.org/r/5887691.lOV4Wx5bFT@kreacher
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Stable-dep-of: 83ebb7b3036d ("rtc: cmos: Disable ACPI RTC event on removal")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-cmos.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index 7962cdd933f9..d8384f7a7381 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -1180,6 +1180,9 @@ static u32 rtc_handler(void *context)
 
 static inline void rtc_wake_setup(struct device *dev)
 {
+	if (acpi_disabled)
+		return;
+
 	acpi_install_fixed_event_handler(ACPI_EVENT_RTC, rtc_handler, dev);
 	/*
 	 * After the RTC handler is installed, the Fixed_RTC event should
@@ -1233,7 +1236,6 @@ static void cmos_wake_setup(struct device *dev)
 
 	use_acpi_alarm_quirks();
 
-	rtc_wake_setup(dev);
 	acpi_rtc_info.wake_on = rtc_wake_on;
 	acpi_rtc_info.wake_off = rtc_wake_off;
 
@@ -1301,6 +1303,8 @@ static int cmos_pnp_probe(struct pnp_dev *pnp, const struct pnp_device_id *id)
 {
 	int irq, ret;
 
+	cmos_wake_setup(&pnp->dev);
+
 	if (pnp_port_start(pnp, 0) == 0x70 && !pnp_irq_valid(pnp, 0)) {
 		irq = 0;
 #ifdef CONFIG_X86
@@ -1319,7 +1323,7 @@ static int cmos_pnp_probe(struct pnp_dev *pnp, const struct pnp_device_id *id)
 	if (ret)
 		return ret;
 
-	cmos_wake_setup(&pnp->dev);
+	rtc_wake_setup(&pnp->dev);
 
 	return 0;
 }
@@ -1408,6 +1412,7 @@ static int __init cmos_platform_probe(struct platform_device *pdev)
 	int irq, ret;
 
 	cmos_of_init(pdev);
+	cmos_wake_setup(&pdev->dev);
 
 	if (RTC_IOMAPPED)
 		resource = platform_get_resource(pdev, IORESOURCE_IO, 0);
@@ -1421,7 +1426,7 @@ static int __init cmos_platform_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	cmos_wake_setup(&pdev->dev);
+	rtc_wake_setup(&pdev->dev);
 
 	return 0;
 }
-- 
2.35.1



