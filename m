Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3086D1494A6;
	Wed, 19 Jun 2024 13:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802687; cv=none; b=rcVxhgbLI15BTd0VN+U808z8TAaDVAbLFY23AjA4Gm26M2Z19nvJgWkmjgw5nXSsCg5w+Dzb77c1vuZ5n5sfOtMLZauEvKkyB7owP5WjvbFASpsrQy6Mm1o3aqkjUWALwQ0DJxny6rNTgZzuhnM/UbQnsuilt6vN7tP3Tg1lhdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802687; c=relaxed/simple;
	bh=hY3ItH+G3kYiK0NZSjnutB2vbJynyptBAmp8yJaS33k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A2QZ+xeIG55mk+PzIa95CT5jEX85+qG2L/Cc2vMqWFNrRb/FnIyEo6maNtmqSQXaxduqk7RmlIYuBUon4nsqDQ/qEidL/qMM6PASsLaEZARO6gdV3s9VTatDWxAovZVw5NMWQS0fNroDexb75SETRhki/V7GUqZLU2DoFqtWaN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wan+kxrq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wan+kxrq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48F46C32786;
	Wed, 19 Jun 2024 13:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802685;
	bh=hY3ItH+G3kYiK0NZSjnutB2vbJynyptBAmp8yJaS33k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wan+kxrq6mWtkbMBq5M+LttJmux4fXSbuGUbwaATMlzcuW4IiCrgqRne1TvOnJro5
	 Wt3EMRgwVJkJmXn38NVt55QaXkhgBct4MQV90R3emEU4Gwi4kpa1SwczL/U3e3vJK+
	 p3gm4YMczdklJp/9kwl7XyH90FUi8q+DX+q3C9lY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Mario Limonciello <mario.limonciello@amd.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 005/281] cpufreq: amd-pstate: remove global header file
Date: Wed, 19 Jun 2024 14:52:44 +0200
Message-ID: <20240619125610.049884759@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 779b8a14afde110dd3502566be907289eba72447 ]

When extra warnings are enabled, gcc points out a global variable
definition in a header:

In file included from drivers/cpufreq/amd-pstate-ut.c:29:
include/linux/amd-pstate.h:123:27: error: 'amd_pstate_mode_string' defined but not used [-Werror=unused-const-variable=]
  123 | static const char * const amd_pstate_mode_string[] = {
      |                           ^~~~~~~~~~~~~~~~~~~~~~

This header is only included from two files in the same directory,
and one of them uses only a single definition from it, so clean it
up by moving most of the contents into the driver that uses them,
and making shared bits a local header file.

Fixes: 36c5014e5460 ("cpufreq: amd-pstate: optimize driver working mode selection in amd_pstate_param()")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 MAINTAINERS                                   |  1 -
 drivers/cpufreq/amd-pstate-ut.c               |  3 +-
 drivers/cpufreq/amd-pstate.c                  | 34 ++++++++++++++++++-
 .../linux => drivers/cpufreq}/amd-pstate.h    | 33 ------------------
 4 files changed, 35 insertions(+), 36 deletions(-)
 rename {include/linux => drivers/cpufreq}/amd-pstate.h (81%)

diff --git a/MAINTAINERS b/MAINTAINERS
index 28e20975c26f5..3121709d99e3b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1066,7 +1066,6 @@ L:	linux-pm@vger.kernel.org
 S:	Supported
 F:	Documentation/admin-guide/pm/amd-pstate.rst
 F:	drivers/cpufreq/amd-pstate*
-F:	include/linux/amd-pstate.h
 F:	tools/power/x86/amd_pstate_tracer/amd_pstate_trace.py
 
 AMD PTDMA DRIVER
diff --git a/drivers/cpufreq/amd-pstate-ut.c b/drivers/cpufreq/amd-pstate-ut.c
index f04ae67dda372..fc275d41d51e9 100644
--- a/drivers/cpufreq/amd-pstate-ut.c
+++ b/drivers/cpufreq/amd-pstate-ut.c
@@ -26,10 +26,11 @@
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/fs.h>
-#include <linux/amd-pstate.h>
 
 #include <acpi/cppc_acpi.h>
 
