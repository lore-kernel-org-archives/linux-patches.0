Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F078303CAE;
	Sun,  7 Jun 2026 10:13:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827221; cv=none; b=odQ3PcXMIPeF5vaqDCGMQjlptqMTwDiWxDr7zjLO9cKkXSBbdlH863EXXfh5NMpFlx0Poeb4a4rNfK9efbgOxcztxkYhD0fV//kGflbA94E6klgbhQ4cIjDS/TVHlWbA8F7WEKagfZP7IT1Ox16vXACjIrCiYHmDW3Kv5aaxGfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827221; c=relaxed/simple;
	bh=i2FTJbf18I4WUmSCrLpaRmxCMHJIfoUBZVs6ARb6fZ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tER9HJXr96gdkHq0bqNqFHZNtebBk/XF6+xtKoRe7jf8I8CFN1eKvTEY0N+4Q7Kv/mhhPcgeG//RCT6+zJwaqPQ2RqsrbyUwbS14JaPi/o3EMLTIz2F399WRg0D/D9FEzOtruxyrAkc/UZlINAA8i1v/NE6w14Ez6RkxvzauoDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uxSyKPUK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uxSyKPUK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D31681F00893;
	Sun,  7 Jun 2026 10:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827220;
	bh=j4dw0SxvKO6TsL/1zex1B7PAiGVAtUAzoOFQ0jfDadc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uxSyKPUKTusvuVpz4F1e5G3Hpx8Qm8mDsOcbeOKtDClMjnhpfIxdaIVpR0BPQrUmJ
	 M1PoQuQB47II1dJTqY4z83GShdHT2KOJMOKrhlPwtcdcrXE8Y+UxQS2m33+UHsAogf
	 1UNFNBzX8gMgNe/AD1aKVsO+se7VOuZaUbYnqygM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ada Couprie Diaz <ada.coupriediaz@arm.com>,
	"Luis Claudio R. Goncalves" <lgoncalv@redhat.com>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Will Deacon <will@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 012/307] arm64: refactor aarch32_break_handler()
Date: Sun,  7 Jun 2026 11:56:49 +0200
Message-ID: <20260607095728.082062843@linuxfoundation.org>
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

[ Upstream commit b1e2d95524e4d0f5b643394c739212869e95cf6a ]

`aarch32_break_handler()` is called in `do_el0_undef()` when we
are trying to handle an exception whose Exception Syndrome is unknown.
It checks if the instruction hit might be a 32-bit arm break (be it
A32 or T2), and sends a SIGTRAP to userspace if it is so that it can
be handled.

However, this is badly represented in the naming of the function, and
is not consistent with the other functions called with the same logic
in `do_el0_undef()`.

Rename it `try_handle_aarch32_break()` and change the return value to
a boolean to align with the logic of the other tentative handlers in
`do_el0_undef()`, the previous error code being ignored anyway.

Signed-off-by: Ada Couprie Diaz <ada.coupriediaz@arm.com>
Tested-by: Luis Claudio R. Goncalves <lgoncalv@redhat.com>
Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
Acked-by: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Will Deacon <will@kernel.org>
Link: https://lore.kernel.org/r/20250707114109.35672-3-ada.coupriediaz@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Reviewed-by: Ada Couprie Diaz <ada.coupriediaz@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/debug-monitors.h |  2 +-
 arch/arm64/kernel/debug-monitors.c      | 10 +++++-----
 arch/arm64/kernel/traps.c               |  2 +-
 3 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/include/asm/debug-monitors.h b/arch/arm64/include/asm/debug-monitors.h
index 13d437bcbf58c2..3eeea1c9f06664 100644
--- a/arch/arm64/include/asm/debug-monitors.h
+++ b/arch/arm64/include/asm/debug-monitors.h
@@ -115,7 +115,7 @@ static inline int reinstall_suspended_bps(struct pt_regs *regs)
 }
 #endif
 
-int aarch32_break_handler(struct pt_regs *regs);
+bool try_handle_aarch32_break(struct pt_regs *regs);
 
 void debug_traps_init(void);
 
diff --git a/arch/arm64/kernel/debug-monitors.c b/arch/arm64/kernel/debug-monitors.c
index b7a2155bca42b1..8275b7f5754626 100644
--- a/arch/arm64/kernel/debug-monitors.c
+++ b/arch/arm64/kernel/debug-monitors.c
@@ -335,7 +335,7 @@ static int brk_handler(unsigned long unused, unsigned long esr,
 }
 NOKPROBE_SYMBOL(brk_handler);
 
-int aarch32_break_handler(struct pt_regs *regs)
+bool try_handle_aarch32_break(struct pt_regs *regs)
 {
 	u32 arm_instr;
 	u16 thumb_instr;
@@ -343,7 +343,7 @@ int aarch32_break_handler(struct pt_regs *regs)
 	void __user *pc = (void __user *)instruction_pointer(regs);
 
 	if (!compat_user_mode(regs))
-		return -EFAULT;
+		return false;
 
 	if (compat_thumb_mode(regs)) {
 		/* get 16-bit Thumb instruction */
@@ -367,12 +367,12 @@ int aarch32_break_handler(struct pt_regs *regs)
 	}
 
 	if (!bp)
-		return -EFAULT;
+		return false;
 
 	send_user_sigtrap(TRAP_BRKPT);
-	return 0;
+	return true;
 }
-NOKPROBE_SYMBOL(aarch32_break_handler);
+NOKPROBE_SYMBOL(try_handle_aarch32_break);
 
 void __init debug_traps_init(void)
 {
diff --git a/arch/arm64/kernel/traps.c b/arch/arm64/kernel/traps.c
index 5e138cf5d4ade3..c38ebf715be764 100644
--- a/arch/arm64/kernel/traps.c
+++ b/arch/arm64/kernel/traps.c
@@ -462,7 +462,7 @@ void do_el0_undef(struct pt_regs *regs, unsigned long esr)
 	u32 insn;
 
 	/* check for AArch32 breakpoint instructions */
-	if (!aarch32_break_handler(regs))
+	if (try_handle_aarch32_break(regs))
 		return;
 
 	if (user_insn_read(regs, &insn))
-- 
2.53.0



