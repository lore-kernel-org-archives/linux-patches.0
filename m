Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 244451E98E3;
	Sun,  7 Jun 2026 10:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827056; cv=none; b=JxIPxQbxT74i49ZsnFKRxq5OITaJFsWCY+2rE2XHnPYMo+rAnXyu3zraU2NMdCHlPTO0CiSRW7/CcHoRbrqUIF2MuIyjnZGb92crT+AdLuHNWWprbBno5n/Fz//6qRLVK+8p63dfl26qSc3w3COgrB2GhJBN0rmNxmlcV5mGaZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827056; c=relaxed/simple;
	bh=zN5ab4z29SielyLSOOiATkl+6GUA0ThmWS0K4RG4v4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ooITE3HZvN99Hi5laA1aSj1ueH3+5SVXZfps6a5Hq9a+ILg2EV/Z0ZvI92PFNHYcbtACLKGiFjOcDDOVs0kaopSyzVaVHY0XG1G//IYA3FkryXhOnsvoq3cqsxKWIdCGF6dYY597fwARIPND+RlSlo0S4K64CqXG0tfa7Dy6npw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eFFLTZoo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eFFLTZoo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3218A1F00893;
	Sun,  7 Jun 2026 10:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827054;
	bh=V+92NPoZxn7MCK30YIw3+0a1QMWijYOWhjZsuPEo0oY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eFFLTZoojESQaNkYC6B9O/gcJ+vvvR7UZ2ffbovvzK0VUKyaDUrMLeV6qAt2uri3M
	 bhcC6hZgNMrXzMGTWhGTATsF/76Fx4qQvmIBO3o93Xd88rCpbYT5Bki1BHmE/pvX6S
	 BFdHxCVUz+8INerXi7zO/w7KvqaD38xbwfVyoILg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ada Couprie Diaz <ada.coupriediaz@arm.com>,
	"Luis Claudio R. Goncalves" <lgoncalv@redhat.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Will Deacon <will@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 018/307] arm64: debug: refactor reinstall_suspended_bps()
Date: Sun,  7 Jun 2026 11:56:55 +0200
Message-ID: <20260607095728.293000057@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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

From: Ada Couprie Diaz <ada.coupriediaz@arm.com>

[ Upstream commit 80691d35523de3292b64c2ffa444aab3d55e51ba ]

`reinstall_suspended_bps()` plays a key part in the stepping process
when we have hardware breakpoints and watchpoints enabled.
It checks if we need to step one, will re-enable it if it has
been handled and will return whether or not we need to proceed with
a single-step.

However, the current naming and return values make it harder to understand
the logic and goal of the function.

Rename it `try_step_suspended_breakpoints()` and change the return value
to a boolean, aligning it with similar functions used in
`do_el0_undef()` like `try_emulate_mrs()`, and making its behaviour
more obvious.

Signed-off-by: Ada Couprie Diaz <ada.coupriediaz@arm.com>
Tested-by: Luis Claudio R. Goncalves <lgoncalv@redhat.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Reviewed-by: Will Deacon <will@kernel.org>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Link: https://lore.kernel.org/r/20250707114109.35672-9-ada.coupriediaz@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Reviewed-by: Ada Couprie Diaz <ada.coupriediaz@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/debug-monitors.h |  6 +++---
 arch/arm64/kernel/debug-monitors.c      |  2 +-
 arch/arm64/kernel/hw_breakpoint.c       | 25 ++++++++++++-------------
 3 files changed, 16 insertions(+), 17 deletions(-)

diff --git a/arch/arm64/include/asm/debug-monitors.h b/arch/arm64/include/asm/debug-monitors.h
index 5319da0f0ca4ea..24c7981abeb0b9 100644
--- a/arch/arm64/include/asm/debug-monitors.h
+++ b/arch/arm64/include/asm/debug-monitors.h
@@ -83,11 +83,11 @@ int kernel_active_single_step(void);
 void kernel_rewind_single_step(struct pt_regs *regs);
 
 #ifdef CONFIG_HAVE_HW_BREAKPOINT
