Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACFA24772B5;
	Sat, 12 Sep 2026 11:45:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213540; cv=none; b=b4CBR0f1hiWQKOp5AZ0alxNcl5M8WZc4TX9LW7P2L6gXFeOEodlz3CCwx24pkGtUetJdI9CrE8qChCLuW451PYketbeyRWdZvKckyUy20RjNHBZCX0wBFZIUN7yL5Z5imd9bDaojfnETXj8ULTQYoNKJEWRK3NVvqOFs9THWQNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213540; c=relaxed/simple;
	bh=8VE/38LIdBqEkNhx236RUs1dJo9EJx+ABvKnkIyFApo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UuTtDhrlL4Y59DGXgYzY5S4bZnYGIVm8F7QV+e/q6Oq+gTlFx+Mvc+NsgOrPkueAG2Dyiv3Y3WizsaJBOPPiJe7yNntSMkXhC/BijCnHICfkb1CIZ9mPpnS2Rs+EK9gCbswONv8eGi9gJZoQkzbx9vRh4Anxjtf9CmopkP0I/q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QM8ZPKtB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QM8ZPKtB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7FC11F000FF;
	Sat, 12 Sep 2026 11:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213535;
	bh=YK6jYK6rNiDjR/JtKr3M9C42qMtqocdq31vPZHR35nE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QM8ZPKtBrY2ObeR0+F4MuDdqE4rcXubD0uhCiUz1qXqXQWEqhdvFmXg1rKGtkOf3o
	 XQWqXw96pwqkiJONdcLjo4+CbcsyzCtxCCZI6yMf4XpphN9JIyAFYYI+4e75wpDo/3
	 LI7GAlUJoEOnD7qeecn6J3c9/i7vI7ayxzgLXKj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Sourabh Jain <sourabhjain@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Subject: [PATCH 6.12 0099/1376] powerpc/pseries: Move H_WATCHDOG definitions to a common header
Date: Sat, 12 Sep 2026 08:42:05 +0200
Message-ID: <20260912065609.765992809@linuxfoundation.org>
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

commit 516a254918453ec99660201263d01189c082332c upstream.

The H_WATCHDOG input and output definitions are currently local to the
pseries watchdog driver. The next patch in this series also needs these
definitions to issue H_WATCHDOG hypercalls outside the watchdog driver.

Move the H_WATCHDOG definitions to a new common header,
asm/papr-watchdog.h, so they can be shared without duplicating the
PAPR watchdog definitions.

No functional changes.

Cc: stable@vger.kernel.org
Suggested-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Signed-off-by: Sourabh Jain <sourabhjain@linux.ibm.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20260727053416.276317-2-sourabhjain@linux.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/include/asm/papr-watchdog.h |   58 +++++++++++++++++++++++++++++++
 drivers/watchdog/pseries-wdt.c           |   53 ----------------------------
 2 files changed, 59 insertions(+), 52 deletions(-)
 create mode 100644 arch/powerpc/include/asm/papr-watchdog.h

