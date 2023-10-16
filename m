Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0D501A27D
	for <patches@lists.linux.dev>; Mon, 16 Oct 2023 08:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jSNn7fbE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E28F3C433C8;
	Mon, 16 Oct 2023 08:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697446246;
	bh=BheVWXfkIQULV4XL1wRKyjNV+reOSuYFRshnIYf5wdA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jSNn7fbE0rcnsAZN0i017ToaRJDtrsal0nYBm6mY1ISE3FE2/47RbOmBhRdu6ZZFo
	 g4Gw9Yja795QnQZvXwkhGt+zlQWAAFkt5DDatsz9BOughUqZe+Xg72s9wrD/of27Qe
	 W5i6mOmKjJbGKOq71HKoOybjMGUfnwJ9OZyO82rk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ruanjinjie@huawei.com,
	Mark Rutland <mark.rutland@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	James Morse <james.morse@arm.com>,
	Joey Gouly <joey.gouly@arm.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 5.15 097/102] arm64: armv8_deprecated: move aarch32 helper earlier
Date: Mon, 16 Oct 2023 10:41:36 +0200
Message-ID: <20231016083956.283536871@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231016083953.689300946@linuxfoundation.org>
References: <20231016083953.689300946@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Rutland <mark.rutland@arm.com>

commit 0c5f416219da3795dc8b33e5bb7865a6b3c4e55c upstream.

Subsequent patches will rework the logic in armv8_deprecated.c.

In preparation for subsequent changes, this patch moves some shared logic
earlier in the file. This will make subsequent diffs simpler and easier to
read.

At the same time, drop the `__kprobes` annotation from
aarch32_check_condition(), as this is only used for traps from compat
userspace, and has no risk of recursion within kprobes. As this is the
last kprobes annotation in armve8_deprecated.c, we no longer need to
include <asm/kprobes.h>.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: James Morse <james.morse@arm.com>
Cc: Joey Gouly <joey.gouly@arm.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20221019144123.612388-9-mark.rutland@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/armv8_deprecated.c |   39 +++++++++++++++++------------------
 1 file changed, 19 insertions(+), 20 deletions(-)

--- a/arch/arm64/kernel/armv8_deprecated.c
+++ b/arch/arm64/kernel/armv8_deprecated.c
@@ -17,7 +17,6 @@
 #include <asm/sysreg.h>
 #include <asm/system_misc.h>
 #include <asm/traps.h>
-#include <asm/kprobes.h>
 
 #define CREATE_TRACE_POINTS
 #include "trace-events-emulation.h"
@@ -52,6 +51,25 @@ struct insn_emulation {
 	int max;
 };
 
+#define ARM_OPCODE_CONDTEST_FAIL   0
+#define ARM_OPCODE_CONDTEST_PASS   1
+#define ARM_OPCODE_CONDTEST_UNCOND 2
+
+#define	ARM_OPCODE_CONDITION_UNCOND	0xf
+
+static unsigned int aarch32_check_condition(u32 opcode, u32 psr)
+{
+	u32 cc_bits  = opcode >> 28;
+
+	if (cc_bits != ARM_OPCODE_CONDITION_UNCOND) {
+		if ((*aarch32_opcode_cond_checks[cc_bits])(psr))
+			return ARM_OPCODE_CONDTEST_PASS;
+		else
+			return ARM_OPCODE_CONDTEST_FAIL;
+	}
+	return ARM_OPCODE_CONDTEST_UNCOND;
+}
+
 /*
  *  Implement emulation of the SWP/SWPB instructions using load-exclusive and
  *  store-exclusive.
@@ -138,25 +156,6 @@ static int emulate_swpX(unsigned int add
 	return res;
 }
 
-#define ARM_OPCODE_CONDTEST_FAIL   0
-#define ARM_OPCODE_CONDTEST_PASS   1
-#define ARM_OPCODE_CONDTEST_UNCOND 2
-
-#define	ARM_OPCODE_CONDITION_UNCOND	0xf
-
-static unsigned int __kprobes aarch32_check_condition(u32 opcode, u32 psr)
-{
-	u32 cc_bits  = opcode >> 28;
-
-	if (cc_bits != ARM_OPCODE_CONDITION_UNCOND) {
-		if ((*aarch32_opcode_cond_checks[cc_bits])(psr))
-			return ARM_OPCODE_CONDTEST_PASS;
-		else
-			return ARM_OPCODE_CONDTEST_FAIL;
-	}
-	return ARM_OPCODE_CONDTEST_UNCOND;
-}
-
 /*
  * swp_handler logs the id of calling process, dissects the instruction, sanity
  * checks the memory location, calls emulate_swpX for the actual operation and


