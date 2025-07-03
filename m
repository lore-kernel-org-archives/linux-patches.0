Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 457802E7BD6;
	Thu,  3 Jul 2025 15:04:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751555087; cv=none; b=S+NOOxvF0FP93u/iIXNkyZ12OA0GSW+c6dKl4uPMp0c15l5OLXcfp/cdIrn7P353VF1nGhc2z+JA94E6NzsIIXj+rwMTMm5wcFd+Ip5EOvhnxliaDQXOXtHnoEWtdBl4CDqiBnHov/AraTt9CwJlHfmj2MgtRczNsJnnT8UqaLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751555087; c=relaxed/simple;
	bh=cQEuCi+If8WnwTF2N7v6kME3ku1WsomWvuwJKj8kIcs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NBocNVMTVCm/Q9Kbu1BSsCbipcmcTHra6XNdZtDv+PeOF10luRVisYwVsqMtiFvyWYr5UTeTd4IN+T4as3woG5d6PfYYg1pt4Eyu5Zh+sILEkTanp6Nhv1/uhTGAR35iN4HZNP4crlB61LUafKH6MBJ/+1/+8YUqOsAwtgRcOl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cFJJ6mMQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cFJJ6mMQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCF1BC4CEE3;
	Thu,  3 Jul 2025 15:04:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751555087;
	bh=cQEuCi+If8WnwTF2N7v6kME3ku1WsomWvuwJKj8kIcs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cFJJ6mMQn73byN8asiGLoXyXnUHkRMHx/9XAr1qRdbGL7k+3NEF+9OB3MQi/9tAUl
	 ckranR5Mmg7aFezOjUuDTSrGkYA/wQrBmiu8guaB+jlAYKfsFKD9hYrkgyp1z23CDu
	 0pjytSsTaPN+r4wMmcXgeUfLYongkfgDstlpy698=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sohil Mehta <sohil.mehta@intel.com>,
	"H. Peter Anvin (Intel)" <hpa@zytor.com>,
	"Xin Li (Intel)" <xin@zytor.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [PATCH 6.15 172/263] x86/traps: Initialize DR6 by writing its architectural reset value
Date: Thu,  3 Jul 2025 16:41:32 +0200
Message-ID: <20250703144011.248488608@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xin Li (Intel) <xin@zytor.com>

commit 5f465c148c61e876b6d6eacd8e8e365f2d47758f upstream.

Initialize DR6 by writing its architectural reset value to avoid
incorrectly zeroing DR6 to clear DR6.BLD at boot time, which leads
to a false bus lock detected warning.

The Intel SDM says:

  1) Certain debug exceptions may clear bits 0-3 of DR6.

  2) BLD induced #DB clears DR6.BLD and any other debug exception
     doesn't modify DR6.BLD.

  3) RTM induced #DB clears DR6.RTM and any other debug exception
     sets DR6.RTM.

  To avoid confusion in identifying debug exceptions, debug handlers
  should set DR6.BLD and DR6.RTM, and clear other DR6 bits before
  returning.

The DR6 architectural reset value 0xFFFF0FF0, already defined as
macro DR6_RESERVED, satisfies these requirements, so just use it to
reinitialize DR6 whenever needed.

Since clear_all_debug_regs() no longer zeros all debug registers,
rename it to initialize_debug_regs() to better reflect its current
behavior.

Since debug_read_clear_dr6() no longer clears DR6, rename it to
debug_read_reset_dr6() to better reflect its current behavior.

Fixes: ebb1064e7c2e9 ("x86/traps: Handle #DB for bus lock")
Reported-by: Sohil Mehta <sohil.mehta@intel.com>
Suggested-by: H. Peter Anvin (Intel) <hpa@zytor.com>
Signed-off-by: Xin Li (Intel) <xin@zytor.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: H. Peter Anvin (Intel) <hpa@zytor.com>
Reviewed-by: Sohil Mehta <sohil.mehta@intel.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: Sohil Mehta <sohil.mehta@intel.com>
Link: https://lore.kernel.org/lkml/06e68373-a92b-472e-8fd9-ba548119770c@intel.com/
Cc:stable@vger.kernel.org
Link: https://lore.kernel.org/all/20250620231504.2676902-2-xin%40zytor.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/uapi/asm/debugreg.h |   21 ++++++++++++++++++++-
 arch/x86/kernel/cpu/common.c         |   24 ++++++++++--------------
 arch/x86/kernel/traps.c              |   34 +++++++++++++++++++++-------------
 3 files changed, 51 insertions(+), 28 deletions(-)

--- a/arch/x86/include/uapi/asm/debugreg.h
+++ b/arch/x86/include/uapi/asm/debugreg.h
@@ -15,7 +15,26 @@
    which debugging register was responsible for the trap.  The other bits
    are either reserved or not of interest to us. */
 
