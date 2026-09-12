Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F5B62FD7C3;
	Sat, 12 Sep 2026 13:57:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789221446; cv=none; b=niv28c1IbOzIyFwJD+gKL7aWX9AlEKP2f5L1j0714aoU1m75EwnmTkg8N9cKI+HNj0Pk/JuYLl3HWtgFzXrrOKZ14Ck+ujWZKo2wefDl0ByasHqzfhWwoDswCKXFa0DDiRI7j/erHeec/eTpR7VWE7SRReLrzfAo7jISY1rJXT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789221446; c=relaxed/simple;
	bh=y16aLihL65SdbST1uC+kxtZxkcMbayB6xD3TkxB8YLA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jhQP5c8XCv4OoN02JJz5u5vDpJBmYyk3JBE2H/zfcck0nwAe1RGBYrTxT+NKE0frZX+WcxTWegb7hKdYlfQwaM8l+/hPsQfpfttSPKRxzBRk0yn9tsIQBr3+skkFq5dXdshnmGu5rLr19lhTVHT7/jV8cROUsBgY3ZmF/LGIJD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jcuWto4f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jcuWto4f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6509D1F000FF;
	Sat, 12 Sep 2026 13:57:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789221445;
	bh=CAtlVtScE9UB6JfDdg4zOmuR9mrbQM8q8mYftJg3aa4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jcuWto4ft/z+tnZWfoybwUvsZG0kx8ZjDqiClB/90uiQr8PQJnXCiefYyk9VvTle7
	 NM9HfBUqCZllJg8COsiWCQzEkGNZpXRLpHN711p6ZNyBUMYNDWK9B0DvMPNZeTx6ae
	 Jblr7J6PoyLBATLKTETrqnTKlOQbly565YYbn1tg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mahesh Kumar G <mahe657@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Sourabh Jain <sourabhjain@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Subject: [PATCH 6.6 0383/1424] powerpc/crash: stop watchdogs before booting kdump kernel
Date: Sat, 12 Sep 2026 08:46:55 +0200
Message-ID: <20260912065615.868796550@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