--- /dev/null
+++ b/arch/powerpc/include/asm/papr-watchdog.h
@@ -0,0 +1,58 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+
+#ifndef _ASM_POWERPC_PAPR_WATCHDOG_H
+#define _ASM_POWERPC_PAPR_WATCHDOG_H
+
+/*
+ * H_WATCHDOG Input
+ *
+ * R4: "flags":
+ *
+ *         Bits 48-55: "operation"
+ */
+#define PSERIES_WDTF_OP_START	0x100UL		/* start timer */
+#define PSERIES_WDTF_OP_STOP	0x200UL		/* stop timer */
+#define PSERIES_WDTF_OP_QUERY	0x300UL		/* query timer capabilities */
+
+/*
+ *         Bits 56-63: "timeoutAction" (for "Start Watchdog" only)
+ */
+#define PSERIES_WDTF_ACTION_HARD_POWEROFF	0x1UL	/* poweroff */
+#define PSERIES_WDTF_ACTION_HARD_RESTART	0x2UL	/* restart */
+#define PSERIES_WDTF_ACTION_DUMP_RESTART	0x3UL	/* dump + restart */
+
+/*
+ * H_WATCHDOG Output
+ *
+ * R3: Return code
+ *
+ *     H_SUCCESS    The operation completed.
+ *
+ *     H_BUSY	    The hypervisor is too busy; retry the operation.
+ *
+ *     H_PARAMETER  The given "flags" are somehow invalid.  Either the
+ *                  "operation" or "timeoutAction" is invalid, or a
+ *                  reserved bit is set.
+ *
+ *     H_P2         The given "watchdogNumber" is zero or exceeds the
+ *                  supported maximum value.
+ *
+ *     H_P3         The given "timeoutInMs" is below the supported
+ *                  minimum value.
+ *
+ *     H_NOOP       The given "watchdogNumber" is already stopped.
+ *
+ *     H_HARDWARE   The operation failed for ineffable reasons.
+ *
+ *     H_FUNCTION   The H_WATCHDOG hypercall is not supported by this
+ *                  hypervisor.
+ *
+ * R4:
+ *
+ * - For the "Query Watchdog Capabilities" operation, a 64-bit
+ *   structure:
+ */
+#define PSERIES_WDTQ_MIN_TIMEOUT(cap)	(((cap) >> 48) & 0xffff)
+#define PSERIES_WDTQ_MAX_NUMBER(cap)	(((cap) >> 32) & 0xffff)
+
+#endif /* _ASM_POWERPC_PAPR_WATCHDOG_H */
--- a/drivers/watchdog/pseries-wdt.c
+++ b/drivers/watchdog/pseries-wdt.c
@@ -13,61 +13,10 @@
 #include <linux/platform_device.h>
 #include <linux/time64.h>
 #include <linux/watchdog.h>
+#include <asm/papr-watchdog.h>
 
 #define DRV_NAME "pseries-wdt"
 
-/*
- * H_WATCHDOG Input
- *
- * R4: "flags":
- *
- *         Bits 48-55: "operation"
- */
-#define PSERIES_WDTF_OP_START	0x100UL		/* start timer */
-#define PSERIES_WDTF_OP_STOP	0x200UL		/* stop timer */
-#define PSERIES_WDTF_OP_QUERY	0x300UL		/* query timer capabilities */
-
-/*
- *         Bits 56-63: "timeoutAction" (for "Start Watchdog" only)
- */
-#define PSERIES_WDTF_ACTION_HARD_POWEROFF	0x1UL	/* poweroff */
-#define PSERIES_WDTF_ACTION_HARD_RESTART	0x2UL	/* restart */
-#define PSERIES_WDTF_ACTION_DUMP_RESTART	0x3UL	/* dump + restart */
-
-/*
- * H_WATCHDOG Output
- *
- * R3: Return code
- *
- *     H_SUCCESS    The operation completed.
- *
- *     H_BUSY	    The hypervisor is too busy; retry the operation.
- *
- *     H_PARAMETER  The given "flags" are somehow invalid.  Either the
- *                  "operation" or "timeoutAction" is invalid, or a
- *                  reserved bit is set.
- *
- *     H_P2         The given "watchdogNumber" is zero or exceeds the
- *                  supported maximum value.
- *
- *     H_P3         The given "timeoutInMs" is below the supported
- *                  minimum value.
- *
- *     H_NOOP       The given "watchdogNumber" is already stopped.
- *
- *     H_HARDWARE   The operation failed for ineffable reasons.
- *
- *     H_FUNCTION   The H_WATCHDOG hypercall is not supported by this
- *                  hypervisor.
- *
- * R4:
- *
- * - For the "Query Watchdog Capabilities" operation, a 64-bit
- *   structure:
- */
-#define PSERIES_WDTQ_MIN_TIMEOUT(cap)	(((cap) >> 48) & 0xffff)
-#define PSERIES_WDTQ_MAX_NUMBER(cap)	(((cap) >> 32) & 0xffff)
-
 static const unsigned long pseries_wdt_action[] = {
 	[0] = PSERIES_WDTF_ACTION_HARD_POWEROFF,
 	[1] = PSERIES_WDTF_ACTION_HARD_RESTART,