-/* Define reserved bits in DR6 which are always set to 1 */
+/*
+ * Define bits in DR6 which are set to 1 by default.
+ *
+ * This is also the DR6 architectural value following Power-up, Reset or INIT.
+ *
+ * Note, with the introduction of Bus Lock Detection (BLD) and Restricted
+ * Transactional Memory (RTM), the DR6 register has been modified:
+ *
+ * 1) BLD flag (bit 11) is no longer reserved to 1 if the CPU supports
+ *    Bus Lock Detection.  The assertion of a bus lock could clear it.
+ *
+ * 2) RTM flag (bit 16) is no longer reserved to 1 if the CPU supports
+ *    restricted transactional memory.  #DB occurred inside an RTM region
+ *    could clear it.
+ *
+ * Apparently, DR6.BLD and DR6.RTM are active low bits.
+ *
+ * As a result, DR6_RESERVED is an incorrect name now, but it is kept for
+ * compatibility.
+ */
 #define DR6_RESERVED	(0xFFFF0FF0)
 
 #define DR_TRAP0	(0x1)		/* db0 */
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -2205,20 +2205,16 @@ EXPORT_PER_CPU_SYMBOL(__stack_chk_guard)
 #endif
 #endif
 
-/*
- * Clear all 6 debug registers:
- */
-static void clear_all_debug_regs(void)
+static void initialize_debug_regs(void)
 {
-	int i;
-
-	for (i = 0; i < 8; i++) {
-		/* Ignore db4, db5 */
-		if ((i == 4) || (i == 5))
-			continue;
-
-		set_debugreg(0, i);
-	}
+	/* Control register first -- to make sure everything is disabled. */
+	set_debugreg(0, 7);
+	set_debugreg(DR6_RESERVED, 6);
+	/* dr5 and dr4 don't exist */
+	set_debugreg(0, 3);
+	set_debugreg(0, 2);
+	set_debugreg(0, 1);
+	set_debugreg(0, 0);
 }
 
 #ifdef CONFIG_KGDB
@@ -2379,7 +2375,7 @@ void cpu_init(void)
 
 	load_mm_ldt(&init_mm);
 
-	clear_all_debug_regs();
+	initialize_debug_regs();
 	dbg_restore_debug_regs();
 
 	doublefault_init_cpu_tss();
--- a/arch/x86/kernel/traps.c
+++ b/arch/x86/kernel/traps.c
@@ -1021,24 +1021,32 @@ static bool is_sysenter_singlestep(struc
 #endif
 }
 
-static __always_inline unsigned long debug_read_clear_dr6(void)
+static __always_inline unsigned long debug_read_reset_dr6(void)
 {
 	unsigned long dr6;
 
+	get_debugreg(dr6, 6);
+	dr6 ^= DR6_RESERVED; /* Flip to positive polarity */
+
 	/*
 	 * The Intel SDM says:
 	 *
-	 *   Certain debug exceptions may clear bits 0-3. The remaining
-	 *   contents of the DR6 register are never cleared by the
-	 *   processor. To avoid confusion in identifying debug
-	 *   exceptions, debug handlers should clear the register before
-	 *   returning to the interrupted task.
+	 *   Certain debug exceptions may clear bits 0-3 of DR6.
+	 *
+	 *   BLD induced #DB clears DR6.BLD and any other debug
+	 *   exception doesn't modify DR6.BLD.
 	 *
-	 * Keep it simple: clear DR6 immediately.
+	 *   RTM induced #DB clears DR6.RTM and any other debug
+	 *   exception sets DR6.RTM.
+	 *
+	 *   To avoid confusion in identifying debug exceptions,
+	 *   debug handlers should set DR6.BLD and DR6.RTM, and
+	 *   clear other DR6 bits before returning.
+	 *
+	 * Keep it simple: write DR6 with its architectural reset
+	 * value 0xFFFF0FF0, defined as DR6_RESERVED, immediately.
 	 */
-	get_debugreg(dr6, 6);
 	set_debugreg(DR6_RESERVED, 6);
-	dr6 ^= DR6_RESERVED; /* Flip to positive polarity */
 
 	return dr6;
 }
@@ -1238,13 +1246,13 @@ out:
 /* IST stack entry */
 DEFINE_IDTENTRY_DEBUG(exc_debug)
 {
-	exc_debug_kernel(regs, debug_read_clear_dr6());
+	exc_debug_kernel(regs, debug_read_reset_dr6());
 }
 
 /* User entry, runs on regular task stack */
 DEFINE_IDTENTRY_DEBUG_USER(exc_debug)
 {
-	exc_debug_user(regs, debug_read_clear_dr6());
+	exc_debug_user(regs, debug_read_reset_dr6());
 }
 
 #ifdef CONFIG_X86_FRED
@@ -1263,7 +1271,7 @@ DEFINE_FREDENTRY_DEBUG(exc_debug)
 {
 	/*
 	 * FRED #DB stores DR6 on the stack in the format which
-	 * debug_read_clear_dr6() returns for the IDT entry points.
+	 * debug_read_reset_dr6() returns for the IDT entry points.
 	 */
 	unsigned long dr6 = fred_event_data(regs);
 
@@ -1278,7 +1286,7 @@ DEFINE_FREDENTRY_DEBUG(exc_debug)
 /* 32 bit does not have separate entry points. */
 DEFINE_IDTENTRY_RAW(exc_debug)
 {
-	unsigned long dr6 = debug_read_clear_dr6();
+	unsigned long dr6 = debug_read_reset_dr6();
 
 	if (user_mode(regs))
 		exc_debug_user(regs, dr6);


