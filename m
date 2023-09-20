Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 621A0156E5
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:37:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA816C433CA;
	Wed, 20 Sep 2023 12:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695213455;
	bh=THwI41OuR9mFZxhiEMiU50IASVJEvWqK4gZnu7JU9Lg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oIRPmdbtS8mIsE6H5aKCb271gwqAhK+Qrd/wWxL1kM1yEB3hIzI1hFszoeEbO2QH2
	 snx5V1VLp3H0d1jC9txNCXM7pogS7PmbQpw58nlO8V0k1w8W8ehjbCCqQtNWjNQEH1
	 bXF9aDbSs2BhhEKIG1JjpM9tOXmt/1YTABP3Vsls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Max Filippov <jcmvbkbc@gmail.com>
Subject: [PATCH 5.4 217/367] xtensa: PMU: fix base address for the newer hardware
Date: Wed, 20 Sep 2023 13:29:54 +0200
Message-ID: <20230920112904.217381680@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112858.471730572@linuxfoundation.org>
References: <20230920112858.471730572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Max Filippov <jcmvbkbc@gmail.com>

commit 687eb3c42f4ad81e7c947c50e2d865f692064291 upstream.

With introduction of ERI access control in RG.0 base address of the PMU
unit registers has changed. Add support for the new PMU configuration.

Cc: stable@vger.kernel.org
Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/xtensa/include/asm/core.h  |    9 +++++++++
 arch/xtensa/kernel/perf_event.c |   17 +++++++++++++----
 2 files changed, 22 insertions(+), 4 deletions(-)

--- a/arch/xtensa/include/asm/core.h
+++ b/arch/xtensa/include/asm/core.h
@@ -18,4 +18,13 @@
 #define XCHAL_SPANNING_WAY 0
 #endif
 
+#ifndef XCHAL_HW_MIN_VERSION
+#if defined(XCHAL_HW_MIN_VERSION_MAJOR) && defined(XCHAL_HW_MIN_VERSION_MINOR)
+#define XCHAL_HW_MIN_VERSION (XCHAL_HW_MIN_VERSION_MAJOR * 100 + \
+			      XCHAL_HW_MIN_VERSION_MINOR)
+#else
+#define XCHAL_HW_MIN_VERSION 0
+#endif
+#endif
+
 #endif
--- a/arch/xtensa/kernel/perf_event.c
+++ b/arch/xtensa/kernel/perf_event.c
@@ -13,17 +13,26 @@
 #include <linux/perf_event.h>
 #include <linux/platform_device.h>
 
+#include <asm/core.h>
 #include <asm/processor.h>
 #include <asm/stacktrace.h>
 
+#define XTENSA_HWVERSION_RG_2015_0	260000
+
+#if XCHAL_HW_MIN_VERSION >= XTENSA_HWVERSION_RG_2015_0
+#define XTENSA_PMU_ERI_BASE		0x00101000
+#else
+#define XTENSA_PMU_ERI_BASE		0x00001000
+#endif
+
 /* Global control/status for all perf counters */
-#define XTENSA_PMU_PMG			0x1000
+#define XTENSA_PMU_PMG			XTENSA_PMU_ERI_BASE
 /* Perf counter values */
-#define XTENSA_PMU_PM(i)		(0x1080 + (i) * 4)
+#define XTENSA_PMU_PM(i)		(XTENSA_PMU_ERI_BASE + 0x80 + (i) * 4)
 /* Perf counter control registers */
-#define XTENSA_PMU_PMCTRL(i)		(0x1100 + (i) * 4)
+#define XTENSA_PMU_PMCTRL(i)		(XTENSA_PMU_ERI_BASE + 0x100 + (i) * 4)
 /* Perf counter status registers */
-#define XTENSA_PMU_PMSTAT(i)		(0x1180 + (i) * 4)
+#define XTENSA_PMU_PMSTAT(i)		(XTENSA_PMU_ERI_BASE + 0x180 + (i) * 4)
 
 #define XTENSA_PMU_PMG_PMEN		0x1
 


