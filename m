Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B192B56B872;
	Wed,  9 Sep 2026 14:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964703; cv=none; b=OOz5T+Bskq5jtxz3fYRT60TT0NKo/qvm1m6esOMQilmxdZv82/rf4QfPifAHLBNGccUgHwCogsLTjMQgFuZlpp3H1+71rEgt2LVBKOLmJAb9KI0J6Fky09z3QzCGBya48whAheCp2b/2FQXAFzvm2IE2Lmg4VcBsgDq0H+hhbDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964703; c=relaxed/simple;
	bh=mgfOI48HuIYmYSPOXD9tF3P/7mVRUCcGQO41TCuqKEg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rWTFWlmmNtJHYc/YCeyAgs26/aD9EGMHNZia2JU3OWWmQ/RHhnrArsPhRnW2cPtiebgxfjOV9ay/YwzTQ0YkNNbjTqqFWt2/QskmFurDXBOv9Q1Y0EH7zA54yMEHMKaMyM7mNvFlDFukwTMTEwOq9JY88jwwQWCbJunjPZVf9rk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g4P+K/wv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g4P+K/wv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01A131F00A3A;
	Wed,  9 Sep 2026 14:38:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964702;
	bh=nsEzPHhZgJx1XUePVgzxM+aQLS/FCV2LOQAYHQVc6EU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g4P+K/wvJ2JREPGF+DDdj7dtkufFnB2iLsSb7WHqSLMhmCiQC1/YzLL389OrtQVLo
	 6PNZ2rUuDVv+91UScWb+iJMljgAeXnujCRvNNESNWFeT+/JDRGY8oOwWs5y38aUF62
	 SuLfKPxaONfdEGRZ8ma7oCiaYq46qRvXb2aeuKtI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Dave Hansen <dave.hansen@linux.intel.com>
Subject: [PATCH 6.18 477/583] ACPI: x86: cmos_rtc: Create a CMOS RTC platform device
Date: Wed,  9 Sep 2026 15:42:42 +0200
Message-ID: <20260909134254.378639313@linuxfoundation.org>
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

[ Upstream commit 1ae2f435350ec05224a39995c3a680aa6fdae5a5 ]

Make the CMOS RTC ACPI scan handler create a platform device that will
be used subsequently by rtc-cmos for driver binding on x86 systems with
ACPI and update add_rtc_cmos() to skip registering a fallback platform
device for the CMOS RTC when the above one has been registered.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Acked-by: Dave Hansen <dave.hansen@linux.intel.com> # x86
Link: https://patch.msgid.link/1962427.tdWV9SEqCh@rafael.j.wysocki
Stable-dep-of: a3df8bbe0a70 ("ACPI: TAD: Add locking around AML evaluations")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/rtc.c       |    4 ++++
 drivers/acpi/x86/cmos_rtc.c |    8 ++++++++
 include/linux/acpi.h        |    4 ++++
 3 files changed, 16 insertions(+)

--- a/arch/x86/kernel/rtc.c
+++ b/arch/x86/kernel/rtc.c
@@ -2,6 +2,7 @@
 /*
  * RTC related functions
  */
+#include <linux/acpi.h>
 #include <linux/platform_device.h>
 #include <linux/mc146818rtc.h>
 #include <linux/export.h>
@@ -146,6 +147,9 @@ static __init int add_rtc_cmos(void)
 		}
 	}
 #endif
+	if (cmos_rtc_platform_device_present)
+		return 0;
+
 	if (!x86_platform.legacy.rtc)
 		return -ENODEV;
 
--- a/drivers/acpi/x86/cmos_rtc.c
+++ b/drivers/acpi/x86/cmos_rtc.c
@@ -24,6 +24,8 @@ static const struct acpi_device_id acpi_
 	{}
 };
 
+bool cmos_rtc_platform_device_present;
+
 static bool cmos_rtc_space_handler_present __read_mostly;
 
 static acpi_status acpi_cmos_rtc_space_handler(u32 function,
@@ -103,6 +105,12 @@ static int acpi_cmos_rtc_attach(struct a
 	if (ret < 0)
 		return ret;
 
+	if (IS_ERR_OR_NULL(acpi_create_platform_device(adev, NULL))) {
+		pr_err("Failed to create CMOS-RTC platform device\n");
+		return 0;
+	} else {
+		cmos_rtc_platform_device_present = true;
+	}
 	return 1;
 }
 
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -779,6 +779,8 @@ const char *acpi_get_subsystem_id(acpi_h
 int acpi_mrrm_max_mem_region(void);
 #endif
 
+extern bool cmos_rtc_platform_device_present;
+
 #else	/* !CONFIG_ACPI */
 
 #define acpi_disabled 1
@@ -1104,6 +1106,8 @@ static inline int acpi_mrrm_max_mem_regi
 	return 1;
 }
 
+#define cmos_rtc_platform_device_present	false
+
 #endif	/* !CONFIG_ACPI */
 
 #ifdef CONFIG_ACPI_HMAT