-int reinstall_suspended_bps(struct pt_regs *regs);
+bool try_step_suspended_breakpoints(struct pt_regs *regs);
 #else
-static inline int reinstall_suspended_bps(struct pt_regs *regs)
+static inline bool try_step_suspended_breakpoints(struct pt_regs *regs)
 {
-	return -ENODEV;
+	return false;
 }
 #endif
 
diff --git a/arch/arm64/kernel/debug-monitors.c b/arch/arm64/kernel/debug-monitors.c
index a28482e25c4c31..b95a135ef10a99 100644
--- a/arch/arm64/kernel/debug-monitors.c
+++ b/arch/arm64/kernel/debug-monitors.c
@@ -195,7 +195,7 @@ static int single_step_handler(unsigned long unused, unsigned long esr,
 	 * If we are stepping a pending breakpoint, call the hw_breakpoint
 	 * handler first.
 	 */
-	if (!reinstall_suspended_bps(regs))
+	if (try_step_suspended_breakpoints(regs))
 		return 0;
 
 	if (call_step_hook(regs, esr) == DBG_HOOK_HANDLED)
diff --git a/arch/arm64/kernel/hw_breakpoint.c b/arch/arm64/kernel/hw_breakpoint.c
index d7eede5d869c2b..309ae24d454805 100644
--- a/arch/arm64/kernel/hw_breakpoint.c
+++ b/arch/arm64/kernel/hw_breakpoint.c
@@ -847,36 +847,35 @@ NOKPROBE_SYMBOL(watchpoint_handler);
 /*
  * Handle single-step exception.
  */
-int reinstall_suspended_bps(struct pt_regs *regs)
+bool try_step_suspended_breakpoints(struct pt_regs *regs)
 {
 	struct debug_info *debug_info = &current->thread.debug;
-	int handled_exception = 0, *kernel_step;
-
-	kernel_step = this_cpu_ptr(&stepping_kernel_bp);
+	int *kernel_step = this_cpu_ptr(&stepping_kernel_bp);
+	bool handled_exception = false;
 
 	/*
 	 * Called from single-step exception handler.
-	 * Return 0 if execution can resume, 1 if a SIGTRAP should be
-	 * reported.
+	 * Return true if we stepped a breakpoint and can resume execution,
+	 * false if we need to handle a single-step.
 	 */
 	if (user_mode(regs)) {
 		if (debug_info->bps_disabled) {
 			debug_info->bps_disabled = 0;
 			toggle_bp_registers(AARCH64_DBG_REG_BCR, DBG_ACTIVE_EL0, 1);
-			handled_exception = 1;
+			handled_exception = true;
 		}
 
 		if (debug_info->wps_disabled) {
 			debug_info->wps_disabled = 0;
 			toggle_bp_registers(AARCH64_DBG_REG_WCR, DBG_ACTIVE_EL0, 1);
-			handled_exception = 1;
+			handled_exception = true;
 		}
 
 		if (handled_exception) {
 			if (debug_info->suspended_step) {
 				debug_info->suspended_step = 0;
 				/* Allow exception handling to fall-through. */
-				handled_exception = 0;
+				handled_exception = false;
 			} else {
 				user_disable_single_step(current);
 			}
@@ -890,17 +889,17 @@ int reinstall_suspended_bps(struct pt_regs *regs)
 
 		if (*kernel_step != ARM_KERNEL_STEP_SUSPEND) {
 			kernel_disable_single_step();
-			handled_exception = 1;
+			handled_exception = true;
 		} else {
-			handled_exception = 0;
+			handled_exception = false;
 		}
 
 		*kernel_step = ARM_KERNEL_STEP_NONE;
 	}
 
-	return !handled_exception;
+	return handled_exception;
 }
-NOKPROBE_SYMBOL(reinstall_suspended_bps);
+NOKPROBE_SYMBOL(try_step_suspended_breakpoints);
 
 /*
  * Context-switcher for restoring suspended breakpoints.
-- 
2.53.0



