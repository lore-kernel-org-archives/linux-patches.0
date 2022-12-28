Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50CB61863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:39:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5C26C433D2;
	Wed, 28 Dec 2022 15:39:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672241953;
	bh=KwKXfZxx3BpPf4NQPS+b85R1s5ASnGewBVbenXMEt2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DW8vLS3anZM1t/toDS7NZjW/ZXZ4I6oXGA8mJA1Bns3ABfaa0slPhFKFUPkhqg2p6
	 4n+P2eY6bID3Duw/4zo4GhNXkzt2lBBrWBeH/A3B8MN1cPcTlwu+bEWj8qcQqAvev9
	 5HQdDKjCjC2Gg3JRVvIxwgEWan48H/bU1HzZuNxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Zhang Rui <rui.zhang@intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 546/731] rtc: cmos: Disable ACPI RTC event on removal
Date: Wed, 28 Dec 2022 15:40:53 +0100
Message-Id: <20221228144312.369745226@linuxfoundation.org>
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



