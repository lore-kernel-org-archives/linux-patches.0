Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D0631C08
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:35:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C577AC433EF;
	Wed, 28 Dec 2022 16:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672245316;
	bh=KwKXfZxx3BpPf4NQPS+b85R1s5ASnGewBVbenXMEt2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e8qQejnYiworIA8hwF3Z367hK8MKh76VbZo75dy8IcBKEvu/eDPNqf75TVLTazcT4
	 J/kpQ9gjsV8zu/+ZlaiKBPrMqMw8cjWQ6c1//b2ktCWuICqxUWlFyh+ODhL1HaHoLT
	 p2WU/1OLqW/eBb/PixCVss1GhEk8gXZ1AaL9hFGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Zhang Rui <rui.zhang@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0838/1146] rtc: cmos: Disable ACPI RTC event on removal
Date: Wed, 28 Dec 2022 15:39:37 +0100
Message-Id: <20221228144352.918957068@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

[ Upstream commit 83ebb7b3036d151ee39a4a752018665648fc3bd4 ]

Make cmos_do_remove() drop the ACPI RTC fixed event handler so as to
prevent it from operating on stale data in case the event triggers
after driver removal.

Fixes: 311ee9c151ad ("rtc: cmos: allow using ACPI for RTC alarm instead of HPET")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Zhang Rui <rui.zhang@intel.com>
Tested-by: Zhang Rui <rui.zhang@intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/2224609.iZASKD2KPV@kreacher
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-cmos.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index 039486bfedf4..00e2ca7374ec 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -798,6 +798,14 @@ static void acpi_rtc_event_setup(struct device *dev)
 	acpi_disable_event(ACPI_EVENT_RTC, 0);
 }
 
+static void acpi_rtc_event_cleanup(void)
+{
+	if (acpi_disabled)
+		return;
+
+	acpi_remove_fixed_event_handler(ACPI_EVENT_RTC, rtc_handler);
+}
+
 static void rtc_wake_on(struct device *dev)
 {
 	acpi_clear_event(ACPI_EVENT_RTC);
@@ -884,6 +892,10 @@ static inline void acpi_rtc_event_setup(struct device *dev)
 {
 }
 
+static inline void acpi_rtc_event_cleanup(void)
+{
+}
+
 static inline void acpi_cmos_wake_setup(struct device *dev)
 {
 }
@@ -1138,6 +1150,9 @@ static void cmos_do_remove(struct device *dev)
 			hpet_unregister_irq_handler(cmos_interrupt);
 	}
 
+	if (!dev_get_platdata(dev))
+		acpi_rtc_event_cleanup();
+
 	cmos->rtc = NULL;
 
 	ports = cmos->iomem;
-- 
2.35.1



