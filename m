Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A96E33F59A;
	Sat, 12 Sep 2026 11:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213329; cv=none; b=eTEYZ0z1b9lf0SqXJP1eUuiY7Wk0lI3QFMagvwkU5cfGeYH5LZl4cGLswS2l8TTC2QEyKPpcMjuX2Xa4OeYqC3hWzfKySOR2yDN/N5Et6EnGrrtxATCBS3oVvG27GmnjSnbwpR3+8DFeUl+8rBrlUeIJnq0logJdOXyizgNNdNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213329; c=relaxed/simple;
	bh=l9qArUYmemzKpVFxh6YuX+cun6cYYxAV1U2u4+5z2T8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NQM8rlYxcCbl2iU5tKFwdQ6tk+VSaRjZFplqCC/Oz/YwXcHu6aP3lCa6ZO2Z3UnoQaLRnIDjyNLh4XkJCsZjs8MMQ7wYtCeAo2e5FIY9JU5Mt7aAPL7OUk7sjxtCPG4TySWPIL0sjJCt1uVpJAi7O7desjNCFjJlzRwURwRe01c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uGtE1e5w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uGtE1e5w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B02EB1F000FF;
	Sat, 12 Sep 2026 11:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213328;
	bh=z0MggoMdrBXoA8y3+QtrRzHyWnhh6cTgSRbDHuqwca4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uGtE1e5wZvTekikJxeO+EYIrREIpBa54Nppv61lM27JOI1JYp6Xnvz8LUCwcIwRO2
	 gEr/HBahpWUG3oj/MZYaSvVI9tTZX0V5Q9QTw8fxzkWsjlNiYcoKSeavE7yKzCl11H
	 cThhDgMEeyuB3zOzHefpKO0AKRlYX/SBbPjluO2s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mahesh Kumar G <mahe657@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Sourabh Jain <sourabhjain@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Subject: [PATCH 6.12 0100/1376] powerpc/crash: stop watchdogs before booting kdump kernel
Date: Sat, 12 Sep 2026 08:42:06 +0200
Message-ID: <20260912065609.787351188@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sourabh Jain <sourabhjain@linux.ibm.com>

commit fb43ba4256543ce18ca0540fc37022bda438a293 upstream.

On pseries LPAR systems, watchdog timers configured from userspace can
remain active after a kernel panic. When a panic triggers kdump, the
crashing kernel jumps directly to the kdump kernel without stopping
active watchdogs. As a result, the watchdogs remain active after the
kdump kernel starts.

If dump capture takes longer than the watchdog timeout, PHYP resets the
LPAR before the dump is fully captured, causing dump capture to fail.

Fix this by issuing the `H_WATCHDOG` hcall during the crash shutdown
sequence to stop all active watchdogs before booting the kdump kernel.

Cc: stable@vger.kernel.org
Fixes: 69472ffa6575 ("watchdog/pseries-wdt: initial support for H_WATCHDOG-based watchdog timers")
Reported-by: Mahesh Kumar G <mahe657@linux.ibm.com>
Suggested-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Signed-off-by: Sourabh Jain <sourabhjain@linux.ibm.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20260727053416.276317-4-sourabhjain@linux.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/include/asm/papr-watchdog.h |    6 ++++++
 arch/powerpc/platforms/pseries/setup.c   |   14 ++++++++++++++
 2 files changed, 20 insertions(+)

--- a/arch/powerpc/include/asm/papr-watchdog.h
+++ b/arch/powerpc/include/asm/papr-watchdog.h
@@ -22,6 +22,12 @@
 #define PSERIES_WDTF_ACTION_DUMP_RESTART	0x3UL	/* dump + restart */
 
 /*
+ * R5: "watchdogNumber":
+ *       PAPR says use -1 (all ones) to stop all watchdogs.
+ */
+#define PSERIES_WDT_NUM_ALL	((unsigned long)-1)
+
+/*
  * H_WATCHDOG Output
  *
  * R3: Return code
--- a/arch/powerpc/platforms/pseries/setup.c
+++ b/arch/powerpc/platforms/pseries/setup.c
@@ -76,6 +76,7 @@
 #include <asm/dtl.h>
 #include <asm/hvconsole.h>
 #include <asm/setup.h>
+#include <asm/papr-watchdog.h>
 
 #include "pseries.h"
 
@@ -187,6 +188,16 @@ static void __init fwnmi_init(void)
 #endif
 }
 
+static void pseries_crash_stop_watchdogs(void)
+{
+	long rc;
+
+	rc = plpar_hcall_norets_notrace(H_WATCHDOG, PSERIES_WDTF_OP_STOP,
+					PSERIES_WDT_NUM_ALL);
+	if (rc != H_SUCCESS && rc != H_NOOP)
+		pr_warn("Could not stop watchdogs before kdump rc=%ld\n", rc);
+}
+
 /*
  * Affix a device for the first timer to the platform bus if
  * we have firmware support for the H_WATCHDOG hypercall.
@@ -205,6 +216,9 @@ static __init int pseries_wdt_init(void)
 		return PTR_ERR(pdev);
 	}
 
+	if (crash_shutdown_register(pseries_crash_stop_watchdogs))
+		pr_warn("Could not register watchdog crash shutdown handler\n");
+
 	return 0;
 }
 machine_subsys_initcall(pseries, pseries_wdt_init);