+#include "amd-pstate.h"
+
 /*
  * Abbreviations:
  * amd_pstate_ut: used as a shortform for AMD P-State unit test.
diff --git a/drivers/cpufreq/amd-pstate.c b/drivers/cpufreq/amd-pstate.c
index 605b037913ff8..6c989d859b396 100644
--- a/drivers/cpufreq/amd-pstate.c
+++ b/drivers/cpufreq/amd-pstate.c
@@ -36,7 +36,6 @@
 #include <linux/delay.h>
 #include <linux/uaccess.h>
 #include <linux/static_call.h>
-#include <linux/amd-pstate.h>
 #include <linux/topology.h>
 
 #include <acpi/processor.h>
@@ -46,6 +45,8 @@
 #include <asm/processor.h>
 #include <asm/cpufeature.h>
 #include <asm/cpu_device_id.h>
+
+#include "amd-pstate.h"
 #include "amd-pstate-trace.h"
 
 #define AMD_PSTATE_TRANSITION_LATENCY	20000
@@ -53,6 +54,37 @@
 #define CPPC_HIGHEST_PERF_PERFORMANCE	196
 #define CPPC_HIGHEST_PERF_DEFAULT	166
 
+#define AMD_CPPC_EPP_PERFORMANCE		0x00
+#define AMD_CPPC_EPP_BALANCE_PERFORMANCE	0x80
+#define AMD_CPPC_EPP_BALANCE_POWERSAVE		0xBF
+#define AMD_CPPC_EPP_POWERSAVE			0xFF
+
+/*
+ * enum amd_pstate_mode - driver working mode of amd pstate
+ */
+enum amd_pstate_mode {
+	AMD_PSTATE_UNDEFINED = 0,
+	AMD_PSTATE_DISABLE,
+	AMD_PSTATE_PASSIVE,
+	AMD_PSTATE_ACTIVE,
+	AMD_PSTATE_GUIDED,
+	AMD_PSTATE_MAX,
+};
+
+static const char * const amd_pstate_mode_string[] = {
+	[AMD_PSTATE_UNDEFINED]   = "undefined",
+	[AMD_PSTATE_DISABLE]     = "disable",
+	[AMD_PSTATE_PASSIVE]     = "passive",
+	[AMD_PSTATE_ACTIVE]      = "active",
+	[AMD_PSTATE_GUIDED]      = "guided",
+	NULL,
+};
+
+struct quirk_entry {
+	u32 nominal_freq;
+	u32 lowest_freq;
+};
+
 /*
  * TODO: We need more time to fine tune processors with shared memory solution
  * with community together.
diff --git a/include/linux/amd-pstate.h b/drivers/cpufreq/amd-pstate.h
similarity index 81%
rename from include/linux/amd-pstate.h
rename to drivers/cpufreq/amd-pstate.h
index 7b2cbb892fd91..bc341f35908d7 100644
--- a/include/linux/amd-pstate.h
+++ b/drivers/cpufreq/amd-pstate.h
@@ -1,7 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0-only */
 /*
- * linux/include/linux/amd-pstate.h
- *
  * Copyright (C) 2022 Advanced Micro Devices, Inc.
  *
  * Author: Meng Li <li.meng@amd.com>
@@ -12,11 +10,6 @@
 
 #include <linux/pm_qos.h>
 
-#define AMD_CPPC_EPP_PERFORMANCE		0x00
-#define AMD_CPPC_EPP_BALANCE_PERFORMANCE	0x80
-#define AMD_CPPC_EPP_BALANCE_POWERSAVE		0xBF
-#define AMD_CPPC_EPP_POWERSAVE			0xFF
-
 /*********************************************************************
  *                        AMD P-state INTERFACE                       *
  *********************************************************************/
@@ -104,30 +97,4 @@ struct amd_cpudata {
 	bool	suspended;
 };
 
-/*
- * enum amd_pstate_mode - driver working mode of amd pstate
- */
-enum amd_pstate_mode {
-	AMD_PSTATE_UNDEFINED = 0,
-	AMD_PSTATE_DISABLE,
-	AMD_PSTATE_PASSIVE,
-	AMD_PSTATE_ACTIVE,
-	AMD_PSTATE_GUIDED,
-	AMD_PSTATE_MAX,
-};
-
-static const char * const amd_pstate_mode_string[] = {
-	[AMD_PSTATE_UNDEFINED]   = "undefined",
-	[AMD_PSTATE_DISABLE]     = "disable",
-	[AMD_PSTATE_PASSIVE]     = "passive",
-	[AMD_PSTATE_ACTIVE]      = "active",
-	[AMD_PSTATE_GUIDED]      = "guided",
-	NULL,
-};
-
-struct quirk_entry {
-	u32 nominal_freq;
-	u32 lowest_freq;
-};
-
 #endif /* _LINUX_AMD_PSTATE_H */
-- 
2.43.0



