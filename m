Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D8A7581232;
	Wed,  9 Sep 2026 14:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964710; cv=none; b=Ox3bGCzyYnpPRl6QhwyOEMacfWYMKeYszh7YAxJ7vtzkhezSdIsmCaWQ+g9p27v/EYPcGXPi+3wrhERzmoFFoUeqqDcw+gm/BzDcoLyaf82vq+v82dJgnBOIo44QEMLkm1ddNla3vSXb7fDdltsTnPOeZR+KXGj1spj9njzbbDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964710; c=relaxed/simple;
	bh=H2E2449ImO571kngc/i3kbPvo79C17UCrdLzpRQSHRQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=chtfc7Zi+nfjXiXfjdTTyfXuPB6QFnxxtiZ1oE5t/rPgcL3//Ir++jdd/AURsz4dvsTAN3mbLyWBr9BLVu/LerNN1USlLHL/oOFVPJkiWVCFrKxQ7gZjMUS/f76wU72lGxLxtelFub6ph9wZE2umeddomWwlsRuDNjUonqPaS+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NlwI/kCQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NlwI/kCQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B60201F00A3A;
	Wed,  9 Sep 2026 14:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964708;
	bh=zZdY/lqimGjEmFi+PuRvGYIt8IclCUIFcWoc77+A0Ug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NlwI/kCQU7IXawdIUmZCBQW5f/chE/O0yRARP5k5px8FmsZYZO5hKvWvqVIMWjW01
	 szpllbh5YO2wYmAIP9ppNPMgWhKMFMI7dIQMI0IIR5q5LPIGjkfEfCxb8aeefKSlAz
	 QtqOKBY85MynRrPl6IeMJp78fgrMBChsVy0lSZHw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 478/583] ACPI: x86/rtc-cmos: Use platform device for driver binding
Date: Wed,  9 Sep 2026 15:42:43 +0200
Message-ID: <20260909134254.408815777@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>

[ Upstream commit 2a78e42104444f948698f1225deaf515e9b7224d ]

Modify the rtc-cmos driver to bind to a platform device on systems with
ACPI via acpi_match_table and advertise the CMOST RTC ACPI device IDs
for driver auto-loading.  Note that adding the requisite device IDs to
it and exposing them via MODULE_DEVICE_TABLE() is sufficient for this
purpose.

Since the ACPI device IDs in question are the same as for the CMOS RTC
ACPI scan handler, put them into a common header file and use the
definition from there in both places.

Additionally, to prevent a PNP device from being created for the CMOS
RTC if a platform one is present already, make is_cmos_rtc_device()
check cmos_rtc_platform_device_present introduced previously.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Acked-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://patch.msgid.link/13969123.uLZWGnKmhe@rafael.j.wysocki
Stable-dep-of: a3df8bbe0a70 ("ACPI: TAD: Add locking around AML evaluations")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/acpi_pnp.c     |    2 +-
 drivers/acpi/x86/cmos_rtc.c |    5 +----
 drivers/rtc/rtc-cmos.c      |   10 ++++++++++
 include/linux/acpi.h        |    6 ++++++
 4 files changed, 18 insertions(+), 5 deletions(-)

--- a/drivers/acpi/acpi_pnp.c
+++ b/drivers/acpi/acpi_pnp.c
@@ -385,7 +385,7 @@ static int is_cmos_rtc_device(struct acp
 		{ "PNP0B02" },
 		{""},
 	};
-	return !acpi_match_device_ids(adev, ids);
+	return !cmos_rtc_platform_device_present && !acpi_match_device_ids(adev, ids);
 }
 
 bool acpi_is_pnp_device(struct acpi_device *adev)
--- a/drivers/acpi/x86/cmos_rtc.c
+++ b/drivers/acpi/x86/cmos_rtc.c
@@ -18,10 +18,7 @@
 #include "../internal.h"
 
 static const struct acpi_device_id acpi_cmos_rtc_ids[] = {
-	{ "PNP0B00" },
-	{ "PNP0B01" },
-	{ "PNP0B02" },
-	{}
+	ACPI_CMOS_RTC_IDS
 };
 
 bool cmos_rtc_platform_device_present;
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -27,6 +27,7 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
+#include <linux/acpi.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/init.h>
@@ -1482,6 +1483,14 @@ static __init void cmos_of_init(struct p
 #else
 static inline void cmos_of_init(struct platform_device *pdev) {}
 #endif
+
+#ifdef CONFIG_ACPI
+static const struct acpi_device_id acpi_cmos_rtc_ids[] = {
+	ACPI_CMOS_RTC_IDS
+};
+MODULE_DEVICE_TABLE(acpi, acpi_cmos_rtc_ids);
+#endif
+
 /*----------------------------------------------------------------*/
 
 /* Platform setup should have set up an RTC device, when PNP is
@@ -1536,6 +1545,7 @@ static struct platform_driver cmos_platf
 		.name		= driver_name,
 		.pm		= &cmos_pm_ops,
 		.of_match_table = of_match_ptr(of_cmos_match),
+		.acpi_match_table = ACPI_PTR(acpi_cmos_rtc_ids),
 	}
 };
 
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -779,6 +779,12 @@ const char *acpi_get_subsystem_id(acpi_h
 int acpi_mrrm_max_mem_region(void);
 #endif
 
+#define ACPI_CMOS_RTC_IDS	\
+	{ "PNP0B00", },		\
+	{ "PNP0B01", },		\
+	{ "PNP0B02", },		\
+	{ "", }
+
 extern bool cmos_rtc_platform_device_present;
 
 #else	/* !CONFIG_ACPI */


